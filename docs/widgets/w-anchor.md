# WAnchor

The core interactivity wrapper that enables `hover:`, `focus:`, and `disabled:` state prefixes for descendant widgets.

<x-preview path="interactivity/anchor_basic" size="md" source="example/lib/pages/interactivity/anchor_basic.dart"></x-preview>

## Basic Usage

Wrap any widget to enable state-based styling:

```dart
WAnchor(
  onTap: () => print("Tapped!"),
  child: WDiv(
    className: 'p-4 bg-blue-500 hover:bg-blue-600 text-white',
    child: WText('Click Me'),
  ),
)
```

## How It Works

WAnchor propagates interaction states to its descendants via `WindStateProvider`. Child widgets automatically respond to `hover:`, `focus:`, and `disabled:` prefixes.

```dart
WAnchor(
  child: WDiv(
    // These styles activate when WAnchor detects the state
    className: 'bg-gray-200 hover:bg-gray-300 focus:ring-2',
    child: WText('Hover me!'),
  ),
)
```

## Hover Effects

Combine with transition utilities for smooth effects:

```dart
WAnchor(
  onTap: () {},
  child: WDiv(
    className: '''
      bg-blue-500 hover:bg-blue-600
      hover:scale-105 hover:shadow-lg
      duration-200
    ''',
    child: WText('Hover Effect'),
  ),
)
```

## Disabled State

Use `isDisabled` to prevent interactions and enable `disabled:` prefix:

```dart
WAnchor(
  onTap: () {},
  isDisabled: true,
  child: WDiv(
    className: 'bg-blue-500 disabled:bg-gray-400 disabled:opacity-50',
    child: WText('Disabled Button'),
  ),
)
```

## Custom States

Pass custom states for advanced styling:

```dart
WAnchor(
  states: {'error', 'active'},
  child: WDiv(
    className: 'bg-white error:border-red-500 active:bg-blue-100',
    child: WText('Custom States'),
  ),
)
```

## Props

| Prop | Type | Description |
| :--- | :--- | :--- |
| `child` | `Widget` | The interactive area (required) |
| `onTap` | `VoidCallback?` | Tap/click handler |
| `onDoubleTap` | `VoidCallback?` | Double-tap handler |
| `onLongPress` | `VoidCallback?` | Long-press handler |
| `isDisabled` | `bool` | Disables all interactions (default: false) |
| `states` | `Set<String>?` | Custom states for styling |

## Supported State Prefixes

Descendants can use these prefixes to react to WAnchor's state:

| Prefix | Activates When |
| :--- | :--- |
| `hover:` | Mouse cursor is over the widget |
| `focus:` | Widget has keyboard focus |
| `disabled:` | `isDisabled` is true |

## Related Documentation

- [WButton](./w-button.md) - Pre-styled button component
- [Transition](../interactivity/transition.md) - Transition utilities for smooth effects
- [State Management](../core-concepts/state-management.md) - How states work
