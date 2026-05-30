# Text Transform

Change the capitalization of text content at render time without modifying the source string.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Responsive Design](#responsive-design)
- [Related Documentation](#related-documentation)

<x-preview path="typography/text_transform" size="md" source="example/lib/pages/typography/text_transform.dart"></x-preview>

```dart
WText('upper case', className: 'uppercase');
WText('LOWER CASE', className: 'lowercase');
WText('capitalize this text', className: 'capitalize');
WText('No transformation here.', className: 'none');
```

<a name="basic-usage"></a>
## Basic Usage

Apply a transform class in the `className` of any text widget. The transformation runs at render time; the original `data` string is never mutated:

```dart
WText('button label', className: 'uppercase font-semibold text-white');
WText('email@example.com', className: 'lowercase text-gray-700 dark:text-gray-300');
WText('first word only', className: 'capitalize');
```

<a name="quick-reference"></a>
## Quick Reference

| Class | Transformation | Description |
|:------|:---------------|:------------|
| `uppercase` | `toUpperCase()` | Converts all characters to uppercase. |
| `lowercase` | `toLowerCase()` | Converts all characters to lowercase. |
| `capitalize` | First char upper, rest lower | Capitalizes the first character of the text. |
| `none` | No change | Leaves the text unchanged. |

<a name="responsive-design"></a>
## Responsive Design

Combine with breakpoint prefixes to apply a transform only at certain screen sizes:

```dart
WText('label text', className: 'none md:uppercase');
```

<a name="related-documentation"></a>
## Related Documentation

- [Font Size](font-size.md) — set text size.
- [Text Color](text-color.md) — apply color to text.
- [Text Decoration](text-decoration.md) — underline, overline, and strikethrough.
- [WText](../widgets/wtext.md) — the primary text widget.
