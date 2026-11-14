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

<a name="basic-usage"></a>
## Basic Usage

The `WButton` widget handles common interactive states automatically. It provides a simple way to create buttons that react to hover, focus, and disabled states without manual state management.

```dart
WButton(
  onTap: _submit,
  className: 'bg-indigo-500 text-white p-3 rounded shadow hover:shadow-lg',
  child: WText('Submit Form'),
)
```

<a name="constructor"></a>
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

<a name="props"></a>
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
| `loadingColor` | `Color?` | `null` | Colour of the spinner. Falls back to text colour, then auto-computes contrast via W3C luminance when no colour is resolvable. |
| `states` | `Set<String>?` | `null` | Custom state prefixes (e.g., `{'error'}` for `error:` classes). |
| `semanticLabel` | `String?` | `null` | Accessible name for icon-only controls. When set, excludes the child subtree from semantics so the label overrides any child text; prefer it for icon-only controls rather than buttons that already expose readable text. |

<a name="layout-modes"></a>
## Layout Modes

You can control content alignment using standard utility classes.

### Centered Content

By default, using `justify-center` in the `className` will centre the child within the button's constraints.

<x-preview path="widgets/w_button_centered" size="md" source="example/lib/pages/widgets/w_button_centered.dart"></x-preview>

```dart
WButton(
  className: 'w-full bg-blue-500 justify-center py-3 text-white',
  child: WText('Centered Full Width'),
)
```

<a name="event-handling"></a>
## Event Handling

`WButton` exposes standard gesture callbacks. All interaction is automatically suppressed when `isLoading` or `disabled` is set to `true`. A disabled or loading button still appears to assistive technology as a button, marked not enabled, so a screen reader announces it as "dimmed" instead of skipping it. The same holds for a button with no callback at all (`onTap: null`): it is a button that is not enabled, not plain text.

```dart
WButton(
  onTap: () => print('Tapped'),
  onLongPress: () => print('Long Pressed'),
  className: 'bg-gray-200 p-4',
  child: WText('Press Me'),
)
```

<a name="state-variants"></a>
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

<a name="styling-examples"></a>
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
> When no explicit `loadingColor` is set and no text colour is available from the className, the spinner automatically picks a contrasting colour (light or dark) based on the button's background luminance using the W3C relative luminance algorithm.

### Icon Buttons

Combine `WButton` with `WIcon` for utility-styled icon buttons.

```dart
WButton(
  className: 'bg-red-500 hover:bg-red-600 p-3 rounded-full text-white shadow-lg',
  child: WIcon(Icons.delete),
)
```

<a name="all-supported-classes"></a>
## All Supported Classes

`WButton` reads sizing, padding, background, border, radius, shadow, ring, text colour, size and weight, opacity and `justify-center` / alignment. Layout (`flex`, `grid`, `hidden`, `gap`), margin and text transforms are not applied; put them on a wrapping `WDiv` or the child `WText`.

| Category | Classes |
|:---------|:--------|
| Layout | `justify-center` |
| Spacing | `p-{n}`, `px-{n}`, `py-{n}` |
| Sizing | `w-{size}`, `h-{size}`, `min-w-{size}`, `max-w-{size}` |
| Typography | `text-{size}`, `font-{weight}`, `text-{color}` |
| Background | `bg-{color}`, `bg-gradient-to-{dir}` |
| Borders | `border`, `border-{n}`, `rounded`, `rounded-{size}`, `ring` |
| Effects | `shadow`, `opacity-{n}`, `duration-{n}`, `ease-{type}` |

<a name="customizing-theme"></a>
## Customizing Theme

You can customise the default behaviour and appearance of buttons by modifying `WindThemeData`.

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

<a name="related-documentation"></a>
## Related Documentation

- [WAnchor](./w-anchor.md) - The base interactive wrapper
- [WText](./w-text.md) - For styling button labels
- [Background Colour](../styling/background-color.md) - Colour utilities
- [Text Colour](../typography/text-color.md) - Typography colour utilities
- [Spacing](../layout/spacing.md) - Padding and margin utilities

## Notes

- `WButton` takes `className` as its first named parameter.
- `WButton` is a `StatelessWidget` and keeps no state of its own.
