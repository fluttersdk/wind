# Text Layout

Utilities for controlling text alignment, overflow, and whitespace.

## Text Alignment

Utilities for controlling the alignment of text.

<x-preview path="typography/alignment" size="md"></x-preview>

```dart
WText("Left Aligned", className: "text-left")
WText("Center Aligned", className: "text-center")
WText("Right Aligned", className: "text-right")
WText("Justified", className: "text-justify")
```

| Class | Description |
| :--- | :--- |
| `text-left` | Align left |
| `text-center` | Align center |
| `text-right` | Align right |
| `text-justify` | Justify text |

## Text Overflow

| Class | Description |
| :--- | :--- |
| `truncate` | Single line, ellipsis overflow (`...`) |
| `text-clip` | Clip overflow |
| `text-ellipsis` | Ellipsis overflow |

## Line Clamping

To limit text to a specific number of lines with an ellipsis.

| Class | Description |
| :--- | :--- |
| `line-clamp-1` | Max 1 line |
| `line-clamp-2` | Max 2 lines |
| `line-clamp-3` | Max 3 lines |
| `line-clamp-none`| No limit |

```dart
WText(
  "This is a very long text that will be cut off after two lines...",
  className: "line-clamp-2",
)
```

## Text Transform

| Class | Description |
| :--- | :--- |
| `uppercase` | UPPERCASE |
| `lowercase` | lowercase |
| `capitalize` | Capitalize Each Word |
| `normal-case` | Original case |
