# Text Alignment

Control the horizontal alignment of text content using predefined alignment classes.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Responsive Design](#responsive-design)
- [Related Documentation](#related-documentation)

<x-preview path="typography/text_alignment" size="md" source="example/lib/pages/typography/text_alignment.dart"></x-preview>

```dart
WText('Left-aligned text', className: 'text-left');
WText('Centered text', className: 'text-center');
WText('Right-aligned text', className: 'text-right');
```

<a name="basic-usage"></a>
## Basic Usage

Apply text alignment with the `text-` prefix followed by an alignment direction:

```dart
WText(
  'Centered heading',
  className: 'text-center text-2xl font-bold text-gray-900 dark:text-gray-100',
);
WText(
  'This paragraph text is justified for a formal appearance.',
  className: 'text-justify text-base text-gray-700 dark:text-gray-300',
);
```

<a name="quick-reference"></a>
## Quick Reference

| Class | Flutter `TextAlign` | Description |
|:------|:--------------------|:------------|
| `text-left` | `TextAlign.left` | Aligns text to the left. |
| `text-center` | `TextAlign.center` | Centers the text. |
| `text-right` | `TextAlign.right` | Aligns text to the right. |
| `text-justify` | `TextAlign.justify` | Justifies the text. |
| `text-start` | `TextAlign.start` | Aligns text to the reading direction start. |
| `text-end` | `TextAlign.end` | Aligns text to the reading direction end. |

<a name="responsive-design"></a>
## Responsive Design

Combine with breakpoint prefixes to change alignment at different screen sizes:

```dart
WText(
  'Responsive alignment',
  className: 'text-center md:text-left',
);
```

<a name="related-documentation"></a>
## Related Documentation

- [Font Size](font-size.md) — set text size.
- [Font Weight](font-weight.md) — control text thickness.
- [Text Color](text-color.md) — apply color to text.
- [WText](../widgets/wtext.md) — the primary text widget.
