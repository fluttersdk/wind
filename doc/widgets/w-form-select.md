# WFormSelect

A Wind-styled single or multi-select dropdown that integrates seamlessly with Flutter's Form validation. It wraps the core `WSelect` widget with `FormField` logic, providing labels, hint text, and automatic error state handling.

- [Basic Usage](#basic-usage)
- [Constructor](#constructor)
- [Props](#props)
- [Layout Modes](#layout-modes)
- [Event Handling](#event-handling)
- [State Variants](#state-variants)
- [Styling Examples](#styling-examples)
- [All Supported Classes](#all-supported-classes)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<a name="basic-usage"></a>
<!-- TODO: [EXAMPLE_NEEDED] path="widgets/w-form-select" action="CREATE" -->
<!-- Description: Basic WFormSelect with validation in a Form -->
<x-preview path="widgets/w-form-select" size="md" source="example/lib/pages/widgets/w_form_select_basic.dart"></x-preview>

```dart
WFormSelect<String>(
  label: 'Country',
  placeholder: 'Select your country',
  options: [
    SelectOption(value: 'us', label: 'United States'),
    SelectOption(value: 'uk', label: 'United Kingdom'),
  ],
  className: 'w-full border rounded-lg error:border-red-500',
  validator: (value) => value == null ? 'Please select a country' : null,
)
```

## Basic Usage

The `WFormSelect` (and its counterpart `WFormMultiSelect`) is designed to be used inside a `Form` widget. It automatically manages its own state and displays validation errors using the `error:` utility prefix when validation fails.

```dart
Form(
  key: _formKey,
  child: Column(
    children: [
      WFormSelect<String>(
        value: _selectedValue,
        options: myOptions,
        onChange: (v) => setState(() => _selectedValue = v),
        label: 'Select Category',
        validator: (v) => v == null ? 'Required' : null,
      ),
      WButton(
        onTap: () {
          if (_formKey.currentState!.validate()) {
            // Process form
          }
        },
        child: WText('Submit'),
      ),
    ],
  ),
)
```

<a name="constructor"></a>
## Constructor

### WFormSelect

```dart
WFormSelect({
  Key? key,
  T? value,
  String? Function(T?)? validator,
  void Function(T?)? onSaved,
  AutovalidateMode? autovalidateMode,
  bool enabled = true,
  required List<SelectOption<T>> options,
  ValueChanged<T?>? onChange,
  String placeholder = 'Select an option',
  String? className,
  String? menuClassName,
  bool searchable = false,
  String? label,
  String? hint,
  bool showError = true,
  // ... other WSelect props
})
```

### WFormMultiSelect

```dart
WFormMultiSelect({
  Key? key,
  List<T>? values,
  String? Function(List<T>?)? validator,
  void Function(List<T>?)? onSaved,
  required List<SelectOption<T>> options,
  ValueChanged<List<T>>? onMultiChange,
  String placeholder = 'Select options',
  String? label,
  String? hint,
  // ... other multi-select props
})
```

<a name="props"></a>
## Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `className` | `String?` | `null` | Wind utility classes for the select trigger. |
| `options` | `List<SelectOption<T>>` | **Required** | The list of available options to display. |
| `value` | `T?` | `null` | The currently selected value (single select). |
| `values` | `List<T>?` | `[]` | The currently selected values (multi select). |
| `label` | `String?` | `null` | Optional label text displayed above the select. |
| `hint` | `String?` | `null` | Optional hint text displayed below the select. |
| `validator` | `String? Function(T?)?` | `null` | Form validation logic. |
| `showError` | `bool` | `true` | Whether to display the error message when invalid. |
| `searchable` | `bool` | `false` | Enables a search input inside the dropdown. |
| `disabled` | `bool` | `false` | Disables user interaction. |
| `labelClassName`| `String` | `text-sm font-medium...` | Styling for the label text. |
| `errorClassName`| `String` | `text-red-500 text-xs...` | Styling for the error message. |

<a name="layout-modes"></a>
## Layout Modes

`WFormSelect` always uses a vertical `flex-col` layout to stack the label, the select trigger, and the error/hint text.

### Standard Stack

By default, the widget arranges elements in a clean vertical flow.

```dart
WFormSelect<String>(
  label: 'Department',
  hint: 'Choose your primary department',
  options: departments,
  className: 'border p-3 rounded-md',
)
```

<a name="event-handling"></a>
## Event Handling

`WFormSelect` provides standard Form event handlers alongside the select-specific change callbacks.

```dart
WFormSelect<String>(
  options: options,
  onChange: (value) {
    print('Selected: $value');
  },
  onSaved: (value) {
    // Called when FormState.save() is invoked
    _formData.dept = value;
  },
  validator: (value) {
    if (value == null) return 'Selection required';
    return null;
  },
)
```

<a name="state-variants"></a>
## State Variants

Since `WFormSelect` injects the `error` state into the underlying `WSelect`, you can use the `error:` prefix to change the styling when validation fails.

```dart
WFormSelect<String>(
  className: 'border-gray-300 focus:border-blue-500 error:border-red-500 error:bg-red-50',
  options: options,
  validator: (v) => v == null ? 'Error' : null,
)
```

<a name="styling-examples"></a>
## Styling Examples

### Multi-Select Form Field

The `WFormMultiSelect` variation handles lists of values and provides a different set of styling options for selected chips.

<!-- TODO: [EXAMPLE_NEEDED] path="widgets/w-form-multiselect" action="CREATE" -->
<!-- Description: WFormMultiSelect with validation -->
<x-preview path="widgets/w-form-multiselect" size="md" source="example/lib/pages/widgets/w_form_multiselect_basic.dart"></x-preview>

```dart
WFormMultiSelect<String>(
  label: 'Interests',
  values: _selectedInterests,
  options: interestOptions,
  className: 'border-2 rounded-xl p-2',
  onMultiChange: (vals) => setState(() => _selectedInterests = vals),
  validator: (vals) => vals!.isEmpty ? 'Select at least one' : null,
)
```

### Searchable Form Select

Perfect for long lists of options where users need to filter quickly.

```dart
WFormSelect<String>(
  label: 'User',
  searchable: true,
  searchPlaceholder: 'Search by name...',
  options: users,
  className: 'w-full px-4 py-3 bg-white border',
)
```

<a name="all-supported-classes"></a>
## All Supported Classes

Since `WFormSelect` wraps `WSelect`, it supports all standard Wind utilities on the `className` and `menuClassName` props.

| Category | Classes |
|:---------|:--------|
| Sizing | `w-full`, `max-w-md`, `h-12` |
| Spacing | `p-{n}`, `px-{n}`, `py-{n}`, `m-{n}` |
| Borders | `border`, `rounded-{size}`, `ring-{n}` |
| Colors | `bg-{color}`, `text-{color}`, `border-{color}` |
| States | `hover:`, `focus:`, `disabled:`, `error:` |

<a name="customizing-theme"></a>
## Customizing Theme

You can globally customize the default styling of form labels and error messages through `WindThemeData`.

```dart
WindThemeData(
  // Customizing default form select behavior via theme defaults
)
```

<a name="related-documentation"></a>
## Related Documentation

- [WSelect - Core Dropdown Widget](./w-select.md)
- [WFormInput - Validated Text Input](./w-form-input.md)
- [WFormCheckbox - Validated Checkbox](./w-form-checkbox.md)
- [Forms in Wind](../core-concepts/forms.md)
