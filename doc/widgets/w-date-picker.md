# WDatePicker

A compact date picker with popup calendar, supporting single date and date range selection with preset buttons.

<!-- TODO: x-preview - implement live preview component -->
<x-preview path="forms/date_picker_basic" size="md" source="example/lib/pages/forms/date_picker_basic.dart"></x-preview>

## Basic Usage

```dart
WDatePicker(
  value: _selectedDate,
  onChanged: (date) => setState(() => _selectedDate = date),
  placeholder: 'Select date',
  className: 'w-64 bg-white border rounded-lg px-3 py-2',
)
```

## Date Range Selection

<!-- TODO: x-preview - implement live preview component -->
<x-preview path="forms/date_picker_range" size="md" source="example/lib/pages/forms/date_picker_range.dart"></x-preview>

Enable range mode with `isRange: true`. Shows two-month calendar view for selecting start and end dates.

```dart
WDatePicker(
  isRange: true,
  range: _selectedRange,
  onRangeChanged: (range) => setState(() => _selectedRange = range),
  placeholder: 'Select date range',
  className: 'w-80 bg-white border rounded-lg px-3 py-2',
)
```

## Preset Buttons

<!-- TODO: x-preview - implement live preview component -->
<x-preview path="forms/date_picker_presets" size="md" source="example/lib/pages/forms/date_picker_presets.dart"></x-preview>

Add quick-select presets with `showPresets: true` and `presets` list.

```dart
WDatePicker(
  isRange: true,
  range: _range,
  onRangeChanged: (range) => setState(() => _range = range),
  showPresets: true,
  presets: [
    DatePreset.last24Hours(),
    DatePreset.last7Days(),
    DatePreset.last30Days(),
    DatePreset.thisMonth(),
    DatePreset.lastMonth(),
  ],
)
```

### Custom Presets

Create custom presets with `DatePreset.custom()`:

```dart
DatePreset.custom(
  label: 'Last Quarter',
  key: 'last_quarter',
  range: DateTimeRange(
    start: DateTime.now().subtract(Duration(days: 90)),
    end: DateTime.now(),
  ),
  icon: Icons.calendar_view_month,
)
```

## Date Constraints

Limit selectable dates with `minDate` and `maxDate`:

```dart
WDatePicker(
  value: _date,
  onChanged: (date) => setState(() => _date = date),
  minDate: DateTime(2024, 1, 1),
  maxDate: DateTime.now(),
)
```

## Styling

### Trigger Styling

```dart
WDatePicker(
  className: '''
    w-64 px-3 py-2
    bg-white dark:bg-gray-800
    border border-gray-300 dark:border-gray-600
    rounded-lg
    hover:border-gray-400 dark:hover:border-gray-500
  ''',
)
```

### Menu (Popup) Styling

```dart
WDatePicker(
  menuClassName: '''
    bg-white dark:bg-gray-800
    border border-gray-200 dark:border-gray-700
    rounded-xl shadow-xl
    p-4
  ''',
)
```

## Props

| Prop | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `value` | `DateTime?` | - | Selected date (single mode) |
| `range` | `DateTimeRange?` | - | Selected range (range mode) |
| `onChanged` | `ValueChanged<DateTime>?` | - | Single date callback |
| `onRangeChanged` | `ValueChanged<DateTimeRange>?` | - | Range callback |
| `isRange` | `bool` | `false` | Enable range selection |
| `placeholder` | `String?` | `'Select date'` | Placeholder text |
| `className` | `String?` | - | Trigger styling |
| `menuClassName` | `String?` | - | Popup styling |
| `minDate` | `DateTime?` | - | Minimum selectable date |
| `maxDate` | `DateTime?` | - | Maximum selectable date |
| `disabled` | `bool` | `false` | Disable widget |
| `presets` | `List<DatePreset>?` | - | Preset options |
| `showPresets` | `bool` | `false` | Show preset buttons |
| `dateFormat` | `String?` | - | Custom date format |

## DatePreset Factory Constructors

| Factory | Label | Range |
| :--- | :--- | :--- |
| `DatePreset.last24Hours()` | "Last 24 hours" | now-24h to now |
| `DatePreset.last7Days()` | "Last 7 days" | now-7d to now |
| `DatePreset.last30Days()` | "Last 30 days" | now-30d to now |
| `DatePreset.thisMonth()` | "This month" | 1st of month to now |
| `DatePreset.lastMonth()` | "Last month" | Previous month |
| `DatePreset.custom(...)` | Custom | Custom range |

## All Supported Classes

| Category | Classes | Description |
| :--- | :--- | :--- |
| **Sizing** | `w-*`, `h-*` | Trigger dimensions |
| **Padding** | `p-*`, `px-*`, `py-*` | Content padding |
| **Background** | `bg-*` | Fill color |
| **Border** | `border-*`, `rounded-*` | Border style |
| **Shadow** | `shadow-*` | Drop shadow |
| **States** | `hover:*`, `focus:*`, `disabled:*` | State styling |
| **Dark Mode** | `dark:*` | Dark mode variants |

## Related Documentation

- [WFormDatePicker](./w-form-date-picker.md) - Form-integrated date picker
- [WCalendarGrid](./w-calendar-grid.md) - Calendar grid component
- [WPopover](./w-popover.md) - Popover component
