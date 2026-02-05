# Binding with Flutter Theme

Wind allows you to bind your custom `WindThemeData` to Flutter's standard `ThemeData`. This creates a seamless integration where standard Material widgets (like `AppBar`, `FloatingActionButton`, `TextField`) automatically reflect your Wind configuration.

## Why Bind Themes?

By binding Wind to Flutter's theme system, you ensure consistency across your app:
- **Colors:** `bg-primary-500` will match `Theme.of(context).primaryColor`.
- **Typography:** `font-sans` will be used by `Text` widgets by default.
- **Brightness:** Toggling Wind's theme also updates `ThemeData.brightness`.

## Reactive Theme Binding

Use the `builder` pattern to create a reactive binding. This ensures your entire app rebuilds automatically when you toggle the theme (e.g., Dark Mode).

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 1. Define your Wind Theme
    final windTheme = WindThemeData(
      colors: {
        'primary': Colors.indigo,
        'secondary': Colors.teal,
        'background': Colors.white, // In dark mode: auto-inverted or override
      },
      fontFamilies: {'sans': 'Inter'},
    );

    // 2. Wrap MaterialApp with WindTheme
    return WindTheme(
      data: windTheme,
      builder: (context, controller) {
        // 3. Use controller.toThemeData() to generate Flutter ThemeData
        return MaterialApp(
          title: 'Wind App',
          theme: controller.toThemeData(),
          home: HomePage(),
        );
      },
    );
  }
}
```

### Toggling Theme

When using reactive binding, changing the theme state automatically rebuilds `MaterialApp`.

```dart
// Toggle between Light and Dark mode
context.windTheme.toggleTheme();
```

## Static Theme Binding

If you don't need dynamic theme switching (e.g., force dark mode or static branding), you can bind the theme once.

```dart
final windTheme = WindThemeData(
  brightness: Brightness.dark,
  colors: {'primary': Colors.purple},
);

return WindTheme(
  data: windTheme,
  child: MaterialApp(
    // Generate ThemeData once
    theme: windTheme.toThemeData(),
    home: HomePage(),
  ),
);
```

## How it works

The `toThemeData()` method converts your `WindThemeData` into a standard Flutter `ThemeData` object. It maps tokens intelligently:

| Wind Token | Flutter Theme Property |
|------------|------------------------|
| `colors['primary']` | `colorScheme.primary` |
| `colors['secondary']` | `colorScheme.secondary` |
| `colors['error']` | `colorScheme.error` |
| `colors['background']` | `scaffoldBackgroundColor` |
| `brightness` | `brightness` |
| `fontFamilies['sans']` | `textTheme.fontFamily` |

This ensures that a button styled with `bg-primary-500` looks identical to a standard `ElevatedButton` using the primary color.
