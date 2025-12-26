# Grid System

Utilities for controlling grid layouts.

## Grid Template Columns
Utilities for specifying the columns in a grid layout.

<x-preview path="layout/grid_cols" size="md"></x-preview>

```dart
WDiv(className: "grid grid-cols-3 gap-4", children: [
  WDiv(className: "bg-red-200 h-10", children: [Text("1")]),
  WDiv(className: "bg-red-200 h-10", children: [Text("2")]),
  WDiv(className: "bg-red-200 h-10", children: [Text("3")]),
])
```

| Class | Properties |
| :--- | :--- |
| `grid-cols-1` | grid-template-columns: repeat(1, minmax(0, 1fr)); |
| `grid-cols-2` | grid-template-columns: repeat(2, minmax(0, 1fr)); |
| `grid-cols-3` | grid-template-columns: repeat(3, minmax(0, 1fr)); |
| `grid-cols-4` | grid-template-columns: repeat(4, minmax(0, 1fr)); |
| `grid-cols-5` | grid-template-columns: repeat(5, minmax(0, 1fr)); |
| `grid-cols-6` | grid-template-columns: repeat(6, minmax(0, 1fr)); |

## Gap
Utilities for controlling gutters between grid and flexbox items.

<x-preview path="layout/grid_gap" size="md"></x-preview>

```dart
WDiv(className: "grid grid-cols-2 gap-4", children: [...])
```

| Class | Properties |
| :--- | :--- |
| `gap-0` | gap: 0px; |
| `gap-1` | gap: 0.25rem; /* 4px */ |
| `gap-4` | gap: 1rem; /* 16px */ |
| `gap-x-4` | column-gap: 1rem; |
| `gap-y-4` | row-gap: 1rem; |
