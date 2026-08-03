# WDatePicker

A utility-first date picker component built on [WPopover](./w-popover.md) with support for single date selection, date range selection, date-with-time selection, min/max constraints, and custom display formatting.

- [Basic Usage](#basic-usage)
- [Constructor](#constructor)
- [Props](#props)
- [Types](#types)
- [Date Range Selection](#date-range-selection)
- [Date + Time Selection](#date--time-selection)
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
  int minuteStep = 5,
  String timeLabel = 'Time',
  String doneLabel = 'Done',
})
```

## Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `mode` | `WDatePickerMode` | `single` | Selection mode: `single`, `range` or `dateTime` |
| `value` | `DateTime?` | `null` | Currently selected instant (`single` and `dateTime` modes; carries the time of day in `dateTime`) |
| `range` | `DateRange?` | `null` | Currently selected range (range mode) |
| `onChanged` | `ValueChanged<DateTime>?` | `null` | Callback fired on selection (`single` and `dateTime` modes; in `dateTime` it fires once the confirm control closes the popover) |
| `onRangeChanged` | `ValueChanged<DateRange>?` | `null` | Callback fired on range selection (range mode) |
| `minDate` | `DateTime?` | `null` | Earliest selectable date; day cells compare at day granularity, the composed instant is additionally clamped in `dateTime` mode |
| `maxDate` | `DateTime?` | `null` | Latest selectable date; a bare-day bound is that day at `00:00`, so `dateTime` mode needs an explicit end-of-day to admit the whole last day |
| `className` | `String?` | `null` | Wind utility classes for the trigger container |
| `placeholder` | `String` | `'Select date'` | Text shown when no value is selected |
| `disabled` | `bool` | `false` | Prevents interaction, shows forbidden cursor |
| `states` | `Set<String>` | `const {}` | Custom states for dynamic styling |
| `displayFormat` | `DateDisplayFormat?` | `null` | Custom function to format dates for display |
| `minuteStep` | `int` | `5` | Minutes each step control moves (`dateTime` mode only) |
| `timeLabel` | `String` | `'Time'` | Label above the time row (`dateTime` mode only) |
| `doneLabel` | `String` | `'Done'` | Confirm control text that closes the popover (`dateTime` mode only) |

## Types

### WDatePickerMode

Determines whether the picker selects a single date, a date range, or a single
date carrying a time of day.

```dart
enum WDatePickerMode {
  single,    // Pick a single date (time struck to midnight)
  range,     // Pick a start and end date
  dateTime,  // Pick a single date AND a time of day
}
```

`single` and `range` normalize every value to midnight. `dateTime` is the only
mode that preserves an hour and a minute, so it is the one to use when the value
is an instant rather than a calendar day. It adds a stepped time row below the
calendar and keeps the popover open until the confirm control is pressed.

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

1. **First click**: Sets the range start. The `onRangeChanged` callback fires with a `DateRange` where `end` is `null`.
2. **Hover**: As the user moves the mouse, dates between start and the hovered date are highlighted with a blue tint.
3. **Second click**: Completes the range. If the second date is before the first, they're automatically swapped. The popover closes.

The trigger display text updates throughout: `"Jan 15, 2025 - ..."` while in progress, then `"Jan 15, 2025 - Jan 20, 2025"` when complete.

## Date + Time Selection

Setting `mode: WDatePickerMode.dateTime` keeps the time of day. The tapped day is composed with a stepped time row and emitted as a single local `DateTime`, where `single` and `range` strike everything to midnight.

<x-preview path="widgets/date_picker_datetime" size="md" source="example/lib/pages/widgets/date_picker_datetime.dart"></x-preview>

```dart
DateTime? _startsAt;

WDatePicker(
  mode: WDatePickerMode.dateTime,
  value: _startsAt,
  onChanged: (value) => setState(() => _startsAt = value),
  minuteStep: 15,
  placeholder: 'Schedule the deploy',
  className: 'w-full p-3 border rounded-lg',
)
```

How the mode differs from `single`:

1. **The popover stays open on a day tap.** The time row below the calendar is the second half of the selection, so the confirm control (`doneLabel`) is what closes it.
2. **`onChanged` fires on every change**, both the day tap and each time step, always with the full composed instant. Closing the popover commits nothing new.
3. **The mode is controlled.** Feed each emitted value back through `value` or the calendar highlight, the time row, and the bounds will drift apart from what the user sees.
4. **The time row is Wind markup**, two 24-hour spinners plus the confirm control built from `WDiv` / `WText` / `WIcon`. It is not a Material `showTimePicker` dialog, so it themes with the rest of the picker.

The spinners never wrap: stepping up from 23:00 would move the instant a full day backwards while the calendar kept showing the same day, so an edge step renders disabled instead. `minuteStep` sets how far one press of the minute spinner moves (default `5`).

> [!NOTE]
> The emitted `DateTime` is local and carries no offset. Dart's `DateTime` cannot hold an arbitrary one ([dart-lang/sdk#54993](https://github.com/dart-lang/sdk/issues/54993)), so a value crossing a network boundary is the caller's `toUtc()` to make.

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
> In `single` and `range` mode, constraints are compared at day-level granularity and time components are stripped before comparison. In `dateTime` mode a day cell stays selectable whenever ANY instant in it is legal, and the composed instant is then pulled back inside the window, so the emitted value is always the same legal instant the trigger displays.

### Bounds in `dateTime` mode

Because the bound is compared as a full instant, a `maxDate` written as a bare day is that day at midnight, and the last day then admits only `00:00`: every time you pick on it collapses back to midnight and its step controls render disabled. Spell out the end of the day when you mean the whole day.

```dart
WDatePicker(
  mode: WDatePickerMode.dateTime,
  value: _startsAt,
  onChanged: (value) => setState(() => _startsAt = value),
  minDate: DateTime.now(),
  // Not DateTime(2026, 8, 31), which caps the last day at 00:00.
  maxDate: DateTime(2026, 8, 31, 23, 59),
  className: 'p-3 border rounded-lg',
)
```

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

`onRangeChanged` fires twice during a range selection: once on the first click (start only) and once on the second click (complete range):

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

### DateTime Mode

`onChanged` reuses the single-mode callback but fires on every change, the day tap and each time step alike, always carrying the full composed instant:

```dart
WDatePicker(
  mode: WDatePickerMode.dateTime,
  value: _startsAt,
  onChanged: (value) {
    // Fires again on every hour / minute step, not only on the day tap.
    setState(() => _startsAt = value);
  },
)
```

Treat it as a live value rather than a commit signal. The confirm control only closes the popover; if you need a "the user finished" moment, act on the value you already hold once the popover closes.

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
| **Selected** | `bg-primary text-white rounded-full` |
| **In range** | `bg-primary-100 dark:bg-primary-900/30 text-primary-700` |
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

The calendar's selection colors route through the theme `primary` token (`bg-primary` for the selected day, `bg-primary-100` / `text-primary-700` for the in-range fill). Override `primary` to recolor the calendar to your brand; the neutral grays remain configurable via their own palette keys. The default `primary` is aliased to the Tailwind blue swatch, so leaving it unchanged keeps the original blue look.

```dart
WindTheme(
  data: WindThemeData(
    colors: {
      'primary': MaterialColor(0xFF16A34A, {
        100: Color(0xFFDCFCE7),  // Range fill
        500: Color(0xFF16A34A),  // Selected day (shade 500 == bg-primary)
        700: Color(0xFF15803D),  // Range text
        900: Color(0xFF14532D),  // Dark mode range
      }),
    },
  ),
  child: MyApp(),
)
```

The calendar only reads shades `100` / `500` / `700` / `900`, so the partial swatch above is enough for it. Other `primary`-driven widgets read further shades (`WSelect` uses `400` / `600` / `700` for its raw icon colors); a missing shade safely falls back to the swatch's base color rather than throwing, but if you share one `primary` across widgets, prefer a complete `50`-`950` swatch (e.g. a generated `MaterialColor`) so every shade renders as intended.

## Related Documentation

- [WFormDatePicker](./w-form-date-picker.md) - Form-integrated date picker with validation
- [WSelect](./w-select.md) - Dropdown selection component
- [WPopover](./w-popover.md) - The underlying overlay engine
- [WInput](./w-input.md) - Standard text input widget
