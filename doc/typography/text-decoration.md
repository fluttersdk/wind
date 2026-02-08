# Text Decoration

Utilities for controlling the decoration of text.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Variants](#variants)
- [Responsive Design](#responsive-design)
- [Dark Mode](#dark-mode)
- [Arbitrary Values](#arbitrary-values)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<x-preview path="typography/decoration" size="md" source="example/lib/pages/typography/decoration.dart"></x-preview>

```dart
// Basic decoration
WText('Underline', className: 'underline')

// With color, style, and thickness
WText('Styled', className: 'underline decoration-blue-500 decoration-wavy decoration-2')
```

<a name="basic-usage"></a>
## Basic Usage

Use `underline`, `overline`, or `line-through` to decorate text. Use `no-underline` to remove existing decorations.

```dart
WText('The quick brown fox...', className: 'underline')
WText('The quick brown fox...', className: 'overline')
WText('The quick brown fox...', className: 'line-through')
WText('Link without underline', className: 'no-underline')
```

<a name="quick-reference"></a>
## Quick Reference

| Class | Properties | Description |
|:------|:-----------|:------------|
| `underline` | `decoration: underline` | Adds an underline. |
| `overline` | `decoration: overline` | Adds an overline. |
| `line-through` | `decoration: line-through` | Adds a strikethrough. |
| `no-underline` | `decoration: none` | Removes decorations. |

<a name="variants"></a>
## Variants

### Decoration Color

Use the `decoration-{color}` utilities to change the color of the text decoration.

<!-- TODO: [EXAMPLE_NEEDED] path="typography/decoration_color" action="CREATE" -->
<!-- Description: Examples of colored text decorations -->
<x-preview path="typography/decoration_color" size="md" source="example/lib/pages/typography/decoration_color.dart"></x-preview>

```dart
WText('Error', className: 'underline decoration-red-500')
WText('Success', className: 'underline decoration-green-600')
```

### Decoration Style

Use the `decoration-{style}` utilities to change the style of the text decoration.

<!-- TODO: [EXAMPLE_NEEDED] path="typography/decoration_style" action="CREATE" -->
<!-- Description: Examples of solid, double, dotted, dashed, and wavy decorations -->
<x-preview path="typography/decoration_style" size="md" source="example/lib/pages/typography/decoration_style.dart"></x-preview>

```dart
WText('Solid', className: 'underline decoration-solid')
WText('Double', className: 'underline decoration-double')
WText('Dotted', className: 'underline decoration-dotted')
WText('Dashed', className: 'underline decoration-dashed')
WText('Wavy', className: 'underline decoration-wavy')
```

| Class | Description |
|:------|:------------|
| `decoration-solid` | Sets the decoration style to solid. |
| `decoration-double` | Sets the decoration style to double. |
| `decoration-dotted` | Sets the decoration style to dotted. |
| `decoration-dashed` | Sets the decoration style to dashed. |
| `decoration-wavy` | Sets the decoration style to wavy. |

### Decoration Thickness

Use the `decoration-{width}` utilities to change the thickness of the text decoration.

<!-- TODO: [EXAMPLE_NEEDED] path="typography/decoration_thickness" action="CREATE" -->
<!-- Description: Examples of decoration thickness 1, 2, 4, 8 -->
<x-preview path="typography/decoration_thickness" size="md" source="example/lib/pages/typography/decoration_thickness.dart"></x-preview>

```dart
WText('1px', className: 'underline decoration-1')
WText('2px', className: 'underline decoration-2')
WText('4px', className: 'underline decoration-4')
WText('8px', className: 'underline decoration-8')
```

<a name="responsive-design"></a>
## Responsive Design

Apply different decoration utilities at different breakpoints using standard responsive modifiers.

```dart
WText('Responsive decoration', className: 'no-underline md:underline')
```

<a name="dark-mode"></a>
## Dark Mode

Use the `dark:` prefix to apply different decoration styles in dark mode.

```dart
WText('Link', className: 'text-gray-900 underline decoration-gray-900 dark:text-white dark:decoration-white')
```

<a name="arbitrary-values"></a>
## Arbitrary Values

Use bracket notation for custom decoration colors or thickness.

```dart
// Custom color
WText('Brand underline', className: 'underline decoration-[#50d71e]')

// Custom thickness
WText('3px underline', className: 'underline decoration-[3px]')
```

<a name="customizing-theme"></a>
## Customizing Theme

### Decoration Color

Decoration colors use your theme's `colors` configuration.

```dart
WindThemeData(
  colors: {
    'brand': {
      '500': Color(0xFF1E88E5),
    },
  },
)
```

<a name="related-documentation"></a>
## Related Documentation

- [Text Color](./text-color.md)
- [Font Weight](./font-weight.md)
