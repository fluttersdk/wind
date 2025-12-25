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

When using `IndexedStack`, you can use the `zIndex` property from `WindStyle` to control visibility order.

```dart
// Access the parsed style for ordering
final style = WindParser.parse("z-20", context);
// style.zIndex == 20
```
