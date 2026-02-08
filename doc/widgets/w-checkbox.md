# WCheckbox

A utility-first checkbox component that translates Tailwind-style classes into a fully customizable checkbox widget. It sidesteps the limitations of native Flutter checkboxes by using a composable architecture of `WAnchor` and `WDiv`.

<!-- TODO: [EXAMPLE_NEEDED] path="widgets/w-checkbox" action="CREATE" -->
<!-- Description: Basic checkbox example with state management -->
<x-preview path="widgets/w-checkbox" size="md" source="example/lib/pages/widgets/w-checkbox.dart"></x-preview>

```dart
WCheckbox(
  value: isChecked,
  onChanged: (val) => setState(() => isChecked = val),
  className: 'w-6 h-6 rounded-md border-gray-400 checked:bg-indigo-600',
)
```

## Basic Usage

The `WCheckbox` widget provides a highly flexible alternative to native Flutter checkboxes. It supports all Wind utility classes, allowing for complex styling like custom borders, focus rings, and state-based colors using the `checked:` prefix.

```dart
WCheckbox(
  value: _value,
  onChanged: (val) => setState(() => _value = val),
  className: 'w-5 h-5 rounded border-2 border-slate-300 checked:bg-blue-500 checked:border-transparent',
)
```

## Constructor

```dart
const WCheckbox({
  Key? key,
  required bool value,
  ValueChanged<bool>? onChanged,
  String? className,
  String? iconClassName,
  bool disabled = false,
  IconData? checkIcon,
  Set<String>? states,
})
```

## Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `value` | `bool` | - | Whether the checkbox is currently checked. |
| `onChanged` | `ValueChanged<bool>?` | `null` | Callback triggered when the checkbox state is toggled. |
| `className` | `String?` | `null` | Wind utility classes for the checkbox container (dimensions, border, background). |
| `iconClassName` | `String?` | `null` | Utility classes applied to the check icon (e.g., `'text-white text-xs'`). |
| `disabled` | `bool` | `false` | When true, prevents interaction and applies the `disabled:` prefix styles. |
| `checkIcon` | `IconData?` | `Icons.check` | Custom icon shown when `value` is true. Defaults to Material check icon. |
| `states` | `Set<String>?` | `null` | Custom state identifiers merged with built-in `checked` and `disabled` states. |

## Layout Modes

### Dimensions
Unlike some widgets that grow to fit their content, a checkbox requires explicit width (`w-{n}`) and height (`h-{n}`) classes to define its clickable area and visual size.

```dart
WCheckbox(
  value: true,
  className: 'w-4 h-4 rounded-sm', // Small checkbox
)

WCheckbox(
  value: true,
  className: 'w-8 h-8 rounded-full', // Large circular checkbox
)
```

## Event Handling

The `onChanged` callback is triggered when the user taps the checkbox. It provides the toggled boolean value.

```dart
WCheckbox(
  value: isChecked,
  onChanged: (bool newValue) {
    setState(() {
      isChecked = newValue;
    });
  },
)
```

## State Variants

`WCheckbox` uses the `checked:` prefix to apply styles when the value is true. It also supports standard interaction prefixes like `hover:`, `focus:`, and `disabled:`.

```dart
WCheckbox(
  value: isChecked,
  className: 'border-gray-300 checked:bg-blue-600 checked:border-transparent hover:border-blue-400 disabled:opacity-50',
)
```

## Styling Examples

### Custom Icons and Colors
You can completely change the look of the checkbox by providing a custom icon and using background utilities.

```dart
WCheckbox(
  value: true,
  checkIcon: Icons.favorite,
  className: 'w-6 h-6 bg-pink-100 border-pink-300 checked:bg-pink-500 checked:border-transparent',
  iconClassName: 'text-white text-xs',
)
```

### Validation States
Using the `states` property allows you to apply conditional styling for errors or success states.

```dart
WCheckbox(
  value: false,
  states: {'error'},
  className: 'border-gray-300 error:border-red-500 error:ring-2 error:ring-red-100',
)
```

## All Supported Classes

| Category | Classes |
|:---------|:--------|
| Sizing | `w-{n}`, `h-{n}`, `min-w-{n}`, `aspect-square` |
| Spacing | `p-{n}`, `m-{n}` |
| Appearance | `rounded`, `border`, `bg-{color}`, `shadow` |
| States | `checked:`, `hover:`, `focus:`, `disabled:`, `error:` |
| Effects | `opacity-{n}`, `ring`, `duration-{n}`, `ease-{n}` |

## Customizing Theme

The default checked color can be controlled via the `primary` color in your `WindThemeData`.

```dart
WindThemeData(
  colors: {
    'primary': context.windColors['indigo']!,
  },
)
```

## Related Documentation

- [WFormCheckbox](./w-form-checkbox.md) - Form-integrated checkbox with label and validation.
- [WAnchor](./w-anchor.md) - The base interactive component used by WCheckbox.
- [WIcon](./w-icon.md) - Documentation for the check icon styling.
