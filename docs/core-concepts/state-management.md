# State-Based Styling

Utilities for applying styles based on widget interaction states.

## State-Based Styling with Wind

Wind allows you to easily manage hover, disabled, and other state-based styles in Flutter widgets using utility class names. By leveraging the parsing engine, Wind dynamically parses class names based on widget states and applies the corresponding styles efficiently.

State-based styling in Wind is inspired by the simplicity of TailwindCSS. With utilities like `hover:bg-blue-500` or `disabled:bg-gray-300`, you can define styles that adapt to a widget's state seamlessly. Wind's parsing logic ensures that these state-based styles are parsed and applied dynamically without the need for complex manual logic.

## Core Concept

Wind dynamically parses class names based on widget states and applies the corresponding styles efficiently. This allows you to create interactive UI elements without complex manual state handling.

```dart
WAnchor(
  onTap: () {},
  child: WDiv(
    className: "bg-blue-500 hover:bg-blue-700 px-4 py-2 rounded",
    children: [WText("Hover me", className: "text-white")],
  ),
)
```

---

## Built-in States

Wind supports three built-in interaction states that are automatically managed by the `WAnchor` widget:

### Hover State

Apply styles when the user hovers over the element.

<x-preview path="effects/states_basic" size="md"></x-preview>

```dart
WAnchor(
  onTap: () {},
  child: WDiv(
    className: "bg-blue-500 hover:bg-blue-700 text-white px-4 py-2",
    children: [WText("Hover me")],
  ),
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
    className: "border focus:ring-2 focus:ring-blue-500 focus:border-blue-500",
    children: [WText("Click to focus")],
  ),
)
```

| Prefix | Condition |
| :--- | :--- |
| `focus:` | Applied when element has focus (after tap) |

### Disabled State

Apply styles when the element is disabled.

```dart
WAnchor(
  onTap: null, // Disabled when onTap is null
  child: WDiv(
    className: "bg-blue-500 disabled:bg-gray-400 text-white px-4 py-2",
    children: [WText("Disabled")],
  ),
)
```

| Prefix | Condition |
| :--- | :--- |
| `disabled:` | Applied when `WAnchor.onTap` is null |

---

## Custom States

Wind also supports custom states that you define yourself. This is powerful for creating complex UI patterns.

<x-preview path="effects/states_custom" size="lg"></x-preview>

### Using Custom States

Pass a `Set<String>` of active states to the `states` parameter of any Wind widget:

#### WDiv

```dart
WDiv(
  className: "bg-blue-500 loading:bg-gray-400 px-4 py-2",
  states: isLoading ? {'loading'} : {},
  children: [
    WText(isLoading ? "Loading..." : "Submit"),
  ],
)
```

#### WText

```dart
WText(
  "Status message",
  className: "text-gray-600 error:text-red-500 success:text-green-500",
  states: {if (hasError) 'error', if (isSuccess) 'success'},
)
```

#### WButton

```dart
WButton(
  onTap: _submit,
  className: "bg-blue-500 error:bg-red-500 success:bg-green-500 text-white px-4 py-2",
  states: {if (hasError) 'error', if (isSuccess) 'success'},
  child: Text("Submit"),
)
```

#### WAnchor (Propagates to Children)

```dart
WAnchor(
  onTap: () {},
  states: {'loading'},  // Propagated to all child widgets
  child: WDiv(
    className: "bg-blue-500 loading:bg-gray-400 loading:opacity-70",
    children: [WText("Content")],
  ),
)
```

### Example: Selected State

```dart
WDiv(
  className: "border-2 border-gray-300 selected:border-blue-500 selected:bg-blue-50",
  states: isSelected ? {'selected'} : {},
  children: [WText("Option 1")],
)
```

### Example: Error State

```dart
WDiv(
  className: "border border-gray-300 error:border-red-500 error:bg-red-50",
  states: hasError ? {'error'} : {},
  children: [WText("Input field")],
)
```

---

## Combining States with Transitions

Combine state prefixes with transition utilities for smooth animations:

```dart
WAnchor(
  onTap: () {},
  child: WDiv(
    className: "bg-blue-500 hover:bg-blue-700 hover:shadow-lg duration-300 ease-out",
    children: [WText("Smooth hover", className: "text-white")],
  ),
)
```

---

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
  className: "p-4 ios:p-6 android:p-5",
  children: [...],
)
```

---

## Responsive States

Combine state prefixes with responsive breakpoints:

```dart
WDiv(
  className: "bg-gray-100 md:hover:bg-blue-100 lg:hover:bg-green-100",
  children: [...],
)
```

---

## How It Works

Under the hood, Wind uses a unified `activeStates` system:

1. **WAnchor** detects hover, focus, and disabled states
2. States are passed to **WindContext** as a `Set<String>`
3. **WindParser** filters classes based on state prefixes
4. Only matching classes are applied to the widget

This architecture allows infinite extensibility - any string can be a state prefix!

```dart
// These are all valid state prefixes:
"loading:opacity-50"
"selected:ring-2"
"error:border-red-500"
"success:bg-green-100"
"dragging:shadow-xl"
```
