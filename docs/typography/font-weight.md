# Font Weight

Utilities for controlling the font weight of an element.

<x-preview path="typography/font_weight" size="md" source="example/lib/pages/typography/font_weight.dart"></x-preview>

## Basic Usage

Control font weight using `font-{weight}` utilities:

```dart
WText('Thin text', className: 'font-thin')
WText('Light text', className: 'font-light')
WText('Normal text', className: 'font-normal')
WText('Medium text', className: 'font-medium')
WText('Semibold text', className: 'font-semibold')
WText('Bold text', className: 'font-bold')
WText('Extrabold text', className: 'font-extrabold')
WText('Black text', className: 'font-black')
```

## All Font Weights

| Class | Weight |
| :--- | :--- |
| `font-thin` | 100 |
| `font-extralight` | 200 |
| `font-light` | 300 |
| `font-normal` | 400 |
| `font-medium` | 500 |
| `font-semibold` | 600 |
| `font-bold` | 700 |
| `font-extrabold` | 800 |
| `font-black` | 900 |

## Arbitrary Values

For custom font weights, use the bracket notation:

```dart
WText('Custom weight', className: 'font-[700]')
WText('Variable weight', className: 'font-[550]')
```

## Customizing Theme

Override or extend font weights in `WindThemeData`:

```dart
WindThemeData(
  fontWeights: {
    'heavy': FontWeight.w900,
    'custom': FontWeight.w450,  // variable font
  }
)
```

Usage: `font-heavy`

## Related Documentation

- [Font Size](./font-size.md) - Font size utilities
- [Font Family](./font-family.md) - Font family utilities
