# Dark Mode

Wind makes it incredibly easy to support dark mode in your application using the `dark:` variant modifier. Instead of managing separate style sheets or complex theme objects, you simply prefix utilities that should apply when dark mode is enabled.

<x-preview path="examples/theme_mode"></x-preview>

## Basic Usage

By default, Wind uses the `light` theme. To style an element for dark mode, add the `dark:` prefix to any utility class.

```dart
WDiv(
  className: "bg-white text-black dark:bg-slate-900 dark:text-white",
  child: WDiv(
    className: "p-6 rounded-lg shadow-lg dark:shadow-none",
    child: WText("I adapt to your system theme!"),
  ),
)
```

In this example:
- **Light Mode:** White background, black text, shadow.
- **Dark Mode:** Slate-900 background, white text, no shadow.

## Combining Modifiers

The `dark:` modifier can be combined with other modifiers like `hover:` or responsive prefixes (`md:`).

```dart
// A button that changes color on hover, with different colors in dark mode
WButton(
  className: '''
    bg-blue-500 hover:bg-blue-600
    dark:bg-blue-700 dark:hover:bg-blue-600
    text-white rounded px-4 py-2
  ''',
  child: WText("Button"),
)
```

## Toggling Theme

Wind automatically detects the system brightness (`MediaQuery.platformBrightness`). However, you often want to give users manual control.

You can toggle the theme using the `WindTheme` controller:

```dart
// Toggle between light and dark
context.windTheme.toggleTheme();

// Force specific mode
context.windTheme.setTheme(
  context.windThemeData.copyWith(brightness: Brightness.dark)
);
```

For this to work effectively, ensure you have set up **Reactive Theme Binding**. See the [Theme Binding](./theme-binding.md) guide for setup instructions.

## Design Patterns

### 1. Off-White Backgrounds
Avoid pure black (`#000000`) for backgrounds. Use dark gray scales like `slate-900` or `gray-900` for a more polished look.

```dart
className: "bg-white dark:bg-slate-900" // Better than dark:bg-black
```

### 2. Softer Borders
Dark mode often requires subtler borders to avoid high contrast eye strain.

```dart
className: "border-gray-200 dark:border-gray-700"
```

### 3. De-emphasized Text
Use opacity or lighter gray shades for secondary text to establish hierarchy.

```dart
WText(
  "Subtitle",
  className: "text-gray-500 dark:text-gray-400"
)
```

## Overriding Detection

If you want to support a "System" mode alongside "Light" and "Dark", you can rely on Wind's default behavior (which reads `MediaQuery`). When the user explicitly selects "Light" or "Dark", update the `WindThemeData.brightness` manually.

```dart
// System Mode (Default)
// Wind uses system brightness

// Explicit Mode
WindTheme(
  theme: WindThemeData(brightness: Brightness.dark), // Forces dark mode
  child: ...
)
```
