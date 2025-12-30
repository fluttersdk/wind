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

## Toggling Theme Programmatically

You can toggle between light and dark modes at runtime:

```dart
// Using WindTheme.of()
WindTheme.of(context).toggleTheme();

// Using BuildContext extension
context.windTheme.toggleTheme();
```

For reactive theme changes that also update `MaterialApp.theme`, use the `builder` pattern:

```dart
WindTheme(
  data: WindThemeData(),
  builder: (context, controller) => MaterialApp(
    theme: controller.toThemeData(), // Updates on toggleTheme()
    home: MyHomePage(),
  ),
)
```

## How it works

Wind checks `MediaQuery.of(context).platformBrightness`. If it is `Brightness.dark`, the `dark:` classes are applied.

> **Note**
> `WindThemeData` has a `brightness` property. If you manually set this to `Brightness.dark`, Wind will force dark mode styles regardless of the system setting.

### Softer Borders
Dark mode often requires more subtle borders to avoid high contrast eye strain.

```dart
className: "border-gray-200 dark:border-gray-700"
```

### Toggle Button Example

```dart
WAnchor(
  onTap: () => WindTheme.of(context).toggleTheme(),
  child: WDiv(
    className: 'bg-gray-200 dark:bg-gray-800 p-4 rounded-lg',
    child: WText(
      'Toggle Theme',
      className: 'text-gray-900 dark:text-white',
    ),
  ),
)
```
