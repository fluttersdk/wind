# WDatePicker

A highly customizable, utility-first date picker component that supports single date selection, date range selection, and min/max constraints.

- [Basic Usage](#basic-usage)
- [Date Range Selection](#date-range-selection)
- [Constructor](#constructor)
- [Props](#props)
- [Types](#types)
- [Form Integration](#form-integration)
- [State Variants](#state-variants)
- [Related Documentation](#related-documentation)

<!-- TODO: [EXAMPLE_NEEDED] path="widgets/date_picker_basic" action="CREATE" -->
<!-- Description: Basic single date picker usage -->
<x-preview path="widgets/date_picker_basic" size="md" source="example/lib/pages/widgets/date_picker_basic.dart"></x-preview>

```dart
WDatePicker(
  value: _selectedDate,
  onChanged: (date) => setState(() => _selectedDate = date),
  className: 'w-full p-3 border border-gray-300 rounded-lg',
  placeholder: 'Select a date',
)
```

## Basic Usage

The `WDatePicker` widget provides a clean, popover-based calendar for selecting dates. It handles month navigation, today highlighting, and selectable date constraints out of the box.

```dart
WDatePicker(
  value: DateTime.now(),
  onChanged: (date) {
    print('Picked: $date');
  },
  className: 'bg-white border rounded-md px-4 py-2 hover:border-blue-500',
)
```

## Date Range Selection

By setting `mode: DatePickerMode.range`, the picker allows users to select a start and end date. It features a hover preview to visualize the range before the second click completes the selection.

<!-- TODO: [EXAMPLE_NEEDED] path="widgets/date_picker_range" action="CREATE" -->
<!-- Description: Date range picker usage -->
<x-preview path="widgets/date_picker_range" size="md" source="example/lib/pages/widgets/date_picker_range.dart"></x-preview>

```dart
WDatePicker(
  mode: DatePickerMode.range,
  range: _dateRange,
  onRangeChanged: (range) => setState(() => _dateRange = range),
  placeholder: 'Check-in / Check-out',
  className: 'w-64 border p-3 rounded-lg',
)
```

## Constructor

```dart
const WDatePicker({
  Key? key,
  DatePickerMode mode = DatePickerMode.single,
  DateTime? value,
  DateRange? range,
  ValueChanged<DateTime>? onChanged,
  ValueChanged<DateRange>? onRangeChanged,
  DateTime? minDate,
  DateTime? maxDate,
  String? className,
  String placeholder = 'Select date',
  bool disabled = false,
  Set<String> states = const {},
  DateDisplayFormat? displayFormat,
})
```

## Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `mode` | `DatePickerMode` | `single` | Selection mode: `single` or `range` |
| `value` | `DateTime?` | `null` | Currently selected date (single mode) |
| `range` | `DateRange?` | `null` | Currently selected range (range mode) |
| `onChanged` | `ValueChanged<DateTime>?` | `null` | Callback for single date selection |
| `onRangeChanged` | `ValueChanged<DateRange>?` | `null` | Callback for range selection |
| `minDate` | `DateTime?` | `null` | Minimum selectable date |
| `maxDate` | `DateTime?` | `null` | Maximum selectable date |
| `className` | `String?` | `null` | Utility classes for the trigger container |
| `placeholder` | `String` | `'Select date'` | Text shown when no value is selected |
| `disabled` | `bool` | `false` | Prevents interaction |
| `displayFormat` | `DateDisplayFormat?` | `null` | Custom function to format dates for display |

## Types

### DatePickerMode
Determines if the picker operates in `single` or `range` mode.

### DateRange
A simple class representing the selection in range mode.
```dart
class DateRange {
  final DateTime start;
  final DateTime? end;
  
  bool get isComplete => end != null;
}
```

## Form Integration

The `WFormDatePicker` widget provides a seamless way to use date selection within a Flutter `Form`. It handles validation states and provides standard form furniture like labels and error messages.

<!-- TODO: [EXAMPLE_NEEDED] path="forms/date_picker_validation" action="CREATE" -->
<!-- Description: Form integrated date picker with validation -->
<x-preview path="forms/date_picker_validation" size="md" source="example/lib/pages/forms/date_picker_validation.dart"></x-preview>

```dart
WFormDatePicker(
  label: 'Event Date',
  hint: 'Pick a date for your meeting',
  validator: (v) => v == null ? 'Date is required' : null,
  className: 'p-3 border rounded-lg error:border-red-500',
  onChanged: (date) => _saveDate(date),
)
```

### Form Specific Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `label` | `String?` | `null` | Label text displayed above the picker |
| `labelClassName` | `String` | `...` | Utility classes for the label |
| `showError` | `bool` | `true` | Whether to display validation errors |
| `errorClassName` | `String` | `...` | Utility classes for error text |
| `hint` | `String?` | `null` | Hint text displayed below the picker |

## State Variants

`WDatePicker` automatically manages several states that you can style using prefixes in `className`:

- `hover:` - When the mouse is over the trigger.
- `focus:` (or `open:`) - When the calendar popover is open.
- `disabled:` - When the widget is disabled.
- `selected:` - When a date or range has been selected.
- `error:` - (Form version) When validation fails.

```dart
WDatePicker(
  className: 'border-gray-300 hover:border-blue-500 selected:bg-blue-50',
)
```

## Related Documentation

- [WInput](./w-input.md) - Standard text input widget
- [WSelect](./w-select.md) - Dropdown selection component
- [WPopover](./w-popover.md) - The underlying overlay engine
