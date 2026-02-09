# WText

A utility-first text component that translates Tailwind-like class strings into optimized Flutter typography.

- [Basic Usage](#basic-usage)
- [Constructor](#constructor)
- [Props](#props)
- [Typography Styling](#typography-styling)
- [State Variants](#state-variants)
- [Styling Examples](#styling-examples)
- [All Supported Classes](#all-supported-classes)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<x-preview path="widgets/w_text" size="md" source="example/lib/pages/widgets/w_text.dart"></x-preview>

```dart
WText(
  'Design is not just what it looks like and feels like.',
  className: 'text-2xl font-bold text-slate-900 text-center leading-tight',
)
```

## Basic Usage

The `WText` widget handles all text rendering in Wind. Unlike standard Flutter `Text` widgets, it supports direct styling via the `className` property, including responsive and state-based modifiers.

```dart
WText(
  'Utility-first styling for Flutter',
  className: 'text-lg text-blue-600 font-semibold italic p-4',
)
```

## Constructor

```dart
const WText(
  String data, {
  Key? key,
  String? className,
  WindStyle? style,
  TextStyle? textStyle,
  bool selectable = false,
  Set<String>? states,
})
```

## Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `data` | `String` | `required` | The text string to display. |
| `className` | `String?` | `null` | Tailwind-like utility classes. |
| `style` | `WindStyle?` | `null` | Explicit WindStyle object as a base. |
| `textStyle` | `TextStyle?` | `null` | Standard Flutter TextStyle to merge (className takes precedence). |
| `selectable` | `bool` | `false` | Whether the text should be selectable (renders `SelectableText`). |
| `states` | `Set<String>?` | `null` | Custom states for dynamic styling (e.g., 'loading'). |

## Typography Styling

WText supports a wide range of typography utilities that map directly to Flutter's `TextStyle`.

### Alignment and Transform

<x-preview path="widgets/w-text-transform" size="sm" source="example/lib/pages/widgets/w_text_transform.dart"></x-preview>

```dart
WText('CENTERED UPPERCASE', className: 'text-center uppercase')
WText('capitalize me', className: 'capitalize')
```

### Overflow and Clamping

Handle long text gracefully using truncation or line clamping.

```dart
WText(
  'A very long text that will be truncated with an ellipsis after two lines.',
  className: 'line-clamp-2 text-gray-500',
)
```

## State Variants

Text colors and weights can react to states when provided via the `states` prop or when nested within state-aware widgets like `WButton`.

```dart
WText(
  'Hover me',
  className: 'text-gray-500 hover:text-blue-600 transition-colors',
)
```

## Styling Examples

### Gradient and Opacity
While standard text uses `text-{color}`, you can also apply opacity modifiers.

```dart
WText(
  'Faded Text',
  className: 'text-blue-500/50 font-medium',
)
```

### Composition Pipeline
WText uniquely supports layout utilities (padding, margin, alignment) by automatically wrapping the text in the necessary layout widgets.

```dart
WText(
  'Alert Message',
  className: 'bg-red-100 text-red-700 p-4 rounded-lg border border-red-200',
)
```

## All Supported Classes

| Category | Classes |
|:---------|:--------|
| **Font Size** | `text-xs`, `text-sm`, `text-base`, `text-lg`, `text-xl` ... `text-6xl` |
| **Font Weight** | `font-thin`, `font-light`, `font-normal`, `font-medium`, `font-bold` ... `font-black` |
| **Color** | `text-{color}`, `text-{color}/{opacity}`, `text-[rgb(...)]` |
| **Align** | `text-left`, `text-center`, `text-right`, `text-justify` |
| **Transform** | `uppercase`, `lowercase`, `capitalize`, `normal-case` |
| **Decoration** | `underline`, `line-through`, `no-underline` |
| **Spacing** | `leading-{size}` (Line Height), `tracking-{size}` (Letter Spacing) |
| **Overflow** | `truncate`, `text-ellipsis`, `line-clamp-{n}` |

## Customizing Theme

Override default typography scales in your `WindThemeData`.

```dart
WindThemeData(
  fontSizes: {
    'huge': 120.0,
  },
  fontWeights: {
    'thick': FontWeight.w900,
  },
)
```

## Related Documentation

- [WDiv](./w-div.md) - For complex layouts and containers.
- [Typography Settings](../typography/font-size.md) - Deep dive into font sizes and scales.
- [State Management](../core-concepts/state-management.md) - How `hover:` and `focus:` work.
