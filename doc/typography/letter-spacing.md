# Letter Spacing

Utilities for controlling the tracking (letter spacing) of an element.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Responsive Design](#responsive-design)
- [Dark Mode](#dark-mode)
- [Arbitrary Values](#arbitrary-values)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<!-- TODO: [VERIFY] path="typography/letter_spacing" action="VERIFY" -->
<!-- Description: Verify this example demonstrates tighter, normal, and widest tracking variations -->
<x-preview path="typography/letter_spacing" size="md" source="example/lib/pages/typography/letter_spacing.dart"></x-preview>

```dart
WDiv(
  className: 'flex flex-col gap-4',
  children: [
    WText('Tight letter spacing', className: 'tracking-tight'),
    WText('Normal letter spacing', className: 'tracking-normal'),
    WText('Wide letter spacing', className: 'tracking-wide'),
  ],
)
```

<a name="basic-usage"></a>
## Basic Usage

Use `tracking-{size}` to control the letter spacing of an element.

```dart
WText(
  'The quick brown fox jumps over the lazy dog.',
  className: 'tracking-wide',
)
```

<a name="quick-reference"></a>
## Quick Reference

| Class | Value | Description |
|:------|:------|:------------|
| `tracking-tighter` | -2.0 | Tighter than default spacing |
| `tracking-tight` | -1.0 | Slightly tighter spacing |
| `tracking-normal` | 0.0 | Standard spacing (default) |
| `tracking-wide` | 1.0 | Slightly wider spacing |
| `tracking-wider` | 2.0 | Wider than default spacing |
| `tracking-widest` | 4.0 | Widest available spacing |

<a name="responsive-design"></a>
## Responsive Design

Apply different letter spacing at different breakpoints using the standard `sm:`, `md:`, `lg:`, `xl:`, and `2xl:` prefixes.

```dart
WText(
  'Responsive Tracking',
  className: 'tracking-normal md:tracking-wide lg:tracking-widest',
)
```

<a name="dark-mode"></a>
## Dark Mode

Use the `dark:` prefix to apply different tracking when the application is in dark mode.

```dart
WText(
  'Dark Mode Tracking',
  className: 'tracking-normal dark:tracking-wide',
)
```

<a name="arbitrary-values"></a>
## Arbitrary Values

If the built-in scale doesn't meet your needs, use bracket notation to apply custom values directly.

```dart
// Sets letterSpacing to 3px
WText(
  'Custom Spacing',
  className: 'tracking-[3px]',
)
```

<a name="customizing-theme"></a>
## Customizing Theme

To extend or override the default tracking scale, modify the `tracking` property in `WindThemeData`.

```dart
WindThemeData(
  tracking: {
    'extra-wide': 6.0,
    'mega': 8.0,
  },
)
```

Then use it in your code:

```dart
WText('Mega Spacing', className: 'tracking-mega')
```

<a name="related-documentation"></a>
## Related Documentation

- [Font Size](./font-size.md)
- [Line Height](./line-height.md)
- [Font Weight](./font-weight.md)
