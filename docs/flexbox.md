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

| Class | Properties |
| :--- | :--- |
| `flex-1` | flex: 1 1 0%; |
| `flex-auto` | flex: 1 1 auto; |
| `flex-initial` | flex: 0 1 auto; |
| `flex-none` | flex: none; |

## Justify Content
Utilities for controlling how flex and grid items are positioned along the main axis.

<x-preview path="layout/flex_justify" size="md"></x-preview>

```dart
WDiv(className: "flex justify-center", children: [...])
WDiv(className: "flex justify-between", children: [...])
```

| Class | Properties |
| :--- | :--- |
| `justify-start` | justify-content: flex-start; |
| `justify-center` | justify-content: center; |
| `justify-end` | justify-content: flex-end; |
| `justify-between` | justify-content: space-between; |
| `justify-around` | justify-content: space-around; |
| `justify-evenly` | justify-content: space-evenly; |

## Align Items
Utilities for controlling how flex and grid items are positioned along the cross axis.

<x-preview path="layout/flex_align" size="md"></x-preview>

```dart
WDiv(className: "flex items-center", children: [...])
WDiv(className: "flex items-stretch", children: [...])
```

| Class | Properties |
| :--- | :--- |
| `items-start` | align-items: flex-start; |
| `items-center` | align-items: center; |
| `items-end` | align-items: flex-end; |
| `items-baseline` | align-items: baseline; |
| `items-stretch` | align-items: stretch; |
