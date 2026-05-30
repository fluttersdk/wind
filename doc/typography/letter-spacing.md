# Letter Spacing

Adjust the spacing between characters using predefined named scales or arbitrary pixel values. Letter spacings can also be [customized in the theme](../customization/letter-spacing.md).

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Responsive Design](#responsive-design)
- [Arbitrary Values](#arbitrary-values)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<x-preview path="typography/letter_spacing" size="md" source="example/lib/pages/typography/letter_spacing.dart"></x-preview>

```dart
WText('Wide letter spacing', className: 'tracking-wide text-lg text-gray-700 dark:text-gray-300');
WText('Custom spacing', className: 'tracking-[0.13] text-base text-blue-500 dark:text-blue-300');
```

<a name="basic-usage"></a>
## Basic Usage

Apply letter spacing with the `tracking-` prefix followed by a named key:

```dart
WText('Compact label', className: 'tracking-tighter text-sm');
WText('Spacious heading', className: 'tracking-wider text-2xl font-semibold');
```

<a name="quick-reference"></a>
## Quick Reference

Values are defined in em units and multiplied by the Pixel Factor (default: 4) to produce a pixel value.

| Class | em value | Default px | Description |
|:------|:---------|:-----------|:------------|
| `tracking-tighter` | -0.05 | -0.2px | Very tight spacing |
| `tracking-tight` | -0.025 | -0.1px | Tight spacing |
| `tracking-normal` | 0 | 0px | Default spacing |
| `tracking-wide` | 0.025 | 0.1px | Wide spacing |
| `tracking-wider` | 0.05 | 0.2px | Very wide spacing |
| `tracking-widest` | 0.1 | 0.4px | Extremely wide spacing |

<a name="responsive-design"></a>
## Responsive Design

Combine with breakpoint prefixes for viewport-dependent letter spacing:

```dart
WText('Heading', className: 'tracking-normal md:tracking-wide lg:tracking-wider');
```

<a name="arbitrary-values"></a>
## Arbitrary Values

Use bracket notation to set a precise pixel value not in the predefined scale:

```dart
WText('Custom tracking', className: 'tracking-[0.13]');
WText('Negative tracking', className: 'tracking-[-0.03]');
```

<a name="customizing-theme"></a>
## Customizing Theme

Add or override letter spacing keys with `WindTheme.setLetterSpacing(key, emValue)`:

```dart
WindTheme.setLetterSpacing('loose', 0.15);
// tracking-loose = 0.15 * 4 (pixel factor) = 0.6px
WText('Loose tracking', className: 'tracking-loose');
```

See [Customizing Letter Spacing](../customization/letter-spacing.md) for full details.

<a name="related-documentation"></a>
## Related Documentation

- [Font Size](font-size.md) — set text size.
- [Line Height](line-height.md) — spacing between lines.
- [Customizing Letter Spacing](../customization/letter-spacing.md) — override the default scale.
- [Pixel Factor](../customization/pixel-factor.md) — how em values translate to pixels.
