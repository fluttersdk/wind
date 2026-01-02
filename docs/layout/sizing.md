# Sizing

Utilities for setting the width and height of an element.

## Width
Utilities for setting the width of an element.

<x-preview path="sizing/width" size="md"></x-preview>

```dart
WText("w-32", className: "w-32 bg-red-200")
WText("w-1/2", className: "w-1/2 bg-blue-200")
WText("w-full", className: "w-full bg-green-200")
```

| Class | Properties |
| :--- | :--- |
| `w-0` | width: 0px; |
| `w-4` | width: 1rem; /* 16px */ |
| `w-full` | width: 100%; |
| `w-screen` | width: 100vw; |
| `w-1/2` | width: 50%; |
| `min-w-0` | min-width: 0px; |
| `max-w-full` | max-width: 100%; |

## Height
Utilities for setting the height of an element.

<x-preview path="sizing/height" size="md"></x-preview>

```dart
WDiv(className: "h-32 bg-red-200")
WDiv(className: "h-full bg-blue-200")
WDiv(className: "h-screen bg-green-200")
```

## Supported Utility Classes

| Category | Classes | Description |
| :--- | :--- | :--- |
| **Width** | `w-{n}`, `w-full`, `w-screen`, `w-1/2`... | Width |
| **Height** | `h-{n}`, `h-full`, `h-screen` | Height |
| **Min/Max** | `min-w-{size}`, `max-w-{size}`, `min-h-{size}`, `max-h-{size}` | Constraints |

### Named Max-Width Sizes

These predefined max-width values match Tailwind CSS defaults:

| Class | Value | Use Case |
| :--- | :--- | :--- |
| `max-w-xs` | 320px | Extra small containers |
| `max-w-sm` | 384px | Small cards, modals |
| `max-w-md` | 448px | Medium containers |
| `max-w-lg` | 512px | Large cards |
| `max-w-xl` | 576px | Wide containers |
| `max-w-2xl` | 672px | Article content |
| `max-w-3xl` | 768px | Wide content |
| `max-w-4xl` | 896px | Dashboard panels |
| `max-w-5xl` | 1024px | Large layouts |
| `max-w-6xl` | 1152px | Extra wide |
| `max-w-7xl` | 1280px | Full width constrained |
| `max-w-prose` | 65ch (~1040px) | Optimal reading width |

### Examples

| Class | CSS Equivalent |
| :--- | :--- |
| `w-4` | width: 1rem; /* 16px */ |
| `w-full` | width: 100%; |
| `h-screen` | height: 100vh; |
| `max-w-sm` | max-width: 384px; |
| `max-w-md` | max-width: 448px; |

## Notes

### Full Sizing Inside Scroll Views
When using `w-full` or `h-full` inside a scrollable container (e.g., `overflow-auto`), Wind automatically detects unbounded constraints and uses the screen dimensions instead of fractional sizing. This ensures proper layout and centering behavior.

```dart
// This works correctly - inner WDiv takes full viewport
WDiv(
  className: "w-full h-full overflow-auto",
  child: WDiv(
    className: "w-full h-full flex items-center justify-center",
    child: WText("Centered Content"),
  ),
)
```
