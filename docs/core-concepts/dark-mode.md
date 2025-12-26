# Dark Mode

Wind supports dark mode out of the box using the `dark:` prefix. It allows you to style your site differently when dark mode is enabled in the system or application.

## Basic Usage

To apply a style only in dark mode, simply add `dark:` to the beginning of the class name.

```dart
WDiv(
  className: "bg-white text-black dark:bg-gray-900 dark:text-white",
  child: WText("I adapt to your system theme!"),
)
```

## How it works

Wind checks `MediaQuery.of(context).platformBrightness`. If it is `Brightness.dark`, the `dark:` classes are applied.

> **Note**
> `WindThemeData` has a `brightness` property. If you manually set this to `Brightness.dark`, Wind will force dark mode styles regardless of the system setting.

## Strategies

### Inverted Colours
The most common pattern is to invert background and text colors.

```dart
// Light: White bg, Slate-900 text
// Dark: Slate-900 bg, White text
className: "bg-white text-slate-900 dark:bg-slate-900 dark:text-white"
```

### Softer Borders
Dark mode often requires more subtle borders to avoid high contrast eye strain.

```dart
className: "border-gray-200 dark:border-gray-700"
```
