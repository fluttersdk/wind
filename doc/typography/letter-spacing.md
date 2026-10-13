# Letter Spacing

Utilities for controlling the tracking (letter spacing) of an element.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Which Font Size an em Uses](#which-font-size-an-em-uses)
- [Responsive Design](#responsive-design)
- [Dark Mode](#dark-mode)
- [Arbitrary Values](#arbitrary-values)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

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

Use `tracking-{size}` to control the letter spacing of an element. The named steps are in em, exactly as in Tailwind: a multiple of the font size of the text they apply to, so the same class reads the same on a caption and on a headline.

```dart
WText(
  'The quick brown fox jumps over the lazy dog.',
  className: 'text-sm tracking-wide',
)
```

This spaces 14px text by `14 * 0.025 = 0.35` logical pixels.

<a name="quick-reference"></a>
## Quick Reference

| Class | Value | At 14px (`text-sm`) | At 30px (`text-3xl`) |
|:------|:------|:--------------------|:---------------------|
| `tracking-tighter` | -0.05em | -0.7 | -1.5 |
| `tracking-tight` | -0.025em | -0.35 | -0.75 |
| `tracking-normal` | 0em | 0 | 0 |
| `tracking-wide` | 0.025em | 0.35 | 0.75 |
| `tracking-wider` | 0.05em | 0.7 | 1.5 |
| `tracking-widest` | 0.1em | 1.4 | 3.0 |

<a name="which-font-size-an-em-uses"></a>
## Which Font Size an em Uses

Flutter's `TextStyle.letterSpacing` is in logical pixels, so Wind multiplies the em by the size the text actually renders at, in this order:

1. The `text-*` size in the same className, including a responsive or state variant (`text-sm md:text-3xl`). On `WText`, a `textStyle:` font size wins over both, because it is what the text renders at.
2. The font size the element inherits from the nearest `DefaultTextStyle` (a parent `WDiv` with a `text-*` class publishes one, and so does a Material ancestor).
3. The theme's `base` font size (`WindThemeData.fontSizes['base']`, 16 by default).

`WInput` skips the second and third steps: `EditableText` reads no `DefaultTextStyle`, so a field with no `text-*` size paints at Flutter's `kDefaultFontSize` (14) and its em resolves there.

The em is taken from the unscaled font size. Flutter scales `fontSize` by the accessibility `TextScaler` but leaves `letterSpacing` as written, so under large text the spacing is a smaller share of the glyph than the em says.

A `WDiv` or `WButton` resolves its tracking at its own font size and publishes the result in pixels, the way CSS computes `letter-spacing`. A child with a different `text-*` size inherits those pixels, not the em; give the child its own `tracking-*` when it should scale.

```dart
WDiv(
  className: 'text-xs uppercase tracking-widest',
  children: [
    WText('Section'), // 12 * 0.1 = 1.2
  ],
)
```

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

If the built-in scale doesn't meet your needs, use bracket notation to apply custom values directly. An `em` value scales with the font size like the named steps; a `px` value or a bare number is logical pixels, as it is in `leading-[24]` and `text-[20]`. Both take a negative sign.

```dart
// -0.02em of 30px: letterSpacing -0.6
WText('Headline', className: 'text-3xl tracking-[-0.02em]')

// Exactly 3 logical pixels at any size
WText('Custom Spacing', className: 'tracking-[3px]')
```

<a name="customizing-theme"></a>
## Customizing Theme

To retune the scale, override its keys through the `tracking` property in `WindThemeData`. The values are em multipliers, like the defaults: `0.05` is 5% of the font size, never 0.05 logical pixels.

```dart
WindThemeData(
  tracking: {
    'tight': -0.02,
    'widest': 0.15,
  },
)
```

> [!NOTE]
> Only the six named keys (`tighter` through `widest`) parse as classes. A new key such as `tracking-mega` is not recognised; use an arbitrary value like `tracking-[0.2em]` instead.

<a name="related-documentation"></a>
## Related Documentation

- [Font Size](./font-size.md)
- [Line Height](./line-height.md)
- [Font Weight](./font-weight.md)
