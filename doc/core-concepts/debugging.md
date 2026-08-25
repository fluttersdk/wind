# Debugging

- [Introduction](#introduction)
- [Enabling Debug Mode](#enabling-debug-mode)
- [Understanding the Output](#understanding-the-output)
    - [Composition Tree](#composition-tree)
    - [Final Styles](#final-styles)
    - [Build Time](#build-time)
- [How WindLogger Works](#how-windlogger-works)
- [Quick Reference](#quick-reference)
- [Common Scenarios](#common-scenarios)
- [Unknown className Warnings](#unknown-classname-warnings)
- [External Tooling Integration](#external-tooling-integration)
- [Aggregate Performance Counters](#aggregate-performance-counters)

<a name="introduction"></a>
## Introduction

Wind includes a specialized debugging system designed to peel back the abstraction of the utility-first engine. Since Wind translates a single `className` string into a complex hierarchy of Flutter widgets, the debugging tools allow you to verify the exact widget composition, resolved styles, and build performance.

The system is built directly into the core engine, requiring no external configuration or devtools extensions to inspect the "parsing → styling → building" pipeline.

<x-preview path="core-concepts/debugging_basic" size="md" source="example/lib/pages/core-concepts/debugging_basic.dart"></x-preview>

```dart
WDiv(
  className: 'debug flex p-4 bg-blue-500 rounded-lg',
  child: WText('Debugging active'),
)
```

<a name="enabling-debug-mode"></a>
## Enabling Debug Mode

To enable debugging for a specific widget, add the `debug` utility class to its `className` string. This approach allows for targeted inspection without flooding the console with logs from unrelated widgets.

```dart
// Enabling debug for a button
WButton(
  className: 'debug bg-red-500 hover:bg-red-600 px-4 py-2 rounded',
  onTap: () => print('Action'),
  child: WText('Delete'),
)
```

When the `WindParser` encounters the `debug` class, it triggers a detailed report to the console during the widget's build phase.

> [!NOTE]
> Debug mode is scoped to the specific widget instance. It does not affect parent or child widgets unless they also include the `debug` class.

<a name="understanding-the-output"></a>
## Understanding the Output

The debug report is divided into three primary sections that represent the lifecycle of a Wind widget.

<a name="composition-tree"></a>
### Composition Tree

The Composition Tree visualizes the "Atomic Widget" stack. Because Wind often wraps your content in multiple Flutter widgets (such as `Padding`, `DecoratedBox`, or `ConstrainedBox`) to satisfy the `className` requirements, this tree shows the final structure.

```text
--- [WIND DEBUG] Composition Tree: ---
Padding(
  padding: EdgeInsets.all(16.0),
  child: 
  DecoratedBox(
    decoration: BoxDecoration(
      color: Color(0xFF3B82F6),
      borderRadius: BorderRadius.circular(8.0)
    ),
    child: ...
  )
)
```

<a name="final-styles"></a>
### Final Styles

This section displays the fully resolved `WindStyle` object. This is the final state after all utility classes, responsive modifiers (e.g., `md:`), and state variants (e.g., `hover:`) have been merged.

```text
--- [WIND DEBUG] Final Styles: WindStyle(
  padding: EdgeInsets.all(16.0),
  backgroundColor: Color(0xFF3B82F6),
  borderRadius: BorderRadius.circular(8.0),
  isFlex: true,
) ---
```

<a name="build-time"></a>
### Build Time

Wind measures the total time spent in the style resolution and widget building process. Metrics are provided in microseconds (µs) to ensure high-precision performance monitoring.

```text
--- [WIND DEBUG] Build Time: 142µs ---
```

Significant spikes in build time (typically >1ms) may indicate excessive class complexity or inefficient custom state resolutions.

<a name="how-windlogger-works"></a>
## How WindLogger Works

Internally, Wind leverages a `WindLogger` service. When the `WindParser` resolves a `className`, it checks for the presence of the `debug` flag in the resulting style object.

If active, the parser passes the resolved properties and the generated widget hierarchy to the logger. The logger then formats this data into a human-readable "pseudo-Dart" format. The timing is handled by a `Stopwatch` that starts when the parsing begins and stops when the widget tree is returned.

<a name="quick-reference"></a>
## Quick Reference

| Field | Purpose | Output Format |
|:------|:--------|:--------------|
| `debug` | Utility class | N/A |
| `Composition Tree` | Widget hierarchy | Pseudo-Dart code |
| `Final Styles` | Style verification | `WindStyle` properties |
| `Build Time` | Performance audit | Microseconds (µs) |

<a name="common-scenarios"></a>
## Common Scenarios

Let's look at common debugging workflows using the `debug` class:

- **Inspecting Responsive Styles**: Resize the viewport while `debug` is active. The logger will re-trigger and show the new `Final Styles` for the active breakpoint.
- **Verifying State Variants**: Hover over or focus a widget with state-based classes (like `hover:bg-blue-600`). The log will update to show the merged style.
- **Analyzing Layout Layers**: Use the `Composition Tree` to determine which utility class is responsible for a specific Flutter wrapper, helping identify unexpected padding or alignment issues.

<a name="unknown-classname-warnings"></a>
## Unknown className Warnings

Wind drops any token no parser recognizes: an unknown token never throws and never renders. That keeps a typo from crashing the UI, but a silent drop also hides the typo. To surface it, the parser prints a one-time hint in `kDebugMode` whenever it meets a className it cannot resolve:

```text
Wind: unknown className 'flex-col-reverse' was ignored.
```

The hint fires once per unique token per session (deduped like the alias shadow and cycle warnings), so a token repeated across many widgets logs a single line. Release builds print nothing: the check sits behind `kDebugMode` and is tree-shaken out.

> [!NOTE]
> The warning targets genuine typos. Valid Wind tokens that a widget consumes outside the parser map are exempt and never warn: the `object-*` fit family (read by `WImage`), the `inline-flex` / `inline-block` / `inline` display keywords (emitted by `WBadge`, inert in Flutter), and deliberately inert compatibility tokens (`transition` / `transition-colors`, `antialiased`, `sr-only`, and the `*-nums` font-variant family such as `tabular-nums`).

If a token you expect to work triggers the warning, check the [Token catalog](https://fluttersdk.com/wind/layout) for the canonical spelling. A common case is a CSS name that Wind aliases: `flex-wrap` prints the hint and points you at the canonical `wrap`.

<a name="external-tooling-integration"></a>
## External Tooling Integration

Beyond the `debug` className for in-console inspection, Wind exposes a contracts-based bridge so external debug tools (E2E drivers, runtime inspectors, IDE plugins) can read live Wind state per widget. The bridge ships in the production dependency `fluttersdk_wind_diagnostics_contracts` and is installed via a single facade call.

### When you need this

You need to call `Wind.installDebugResolver()` when one of these is true:

- You are using `fluttersdk_dusk` to drive E2E tests against your app. Dusk reads Wind state (the active className, breakpoint, brightness, platform, dynamic states, resolved background color, resolved text color) via the contracts package during snapshot capture.
- You are writing an inspector or IDE tool that needs the same per-widget Wind state at runtime.

If neither applies, you can skip this step. Wind itself does not depend on the resolver being installed; widgets render the same with or without it.

### Wiring it up

Call `Wind.installDebugResolver()` once during app startup, inside a `kDebugMode` guard. The call is idempotent (safe to call multiple times) and is automatically a no-op in release builds, so the bridge is tree-shaken out of production binaries.

```dart
import 'package:flutter/foundation.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

void main() {
  if (kDebugMode) {
    Wind.installDebugResolver();
  }
  runApp(const MyApp());
}
```

After the call, any consumer of `WindDebugRegistry.current` (from the contracts package) can call `resolver.resolve(element)` on a Wind widget's `Element` to receive a map of debug fields: `className`, `breakpoint`, `brightness`, `platform`, `states`, `bgColor`, `textColor`. Tools read this without depending on Wind directly.

### What the contract emits

`WindDebugResolverImpl.resolve(element)` returns at most six fields per widget element:

| Field | Type | Notes |
|:------|:-----|:------|
| `className` | `String` | The active className resolved through breakpoints, dark mode, and state prefixes |
| `breakpoint` | `String` | The currently-active named breakpoint (`sm` / `md` / `lg` / `xl` / `2xl` / `base`) |
| `brightness` | `String` | `'light'` or `'dark'` |
| `platform` | `String` | `'web'` / `'android'` / `'ios'` / etc. |
| `states` | `List<String>` | Active dynamic states (`hover`, `focus`, `active`, custom keys) |
| `bgColor` | `String?` | Resolved background color hex (8 digits including alpha) when set by className or inline prop |
| `textColor` | `String?` | Resolved foreground color hex when set |

Fields whose value is null are omitted; the map only carries what the widget actually resolved.

### Release-build safety

`Wind.installDebugResolver()` is a no-op in release builds. The `kDebugMode` guard in user code further ensures dart2js / dart2native tree-shakes the entire branch on every platform. There is no production cost from leaving the call in place.

<a name="aggregate-performance-counters"></a>
## Aggregate Performance Counters

`WindDebugResolver` answers per-`Element` questions, so it has nowhere to put a number that belongs to no single element: how often the style cache was hit, how many `WDiv`s were built. `WindPerfCounters` and a second contract, `WindPerfResolver`, cover exactly those.

### The three cache outcomes, and why they are three

`WindParser.parse` runs on every build of every W-widget, and its cache has three outcomes rather than the usual two:

| Outcome | When | Cost |
|---|---|---|
| **Hit** | no `baseStyle`, and the key is present | a map lookup |
| **Miss** | no `baseStyle`, key absent | parses once, then caches |
| **Bypass** | a `baseStyle` was supplied | parses on every rebuild, never caches |

A bypass never consults and never writes the cache, because the cache key is composed from the context and the className only. Folding it into "miss" would report a cache-miss rate that looks explainable while saying nothing about work that never amortises.

Worth reading the call sites precisely: `WDiv` and `WText` both call the parser as `baseStyle: style`, and `style` is the widget's own nullable property. **A bypass is a property of a caller writing `style:`, not of using these widgets.** Driven against a real app, bypasses measured zero across 1613 W-widget builds while the hit rate stayed at 99% or better.

### Turning them on

Counting is off by default and every increment sits behind one static bool check, so a disabled counter costs a load and a branch that tree-shakes:

```dart
WindPerfCounters.enabled = true;
// ... drive the interaction you want to measure ...
print(WindPerfCounters.cacheHits);      // and cacheMisses, cacheBypasses
print(WindPerfCounters.wDivBuilds);     // and wTextBuilds
```

`WindParser.clearCache()` resets the counters as well as the cache, so a hit rate is always reported against the cache it was measured on. That is also why a theme change mid-measurement zeroes them.

### Reading them from outside

`Wind.installPerfResolver()` publishes the totals through the diagnostics contracts package, the same bridge `installDebugResolver()` uses and a separate slot on the same registry. It is idempotent, `kDebugMode`-gated, and installing it costs nothing on its own since counting stays off until the flag is set:

```dart
if (kDebugMode) {
  Wind.installDebugResolver();   // per-Element state
  Wind.installPerfResolver();    // aggregate counters
}
```

A tool then reads `WindDebugRegistry.currentPerf?.stats()` and gets exactly six `int` keys: `cacheHits`, `cacheMisses`, `cacheBypasses`, `cacheSize`, `wDivBuilds`, `wTextBuilds`. The `null` when no resolver is registered is meaningful and worth passing through rather than flattening to zeros: it is what lets a caller tell "wind never installed one" from "the counters really are zero".

`fluttersdk_dusk` reads this during a `dusk:perf_begin` / `dusk:perf_end` session.
