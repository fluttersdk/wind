# Background Color

Utilities for controlling the background color of an element.

<x-preview path="backgrounds/colors" size="md" source="example/lib/pages/backgrounds/colors.dart"></x-preview>

## Basic Usage

Control background color using `bg-{color}-{shade}` utilities:

```dart
WDiv(className: 'bg-red-500 p-4')    // Red background
WDiv(className: 'bg-blue-600 p-4')   // Blue background
WDiv(className: 'bg-green-500 p-4')  // Green background
```

## Color Shades

Each color has shades from 50 (lightest) to 900 (darkest):

```dart
WDiv(className: 'bg-blue-50')   // Very light
WDiv(className: 'bg-blue-500')  // Default
WDiv(className: 'bg-blue-900')  // Very dark
```

| Shade | Description |
| :--- | :--- |
| `50` | Lightest |
| `100-300` | Light |
| `400-600` | Medium |
| `700-900` | Dark |

## Background Opacity

Control background color opacity with the `/` modifier:

```dart
WDiv(className: 'bg-red-500')      // 100% opacity
WDiv(className: 'bg-red-500/75')   // 75% opacity
WDiv(className: 'bg-red-500/50')   // 50% opacity
WDiv(className: 'bg-red-500/25')   // 25% opacity
WDiv(className: 'bg-red-500/10')   // 10% opacity
```

### Arbitrary Opacity

Use bracket notation for precise values:

```dart
WDiv(className: 'bg-blue-500/[0.35]')  // 35% opacity
WDiv(className: 'bg-green-500/[0.8]')  // 80% opacity
```

## Arbitrary Values

For custom colors, use the bracket notation:

```dart
WDiv(className: 'bg-[#1da1f2]')  // Twitter blue
WDiv(className: 'bg-[#FF5733]')  // Custom hex
WDiv(className: 'bg-[#6B5B95]')  // Custom purple
```

## Special Values

| Class | Description |
| :--- | :--- |
| `bg-transparent` | Transparent background |
| `bg-white` | White background |
| `bg-black` | Black background |

## All Classes

| Class | Description |
| :--- | :--- |
| `bg-{color}-{shade}` | Theme color (e.g. `bg-red-500`) |
| `bg-{color}-{shade}/{opacity}` | With opacity (e.g. `bg-red-500/50`) |
| `bg-[#hex]` | Arbitrary hex color |
| `bg-transparent` | Transparent |
| `bg-white` | White |
| `bg-black` | Black |

## Customizing Theme

Extend the color palette in `WindThemeData`:

```dart
WindThemeData(
  colors: {
    'brand': Colors.blue,
    'surface': Color(0xFF1E293B),
  },
)
```

Usage: `bg-brand-500`, `bg-surface`

## Related Documentation

- [Background Gradient](./background-gradient.md) - Gradient backgrounds
- [Text Color](../typography/text-color.md) - Text color utilities
- [Border Color](../borders/borders.md) - Border color utilities
