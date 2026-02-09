# Theme Binding

Theme binding allows you to sync your Wind configuration with Flutter's native `ThemeData` system. This ensures that standard Material widgets automatically reflect your Wind tokens, creating a cohesive visual experience across your entire application.

- [Why Bind Themes?](#why-bind-themes)
- [Reactive Binding](#reactive-binding)
- [Toggling Themes](#toggling-themes)
- [Static Binding](#static-binding)
- [Mapping Reference](#mapping-reference)

<a name="why-bind-themes"></a>
## Why Bind Themes?

By default, Wind manages its own styling tokens (colors, spacing, typography). However, Flutter's built-in widgets (like `AppBar`, `FloatingActionButton`, or `TextField`) rely on the standard `Theme.of(context)` to determine their appearance.

Binding the two systems ensures:
- **Consistency:** A button using `bg-primary-500` matches a standard `ElevatedButton`.
- **Inheritance:** Standard Flutter widgets automatically pick up your Wind font families and colors.
- **Automation:** Toggling dark mode in Wind automatically updates the `brightness` of your standard Material theme.

<a name="reactive-binding"></a>
## Reactive Binding

To ensure your entire application rebuilds when the theme changes (e.g., switching to dark mode), use the `builder` pattern. This provides a `WindController` that dynamically generates a new `ThemeData` whenever the state updates.

<x-preview path="core-concepts/theme_binding" size="md" source="example/lib/pages/core-concepts/theme_binding.dart"></x-preview>

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final windTheme = WindThemeData(
      colors: {
        'primary': Colors.indigo,
        'secondary': Colors.teal,
      },
    );

    return WindTheme(
      data: windTheme,
      builder: (context, controller) {
        // controller.toThemeData() produces a standard Flutter ThemeData
        return MaterialApp(
          theme: controller.toThemeData(),
          home: const HomePage(),
        );
      },
    );
  }
}
```

<a name="toggling-themes"></a>
## Toggling Themes

When using the reactive `builder` pattern, you can trigger a global theme update from anywhere in the widget tree. This will automatically update both Wind utilities and standard Material widgets.

```dart
// Toggle between Light and Dark mode
context.windTheme.toggleTheme();
```

<a name="static-binding"></a>
## Static Binding

If you do not need dynamic theme switching at runtime, you can bind the theme once during initialization. This is useful for apps with a fixed brand identity or forced dark/light modes.

```dart
final windTheme = WindThemeData(
  brightness: Brightness.dark,
  colors: {'primary': Colors.purple},
);

return WindTheme(
  data: windTheme,
  child: MaterialApp(
    theme: windTheme.toThemeData(),
    home: const HomePage(),
  ),
);
```

<a name="mapping-reference"></a>
## Mapping Reference

The `toThemeData()` method intelligently maps Wind tokens to their standard Flutter counterparts:

| Wind Token | Flutter Theme Property |
|:-----------|:-----------------------|
| `colors['primary']` | `colorScheme.primary` |
| `colors['secondary']` | `colorScheme.secondary` |
| `colors['error']` | `colorScheme.error` |
| `colors['background']` | `scaffoldBackgroundColor` |
| `brightness` | `brightness` |
| `fontFamilies['sans']` | `textTheme.fontFamily` |

This mapping ensures that your utility-first styles and native widgets stay perfectly in sync.

