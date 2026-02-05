# WCalendarGrid

A reusable calendar grid component for displaying month views with selectable day cells.

<!-- TODO: x-preview - implement live preview component -->
<x-preview path="calendar/calendar_grid_basic" size="md" source="example/lib/pages/calendar/calendar_grid_basic.dart"></x-preview>

## Basic Usage

```dart
WCalendarGrid(
  month: DateTime(2026, 2, 1),
  selectedDate: _selectedDate,
  onDateSelected: (date) => setState(() => _selectedDate = date),
)
```

## Date Range Highlighting

<!-- TODO: x-preview - implement live preview component -->
<x-preview path="calendar/calendar_grid_range" size="md" source="example/lib/pages/calendar/calendar_grid_range.dart"></x-preview>

Display a highlighted date range:

```dart
WCalendarGrid(
  month: DateTime(2026, 2, 1),
  selectedRange: DateTimeRange(
    start: DateTime(2026, 2, 10),
    end: DateTime(2026, 2, 20),
  ),
  onDateSelected: (date) => _handleDateTap(date),
)
```

## Date Constraints

Disable dates outside a valid range:

```dart
WCalendarGrid(
  month: DateTime(2026, 2, 1),
  minDate: DateTime(2026, 2, 5),
  maxDate: DateTime(2026, 2, 25),
  onDateSelected: (date) => setState(() => _date = date),
)
```

## Custom Styling

```dart
WCalendarGrid(
  month: DateTime(2026, 2, 1),
  className: 'bg-gray-50 dark:bg-gray-900 p-2 rounded-lg',
  dayClassName: 'text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-full',
  selectedDayClassName: 'bg-primary text-white rounded-full font-medium',
  disabledDayClassName: 'text-gray-300 dark:text-gray-600 cursor-not-allowed',
  rangeDayClassName: 'bg-primary/10 dark:bg-primary/20 text-gray-900 dark:text-gray-100',
  todayClassName: 'border border-primary text-primary rounded-full font-medium',
  weekdayHeaderClassName: 'text-xs font-medium text-gray-500 dark:text-gray-400',
)
```

## Props

| Prop | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `month` | `DateTime` | required | Month to display |
| `selectedDate` | `DateTime?` | - | Single selected date |
| `selectedRange` | `DateTimeRange?` | - | Selected date range |
| `minDate` | `DateTime?` | - | Minimum selectable date |
| `maxDate` | `DateTime?` | - | Maximum selectable date |
| `onDateSelected` | `ValueChanged<DateTime>?` | - | Date tap callback |
| `className` | `String?` | - | Grid container styling |
| `dayClassName` | `String?` | - | Day cell styling |
| `selectedDayClassName` | `String?` | - | Selected day styling |
| `disabledDayClassName` | `String?` | - | Disabled day styling |
| `rangeDayClassName` | `String?` | - | Range day styling |
| `todayClassName` | `String?` | - | Today styling |
| `weekdayHeaderClassName` | `String?` | - | Weekday header styling |
| `firstDayOfWeek` | `int` | `DateTime.sunday` | First day of week |

## Grid Structure

The calendar grid displays:

- **7 weekday headers** (Su, Mo, Tu, We, Th, Fr, Sa)
- **6 rows of day cells** (42 total cells)
- **Previous/next month days** shown with faded styling

## Visual States

| State | Styling Applied |
| :--- | :--- |
| Selected | `selectedDayClassName` |
| In Range | `rangeDayClassName` |
| Today | `todayClassName` |
| Disabled | `disabledDayClassName` |
| Normal | `dayClassName` |
| Other Month | Faded/disabled |

## Related Documentation

- [WCalendarHeader](./w-calendar-header.md) - Month navigation header
- [WDatePicker](./w-date-picker.md) - Complete date picker widget
