# Font Style

Toggle between italic and normal text style using simple class names.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Responsive Design](#responsive-design)
- [Related Documentation](#related-documentation)

<x-preview path="typography/font_style" size="md" source="example/lib/pages/typography/font_style.dart"></x-preview>

```dart
WText('Italic Text', className: 'italic');
WText('Normal Text', className: 'not-italic');
```

<a name="basic-usage"></a>
## Basic Usage

Apply `italic` to make text italicized, or `not-italic` to reset it to the normal font style:

```dart
WText('Important note', className: 'italic text-gray-700 dark:text-gray-300');
WText('Regular text', className: 'not-italic');
```

<a name="quick-reference"></a>
## Quick Reference

| Class | Flutter `FontStyle` | Description |
|:------|:--------------------|:------------|
| `italic` | `FontStyle.italic` | Renders text in italic. |
| `not-italic` | `FontStyle.normal` | Resets text to normal style. |

<a name="responsive-design"></a>
## Responsive Design

Combine with breakpoint prefixes to apply italic only at certain screen sizes:

```dart
WText('Responsive italic', className: 'not-italic md:italic');
```

<a name="related-documentation"></a>
## Related Documentation

- [Font Size](font-size.md) — set text size.
- [Font Weight](font-weight.md) — control text thickness.
- [Text Decoration](text-decoration.md) — underline, overline, and strikethrough.
