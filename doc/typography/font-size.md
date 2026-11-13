# Font Size

Utilities for controlling the font size of an element.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Variants](#variants)
- [Responsive Design](#responsive-design)
- [Dark Mode](#dark-mode)
- [Arbitrary Values](#arbitrary-values)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<x-preview path="typography/font_size" size="md" source="example/lib/pages/typography/font_size.dart"></x-preview>

```dart
WText('Small text', className: 'text-sm')
WText('Large text', className: 'text-lg')
WText('Extra large', className: 'text-xl')
```

<a name="basic-usage"></a>
## Basic Usage

Use `text-{size}` to set the font size of an element.

```dart
WText(
  'The quick brown fox jumps over the lazy dog.',
  className: 'text-base',
)

WText(
  'Main Heading',
  className: 'text-4xl font-bold',
)
```

<a name="quick-reference"></a>
## Quick Reference

| Class | Size | Pixel Value |
|:------|:-----|:------------|
| `text-xs` | 0.75rem | 12px |
| `text-sm` | 0.875rem | 14px |
| `text-base` | 1rem | 16px |
| `text-lg` | 1.125rem | 18px |
| `text-xl` | 1.25rem | 20px |
| `text-2xl` | 1.5rem | 24px |
| `text-3xl` | 1.875rem | 30px |
| `text-4xl` | 2.25rem | 36px |
| `text-5xl` | 3rem | 48px |
| `text-6xl` | 3.75rem | 60px |

> For sizes beyond `text-6xl`, use the arbitrary-value syntax (`text-[80px]`) or extend `WindThemeData.fontSizes` with additional entries.

<a name="variants"></a>
## Variants

### Line Height Modifier

You can set the line height simultaneously by adding a forward slash and a line-height value to any font size utility.

This supports numeric spacing values and arbitrary pixel values. A named line height (`text-lg/loose`) is stored as pixels, not as a multiplier, so use `leading-loose` for a named one.

```dart
// Numeric spacing (text-base + 28px line height)
// 7 * 4px = 28px
WText('Spaced text', className: 'text-base/7')

// Arbitrary line height
WText('Precise text', className: 'text-xl/[32px]')
```

| Class | Size | Line Height |
|:------|:-----|:------------|
| `text-sm/6` | 14px | 24px |
| `text-base/7` | 16px | 28px |
| `text-xl/[32px]` | 20px | 32px |

<a name="responsive-design"></a>
## Responsive Design

Apply different font sizes at different breakpoints using the standard `sm:`, `md:`, `lg:`, `xl:`, and `2xl:` prefixes.

```dart
WText(
  'Responsive Text',
  className: 'text-sm md:text-base lg:text-xl',
)
```

<a name="dark-mode"></a>
## Dark Mode

Use the `dark:` prefix to apply different font sizes when the application is in dark mode.

```dart
WText(
  'Dynamic Sizing',
  className: 'text-base dark:text-lg',
)
```

<a name="arbitrary-values"></a>
## Arbitrary Values

If the built-in scale doesn't meet your needs, use bracket notation to apply custom values directly.

```dart
// Exact pixel value
WText('15px text', className: 'text-[15px]')

// rem is read as px, so write px
WText('24px text', className: 'text-[24px]')
```

<a name="customizing-theme"></a>
## Customizing Theme

To extend or override the default font size scale, modify the `fontSizes` property in `WindThemeData`.

```dart
WindThemeData(
  fontSizes: {
    // Override existing
    'xs': 10.0,
    
    // Add new custom size
    'mega': 100.0,
  },
)
```

Usage:

```dart
WText('Tiny text', className: 'text-xs') // 10.0
WText('Huge text', className: 'text-mega') // 100.0
```

<a name="related-documentation"></a>
## Related Documentation

- [Font Weight](./font-weight.md)
- [Line Height](./line-height.md)
- [Text Colour](./text-color.md)

> **Defaults:** the scale runs from `xs` (12px) to `6xl` (60px).
