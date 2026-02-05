# WFormInput

A utility-first form input widget that integrates with Flutter's native Form validation system.

<x-preview path="forms/form_input_basic" size="md" source="example/lib/pages/forms/form_input_basic.dart"></x-preview>

## Basic Usage

```dart
Form(
  key: _formKey,
  child: WFormInput(
    controller: _emailController,
    type: InputType.email,
    placeholder: 'Enter your email',
    className: 'p-3 border border-gray-300 rounded-lg error:border-red-500',
    validator: (value) {
      if (value == null || value.isEmpty) return 'Email is required';
      return null;
    },
  ),
)
```

## Error Styling

When validation fails, the `error` state is automatically added:

```dart
WFormInput(
  className: '''
    p-3 border border-gray-300 rounded-lg
    error:border-red-500 error:ring-2 error:ring-red-200
  ''',
  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
)
```

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

## Hint

Show helpful text below the input:

```dart
WFormInput(
  hint: 'We will never share your email.',
  hintClassName: 'text-gray-400 text-xs italic mt-1',
  className: 'p-3 border rounded-lg',
)
```

> [!NOTE]
> The hint is automatically hidden when a validation error is displayed.

## Prefix & Suffix

Add icons inside the input:

```dart
WFormInput(
  prefix: Icon(Icons.email, size: 20),
  suffix: Icon(Icons.check, color: Colors.green),
  className: 'p-3 border rounded-lg',
)
```

## Props

| Prop | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `controller` | `TextEditingController?` | `null` | External controller |
| `initialValue` | `String?` | `null` | Initial value if no controller |
| `validator` | `FormFieldValidator<String>?` | `null` | Validation function |
| `onSaved` | `FormFieldSetter<String>?` | `null` | Called on `Form.save()` |
| `autovalidateMode` | `AutovalidateMode?` | `null` | When to validate |
| `label` | `String?` | `null` | Label text above input |
| `labelClassName` | `String` | `'text-sm font-medium...'` | Label styling |
| `hint` | `String?` | `null` | Hint text below input |
| `hintClassName` | `String` | `'text-gray-500 text-xs mt-1'` | Hint styling |
| `showError` | `bool` | `true` | Show error message below |
| `errorClassName` | `String` | `'text-red-500 text-xs mt-1'` | Error styling |
| `prefix` | `Widget?` | `null` | Widget before input |
| `suffix` | `Widget?` | `null` | Widget after input |

All [WInput properties](./w-input.md#props) are also supported.

## State Prefixes

| Prefix | Activates When |
| :--- | :--- |
| `focus:` | Input is focused |
| `error:` | Validation fails |
| `disabled:` | `enabled: false` |

## All Supported Classes

| Category | Classes | Description |
| :--- | :--- | :--- |
| **Sizing** | `w-*`, `h-*`, `w-full` | Input dimensions |
| **Padding** | `p-*`, `px-*`, `py-*` | Content padding |
| **Background** | `bg-*` | Fill color |
| **Border** | `border-*`, `rounded-*` | Border style |
| **Error** | `error:border-*`, `error:ring-*` | Error styling |
| **Typography** | `text-*`, `font-*` | Text styling |

## Related Documentation

- [WInput](./w-input.md) - Base input widget
- [WFormCheckbox](./w-form-checkbox.md) - Form checkbox widget
