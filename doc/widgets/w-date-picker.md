# WDatePicker

WDatePicker is a utility-first date selection component that provides a sleek, customizable calendar popup for picking single dates or date ranges.

<!-- TODO: [EXAMPLE_NEEDED] path="widgets/w-date-picker" action="CREATE" -->
<!-- Description: Basic WDatePicker usage showing a single date selection -->
<x-preview path="widgets/w-date-picker" size="md" source="example/lib/pages/widgets/w-date-picker.dart"></x-preview>

```dart
WDatePicker(
  value: selectedDate,
  onChanged: (date) => setState(() => selectedDate = date),
  placeholder: 'Select a date',
)
```

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
## Basic Usage

The `WDatePicker` widget manages its own overlay mechanism to ensure stability across complex widget trees. It supports both single date selection and date range selection with optional presets.

```dart
// Single date selection
WDatePicker(
  value: DateTime.now(),
  onChanged: (date) => print('Selected: $date'),
)
```

<a name="constructor"></a>
## Constructor

```dart
const WDatePicker({
  Key? key,
  DateTime? value,
  DateTimeRange? range,
  ValueChanged<DateTime>? onChanged,
  ValueChanged<DateTimeRange>? onRangeChanged,
  bool isRange = false,
  String? placeholder,
  String? className,
  String? menuClassName,
  DateTime? minDate,
  DateTime? maxDate,
  bool disabled = false,
  List<DatePreset>? presets,
  bool showPresets = false,
  String? dateFormat,
})
```

<a name="props"></a>
## Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `className` | `String?` | `null` | Wind utility classes for the trigger (button). |
| `value` | `DateTime?` | `null` | The currently selected single date. |
| `range` | `DateTimeRange?` | `null` | The currently selected date range (used when `isRange` is true). |
| `onChanged` | `ValueChanged<DateTime>?` | `null` | Callback triggered when a single date is selected. |
| `onRangeChanged` | `ValueChanged<DateTimeRange>?` | `null` | Callback triggered when a date range is selected. |
| `isRange` | `bool` | `false` | Enables date range selection mode. |
| `placeholder` | `String?` | `'Select date'` | Text displayed when no date is selected. |
| `menuClassName` | `String?` | `null` | Wind utility classes for the calendar popup menu. |
| `minDate` | `DateTime?` | `null` | The earliest selectable date. |
| `maxDate` | `DateTime?` | `null` | The latest selectable date. |
| `disabled` | `bool` | `false` | Disables the picker and prevents opening the menu. |
| `presets` | `List<DatePreset>?` | `null` | List of quick-select date ranges (e.g., "Last 7 Days"). |
| `showPresets` | `bool` | `false` | Whether to display the preset buttons in range mode. |
| `dateFormat` | `String?` | `null` | Custom pattern for formatting the displayed date. |

<a name="layout-modes"></a>
## Layout Modes

### Single Date Mode
In single date mode (default), the picker displays a single calendar month.

<!-- TODO: [EXAMPLE_NEEDED] path="widgets/w-date-picker_single" action="CREATE" -->
<!-- Description: WDatePicker in single date selection mode -->
<x-preview path="widgets/w-date-picker_single" size="md" source="example/lib/pages/widgets/w-date-picker_single.dart"></x-preview>

```dart
WDatePicker(
  isRange: false,
  value: selectedDate,
  onChanged: (date) => setState(() => selectedDate = date),
)
```

### Date Range Mode
When `isRange` is true, the picker displays two side-by-side calendars for selecting a start and end date.

<!-- TODO: [EXAMPLE_NEEDED] path="widgets/w-date-picker_range" action="CREATE" -->
<!-- Description: WDatePicker in range selection mode with presets -->
<x-preview path="widgets/w-date-picker_range" size="md" source="example/lib/pages/widgets/w-date-picker_range.dart"></x-preview>

```dart
WDatePicker(
  isRange: true,
  showPresets: true,
  range: selectedRange,
  onRangeChanged: (range) => setState(() => selectedRange = range),
)
```

<a name="event-handling"></a>
## Event Handling

The picker provides dedicated callbacks for both selection modes.

```dart
WDatePicker(
  // Single selection
  onChanged: (date) {
    print('User picked $date');
  },
  
  // Range selection
  onRangeChanged: (range) {
    print('User picked range from ${range.start} to ${range.end}');
  },
)
```

<a name="state-variants"></a>
## State Variants

You can use standard state prefixes like `disabled:` to style the trigger when the picker is inactive.

```dart
WDatePicker(
  disabled: true,
  className: 'bg-gray-100 border-gray-200 disabled:opacity-50 disabled:cursor-not-allowed',
)
```

<a name="styling-examples"></a>
## Styling Examples

### Custom Trigger Design
You can completely overhaul the look of the input trigger using `className`.

```dart
WDatePicker(
  className: 'bg-indigo-50 border-indigo-200 rounded-full px-6 py-3 shadow-sm',
  placeholder: 'Pick a day...',
)
```

### Menu Customization
Use `menuClassName` to style the calendar container (e.g., adding shadows or changing the background).

```dart
WDatePicker(
  menuClassName: 'bg-white dark:bg-gray-900 shadow-2xl rounded-2xl border-none',
)
```

<a name="all-supported-classes"></a>
## All Supported Classes

| Category | Classes |
|:---------|:--------|
| Layout | `flex`, `grid`, `block`, `hidden`, `items-center`, `gap-{n}` |
| Spacing | `p-{n}`, `px-{n}`, `py-{n}`, `m-{n}`, `mt-{n}` |
| Sizing | `w-{size}`, `h-{size}`, `min-w-{size}`, `max-w-{size}` |
| Typography | `text-{size}`, `font-{weight}`, `truncate` |
| Colors | `bg-{color}`, `text-{color}`, `dark:bg-{color}` |
| Borders | `border`, `border-{width}`, `rounded-{size}`, `shadow-{size}` |

<a name="customizing-theme"></a>
## Customizing Theme

`WDatePicker` inherits styles from the global `WindThemeData`. Specifically, it uses the color palette for the calendar grid and header buttons.

```dart
WindThemeData(
  colors: {
    'primary': Colors.blue, // Affects selected dates
  },
)
```

<a name="related-documentation"></a>
## Related Documentation

- [WCalendarGrid](./w-calendar-grid.md)
- [WCalendarHeader](./w-calendar-header.md)
- [WPopover](./w-popover.md)
