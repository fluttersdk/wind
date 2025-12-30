# WFormCheckbox

A Wind-styled checkbox that integrates with Flutter's Form validation.

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

---

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
        TextSpan(
          text: 'Terms',
          style: TextStyle(color: Colors.blue),
        ),
      ],
    ),
  ),
)
```

---

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

---

## Hint

```dart
WFormCheckbox(
  hint: 'Optional but recommended',
  hintClassName: 'text-gray-400 text-xs',
)
```

> [!NOTE]
> Hint is hidden when error message is displayed.

---

## API Reference

| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `value` | `bool` | `false` | Initial checked state |
| `onChanged` | `ValueChanged<bool>?` | `null` | Change callback |
| `validator` | `FormFieldValidator<bool>?` | `null` | Validation function |
| `className` | `String?` | `null` | Checkbox styling |
| `labelText` | `String?` | `null` | Simple text label |
| `label` | `Widget?` | `null` | Custom label widget |
| `hint` | `String?` | `null` | Hint text below |
| `showError` | `bool` | `true` | Show error message |
| `disabled` | `bool` | `false` | Disable interaction |

---

## WCheckbox States Enhancement

WCheckbox now supports custom states via `states` prop:

```dart
WCheckbox(
  value: isChecked,
  states: {'error', 'loading'},
  className: 'w-5 h-5 border error:border-red-500 loading:opacity-50',
)
```

---

## See Also

- [WCheckbox](/widgets/w-checkbox) - Base checkbox widget
- [WFormInput](/widgets/w-form-input) - Form input widget
