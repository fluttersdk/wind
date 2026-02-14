# WFormDatePicker

A form-integrated date picker that wraps [WDatePicker](./w-date-picker.md) with Flutter's `FormField<DateTime>`. Provides native form validation, automatic `error:` state styling, and optional label, hint, and error message display.

- [Basic Usage](#basic-usage)
- [Constructor](#constructor)
- [Props](#props)
- [Form Validation](#form-validation)
- [Range Mode in Forms](#range-mode-in-forms)
- [Event Handling](#event-handling)
- [State Variants](#state-variants)
- [Styling Examples](#styling-examples)
- [All Supported Classes](#all-supported-classes)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<x-preview path="forms/form_date_picker_basic" size="md" source="example/lib/pages/forms/form_date_picker_basic.dart"></x-preview>

```dart
WFormDatePicker(
  label: 'Birth Date',
  hint: 'We need your date of birth for verification',
  className: 'p-3 border border-gray-300 rounded-lg error:border-red-500',
  validator: (value) => value == null ? 'Please select a date' : null,
  onChanged: (date) => print('Selected: $date'),
)
```

## Basic Usage

`WFormDatePicker` works inside a Flutter `Form` widget. It renders a vertical layout with an optional label above the date picker and error/hint text below.

```dart
final _formKey = GlobalKey<FormState>();

Form(
  key: _formKey,
  child: Column(
    children: [
      WFormDatePicker(
        label: 'Event Date',
        className: 'p-3 border rounded-lg error:border-red-500',
        validator: (date) => date == null ? 'Date is required' : null,
        onChanged: (date) => _eventDate = date,
      ),
      WButton(
        className: 'mt-4 bg-blue-500 text-white px-4 py-2 rounded-lg',
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
          }
        },
        child: WText('Submit'),
      ),
    ],
  ),
)
```

When validation fails, the widget automatically adds the `error` state to the inner `WDatePicker`, activating any `error:` prefixed classes.

## Constructor

```dart
WFormDatePicker({
  Key? key,
  // FormField params
  FormFieldValidator<DateTime>? validator,
  FormFieldSetter<DateTime>? onSaved,
  AutovalidateMode? autovalidateMode,
  bool enabled = true,
  // WDatePicker params
  DateTime? initialValue,
  DateRange? initialRange,
  DatePickerMode mode = DatePickerMode.single,
  ValueChanged<DateTime>? onChanged,
  ValueChanged<DateRange>? onRangeChanged,
  DateTime? minDate,
  DateTime? maxDate,
  String? className,
  String? placeholder,
  Set<String>? states,
  DateDisplayFormat? displayFormat,
  // Form wrapper params
  String? label,
  String labelClassName = 'text-sm font-medium text-gray-700 dark:text-gray-300 mb-1',
  bool showError = true,
  String errorClassName = 'text-red-500 text-xs mt-1',
  String? hint,
  String hintClassName = 'text-gray-500 text-xs mt-1',
})
```

## Props

### FormField Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `validator` | `FormFieldValidator<DateTime>?` | `null` | Validation function, receives `DateTime?` |
| `onSaved` | `FormFieldSetter<DateTime>?` | `null` | Called when form is saved |
| `autovalidateMode` | `AutovalidateMode?` | `null` | When to auto-validate |
| `enabled` | `bool` | `true` | Whether the picker is interactive |
| `initialValue` | `DateTime?` | `null` | Initial selected date (single mode) |

### Date Picker Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `mode` | `DatePickerMode` | `single` | Selection mode: `single` or `range` |
| `initialRange` | `DateRange?` | `null` | Initial date range (range mode) |
| `onChanged` | `ValueChanged<DateTime>?` | `null` | Called on date selection (single mode) |
| `onRangeChanged` | `ValueChanged<DateRange>?` | `null` | Called on range selection (range mode) |
| `minDate` | `DateTime?` | `null` | Earliest selectable date |
| `maxDate` | `DateTime?` | `null` | Latest selectable date |
| `className` | `String?` | `null` | Wind utility classes for the trigger |
| `placeholder` | `String?` | `null` | Placeholder text (defaults to `'Select date'`) |
| `states` | `Set<String>?` | `null` | Custom states for dynamic styling |
| `displayFormat` | `DateDisplayFormat?` | `null` | Custom date display format function |

### Layout Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `label` | `String?` | `null` | Label text displayed above the picker |
| `labelClassName` | `String` | `'text-sm font-medium text-gray-700 dark:text-gray-300 mb-1'` | Wind classes for the label |
| `showError` | `bool` | `true` | Whether to display validation error text |
| `errorClassName` | `String` | `'text-red-500 text-xs mt-1'` | Wind classes for error message |
| `hint` | `String?` | `null` | Hint text displayed below the picker |
| `hintClassName` | `String` | `'text-gray-500 text-xs mt-1'` | Wind classes for hint text |

> [!NOTE]
> When both an error and hint are present, the error message takes priority and the hint is hidden.

## Form Validation

The `validator` function receives the currently selected `DateTime?` value. Return a `String` to show an error, or `null` if valid.

```dart
WFormDatePicker(
  label: 'Departure Date',
  className: 'p-3 border rounded-lg error:border-red-500 error:bg-red-50',
  validator: (date) {
    if (date == null) return 'Please select a departure date';
    if (date.isBefore(DateTime.now())) return 'Date must be in the future';
    return null;
  },
)
```

### Auto-Validation

Use `autovalidateMode` to validate as the user interacts:

```dart
WFormDatePicker(
  label: 'Start Date',
  autovalidateMode: AutovalidateMode.onUserInteraction,
  className: 'p-3 border rounded-lg error:border-red-500',
  validator: (date) => date == null ? 'Required' : null,
)
```

### Using onSaved

```dart
DateTime? _savedDate;

WFormDatePicker(
  label: 'Meeting Date',
  className: 'p-3 border rounded-lg',
  onSaved: (date) => _savedDate = date,
  validator: (date) => date == null ? 'Required' : null,
)
```

## Range Mode in Forms

In range mode, the `FormField<DateTime>` internally tracks the range's **start date** for validation purposes. This means a simple null check still works as a "required" validator.

<x-preview path="forms/form_date_picker_range" size="md" source="example/lib/pages/forms/form_date_picker_range.dart"></x-preview>

```dart
WFormDatePicker(
  label: 'Trip Dates',
  mode: DatePickerMode.range,
  initialRange: null,
  className: 'p-3 border rounded-lg error:border-red-500',
  placeholder: 'Select check-in / check-out',
  validator: (date) => date == null ? 'Please select your trip dates' : null,
  onRangeChanged: (range) {
    if (range.isComplete) {
      _calculateTripDuration(range);
    }
  },
)
```

> [!NOTE]
> The `validator` receives the range's start `DateTime` — not a `DateRange` object. For more complex range validation (e.g., minimum stay duration), use the `onRangeChanged` callback to manage validation externally.

## Event Handling

`onChanged` and `onRangeChanged` fire alongside the form state updates. The `FormFieldState` is updated automatically — you don't need to call `didChange` yourself.

```dart
WFormDatePicker(
  label: 'Appointment',
  onChanged: (date) {
    // FormField state is already updated at this point
    _loadAvailableSlots(date);
  },
)
```

## State Variants

`WFormDatePicker` inherits all state variants from `WDatePicker` and adds the `error` state automatically when validation fails.

| State | Activated When |
|:------|:---------------|
| `hover:` | Mouse hovers over the trigger |
| `focus:` | Calendar popover is open |
| `open:` | Calendar popover is open (alias) |
| `disabled:` | `enabled` is `false` |
| `selected:` | A date or range has been selected |
| `error:` | Form validation has failed |

```dart
WFormDatePicker(
  label: 'Date',
  className: 'p-3 border border-gray-300 rounded-lg '
      'hover:border-blue-400 '
      'focus:border-blue-500 focus:ring-2 focus:ring-blue-200 '
      'error:border-red-500 error:ring-2 error:ring-red-200 '
      'disabled:opacity-50 disabled:bg-gray-100',
  validator: (date) => date == null ? 'Required' : null,
)
```

## Styling Examples

### Standard Form Field

```dart
WFormDatePicker(
  label: 'Date of Birth',
  hint: 'You must be at least 18 years old',
  className: 'w-full p-3 border border-gray-300 rounded-lg '
      'focus:border-blue-500 focus:ring-2 focus:ring-blue-200 '
      'error:border-red-500',
  maxDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
  validator: (date) => date == null ? 'Date of birth is required' : null,
)
```

### Dark Mode Ready

```dart
WFormDatePicker(
  label: 'Schedule',
  labelClassName: 'text-sm font-medium text-gray-700 dark:text-gray-300',
  className: 'p-3 bg-white dark:bg-gray-800 '
      'border border-gray-300 dark:border-gray-600 rounded-lg '
      'hover:border-blue-400 dark:hover:border-blue-500 '
      'error:border-red-500 dark:error:border-red-400',
  errorClassName: 'text-red-500 dark:text-red-400 text-xs mt-1',
  validator: (date) => date == null ? 'Required' : null,
)
```

### Minimalist

```dart
WFormDatePicker(
  label: 'When',
  labelClassName: 'text-xs text-gray-500 uppercase tracking-wider',
  className: 'border-b border-gray-200 py-2 rounded-none '
      'focus:border-blue-500 error:border-red-500',
  hintClassName: 'text-gray-400 text-xs mt-0.5',
  hint: 'Optional',
)
```

## All Supported Classes

### Trigger (className)

All Wind utility classes work on the trigger container. The most commonly used:

| Category | Examples |
|:---------|:---------|
| Background | `bg-white`, `bg-gray-50`, `dark:bg-gray-800` |
| Border | `border`, `border-gray-300`, `rounded-lg` |
| Padding | `p-3`, `px-4`, `py-2` |
| Sizing | `w-full`, `w-64` |
| Ring | `ring-2`, `ring-blue-200` |
| Shadow | `shadow-sm` |
| State prefixes | `hover:`, `focus:`, `disabled:`, `selected:`, `error:`, `dark:` |

### Label (labelClassName)

Default: `text-sm font-medium text-gray-700 dark:text-gray-300 mb-1`

### Error (errorClassName)

Default: `text-red-500 text-xs mt-1`

### Hint (hintClassName)

Default: `text-gray-500 text-xs mt-1`

## Customizing Theme

`WFormDatePicker` inherits all theme customization from `WDatePicker`. Override Tailwind color scales in `WindThemeData` to change selection colors, error states, and calendar chrome:

```dart
WindTheme(
  data: WindThemeData(
    colors: {
      ...WindThemeData.defaultColors,
      'red': {
        500: Color(0xFFEF4444), // Error border color
        200: Color(0xFFFECACA), // Error ring color
      },
    },
  ),
  child: MyApp(),
)
```

## Related Documentation

- [WDatePicker](./w-date-picker.md) - The base date picker widget
- [WFormInput](./w-form-input.md) - Form-integrated text input
- [WFormSelect](./w-form-select.md) - Form-integrated dropdown
- [WFormCheckbox](./w-form-checkbox.md) - Form-integrated checkbox
- [WPopover](./w-popover.md) - The underlying overlay engine
