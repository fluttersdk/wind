# Ring Width, Color, and Offset

Utilities for creating outline rings with box-shadows. These are useful for focus states or highlighting elements without affecting layout.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Variants](#variants)
- [Responsive Design](#responsive-design)
- [Dark Mode](#dark-mode)
- [Arbitrary Values](#arbitrary-values)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<x-preview path="effects/ring_basic" size="md" source="example/lib/pages/effects/ring_basic.dart"></x-preview>

```dart
// Default ring (3px blue-500)
WDiv(className: 'ring')

// Custom width and color
WDiv(className: 'ring-4 ring-red-500')

// With offset
WDiv(className: 'ring-2 ring-offset-2')
```

## Basic Usage

Use `ring-{width}` utilities to apply a solid box-shadow to an element. By default, this adds a 3px blue ring.

> [!NOTE]
> Rings in Wind are implemented using `BoxShadow` with a spread radius and zero blur. They do not take up space in the layout, unlike borders.

```dart
WDiv(
  className: 'ring-4 ring-blue-500 rounded-lg p-4',
  child: WText('Ring Example'),
)
```

## Quick Reference

| Class | Value | Description |
|:------|:------|:------------|
| `ring-0` | 0px | No ring |
| `ring-1` | 1px | 1px ring width |
| `ring-2` | 2px | 2px ring width |
| `ring` | 3px | Default ring width (3px) |
| `ring-4` | 4px | 4px ring width |
| `ring-8` | 8px | 8px ring width |
| `ring-inset` | - | Forces ring to be on the inside |
| `ring-offset-{width}` | - | Simulates an offset by adding a transparent gap |

## Variants

### Ring Color

Use `ring-{color}` to set the color of the ring. You can also use opacity modifiers like `/50`.

<x-preview path="effects/ring_colors" size="md" source="example/lib/pages/effects/ring_colors.dart"></x-preview>

```dart
WDiv(className: 'ring-2 ring-blue-500')
WDiv(className: 'ring-2 ring-red-500/50') // 50% opacity
```

### Ring Offset

Use `ring-offset-{width}` to simulate space between the element and the ring. This is helpful for focus states on colored backgrounds.

```dart
// Creates a 2px gap between the element and the ring
WDiv(className: 'ring-2 ring-offset-2 ring-offset-white')
```

| Class | Value | Description |
|:------|:------|:------------|
| `ring-offset-0` | 0px | No offset |
| `ring-offset-1` | 1px | 1px offset |
| `ring-offset-2` | 2px | 2px offset |
| `ring-offset-4` | 4px | 4px offset |
| `ring-offset-8` | 8px | 8px offset |

### Ring Inset

Use `ring-inset` to force the ring to render on the inside of the element instead of the outside. This is useful for elements that shouldn't overflow their container.

```dart
WDiv(className: 'ring-2 ring-inset ring-pink-500')
```

## Responsive Design

Apply different ring utilities at different breakpoints using the standard `sm:`, `md:`, `lg:`, `xl:`, and `2xl:` prefixes.

```dart
WDiv(className: 'ring-2 md:ring-4 lg:ring-8')
```

## Dark Mode

Use the `dark:` prefix to apply different ring styles when the application is in dark mode.

```dart
WDiv(className: 'ring-slate-900/5 dark:ring-white/10')
```

## Arbitrary Values

If the built-in scale doesn't meet your needs, use bracket notation to apply custom values directly.

```dart
// Custom color
WDiv(className: 'ring-[#50d71e]')

// Custom color with opacity
WDiv(className: 'ring-[#50d71e]/50')
```

> [!NOTE]
> Currently, arbitrary values are supported for **colors only** (`ring-[#hex]`). Arbitrary widths (`ring-[10px]`) are not yet supported in the parser.

## Customizing Theme

To extend or override the default scale for rings, modify the `WindThemeData` in your app root.

```dart
WindTheme(
  data: WindThemeData(
    // Default color when no ring color class is present
    ringColor: Colors.blue, 
    
    // Custom ring widths
    ringWidths: {
      'DEFAULT': 3,
      '6': 6,
      '10': 10,
    },
    
    // Custom offset widths
    ringOffsets: {
      '3': 3,
      '6': 6,
    },
  ),
  child: MyApp(),
)
```

## Related Documentation

- [Borders](./borders.md)
- [Box Shadow](../styling/shadow.md)
