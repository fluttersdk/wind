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

### Examples

| Class | CSS Equivalent |
| :--- | :--- |
| `w-4` | width: 1rem; /* 16px */ |
| `w-full` | width: 100%; |
| `h-screen` | height: 100vh; |
| `max-w-md` | max-width: 28rem; |
