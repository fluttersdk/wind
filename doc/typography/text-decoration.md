# Text Decoration

Apply underline, overline, or strikethrough decorations to text, or remove an inherited decoration.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Responsive Design](#responsive-design)
- [Related Documentation](#related-documentation)

<x-preview path="typography/text_decoration" size="md" source="example/lib/pages/typography/text_decoration.dart"></x-preview>

```dart
WText('Underlined text', className: 'underline');
WText('Strikethrough text', className: 'line-through');
WText('No decoration', className: 'no-underline');
```

<a name="basic-usage"></a>
## Basic Usage

Apply decoration classes directly in the `className` of any text widget:

```dart
WText(
  'See terms and conditions.',
  className: 'underline text-blue-600 dark:text-blue-400',
);
WText(
  'Original price: \$99',
  className: 'line-through text-gray-500 dark:text-gray-400',
);
```

<a name="quick-reference"></a>
## Quick Reference

| Class | Flutter `TextDecoration` | Description |
|:------|:-------------------------|:------------|
| `no-underline` | `TextDecoration.none` | Removes any text decoration. |
| `underline` | `TextDecoration.underline` | Adds an underline. |
| `overline` | `TextDecoration.overline` | Adds an overline. |
| `line-through` | `TextDecoration.lineThrough` | Adds a strikethrough. |

<a name="responsive-design"></a>
## Responsive Design

Combine with breakpoint prefixes to toggle decoration at certain screen sizes:

```dart
WText('Conditional underline', className: 'no-underline md:underline');
```

<a name="related-documentation"></a>
## Related Documentation

- [Text Color](text-color.md) — apply color to text.
- [Font Style](font-style.md) — italic and normal styles.
- [Font Weight](font-weight.md) — control text thickness.
- [WText](../widgets/wtext.md) — the primary text widget.
