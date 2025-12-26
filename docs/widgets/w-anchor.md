# WAnchor

`WAnchor` is the interactivity wrapper of the Wind framework. It is responsible for handling gestures (`onTap`, `onDoubleTap`, `onLongPress`) and managing widget states (`hover`, `focus`, `active`).

## Basic Usage

Wrap any widget in `WAnchor` to make it interactive.

```dart
WAnchor(
  onTap: () => print("Tapped!"),
  child: WDiv(className: "p-4 bg-blue-500 text-white", child: Text("Button")),
)
```

## State Propagation

The power of `WAnchor` comes from its ability to propagate state to its children.

```dart
WAnchor(
  child: WDiv(
    // These styles activate when WAnchor detects the state
    className: "bg-gray-200 hover:bg-gray-300 focus:ring-2 disabled:opacity-50",
    child: Text("Hover me!"),
  ),
)
```

## Focus Management

`WAnchor` manages a `FocusNode`. You can pass a `focusNode` if you need to control it externally, or `autofocus: true`.

```dart
WAnchor(
  autofocus: true,
  className: "focus:ring-2 ring-blue-500", // Style the anchor itself if it wraps content intimately
  child: Text("I have focus"),
)
```
