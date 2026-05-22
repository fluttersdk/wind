# Context Extensions

- [Overview](#overview)
- [Theme Extensions](#theme-extensions)
- [Responsive Extensions](#responsive-extensions)
- [Helper Extensions](#helper-extensions)
- [API Reference](#api-reference)
- [Common Patterns](#common-patterns)

<a name="overview"></a>
## Overview

Wind provides a set of ergonomic extensions on `BuildContext` to make accessing theme data, responsive breakpoints, and styling helpers as concise as possible. Instead of verbose provider lookups, you can access the entire Wind ecosystem directly from the `context`.

<x-preview path="utilities/context_extensions_basic" size="md" source="example/lib/pages/utilities/context_extensions_basic.dart"></x-preview>

<a name="theme-extensions"></a>
## Theme Extensions

These extensions provide direct access to the `WindTheme` configuration and its underlying data.

### Theme Control
Use `windTheme` to interact with the theme controller, typically for toggling between light and dark modes.

```dart
// Toggle the current theme
context.windTheme.toggleTheme();

// Set a specific brightness
context.windTheme.setBrightness(Brightness.dark);
```

### Theme Data
Access the raw `WindThemeData` or specific properties like colors and brightness.

```dart
// Access the full theme data object
final theme = context.windThemeData;

// Quick access to the colors map
final primary = context.windColors['blue'];

// Check current brightness state
if (context.windIsDark) {
  // Apply dark mode logic
}
```

<a name="responsive-extensions"></a>
## Responsive Extensions

Responsive extensions allow you to make layout decisions in your widget tree based on the current screen size and defined breakpoints.

### Breakpoint Shortcuts
Quickly determine the current device category. These are based on your theme's `screens` configuration (defaults to Tailwind breakpoints).

```dart
if (context.wIsMobile) {
  return MobileLayout(); // < md
}

if (context.wIsTablet) {
  return TabletLayout(); // >= md && < lg
}

if (context.wIsDesktop) {
  return DesktopLayout(); // >= lg
}
```

### Active Breakpoint
You can also retrieve the exact name of the active breakpoint.

```dart
WText('Current breakpoint: ${context.wActiveBreakpoint}');
```

<a name="helper-extensions"></a>
## Helper Extensions

These extensions are shorthand for Wind's global helper functions, allowing you to resolve specific values from the theme without passing the context manually.

### Colors and Spacing
Resolve colors and spacing values based on your theme's unit scale.

```dart
// Get 'red-500' from the theme
final alertColor = context.wColorExt('red', shade: 500);

// Get 4 units of spacing (4 * baseSpacingUnit)
final padding = context.wSpacingExt(4);
```

### Typography and Styling
Directly resolve font properties or even parse full class strings into a `WindStyle` object.

```dart
final weight = context.wFontWeightExt('bold');
final size = context.wFontSizeExt('lg');

// Parse a class string manually
final style = context.wStyleExt('p-4 bg-blue-500 rounded-lg');
```

<a name="api-reference"></a>
## API Reference

| Property / Method | Returns | Description |
|:---|:---|:---|
| `windTheme` | `WindThemeController` | Access the controller for toggling or updating the theme. |
| `windThemeData` | `WindThemeData` | Access the read-only theme configuration. |
| `windColors` | `Map<String, MaterialColor>` | Returns the full color palette from the theme. |
| `windScreens` | `Map<String, int>` | Returns the breakpoint map (e.g., `md: 768`). |
| `windBrightness` | `Brightness` | Returns the current theme brightness (`light` or `dark`). |
| `windIsDark` | `bool` | Convenience getter for `brightness == Brightness.dark`. |
| `wActiveBreakpoint` | `String` | Returns the name of the currently active breakpoint. |
| `wIsMobile` | `bool` | Returns `true` if screen width is less than `md`. |
| `wIsTablet` | `bool` | Returns `true` if screen width is between `md` and `lg`. |
| `wIsDesktop` | `bool` | Returns `true` if screen width is `lg` or larger. |
| `wColorExt(name, {shade})`| `Color?` | Resolves a theme color by name and optional shade. |
| `wSpacingExt(multiplier)` | `double` | Returns spacing calculated by `multiplier * baseSpacingUnit`. |
| `wFontSizeExt(name)` | `double?` | Returns the font size value for a key (e.g., `xl`). |
| `wFontWeightExt(name)` | `FontWeight?` | Returns the font weight for a key (e.g., `bold`). |
| `wScreenIsExt(name)` | `bool` | Checks if a specific breakpoint is currently active. |
| `wStyleExt(className)` | `WindStyle` | Parses a utility string into a `WindStyle` object. |

<a name="common-patterns"></a>
## Common Patterns

### Conditional Layouts
Using responsive extensions to change widget parameters.

```dart
WDiv(
  className: 'bg-white rounded-lg',
  // Use extension to adjust padding dynamically in logic
  child: Padding(
    padding: EdgeInsets.all(context.wIsMobile ? 12 : 24),
    child: Content(),
  ),
)
```

### Manual Style Resolution
Sometimes you need to apply Wind styles to standard Flutter widgets that don't support `className`.

```dart
final style = context.wStyleExt('text-blue-600 font-bold italic');

return Text(
  'Direct Styling',
  style: style.textStyle,
);
```

### Theme Toggling
Implementing a theme switcher is trivial with the `windTheme` extension.

```dart
IconButton(
  icon: Icon(context.windIsDark ? Icons.light_mode : Icons.dark_mode),
  onPressed: () => context.windTheme.toggleTheme(),
)
```

## Related Documentation

- [Theming Concepts](../core-concepts/theming.md)
- [Responsive Design](../core-concepts/responsive-design.md)
- [Color Helpers](./color-helpers.md)
