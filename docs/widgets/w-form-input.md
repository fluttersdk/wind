# WFormInput

A utility-first form input widget that integrates with Flutter's native Form validation system.

`WFormInput` wraps [WInput](/widgets/w-input) with `FormField<String>` to provide seamless Form validation, automatic error state styling, and controller synchronization.

## Basic Usage

```dart
final _formKey = GlobalKey<FormState>();
final _emailController = TextEditingController();

Form(
  key: _formKey,
  child: Column(
    children: [
      WFormInput(
        controller: _emailController,
        type: InputType.email,
        placeholder: 'Enter your email',
        className: 'w-full p-3 border border-gray-300 rounded-lg',
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Email is required';
          }
          return null;
        },
      ),
      
      FilledButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Form is valid!
          }
        },
        child: Text('Submit'),
      ),
    ],
  ),
)
```

---

## Error Styling

When validation fails, the `error` state is automatically added to the input, activating any `error:` prefixed classes:

```dart
WFormInput(
  className: '''
    p-3 border border-gray-300 rounded-lg
    error:border-red-500 error:ring-2 error:ring-red-200
  ''',
  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
)
```

### How It Works

1. User submits form with `Form.validate()`
2. `WFormInput` runs its validator
3. If validation fails, `error` state is added automatically
4. Classes with `error:` prefix become active
5. Error message is displayed below the input

---

## Error Message Display

By default, `WFormInput` displays the error message below the input. You can customize or hide this:

```dart
// Custom error styling
WFormInput(
  showError: true,  // default
  errorClassName: 'text-red-500 text-sm mt-2',
  validator: ...,
)

// Hide error message (only apply error styling)
WFormInput(
  showError: false,
  className: 'border error:border-red-500',
  validator: ...,
)
```

---

## Label

Show a label above the input:

```dart
WFormInput(
  label: 'Email Address',
  labelClassName: 'text-sm font-semibold text-gray-800 mb-2',
  placeholder: 'you@example.com',
  className: 'p-3 border rounded-lg',
)
```

Default `labelClassName`: `'text-sm font-medium text-gray-700 mb-1'`

---

## Hint

Show helpful text below the input:

```dart
WFormInput(
  hint: 'We will never share your email.',
  hintClassName: 'text-gray-400 text-xs italic mt-1',
  className: 'p-3 border rounded-lg',
)
```

Default `hintClassName`: `'text-gray-500 text-xs mt-1'`

> [!NOTE]
> The hint is automatically hidden when a validation error is displayed.

---

## Controller Bridge with Magic

Bridge with Magic controller validation for a Laravel-like experience:

```dart
class _LoginFormState extends MagicStatefulViewState<LoginForm> {
  final _emailController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return WFormInput(
      controller: _emailController,
      type: InputType.email,
      placeholder: 'you@example.com',
      className: 'p-3 border border-gray-300 rounded-lg error:border-red-500',
      // Bridge: Get error from Magic controller
      validator: (_) => controller.getError('email'),
    );
  }
}
```

---

## Form Reset

`WFormInput` properly responds to `Form.reset()`:

```dart
ElevatedButton(
  onPressed: () {
    _formKey.currentState!.reset();
  },
  child: Text('Reset'),
)
```

This clears:
- Input value (resets to `initialValue`)
- Error state
- Error message

---

## All WInput Features

`WFormInput` supports all `WInput` features:

| Feature | Description |
| :--- | :--- |
| **Input Types** | `text`, `password`, `email`, `number`, `multiline` |
| **Focus Styling** | `focus:ring-2 focus:border-blue-500` |
| **Disabled State** | `disabled:bg-gray-100 disabled:opacity-50` |
| **Custom States** | Additional states merged with `error` |
| **Flex Support** | `flex-auto`, `flex-1` for flex layouts |

---

## API Reference

### Properties

| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `controller` | `TextEditingController?` | `null` | External controller |
| `initialValue` | `String?` | `null` | Initial value if no controller |
| `validator` | `FormFieldValidator<String>?` | `null` | Validation function |
| `onSaved` | `FormFieldSetter<String>?` | `null` | Called on `Form.save()` |
| `autovalidateMode` | `AutovalidateMode?` | `null` | When to validate |
| `showError` | `bool` | `true` | Show error message below |
| `errorClassName` | `String` | `'text-red-500 text-xs mt-1'` | Error message styling |
| `label` | `String?` | `null` | Label text above input |
| `labelClassName` | `String` | `'text-sm font-medium text-gray-700 mb-1'` | Label styling |
| `hint` | `String?` | `null` | Hint text below input |
| `hintClassName` | `String` | `'text-gray-500 text-xs mt-1'` | Hint styling |

All [WInput properties](/widgets/w-input#api-reference) are also supported.

---

## See Also

- [WInput](/widgets/w-input) - The base input widget
- [Form (Flutter docs)](https://api.flutter.dev/flutter/widgets/Form-class.html)
