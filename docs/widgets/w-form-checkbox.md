# WFormCheckbox

A Wind-styled checkbox that integrates with Flutter's Form validation.

<x-preview path="forms/form_checkbox_basic" size="md" source="example/lib/pages/forms/form_checkbox_basic.dart"></x-preview>

## Basic Usage

```dart
Form(
  key: _formKey,
  child: WFormCheckbox(
    value: _agreeTerms,
    onChanged: (v) => setState(() => _agreeTerms = v),
    labelText: 'I agree to Terms of Service',
    className: 'w-5 h-5 rounded border checked:bg-blue-500 error:border-red-500',
    validator: (value) => value != true ? 'You must agree' : null,
  ),
)
```

## Label Options

### Text Label

```dart
WFormCheckbox(
  labelText: 'Subscribe to newsletter',
  labelClassName: 'text-sm font-medium',
)
```

### Custom Widget Label

```dart
WFormCheckbox(
  label: RichText(
    text: TextSpan(
      text: 'I accept the ',
      children: [
        TextSpan(text: 'Terms', style: TextStyle(color: Colors.blue)),
      ],
    ),
  ),
)
```

## Error Styling

When validation fails, `error` state is automatically added:

```dart
WFormCheckbox(
  className: '''
    w-5 h-5 rounded border border-gray-300
    checked:bg-blue-500 error:border-red-500
  ''',
  validator: (value) => value != true ? 'Required' : null,
)
```

## Props

| Prop | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `value` | `bool` | `false` | Initial checked state |
| `onChanged` | `ValueChanged<bool>?` | `null` | Change callback |
| `validator` | `FormFieldValidator<bool>?` | `null` | Validation function |
| `className` | `String?` | `null` | Checkbox styling |
| `iconClassName` | `String?` | `null` | Check icon classes |
| `labelText` | `String?` | `null` | Simple text label |
| `label` | `Widget?` | `null` | Custom label widget |
| `labelClassName` | `String` | `'text-sm text-gray-700'` | Label classes |
| `hint` | `String?` | `null` | Hint text below |
| `hintClassName` | `String` | `'text-gray-500 text-xs mt-1'` | Hint classes |
| `showError` | `bool` | `true` | Show error message |
| `errorClassName` | `String` | `'text-red-500 text-xs mt-1'` | Error classes |
| `disabled` | `bool` | `false` | Disable interaction |
| `checkIcon` | `IconData?` | `null` | Custom check icon |
| `states` | `Set<String>?` | `null` | Custom states |

## State Prefixes

| Prefix | Activates When |
| :--- | :--- |
| `checked:` | `value` is true |
| `error:` | Validation fails |
| `hover:` | Mouse is over checkbox |
| `disabled:` | `disabled` is true |

## All Supported Classes

| Category | Classes | Description |
| :--- | :--- | :--- |
| **Sizing** | `w-*`, `h-*` | Checkbox dimensions |
| **Border** | `rounded-*`, `border-*` | Border radius and width |
| **Background** | `bg-*`, `checked:bg-*` | Background colors |
| **Error** | `error:border-*`, `error:bg-*` | Error state styling |
| **Layout** | `items-center`, `justify-center` | Content alignment |
| **Effects** | `opacity-*`, `disabled:opacity-*` | Opacity |

> [!NOTE]
> Hint is hidden when error message is displayed.

## Related Documentation

- [WCheckbox](./w-checkbox.md) - Base checkbox widget
- [WFormInput](./w-form-input.md) - Form input widget
