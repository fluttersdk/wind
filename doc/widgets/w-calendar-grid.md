# WCalendarGrid

A calendar grid widget that displays a month view with weekday headers and selectable day cells. It supports single date selection, date range highlighting, and date constraints.

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

<x-preview path="widgets/w_calendar_grid" size="md" source="example/lib/pages/widgets/w_calendar_grid.dart"></x-preview>

<a name="basic-usage"></a>
## Basic Usage

The `WCalendarGrid` widget renders a 7-column grid representing a specific month. It handles the logic for date offsets, previous/next month day padding, and date selection states.

```dart
WCalendarGrid(
  month: DateTime.now(),
  onDateSelected: (date) {
    // Handle date selection
  },
)
```

<a name="constructor"></a>
## Constructor

```dart
const WCalendarGrid({
  Key? key,
  required DateTime month,
  DateTime? selectedDate,
  DateTimeRange? selectedRange,
  DateTime? minDate,
  DateTime? maxDate,
  ValueChanged<DateTime>? onDateSelected,
  String? className,
  String? dayClassName,
  String? selectedDayClassName,
  String? disabledDayClassName,
  String? rangeDayClassName,
  String? todayClassName,
  String? weekdayHeaderClassName,
  int firstDayOfWeek = DateTime.sunday,
})
```

<a name="props"></a>
## Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `month` | `DateTime` | **Required** | The month to display (only year and month are used) |
| `selectedDate` | `DateTime?` | `null` | Currently selected single date |
| `selectedRange` | `DateTimeRange?` | `null` | Currently selected date range for highlighting |
| `minDate` | `DateTime?` | `null` | Minimum selectable date |
| `maxDate` | `DateTime?` | `null` | Maximum selectable date |
| `onDateSelected` | `ValueChanged<DateTime>?` | `null` | Callback when a day cell is tapped |
| `className` | `String?` | `null` | Wind utility classes for the grid container |
| `dayClassName` | `String?` | `null` | Utility classes for standard day cells |
| `selectedDayClassName` | `String?` | `null` | Utility classes for the selected day cell |
| `disabledDayClassName` | `String?` | `null` | Utility classes for disabled/out-of-month cells |
| `rangeDayClassName` | `String?` | `null` | Utility classes for days within a selected range |
| `todayClassName` | `String?` | `null` | Utility classes for the current date cell |
| `weekdayHeaderClassName` | `String?` | `null` | Utility classes for the weekday initials (Su, Mo, etc.) |
| `firstDayOfWeek` | `int` | `DateTime.sunday` | Starting day of the week (1-7) |

<a name="layout-modes"></a>
## Layout Modes

`WCalendarGrid` is a specialized grid component. It automatically calculates a 6-week grid (42 days) to ensure consistent height across different months, including leading and trailing days from adjacent months.

### Custom Grid Container
You can style the outer container of the grid using the `className` prop.

```dart
WCalendarGrid(
  month: DateTime.now(),
  className: 'bg-white dark:bg-gray-800 p-4 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700',
)
```

<a name="event-handling"></a>
## Event Handling

The primary event is `onDateSelected`, which triggers when a user taps a valid, non-disabled day cell.

```dart
WCalendarGrid(
  month: DateTime.now(),
  onDateSelected: (date) {
    setState(() => _selected = date);
  },
)
```

<a name="state-variants"></a>
## State Variants

Unlike most Wind widgets that use `hover:` or `focus:` prefixes in a single `className`, `WCalendarGrid` provides specific props for different date states:

- **Selected**: Applied when `date == selectedDate`.
- **Range**: Applied to dates between `selectedRange.start` and `selectedRange.end`.
- **Today**: Applied to the current system date.
- **Disabled**: Applied to dates outside `minDate`/`maxDate` or outside the current month.

```dart
WCalendarGrid(
  month: DateTime.now(),
  selectedDayClassName: 'bg-indigo-600 text-white shadow-md',
  todayClassName: 'border-2 border-indigo-600 text-indigo-600',
  rangeDayClassName: 'bg-indigo-50 text-indigo-900',
)
```

<a name="styling-examples"></a>
## Styling Examples

### Custom Weekday Headers
Modify the appearance of the "Su", "Mo", etc., labels.

```dart
WCalendarGrid(
  month: DateTime.now(),
  weekdayHeaderClassName: 'text-[10px] uppercase tracking-wider text-gray-400 font-bold',
)
```

### Subtle Range Selection
Creating a soft highlight for date ranges.

```dart
WCalendarGrid(
  month: DateTime.now(),
  selectedRange: DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now().add(const Duration(days: 5)),
  ),
  rangeDayClassName: 'bg-blue-50 dark:bg-blue-900/30 text-blue-700 dark:text-blue-300',
  selectedDayClassName: 'bg-blue-600 text-white',
)
```

<a name="all-supported-classes"></a>
## All Supported Classes

The grid container and individual cell props support the standard Wind utility categories.

| Category | Classes |
|:---------|:--------|
| Layout | `flex`, `grid`, `block`, `hidden` |
| Spacing | `p-{n}`, `m-{n}`, `gap-{n}` |
| Sizing | `w-{size}`, `h-{size}` |
| Typography | `text-{size}`, `font-{weight}`, `italic`, `uppercase` |
| Colors | `bg-{color}`, `text-{color}` |
| Borders | `border`, `rounded`, `ring`, `shadow` |

<a name="customizing-theme"></a>
## Customizing Theme

Default styling for `WCalendarGrid` relies on the theme's primary color and gray scales.

```dart
WindThemeData(
  colors: {
    'primary': Colors.indigo, // Affects default selected/range colors
  },
)
```

<a name="related-documentation"></a>
## Related Documentation

- [WDatePicker](./w-date-picker.md)
- [WCalendarHeader](./w-calendar-header.md)
- [Background Color](../background/background-color.md)
- [Border Radius](../borders/border-radius.md)
