# Context Extensions

BuildContext extensions for convenient theme access.

## Theme Access

```dart
// Get theme controller (for toggling)
WindThemeController controller = context.windTheme;
controller.toggleTheme();

// Get theme data (read-only)
WindThemeData data = context.windThemeData;
```

## Theme Properties

```dart
// Colors map
Map<String, MaterialColor> colors = context.windColors;

// Breakpoints map
Map<String, int> screens = context.windScreens;

// Brightness
Brightness brightness = context.windBrightness;
bool isDark = context.windIsDark;
```

## Responsive Shortcuts

```dart
// Device type checks
bool isMobile = context.wIsMobile;    // < md
bool isTablet = context.wIsTablet;    // >= md && < lg
bool isDesktop = context.wIsDesktop;  // >= lg

// Current breakpoint
String bp = context.wActiveBreakpoint;
```

## Helper Shortcuts

```dart
// Color
Color? blue = context.wColorExt('blue', shade: 500);

// Spacing
double space = context.wSpacingExt(4);

// Font size
double? size = context.wFontSizeExt('lg');

// Font weight
FontWeight? weight = context.wFontWeightExt('bold');

// Screen check
bool isLarge = context.wScreenIsExt('lg');

// Style parsing
WindStyle style = context.wStyleExt('p-4 bg-blue-500');
```

## Extension Reference

| Extension | Description |
| :--- | :--- |
| `context.windTheme` | Get WindThemeController |
| `context.windThemeData` | Get WindThemeData |
| `context.windColors` | Get colors map |
| `context.windScreens` | Get breakpoints map |
| `context.windBrightness` | Get current brightness |
| `context.windIsDark` | Check if dark mode |
| `context.wIsMobile` | Check if < md |
| `context.wIsTablet` | Check if md <= screen < lg |
| `context.wIsDesktop` | Check if >= lg |
| `context.wActiveBreakpoint` | Current breakpoint name |
| `context.wColorExt(...)` | Color helper shortcut |
| `context.wSpacingExt(...)` | Spacing helper shortcut |
| `context.wFontSizeExt(...)` | Font size helper shortcut |
| `context.wFontWeightExt(...)` | Font weight helper shortcut |
| `context.wScreenIsExt(...)` | Screen check shortcut |
| `context.wStyleExt(...)` | Style parser shortcut |

## Related

- [Color Helpers](./color-helpers.md)
- [Responsive Helpers](./responsive-helpers.md)
