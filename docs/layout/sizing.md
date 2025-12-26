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

| Class | Properties |
| :--- | :--- |
| `h-0` | height: 0px; |
| `h-4` | height: 1rem; /* 16px */ |
| `h-full` | height: 100%; |
| `h-screen` | height: 100vh; |
| `h-1/2` | height: 50%; |
| `min-h-0` | min-height: 0px; |
| `max-h-full` | max-height: 100%; |
