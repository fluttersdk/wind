# WButton

`WButton` is an interactive component that combines `WAnchor` state management with Tailwind-like utility styling and built-in loading states.

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

<x-preview path="buttons/button_basic" size="md" source="example/lib/pages/buttons/button_basic.dart"></x-preview>

```dart
WButton(
  onTap: () => print('Button tapped'),
  className: 'bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg transition-colors',
  child: WText('Click Me'),
)
```

## Basic Usage

The `WButton` widget handles common interactive states automatically. It provides a simple way to create buttons that react to hover, focus, and disabled states without manual state management.

```dart
WButton(
  onTap: _submit,
  className: 'bg-indigo-500 text-white p-3 rounded shadow hover:shadow-lg',
  child: WText('Submit Form'),
)
```

## Constructor

```dart
const WButton({
  Key? key,
  required Widget child,
  VoidCallback? onTap,
  VoidCallback? onLongPress,
  VoidCallback? onDoubleTap,
  bool isLoading = false,
  bool disabled = false,
  String? className,
  String? loadingText,
  Widget? loadingWidget,
  double loadingSize = 16,
  Color? loadingColor,
  Set<String>? states,
  String? semanticLabel,
})
```

## Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `child` | `Widget` | **Required** | The button content (usually `WText` or `WIcon`). |
| `className` | `String?` | `null` | Wind utility classes for styling. |
| `onTap` | `VoidCallback?` | `null` | Callback when the button is tapped. Disabled if `isLoading` or `disabled` is true. |
| `onLongPress` | `VoidCallback?` | `null` | Callback for long press gestures. |
| `onDoubleTap` | `VoidCallback?` | `null` | Callback for double tap gestures. |
| `isLoading` | `bool` | `false` | Activates loading state: disables interaction and shows a spinner. |
| `disabled` | `bool` | `false` | Activates disabled state: disables interaction and changes cursor. |
| `loadingText` | `String?` | `null` | Text to display next to the loading spinner. |
| `loadingWidget` | `Widget?` | `null` | Custom widget to replace the default spinner. |
| `loadingSize` | `double` | `16` | Size of the default loading spinner. |
| `loadingColor` | `Color?` | `null` | Color of the spinner. Falls back to text color, then auto-computes contrast via W3C luminance when no color is resolvable. |
| `states` | `Set<String>?` | `null` | Custom state prefixes (e.g., `{'error'}` for `error:` classes). |
| `semanticLabel` | `String?` | `null` | Accessible name for icon-only or no-text buttons. Do not set it on a button that already has visible text, or the screen reader announces the label twice (it is additive under `MergeSemantics`, not a fallback). |

## Layout Modes

`WButton` uses flexbox-like behavior internally. You can control content alignment using standard utility classes.

### Centered Content

By default, using `justify-center` in the `className` will center the child within the button's constraints.

<x-preview path="widgets/w_button_centered" size="md" source="example/lib/pages/widgets/w_button_centered.dart"></x-preview>

```dart
WButton(
  className: 'w-full bg-blue-500 justify-center py-3 text-white',
  child: WText('Centered Full Width'),
)
```

## Event Handling

`WButton` exposes standard gesture callbacks. All interaction is automatically suppressed when `isLoading` or `disabled` is set to `true`.

```dart
WButton(
  onTap: () => print('Tapped'),
  onLongPress: () => print('Long Pressed'),
  className: 'bg-gray-200 p-4',
  child: WText('Press Me'),
)
```

## State Variants

`WButton` supports multiple state-based prefixes. These classes are applied only when the corresponding state is active.

```dart
WButton(
  onTap: _submit,
  className: 'bg-blue-600 hover:bg-blue-700 focus:ring-2 disabled:bg-gray-400 loading:opacity-50',
  child: WText('Stateful Button'),
)
```

| Prefix | Trigger |
|:-------|:--------|
| `hover:` | When the mouse pointer is over the button. |
| `focus:` | When the button has keyboard focus. |
| `disabled:` | When the `disabled` prop is `true`. |
| `loading:` | When the `isLoading` prop is `true`. |

## Styling Examples

### Loading States

When `isLoading` is true, `WButton` replaces the `child` with a spinner. You can add text or a custom widget.

```dart
// Basic spinner
WButton(
  isLoading: true,
  className: 'bg-blue-500 text-white p-2',
  child: WText('Login'),
)

// Spinner with text
WButton(
  isLoading: true,
  loadingText: 'Processing...',
  className: 'bg-green-600 text-white px-4 py-2',
  child: WText('Submit'),
)
```

> [!NOTE]
> When no explicit `loadingColor` is set and no text color is available from the className, the spinner automatically picks a contrasting color (light or dark) based on the button's background luminance using the W3C relative luminance algorithm.

### Icon Buttons

Combine `WButton` with `WIcon` for utility-styled icon buttons.

```dart
WButton(
  className: 'bg-red-500 hover:bg-red-600 p-3 rounded-full text-white shadow-lg',
  child: WIcon(Icons.delete),
)
```

## All Supported Classes

Since `WButton` uses `WDiv` and `WAnchor` internally, it supports the full range of Wind utilities.

| Category | Classes |
|:---------|:--------|
| Layout | `flex`, `grid`, `block`, `hidden`, `justify-center`, `items-center` |
| Spacing | `p-{n}`, `px-{n}`, `py-{n}`, `m-{n}`, `gap-{n}` |
| Sizing | `w-{size}`, `h-{size}`, `min-w-{size}`, `max-w-{size}` |
| Typography | `text-{size}`, `font-{weight}`, `text-{color}`, `uppercase` |
| Background | `bg-{color}`, `bg-gradient-to-{dir}`, `bg-opacity-{n}` |
| Borders | `border`, `border-{n}`, `rounded`, `rounded-{size}`, `ring` |
| Effects | `shadow`, `opacity-{n}`, `duration-{n}`, `ease-{type}` |

## Customizing Theme

You can customize the default behavior and appearance of buttons by modifying `WindThemeData`.

```dart
WindThemeData(
  // Customize the base spacing unit used for p-4, m-2, etc.
  baseSpacingUnit: 4.0,
  // Add custom colors for specific button brands
  colors: {
    'brand': Colors.deepPurple,
  },
)
```

## Related Documentation

- [WAnchor](./w-anchor.md) - The base interactive wrapper
- [WText](./w-text.md) - For styling button labels
- [Background Color](../styling/background-color.md) - Color utilities
- [Text Color](../typography/text-color.md) - Typography color utilities
- [Spacing](../layout/spacing.md) - Padding and margin utilities
