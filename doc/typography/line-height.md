# Line Height

Control the vertical spacing between lines of text. Line heights can also be [customized in the theme](../customization/line-height.md).

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Responsive Design](#responsive-design)
- [Arbitrary Values](#arbitrary-values)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<x-preview path="typography/line_height" size="md" source="example/lib/pages/typography/line_height.dart"></x-preview>

```dart
WText('Comfortable spacing', className: 'text-lg leading-6');
WText('Custom spacing', className: 'text-lg leading-[1.3]');
```

<a name="basic-usage"></a>
## Basic Usage

In Flutter, line height is a multiplier applied to the font size. A value of `1.5` on a `16px` font produces `24px` of line height. Apply it with the `leading-` prefix:

```dart
WText(
  'Body paragraph text with comfortable line height.',
  className: 'text-base leading-normal text-gray-800 dark:text-gray-200',
);
```

<a name="quick-reference"></a>
## Quick Reference

| Class | Multiplier | Description |
|:------|:-----------|:------------|
| `leading-3` | 0.75 | Compact |
| `leading-4` | 1.0 | Standard compact |
| `leading-5` | 1.25 | Slightly expanded |
| `leading-6` | 1.5 | Comfortable |
| `leading-7` | 1.75 | Spacious |
| `leading-8` | 2.0 | Very spacious |
| `leading-9` | 2.25 | Extra spacious |
| `leading-10` | 2.5 | Maximum spaciousness |
| `leading-none` | 1.0 | No extra spacing |
| `leading-tight` | 1.25 | Tight spacing |
| `leading-snug` | 1.375 | Snug spacing |
| `leading-normal` | 1.5 | Normal spacing |
| `leading-relaxed` | 1.625 | Relaxed spacing |
| `leading-loose` | 2.0 | Loose spacing |

<a name="responsive-design"></a>
## Responsive Design

Combine with breakpoint prefixes to adjust line height per screen size:

```dart
WText('Body', className: 'leading-snug md:leading-normal lg:leading-relaxed');
```

<a name="arbitrary-values"></a>
## Arbitrary Values

Use bracket notation to set a precise multiplier not in the predefined scale:

```dart
WText('Custom line height', className: 'text-base leading-[1.3]');
// 16px * 1.3 = 20.8px line height
```

<a name="customizing-theme"></a>
## Customizing Theme

Add or override line height keys with `WindTheme.setLineHeight(key, multiplier)`:

```dart
WindTheme.setLineHeight('comfortable', 1.6);
WText('Custom leading', className: 'leading-comfortable');
```

See [Customizing Line Height](../customization/line-height.md) for full details.

<a name="related-documentation"></a>
## Related Documentation

- [Font Size](font-size.md) — set text size.
- [Letter Spacing](letter-spacing.md) — spacing between characters.
- [Customizing Line Height](../customization/line-height.md) — override the default scale.
