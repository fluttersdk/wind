# WCalendarHeader

A calendar navigation header component that displays the current month and year with navigation buttons. It is primarily used as a sub-component within the `WDatePicker`.

<!-- TODO: [EXAMPLE_NEEDED] path="widgets/calendar_header_basic" action="CREATE" -->
<!-- Description: Basic calendar header with month navigation -->
<x-preview path="widgets/calendar_header_basic" size="md" source="example/lib/pages/widgets/calendar_header_basic.dart"></x-preview>

```dart
WCalendarHeader(
  month: DateTime.now(),
  onMonthChanged: (newMonth) {
    print('Navigated to: $newMonth');
  },
)
```

## Basic Usage

The `WCalendarHeader` displays the month name and year (e.g., "February 2026") and provides chevron buttons to navigate between months. It automatically handles disabling navigation buttons if `minDate` or `maxDate` constraints are reached.

```dart
WCalendarHeader(
  month: _currentMonth,
  minDate: DateTime(2020),
  maxDate: DateTime(2030),
  onMonthChanged: (date) => setState(() => _currentMonth = date),
)
```

## Constructor

```dart
const WCalendarHeader({
  Key? key,
  required DateTime month,
  ValueChanged<DateTime>? onMonthChanged,
  String? className,
  DateTime? minDate,
  DateTime? maxDate,
  Locale? locale,
  String? monthYearClassName,
  String? buttonClassName,
  String? disabledButtonClassName,
})
```

## Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `month` | `DateTime` | **Required** | The month to display (only year and month are used). |
| `onMonthChanged` | `ValueChanged<DateTime>?` | `null` | Callback when navigation buttons are tapped. |
| `className` | `String?` | `null` | Utility classes for the header container. |
| `minDate` | `DateTime?` | `null` | Minimum date allowed for navigation. |
| `maxDate` | `DateTime?` | `null` | Maximum date allowed for navigation. |
| `locale` | `Locale?` | `null` | Locale used for month name formatting. |
| `monthYearClassName` | `String?` | `null` | Utility classes for the month/year label text. |
| `buttonClassName` | `String?` | `null` | Utility classes for active navigation buttons. |
| `disabledButtonClassName` | `String?` | `null` | Utility classes for disabled navigation buttons. |

## Layout Modes

### Standard Header
The header uses a `spaceBetween` Row layout, placing the "Previous" button on the left, the "Next" button on the right, and the month/year label centered.

```dart
WCalendarHeader(
  month: DateTime(2026, 2),
  className: 'bg-white border-b border-gray-200 px-2 py-4',
)
```

## Event Handling

The `onMonthChanged` callback provides the first day of the newly selected month whenever the user clicks the navigation arrows.

```dart
WCalendarHeader(
  month: _month,
  onMonthChanged: (newMonth) {
    setState(() {
      _month = newMonth;
    });
  },
)
```

## State Variants

While `WCalendarHeader` itself is a stateless widget, it uses `WButton` for navigation, which supports interactive state prefixes:

```dart
WCalendarHeader(
  month: DateTime.now(),
  // Active buttons will have a red background on hover
  buttonClassName: 'p-2 rounded hover:bg-red-50 text-red-600',
  // Disabled buttons will look ghosted
  disabledButtonClassName: 'p-2 opacity-30 cursor-not-allowed',
)
```

## Styling Examples

### Custom Colors
You can style the inner elements separately from the main container.

```dart
WCalendarHeader(
  month: DateTime.now(),
  className: 'bg-indigo-600 rounded-t-xl',
  monthYearClassName: 'text-white font-bold tracking-tight',
  buttonClassName: 'text-white/80 hover:text-white hover:bg-white/10 p-2 rounded-lg',
)
```

### Compact View
Adjust padding and text size for smaller calendar interfaces.

```dart
WCalendarHeader(
  month: DateTime.now(),
  className: 'py-1 px-2',
  monthYearClassName: 'text-sm font-medium',
  buttonClassName: 'p-1',
)
```

## All Supported Classes

Since `WCalendarHeader` maps its `className` to a `Container` and uses `WText` and `WButton` internally, it supports most standard utilities.

| Category | Classes |
|:---------|:--------|
| Layout | `flex`, `hidden` |
| Spacing | `p-{n}`, `m-{n}`, `px-{n}`, `py-{n}` |
| Sizing | `w-{size}`, `h-{size}` |
| Typography | `text-{size}`, `font-{weight}`, `italic` (via `monthYearClassName`) |
| Colors | `bg-{color}`, `text-{color}` |
| Borders | `border`, `rounded-{size}`, `shadow-{size}` |

## Customizing Theme

The default appearance of the month/year text and buttons is controlled via `WindThemeData`.

```dart
WindThemeData(
  // The header inherits colors and spacing units from the theme
  colors: {
    'gray': myCustomGrayScale,
  },
  baseSpacingUnit: 4.0,
)
```

## Related Documentation

- [WDatePicker](./w-date-picker.md)
- [WCalendarGrid](./w-calendar-grid.md)
- [WButton](./w-button.md)
- [WText](./w-text.md)
