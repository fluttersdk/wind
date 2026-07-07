# WSwitch

Controlled toggle switch. Composes `WAnchor` + `WDiv` (track) + `WDiv` (thumb). Pushes the `checked:` state prefix into the className context when `value` is `true`, so callers can drive all visual changes: track color, thumb position, opacity: through className tokens alone.

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
    w-11 h-6 rounded-full px-0.5 border-2
    flex items-center justify-start checked:justify-end
    bg-gray-200 checked:bg-blue-600
    border-gray-300 checked:border-blue-600
    dark:bg-gray-700 dark:checked:bg-blue-500
    dark:border-gray-600 dark:checked:border-blue-500
  ''',
  thumbClassName: 'w-4 h-4 rounded-full bg-white dark:bg-gray-100 shadow',
)
```

<a name="props"></a>
## Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `value` | `bool` | **Required** | Whether the switch is on. Drives the `checked:` state prefix. |
| `onChanged` | `ValueChanged<bool>?` | `null` | Called with the new value when the switch is tapped. Omit or pass `null` to make the switch non-interactive. |
| `className` | `String?` | `null` | Utility classes for the track (the outer pill). Supports `checked:`, `disabled:`, `hover:`, and `focus:` prefixes. |
| `thumbClassName` | `String?` | `null` | Utility classes for the thumb (the circular indicator), shape and color only. The thumb is a flex child of the track; position it with `justify-start` / `checked:justify-end` on the track `className`, not with `translate-x-*` (Wind has no transform parser, so translate is a no-op). |
| `disabled` | `bool` | `false` | Blocks tap and activates the `disabled:` prefix. |
| `states` | `Set<String>?` | `null` | Extra custom states merged with built-in `checked` and `disabled`. |
| `semanticLabel` | `String?` | `null` | Accessible label for the switch Semantics node. Set this when the switch has no adjacent visible text label. |

<a name="constructor"></a>
## Constructor

```dart
WSwitch({
  Key? key,
  required bool value,
  ValueChanged<bool>? onChanged,
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
    w-11 h-6 rounded-full px-0.5 border-2
    flex items-center justify-start checked:justify-end
    bg-gray-200 dark:bg-gray-700
    border-gray-300 dark:border-gray-600
    checked:bg-teal-500 dark:checked:bg-teal-400
    checked:border-teal-500 dark:checked:border-teal-400
    focus:ring-2 focus:ring-teal-500 dark:focus:ring-teal-400 focus:ring-offset-2
  ''',
  thumbClassName: 'w-4 h-4 rounded-full bg-white dark:bg-gray-100 shadow',
)
```

### Thumb Position

The thumb is a flex child of the track, so the track owns its position. Put `flex items-center` on the track to lay the thumb out, then slide it with `justify-start` (left, off) to `checked:justify-end` (right, on). A little horizontal padding (`px-0.5`) keeps the thumb off the track edge:

```dart
// Track w-11 (44px), thumb w-5 (20px): flex justify-end seats it on the right
className: 'w-11 h-6 rounded-full px-0.5 flex items-center justify-start checked:justify-end ...',
thumbClassName: 'w-5 h-5 rounded-full bg-white dark:bg-gray-100 shadow',
```

Do NOT use `translate-x-*`: Wind has no transform parser, so a translate-based thumb never moves.

### Disabled State

```dart
WSwitch(
  value: true,
  onChanged: null,
  disabled: true,
  className: '''
    w-11 h-6 rounded-full px-0.5 border-2
    flex items-center justify-start checked:justify-end
    checked:bg-teal-400 checked:border-teal-400
    dark:checked:bg-teal-600 dark:checked:border-teal-600
    disabled:opacity-50
  ''',
  thumbClassName: 'w-4 h-4 rounded-full bg-white dark:bg-gray-100',
)
```

### Custom State via states:

```dart
WSwitch(
  value: isOn,
  onChanged: (_) {},
  states: {'error'},
  className: 'w-11 h-6 rounded-full px-0.5 flex items-center justify-start checked:justify-end border-2 border-gray-300 error:border-red-500 error:ring-2 error:ring-red-100',
  thumbClassName: 'w-4 h-4 rounded-full bg-white dark:bg-gray-100',
)
```

<a name="related-documentation"></a>
## Related Documentation

- [WAnchor](./w-anchor.md): provides hover, focus, and gesture state propagation for the switch.
- [WCheckbox](./w-checkbox.md): boolean input that mirrors the `checked:` state pattern.
- [WDiv](./w-div.md): renders the track and thumb surfaces.
