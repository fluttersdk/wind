# Text Align

Utilities for controlling the alignment of text.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Responsive Design](#responsive-design)
- [Dark Mode](#dark-mode)
- [Arbitrary Values](#arbitrary-values)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<x-preview path="typography/text_align_basic" size="md" source="example/lib/pages/typography/text_align_basic.dart"></x-preview>

```dart
// Basic alignment examples
WText('Left aligned', className: 'text-left')
WText('Center aligned', className: 'text-center')
WText('Right aligned', className: 'text-right')
```

<a name="basic-usage"></a>
## Basic Usage

Use `text-left`, `text-center`, `text-right`, and `text-justify` to control the text alignment of an element.

```dart
WDiv(
  className: 'flex flex-col gap-4',
  children: [
    WText('Left aligned text.', className: 'text-left'),
    WText('Center aligned text.', className: 'text-center'),
    WText('Right aligned text.', className: 'text-right'),
    WText('Justified text.', className: 'text-justify'),
  ],
)
```

<a name="quick-reference"></a>
## Quick Reference

| Class | Value | Description |
|:------|:------|:------------|
| `text-left` | `TextAlign.left` | Align text to the left. |
| `text-center` | `TextAlign.center` | Align text to the center. |
| `text-right` | `TextAlign.right` | Align text to the right. |
| `text-justify` | `TextAlign.justify` | Stretch lines of text to equal width. |
| `text-start` | `TextAlign.start` | Align text to the start (direction-aware). |
| `text-end` | `TextAlign.end` | Align text to the end (direction-aware). |

<a name="responsive-design"></a>
## Responsive Design

Apply different alignment at different breakpoints using the standard `sm:`, `md:`, `lg:`, `xl:`, and `2xl:` prefixes.

<x-preview path="typography/text_align_responsive" size="md" source="example/lib/pages/typography/text_align_responsive.dart"></x-preview>

```dart
// Center on mobile, left on medium screens and up
WText(
  'Responsive Alignment',
  className: 'text-center md:text-left',
)
```

<a name="dark-mode"></a>
## Dark Mode

Use the `dark:` prefix to apply different alignment in dark mode. While less common for alignment than colors, it is fully supported.

```dart
WText('Dark mode alignment', className: 'text-left dark:text-center')
```

<a name="arbitrary-values"></a>
## Arbitrary Values

The text alignment utility does not support arbitrary values because it maps directly to Flutter's `TextAlign` enum.

<a name="customizing-theme"></a>
## Customizing Theme

Text alignment values are hardcoded to map to Flutter's `TextAlign` enum and cannot be customized via `WindThemeData`.

<a name="related-documentation"></a>
## Related Documentation

- [Font Size](./font-size.md)
- [Font Weight](./font-weight.md)
- [Line Height](./line-height.md)
