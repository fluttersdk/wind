# Helper Functions

Wind provides helper functions for programmatic access to theme values. These are useful when you need to work with theme values directly in your code instead of using utility class strings.

## Color Access

Use `wColor` to get theme colors programmatically.

```dart
// Get color by name and shade
Color blue = wColor(context, 'blue', 500)!;
Color red = wColor(context, 'red', 600)!;

// Shorthand with shade in name
Color green = wColor(context, 'green-400')!;

// Hex color (bypasses theme)
Color custom = wColor(context, '#FF5733')!;
```

| Function | Description |
| :--- | :--- |
| `wColor(context, name, [shade])` | Returns a theme color by name |

## Spacing

Use `wSpacing` to get consistent spacing values.

```dart
// Get spacing (multiplier × baseSpacingUnit)
double p4 = wSpacing(context, 4);   // 16.0
double p2 = wSpacing(context, 2);   // 8.0
double half = wSpacing(context, 0.5); // 2.0
```

| Function | Description |
| :--- | :--- |
| `wSpacing(context, multiplier)` | Returns spacing value |

## Typography

Access font sizes and weights from the theme.

```dart
// Font sizes
double lg = wFontSize(context, 'lg')!;     // 18.0
double xl = wFontSize(context, '2xl')!;    // 24.0

// Font weights
FontWeight bold = wFontWeight(context, 'bold')!;       // w700
FontWeight semi = wFontWeight(context, 'semibold')!;   // w600
```

| Function | Description |
| :--- | :--- |
| `wFontSize(context, name)` | Returns font size (xs, sm, base, lg, xl, 2xl...) |
| `wFontWeight(context, name)` | Returns font weight (thin, light, normal, medium, semibold, bold...) |

## Responsive Breakpoints

Work with responsive breakpoints programmatically.

```dart
// Get breakpoint pixel value
int md = wScreen(context, 'md');  // 768
int lg = wScreen(context, 'lg');  // 1024

// Check if screen is at least a breakpoint
if (wScreenIs(context, 'lg')) {
  // Desktop layout
}

// Get current active breakpoint
String current = wScreenCurrent(context);  // 'md', 'lg', etc.
```

| Function | Description |
| :--- | :--- |
| `wScreen(context, name)` | Returns breakpoint pixel value |
| `wScreenIs(context, name)` | Returns true if screen >= breakpoint |
| `wScreenCurrent(context)` | Returns current active breakpoint name |

## Parse Class Strings

Parse Wind utility classes into a `WindStyle` object for custom usage.

```dart
WindStyle style = wStyle(context, 'bg-red-500 p-4 rounded-lg');

// Access parsed values
Color? bgColor = style.decoration?.color;
EdgeInsets? padding = style.padding;
```

| Function | Description |
| :--- | :--- |
| `wStyle(context, className)` | Parses class string into WindStyle |

## BuildContext Extensions

For convenience, all helpers are also available as BuildContext extensions.

```dart
// Theme access
WindThemeData theme = context.windTheme;
Map<String, MaterialColor> colors = context.windColors;
Map<String, int> screens = context.windScreens;
bool isDark = context.windIsDark;

// Responsive shortcuts
bool isMobile = context.wIsMobile;    // < md
bool isTablet = context.wIsTablet;    // >= md && < lg
bool isDesktop = context.wIsDesktop;  // >= lg
String bp = context.wActiveBreakpoint;

// Helper shortcuts (with 'Ext' suffix)
Color? blue = context.wColorExt('blue', 500);
double space = context.wSpacingExt(4);
WindStyle style = context.wStyleExt('p-4 bg-blue-500');
```

| Extension | Description |
| :--- | :--- |
| `context.windTheme` | Get WindThemeData |
| `context.windColors` | Get colors map |
| `context.windScreens` | Get breakpoints map |
| `context.windBrightness` | Get current brightness |
| `context.windIsDark` | Check if dark mode |
| `context.wIsMobile` | Check if screen < md |
| `context.wIsTablet` | Check if md <= screen < lg |
| `context.wIsDesktop` | Check if screen >= lg |
| `context.wActiveBreakpoint` | Get current breakpoint name |
