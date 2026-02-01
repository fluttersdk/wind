# Text Align

Utilities for controlling the alignment of text.

<x-preview path="typography/alignment" size="md" source="example/lib/pages/typography/alignment.dart"></x-preview>

## Basic Usage

Control text alignment using `text-{align}` utilities:

```dart
WText('Left aligned', className: 'text-left')
WText('Center aligned', className: 'text-center')
WText('Right aligned', className: 'text-right')
WText('Justified text', className: 'text-justify')
```

## All Alignment Classes

| Class | Alignment |
| :--- | :--- |
| `text-left` | Align left |
| `text-center` | Align center |
| `text-right` | Align right |
| `text-justify` | Justify text |
| `text-start` | Align to start (RTL aware) |
| `text-end` | Align to end (RTL aware) |

## RTL Support

Use `text-start` and `text-end` for right-to-left language support:

```dart
// Left in LTR, Right in RTL
WText('Start aligned', className: 'text-start')

// Right in LTR, Left in RTL
WText('End aligned', className: 'text-end')
```

## Related Documentation

- [Text Overflow](./text-overflow.md) - Text overflow utilities
