# WInput

A utility-first form input widget with React-style controlled state management.

<x-preview path="forms/input_basic" size="md" source="example/lib/pages/forms/input_basic.dart"></x-preview>

## Basic Usage

```dart
WInput(
  value: _email,
  onChanged: (value) => setState(() => _email = value),
  placeholder: 'Enter your email',
  className: 'w-full p-3 border border-gray-300 rounded-lg',
)
```

## Input Types

Control the keyboard type and behavior using the `type` property.

| Type | Behavior |
| :--- | :--- |
| `InputType.text` | Standard text input (default) |
| `InputType.password` | Obscured text for passwords |
| `InputType.email` | Email keyboard |
| `InputType.number` | Numeric keyboard |
| `InputType.multiline` | Text area with multiple lines |

### Password Input

```dart
WInput(
  type: InputType.password,
  placeholder: 'Enter password',
  className: 'p-3 border rounded-lg',
)
```

### Multiline (Textarea)

```dart
WInput(
  type: InputType.multiline,
  minLines: 3,
  maxLines: 6,
  placeholder: 'Enter description',
  className: 'p-3 border rounded-lg',
)
```

## Styling with className

<x-preview path="forms/input_styled" size="lg" source="example/lib/pages/forms/input_styled.dart"></x-preview>

Apply Tailwind-like classes to style your inputs:

```dart
WInput(
  className: 'w-full p-4 bg-gray-50 border-2 border-gray-200 rounded-xl text-gray-900',
  placeholder: 'Styled input',
)
```

## Flex Container Support

`WInput` automatically handles flex layout classes when used inside a Row or WDiv with flex layout:

```dart
WDiv(
  className: "flex gap-x-4",
  children: [
    WInput(
      className: "flex-auto rounded-md px-3 py-2 border",
      placeholder: "Enter your email",
    ),
    WButton(
      className: "flex-none px-4 py-2 bg-blue-500",
      onTap: () {},
      child: Text("Subscribe"),
    ),
  ],
)
```

| Class | Behavior |
| :--- | :--- |
| `flex-auto` | Wraps in `Flexible` - grows/shrinks with available space |
| `flex-1` | Wraps in `Expanded` - takes equal share of available space |

## Focus States

<x-preview path="forms/input_states" size="md" source="example/lib/pages/forms/input_states.dart"></x-preview>

Use focus-prefixed classes for focus styling:

```dart
WInput(
  className: '''
    w-full p-3 
    border border-gray-300 rounded-lg
    focus:ring-2 focus:ring-blue-500 focus:border-blue-500
  ''',
  placeholder: 'Click to focus',
)
```

## Custom States & Validation

Use the `states` prop to apply custom state-based styling:

```dart
WInput(
  value: _email,
  onChanged: (value) {
    setState(() {
      _email = value;
      _emailError = _validateEmail(value);
    });
  },
  states: _emailError != null ? {'error'} : {},
  className: '''
    w-full p-3 border border-gray-300 rounded-lg
    error:border-red-500 error:ring-2 error:ring-red-500
  ''',
)
```

## Prefix & Suffix

Add icons or widgets inside the input:

```dart
WInput(
  prefix: Icon(Icons.email, size: 20),
  suffix: Icon(Icons.check, color: Colors.green),
  className: 'p-3 border rounded-lg',
  placeholder: 'With icons',
)
```

## Placeholder Styling

Use `placeholderClassName` to style placeholder text:

```dart
WInput(
  placeholder: 'Enter your email',
  placeholderClassName: 'text-gray-400 text-sm italic',
  className: 'text-gray-900 p-3 border rounded-lg',
)
```

## Props

| Prop | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `value` | `String?` | `null` | Controlled value |
| `onChanged` | `ValueChanged<String>?` | `null` | Called on value change |
| `type` | `InputType` | `text` | Input type |
| `className` | `String?` | `null` | Tailwind-like classes for input |
| `placeholderClassName` | `String?` | `null` | Tailwind-like classes for placeholder |
| `placeholder` | `String?` | `null` | Placeholder text |
| `prefix` | `Widget?` | `null` | Widget before input |
| `suffix` | `Widget?` | `null` | Widget after input |
| `enabled` | `bool` | `true` | Whether input is enabled |
| `readOnly` | `bool` | `false` | Whether input is read-only |
| `autofocus` | `bool` | `false` | Whether to autofocus |
| `textInputAction` | `TextInputAction?` | `null` | Keyboard action button |
| `onSubmitted` | `ValueChanged<String>?` | `null` | Called when action button pressed |
| `onEditingComplete` | `VoidCallback?` | `null` | Called when editing finishes |
| `onTap` | `VoidCallback?` | `null` | Called when input is tapped |
| `onTapOutside` | `TapRegionCallback?` | `null` | Called when tapped outside |
| `textCapitalization` | `TextCapitalization` | `none` | Text capitalization behavior |
| `autocorrect` | `bool` | `true` | Enable autocorrect |
| `enableSuggestions` | `bool` | `true` | Enable predictive text |
| `maxLines` | `int?` | `null` | Max lines (multiline) |
| `minLines` | `int` | `1` | Min lines (multiline) |
| `focusNode` | `FocusNode?` | `null` | External focus node |
| `controller` | `TextEditingController?` | `null` | External controller |
| `states` | `Set<String>?` | `null` | Custom states |
| `inputFormatters` | `List<TextInputFormatter>?` | `null` | Input formatters |

## State Prefixes

| Prefix | Activates When |
| :--- | :--- |
| `focus:` | Input is focused |
| `disabled:` | `enabled: false` |
| `error:` | `states: {'error'}` |
| `success:` | `states: {'success'}` |

## All Supported Classes

| Category | Classes | Description |
| :--- | :--- | :--- |
| **Sizing** | `w-*`, `h-*`, `w-full` | Input dimensions |
| **Padding** | `p-*`, `px-*`, `py-*` | Content padding |
| **Background** | `bg-*` | Fill color |
| **Border** | `border-*`, `rounded-*` | Border style and radius |
| **Typography** | `text-*`, `font-*` | Text styling |
| **Focus** | `focus:ring-*`, `focus:border-*` | Focus indicators |
| **Flex** | `flex-auto`, `flex-1` | Flex container behavior |

> [!NOTE]
> When using `controller`, the `value` prop is ignored.

## Related Documentation

- [WFormInput](./w-form-input.md) - Form-integrated input with validation
- [WButton](./w-button.md) - Button for form submission
- [Colors](../styling/colors.md) - Color utilities
