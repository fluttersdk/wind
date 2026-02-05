# WSvg

A utility-first SVG component with fill, stroke color, sizing, and parent inheritance (like WIcon).

<x-preview path="svg/svg_basic" size="md" source="example/lib/pages/svg/svg_basic.dart"></x-preview>

## Basic Usage

Load SVGs from assets or inline strings:

```dart
// From asset
WSvg(
  src: 'assets/icons/star.svg',
  className: 'fill-yellow-500 w-8 h-8',
)

// Inline SVG
WSvg.string('<svg>...</svg>', className: 'fill-red-500 text-xl')
```

## Fill Color

Colorize filled SVGs with `fill-{color}`:

```dart
WSvg(src: '...', className: 'fill-red-500 w-6 h-6')
WSvg(src: '...', className: 'fill-[#ff5500] w-6 h-6')
WSvg(src: '...', className: 'fill-blue-500/50 w-6 h-6')  // With opacity
```

## Stroke Color

For outlined SVGs with `stroke="currentColor"`:

```dart
WSvg(src: '...', className: 'stroke-blue-500 w-8 h-8')
WSvg(src: '...', className: 'stroke-red-500 w-8 h-8')
```

## Sizing

### Text Size Classes

Like WIcon, use text size classes for proportional sizing:

```dart
className: 'fill-gray-500 text-sm'   // 14px
className: 'fill-gray-500 text-lg'   // 18px
className: 'fill-gray-500 text-xl'   // 20px
className: 'fill-gray-500 text-2xl'  // 24px
```

### Pixel Size

For exact dimensions:

```dart
className: 'fill-gray-500 w-8 h-8'   // 32px
className: 'fill-gray-500 w-12 h-12' // 48px
```

## Parent Inheritance

Inherits color and size from parent's `DefaultTextStyle`:

```dart
WDiv(
  className: 'text-red-500 text-xl',
  children: [
    WSvg(src: 'heart.svg'),  // Inherits red + xl
    WText('Liked'),
  ],
)
```

## Props

| Prop | Type | Description |
| :--- | :--- | :--- |
| `src` | `String?` | Asset path |
| `svgString` | `String?` | Inline SVG via `WSvg.string()` |
| `className` | `String?` | Utility classes |
| `states` | `Set<String>?` | Active states |
| `semanticsLabel` | `String?` | Accessibility label |

## All Supported Classes

| Category | Classes | Description |
| :--- | :--- | :--- |
| **Fill** | `fill-{color}`, `fill-none`, `fill-current` | Fill color |
| **Stroke** | `stroke-{color}` | Stroke color |
| **Text Color** | `text-{color}` | Fallback color (if no fill/stroke) |
| **Size** | `w-{n}`, `h-{n}` | Pixel dimensions |
| **Text Size** | `text-{size}` | Font-relative sizing |
| **Opacity** | `opacity-{n}` | Opacity (0-100) |
| **Transition** | `duration-{ms}`, `ease-{curve}` | Animated opacity transitions |

> **Color Priority:** `stroke-{color}` > `fill-{color}` > `text-{color}` > inherited from parent

> **Size Priority:** `w-{n}` / `h-{n}` > `text-{size}` > inherited from parent

## Related Documentation

- [WIcon](./w-icon.md) - Icon component with similar inheritance
- [WImage](./w-image.md) - Image component
- [Colors](../styling/colors.md) - Available color utilities
