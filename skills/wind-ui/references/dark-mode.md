# Dark mode with Wind UI

Dark mode in Wind is mandatory, not optional. Every visible color token MUST carry a `dark:` peer in the same className. Missing pairs are visible bugs that surface the first time a user toggles into dark mode.

## The invariant

For every one of these token families, a matching `dark:`-prefixed token appears in the SAME className string:

- `bg-*` background color
- `text-*` text color (the color meaning, not size or alignment)
- `border-*` border color
- `ring-*` focus ring color
- `fill-*` SVG fill
- `stroke-*` SVG stroke
- `shadow-*` color-tinted shadow
- `from-*` / `via-*` / `to-*` gradient stops (when designed to differ)

```dart
// MUST have peer
className: '''
  bg-white dark:bg-gray-800
  text-gray-900 dark:text-gray-100
  border border-gray-200 dark:border-gray-700
  hover:bg-gray-50 dark:hover:bg-gray-700
  focus:ring-2 focus:ring-blue-500 dark:focus:ring-blue-400
''',
```

Gradient banners are the one common exception — gradient stops are often the same color in both modes because the banner is a design element, not a content background.

## Canonical color pairs

Tested combinations from the Wind example gallery. Use these as defaults; vary only for specific brand needs.

### Surface (cards, modals, sheets)

| Light | Dark |
|-------|------|
| `bg-white` | `bg-gray-800` |
| `bg-gray-50` | `bg-gray-900` (page background) |
| `bg-gray-100` | `bg-gray-700` (subtle surface, hover) |
| `bg-blue-50` | `bg-blue-900/30` (accent surface with opacity) |

### Text

| Light | Dark |
|-------|------|
| `text-gray-900` | `text-white` (primary) |
| `text-gray-800` | `text-gray-100` |
| `text-gray-700` | `text-gray-300` (secondary) |
| `text-gray-500` | `text-gray-400` (muted, hint) |
| `text-gray-400` | `text-gray-500` (disabled) |

### Border

| Light | Dark |
|-------|------|
| `border-gray-200` | `border-gray-700` (subtle divider) |
| `border-gray-300` | `border-gray-600` (form input border) |
| `border-blue-500` | `border-blue-400` (focus, accent) |

### Brand color shifts (typical pattern)

Brand-500 is the daylight choice; brand-400 (lighter) the dark-mode choice (less contrast against dark surface).

```
bg-blue-500 / dark:bg-blue-400
text-blue-600 / dark:text-blue-400
border-blue-500 / dark:border-blue-400
```

### Slate vs gray vs zinc vs neutral vs stone

Five neutral families to choose from. Most designs pick one and stick with it. `slate` and `gray` are the safest starts; `zinc`, `neutral`, `stone` are stylistic variants.

## Combining `dark:` with states

`dark:` and state prefixes (`hover:`, `focus:`, `disabled:`) combine freely. Order is arbitrary; both must match.

```dart
className: '''
  bg-white dark:bg-gray-800
  hover:bg-gray-100 dark:hover:bg-gray-700
  focus:ring-2 focus:ring-blue-500 dark:focus:ring-blue-400
  disabled:bg-gray-200 dark:disabled:bg-gray-700
''',
```

Combine with breakpoints too:

```dart
className: '''
  bg-white dark:bg-gray-800
  md:bg-gray-50 dark:md:bg-gray-900
  hover:bg-gray-100 dark:hover:bg-gray-700
''',
```

## Toggling theme programmatically

```dart
// In any widget that has a BuildContext:
context.windTheme.toggleTheme();    // toggles light <-> dark
context.windTheme.setTheme(WindThemeData(brightness: Brightness.dark));  // explicit
context.windTheme.resetToSystem();  // re-enable syncWithSystem
```

`toggleTheme()` DISABLES `syncWithSystem` automatically — the user expects a manual toggle to stick across system changes until they reset. To re-enable OS sync, call `resetToSystem()`.

## Reading theme state

```dart
context.windIsDark      // bool — is the current theme dark?
context.windThemeData   // WindThemeData — current data (no listener)
context.windTheme       // WindThemeController — the ChangeNotifier (use for rebuilds)
```

For a widget that should rebuild on theme change, use `ListenableBuilder` (or, more idiomatic in Wind, just read `context.windTheme` and the wrapping `WindTheme` will trigger rebuilds via `InheritedNotifier`).

## System sync (the default)

`WindThemeData(syncWithSystem: true)` (default) listens to `WidgetsBinding.instance.platformDispatcher.platformBrightness` and rebuilds the app when the OS toggles dark mode at runtime.

The `_isSystemChange` flag inside `WindThemeController` distinguishes system-driven changes from user toggles. Your `onThemeChanged` callback fires ONLY on user toggles, not system updates — useful if you want to log analytics on "user toggled theme" specifically.

## Iframe / browser tab note

In an iframed example page (`example/lib/play.dart`), the docs frame controls light/dark via a postMessage event (`UPDATE_OPTIONS: { theme: 'light' | 'dark' }`). The example page itself does not render a toggle. Your app, if iframed somewhere, can wire similar message handling.

## What about Material widgets you mix in?

`controller.toThemeData()` maps Wind's color palette into a Material 3 `ThemeData`. Dialogs, NavigationBars, AlertDialogs, snackbars all inherit Wind's primary color, surface color, and brightness automatically. No double-wrapping needed.

## Dark-mode anti-patterns

| Wrong | Why | Right |
|-------|-----|-------|
| `bg-white` alone | renders white-on-light text in dark mode | `bg-white dark:bg-gray-800` |
| `text-black` alone | unreadable in dark mode | `text-black dark:text-white` |
| `border-gray-200` alone | invisible against dark surface | `border-gray-200 dark:border-gray-700` |
| `Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white` (manual ternary) | breaks parser cache, hard to reason about | use `dark:` prefix |
| Hard-coded hex colors in `dark:` peers | breaks theme palette consistency | use shade tokens like `dark:bg-gray-800` |
| Different IMAGE in dark mode via Dart conditional | image swap is a structural change | use a brand asset that works in both, OR drive via `MediaQuery.of(context).platformBrightness` + `WBreakpoint`-style logic |
| Toggle theme directly via `setState((){ _brightness = Brightness.dark; })` outside `WindTheme` | bypasses the controller, lost re-sync | call `context.windTheme.toggleTheme()` |
| Forgetting `dark:` on focus rings | focus invisible in dark mode | always pair `focus:ring-blue-500` with `dark:focus:ring-blue-400` |
| Mixing dark text on dark surface | unreadable | check contrast; gray-900 on gray-800 is too low |

## Quick verification checklist

Before committing a UI change, grep your diff for `bg-`, `text-`, `border-`, `ring-`, `fill-`, `shadow-`. For each non-`dark:` token, confirm there is a `dark:` peer in the SAME className string. Missing peers = dark-mode bug.

The PostToolUse hook in `.claude/settings.json` does not catch this — it is a semantic check the agent must do manually.
