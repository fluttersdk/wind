# Font Weight

Utilities for controlling the font weight of an element.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Variants](#variants)
- [Responsive Design](#responsive-design)
- [Dark Mode](#dark-mode)
- [Arbitrary Values](#arbitrary-values)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<x-preview path="typography/font_weight_basic" size="md" source="example/lib/pages/typography/font_weight_basic.dart"></x-preview>

```dart
WDiv(
  className: 'flex flex-col gap-4',
  children: [
    WText('The quick brown fox', className: 'font-light'),
    WText('The quick brown fox', className: 'font-normal'),
    WText('The quick brown fox', className: 'font-bold'),
  ],
)
```

<a name="basic-usage"></a>
## Basic Usage

Control the font weight of an element using the `font-{weight}` utilities.

```dart
WText('Most text uses font-normal', className: 'font-normal')
WText('Important text uses font-bold', className: 'font-bold')
```

<a name="quick-reference"></a>
## Quick Reference

| Class | Weight | Description |
|:------|:-------|:------------|
| `font-thin` | 100 | Thin |
| `font-extralight` | 200 | Extra Light |
| `font-light` | 300 | Light |
| `font-normal` | 400 | Normal |
| `font-medium` | 500 | Medium |
| `font-semibold` | 600 | Semi Bold |
| `font-bold` | 700 | Bold |
| `font-extrabold` | 800 | Extra Bold |
| `font-black` | 900 | Black |

<a name="variants"></a>
## Variants

### Font Style

Control the font style of an element using the `italic` and `not-italic` utilities.

<x-preview path="typography/font_style_basic" size="md" source="example/lib/pages/typography/font_style_basic.dart"></x-preview>

```dart
WText('This text is italicized.', className: 'italic')
WText('This text is normal.', className: 'not-italic')
```

| Class | Style | Description |
|:------|:------|:------------|
| `italic` | `FontStyle.italic` | Renders text in italics |
| `not-italic` | `FontStyle.normal` | Renders text normally (useful for resetting) |

<a name="responsive-design"></a>
## Responsive Design

Apply different font weights at specific breakpoints using standard responsive prefixes.

```dart
// Normal on mobile, bold on medium screens and up
WText('Responsive Weight', className: 'font-normal md:font-bold')
```

<a name="dark-mode"></a>
## Dark Mode

Adjust font weight based on the theme brightness. This is useful for maintaining legibility against dark backgrounds, where lighter weights might appear too thin.

```dart
// Lighter weight in dark mode for better readability
WText('Adaptive Weight', className: 'font-medium dark:font-normal')
```

<a name="arbitrary-values"></a>
## Arbitrary Values

If you need a specific font weight that isn't included in your theme, use square bracket notation.

```dart
// 100 to 999 truncates to the standard weight at or below it (700 -> bold, 550 -> medium); 1000 and above, or below 100, set no weight
WText('Custom Weight', className: 'font-[700]')
WText('Variable Weight', className: 'font-[550]')
```

<a name="customizing-theme"></a>
## Customizing Theme

You can customise the `fontWeights` scale in your `WindThemeData` configuration.

```dart
WindTheme(
  data: WindThemeData(
    fontWeights: {
      'hairline': FontWeight.w100,
      'heavy': FontWeight.w900,
      // Override default
      'bold': FontWeight.w600,
    },
  ),
  child: MyApp(),
)
```

<a name="related-documentation"></a>
## Related Documentation

- [Font Size](./font-size.md)
- [Font Family](./font-family.md)
- [Text Colour](./text-color.md)

<!-- steer probe font-weight -->
