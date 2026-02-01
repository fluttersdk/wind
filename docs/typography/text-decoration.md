# Text Decoration

Utilities for controlling text decoration.

<x-preview path="typography/decoration" size="md" source="example/lib/pages/typography/decoration.dart"></x-preview>

## Basic Usage

Control text decoration using decoration utilities:

```dart
WText('Underlined', className: 'underline')
WText('Overline', className: 'overline')
WText('Strikethrough', className: 'line-through')
WText('No decoration', className: 'no-underline')
```

## Decoration Types

| Class | Description |
| :--- | :--- |
| `underline` | Underline text |
| `overline` | Overline text |
| `line-through` | Strikethrough |
| `no-underline` | Remove decoration |

## Decoration Color

Style the decoration color:

```dart
WText('Red underline', className: 'underline decoration-red-500')
WText('Blue line', className: 'underline decoration-blue-600')
WText('Custom', className: 'underline decoration-[#FF00FF]')
```

## Decoration Style

Control the decoration style:

```dart
WText('Solid', className: 'underline decoration-solid')
WText('Double', className: 'underline decoration-double')
WText('Dotted', className: 'underline decoration-dotted')
WText('Dashed', className: 'underline decoration-dashed')
WText('Wavy', className: 'underline decoration-wavy')
```

| Class | Style |
| :--- | :--- |
| `decoration-solid` | Solid line |
| `decoration-double` | Double line |
| `decoration-dotted` | Dotted line |
| `decoration-dashed` | Dashed line |
| `decoration-wavy` | Wavy line |

## Decoration Thickness

Control the thickness of the decoration:

```dart
WText('Thin', className: 'underline decoration-1')
WText('Normal', className: 'underline decoration-2')
WText('Thick', className: 'underline decoration-4')
WText('Very thick', className: 'underline decoration-8')
WText('Custom', className: 'underline decoration-[3px]')
```

| Class | Thickness |
| :--- | :--- |
| `decoration-1` | 1px |
| `decoration-2` | 2px |
| `decoration-4` | 4px |
| `decoration-8` | 8px |
| `decoration-[n]` | Custom |

## Combined Example

Combine multiple decoration properties:

```dart
WText(
  'Styled decoration',
  className: 'underline decoration-red-500 decoration-wavy decoration-2',
)
```

## Related Documentation

- [Text Color](./text-color.md) - Text color utilities
