# WDatePicker

A utility-first date picker component built on [WPopover](./w-popover.md) with support for single date selection, date range selection, min/max constraints, and custom display formatting.

- [Basic Usage](#basic-usage)
- [Constructor](#constructor)
- [Props](#props)
- [Types](#types)
- [Date Range Selection](#date-range-selection)
- [Min/Max Constraints](#minmax-constraints)
- [Custom Display Format](#custom-display-format)
- [Event Handling](#event-handling)
- [State Variants](#state-variants)
- [Styling Examples](#styling-examples)
- [Calendar Internals](#calendar-internals)
- [All Supported Classes](#all-supported-classes)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

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

`WDatePicker` renders a trigger container that opens a popover-based calendar on click. It handles month navigation, today highlighting, and date constraints out of the box.

```dart
DateTime? _selectedDate;

WDatePicker(
  value: _selectedDate,
  onChanged: (date) {
    setState(() => _selectedDate = date);
  },
  className: 'bg-white border rounded-md px-4 py-2 hover:border-blue-500',
)
```

When no `className` is provided, the trigger uses this default styling:

```dart
// Default trigger className
'bg-white border border-gray-300 rounded-lg p-3 dark:bg-gray-800 dark:border-gray-600'
```

The calendar popover opens below the trigger and auto-flips if there isn't enough space. In single mode, the popover closes automatically after a date is selected.

## Constructor

```dart
const WDatePicker({
  Key? key,
  WDatePickerMode mode = WDatePickerMode.single,
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
| `mode` | `WDatePickerMode` | `single` | Selection mode: `single` or `range` |
| `value` | `DateTime?` | `null` | Currently selected date (single mode) |
| `range` | `DateRange?` | `null` | Currently selected range (range mode) |
| `onChanged` | `ValueChanged<DateTime>?` | `null` | Callback fired on date selection (single mode) |
| `onRangeChanged` | `ValueChanged<DateRange>?` | `null` | Callback fired on range selection (range mode) |
| `minDate` | `DateTime?` | `null` | Earliest selectable date |
| `maxDate` | `DateTime?` | `null` | Latest selectable date |
| `className` | `String?` | `null` | Wind utility classes for the trigger container |
| `placeholder` | `String` | `'Select date'` | Text shown when no value is selected |
| `disabled` | `bool` | `false` | Prevents interaction, shows forbidden cursor |
| `states` | `Set<String>` | `const {}` | Custom states for dynamic styling |
| `displayFormat` | `DateDisplayFormat?` | `null` | Custom function to format dates for display |

## Types

### WDatePickerMode

Determines if the picker operates in single date or date range selection mode.

```dart
enum WDatePickerMode {
  single,  // Pick a single date
  range,   // Pick a start and end date
}
```

### DateRange

Represents a date range with a required start and optional end date.

```dart
class DateRange {
  final DateTime start;
  final DateTime? end;

  bool get isComplete => end != null;

  DateRange copyWith({DateTime? start, DateTime? end});
}
```

### DateDisplayFormat

A typedef for custom date formatting:

```dart
typedef DateDisplayFormat = String Function(DateTime date);
```

When no `displayFormat` is provided, dates display as `"Jan 15, 2025"` format.

## Date Range Selection

Setting `mode: WDatePickerMode.range` enables two-click range selection with hover preview.

<x-preview path="widgets/date_picker_range" size="md" source="example/lib/pages/widgets/date_picker_range.dart"></x-preview>

```dart
DateRange? _dateRange;

WDatePicker(
  mode: WDatePickerMode.range,
  range: _dateRange,
  onRangeChanged: (range) => setState(() => _dateRange = range),
  placeholder: 'Check-in / Check-out',
  className: 'w-64 border p-3 rounded-lg',
)
```

How range selection works:

1. **First click** — Sets the range start. The `onRangeChanged` callback fires with a `DateRange` where `end` is `null`.
2. **Hover** — As the user moves the mouse, dates between start and the hovered date are highlighted with a blue tint.
3. **Second click** — Completes the range. If the second date is before the first, they're automatically swapped. The popover closes.

The trigger display text updates throughout: `"Jan 15, 2025 - ..."` while in progress, then `"Jan 15, 2025 - Jan 20, 2025"` when complete.

## Min/Max Constraints

Use `minDate` and `maxDate` to restrict which dates are selectable. Dates outside the range appear dimmed and don't respond to clicks.

```dart
WDatePicker(
  value: _selectedDate,
  onChanged: (date) => setState(() => _selectedDate = date),
  minDate: DateTime.now(),
  maxDate: DateTime.now().add(const Duration(days: 90)),
  className: 'p-3 border rounded-lg',
  placeholder: 'Next 90 days only',
)
```

> [!NOTE]
> Constraints are compared at day-level granularity. Time components are stripped before comparison.

## Custom Display Format

Override the default `"Jan 15, 2025"` format with a custom function:

```dart
WDatePicker(
  value: _selectedDate,
  onChanged: (date) => setState(() => _selectedDate = date),
  displayFormat: (date) => '${date.day}/${date.month}/${date.year}',
  className: 'p-3 border rounded-lg',
)
```

In range mode, the format function applies to both start and end dates independently.

## Event Handling

### Single Mode

`onChanged` fires with a normalized `DateTime` (midnight, no time component) when the user selects a date:

```dart
WDatePicker(
  value: _date,
  onChanged: (date) {
    setState(() => _date = date);
    _loadSchedule(date);
  },
)
```

### Range Mode

`onRangeChanged` fires twice during a range selection — once on the first click (start only) and once on the second click (complete range):

```dart
WDatePicker(
  mode: WDatePickerMode.range,
  range: _range,
  onRangeChanged: (range) {
    setState(() => _range = range);
    if (range.isComplete) {
      _calculateDuration(range.start, range.end!);
    }
  },
)
```

## State Variants

`WDatePicker` automatically manages several interactive states. Use state prefixes in `className` to apply conditional styles.

| State | Activated When |
|:------|:---------------|
| `hover:` | Mouse hovers over the trigger |
| `focus:` | Calendar popover is open |
| `open:` | Calendar popover is open (alias for `focus:`) |
| `disabled:` | `disabled` prop is `true` |
| `selected:` | A date or range has been selected |

```dart
WDatePicker(
  value: _date,
  onChanged: (date) => setState(() => _date = date),
  className: 'p-3 border border-gray-300 rounded-lg '
      'hover:border-blue-400 '
      'focus:border-blue-500 focus:ring-2 focus:ring-blue-200 '
      'selected:bg-blue-50 '
      'disabled:opacity-50 disabled:bg-gray-100',
)
```

### Disabled State

When `disabled: true`, the trigger shows a forbidden cursor and the popover won't open:

```dart
WDatePicker(
  disabled: true,
  value: DateTime(2025, 6, 15),
  className: 'p-3 border rounded-lg disabled:opacity-50 disabled:bg-gray-100',
)
```

## Styling Examples

### Default Styling

Without a `className`, the trigger uses built-in defaults with dark mode support:

```dart
WDatePicker(
  value: _date,
  onChanged: (date) => setState(() => _date = date),
  // Uses: 'bg-white border border-gray-300 rounded-lg p-3
  //        dark:bg-gray-800 dark:border-gray-600'
)
```

### Interactive with Ring Focus

<x-preview path="widgets/date_picker_styled" size="md" source="example/lib/pages/widgets/date_picker_styled.dart"></x-preview>

```dart
WDatePicker(
  value: _date,
  onChanged: (date) => setState(() => _date = date),
  className: 'w-full p-3 bg-white dark:bg-gray-800 '
      'border border-gray-300 dark:border-gray-600 rounded-lg '
      'hover:border-blue-400 dark:hover:border-blue-500 '
      'focus:border-blue-500 focus:ring-2 focus:ring-blue-200 '
      'dark:focus:ring-blue-800 '
      'selected:border-blue-500',
)
```

### Compact Inline

```dart
WDatePicker(
  value: _date,
  onChanged: (date) => setState(() => _date = date),
  className: 'px-2 py-1 text-sm border rounded bg-gray-50 hover:bg-white',
  placeholder: 'Date',
)
```

### Borderless with Shadow

```dart
WDatePicker(
  value: _date,
  onChanged: (date) => setState(() => _date = date),
  className: 'p-3 bg-white rounded-xl shadow-md hover:shadow-lg',
)
```

## Calendar Internals

The calendar popover is styled with a fixed-width container:

```
'w-[320px] bg-white dark:bg-gray-800 border border-gray-200
 dark:border-gray-700 rounded-xl shadow-xl p-4'
```

The calendar grid consists of:

| Component | Details |
|:----------|:--------|
| **Header** | Month/year label with left/right navigation arrows |
| **Weekday row** | `Mo Tu We Th Fr Sa Su` (Monday start) |
| **Date grid** | 6 rows × 7 columns = 42 cells |
| **Today** | Highlighted with `bg-gray-100 dark:bg-gray-700 rounded-full` |
| **Selected** | `bg-blue-500 text-white rounded-full` |
| **In range** | `bg-blue-100 dark:bg-blue-900/30 text-blue-700` |
| **Out of month** | `text-gray-300 dark:text-gray-600` |
| **Disabled** | `text-gray-300 dark:text-gray-600`, no click |

> [!NOTE]
> The calendar chrome (header, grid, day cells) uses hardcoded Wind classes and is not configurable via `className`. The `className` prop only controls the trigger element.

## All Supported Classes

### Trigger (className)

The `className` prop styles the trigger container. All Wind utility classes are supported:

| Category | Examples |
|:---------|:---------|
| Background | `bg-white`, `bg-gray-50`, `dark:bg-gray-800` |
| Border | `border`, `border-2`, `border-gray-300`, `rounded-lg`, `rounded-xl` |
| Padding | `p-3`, `px-4`, `py-2` |
| Sizing | `w-full`, `w-64`, `w-[300px]` |
| Ring | `ring-2`, `ring-blue-200`, `ring-offset-2` |
| Shadow | `shadow-sm`, `shadow-md`, `shadow-lg` |
| Typography | `text-sm` (affects placeholder/display text indirectly via icon color) |
| Opacity | `opacity-50`, `opacity-75` |
| State prefixes | `hover:`, `focus:`, `open:`, `disabled:`, `selected:`, `dark:` |
| Responsive | `sm:`, `md:`, `lg:`, `xl:`, `2xl:` |

### What className Does NOT Control

The calendar popover, header, weekday labels, and day cells use internal Wind classes that are not configurable via props.

## Customizing Theme

The calendar's selection colors (`bg-blue-500`, `bg-blue-100`) and neutral grays use Tailwind color scales from `WindThemeData`. Override them to change the visual appearance:

```dart
WindTheme(
  data: WindThemeData(
    colors: {
      ...WindThemeData.defaultColors,
      'blue': {
        100: Color(0xFFDBEAFE),  // Range fill
        500: Color(0xFF3B82F6),  // Selected day
        700: Color(0xFF1D4ED8),  // Range text
        900: Color(0xFF1E3A8A),  // Dark mode range
      },
    },
  ),
  child: MyApp(),
)
```

## Related Documentation

- [WFormDatePicker](./w-form-date-picker.md) - Form-integrated date picker with validation
- [WSelect](./w-select.md) - Dropdown selection component
- [WPopover](./w-popover.md) - The underlying overlay engine
- [WInput](./w-input.md) - Standard text input widget
