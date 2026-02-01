# Wind Theme Reference

All scales are customizable via `WindThemeData` constructor.

## Colors

Default palette: transparent, black, white, slate, gray, zinc, neutral, stone, red, orange, amber, yellow, lime, green, emerald, teal, cyan, sky, blue, indigo, violet, purple, fuchsia, pink, rose.

Each color has shades: 50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 950.

Add custom colors:
```dart
WindThemeData(colors: {
  ...WindThemeData.defaultColors,
  'primary': {'500': Color(0xFF6366F1), '600': Color(0xFF4F46E5)},
  'brand': {'500': Color(0xFFFF6B00)},
})
```

## Spacing

`baseSpacingUnit` = 4.0 (default). Value N = N * 4px.

Scale: 0, 0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4, 5, 6, 7, 8, 9, 10, 11, 12, 14, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 64, 72, 80, 96

## Screens (breakpoints)

| Prefix | Min-width |
|--------|-----------|
| sm | 640 |
| md | 768 |
| lg | 1024 |
| xl | 1280 |
| 2xl | 1536 |

## Font Sizes

| Key | Size (px) |
|-----|-----------|
| xs | 12 |
| sm | 14 |
| base | 16 |
| lg | 18 |
| xl | 20 |
| 2xl | 24 |
| 3xl | 30 |
| 4xl | 36 |
| 5xl | 48 |
| 6xl | 60 |

## Font Weights

thin:100, extralight:200, light:300, normal:400, medium:500, semibold:600, bold:700, extrabold:800, black:900

## Font Families

| Key | Default |
|-----|---------|
| sans | System default |
| serif | Georgia |
| mono | Monospace |

## Border Radius

| Key | Value (px) |
|-----|------------|
| none | 0 |
| sm | 2 |
| DEFAULT | 4 |
| md | 6 |
| lg | 8 |
| xl | 12 |
| 2xl | 16 |
| 3xl | 24 |
| full | 9999 |

## Shadows

Sizes: sm, DEFAULT, md, lg, xl, 2xl, none

## Ring

Widths: 0, 1, 2, DEFAULT (3), 4, 8
Offsets: 0, 1, 2, 4, 8

## Leading (line-height)

tight:1.25, snug:1.375, normal:1.5, relaxed:1.625, loose:2.0

## Tracking (letter-spacing)

tighter:-2, tight:-1, normal:0, wide:1, wider:2, widest:4

## Max-widths (named)

xs:320, sm:384, md:448, lg:512, xl:576, 2xl:672, 3xl:768, 4xl:896, 5xl:1024, 6xl:1152, 7xl:1280, prose:1040

## API Access

```dart
// Controller (for toggling theme mode, etc.)
final controller = WindTheme.of(context);

// Data (for reading scales)
final data = WindTheme.dataOf(context);
```
