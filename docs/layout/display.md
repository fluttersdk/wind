# Layout

Utilities for controlling the display, position, and visibility of elements.

## Display
Utilities for controlling how an element is displayed.

<x-preview path="layout/display" size="md"></x-preview>

```dart
WText("block (default)", className: "block p-4 bg-red-200 mb-2")
WDiv(
  className: "hidden p-4 bg-blue-200 mb-2",
  children: [Text("I am hidden")],
)
WDiv(
  className: "flex p-4 bg-green-200 mb-2 gap-2",
  children: [Text("Item 1"), Text("Item 2")],
)
WDiv(
  className: "grid p-4 bg-purple-200 mb-2 gap-2",
  children: [Text("Grid 1"), Text("Grid 2")],
)
```

| Class | Properties |
| :--- | :--- |
| `block` | display: block; |
| `hidden` | display: none; |
| `flex` | display: flex; |
| `grid` | display: grid; |

## Visibility
Utilities for controlling the visibility of an element without affecting layout.

<x-preview path="layout/visibility" size="md"></x-preview>

```dart
WDiv(
  className: "invisible ...",
  child: Text("I am invisible but take up space"),
)
```

| Class | Description |
| :--- | :--- |
| `visible` | Make element visible |
| `invisible` | Hide element (maintain layout space) |

## Responsive Display
Control visibility at specific breakpoints.

<x-preview path="layout/responsive" size="md"></x-preview>

```dart
// Hidden on mobile, visible on medium screens and up
WDiv(className: "hidden md:flex ...")

// Visible on mobile, hidden on large screens
WDiv(className: "flex md:hidden ...")
```
