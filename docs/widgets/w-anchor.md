# WAnchor

`WAnchor` is the core interactivity wrapper of the Wind framework. It handles gestures (`onTap`, `onHover`, `onFocus`) and managing widget states (`hover`, `focus`, `active`, `disabled`).

## Basic Usage

Wrap any widget in `WAnchor` to make it interactive.

```dart
WAnchor(
  onTap: () => print("Tapped!"),
  child: WDiv(className: "p-4 bg-blue-500 text-white", child: Text("Button")),
)
```

## State Propagation

The power of `WAnchor` comes from its ability to propagate state to its descendants via `WindContext`.

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

`WAnchor` automatically manages a `FocusNode`.

```dart
WAnchor(
  autofocus: true,
  className: "focus:ring-2 ring-blue-500 focus:outline-none",
  child: Text("I have focus"),
)
```

## API Reference

| Property | Type | Description |
| :--- | :--- | :--- |
| `onTap` | `VoidCallback?` | Click/Tap handler |
| `onDoubleTap` | `VoidCallback?` | Double click handler |
| `onLongPress` | `VoidCallback?` | Long press handler |
| `onHover` | `ValueChanged<bool>?` | Hover state change handler |
| `onFocusChange` | `ValueChanged<bool>?` | Focus state change handler |
| `disabled` | `bool` | Disables interaction and sets `disabled` state |
| `autofocus` | `bool` | Whether to request focus on mount |
| `focusNode` | `FocusNode?` | External focus node |
| `mouseCursor` | `MouseCursor` | Cursor style (default: `SystemMouseCursors.click`) |
| `states` | `Set<String>?` | Custom states to apply manually |

## Supported State Prefixes

Descendants can use these prefixes to react to `WAnchor`'s state:

| Prefix | State |
| :--- | :--- |
| `hover:` | Cursor is over the widget |
| `focus:` | Widget has keyboard focus |
| `disabled:` | `disabled` property is true |
| `active:` | Widget is being pressed |
| `custom:` | Any custom state passed via `states` |
