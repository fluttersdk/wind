# WCalendarHeader

A calendar header component for month/year display and navigation between months.

<!-- TODO: x-preview - implement live preview component -->
<x-preview path="calendar/calendar_header_basic" size="md" source="example/lib/pages/calendar/calendar_header_basic.dart"></x-preview>

## Basic Usage

```dart
WCalendarHeader(
  month: _displayMonth,
  onMonthChanged: (newMonth) => setState(() => _displayMonth = newMonth),
)
```

## With Date Constraints

Disable navigation outside allowed range:

```dart
WCalendarHeader(
  month: _displayMonth,
  minDate: DateTime(2024, 1, 1),
  maxDate: DateTime.now(),
  onMonthChanged: (newMonth) => setState(() => _displayMonth = newMonth),
)
```

## Custom Styling

```dart
WCalendarHeader(
  month: _displayMonth,
  onMonthChanged: (m) => setState(() => _displayMonth = m),
  className: 'bg-gray-100 dark:bg-gray-800 p-2 rounded-lg',
  monthYearClassName: 'text-lg font-bold text-gray-900 dark:text-white',
  buttonClassName: 'p-2 rounded-lg hover:bg-gray-200 dark:hover:bg-gray-700 text-gray-600 dark:text-gray-400',
  disabledButtonClassName: 'p-2 rounded-lg text-gray-300 dark:text-gray-600 cursor-not-allowed',
)
```

## Props

| Prop | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `month` | `DateTime` | required | Current month to display |
| `onMonthChanged` | `ValueChanged<DateTime>?` | - | Month change callback |
| `className` | `String?` | - | Container styling |
| `minDate` | `DateTime?` | - | Minimum navigable date |
| `maxDate` | `DateTime?` | - | Maximum navigable date |
| `locale` | `Locale?` | - | Locale for month names |
| `monthYearClassName` | `String?` | - | Month/year text styling |
| `buttonClassName` | `String?` | - | Navigation button styling |
| `disabledButtonClassName` | `String?` | - | Disabled button styling |

## Navigation Behavior

- **Previous button** (`chevron_left`): Goes to previous month
- **Next button** (`chevron_right`): Goes to next month
- **Year boundary**: Automatically handles Dec→Jan and Jan→Dec transitions
- **Constraints**: Buttons disabled when at min/max month

## Display Format

Month and year are displayed in English format:

```
February 2026
```

## Related Documentation

- [WCalendarGrid](./w-calendar-grid.md) - Calendar day grid
- [WDatePicker](./w-date-picker.md) - Complete date picker widget
