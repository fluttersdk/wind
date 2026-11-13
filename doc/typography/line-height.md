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
// `leading-none` is not supported yet; use `leading-tight` or override a named key.
WText('Leading tight', className: 'leading-tight')
WText('Leading loose', className: 'leading-loose')

// Fixed line-heights
WText('Leading 6', className: 'leading-6')
```

<a name="basic-usage"></a>
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
> You can also set line height directly within the font size utility, e.g., `text-lg/7` or `text-lg/[28px]`. See [Font Size](./font-size.md) for details.

<a name="quick-reference"></a>
## Quick Reference

| Class | Value | Description |
|:--- |:--- |:--- |
| `leading-none` | none | Not supported yet; use `leading-tight` or override a named key |
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

<a name="responsive-design"></a>
## Responsive Design

Apply different line height values at different breakpoints using the standard `sm:`, `md:`, `lg:`, `xl:`, and `2xl:` prefixes.

```dart
WText(
  'Responsive leading',
  className: 'leading-tight md:leading-normal lg:leading-loose',
)
```

<a name="dark-mode"></a>
## Dark Mode

Use the `dark:` prefix to apply different line heights when the application is in dark mode.

```dart
WText(
  'Dark mode leading',
  className: 'leading-normal dark:leading-loose',
)
```

<a name="arbitrary-values"></a>
## Arbitrary Values

If the built-in scale doesn't meet your needs, use bracket notation to apply custom values directly.

```dart
// Fixed pixel value
WText('Custom px', className: 'text-base leading-[24px]')

// A bare number is also logical pixels
WText('Custom bare number', className: 'text-base leading-[24]')
```

A fixed pixel line height needs a font size on the same widget (`text-base` above): Wind divides the pixels by that size to get Flutter's height factor, and without one the line height is not applied. A size inherited from a parent does not count.

Arbitrary values are logical pixels, not a multiplier. `rem` is not converted: `leading-[1.8]` is 1.8 px and `leading-[3rem]` is 3 px.

<a name="customizing-theme"></a>
## Customizing Theme

To override the named line height scale, modify the `leading` property in `WindThemeData`.

```dart
WindThemeData(
  leading: {
    'loose': 2.5,
  },
)
```

Only the six named keys parse (`none`, `tight`, `snug`, `normal`, `relaxed`, `loose`); override their values, do not add keys. `none` has no default value, so `leading-none` does nothing until you supply one (`'none': 1.0`).

<a name="related-documentation"></a>
## Related Documentation

- [Font Size](./font-size.md) - Setting font size and line height together
- [Letter Spacing](./letter-spacing.md) - Controlling tracking (letter spacing)
