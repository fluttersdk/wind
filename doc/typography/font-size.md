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
| `text-7xl` | 4.5rem | 72px |
| `text-8xl` | 6rem | 96px |
| `text-9xl` | 8rem | 128px |

## Variants

### Line Height Modifier

You can set the line height simultaneously by adding a forward slash and a line-height value to any font size utility.

This supports both named line heights (from your theme) and numeric spacing values.

```dart
// Named line height (text-lg + leading-loose)
WText('Loose text', className: 'text-lg/loose')

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
| `text-lg/relaxed` | 18px | 1.625 (factor) |

## Responsive Design

Apply different font sizes at different breakpoints using the standard `sm:`, `md:`, `lg:`, `xl:`, and `2xl:` prefixes.

```dart
WText(
  'Responsive Text',
  className: 'text-sm md:text-base lg:text-xl',
)
```

## Dark Mode

Use the `dark:` prefix to apply different font sizes when the application is in dark mode.

```dart
WText(
  'Dynamic Sizing',
  className: 'text-base dark:text-lg',
)
```

## Arbitrary Values

If the built-in scale doesn't meet your needs, use bracket notation to apply custom values directly.

```dart
// Exact pixel value
WText('15px text', className: 'text-[15px]')

// Rem value (treated as pixels if no unit provided, or parsed explicitly)
WText('1.5rem text', className: 'text-[1.5rem]')
```

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

## Related Documentation

- [Font Weight](./font-weight.md)
- [Line Height](./line-height.md)
- [Text Color](./text-color.md)
