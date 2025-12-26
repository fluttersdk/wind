# WText Widget

`WText` is a utility-first wrapper around Flutter's `Text` (or `SelectableText`). It streamlines typography by accepting text utility classes directly.

## Usage

```dart
WText(
  "Hello World",
  className: "text-2xl font-bold text-gray-900 text-center",
)
```

## Selectable Text

To make text selectable, use `selectable: true`. It will build a `SelectableText` widget internally.

```dart
WText(
  "Copy me!",
  selectable: true,
  className: "text-blue-600",
)
```

## Inheritance

`WText` naturally inherits styles from parent `WDiv` (via `DefaultTextStyle`), but explicit classes on `WText` take precedence.

```dart
WDiv(
  className: "text-gray-500", // Parent style
  child: WText("I am gray"),
)

WDiv(
  className: "text-gray-500",
  child: WText("I am red", className: "text-red-500"), // Override
)
```

## Supported Utility Classes

`WText` works with typical Tailwind typography classes.

### Font & Color
| Class | Description |
| :--- | :--- |
| `text-{color}` | Text Color (e.g., `text-red-500`) |
| `text-{size}` | Font Size (e.g., `text-xl`, `text-[20px]`) |
| `font-{family}` | Font Family |
| `font-{weight}` | Font Weight (e.g., `font-bold`, `font-[700]`) |

### Formatting
| Class | Description |
| :--- | :--- |
| `italic`, `not-italic` | Font Style |
| `underline`, `line-through` | Decoration |
| `uppercase`, `lowercase`, `capitalize` | Transformation |
| `tracking-{size}` | Letter Spacing |
| `leading-{size}` | Line Height |
| `text-{align}` | Alignment (`left`, `center`, `right`, `justify`) |

### Overflow
| Class | Description |
| :--- | :--- |
| `truncate` | Single line ellipsis |
| `line-clamp-{n}` | Limit to `n` lines with ellipsis |
