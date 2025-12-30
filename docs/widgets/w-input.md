# WInput

A utility-first form input widget with React-style controlled state management.

`WInput` provides a clean, declarative API for building styled form inputs with Tailwind-like classes. It supports multiple input types and seamlessly integrates with Wind's state-based styling system.

## Basic Usage

<x-preview path="forms/input_basic" size="md"></x-preview>

```dart
WInput(
  value: _email,
  onChanged: (value) => setState(() => _email = value),
  placeholder: 'Enter your email',
  className: 'w-full p-3 border border-gray-300 rounded-lg',
)
```

---

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

---

## Styling with className

<x-preview path="forms/input_styled" size="lg"></x-preview>

Apply Tailwind-like classes to style your inputs:

```dart
WInput(
  className: 'w-full p-4 bg-gray-50 border-2 border-gray-200 rounded-xl text-gray-900',
  placeholder: 'Styled input',
)
```

### Supported Utility Classes

`WInput` maps utility classes to `InputDecoration` properties.

| Category | Classes | Maps To |
| :--- | :--- | :--- |
| **Padding** | `p-{n}`, `px-{n}`, `py-{n}` | `contentPadding` |
| **Background** | `bg-{color}` | `fillColor`, `filled: true` |
| **Border** | `border`, `border-{n}`, `border-{color}` | `enabledBorder`, `focusedBorder` |
| **Radius** | `rounded-{size}` | `borderRadius` |
| **Typography** | `text-{color}`, `font-{weight}` | Input text style |
| **Placeholder** | `placeholder:{style}` | Placeholder text style (via `placeholderClassName`) |
| **Flex** | `flex-auto`, `flex-1` | Wraps in `Flexible`/`Expanded` for flex containers |

---

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

<x-preview path="forms/input_states" size="md"></x-preview>

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

### Available State Prefixes

| Prefix | Condition |
| :--- | :--- |
| `focus:` | Applied when input is focused |
| `disabled:` | Applied when `enabled: false` |

---

## Custom States & Validation

Use the `states` prop to apply custom state-based styling. This is perfect for validation:

<x-preview path="forms/input_states" size="lg"></x-preview>

### Error State Example

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

### Available Custom State Prefixes

You can use any custom state name with the `states` prop:

| State | Usage |
| :--- | :--- |
| `error:` | `states: {'error'}` - Validation errors |
| `success:` | `states: {'success'}` - Valid input |
| `warning:` | `states: {'warning'}` - Warnings |
| Any custom | `states: {'mystate'}` - `mystate:` prefix |

---

## Disabled State

```dart
WInput(
  enabled: false,
  value: 'Cannot edit',
  className: 'p-3 border rounded-lg disabled:bg-gray-100 disabled:text-gray-400',
)
```

---

## Controlled vs Uncontrolled

### Controlled (React-style)

Pass `value` and `onChanged` for full control:

```dart
class _MyFormState extends State<MyForm> {
  String _name = '';

  @override
  Widget build(BuildContext context) {
    return WInput(
      value: _name,
      onChanged: (value) => setState(() => _name = value),
      placeholder: 'Your name',
    );
  }
}
```

### With External Controller

For advanced use cases, pass your own controller:

```dart
final _controller = TextEditingController();

WInput(
  controller: _controller,
  placeholder: 'Using controller',
)
```

> [!NOTE]
> When using `controller`, the `value` prop is ignored.

---

## Keyboard Actions

Customize keyboard behavior for mobile users:

```dart
WInput(
  textInputAction: TextInputAction.search,
  onSubmitted: (value) => _performSearch(value),
  onEditingComplete: () => _focusNextField(),
  textCapitalization: TextCapitalization.words,
  autocorrect: false,
  enableSuggestions: false,
)
```

### Available TextInputAction Values

| Action | Keyboard Button |
| :--- | :--- |
| `TextInputAction.done` | Done / ✓ |
| `TextInputAction.next` | Next → |
| `TextInputAction.search` | Search 🔍 |
| `TextInputAction.send` | Send |
| `TextInputAction.go` | Go |
| `TextInputAction.newline` | Enter (multiline) |

---

## Placeholder Styling

Use `placeholderClassName` to style placeholder text:

```dart
WInput(
  placeholder: 'Enter your email',
  placeholderClassName: 'text-gray-400 text-sm italic',
  className: 'text-gray-900 p-3 border rounded-lg',
)
```

If no `placeholderClassName` is provided, placeholder inherits text color with 50% opacity.

---

## API Reference

### Properties

| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `value` | `String?` | `null` | Controlled value |
| `onChanged` | `ValueChanged<String>?` | `null` | Called on value change |
| `type` | `InputType` | `text` | Input type |
| `className` | `String?` | `null` | Tailwind-like classes for input |
| `placeholderClassName` | `String?` | `null` | Tailwind-like classes for placeholder |
| `placeholder` | `String?` | `null` | Placeholder text |
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
