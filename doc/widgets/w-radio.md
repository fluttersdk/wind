# WRadio

Controlled radio button. Composes `WAnchor` (interaction state) + `WDiv` (outer ring shell) + `WDiv` (inner filled indicator). Drives the `selected:` state prefix when `value == groupValue`, mirroring how `WCheckbox` drives `checked:`.

Mutually-exclusive group behavior is the caller's responsibility: pass the same `groupValue` to every `WRadio<T>` in a group and update it through `onChanged`.

## Table of Contents

- [Basic Usage](#basic-usage)
- [Props](#props)
- [Constructor](#constructor)
- [Styling Examples](#styling-examples)
- [Related Documentation](#related-documentation)

<a name="basic-usage"></a>
## Basic Usage

<x-preview path="widgets/w_radio_basic" size="md" source="example/lib/pages/widgets/w_radio_basic.dart"></x-preview>

```dart
WRadio<String>(
  value: 'light',
  groupValue: _theme,
  onChanged: (val) => setState(() => _theme = val),
  className: '''
    w-5 h-5 rounded-full border border-gray-300 dark:border-gray-600
    flex items-center justify-center
    selected:border-blue-500 dark:selected:border-blue-400
    hover:border-blue-400 dark:hover:border-blue-300
  ''',
  indicatorClassName: 'w-2.5 h-2.5 rounded-full bg-blue-500 dark:bg-blue-400',
)
```

<a name="props"></a>
## Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `value` | `T` | **Required** | The value this radio represents. |
| `groupValue` | `T?` | **Required** | The currently selected value for the group. When `value == groupValue`, `selected:` state activates. |
| `onChanged` | `ValueChanged<T>?` | `null` | Called with `value` when this radio is tapped and not already selected. Omit or pass `null` for a non-interactive radio. |
| `className` | `String?` | `null` | Utility classes for the outer ring shell. Defaults to `'w-5 h-5 rounded-full border border-gray-300 flex items-center justify-center selected:border-blue-500'` when `null`. |
| `indicatorClassName` | `String?` | `null` | Utility classes for the inner filled dot (visible only when selected). Defaults to `'w-2.5 h-2.5 rounded-full bg-blue-500 selected:opacity-100'` when `null`. |
| `disabled` | `bool` | `false` | Blocks tap and activates the `disabled:` prefix. |
| `states` | `Set<String>?` | `null` | Extra custom states merged with built-in `selected` and `disabled`. |
| `semanticLabel` | `String?` | `null` | Accessible label for the Semantics node. Required on icon-only radios. |

<a name="constructor"></a>
## Constructor

```dart
WRadio<T>({
  Key? key,
  required T value,
  required T? groupValue,
  ValueChanged<T>? onChanged,
  String? className,
  String? indicatorClassName,
  bool disabled = false,
  Set<String>? states,
  String? semanticLabel,
})
```

<a name="styling-examples"></a>
## Styling Examples

### Vertical Radio Group

Each radio in the group shares the same `groupValue` and `onChanged`. The `selected:` prefix styles the active choice:

```dart
WRadio<String>(
  value: 'pro',
  groupValue: _plan,
  onChanged: (val) => setState(() => _plan = val),
  className: '''
    w-5 h-5 rounded-full border-2
    border-gray-300 dark:border-gray-600
    flex items-center justify-center
    selected:border-indigo-500 dark:selected:border-indigo-400
    hover:border-indigo-400 dark:hover:border-indigo-300
    disabled:opacity-50
  ''',
  indicatorClassName: '''
    w-2.5 h-2.5 rounded-full
    bg-indigo-500 dark:bg-indigo-400
  ''',
)
```

### Horizontal Row

Arrange radios in a `flex-row` container for inline selection:

```dart
WDiv(
  className: 'flex flex-row gap-6',
  children: [
    for (final option in ['light', 'dark', 'system'])
      WDiv(
        className: 'flex flex-row items-center gap-2',
        children: [
          WRadio<String>(
            value: option,
            groupValue: _theme,
            onChanged: (val) => setState(() => _theme = val),
            className: 'w-5 h-5 rounded-full border border-gray-300 dark:border-gray-600 flex items-center justify-center selected:border-blue-500 dark:selected:border-blue-400',
            indicatorClassName: 'w-2.5 h-2.5 rounded-full bg-blue-500 dark:bg-blue-400',
          ),
          WText(option, className: 'text-sm text-gray-700 dark:text-gray-300'),
        ],
      ),
  ],
)
```

### Default Fallback Styling

When `className` or `indicatorClassName` is omitted, `WRadio` falls back to its built-in defaults (blue indicator). Override only when the design calls for a different tone:

```dart
// Uses built-in blue defaults
WRadio<String>(
  value: 'option',
  groupValue: _value,
  onChanged: (val) => setState(() => _value = val),
)
```

<a name="related-documentation"></a>
## Related Documentation

- [WCheckbox](./w-checkbox.md): boolean input that mirrors the state-prefix pattern.
- [WAnchor](./w-anchor.md): provides hover and focus state propagation used by `WRadio` internally.
- [WDiv](./w-div.md): renders the ring shell and indicator surfaces.
