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

## Gap
Utilities for controlling gutters between grid and flexbox items.

<x-preview path="layout/grid_gap" size="md"></x-preview>

```dart
WDiv(className: "grid grid-cols-2 gap-4", children: [...])
```

## Supported Utility Classes

| Category | Classes | Description |
| :--- | :--- | :--- |
| **Columns** | `grid-cols-{n}` (1-12) | Number of columns |
| **Gap** | `gap-{n}`, `gap-x-{n}`, `gap-y-{n}` | Spacing between items |

### Arbitrary Values

| Class | Description |
| :--- | :--- |
| `grid-cols-[200px_1fr]` | Arbitrary column definition (future) |
| `gap-[10px]` | Arbitrary gap size |
