# WindTheme Setup & Configuration

This guide covers how to set up `WindTheme`, configure custom colors/fonts via `WindThemeData`, toggle dark mode, and access theme values programmatically.

## 1. Basic Setup

Wrap your `MaterialApp` with `WindTheme`. This provides the theme context to all Wind widgets (`WDiv`, `WText`, etc.).

```dart
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

void main() {
  runApp(
    WindTheme(
      data: WindThemeData(), // Uses default light theme
      child: const MyApp(),
    ),
  );
}
```

### Persisting Theme Preference

Use the `onThemeChanged` callback to save the user's manual theme choice. This fires only on `toggleTheme()` — not on system brightness changes.

```dart
WindTheme(
  data: WindThemeData(),
  onThemeChanged: (brightness) {
    Vault.set('theme_mode', brightness == Brightness.dark ? 'dark' : 'light');
  },
  child: const MyApp(),
)
```

### Builder Pattern (Reactive MaterialApp Theme)

If you want your `MaterialApp` to automatically react to Wind theme changes (like dark mode toggles), use the `builder` parameter instead of `child`:

```dart
WindTheme(
  data: WindThemeData(),
  builder: (context, controller) => MaterialApp(
    theme: controller.toThemeData(), // Light theme
    darkTheme: controller.toThemeData(brightness: Brightness.dark),
    themeMode: controller.isDark ? ThemeMode.dark : ThemeMode.light,
    home: const MyApp(),
  ),
)
```

## 2. WindThemeData Options

`WindThemeData` is the "Tailwind Config" of Wind. It holds all design tokens.

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `brightness` | `Brightness` | `Brightness.light` | The overall theme brightness. |
| `colors` | `Map<String, MaterialColor>` | Default palette | Custom color registration. |
| `baseSpacingUnit` | `double` | `4.0` | Base pixel value for spacing multipliers (e.g. `p-4` = 4 * 4px). |
| `screens` | `Map<String, int>` | Default breakpoints | Responsive breakpoints in pixels. |
| `fontSizes` | `Map<String, double>` | Default sizes | Font size scale. |
| `fontWeights` | `Map<String, FontWeight>` | Default weights | Font weight scale. |
| `fontFamilies` | `Map<String, String>` | Default families | Custom font families (e.g. `sans`, `mono`). |
| `borderRadius` | `Map<String, double>` | Default radii | Border radius scale. |
| `borderWidths` | `Map<String, double>` | Default widths | Border width scale. |

### Complete Constructor Signature

```dart
WindThemeData({
  this.brightness = Brightness.light,
  Map<String, MaterialColor>? colors,
  Map<String, int>? screens,
  Map<String, int>? containers,
  Map<String, double>? fontSizes,
  Map<String, FontWeight>? fontWeights,
  Map<String, double>? tracking,
  Map<String, double>? leading,
  Map<String, double>? borderWidths,
  Map<String, double>? borderRadius,
  Map<String, String>? fontFamilies,
  Map<String, double>? ringWidths,
  Map<String, double>? ringOffsets,
  this.applyDefaultFontFamily = true,
  this.syncWithSystem = true,
  this.baseSpacingUnit = 4.0,
  this.ringColor = const Color(0xFF3B82F6),
  Map<String, double>? opacities,
  Map<String, int>? zIndices,
  Map<String, List<BoxShadow>>? shadows,
})
```

## 3. Dark Mode

There are three ways to handle dark mode in Wind.

**1. Static Setup**
```dart
WindTheme(
  data: WindThemeData(brightness: Brightness.dark),
  child: MyApp(),
)
```

**2. System-Aware (Preferred)**
Use Flutter's `MediaQuery` to detect system preference. (Combine this with the builder pattern shown above).

**3. Runtime Toggle**
You can toggle dark mode dynamically. This will trigger a rebuild of all Wind widgets.
```dart
// Using extension
context.windTheme.toggleTheme();

// Or using static method
WindTheme.of(context).toggleTheme();
```

**4. Resetting to System**
After manual toggle, system sync is disabled. To re-enable:
```dart
// Re-enable automatic system brightness sync
WindTheme.of(context).resetToSystem();
// Or via extension
context.windTheme.resetToSystem();
```

## 4. Registering Custom Colors

To add a brand color, you must provide a full `MaterialColor` with all 10 shades (50-900).

```dart
WindTheme(
  data: WindThemeData(
    colors: {
      'primary': const MaterialColor(0xFF009E60, {
        50: Color(0xFFE0F4ED),
        100: Color(0xFFB3E4D1),
        200: Color(0xFF80D2B3),
        300: Color(0xFF4DBF94),
        400: Color(0xFF26B07D),
        500: Color(0xFF009E60), // The default `bg-primary`
        600: Color(0xFF009156),
        700: Color(0xFF00814A),
        800: Color(0xFF00723F),
        900: Color(0xFF004D2F),
        950: Color(0xFF002E1B), // Optional, but recommended for Wind UI
      }),
    },
  ),
  child: const MyApp(),
)
```

Once registered, use it anywhere via `className`:
- `text-primary` (uses shade 500)
- `bg-primary-700`
- `border-primary/50` (50% opacity)

## 5. Context Extensions & Helpers

When you need to access theme values programmatically (outside of `className`), use these extensions and helpers.

### Context Extensions (`BuildContext`)

| Extension | Returns | Description |
|-----------|---------|-------------|
| `context.windTheme` | `WindThemeController` | Access the controller to toggle/update theme. |
| `context.windThemeData` | `WindThemeData` | Read-only access to the current theme config. |
| `context.windColors` | `Map<String, MaterialColor>` | Access the color palette map. |
| `context.windScreens` | `Map<String, int>` | Access the breakpoints map. |
| `context.windBrightness`| `Brightness` | Current brightness. |
| `context.windIsDark` | `bool` | True if current theme is dark. |
| `context.wIsMobile` | `bool` | True if screen is < md breakpoint. |
| `context.wIsTablet` | `bool` | True if screen is >= md and < lg. |
| `context.wIsDesktop` | `bool` | True if screen is >= lg. |
| `context.wActiveBreakpoint`| `String` | Current breakpoint name (e.g. 'md'). |
| `context.wColorExt('red', 500)`| `Color?` | Resolve a color safely. |
| `context.wSpacingExt(4)` | `double` | Get spacing in px (e.g. 16.0). |

### Global Helper Functions

These perform the same functions as extensions but are available as standalone functions.

| Function | Returns | Example Usage |
|----------|---------|---------------|
| `wColor` | `Color?` | `wColor(context, 'primary', shade: 500)` or `wColor(context, '#FFAABB')` |
| `wSpacing` | `double` | `wSpacing(context, 4)` // returns 16.0 |
| `wFontSize` | `double?` | `wFontSize(context, 'lg')` // returns 18.0 |
| `wFontWeight`| `FontWeight?`| `wFontWeight(context, 'bold')` // returns FontWeight.w700 |
| `wScreen` | `int?` | `wScreen(context, 'md')` // returns 768 |
| `wScreenIs` | `bool` | `wScreenIs(context, 'lg')` // true if width >= lg |

## 6. Using with Magic Framework

If your app uses the Magic Framework, `WindTheme` is typically registered inside your `AppServiceProvider` or `main.dart` wrapper.

```dart
class AppServiceProvider extends ServiceProvider {
  @override
  void register() {
    // Other bindings...
  }

  @override
  Widget boot(Widget child) {
    return WindTheme(
      data: WindThemeData(
        colors: { 'primary': AppColors.primary },
      ),
      builder: (context, controller) => MagicApplication(
        title: 'My App',
        theme: controller.toThemeData(),
        darkTheme: controller.toThemeData(brightness: Brightness.dark),
        themeMode: controller.isDark ? ThemeMode.dark : ThemeMode.light,
      ),
    );
  }
}
```