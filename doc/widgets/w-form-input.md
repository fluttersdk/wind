# WFormInput

A Wind-styled input that integrates seamlessly with Flutter's native Form validation system. It extends `FormField` to provide automatic error handling, label management, and state-based styling through utility classes.

<!-- TODO: [EXAMPLE_NEEDED] path="widgets/w-form-input" action="CREATE" -->
<!-- Description: Basic form with WFormInput showing validation and label usage -->
<x-preview path="widgets/w-form-input" size="md" source="example/lib/pages/widgets/w_form_input.dart"></x-preview>

```dart
WFormInput(
  label: 'Email Address',
  placeholder: 'you@example.com',
  className: 'p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 error:border-red-500',
  validator: (value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!value.contains('@')) return 'Invalid email address';
    return null;
  },
)
```

## Basic Usage

The `WFormInput` widget wraps a standard `WInput` with a `FormField`. It automatically manages its own internal `TextEditingController` if one isn't provided, and synchronizes its state with the parent `Form` widget.

When validation fails, the widget automatically activates the `error` state, enabling any `error:` prefixed utility classes in your `className`.

```dart
Form(
  key: _formKey,
  child: Column(
    children: [
      WFormInput(
        label: 'Username',
        className: 'border p-2 error:bg-red-50',
        validator: (v) => v!.length < 3 ? 'Too short' : null,
      ),
      WButton(
        onTap: () => _formKey.currentState!.validate(),
        child: Text('Submit'),
      ),
    ],
  ),
)
```

## Constructor

```dart
WFormInput({
  Key? key,
  TextEditingController? controller,
  String? initialValue,
  String? Function(String?)? validator,
  void Function(String?)? onSaved,
  AutovalidateMode? autovalidateMode,
  bool enabled = true,
  
  // WInput props
  InputType type = InputType.text,
  String? placeholder,
  String? className,
  String? placeholderClassName,
  TextInputAction? textInputAction,
  ValueChanged<String>? onSubmitted,
  ValueChanged<String>? onChanged,
  VoidCallback? onEditingComplete,
  VoidCallback? onTap,
  TapRegionCallback? onTapOutside,
  bool readOnly = false,
  bool autofocus = false,
  int? maxLines,
  int minLines = 1,
  Set<String>? states,
  List<TextInputFormatter>? inputFormatters,
  TextCapitalization textCapitalization = TextCapitalization.none,
  bool autocorrect = true,
  bool enableSuggestions = true,
  
  // Layout props
  String? label,
  String labelClassName = 'text-sm font-medium text-gray-700 mb-1',
  String? hint,
  String hintClassName = 'text-gray-500 text-xs mt-1',
  bool showError = true,
  String errorClassName = 'text-red-500 text-xs mt-1',
  
  // Prefix/Suffix
  Widget? prefix,
  Widget? suffix,
})
```

## Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `className` | `String?` | `null` | Utility classes for the input field. Supports `error:`, `focus:`, and `disabled:` prefixes. |
| `label` | `String?` | `null` | Label text displayed above the input. |
| `labelClassName` | `String` | `'text-sm...'` | Styling for the label text. |
| `hint` | `String?` | `null` | Helper text displayed below the input. Hidden when validation error is active. |
| `hintClassName` | `String` | `'text-gray-500...'` | Styling for the hint text. |
| `showError` | `bool` | `true` | Whether to display the error message string below the input. |
| `errorClassName` | `String` | `'text-red-500...'` | Styling for the validation error message text. |
| `controller` | `TextEditingController?` | `null` | Optional external controller for manual text management. |
| `validator` | `String? Function(String?)?` | `null` | Form validation logic returning error string or null. |
| `type` | `InputType` | `InputType.text` | Determines keyboard layout and visual masking (e.g., `password`). |
| `prefix` | `Widget?` | `null` | Widget (like an Icon) displayed before the input text. |
| `suffix` | `Widget?` | `null` | Widget (like a visibility toggle) displayed after the input text. |

## Layout Modes

### Vertical Stack (Default)
`WFormInput` organizes its components in a vertical column: label at the top, followed by the input field, and then the hint or error message at the bottom.

<!-- TODO: [EXAMPLE_NEEDED] path="widgets/w-form-input_layout" action="CREATE" -->
<!-- Description: WFormInput showing the vertical stack of label, input, and hint -->
<x-preview path="widgets/w-form-input_layout" size="md" source="example/lib/pages/widgets/w_form_input_layout.dart"></x-preview>

```dart
WFormInput(
  label: 'Account Number',
  hint: 'Enter the 12-digit number found on your statement.',
  className: 'border p-3 rounded',
)
```

## Event Handling

`WFormInput` supports all standard text input events. `onChanged` automatically notifies the internal `FormFieldState` to track validation in real-time if `autovalidateMode` is enabled.

```dart
WFormInput(
  className: 'border p-2',
  onChanged: (value) => print('Typing: $value'),
  onSubmitted: (value) => print('Final value: $value'),
)
```

## State Variants

Interactive styling is achieved through state prefixes. `WFormInput` automatically manages the `error` state based on validation results.

```dart
WFormInput(
  className: '''
    border border-gray-300 
    focus:border-blue-500 focus:ring-1 
    error:border-red-500 error:bg-red-50
    disabled:bg-gray-100 disabled:text-gray-400
  ''',
  validator: (v) => v!.isEmpty ? 'Required' : null,
)
```

## Styling Examples

### Custom Error Feedback
You can completely customize how the error appears by using `error:` classes on the main input and styling the error message specifically.

```dart
WFormInput(
  label: 'Password',
  type: InputType.password,
  className: 'border-b-2 error:border-red-600',
  errorClassName: 'text-red-600 font-bold mt-2 italic',
  validator: (v) => v!.length < 8 ? 'Password too short' : null,
)
```

### Minimalist Style
Removing the default labels and hints for a tighter, cleaner UI.

```dart
WFormInput(
  placeholder: 'Search...',
  className: 'bg-gray-100 rounded-full px-4 py-2 border-none focus:bg-white focus:ring-2 focus:ring-blue-500/50',
  showError: false, // Only use error: styling on the input itself
)
```

## All Supported Classes

Since `WFormInput` uses `WInput` internally, it supports all standard utility categories.

| Category | Classes |
|:---------|:--------|
| Layout | `flex`, `grid`, `block`, `hidden` |
| Spacing | `p-{n}`, `m-{n}`, `gap-{n}` |
| Sizing | `w-{size}`, `h-{size}` |
| Typography | `text-{size}`, `font-{weight}` |
| Colors | `bg-{color}`, `text-{color}` |
| Borders | `border`, `rounded`, `ring` |
| State | `hover:`, `focus:`, `disabled:`, `error:` |

## Customizing Theme

Default styles for labels, hints, and error messages can be influenced globally through `WindThemeData`.

```dart
WindThemeData(
  // The base spacing unit affects all p-{n}, m-{n}, and gap-{n} classes
  baseSpacingUnit: 4.0,
)
```

## Related Documentation

- [WInput](./w-input.md) - The base input widget.
- [WButton](./w-button.md) - Standard button for form submission.
- [WFormCheckbox](./w-form-checkbox.md) - Form-integrated checkbox.
- [WText](./w-text.md) - The underlying typography system.
