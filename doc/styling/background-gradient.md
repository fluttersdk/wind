# Background Gradient

Utilities for creating linear gradients with customizable directions and color stops.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Variants](#variants)
- [Responsive Design](#responsive-design)
- [Dark Mode](#dark-mode)
- [Arbitrary Values](#arbitrary-values)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<x-preview path="styling/background_gradient_basic" size="md" source="example/lib/pages/styling/background_gradient_basic.dart"></x-preview>

```dart
// Basic gradient from cyan to blue
WDiv(className: 'bg-gradient-to-r from-cyan-500 to-blue-500')

// Three-color gradient
WDiv(className: 'bg-gradient-to-r from-indigo-500 via-purple-500 to-pink-500')
```

## Basic Usage

To create a gradient, you need to specify a direction (e.g., `bg-gradient-to-r`) and at least a starting color (`from-*`). Wind will create a linear gradient based on these parameters.

```dart
WDiv(
  className: 'h-24 bg-gradient-to-r from-cyan-500 to-blue-500',
  child: WText('Gradient Background'),
)
```

If you only provide a `from` color, the gradient will fade to transparent by default. If you provide `to` but no `from`, it will also handle it gracefully, but standard usage typically defines both or relies on the fade-to-transparent behavior.

## Quick Reference

| Class | Description |
|:------|:------------|
| `bg-gradient-to-t` | Gradient to top |
| `bg-gradient-to-tr` | Gradient to top right |
| `bg-gradient-to-r` | Gradient to right |
| `bg-gradient-to-br` | Gradient to bottom right |
| `bg-gradient-to-b` | Gradient to bottom |
| `bg-gradient-to-bl` | Gradient to bottom left |
| `bg-gradient-to-l` | Gradient to left |
| `bg-gradient-to-tl` | Gradient to top left |
| `from-{color}` | Starting color |
| `via-{color}` | Middle color |
| `to-{color}` | Ending color |

## Variants

### Gradient Stops

Use `from-*`, `via-*`, and `to-*` utilities to define the color stops of your gradient.

<x-preview path="styling/background_gradient_stops" size="md" source="example/lib/pages/styling/background_gradient_stops.dart"></x-preview>

```dart
// Start color only (fades to transparent)
WDiv(className: 'bg-gradient-to-r from-green-400')

// Start and end colors
WDiv(className: 'bg-gradient-to-r from-green-400 to-blue-500')

// Start, middle, and end colors
WDiv(className: 'bg-gradient-to-r from-green-400 via-blue-500 to-purple-600')
```

### Color Opacity

You can control the opacity of gradient colors using the `/opacity` modifier.

```dart
WDiv(className: 'bg-gradient-to-r from-red-500/50 to-red-500/0')
```

## Responsive Design

Apply different gradient directions or colors at different breakpoints using standard responsive prefixes.

```dart
WDiv(className: 'bg-gradient-to-r md:bg-gradient-to-b from-blue-500 to-green-500')
```

## Dark Mode

Use `dark:` to specify different gradient colors for dark mode.

```dart
WDiv(className: 'bg-gradient-to-r from-slate-100 to-slate-200 dark:from-slate-800 dark:to-slate-900')
```

## Arbitrary Values

If you need specific hex colors that aren't in your theme, use square bracket notation.

```dart
WDiv(className: 'bg-gradient-to-r from-[#1da1f2] to-[#1a91da]')
```

## Customizing Theme

Gradient colors use your theme's color palette. To add new colors, update the `colors` key in `WindThemeData`.

```dart
WindThemeData(
  colors: {
    'brand': {
      '500': Color(0xFF1DA1F2),
      '600': Color(0xFF1A91DA),
    },
  },
)
```

Then use them in your gradients:

```dart
WDiv(className: 'bg-gradient-to-r from-brand-500 to-brand-600')
```

## Related Documentation

- [Background Color](./background-color.md)
- [Background Image](./background-image.md)
