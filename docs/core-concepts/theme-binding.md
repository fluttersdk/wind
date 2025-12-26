# Binding with Flutter Theme

You can bind the Wind theme to your Flutter application to seamlessly integrate your app's default styles with Wind's powerful theming system. This ensures consistency between Wind utility classes and standard Flutter widgets.

## Reactive Theme Binding

Use the `builder` pattern to create a reactive binding where `MaterialApp.theme` updates automatically when you call `toggleTheme()`:

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final windTheme = WindThemeData(
      colors: {
        'primary': Colors.indigo,
        'secondary': Colors.teal,
      },
      fontFamilies: {'sans': 'Inter'},
    );

    return WindTheme(
      data: windTheme,
      builder: (context, controller) => MaterialApp(
        title: 'Wind App',
        // Auto-updates when controller.toggleTheme() is called
        theme: controller.toThemeData(),
        home: HomePage(),
      ),
    );
  }
}
```

### Toggling Theme

```dart
// Anywhere in your app:
WindTheme.of(context).toggleTheme();
// or
context.windTheme.toggleTheme();
```

## Static Theme Binding

If you don't need reactive theme switching, use the `child` pattern with a static `toThemeData()` call:

```dart
final windTheme = WindThemeData(
  brightness: Brightness.light,
);

return WindTheme(
  data: windTheme,
  child: MaterialApp(
    theme: windTheme.toThemeData(),
    home: HomePage(),
  ),
);
```

## How it works

The `toThemeData()` method creates a standard Flutter `ThemeData` object derived from your `WindThemeData` configuration. It automatically maps:

- **Colors:**
  - `primary`: Uses `colors['primary']` (fallback: Indigo).
  - `secondary`: Uses `colors['secondary']` (fallback: Teal).
  - `error`: Uses `colors['error']` (fallback: Red).
  - `surface`: Uses `colors['white']`.
  - `scaffoldBackgroundColor`: Uses `colors['background']` if defined, otherwise defaults to White (light) or Gray-900 (dark).
- **Typography:**
  - Applies the default `sans` font family to the entire `textTheme`.
- **System:**
  - Sets `brightness` and enables `useMaterial3: true`.

This ensures that widgets like `AppBar`, `FloatingActionButton`, or `TextField` that rely on `Theme.of(context)` will match your Wind utility classes.
