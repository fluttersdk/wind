# WFormDatePicker

A form-integrated date picker with validation, labels, hints, and error display.

<!-- TODO: x-preview - implement live preview component -->
<x-preview path="forms/form_date_picker_basic" size="md" source="example/lib/pages/forms/form_date_picker_basic.dart"></x-preview>

## Basic Usage

```dart
Form(
  child: WFormDatePicker(
    label: 'Start Date',
    hint: 'Select when to start',
    validator: (date) => date == null ? 'Date is required' : null,
    onSaved: (date) => _startDate = date,
  ),
)
```

## With Initial Value

```dart
WFormDatePicker(
  initialValue: DateTime(2026, 2, 15),
  label: 'Event Date',
  placeholder: 'Choose date',
  validator: (date) {
    if (date == null) return 'Required';
    if (date.isBefore(DateTime.now())) return 'Must be in the future';
    return null;
  },
)
```

## Date Range Form Field

<!-- TODO: x-preview - implement live preview component -->
<x-preview path="forms/form_date_range_picker" size="md" source="example/lib/pages/forms/form_date_range_picker.dart"></x-preview>

Use `WFormDateRangePicker` for date range selection in forms:

```dart
WFormDateRangePicker(
  label: 'Date Range',
  hint: 'Select start and end dates',
  showPresets: true,
  presets: [
    DatePreset.last7Days(),
    DatePreset.last30Days(),
  ],
  validator: (range) {
    if (range == null) return 'Date range is required';
    if (range.duration.inDays > 90) return 'Max 90 days allowed';
    return null;
  },
  onSaved: (range) => _dateRange = range,
)
```

## Styling

### Error State

Error styling is automatically applied when validation fails:

```dart
WFormDatePicker(
  label: 'Date',
  className: '''
    border border-gray-300 rounded-lg
    error:border-red-500 error:ring-2 error:ring-red-200
  ''',
  errorClassName: 'text-red-500 text-xs mt-1',
)
```

### Custom Label and Hint Styling

```dart
WFormDatePicker(
  label: 'Deadline',
  labelClassName: 'text-sm font-semibold text-gray-800 dark:text-gray-200',
  hint: 'When should this be completed?',
  hintClassName: 'text-xs text-gray-500 dark:text-gray-400 mt-1',
)
```

## Props

### WFormDatePicker

| Prop | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `initialValue` | `DateTime?` | - | Initial date value |
| `validator` | `FormFieldValidator<DateTime>?` | - | Validation function |
| `onSaved` | `FormFieldSetter<DateTime>?` | - | Save callback |
| `autovalidateMode` | `AutovalidateMode?` | - | When to validate |
| `enabled` | `bool` | `true` | Enable/disable field |
| `label` | `String?` | - | Label text |
| `labelClassName` | `String?` | - | Label styling |
| `hint` | `String?` | - | Hint text |
| `hintClassName` | `String?` | - | Hint styling |
| `errorClassName` | `String?` | - | Error text styling |
| `placeholder` | `String?` | - | Placeholder text |
| `className` | `String?` | - | Picker styling |
| `menuClassName` | `String?` | - | Popup styling |
| `minDate` | `DateTime?` | - | Minimum date |
| `maxDate` | `DateTime?` | - | Maximum date |
| `presets` | `List<DatePreset>?` | - | Preset options |
| `showPresets` | `bool` | `false` | Show presets |
| `onChanged` | `ValueChanged<DateTime?>?` | - | Change callback |

### WFormDateRangePicker

Same props as `WFormDatePicker`, but with:

| Prop | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `initialValue` | `DateTimeRange?` | - | Initial range value |
| `validator` | `FormFieldValidator<DateTimeRange>?` | - | Validation function |
| `onSaved` | `FormFieldSetter<DateTimeRange>?` | - | Save callback |
| `onChanged` | `ValueChanged<DateTimeRange?>?` | - | Change callback |

## Form Integration Example

```dart
final _formKey = GlobalKey<FormState>();
DateTime? _startDate;
DateTimeRange? _dateRange;

Form(
  key: _formKey,
  child: Column(
    children: [
      WFormDatePicker(
        label: 'Start Date',
        validator: (date) => date == null ? 'Required' : null,
        onSaved: (date) => _startDate = date,
      ),
      SizedBox(height: 16),
      WFormDateRangePicker(
        label: 'Project Duration',
        showPresets: true,
        presets: [DatePreset.last30Days()],
        validator: (range) => range == null ? 'Required' : null,
        onSaved: (range) => _dateRange = range,
      ),
      SizedBox(height: 24),
      WButton(
        onTap: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            // Use _startDate and _dateRange
          }
        },
        child: WText('Submit'),
      ),
    ],
  ),
)
```

## All Supported Classes

| Category | Classes | Description |
| :--- | :--- | :--- |
| **Sizing** | `w-*`, `h-*` | Field dimensions |
| **Padding** | `p-*`, `px-*`, `py-*` | Content padding |
| **Background** | `bg-*` | Fill color |
| **Border** | `border-*`, `rounded-*` | Border style |
| **States** | `error:*`, `disabled:*` | State styling |
| **Dark Mode** | `dark:*` | Dark mode variants |

## Related Documentation

- [WDatePicker](./w-date-picker.md) - Base date picker widget
- [WFormInput](./w-form-input.md) - Form text input
- [WFormSelect](./w-form-select.md) - Form select widget
