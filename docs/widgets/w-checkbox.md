# WCheckbox

A utility-first checkbox component using `WAnchor` + `WDiv` for full styling control.

<x-preview path="checkbox/checkbox_basic" size="md" source="example/lib/pages/checkbox/checkbox_basic.dart"></x-preview>

## Basic Usage

```dart
WCheckbox(
  value: isChecked,
  onChanged: (val) => setState(() => isChecked = val),
  className: 'w-5 h-5 rounded border border-gray-300 checked:bg-blue-500 checked:border-transparent',
)
```

## State Styling

Use `checked:` prefix for checked state styles:

```dart
className: '''
  w-5 h-5 rounded border border-gray-300
  checked:bg-blue-500 checked:border-transparent
  hover:border-blue-400
  disabled:bg-gray-100 disabled:opacity-50
'''
```

## Custom Colors

```dart
// Green
className: 'checked:bg-green-500 checked:border-transparent'

// Red
className: 'checked:bg-red-500 checked:border-transparent'

// Purple
className: 'checked:bg-purple-500 checked:border-transparent'
```

## Sizes

```dart
// Small
className: 'w-4 h-4 ...'
iconClassName: 'text-white text-xs'

// Medium (default)
className: 'w-5 h-5 ...'
iconClassName: 'text-white text-sm'

// Large
className: 'w-6 h-6 ...'
iconClassName: 'text-white text-base'
```

## Props

| Prop | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `value` | `bool` | required | Whether checked |
| `onChanged` | `ValueChanged<bool>?` | `null` | Change callback |
| `className` | `String?` | `null` | Box utility classes |
| `iconClassName` | `String?` | `null` | Check icon classes |
| `disabled` | `bool` | `false` | Disable interaction |
| `checkIcon` | `IconData?` | `null` | Custom check icon |
| `states` | `Set<String>?` | `null` | Custom states |

## State Prefixes

| Prefix | Activates When |
| :--- | :--- |
| `checked:` | `value` is true |
| `hover:` | Mouse is over checkbox |
| `focus:` | Checkbox is focused |
| `disabled:` | `disabled` is true |

## All Supported Classes

| Category | Classes | Description |
| :--- | :--- | :--- |
| **Sizing** | `w-*`, `h-*` | Checkbox dimensions |
| **Border** | `rounded-*`, `border-*` | Border radius and width |
| **Background** | `bg-*`, `checked:bg-*` | Background colors |
| **Border Color** | `border-*`, `checked:border-*` | Border colors |
| **Layout** | `items-center`, `justify-center` | Content alignment |
| **Effects** | `opacity-*`, `disabled:opacity-*` | Opacity |

## Related Documentation

- [WAnchor](./w-anchor.md) - State wrapper used internally
- [WIcon](./w-icon.md) - Check icon component
- [Colors](../styling/colors.md) - Color utilities
