# Line Height

Utilities for controlling the leading (line height) of an element.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Responsive Design](#responsive-design)
- [Dark Mode](#dark-mode)
- [Arbitrary Values](#arbitrary-values)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<x-preview path="typography/line_height" size="md" source="example/lib/pages/typography/line_height.dart"></x-preview>

```dart
// Relative line-heights
WText('Leading none', className: 'leading-none')
WText('Leading loose', className: 'leading-loose')

// Fixed line-heights
WText('Leading 6', className: 'leading-6')
```

## Basic Usage

Use `leading-{value}` to control the line height of an element. Relative line heights (like `normal`, `loose`) depend on the font size, while fixed line heights (like `leading-6`) set a specific height independent of the font size.

```dart
WDiv(
  className: 'max-w-md mx-auto bg-white rounded-xl shadow-md overflow-hidden md:max-w-2xl',
  child: WDiv(
    className: 'p-8',
    child: WText(
      'The quick brown fox jumps over the lazy dog.',
      className: 'leading-loose text-gray-900',
    ),
  ),
)
```

> [!NOTE]
> You can also set line height directly within the font size utility, e.g., `text-lg/7` or `text-lg/loose`. See [Font Size](./font-size.md) for details.

## Quick Reference

| Class | Value | Description |
|:--- |:--- |:--- |
| `leading-none` | 1 | Relative height |
| `leading-tight` | 1.25 | Relative height |
| `leading-snug` | 1.375 | Relative height |
| `leading-normal` | 1.5 | Relative height |
| `leading-relaxed` | 1.625 | Relative height |
| `leading-loose` | 2 | Relative height |
| `leading-3` | 0.75rem | Fixed height (12px) |
| `leading-4` | 1rem | Fixed height (16px) |
| `leading-5` | 1.25rem | Fixed height (20px) |
| `leading-6` | 1.5rem | Fixed height (24px) |
| `leading-7` | 1.75rem | Fixed height (28px) |
| `leading-8` | 2rem | Fixed height (32px) |
| `leading-9` | 2.25rem | Fixed height (36px) |
| `leading-10` | 2.5rem | Fixed height (40px) |

## Responsive Design

Apply different line height values at different breakpoints using the standard `sm:`, `md:`, `lg:`, `xl:`, and `2xl:` prefixes.

```dart
WText(
  'Responsive leading',
  className: 'leading-none md:leading-normal lg:leading-loose',
)
```

## Dark Mode

Use the `dark:` prefix to apply different line heights when the application is in dark mode.

```dart
WText(
  'Dark mode leading',
  className: 'leading-normal dark:leading-loose',
)
```

## Arbitrary Values

If the built-in scale doesn't meet your needs, use bracket notation to apply custom values directly.

```dart
// Fixed pixel value
WText('Custom px', className: 'leading-[24px]')

// Relative value (unitless)
WText('Custom relative', className: 'leading-[1.8]')

// Rem value
WText('Custom rem', className: 'leading-[3rem]')
```

## Customizing Theme

To extend or override the default line height scale, modify the `leading` property in `WindThemeData`.

```dart
WindThemeData(
  leading: {
    'tighter': 1.1,
    'double': 2.0,
    // Overriding existing
    'loose': 2.5,
  },
)
```

## Related Documentation

- [Font Size](./font-size.md) - Setting font size and line height together
- [Letter Spacing](./letter-spacing.md) - Controlling tracking (letter spacing)
