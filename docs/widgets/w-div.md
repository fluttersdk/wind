# WDiv Widget

The `WDiv` widget is the fundamental building block of the Wind framework. It is designed to replace the standard `Container`, `Row`, `Column`, `Padding`, and `properties` stack with a single, intelligent widget.

## Intelligent Composition

One of the biggest challenges in Flutter is the "Widget Tree Depth". To add padding, you wrap in `Padding`. To align, you wrap in `Align`. To add a background, you wrap in `DecoratedBox` (or `Container`).

`WDiv` solves this via **Intelligent Composition**. It parses your `className` string and dynamically constructs the most efficient widget tree possible, flattening the structure where it can.

> **Note**
> `WDiv` is not just a wrapper around `Container`. It selectively builds `Row`, `Column`, `GridView`, or `Wrap` based on your layout classes.

## Usage

### Basic Block
For a simple box with styling, use `WDiv` with a single `child`.

```dart
WDiv(
  className: "p-4 bg-white rounded-lg shadow-sm border border-gray-200",
  child: Text("I am a card"),
)
```

### Flex Layout (Row/Column)
When you provide `children`, `WDiv` acts as a layout container. By default, it behaves like a generic block (Column), but you can control this with `flex`, `flex-row`, or `flex-col`.

```dart
// Creates a Row (flex-row is default for flex display)
WDiv(
  className: "flex gap-4 items-center",
  children: [
    WDiv(className: "w-10 h-10 bg-red-500 rounded-full"),
    Text("User Name"),
  ],
)
```

### Grid Layout
Use `grid` and `grid-cols-{n}` to create responsive grids.

```dart
WDiv(
  className: "grid grid-cols-2 gap-4",
  children: [
    WDiv(className: "bg-blue-100 p-4", child: Text("Item 1")),
    WDiv(className: "bg-blue-200 p-4", child: Text("Item 2")),
    WDiv(className: "bg-blue-300 p-4", child: Text("Item 3")),
    WDiv(className: "bg-blue-400 p-4", child: Text("Item 4")),
  ],
)
```

## The "Child vs Children" Rule

To ensure clarity and prevent ambiguous layouts, `WDiv` enforces a strict rule:

> **Rule**
> You must provide either `child` OR `children`, but NEVER both.

- Use **`child`** when wrapping a single widget (e.g., styling a specific element).
- Use **`children`** when managing a layout (Row, Column, Grid, Wrap).

## Text Style Inheritance

`WDiv` automatically propagates typography styles to its descendants using `DefaultTextStyle`. This mimics CSS inheritance.

```dart
WDiv(
  className: "text-center text-lg text-gray-700 font-bold",
  child: Text("I inherit all these styles!"),
)
```
