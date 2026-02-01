# WText

A utility-first text widget that wraps Flutter's `Text` or `SelectableText` with Tailwind-like styling classes.

<x-preview path="widgets/w_text" size="lg" source="example/lib/pages/widgets/w_text.dart"></x-preview>

## Basic Usage

```dart
WText(
  'Hello World',
  className: 'text-2xl font-bold text-gray-900 text-center',
)
```

## Font Size

Control text size with `text-{size}` utilities:

| Class | Size |
| :--- | :--- |
| `text-xs` | 12px |
| `text-sm` | 14px |
| `text-base` | 16px |
| `text-lg` | 18px |
| `text-xl` | 20px |
| `text-2xl` | 24px |
| `text-3xl` | 30px |
| `text-4xl` | 36px |
| `text-5xl` | 48px |

Arbitrary values: `text-[20px]`

## Font Weight

Control font weight with `font-{weight}`:

| Class | Weight |
| :--- | :--- |
| `font-thin` | 100 |
| `font-extralight` | 200 |
| `font-light` | 300 |
| `font-normal` | 400 |
| `font-medium` | 500 |
| `font-semibold` | 600 |
| `font-bold` | 700 |
| `font-extrabold` | 800 |
| `font-black` | 900 |

Arbitrary values: `font-[600]`

## Font Style

| Class | Description |
| :--- | :--- |
| `italic` | Italic text |
| `not-italic` | Normal text |

## Text Color

Apply colors with `text-{color}`:

```dart
WText('Red text', className: 'text-red-500')
WText('Blue text', className: 'text-blue-600')
WText('With opacity', className: 'text-gray-900 text-opacity-50')
```

Arbitrary values: `text-[#FF5500]`

## Text Transform

<x-preview path="typography/text_transform" size="sm" source="example/lib/pages/typography/text_transform.dart"></x-preview>

| Class | Description |
| :--- | :--- |
| `uppercase` | UPPERCASE TEXT |
| `lowercase` | lowercase text |
| `capitalize` | Capitalize First Letter |
| `normal-case` | Original case |

## Text Decoration

| Class | Description |
| :--- | :--- |
| `underline` | Underlined text |
| `overline` | Overlined text |
| `line-through` | Strikethrough text |
| `no-underline` | Remove decoration |

### Decoration Styling

| Class | Description |
| :--- | :--- |
| `decoration-{color}` | Decoration color (e.g., `decoration-red-500`) |
| `decoration-wavy` | Wavy line |
| `decoration-dotted` | Dotted line |
| `decoration-dashed` | Dashed line |
| `decoration-{n}` | Thickness (e.g., `decoration-2`, `decoration-4`) |

## Letter Spacing (Tracking)

| Class | Value |
| :--- | :--- |
| `tracking-tighter` | -0.05em |
| `tracking-tight` | -0.025em |
| `tracking-normal` | 0 |
| `tracking-wide` | 0.025em |
| `tracking-wider` | 0.05em |
| `tracking-widest` | 0.1em |

## Line Height (Leading)

| Class | Value |
| :--- | :--- |
| `leading-none` | 1 |
| `leading-tight` | 1.25 |
| `leading-snug` | 1.375 |
| `leading-normal` | 1.5 |
| `leading-relaxed` | 1.625 |
| `leading-loose` | 2 |

## Text Alignment

| Class | Description |
| :--- | :--- |
| `text-left` | Left align |
| `text-center` | Center align |
| `text-right` | Right align |
| `text-justify` | Justify text |

## Text Overflow

<x-preview path="typography/text_overflow" size="md" source="example/lib/pages/typography/text_overflow.dart"></x-preview>

| Class | Description |
| :--- | :--- |
| `truncate` | Single line with ellipsis |
| `text-ellipsis` | Ellipsis overflow |
| `line-clamp-{n}` | Limit to n lines (1-6) |

## Whitespace

| Class | Description |
| :--- | :--- |
| `whitespace-normal` | Normal wrapping |
| `whitespace-nowrap` | Prevent wrapping |
| `whitespace-pre` | Preserve whitespace |

## Selectable Text

Make text selectable with the `selectable` prop or class:

```dart
WText(
  'Copy me!',
  selectable: true,
  className: 'text-blue-600',
)

// Or via class
WText('Copy me!', className: 'selectable text-blue-600')
```

## Style Inheritance

WText inherits styles from parent WDiv via DefaultTextStyle:

```dart
WDiv(
  className: 'text-gray-500',  // Parent style
  child: WText('I am gray'),   // Inherits gray
)

WDiv(
  className: 'text-gray-500',
  child: WText('I am red', className: 'text-red-500'),  // Override
)
```

## Props

| Prop | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `data` | `String` | required | Text to display |
| `className` | `String?` | - | Utility classes |
| `style` | `WindStyle?` | - | Base WindStyle |
| `textStyle` | `TextStyle?` | - | Flutter TextStyle to merge |
| `selectable` | `bool` | `false` | Make text selectable |
| `states` | `Set<String>?` | - | Custom states |

## All Supported Classes

| Category | Classes | Description |
| :--- | :--- | :--- |
| **Size** | `text-xs`, `text-sm`, `text-base`, `text-lg`, `text-xl`, `text-2xl`... | Font size |
| **Weight** | `font-thin`, `font-normal`, `font-bold`... | Font weight |
| **Style** | `italic`, `not-italic` | Font style |
| **Color** | `text-{color}`, `text-opacity-{n}` | Text color |
| **Transform** | `uppercase`, `lowercase`, `capitalize` | Text case |
| **Decoration** | `underline`, `line-through`, `overline` | Text decoration |
| **Decoration Style** | `decoration-{color}`, `decoration-wavy` | Decoration styling |
| **Spacing** | `tracking-*`, `leading-*` | Letter/line spacing |
| **Align** | `text-left`, `text-center`, `text-right` | Text alignment |
| **Overflow** | `truncate`, `line-clamp-{n}` | Overflow handling |
| **Whitespace** | `whitespace-nowrap`, `whitespace-normal` | Wrapping |
| **Layout** | `p-*`, `m-*`, `flex-1` | Composition |

## Related Documentation

- [WDiv](./w-div.md) - Container widget
- [Colors](../effects/colors.md) - Color utilities
