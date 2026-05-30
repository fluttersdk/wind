# Font Weight

Control the thickness of text using predefined weight names. Font weights can also be [customized in the theme](../customization/font-weight.md).

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Responsive Design](#responsive-design)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<x-preview path="typography/font_weight" size="md" source="example/lib/pages/typography/font_weight.dart"></x-preview>

```dart
WText('Bold Text', className: 'font-bold');
WText('Thin Text', className: 'font-thin');
WText('Black Text', className: 'font-black');
```

<a name="basic-usage"></a>
## Basic Usage

Apply font weights using the `font-` prefix followed by a weight name:

```dart
WText('Normal body text', className: 'font-normal');
WText('Section heading', className: 'font-semibold text-gray-900 dark:text-gray-100');
WText('Strong callout', className: 'font-bold');
```

<a name="quick-reference"></a>
## Quick Reference

| Class | Weight | Flutter `FontWeight` |
|:------|:-------|:---------------------|
| `font-thin` | 100 | `FontWeight.w100` |
| `font-extralight` | 200 | `FontWeight.w200` |
| `font-light` | 300 | `FontWeight.w300` |
| `font-normal` | 400 | `FontWeight.w400` |
| `font-medium` | 500 | `FontWeight.w500` |
| `font-semibold` | 600 | `FontWeight.w600` |
| `font-bold` | 700 | `FontWeight.w700` |
| `font-extrabold` | 800 | `FontWeight.w800` |
| `font-black` | 900 | `FontWeight.w900` |

<a name="responsive-design"></a>
## Responsive Design

Combine weight classes with breakpoint prefixes:

```dart
WText('Heading', className: 'font-normal md:font-semibold lg:font-bold');
```

<a name="customizing-theme"></a>
## Customizing Theme

Override or extend the font weight map with `WindTheme.setFontWeight(key, fontWeight)`:

```dart
WindTheme.setFontWeight('normal', FontWeight.w500);
// All font-normal usages now render at w500
```

See [Customizing Font Weight](../customization/font-weight.md) for full details.

<a name="related-documentation"></a>
## Related Documentation

- [Font Size](font-size.md) — set text size.
- [Font Style](font-style.md) — italic and normal styles.
- [Customizing Font Weight](../customization/font-weight.md) — override the default weight map.
