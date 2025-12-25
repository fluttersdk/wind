# Z-Index

Utilities for controlling the stack order of an element.

> [!IMPORTANT]
> Flutter doesn't have CSS-like positioning (`absolute`, `relative`, `fixed`). Z-index only works within `Stack` widgets where children are ordered by index.

## Basic Usage

Control the stack order using `z-{value}` utilities.

```dart
Stack(
  children: [
    WDiv(className: "z-10 bg-blue-500"),
    WDiv(className: "z-20 bg-red-500"),
    WDiv(className: "z-30 bg-green-500"),
  ],
)
```

| Class | Properties |
| :--- | :--- |
| `z-0` | zIndex: 0 |
| `z-10` | zIndex: 10 |
| `z-20` | zIndex: 20 |
| `z-30` | zIndex: 30 |
| `z-40` | zIndex: 40 |
| `z-50` | zIndex: 50 |
| `z-auto` | zIndex: auto (unset) |

## Arbitrary Values

For one-off z-index values, use the bracket notation.

```dart
WDiv(className: "z-[100]")
WDiv(className: "z-[-1]")
```

## Usage with IndexedStack

When using `Stack` or `IndexedStack`, you can use the `zIndex` property from `WindStyle` to control the order of your children.

Flutter does **not** read `zIndex` directly from a widget; instead, you must reorder the `children` list yourself based on the parsed `zIndex` values.

```dart
// Parse styles for each widget
final styleA = WindParser.parse("z-10", context); // styleA.zIndex == 10
final styleB = WindParser.parse("z-20", context); // styleB.zIndex == 20

// Higher zIndex should appear later in the `children` list so it paints on top
final children = <Widget>[
  if ((styleA.zIndex ?? 0) <= (styleB.zIndex ?? 0)) ...[
    WDiv(className: "z-10 bg-blue-500"),
    WDiv(className: "z-20 bg-red-500"),
  ] else ...[
    WDiv(className: "z-20 bg-red-500"),
    WDiv(className: "z-10 bg-blue-500"),
  ],
];

Stack(
  children: children,
);

// With IndexedStack you can also use the parsed zIndex to decide which child index is visible.
```
