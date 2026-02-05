# WButton

A utility-first button widget with loading states, hover effects, and native cursor behavior.

<x-preview path="buttons/button_basic" size="md" source="example/lib/pages/buttons/button_basic.dart"></x-preview>

## Basic Usage

```dart
WButton(
  onTap: () => print('Clicked!'),
  className: 'bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg',
  child: Text('Click Me'),
)
```

> [!TIP]
> WButton automatically shows `pointer` cursor on hover and `forbidden` cursor when disabled.

## Button Variants

```dart
// Primary
WButton(
  onTap: () {},
  className: 'bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg duration-200',
  child: Text('Primary'),
)

// Secondary
WButton(
  onTap: () {},
  className: 'bg-gray-200 hover:bg-gray-300 text-gray-800 px-4 py-2 rounded-lg duration-200',
  child: Text('Secondary'),
)

// Outline
WButton(
  onTap: () {},
  className: 'border-2 border-blue-600 hover:bg-blue-50 text-blue-600 px-4 py-2 rounded-lg duration-200',
  child: Text('Outline'),
)

// Danger
WButton(
  onTap: () {},
  className: 'bg-red-500 hover:bg-red-600 text-white px-4 py-2 rounded-lg duration-200',
  child: Text('Delete'),
)
```

## Loading State

Show a loading spinner while processing:

```dart
WButton(
  onTap: _submit,
  isLoading: _isSubmitting,
  loadingText: 'Submitting...',
  className: 'bg-blue-600 loading:opacity-70 text-white px-4 py-2 rounded-lg',
  child: Text('Submit'),
)
```

## Disabled State

```dart
WButton(
  onTap: () {},
  disabled: true,
  className: 'bg-blue-600 disabled:bg-gray-400 disabled:opacity-50 text-white px-4 py-2 rounded-lg',
  child: Text('Disabled'),
)
```

## Props

| Prop | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `child` | `Widget` | required | Button content |
| `onTap` | `VoidCallback?` | `null` | Tap callback |
| `onLongPress` | `VoidCallback?` | `null` | Long press callback |
| `onDoubleTap` | `VoidCallback?` | `null` | Double tap callback |
| `isLoading` | `bool` | `false` | Shows loading spinner |
| `disabled` | `bool` | `false` | Disables interaction |
| `className` | `String?` | `null` | Utility classes |
| `states` | `Set<String>?` | `null` | Custom states |
| `loadingText` | `String?` | `null` | Text shown with spinner |
| `loadingWidget` | `Widget?` | `null` | Custom spinner widget |
| `loadingSize` | `double` | `16` | Spinner size |
| `loadingColor` | `Color?` | `null` | Spinner color |

## State Prefixes

| Prefix | Activates When |
| :--- | :--- |
| `hover:` | Mouse is over button |
| `focus:` | Button is focused |
| `disabled:` | `disabled: true` |
| `loading:` | `isLoading: true` |

## All Supported Classes

| Category | Classes | Description |
| :--- | :--- | :--- |
| **Sizing** | `w-*`, `h-*`, `w-full`, `h-full` | Button dimensions |
| **Spacing** | `p-*`, `px-*`, `py-*`, `m-*` | Padding and margin |
| **Background** | `bg-*`, `hover:bg-*` | Background colors |
| **Text** | `text-*`, `font-*` | Text styling |
| **Border** | `rounded-*`, `border-*` | Border radius and width |
| **Layout** | `flex`, `items-*`, `justify-*` | Internal layout |
| **Transition** | `duration-*`, `ease-*` | Smooth hover transitions |

## Related Documentation

- [WAnchor](./w-anchor.md) - Low-level state wrapper
- [Transition](../interactivity/transition.md) - Transition utilities
- [Colors](../styling/colors.md) - Color utilities
