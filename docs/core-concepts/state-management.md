# State-Based Styling

Wind allows you to easily manage hover, disabled, and other state-based styles in Flutter widgets using utility class names. With utilities like `hover:bg-blue-500` or `disabled:bg-gray-300`, you can define styles that adapt to a widget's state seamlessly.

## Core Concept

Wind dynamically parses class names based on widget states and applies the corresponding styles efficiently. This allows you to create interactive UI elements without complex manual state handling.

```dart
WAnchor(
  onTap: () {},
  child: WDiv(
    className: 'bg-blue-500 hover:bg-blue-700 px-4 py-2 rounded',
    children: [WText('Hover me', className: 'text-white')],
  ),
)
```

## Built-in States

Wind supports three built-in interaction states that are automatically managed by **`WAnchor`** and **`WButton`** widgets:

| Widget | Description |
| :--- | :--- |
| `WAnchor` | Low-level state wrapper. Wraps any widget to enable `hover:`, `focus:`, `disabled:` styling. |
| `WButton` | High-level button component. Internally uses `WAnchor` + adds `isLoading`, `disabled` props and loading spinner. |

> **Tip:** Use `WButton` for buttons (it handles everything automatically). Use `WAnchor` when you need state management on custom widgets like cards or list items.

### Hover State

<x-preview path="effects/states_basic" size="md" source="example/lib/pages/effects/states_basic.dart"></x-preview>

Apply styles when the user hovers over the element.

```dart
// Using WAnchor (for custom widgets)
WAnchor(
  onTap: () {},
  child: WDiv(
    className: 'bg-blue-500 hover:bg-blue-700 px-6 py-3 rounded-lg',
    children: [
      WText('Hover me', className: 'text-white font-medium'),
    ],
  ),
)

// Using WButton (recommended for buttons)
WButton(
  onTap: () {},
  className: 'bg-blue-500 hover:bg-blue-700 text-white px-6 py-3 rounded-lg',
  child: Text('Hover me'),
)
```

| Prefix | Condition |
| :--- | :--- |
| `hover:` | Applied when pointer is over the element |

### Focus State

Apply styles when the element has focus.

```dart
WAnchor(
  onTap: () {},
  child: WDiv(
    className: '''
      bg-white border border-gray-300
      focus:ring-2 focus:ring-blue-500 focus:border-blue-500
      px-6 py-3 rounded-lg
    ''',
    children: [
      WText('Click to focus', className: 'text-gray-700 font-medium'),
    ],
  ),
)
```

| Prefix | Condition |
| :--- | :--- |
| `focus:` | Applied when element has focus (after tap) |

### Disabled State

Apply styles when the element is disabled.

```dart
// WAnchor: disabled when onTap is null
WAnchor(
  onTap: null,
  child: WDiv(
    className: 'bg-green-500 disabled:bg-gray-400 px-6 py-3 rounded-lg',
    children: [WText('Disabled', className: 'text-white font-medium')],
  ),
)

// WButton: use disabled prop
WButton(
  onTap: () {},
  disabled: true,
  className: 'bg-green-500 disabled:bg-gray-400 text-white px-6 py-3 rounded-lg',
  child: Text('Disabled'),
)
```

| Prefix | Condition |
| :--- | :--- |
| `disabled:` | Applied when `WAnchor.onTap` is null or `WButton.disabled` is true |

### Loading State (WButton only)

`WButton` has built-in loading state with automatic spinner:

```dart
WButton(
  onTap: _submit,
  isLoading: _isSubmitting,
  loadingText: 'Submitting...',
  className: '''
    bg-blue-600 text-white px-4 py-2 rounded-lg
    loading:opacity-70
  ''',
  child: Text('Submit'),
)
```

| Prefix | Condition |
| :--- | :--- |
| `loading:` | Applied when `WButton.isLoading` is true |

## Custom States

<x-preview path="effects/states_custom" size="lg" source="example/lib/pages/effects/states_custom.dart"></x-preview>

Wind also supports custom states that you define yourself. This is powerful for creating complex UI patterns.

### Using Custom States

Pass a `Set<String>` of active states to the `states` parameter of any Wind widget:

#### Loading State Example

```dart
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => isLoading = !isLoading),
      child: WDiv(
        className: 'bg-blue-500 loading:bg-gray-400 px-6 py-3 rounded-lg',
        states: isLoading ? {'loading'} : {},
        children: [
          WText(
            isLoading ? 'Loading...' : 'Click to toggle loading',
            className: 'text-white font-medium',
          ),
        ],
      ),
    );
  }
}
```

#### Selected State Example

```dart
WDiv(
  className: '''
    bg-white border-2 border-gray-300
    selected:border-blue-500 selected:bg-blue-50
    px-6 py-3 rounded-lg
  ''',
  states: isSelected ? {'selected'} : {},
  children: [
    WText(isSelected ? 'Selected' : 'Click to select'),
  ],
)
```

#### WText with States

```dart
WText(
  'Status message',
  className: 'text-gray-600 error:text-red-500 success:text-green-500',
  states: {if (hasError) 'error', if (isSuccess) 'success'},
)
```

#### WButton with States

```dart
WButton(
  onTap: _submit,
  className: 'bg-blue-500 error:bg-red-500 success:bg-green-500 text-white px-4 py-2',
  states: {if (hasError) 'error', if (isSuccess) 'success'},
  child: Text('Submit'),
)
```

#### WAnchor (Propagates to Children)

```dart
WAnchor(
  onTap: () {},
  states: {'loading'},  // Propagated to all child widgets
  child: WDiv(
    className: 'bg-blue-500 loading:bg-gray-400 loading:opacity-70',
    children: [WText('Content')],
  ),
)
```

## Combining States with Transitions

Combine state prefixes with transition utilities for smooth animations:

```dart
WAnchor(
  onTap: () {},
  child: WDiv(
    className: '''
      bg-purple-500 hover:bg-purple-700 hover:shadow-lg
      px-6 py-3 rounded-lg duration-300
    ''',
    children: [
      WText('Smooth transition', className: 'text-white font-medium'),
    ],
  ),
)
```

## Platform States

Wind also supports platform-specific prefixes:

| Prefix | Condition |
| :--- | :--- |
| `ios:` | Applied on iOS platform |
| `android:` | Applied on Android platform |
| `web:` | Applied on web platform |
| `mobile:` | Applied on mobile (iOS or Android) |

```dart
WDiv(
  className: 'p-4 ios:p-6 android:p-5',
  children: [...],
)
```

## Responsive States

Combine state prefixes with responsive breakpoints:

```dart
WDiv(
  className: 'bg-gray-100 md:hover:bg-blue-100 lg:hover:bg-green-100',
  children: [...],
)
```

## How It Works

Under the hood, Wind uses a unified `activeStates` system:

1. **WAnchor** detects hover, focus, and disabled states
2. States are passed to **WindContext** as a `Set<String>`
3. **WindParser** filters classes based on state prefixes
4. Only matching classes are applied to the widget

This architecture allows infinite extensibility - any string can be a state prefix!

```dart
// These are all valid state prefixes:
'loading:opacity-50'
'selected:ring-2'
'error:border-red-500'
'success:bg-green-100'
'dragging:shadow-xl'
```

## Related Documentation

- [Utility-First Fundamentals](./utility-first.md) - Core concepts
- [Responsive Design](./responsive-design.md) - Breakpoint prefixes
- [Transitions](../effects/transition.md) - Smooth state changes
