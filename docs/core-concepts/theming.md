# Theme Configuration

Wind uses a centralized theme system to configure all design tokens. You can customize the look and feel of your application by defining values in `WindTheme`.

To customize the theme, wrap your app (or a specific subtree) with `WindTheme`. The `WindThemeData` object is immutable and merging strategies are handled via the constructor (partial maps are merged with defaults).

```dart
WindTheme(
  theme: WindThemeData(
    colors: {'brand': Colors.indigo},
    baseSpacingUnit: 4.0,
  ),
  child: MyApp(),
)
```

## Configurable Options

### General Settings

#### `brightness`
**Type:** `Brightness`
**Default:** `Brightness.light`
Defines the overall brightness of the theme. When set to `Brightness.dark`, colors defined in the theme are automatically inverted unless you fetch specific shades directly.

#### `baseSpacingUnit`
**Type:** `double`
**Default:** `4.0`
The base pixel value for spacing utilities (`p-`, `m-`, `w-`, `h-`, `gap-`, etc.). Reference values like `p-4` are calculated as `4 * baseSpacingUnit` (16px).

#### `applyDefaultFontFamily`
**Type:** `bool`
**Default:** `true`
When true, Wind automatically wraps its child in a `DefaultTextStyle` using the `sans` font family defined in `fontFamilies`.

### Typography

#### `fontFamilies`
**Type:** `Map<String, String>`
**Usage:** `font-sans`, `font-serif`, `font-mono`, `font-[key]`
Map of font family keys to actual font family names (as loaded in `pubspec.yaml`).
- Defaults include `sans` (Roboto/Inter), `serif` (Merriweather), `mono` (Roboto Mono).

#### `fontSizes`
**Type:** `Map<String, double>`
**Usage:** `text-xs`, `text-sm`, `text-base`, `text-lg`, `text-xl`...
Defines font sizes in pixels.

#### `fontWeights`
**Type:** `Map<String, FontWeight>`
**Usage:** `font-thin`, `font-bold`, `font-black`...
Defines font weights.

#### `tracking` (Letter Spacing)
**Type:** `Map<String, double>`
**Usage:** `tracking-tighter`, `tracking-wide`, `tracking-widest`
Defines letter spacing values.

#### `leading` (Line Height)
**Type:** `Map<String, double>`
**Usage:** `leading-none`, `leading-tight`, `leading-relaxed`
Defines line heights relative to the font size or fixed values.

### Colors & Backgrounds

#### `colors`
**Type:** `Map<String, MaterialColor>`
**Usage:** `text-red-500`, `bg-blue-100`, `border-gray-200`
The core color palette. Simple `Color` values are automatically converted to `MaterialColor` steps (50-900).

#### `opacities`
**Type:** `Map<String, double>`
**Usage:** `opacity-0`, `opacity-50`, `opacity-100`
Defines opacity levels (0.0 to 1.0).

### Borders & Rings

#### `borderWidths`
**Type:** `Map<String, double>`
**Usage:** `border`, `border-2`, `border-4`
Defines border widths in pixels.

#### `borderRadius`
**Type:** `Map<String, double>`
**Usage:** `rounded`, `rounded-md`, `rounded-full`
Defines border radius values.

#### `ringWidths`
**Type:** `Map<String, double>`
**Usage:** `ring`, `ring-2`, `ring-4`
Defines the width of the ring (box-shadow outline).

#### `ringOffsets`
**Type:** `Map<String, double>`
**Usage:** `ring-offset-1`, `ring-offset-2`
Defines the offset width between the element and the ring.

#### `ringColor`
**Type:** `Color`
**Default:** `Color(0xFF3B82F6)` (Tailwind Blue 500)
The default color used for rings when no color is specified (e.g., just `ring-4`).

### Layout & Sizing

#### `screens`
**Type:** `Map<String, int>`
**Usage:** `sm:`, `md:`, `lg:`, `xl:`, `2xl:`
Defines responsive breakpoints (min-width in pixels).

#### `containers`
**Type:** `Map<String, int>`
**Usage:** `.container` behavior
Defines the max-width of the container at each breakpoint.

#### `zIndices`
**Type:** `Map<String, int>`
**Usage:** `z-0`, `z-50`, `z-auto`
Defines z-index values (used in Stacks).

### Effects & Animation

#### `shadows`
**Type:** `Map<String, List<BoxShadow>>`
**Usage:** `shadow-sm`, `shadow-lg`, `shadow-none`
Defines box shadow styles.

#### `transitionDurations`
**Type:** `Map<String, Duration>`
**Usage:** `duration-150`, `duration-700`
Defines transition durations for animations.

#### `transitionCurves`
**Type:** `Map<String, Curve>`
**Usage:** `ease-in`, `ease-out`, `ease-linear`
Defines animation curves.

#### `animations`
**Type:** `Map<String, WindAnimationType>`
**Usage:** `animate-spin`, `animate-bounce`
Defines predefined animation behaviors (requires internal support or custom implementations).

## Programmatic Access

You can access the theme data programmatically using `WindTheme.of(context)` or the `context.windTheme` extension. `WindThemeData` exposes several utility methods for resolving values.

### `getColor(String colorName, int shade)`
Returns a `Color` from the theme.
- Automatically handles dark mode inversion if `brightness` is `Brightness.dark`.
- Returns `null` if the color/shade doesn't exist.

```dart
final primary = context.windTheme.getColor('blue', 500);
```

### `getOriginalColor(String colorName, int shade)`
Returns the original `Color` ignoring brightness settings (no inversion).

### `getSpacing(String multiplier)`
Calculates a pixel value based on the `baseSpacingUnit` or other tokens.
- **Numbers:** `"4"` → `4 * 4.0 = 16.0`
- **Decimals:** `"1.5"` → `1.5 * 4.0 = 6.0`
- **Container Keys:** `"sm"`, `"md"`, `"lg"` etc. → returns container width.
- **Full:** `"full"` → `double.infinity`
- **Fraction:** `"1/2"` → Not supported here (use `WDiv` layout logic), this method expects multipliers.

```dart
final p4 = context.windTheme.getSpacing('4'); // 16.0
final width = context.windTheme.getSpacing('full'); // double.infinity
```

### `isValidColor(String colorName, {int? shade})`
Checks if a color (and optional shade) exists in the theme configuration.

## Defaults

Wind comes pre-configured with a default theme inspired by Tailwind CSS v3.
- **Colors:** Includes full palette (Slate, Gray, Red, Orange, Amber, Yellow, Lime, Green, Emerald, Teal, Cyan, Sky, Blue, Indigo, Violet, Purple, Fuchsia, Pink, Rose).
- **Screens:** `sm` (640px), `md` (768px), `lg` (1024px), `xl` (1280px), `2xl` (1536px).
- **Spacing:** Base unit is `4.0` pixels.
