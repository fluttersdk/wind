# Font Size

Control text size with predefined named scales or arbitrary pixel values. Font sizes can also be [customized in the theme](../customization/font-size.md) for maximum flexibility.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Responsive Design](#responsive-design)
- [Arbitrary Values](#arbitrary-values)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<x-preview path="typography/font_size" size="md" source="example/lib/pages/typography/font_size.dart"></x-preview>

```dart
WText('Extra Small Text', className: 'text-xs');   // 12px
WText('Base Text', className: 'text-base');         // 16px
WText('Large Text', className: 'text-lg');          // 18px
WText('Gigantic Text', className: 'text-6xl');      // 64px
```

<a name="basic-usage"></a>
## Basic Usage

Apply font sizes using the `text-` prefix followed by a named size key:

```dart
WText('Small label', className: 'text-sm');
WText('Body text', className: 'text-base');
WText('Section heading', className: 'text-2xl font-bold');
```

<a name="quick-reference"></a>
## Quick Reference

Predefined sizes are stored in rem units and resolved against the REM factor (`WindTheme.getRemFactor()`, which is pixel factor × 4 = 16 by default). The final size is calculated as:

```
Size (rem) × REM factor (16 by default) = Final size in px
```

| Class | REM | Default px | Description |
|:------|:----|:-----------|:------------|
| `text-xs` | 0.75 | 12px | Extra small |
| `text-sm` | 0.875 | 14px | Small |
| `text-base` | 1.0 | 16px | Base size |
| `text-lg` | 1.125 | 18px | Large |
| `text-xl` | 1.25 | 20px | Extra large |
| `text-2xl` | 1.5 | 24px | Very large |
| `text-3xl` | 1.875 | 30px | Extra extra large |
| `text-4xl` | 2.25 | 36px | Huge |
| `text-5xl` | 3.0 | 48px | Massive |
| `text-6xl` | 4.0 | 64px | Gigantic |

<a name="responsive-design"></a>
## Responsive Design

Combine size classes with breakpoint prefixes to adjust text size per screen width:

```dart
WText('Responsive heading', className: 'text-base md:text-xl lg:text-3xl');
```

<a name="arbitrary-values"></a>
## Arbitrary Values

Use bracket notation to set any pixel size not in the predefined scale. The value is treated as raw pixels:

```dart
WText('Custom 22px text', className: 'text-[22]');
WText('Tiny 8px label', className: 'text-[8]');
```

<a name="customizing-theme"></a>
## Customizing Theme

Add or override font size keys with `WindTheme.setFontSize(key, remValue)`:

```dart
WindTheme.setFontSize('giant', 5);
// Now text-giant = 5 × 16 (rem factor) = 80px at the default factor
WText('Giant text', className: 'text-giant');
```

See [Customizing Font Sizes](../customization/font-size.md) for full details.

<a name="related-documentation"></a>
## Related Documentation

- [Font Weight](font-weight.md) — control text thickness.
- [Font Style](font-style.md) — italic and normal styles.
- [Line Height](line-height.md) — spacing between lines.
- [Customizing Font Sizes](../customization/font-size.md) — override the default scale.
- [Pixel Factor](../customization/pixel-factor.md) — how rem values translate to pixels.
