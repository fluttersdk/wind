# Utility-First Fundamentals

Traditionally, styling in Flutter involves composing widgets. To center text with a blue background and padding, you might write:

```dart
Container(
  padding: EdgeInsets.all(16),
  color: Colors.blue,
  child: Center(child: Text("Hello")),
)
```

With Wind, you express this intent with **Utility Classes**:

```dart
WDiv(
  className: "p-4 bg-blue items-center justify-center", // flex centering needs both
  child: Text("Hello"),
)
```

## Why "Utility-First"?

1.  **Lower Cognitive Load**: You don't need to remember if it's `EdgeInsets.all` or `EdgeInsets.symmetric`. You just write `p-4` or `px-4`.
2.  **Visual Parity**: Viewing the code gives you an immediate mental image of the UI.
3.  **No Context Switching**: You style your UI right where you build it, without jumping to a separate stylesheet or `ThemeData` definition for every small component.

## How it Works

Wind uses a **Compiler-free, Runtime Parser**. When you use `WDiv`:

1.  **Parsing**: The string "p-4 bg-blue" is split into tokens.
2.  **Resolution**: Each token is parsed. `p-4` becomes `EdgeInsets.all(16)`. `bg-blue` becomes a `Color`.
3.  **Composition**: `WDiv` intelligently builds a Flutter widget tree. It sees `padding` and wraps the child in `Padding`. It sees `bg-color` and wraps it in a `decorated` Container.

> **Performance Note**
> Wind caches parsed styles. The first time "p-4 bg-blue" is used, it takes a few microseconds to parse. Subsequent uses are instantaneous (O(1) lookup).

## The Syntax

Wind follows the Tailwind CSS syntax almost exactly:

- **Property-Value**: `property-value` (e.g., `text-red`, `p-4`)
- **Arbitrary Values**: `property-[value]` (e.g., `w-[350px]`, `bg-[#123456]`)
- **State Modifiers**: `state:class` (e.g., `hover:bg-red`, `dark:text-white`)
