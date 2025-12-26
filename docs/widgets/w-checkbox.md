# WCheckbox

A utility-first checkbox component using `WAnchor` + `WDiv` for full styling control.

## Basic Usage

```dart
WCheckbox(
  value: isChecked,
  onChanged: (val) => setState(() => isChecked = val),
  className: 'w-5 h-5 rounded border border-gray-300 items-center justify-center checked:bg-blue-500 checked:border-transparent',
)
```

<x-preview path="checkbox/checkbox_basic" size="md"></x-preview>

---

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

---

## Custom Colors

```dart
// Green
className: 'checked:bg-green-500 checked:border-transparent'

// Red
className: 'checked:bg-red-500 checked:border-transparent'

// Purple
className: 'checked:bg-purple-500 checked:border-transparent'
```

---

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

---

## Props

| Prop | Type | Description |
|------|------|-------------|
| `value` | `bool` | Whether checked |
| `onChanged` | `ValueChanged<bool>?` | Change callback |
| `className` | `String?` | Utility classes |
| `iconClassName` | `String?` | Check icon classes |
| `disabled` | `bool` | Disable interaction |
| `checkIcon` | `IconData?` | Custom check icon |

---

## Supported Prefixes

| Prefix | Description |
| :--- | :--- |
| `checked:` | Styles applied when `value` is true |
| `hover:` | Styles applied on mouse hover |
| `focus:` | Styles applied when focused (via keyboard) |
| `disabled:` | Styles applied when `disabled` is true |
