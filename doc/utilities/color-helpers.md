# Color Helpers

- [Resolving Colors](#resolving-colors)
- [Hex Colors](#hex-colors)
- [Opacity Handling](#opacity-handling)
- [Contrast](#contrast)
- [Material Color Inversion](#material-color-inversion)
- [Context Extensions](#context-extensions)

Wind provides a set of utility functions and extensions to help you resolve and manipulate colors programmatically, staying consistent with your theme.

<x-preview path="utilities/color_helpers_basic" size="md" source="example/lib/pages/utilities/color_helpers_basic.dart"></x-preview>

<a name="resolving-colors"></a>
## Resolving Colors

The `wColor` function is the primary way to resolve colors from the active `WindTheme`. It handles color names, shades, and even automatic dark mode overrides.

```dart
Color? wColor(
  BuildContext context,
  String colorName, {
  int shade = 500,
  String? darkColorName,
  int darkShade = 500,
})
```

### Basic Usage

You can resolve a color by its name and shade:

```dart
// Resolves blue-500 from the theme
final primary = wColor(context, 'blue');

// Resolves red-600
final error = wColor(context, 'red', shade: 600);

// Resolves using color-shade string format
final danger = wColor(context, 'rose-500');
```

### Dark Mode Overrides

You can specify a different color or shade to be used when the theme is in dark mode:

```dart
final background = wColor(
  context,
  'slate-50',
  darkColorName: 'slate-900',
);
```

<a name="hex-colors"></a>
## Hex Colors

The `hexToColor` function converts various hex string formats into Flutter `Color` objects.

```dart
Color hexToColor(String code)
```

### Supported Formats

| Format | Example | Result |
|:-------|:--------|:-------|
| 3-digit Hex | `#RGB` | `#RRGGBB` |
| 4-digit Hex | `#ARGB` | `#AARRGGBB` |
| 6-digit Hex | `#RRGGBB` | `0xFFRRGGBB` |
| 8-digit Hex | `#AARRGGBB` | `0xAARRGGBB` |

> [!NOTE]
> The hash (`#`) prefix is optional. `hexToColor('FF0000')` works identically to `hexToColor('#FF0000')`.

<a name="opacity-handling"></a>
## Opacity Handling

Wind includes utilities for parsing Tailwind-style opacity modifiers and applying them to colors.

### Parsing Opacity

The `parseColorOpacity` function splits a class string into the color part and its opacity factor.

```dart
// Returns (colorPart: 'blue-500', opacity: 0.5)
final result = parseColorOpacity('blue-500/50');

// Supports arbitrary values: (colorPart: 'red-500', opacity: 0.75)
final arbitrary = parseColorOpacity('red-500/[75]');
```

### Applying Opacity

Use `applyOpacity` to programmatically adjust the alpha channel of any `Color`.

```dart
Color applyOpacity(Color color, double opacity)
```

```dart
final semiTransparent = applyOpacity(Colors.blue, 0.5);
```

<a name="contrast"></a>
## Contrast

`contrastRatio` and `contrastForeground` compute WCAG 2.x contrast for a colour your theme does not own, such as a brand colour an end user picks for a public status page. A theme token already has a correct `dark:` pair; these two exist for the colour that does not.

```dart
double contrastRatio(Color a, Color b)

Color contrastForeground(
  Color background, {
  Color light = const Color(0xFFFFFFFF),
  Color dark = const Color(0xFF000000),
})
```

`contrastRatio` returns a value from 1 (identical colours) to 21 (pure black against pure white). `contrastForeground` picks whichever of `light` or `dark` has the higher ratio against `background`, comparing the two ratios directly rather than checking `background`'s luminance against the usual 0.179 crossover. That threshold is only correct when both candidates are pure black and pure white; pass a `dark` tuned away from pure black (a near-black brand tone, say) and the threshold can pick the candidate that reads worse.

```dart
// A status page renders its operator's brand colour behind white text.
// The brand colour is not a theme token, so it needs a computed answer.
final Color heading = contrastForeground(brandColor);

// Compare a fixed pair directly.
final double ratio = contrastRatio(brandColor, Colors.white);
```

<a name="material-color-inversion"></a>
## Material Color Inversion

The `invertMaterialColor` utility is used by the theme engine to automatically generate dark mode variants by swapping shades (e.g., 50 ↔ 900, 100 ↔ 800).

```dart
MaterialColor invertMaterialColor(MaterialColor color)
```

<a name="context-extensions"></a>
## Context Extensions

For more ergonomic access, Wind extends `BuildContext` with several color-related shortcuts.

### `context.windColors`

Returns the full color map from the current `WindThemeData`.

```dart
final redPalette = context.windColors['red'];
```

### `context.wColorExt`

A shortcut for calling `wColor(context, ...)`.

```dart
final primary = context.wColorExt('blue', shade: 600);
```

### `context.windIsDark`

Returns a boolean indicating if the current theme brightness is `Brightness.dark`.

```dart
if (context.windIsDark) {
  // Do something specific for dark mode
}
```
