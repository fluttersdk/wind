# WButton

A utility-first button widget with loading states, hover effects, and native cursor behavior.

`WButton` extends `WAnchor` capabilities with standard button features like loading spinners, disabled styling, and automatic cursor changes for web/desktop platforms.

## Basic Usage

<x-preview path="buttons/button_basic" size="md"></x-preview>

```dart
WButton(
  onTap: () => print('Clicked!'),
  className: 'bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg',
  child: Text('Click Me'),
)
```

> [!TIP]
> WButton automatically shows `pointer` cursor on hover and `forbidden` cursor when disabled.

---

## Button Variants

```dart
// Primary
WButton(
  className: 'bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg',
  child: Text('Primary'),
)

// Secondary
WButton(
  className: 'bg-gray-200 hover:bg-gray-300 text-gray-800 px-4 py-2 rounded-lg',
  child: Text('Secondary'),
)

// Outline
WButton(
  className: 'border-2 border-blue-600 hover:bg-blue-50 text-blue-600 px-4 py-2 rounded-lg',
  child: Text('Outline'),
)

// Danger
WButton(
  className: 'bg-red-500 hover:bg-red-600 text-white px-4 py-2 rounded-lg',
  child: Text('Delete'),
)
```

---

## Loading State

<x-preview path="buttons/button_states" size="lg"></x-preview>

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

### Custom Loading Widget

```dart
WButton(
  isLoading: true,
  loadingWidget: Row(
    children: [
      Icon(Icons.hourglass_empty, size: 16),
      SizedBox(width: 8),
      Text('Please wait...'),
    ],
  ),
  className: 'bg-blue-600 text-white px-4 py-2 rounded-lg',
  child: Text('Submit'),
)
```

---

## Disabled State

```dart
WButton(
  onTap: () {},
  disabled: true,
  className: 'bg-blue-600 disabled:bg-gray-400 disabled:opacity-50 text-white px-4 py-2 rounded-lg',
  child: Text('Disabled'),
)
```

---

## State Prefixes

| Prefix | Condition |
| :--- | :--- |
| `hover:` | Mouse is over the button |
| `focus:` | Button is focused |
| `disabled:` | `disabled: true` |
| `loading:` | `isLoading: true` |

---

## API Reference

### Properties

| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `child` | `Widget` | required | Button content |
| `onTap` | `VoidCallback?` | `null` | Tap callback |
| `onLongPress` | `VoidCallback?` | `null` | Long press callback |
| `onDoubleTap` | `VoidCallback?` | `null` | Double tap callback |
| `isLoading` | `bool` | `false` | Loading state |
| `disabled` | `bool` | `false` | Disabled state |
| `className` | `String?` | `null` | Tailwind-like classes |
| `states` | `Set<String>?` | `null` | Custom states |
| `loadingText` | `String?` | `null` | Text shown with spinner |
| `loadingWidget` | `Widget?` | `null` | Custom loading widget |
| `loadingSize` | `double` | `16` | Spinner size |
| `loadingColor` | `Color?` | `null` | Spinner color |
