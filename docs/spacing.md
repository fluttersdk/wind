# Spacing

Utilities for controlling padding and margin.

## Padding
Utilities for controlling the padding of an element.

<x-preview path="spacing/padding" size="md"></x-preview>

```dart
WText("p-4", className: "p-4 bg-red-200")
WText("px-8", className: "px-8 bg-blue-200")
WText("pt-4", className: "pt-4 bg-yellow-200")
```

## Margin
Utilities for controlling the margin of an element.

<x-preview path="spacing/margin" size="md"></x-preview>

```dart
WText("m-4", className: "m-4 bg-red-200")
WText("mx-8", className: "mx-8 bg-blue-200")
WText("my-4", className: "my-4 bg-green-200")
```

| Class | Properties |
| :--- | :--- |
| `m-0` | margin: 0px; |
| `m-4` | margin: 1rem; /* 16px */ |
| `mx-4` | margin-left: 1rem; margin-right: 1rem; |
| `my-4` | margin-top: 1rem; margin-bottom: 1rem; |
| `mt-4` | margin-top: 1rem; |
| `mr-4` | margin-right: 1rem; |
| `mb-4` | margin-bottom: 1rem; |
| `ml-4` | margin-left: 1rem; |

### Arbitrary values
| Class | Properties |
| :--- | :--- |
| `m-[20px]` | margin: 20px; |
