# State Management & Interactive Styles

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

By using prefixes like `hover:`, `focus:`, and `active:`, you can build responsive, tactile interfaces that feel native to both web and mobile platforms.

<a name="how-it-works"></a>
## How It Works

<!-- TODO: [EXAMPLE_NEEDED] path="core-concepts/state_management_overview" action="CREATE" -->
<!-- Description: A demonstration of a card that changes color on hover, scales on click, and shows focus rings. -->
<x-preview path="core-concepts/state_management_overview" size="md" source="example/lib/pages/core-concepts/state_management_overview.dart"></x-preview>

Wind's parsing engine identifies state prefixes in your class string and stores them in a separate style map. When the widget's internal state changes (e.g., a user hovers over it), the widget rebuilds and applies the corresponding styles.

Consider this basic button example:

```dart
WButton(
  onTap: () => print('Action triggered'),
  className: 'bg-blue-500 hover:bg-blue-600 active:bg-blue-700 p-4 rounded-lg duration-200',
  child: WText('Save Changes', className: 'text-white'),
)
```

In this case, the background color transitions smoothly between shades based on the interaction state.

> [!NOTE]
> For state prefixes to work, the widget must be wrapped in an interactive component like `WAnchor`, `WButton`, or `WInput`. A standard `WDiv` is passive and will not trigger interaction states on its own.

<a name="built-in-state-prefixes"></a>
## Built-in State Prefixes

Wind supports several interactive states out of the box. These are automatically managed when using interactive widgets:

- **hover**: Triggered when a pointer enters the widget bounds.
- **focus**: Triggered when the widget receives keyboard or input focus.
- **active**: Triggered while the widget is being pressed or tapped.
- **disabled**: Triggered when the widget's interactivity is disabled (e.g., `onTap` is null).

<a name="quick-reference"></a>
## Quick Reference

| Prefix | Trigger | Typical Use Case |
|:-------|:--------|:-----------------|
| `hover:` | Pointer entry | Changing background or elevation on desktop. |
| `focus:` | Keyboard focus | Showing a ring or border on input fields. |
| `active:` | Pointer press | Scaling down or darkening a button on tap. |
| `disabled:` | Interactivity off | Reducing opacity or greying out actions. |

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
    className: 'bg-white hover:bg-slate-50 border p-6 rounded-xl duration-300',
    children: [
      WText('Interactive Card', className: 'group-hover:text-blue-600'),
    ],
  ),
)
```

<a name="wbutton-the-high-level-action"></a>
### WButton: The High-Level Action

While `WAnchor` is for generic wrappers, `WButton` is optimized for actions. It includes built-in support for loading states, padding defaults, and button-specific accessibility.

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

Even if the mouse is only hovering over the padding of the `WDiv`, the `WText` widget will receive the "hover" state and update its color accordingly.

That's all.

<a name="related-documentation"></a>
## Related Documentation

- [Responsive Design](./responsive-design.md) - Combining states with breakpoints.
- [Dark Mode](./dark-mode.md) - Styling for night owls.
- [WAnchor Widget](../widgets/w-anchor.md) - Technical reference for the anchor engine.
