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

## Supported Utility Classes

### Alignment
| Class | Description |
| :--- | :--- |
| `text-left` | Align left |
| `text-center` | Align center |
| `text-right` | Align right |
| `text-justify` | Justify text |

### Overflow & Wrapping
| Class | Description |
| :--- | :--- |
| `truncate` | Single line ellipsis |
| `text-clip` | Clip overflow |
| `text-ellipsis` | Ellipsis overflow |
| `line-clamp-{n}` | Max lines (1-6, or none) |

### Transform
| Class | Description |
| :--- | :--- |
| `uppercase` | UPPERCASE |
| `lowercase` | lowercase |
| `capitalize` | Capitalize Each Word |
| `normal-case` | Original case |
