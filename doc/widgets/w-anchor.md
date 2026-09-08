# WAnchor

The foundational state wrapper that detects user gestures (Hover, Focus, Press) and propagates that state down to all descendant widgets via `WindAnchorStateProvider`.

- [Basic Usage](#basic-usage)
- [Constructor](#constructor)
- [Props](#props)
- [Layout Modes](#layout-modes)
- [Event Handling](#event-handling)
- [Keyboard and Remote Control](#keyboard-and-remote-control)
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
  String? semanticLabel,
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
| `semanticLabel` | `String?` | `null` | Accessible name for icon-only controls. When set, excludes the child subtree from semantics so the label overrides any child text; prefer it for icon-only controls rather than controls that already expose readable text. |

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

## Keyboard and Remote Control

A focused `WAnchor` runs its `onTap` when the user presses the activation key. `WAnchor` binds no key of its own: it answers `ActivateIntent`, which `WidgetsApp` already raises for `Enter`, `Space`, the numeric keypad `Enter`, the gamepad A button and `select`. `select` is the D-pad centre on Android TV and the click on the Apple TV remote, so one binding covers a keyboard, a gamepad and a remote, and a key the platform adds later arrives for free.

```dart
// Reachable by Tab, activated by Enter, Space or the D-pad centre.
WAnchor(onTap: play, child: const WText('Play'))
```

Only `onTap` is bound. `ActivateIntent` means the primary action and there is no second key for a secondary one, so `onLongPress` and `onDoubleTap` stay pointer-only, exactly as they are on Flutter's own buttons.

An anchor with no `onTap`, or a disabled one, binds nothing and lets the key travel on to whatever is above it. That is narrower than it may look: a `CallbackAction` is always enabled and `ShortcutManager` reports a key handled for any enabled action, so binding unconditionally would have made a long-press-only anchor eat the activation key belonging to the row around it, and on web eat `Space`'s scroll with it, because `Space` maps to `PrioritizedIntents([ActivateIntent, ScrollIntent])` and an always-enabled action wins that race.

### One control is one stop

A control has to cost one press of the remote, so only an anchor that carries a gesture is a traversal stop. A gestureless `WAnchor` is a styling wrapper, and it inherits from the nearest anchor above it instead of publishing its own state.

This matters because `WDiv` wraps itself in a gestureless `WAnchor` whenever its className carries `hover:`, `focus:` or `active:`. Without the inheritance, the element carrying `focus:ring-2` would be the one element that could not see the focus:

```dart
// One stop. Tab lands on the anchor, the ring is drawn on the div, and
// Enter fires onTap.
WAnchor(
  onTap: clear,
  child: const WDiv(
    className: 'p-2 rounded-full focus:ring-2 focus:ring-blue-500',
    child: WIcon(Icons.close),
  ),
)
```

Two shapes are unaffected. A `WDiv` carrying `focus:` with no anchor above it keeps its own focus node, because that is how a consumer styles a custom control. And a focusable descendant still lights the wrapper's ring: `FocusNode.hasFocus` covers descendants, so a `WInput` inside a ring-styled `WDiv` draws the ring around the field the user is typing in.

What the wrapper inherits is deliberately narrow: the ancestor's PRIMARY focus, never its focus-within. The two are different questions and `WindAnchorState` now exposes both. A tappable card containing a text field reports focus-within the whole time the user types, so a wrapper inheriting that would light up even when it sits *beside* the field rather than around it:

```dart
// The ring belongs to nothing here, and stays dark while the field has focus.
WAnchor(
  onTap: open,
  child: const WDiv(
    className: 'flex flex-row',
    children: <Widget>[
      WDiv(className: 'p-2 focus:ring-2', child: WText('Label')),
      WDiv(className: 'flex-1 min-w-0', child: WInput()),
    ],
  ),
)
```

`hover` is not inherited at all. It is a pointer position, and two siblings inside one anchor legitimately highlight independently.

### What is not here

Wind ships no `FocusTraversalPolicy`. Directional movement is Flutter's default `DirectionalFocusTraversalPolicyMixin`, which scopes left and right to the enclosing horizontal `Scrollable` and up and down to the vertical one, so a stack of horizontal rails behaves reasonably without configuration. Focus memory per region, edge behaviour (wrap, stop or leave) and ordering beyond geometry are a consumer concern today; reach for `FocusTraversalGroup` with your own policy.

One upstream limit is worth knowing before it is diagnosed as a Wind bug: directional traversal cannot reach a list item that has not been built, so focus stops at the edge of a lazy list's cache extent ([flutter/flutter#91741](https://github.com/flutter/flutter/issues/91741)), and it can land on a cached item that is scrolled out of sight ([flutter/flutter#91795](https://github.com/flutter/flutter/issues/91795)).

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
| Keys | `onTap` also runs on `ActivateIntent` (`Enter`, `Space`, gamepad A, D-pad `select`) |

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

## Accessibility

A `WAnchor` that carries a gesture (`onTap`, `onLongPress` or `onDoubleTap`) publishes one `Semantics(button: true)` node, and `MergeSemantics` folds the child's text into it so the control gets its name from what it renders. Pass `semanticLabel` when the child has no readable text, such as an icon-only anchor; that label replaces the child subtree rather than concatenating with it.

A `WAnchor` with no gesture **and no `semanticLabel`** publishes nothing of its own. It is the state propagator in that mode, which is how `WDiv` uses it to serve `hover:`, `focus:` and `active:` classes (the auto-wrap never passes a label), and a decorative surface must not announce itself as a button with no action behind it.

`semanticLabel` is the exception, and deliberately so: setting it always publishes the named button node, gestures or not. It is how a DISABLED control still tells assistive technology that a control is there and currently unavailable, which is information the user needs. That makes the label a statement of intent rather than a formatting choice: set it on a control, never on decoration.

```dart
// One button node named "Save".
WAnchor(onTap: save, child: const WText('Save'))

// One button node named "Save", announced disabled, with no tap action.
const WAnchor(isDisabled: true, semanticLabel: 'Save', child: WText('Save'))

// No node at all: hover styling only.
const WAnchor(child: WDiv(className: 'hover:bg-slate-100', child: WText('Card')))
```

## Related Documentation

- [WButton](./w-button.md) - High-level button widget built on WAnchor.
- [WDiv](./w-div.md) - The primary layout widget used with WAnchor.
- [State Management](../core-concepts/state-management.md) - Deep dive into state prefixes.
