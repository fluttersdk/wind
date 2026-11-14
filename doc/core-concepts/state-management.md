# State Management & Interactive Styles

Style hover, focus, disabled, loading and custom states with prefixed classes and the `states` prop.

- [Introduction](#introduction)
- [How It Works](#how-it-works)
- [Built-in State Prefixes](#built-in-state-prefixes)
- [Quick Reference](#quick-reference)
- [Interactive Widgets](#interactive-widgets)
  - [WAnchor: The Core Wrapper](#wanchor-the-core-wrapper)
  - [WButton: The High-Level Action](#wbutton-the-high-level-action)
  - [WInput: Focus States](#winput-focus-states)
- [Custom States](#custom-states)
- [State Propagation](#state-propagation)
- [Related Documentation](#related-documentation)

<a name="introduction"></a>
## Introduction

Interactive styles allow you to define how your UI reacts to user input without managing complex state variables. Instead of nesting multiple `MouseRegion`, `GestureDetector`, and `Focus` widgets, Wind provides a declarative way to handle states directly in your `className` string.

By using prefixes like `hover:`, `focus:` and `disabled:`, you can build responsive, tactile interfaces that feel native to both web and mobile platforms.

<a name="how-it-works"></a>
## How It Works

<x-preview path="core-concepts/state_management_overview" size="md" source="example/lib/pages/core-concepts/state_management_overview.dart"></x-preview>

Wind's parsing engine identifies state prefixes in your class string and stores them in a separate style map. When the widget's internal state changes (e.g., a user hovers over it), the widget rebuilds and applies the corresponding styles.

Consider this basic button example:

```dart
WButton(
  onTap: () => print('Action triggered'),
  className: 'bg-blue-500 dark:bg-blue-600 hover:bg-blue-600 dark:hover:bg-blue-700 p-4 rounded-lg duration-200',
  child: WText('Save Changes', className: 'text-white dark:text-white'),
)
```

In this case, the background shifts between shades based on the interaction state. A `WButton` applies the new colour at once and `duration-200` only fades its opacity; to animate the colour itself, put the same classes on a `WDiv`, which wraps its decoration in an `AnimatedContainer` when a duration is set.

> [!NOTE]
> For state prefixes to work, the widget must be wrapped in an interactive component like `WAnchor`, `WButton`, or `WInput`. `WDiv` wraps itself in a `WAnchor` when its className has `hover:`, `focus:` or `active:`; hover is per anchor and is not inherited by a nested `WDiv`.

<a name="built-in-state-prefixes"></a>
## Built-in State Prefixes

Wind supports several interactive states out of the box. These are automatically managed when using interactive widgets:

- **hover**: Triggered when a pointer enters the widget bounds.
- **focus**: Triggered when the widget receives keyboard or input focus.
- **active**: Reserved. It is not wired to the pointer: it applies only when you pass `states: {'active'}` to the widget that carries the `active:` classes (`WText`, `WDiv`, `WButton`). Passing it to a `WAnchor` does not reach a descendant `WText`, because the anchor's custom states are not part of the context a descendant resolves its styles from.
- **disabled**: Active when `WButton(disabled: true)` or `WAnchor(isDisabled: true)`; a null `onTap` does not disable. `WButton(isLoading: true)` activates `loading:` on the button's own `className`, not `disabled:`, so a class meant to cover both needs both prefixes (`disabled:opacity-50 loading:opacity-50`). A loading button's anchor is disabled, though, so a `WText` or `WIcon` inside it does resolve `disabled:`.

<a name="quick-reference"></a>
## Quick Reference

| Prefix | Trigger | Typical Use Case |
|:-------|:--------|:-----------------|
| `hover:` | Pointer entry | Changing background or elevation on desktop. |
| `focus:` | Keyboard focus | Showing a ring or border on input fields. |
| `active:` | `states: {'active'}` only | Press styling you drive yourself: track the press in your own state and pass `states: {'active'}` to the styled widget itself. |
| `disabled:` | `disabled: true` / `isDisabled: true` | Reducing opacity or greying out actions. `WButton(isLoading: true)` applies `loading:` to the button itself and `disabled:` only to descendants such as `WText`. |

<a name="interactive-widgets"></a>
## Interactive Widgets

Wind provides specific widgets designed to manage and propagate these states.

<a name="wanchor-the-core-wrapper"></a>
### WAnchor: The Core Wrapper

`WAnchor` is the low-level engine behind Wind's interactivity. It provides no visual styling itself; its sole purpose is to detect gestures and share that state with its child tree. This is useful for making entire cards or complex layouts interactive.

```dart
WAnchor(
  onTap: () {},
  child: WDiv(
    className: 'bg-white dark:bg-gray-800 hover:bg-slate-50 dark:hover:bg-gray-700 border p-6 rounded-xl duration-300',
    children: [
      WText('Interactive Card', className: 'text-gray-900 dark:text-white hover:text-blue-600 dark:hover:text-blue-400'),
    ],
  ),
)
```

<a name="wbutton-the-high-level-action"></a>
### WButton: The High-Level Action

While `WAnchor` is for generic wrappers, `WButton` is optimised for actions. It includes built-in support for loading states, padding defaults, and button-specific accessibility.

```dart
WButton(
  onTap: _submit,
  className: 'bg-indigo-600 hover:bg-indigo-700 disabled:opacity-50 text-white px-8 py-3 rounded',
  child: Text('Submit'),
)
```

<a name="winput-focus-states"></a>
### WInput: Focus States

`WInput` manages its own focus state. It is common to use `focus:` prefixes here to highlight the active field or show a focus ring.

```dart
WInput(
  placeholder: 'Search...',
  className: 'border border-gray-300 focus:border-blue-500 focus:ring-2 focus:ring-blue-500/20 p-3 rounded-lg',
)
```

<a name="custom-states"></a>
## Custom States

Sometimes you need to style a widget based on a state that isn't built-in, such as whether an item is "selected" or "loading". You can pass custom strings to the `states` parameter.

```dart
WDiv(
  className: 'border-2 border-gray-200 selected:border-blue-500 bg-white selected:bg-blue-50 p-4',
  states: isSelected ? {'selected'} : {},
  child: WText('Selection Item'),
)
```

If the `states` set contains "selected", any class prefixed with `selected:` will be applied.

<a name="state-propagation"></a>
## State Propagation

Interactivity in Wind is shared through `WindContext`. When an ancestor widget like `WAnchor` changes state, it propagates that state to all children in its subtree.

Let's look at a nested example:

```dart
WAnchor(
  onTap: () {},
  child: WDiv(
    className: 'p-4 bg-white hover:bg-gray-50',
    children: [
      WText('Title', className: 'font-bold hover:text-blue-600'),
      WText('Description', className: 'text-gray-500'),
    ],
  ),
)
```

Even if the mouse is only hovering over the padding of the `WDiv`, the `WText` widget will receive the "hover" state and update its colour accordingly.

<a name="related-documentation"></a>
## Related Documentation

- [Responsive Design](./responsive-design.md) - Combining states with breakpoints.
- [Dark Mode](./dark-mode.md) - Styling for night owls.
- [WAnchor Widget](../widgets/w-anchor.md) - Technical reference for the anchor engine.

<!-- steer probe state-management -->
