# Flexbox

Utilities for controlling the layout of flex containers.

## Flex Direction & Wrap
Utilities for controlling flex direction and wrapping.

<x-preview path="layout/flex_basic" size="md"></x-preview>

```dart
WText("Flex Row (default)", className: "p-2 font-bold"),
WDiv(
  className: "flex gap-2 p-4 bg-gray-100",
  children: [
    WDiv(className: "w-10 h-10 bg-blue-500"),
    WDiv(className: "w-10 h-10 bg-blue-500"),
    WDiv(className: "w-10 h-10 bg-blue-500"),
  ],
),
WText("Flex Column", className: "p-2 font-bold"),
WDiv(
  className: "flex flex-col gap-2 p-4 bg-gray-100",
  children: [
    WDiv(className: "w-10 h-10 bg-green-500"),
    WDiv(className: "w-10 h-10 bg-green-500"),
    WDiv(className: "w-10 h-10 bg-green-500"),
  ],
),
```
| Class | Properties |
| :--- | :--- |
| `flex-row` | flex-direction: row; |
| `flex-col` | flex-direction: column; |
| `flex-wrap` | flex-wrap: wrap; |
| `flex-nowrap` | flex-wrap: nowrap; |

## Flex Grow & Shrink
Utilities for controlling how flex items grow and shrink.

<x-preview path="layout/flex_grow" size="md"></x-preview>

```dart
WDiv(className: "flex ...", children: [
  WDiv(className: "flex-none w-10 ..."),
  WDiv(className: "flex-1 ..."), // Grows to fill space
  WDiv(className: "flex-none w-10 ..."),
])
```

## Justify Content
Utilities for controlling how flex and grid items are positioned along the main axis.

<x-preview path="layout/flex_justify" size="md"></x-preview>

```dart
WDiv(className: "flex justify-center", children: [...])
WDiv(className: "flex justify-between", children: [...])
```

## Align Items
Utilities for controlling how flex and grid items are positioned along the cross axis.

<x-preview path="layout/flex_align" size="md"></x-preview>

```dart
WDiv(className: "flex items-center", children: [...])
WDiv(className: "flex items-stretch", children: [...])
```

## Supported Utility Classes

| Category | Classes | CSS Equivalent |
| :--- | :--- | :--- |
| **Direction** | `flex-row`, `flex-col` | `flex-direction` |
| **Wrap** | `flex-wrap`, `flex-nowrap` | `flex-wrap` |
| **Flex** | `flex-1`, `flex-auto`, `flex-initial`, `flex-none` | `flex` |
| **Grow** | `flex-grow`, `flex-grow-0` | `flex-grow` |
| **Justify** | `justify-start`, `justify-end`, `justify-center`, `justify-between`, `justify-around`, `justify-evenly` | `justify-content` |
| **Align** | `items-start`, `items-end`, `items-center`, `items-baseline`, `items-stretch` | `align-items` |
