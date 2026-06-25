# WSwitch

Controlled toggle switch. Composes `WAnchor` + `WDiv` (track) + `WDiv` (thumb). Pushes the `checked:` state prefix into the className context when `value` is `true`, so callers can drive all visual changes — track color, thumb position, opacity — through className tokens alone.

## Table of Contents

- [Basic Usage](#basic-usage)
- [Props](#props)
- [Constructor](#constructor)
- [Styling Examples](#styling-examples)
- [Related Documentation](#related-documentation)

<a name="basic-usage"></a>
## Basic Usage

<x-preview path="widgets/w_switch_basic" size="md" source="example/lib/pages/widgets/w_switch_basic.dart"></x-preview>

```dart
WSwitch(
  value: isOn,
  onChanged: (val) => setState(() => isOn = val),
  className: '''
    w-11 h-6 rounded-full border-2
    bg-gray-200 checked:bg-blue-600
    border-gray-300 checked:border-blue-600
    dark:bg-gray-700 dark:checked:bg-blue-500
    dark:border-gray-600 dark:checked:border-blue-500
  ''',
  thumbClassName: 'w-4 h-4 rounded-full bg-white shadow translate-x-0 checked:translate-x-5',
)
```

<a name="props"></a>
## Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `value` | `bool` | **Required** | Whether the switch is on. Drives the `checked:` state prefix. |
| `onChanged` | `ValueChanged<bool>?` | **Required** | Called with the new value when the switch is tapped. Pass `null` to make the switch non-interactive. |
| `className` | `String?` | `null` | Utility classes for the track (the outer pill). Supports `checked:`, `disabled:`, `hover:`, and `focus:` prefixes. |
| `thumbClassName` | `String?` | `null` | Utility classes for the thumb (the circular indicator). Use `checked:translate-x-*` to slide the thumb when on. |
| `disabled` | `bool` | `false` | Blocks tap and activates the `disabled:` prefix. |
| `states` | `Set<String>?` | `null` | Extra custom states merged with built-in `checked` and `disabled`. |
| `semanticLabel` | `String?` | `null` | Accessible label for the switch Semantics node. Set this when the switch has no adjacent visible text label. |

<a name="constructor"></a>
## Constructor

```dart
WSwitch({
  Key? key,
  required bool value,
  required ValueChanged<bool>? onChanged,
  String? className,
  String? thumbClassName,
  bool disabled = false,
  Set<String>? states,
  String? semanticLabel,
})
```

<a name="styling-examples"></a>
## Styling Examples

### Track Color with checked: State

The `checked:` prefix activates when `value` is `true`. Toggle track background, border, and ring in one className:

```dart
WSwitch(
  value: isOn,
  onChanged: (val) => setState(() => isOn = val),
  className: '''
    w-11 h-6 rounded-full border-2
    bg-gray-200 dark:bg-gray-700
    border-gray-300 dark:border-gray-600
    checked:bg-teal-500 dark:checked:bg-teal-400
    checked:border-teal-500 dark:checked:border-teal-400
    focus:ring-2 focus:ring-teal-500 focus:ring-offset-2
  ''',
  thumbClassName: '''
    w-4 h-4 rounded-full bg-white shadow
    translate-x-0 checked:translate-x-5
  ''',
)
```

### Thumb Position

The thumb starts at `translate-x-0` (left) and slides to `checked:translate-x-*` (right) when on. Match the translate offset to your track width minus thumb width:

```dart
// Track w-11 (44px), thumb w-5 (20px) → offset ~ translate-x-6 (24px)
thumbClassName: 'w-5 h-5 rounded-full bg-white shadow translate-x-0 checked:translate-x-6',
```

### Disabled State

```dart
WSwitch(
  value: true,
  onChanged: null,
  disabled: true,
  className: '''
    w-11 h-6 rounded-full border-2
    checked:bg-teal-400 checked:border-teal-400
    dark:checked:bg-teal-600 dark:checked:border-teal-600
    disabled:opacity-50
  ''',
  thumbClassName: 'w-4 h-4 rounded-full bg-white translate-x-0 checked:translate-x-5',
)
```

### Custom State via states:

```dart
WSwitch(
  value: isOn,
  onChanged: (_) {},
  states: {'error'},
  className: 'w-11 h-6 rounded-full border-2 border-gray-300 error:border-red-500 error:ring-2 error:ring-red-100',
  thumbClassName: 'w-4 h-4 rounded-full bg-white translate-x-0 checked:translate-x-5',
)
```

<a name="related-documentation"></a>
## Related Documentation

- [WAnchor](./w-anchor.md) — provides hover, focus, and gesture state propagation for the switch.
- [WCheckbox](./w-checkbox.md) — boolean input that mirrors the `checked:` state pattern.
- [WDiv](./w-div.md) — renders the track and thumb surfaces.
