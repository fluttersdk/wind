# Text Color

Utilities for controlling the text color of an element.

<x-preview path="typography/colors" size="md" source="example/lib/pages/typography/colors.dart"></x-preview>

## Basic Usage

Control text color using `text-{color}-{shade}` utilities:

```dart
WText('Red text', className: 'text-red-500')
WText('Blue text', className: 'text-blue-600')
WText('Gray text', className: 'text-gray-400')
WText('Black text', className: 'text-black')
WText('White text', className: 'text-white')
```

## Color Shades

Each color has shades from 50 (lightest) to 950 (darkest):

```dart
WText('Light', className: 'text-blue-50')
WText('Default', className: 'text-blue-500')
WText('Dark', className: 'text-blue-900')
```

## Color Opacity

Control text color opacity with the `/` modifier:

```dart
WText('50% opacity', className: 'text-red-500/50')
WText('25% opacity', className: 'text-blue-500/25')
WText('Custom', className: 'text-green-500/[0.35]')
```

| Class | Result |
| :--- | :--- |
| `text-red-500/50` | 50% opacity |
| `text-blue-500/25` | 25% opacity |
| `text-green-500/[0.35]` | 35% opacity |

## Arbitrary Values

For custom colors, use the bracket notation:

```dart
WText('Hex color', className: 'text-[#FF00FF]')
WText('Short hex', className: 'text-[#F0F]')
```

## Hover States

Change color on hover with `WAnchor`:

```dart
WAnchor(
  onTap: () {},
  child: WText(
    'Hover me',
    className: 'text-gray-500 hover:text-blue-500',
  ),
)
```

## Customizing Theme

Extend the color palette in `WindThemeData`:

```dart
WindThemeData(
  colors: {
    'brand': Colors.blue,
    'accent': Colors.orange,
  },
)
```

Usage: `text-brand-500`, `text-accent`

## Related Documentation

- [Background Color](../backgrounds/colors.md) - Background color utilities
