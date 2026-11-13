# Debug bridge, parser cache, logger

Wiring `Wind.installDebugResolver()` and `Wind.installPerfResolver()` for E2E tooling (tapir), understanding the parser cache (and why tests need `WindParser.clearCache()`), and reading `WindLogger` output for performance / composition debugging.

## Contents

1. [Wind.installDebugResolver()](#1-windinstalldebugresolver)
2. [What the resolver exposes](#2-what-the-resolver-exposes)
3. [WindDebugRegistry contract](#3-winddebugregistry-contract)
4. [The parser cache + WindParser.clearCache()](#4-the-parser-cache--windparserclearcache)
5. [WindLogger and the `debug` token](#5-windlogger-and-the-debug-token)
6. [Tree-shake guarantees](#6-tree-shake-guarantees)
7. [Diagnostics in tests](#7-diagnostics-in-tests)
8. [Aggregate counters (`WindPerfCounters`)](#8-aggregate-counters-windperfcounters)

---

## 1. Wind.installDebugResolver()

```dart
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:wind_kit/wind_kit.dart';

void main() {
  if (!kReleaseMode) {
    Wind.installDebugResolver();
  }
  runApp(const MyApp());
}
```

- Idempotent: safe to call multiple times; second call is a no-op.
- Gate the call with `!kReleaseMode` as well. The function itself returns immediately in a release build (`!kReleaseMode`, not `kDebugMode`, so a profile build still registers for a profiling session), and the gate lets the call tree-shake.
- Registers a `WindDebugResolverImpl` instance into the static `WindDebugRegistry`.
- Once registered, any consumer of `wind_kit_diagnostics_contracts` (tapir, a custom inspector) can read live Wind state per widget without importing `wind_kit`.


---

## 2. What the resolver exposes

For each W-prefix widget with a non-empty `className`, the resolver returns a `Map<String, Object?>` with the fields below (`bgColor` and `textColor` are present only when non-null):

| Field | Type | Source |
|---|---|---|
| `className` | `String` | The raw className passed to the widget |
| `breakpoint` | `String` | Active breakpoint at render time: `'base'`, or a key of `theme.screens` (`'sm'`, `'md'`, `'lg'`, `'xl'`, `'2xl'` by default; a custom `screens` map changes them) |
| `brightness` | `String` | `'light'` or `'dark'` |
| `platform` | `String` | `'web'`, `'ios'`, `'android'`, `'macos'`, `'windows'`, `'linux'`, or `'unknown'` |
| `states` | `List<String>` | Active states (e.g. `['hover', 'focus']`) |
| `bgColor` | `String?` | Resolved background colour as uppercase hex RGB (`#3B82F6`); present only when non-null |
| `textColor` | `String?` | Resolved text colour as uppercase hex RGB; present only when non-null |

Non-Wind elements (a Material `Container`, a `ListTile`) return an empty map. So do W-widgets that have no `className` field (`WAnchor`, `WBreakpoint`, `WindAnimationWrapper`, `WKeyboardActions`): the resolver skips them safely instead of throwing, so a bare `WAnchor` in the tree never aborts a tapir snapshot. The resolver walks `Element` (which is a `BuildContext`) and parses the className through `WindParser.parse(className, element)`.

---

## 3. WindDebugRegistry contract

Lives in `wind_kit_diagnostics_contracts` (zero-dependency package; depends only on `flutter` and `meta`).

```dart
abstract class WindDebugResolver {
  Map<String, Object?> resolve(Element element);
}

abstract class WindPerfResolver {
  Map<String, Object?> stats();
}

class WindDebugRegistry {
  static WindDebugResolver? get current;
  static WindPerfResolver? get currentPerf;
  static void register(WindDebugResolver resolver);      // replaces the previous resolver
  static void registerPerf(WindPerfResolver resolver);   // replaces the previous perf resolver
  static void resetForTesting();                         // @visibleForTesting
  static void registerForTesting(WindDebugResolver r);   // @visibleForTesting
  static void registerPerfForTesting(WindPerfResolver r); // @visibleForTesting
}
```

External tooling reads:
```dart
final fields = WindDebugRegistry.current?.resolve(element) ?? const {};
```

Consumers do not import Wind. They import only the contracts package. When Wind is installed and `Wind.installDebugResolver()` ran, `current` is set. Otherwise it's `null` and tooling gracefully skips the Wind enrichment.

---

## 4. The parser cache + `WindParser.clearCache()`

The parser caches every resolved `WindStyle` keyed by:

```
expandedClassName + activeBreakpoint + brightness + platform + sorted(activeStates).join(',')
```

`expandedClassName` is the className after `WindThemeData.aliases` expansion. A call that passes a `baseStyle` skips the cache entirely.

Once warm, nearly every parse is a cache hit. The same className renders the same `WindStyle` regardless of how many times it's used. The cache survives hot reload (className edits during hot reload pick up the new value on the next frame because the key changes).

**Test discipline.** The cache is a global static `Map<String, WindStyle>`. It persists between tests within the same process. A test that primes the cache with a specific theme can produce false-positive PASSes in a sibling test that uses a different theme.

Mandatory `setUp()` for parser tests and widget tests that pump Wind widgets:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:wind_kit/wind_kit.dart';

void main() {
  setUp(() {
    WindParser.clearCache();
  });

  testWidgets('button renders blue', (tester) async {
    // ...
  });
}
```

Skipping this is the single largest source of false-positive Wind tests. The cache key includes brightness, so a dark-mode test polluting the cache will not directly fail a light-mode test, but theme customisations (custom colours) cross-pollute. Clear unconditionally.

When `WindParser.parse` is called with a non-null `baseStyle`, the cache is bypassed in both directions (no read, no write). The result is per-call and would otherwise either return a stale entry computed against a different `baseStyle` or poison the cache slot for default-flag callers.

---

## 5. WindLogger and the `debug` token

The `debug` token in any className activates per-build logging via `debugPrint`.

```dart
WDiv(
  className: 'debug flex flex-col gap-4 p-6 bg-white dark:bg-gray-800',
  child: ...,
);
```

Output (shape; the wrapper list and the style fields depend on the className):
```
--- [WIND DEBUG] START: WDiv ---
--- [WIND DEBUG] Composition Tree: ---
DecoratedBox(
  ...,
  child:
  Padding(
    ...,
    child:
    Column(...),
  )
)
--- [WIND DEBUG] Final Styles: WindStyle(...) ---
--- [WIND DEBUG] Build Time: 142µs ---
--- [WIND DEBUG] END: WDiv ---
```

What it shows:
1. **Composition tree**: pseudo-Dart pseudo-code of the widget hierarchy Wind constructs (DecoratedBox → Padding → Column / Row / etc.).
2. **Final WindStyle**: the immutable value object after all parsers have run.
3. **Build time**: microseconds from className-receive to widget-return.

The `debug` token does not draw visual borders or wireframes. For visual debugging, reach for Flutter's `debugPaintSizeEnabled = true` (set in `main()` inside `kDebugMode`).

Remove the `debug` token before production. It runs `debugPrint` on every build of every widget that has it; the cost is visible in DevTools.

---

## 6. Tree-shake guarantees

wind_kit's debug machinery is gated at two levels:

- `Wind.installDebugResolver()` exits early when `kReleaseMode`. Dart's constant propagation eliminates the entire `WindDebugRegistry.register(...)` call in release AOT.
- `WindLogger` is internal (it is not exported from the barrel). Its methods check the `debug` token's flag before doing anything and have no `kReleaseMode` check of their own.

Release builds (dart2js for web, dart2native for desktop and mobile AOT) eliminate:
- The `WindDebugResolverImpl` class (only referenced from behind the `!kReleaseMode` gate in `Wind.installDebugResolver`).
- The `WindDebugRegistry` registration.

The `debug` token is not stripped from release builds: it parses into `WindStyle.debug = true` and `WindLogger` prints through `debugPrint` for every build of a widget that carries it. `debugPrint` still writes to the console of a release build, so a shipped `debug` token is noise at best, and costs time on every build. Remove it before production.

---

## 7. Diagnostics in tests

Wind ships no built-in widget matchers or test helpers; use standard `flutter_test` patterns.

Standard test scaffolding for a className-styled widget:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:wind_kit/wind_kit.dart';

Widget wrapWithTheme(Widget child, {WindThemeData? data}) {
  return WindTheme(
    data: data ?? WindThemeData(),
    builder: (context, controller) => MaterialApp(
      theme: controller.toThemeData(),
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  setUp(() {
    WindParser.clearCache();
  });

  testWidgets('button styled with bg-blue-500', (tester) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    bool tapped = false;
    await tester.pumpWidget(wrapWithTheme(
      WButton(
        onTap: () => tapped = true,
        className: 'bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded-lg',
        child: const Text('Click me'),
      ),
    ));

    await tester.tap(find.text('Click me'));
    await tester.pumpAndSettle();

    expect(tapped, isTrue);
  });
}
```

Discipline:
- `WindParser.clearCache()` in `setUp()` (non-negotiable).
- `wrapWithTheme` helper duplicated per test file (intentional; avoids cross-file coupling).
- Size the viewport explicitly when testing responsive layouts; default 800×600 collapses multi-column layouts and may not match the breakpoint you expect.
- `addTearDown(...)` for `FocusNode` / `TextEditingController` / `AnimationController` disposal.
- Assert behavioural outputs (`find.text`, `find.byType(WDiv)`, callback flags), not internal `WindStyle` fields.

For testing dark mode, pass `WindThemeData(brightness: Brightness.dark, syncWithSystem: false)` to `wrapWithTheme`. For testing breakpoints, set the viewport size to bracket each breakpoint.

For E2E testing inside a running app (tapir), `Wind.installDebugResolver()` exposes the per-widget snapshot from section 2; consumers read via `WindDebugRegistry.current?.resolve(element)` without needing Wind as a direct dep.

## 8. Aggregate counters (`WindPerfCounters`)

A per-`Element` resolver has nowhere to put a number that belongs to no element, so the counters get a second contract and a second registry slot.

`WindPerfCounters.enabled` is `false` by default and every increment sits behind it, so a disabled counter is one static bool load. The parse path has three outcomes, not two:

- **hit**: no `baseStyle`, key present.
- **miss**: no `baseStyle`, key absent, parses and caches.
- **bypass**: a `baseStyle` was supplied, so it parses on every rebuild and never caches.

A bypass is a property of a caller writing `style:`, not of using `WDiv` / `WText`: both pass `baseStyle: style` and that property is null in ordinary use. In a measured real app, bypasses were zero and the hit rate was above 99%.

`WindParser.clearCache()` resets the counters too, so a host that clears the cache after a theme change mid-measurement zeroes them. `toggleTheme()` alone does not clear the cache, so the counters continue across it. `WindPerfCounters.reset()` is public and zeroes them without touching the cache.

`Wind.installPerfResolver()` publishes a map through `WindDebugRegistry.currentPerf?.stats()`: the `int` values `cacheHits`, `cacheMisses`, `cacheBypasses`, `cacheSize`, `wDivBuilds` and `wTextBuilds`, plus these `Map<String, int>` counters: `widgetBuilds` (every W-widget with a build method, by type name: `'WButton'`, `'WDiv'`, ...), `wrapperEmissions` (the Flutter or Wind-authored render-layer wrapper widget inserted at each composition-pipeline branch: `'DecoratedBox'`, `'ConstrainedBox'`, `'Padding'`, `'MouseRegion'`, `'Semantics'`, `'DefaultTextStyle'`, ...), `inheritedReads` (fixed to `mediaQuerySize`, `mediaQueryBrightness`, `windTheme`, `defaultTextStyle`). A `null` there means no resolver was installed, which is deliberately distinguishable from "the counters are zero". Both `installDebugResolver()` and `installPerfResolver()` gate on `!kReleaseMode`, not `kDebugMode`, so a profile build still carries them.
