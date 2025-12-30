# WFormSelect

Wind-styled select widgets that integrate with Flutter's Form validation system.

## WFormSelect (Single-Select)

```dart
Form(
  key: _formKey,
  child: WFormSelect<String>(
    value: _country,
    options: [
      SelectOption(value: 'us', label: 'United States'),
      SelectOption(value: 'uk', label: 'United Kingdom'),
    ],
    onChange: (v) => setState(() => _country = v),
    label: 'Country',
    hint: 'Select your country',
    className: 'w-64 border rounded-lg error:border-red-500',
    validator: (value) => value == null ? 'Required' : null,
  ),
)
```

---

## WFormMultiSelect (Multi-Select)

```dart
WFormMultiSelect<String>(
  values: _selectedTags,
  options: tagOptions,
  onMultiChange: (v) => setState(() => _selectedTags = v),
  label: 'Tags',
  className: 'w-80 border rounded-lg error:border-red-500',
  validator: (values) {
    if (values == null || values.isEmpty) return 'Select at least one';
    if (values.length > 5) return 'Maximum 5 allowed';
    return null;
  },
)
```

---

## Error Styling

When validation fails, `error` state is automatically added:

```dart
WFormSelect(
  className: '''
    w-64 border border-gray-300 rounded-lg
    error:border-red-500 error:ring-2 error:ring-red-200
  ''',
  validator: (value) => value == null ? 'Required' : null,
)
```

---

## Label & Hint

Both widgets support label and hint:

```dart
WFormSelect(
  label: 'Country',
  labelClassName: 'text-sm font-semibold',
  hint: 'We ship worldwide',
  hintClassName: 'text-gray-400 text-xs',
  ...
)
```

> [!NOTE]
> Hint is hidden when error message is displayed.

---

## Controller Bridge

Bridge with Magic controller validation:

```dart
WFormSelect(
  validator: (_) => controller.getError('country'),
  ...
)
```

---

## API Reference

### WFormSelect Properties

| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `value` | `T?` | `null` | Selected value |
| `options` | `List<SelectOption<T>>` | required | Available options |
| `onChange` | `ValueChanged<T?>?` | `null` | Selection callback |
| `validator` | `FormFieldValidator<T>?` | `null` | Validation function |
| `label` | `String?` | `null` | Label above select |
| `hint` | `String?` | `null` | Hint below select |
| `showError` | `bool` | `true` | Show error message |
| `searchable` | `bool` | `false` | Enable search |

### WFormMultiSelect Additional Properties

| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `values` | `List<T>?` | `null` | Selected values |
| `onMultiChange` | `ValueChanged<List<T>>?` | `null` | Selection callback |

All [WSelect properties](/widgets/w-select) are also supported.

---

## See Also

- [WSelect](/widgets/w-select) - Base select widget
- [WFormInput](/widgets/w-form-input) - Form input widget
