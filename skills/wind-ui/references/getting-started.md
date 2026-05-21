# Getting started with Wind UI

The complete setup recipe for a new Flutter app that uses Wind. Read this once when starting a project; SKILL.md and the other references cover everything afterward.

## 1. Install

```yaml
# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  fluttersdk_wind: ^1.0.0
```

`flutter pub get`. Flutter SDK >= 3.27.0, Dart >= 3.4.0.

Wind has two production dependencies it pulls transitively: `flutter_svg` (for `WSvg`) and `fluttersdk_wind_diagnostics_contracts` (the abstract debug-bridge interface). You do not need to add either yourself.

## 2. Wrap the app

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return WindTheme(
      data: WindThemeData(/* 23 optional fields; defaults applied to all unset ones */),
      builder: (context, controller) => MaterialApp(
        theme: controller.toThemeData(),
        home: const Scaffold(body: HomePage()),
      ),
    );
  }
}
```

Three things to know about this shape:

- **WindTheme lives BELOW MaterialApp in the actual tree.** The builder pattern inverts the apparent order in source.
- **`controller.toThemeData()`** maps Wind's color/font/radius tokens into a Material 3 `ThemeData`. Material widgets you mix in (DialogBox, NavigationBar, etc.) honor Wind's color palette automatically.
- **`Overlay` contexts cannot reach `WindTheme` via ancestor walk.** If you call `WindParser.parse(...)` from inside an `OverlayEntry.builder`, pass the State's outer `context`, not the overlay's.

## 3. Localization (required for WInput, WDatePicker)

`WInput` and `WDatePicker` use `MaterialLocalizations.of(context)` for OK/Cancel/month labels. `MaterialApp` provides this automatically; if you use `WidgetsApp` or `CupertinoApp` instead, wire it manually:

```dart
return MaterialApp(
  localizationsDelegates: const [
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ],
  supportedLocales: const [Locale('en'), Locale('tr'), /* ... */],
  // ...
);
```

## 4. Use a widget

```dart
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'w-full h-full overflow-y-auto p-4',
      scrollPrimary: true,
      child: WDiv(
        className: 'flex flex-col gap-6 max-w-2xl mx-auto',
        children: [
          WText(
            'Welcome to Wind',
            className: 'text-3xl font-bold text-gray-900 dark:text-white',
          ),
          WText(
            'Utility-first styling for Flutter.',
            className: 'text-base text-gray-600 dark:text-gray-400',
          ),
          WButton(
            onTap: () {},
            className: '''
              bg-blue-600 dark:bg-blue-700
              hover:bg-blue-700 dark:hover:bg-blue-600
              text-white px-6 py-3 rounded-lg
            ''',
            child: const WText('Get started'),
          ),
        ],
      ),
    );
  }
}
```

That is everything you need to ship the first screen.

## 5. Brightness and dark mode

`WindTheme(syncWithSystem: true)` is the default. The app's brightness tracks the OS setting automatically: turn the system into dark mode and `dark:` classes activate, no code change.

Manual toggle (settings screen, in-app theme switcher):

```dart
WButton(
  onTap: () => context.windTheme.toggleTheme(),  // disables syncWithSystem
  child: WIcon(
    context.windIsDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
  ),
);
```

Reset to system: `context.windTheme.resetToSystem()` re-enables `syncWithSystem` and immediately syncs to the current platform brightness.

Read-only checks:
- `context.windIsDark` → `bool`
- `context.windThemeData` → the current `WindThemeData` (do not subscribe; use `context.windTheme` if you need to rebuild on change)
- `context.windTheme` → the `WindThemeController` (a `ChangeNotifier`)

Detail: `references/dark-mode.md`.

## 6. Theme customization

Override any of `WindThemeData`'s 23 fields; unset fields get the default. Partial overrides ARE merged (your overrides win; defaults fill the gaps).

```dart
WindThemeData(
  // Add a 'brand' color scale (or override an existing one):
  colors: {
    'brand': const MaterialColor(0xFF6366F1, {
      50:  Color(0xFFEEF2FF),
      100: Color(0xFFE0E7FF),
      200: Color(0xFFC7D2FE),
      300: Color(0xFFA5B4FC),
      400: Color(0xFF818CF8),
      500: Color(0xFF6366F1),
      600: Color(0xFF4F46E5),
      700: Color(0xFF4338CA),
      800: Color(0xFF3730A3),
      900: Color(0xFF312E81),
      950: Color(0xFF1E1B4B),
    }),
  },
  // Adjust breakpoints (defaults: sm=640, md=768, lg=1024, xl=1280, 2xl=1536):
  screens: {'tablet': 600, 'desktop': 1024},
  // Bump default font sizes:
  fontSizes: {'base': 16.0, 'lg': 20.0},
  // Apply a custom font family by default:
  fontFamilies: {'sans': 'Inter', 'mono': 'JetBrainsMono'},
  applyDefaultFontFamily: true,
  // Tweak spacing unit (default 4 px):
  baseSpacingUnit: 4.0,
  // Custom focus ring color (default Tailwind blue-500):
  ringColor: const Color(0xFF6366F1),
)
```

All other unset fields keep their Wind defaults (slate/gray scales, Inter-like sans-serif, Tailwind-equivalent breakpoints, etc.).

## 7. Debug bridge (optional)

If you use `fluttersdk_dusk` for E2E testing OR build any custom inspector that reads Wind's resolved-state per widget, call this once in `main.dart` inside `kDebugMode`:

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

What it does: registers Wind's `WindDebugResolverImpl` into the abstract `WindDebugRegistry` from `fluttersdk_wind_diagnostics_contracts`. Any consumer can then call `WindDebugRegistry.current?.resolve(element)` to read the 6 core fields of any W-widget in the tree: `className`, `breakpoint`, `brightness`, `platform`, `states`, `bgColor`, `textColor`.

The call is idempotent (`_installed` flag) and a no-op in release builds (`kDebugMode` gate is compile-time-stripped).

**If you do NOT use Dusk or any inspector**, skip this step entirely. It is opt-in.

## 8. Run + verify

```bash
flutter run -d chrome       # web
flutter run -d <device-id>  # mobile
flutter analyze             # lint
```

The PostToolUse hooks defined in `.claude/settings.json` (if you copied them from Wind itself) auto-run `dart format` + `dart analyze` after every `.dart` edit. Otherwise call them manually before committing.

## What goes in main.dart vs elsewhere

| Goes in main.dart | Goes elsewhere |
|-------------------|----------------|
| `Wind.installDebugResolver()` (kDebugMode-gated) | Per-screen styling — that's just `className` in each widget |
| `WindTheme(...)` wrap + theme data | Theme reads/toggles via `context.windTheme` inside widgets |
| `MaterialApp(localizationsDelegates: ...)` (when needed) | `Form(key: _formKey)` lives in the form screen, not main.dart |
| Root navigator setup | Per-route components |

## What you should NOT do

- **Do not import any Wind sub-barrel.** The main barrel `package:fluttersdk_wind/fluttersdk_wind.dart` exports everything. The pre-1.0 sub-barrels (`dusk_integration.dart`, `telescope_integration.dart`) are gone in 1.0.0.
- **Do not call `WindParser.clearCache()` in production code.** It is a test-only function; calling it at runtime trashes the cache and recomputes every className from scratch.
- **Do not wrap the app twice in `WindTheme`.** Nested wraps work but waste rebuilds.
- **Do not put `Wind.installDebugResolver()` outside `kDebugMode`.** Already kDebugMode-gated internally, but the tree-shaker only strips the whole call when the outer guard is also `kDebugMode`.

## Where to go next

- Build your first form → `references/forms.md`
- Pick a layout pattern → `references/layouts.md`
- Make it responsive → `references/responsive.md`
- Dark-mode discipline → `references/dark-mode.md`
- Lookup a widget's full constructor → `references/widgets.md`
- Verify a className token exists → `references/tokens.md`
- Came from Tailwind? → `references/migrate-from-tailwind.md`
