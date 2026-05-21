# WAnchor

The foundational state wrapper that detects user gestures (Hover, Focus, Press) and propagates that state down to all descendant widgets via `WindAnchorStateProvider`.

- [Basic Usage](#basic-usage)
- [Constructor](#constructor)
- [Props](#props)
- [Layout Modes](#layout-modes)
- [Event Handling](#event-handling)
- [State Variants](#state-variants)
- [Styling Examples](#styling-examples)
- [All Supported Classes](#all-supported-classes)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<x-preview path="interactivity/anchor_basic" size="md" source="example/lib/pages/interactivity/anchor_basic.dart"></x-preview>

```dart
WAnchor(
  onTap: () => print('Pressed'),
  child: WDiv(
    // Reacts to hover state provided by WAnchor
    className: 'p-4 bg-white hover:bg-gray-100 transition-colors',
    child: WText('Hover Me'),
  ),
)
```

## Basic Usage

The `WAnchor` widget acts as the "brain" for interaction state management in Wind. It handles gesture detection and focus management, making it possible for child widgets to use prefixes like `hover:`, `focus:`, and `disabled:`.

Unlike most Wind widgets, `WAnchor` does not take a `className` itself. Instead, it provides the context needed for its children to respond to interactive states.

```dart
WAnchor(
  onTap: () => print('Tapped!'),
  child: WDiv(
    className: 'p-4 bg-blue-500 hover:bg-blue-600 rounded-lg',
    child: WText('Interactive Box', className: 'text-white'),
  ),
)
```

## Constructor

```dart
const WAnchor({
  Key? key,
  required Widget child,
  VoidCallback? onTap,
  VoidCallback? onLongPress,
  VoidCallback? onDoubleTap,
  bool isDisabled = false,
  Set<String>? states,
  MouseCursor? mouseCursor,
})
```

## Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `child` | `Widget` | **Required** | The widget that will receive the hover, focus, and gesture states. |
| `onTap` | `VoidCallback?` | `null` | Triggered when the widget is tapped. |
| `onLongPress` | `VoidCallback?` | `null` | Triggered when the widget is long-pressed. |
| `onDoubleTap` | `VoidCallback?` | `null` | Triggered when the widget is double-tapped. |
| `isDisabled` | `bool` | `false` | When true, gestures are ignored and the `disabled:` prefix is activated. |
| `states` | `Set<String>?` | `null` | Custom states for dynamic styling (e.g., `{'active'}`). |
| `mouseCursor` | `MouseCursor?` | `null` | Custom cursor. Defaults to click when interactive. |

## Layout Modes

`WAnchor` is a logic wrapper and does not provide layout properties of its own. To control the layout of the interactive area, use a `WDiv` or another layout widget as the immediate child.

### Flex Layout Wrapper

<x-preview path="widgets/w_anchor_flex" size="md" source="example/lib/pages/widgets/w_anchor_flex.dart"></x-preview>

```dart
WAnchor(
  onTap: () {},
  child: WDiv(
    className: 'flex items-center gap-2 p-3 bg-gray-50 hover:bg-gray-100 rounded',
    children: [
      WIcon(Icons.add, className: 'text-blue-500'),
      WText('Add Item'),
    ],
  ),
)
```

## Event Handling

`WAnchor` supports standard touch and mouse gestures. These events are only triggered if `isDisabled` is false.

```dart
WAnchor(
  onTap: () => print('Single Tap'),
  onDoubleTap: () => print('Double Tap'),
  onLongPress: () => print('Long Press'),
  child: WDiv(
    className: 'p-10 bg-zinc-200 text-center', 
    child: WText('Gesture Interaction Area')
  ),
)
```

## State Variants

`WAnchor` enables several state prefixes for all Wind widgets in its subtree. This allows you to define complex interactive styles easily.

```dart
WAnchor(
  isDisabled: false,
  child: WDiv(
    className: '''
      bg-blue-500 
      hover:bg-blue-600 
      focus:ring-2 focus:ring-blue-300
      disabled:bg-gray-400 disabled:opacity-50
    ''',
    child: WText('Interactive States', className: 'text-white'),
  ),
)
```

## Styling Examples

### Card Lift Effect
```dart
WAnchor(
  onTap: () {},
  child: WDiv(
    className: 'p-6 bg-white shadow hover:shadow-lg hover:-translate-y-1 rounded-xl duration-300',
    child: WText('Hover to see the lift effect'),
  ),
)
```

### Navigation Link
```dart
WAnchor(
  onTap: () {},
  child: WDiv(
    className: 'px-4 py-2 text-gray-600 hover:text-blue-600 hover:bg-blue-50 rounded',
    child: WText('Dashboard'),
  ),
)
```

## All Supported Classes

While `WAnchor` does not take a `className`, it facilitates the use of these state prefixes for visual widgets (like `WDiv` or `WText`) within its subtree:

| Category | Prefixes / Features |
|:---------|:--------------------|
| Interaction | `hover:`, `focus:`, `disabled:` |
| Custom States | Any value passed to the `states` prop (e.g., `active:`, `error:`) |
| Gestures | Enables `onTap`, `onLongPress`, `onDoubleTap` |

## Customizing Theme

`WAnchor` behavior is primarily state-driven. You can customize the global interaction defaults via `WindThemeData`.

```dart
WindTheme(
  data: WindThemeData(
    // Theme scales influence the styles applied during states
    baseSpacingUnit: 4.0,
  ),
  child: MyApp(),
)
```

## Related Documentation

- [WButton](./w-button.md) - High-level button widget built on WAnchor.
- [WDiv](./w-div.md) - The primary layout widget used with WAnchor.
- [State Management](../core-concepts/state-management.md) - Deep dive into state prefixes.
