import 'package:flutter/material.dart';

import '../parser/wind_parser.dart';
import '../parser/wind_style.dart';
import 'w_div.dart';
import 'w_icon.dart';
import 'w_popover.dart';
import 'w_text.dart';

/// Date picker selection mode.
enum WDatePickerMode {
  /// Single date selection.
  single,

  /// Date range selection (start and end dates).
  range,

  /// Single date plus a time of day, emitted as a full [DateTime].
  ///
  /// The only mode that preserves a time component: [single] and [range]
  /// strike every emitted value back to midnight.
  dateTime,
}

/// Represents a date range with start and end dates.
class DateRange {
  /// The start date of the range.
  final DateTime start;

  /// The end date of the range.
  final DateTime? end;

  /// Creates a new [DateRange].
  const DateRange({required this.start, this.end});

  /// Whether both start and end dates are selected.
  bool get isComplete => end != null;

  /// Creates a copy with the given fields replaced.
  DateRange copyWith({DateTime? start, DateTime? end}) {
    return DateRange(
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DateRange && other.start == start && other.end == end;
  }

  @override
  int get hashCode => start.hashCode ^ end.hashCode;

  @override
  String toString() => 'DateRange(start: $start, end: $end)';
}

/// Signature for custom display format function.
typedef DateDisplayFormat = String Function(DateTime date);

/// **WDatePicker - Utility-First Date Picker Component**
///
/// A fully styled date picker using Wind utility classes with support for
/// single date and date range selection.
///
/// ### Features:
/// - **Single Date Selection:** Pick a single date
/// - **Date Range Selection:** Pick start and end dates with hover preview
/// - **Date + Time Selection:** Pick a date and a time of day in one value
/// - **Min/Max Constraints:** Limit selectable date range
/// - **Styling:** Full Wind className support for trigger and calendar
/// - **Popover Integration:** Uses WPopover for overlay positioning
///
/// ### Single Date Example:
///
/// ```dart
/// WDatePicker(
///   value: _selectedDate,
///   onChanged: (date) => setState(() => _selectedDate = date),
///   className: 'w-full p-3 border rounded-lg',
///   placeholder: 'Select a date',
/// )
/// ```
///
/// ### Date Range Example:
///
/// ```dart
/// WDatePicker(
///   mode: WDatePickerMode.range,
///   range: _dateRange,
///   onRangeChanged: (range) => setState(() => _dateRange = range),
///   className: 'w-full p-3 border rounded-lg',
///   placeholder: 'Select date range',
/// )
/// ```
///
/// ### Date + Time Example:
///
/// ```dart
/// WDatePicker(
///   mode: WDatePickerMode.dateTime,
///   value: _startsAt,
///   onChanged: (value) => setState(() => _startsAt = value),
///   minuteStep: 15,
///   className: 'w-full p-3 border rounded-lg',
///   placeholder: 'Select start',
/// )
/// ```
///
/// `dateTime` mode emits a plain local [DateTime] carrying the picked hour and
/// minute; every other mode emits midnight. The mode is controlled: feed each
/// emitted value back through [value] so the calendar highlight, the time row,
/// and the min/max window all follow it. The widget performs NO timezone
/// conversion, so a value crossing a network boundary is the caller's
/// `toUtc()` to make (Dart's [DateTime] cannot carry an arbitrary offset).
class WDatePicker extends StatefulWidget {
  /// Selection mode: single date, date range, or date plus time of day.
  final WDatePickerMode mode;

  /// The currently selected instant ([WDatePickerMode.single] and
  /// [WDatePickerMode.dateTime]).
  ///
  /// `single` holds a midnight date; `dateTime` carries the picked hour and
  /// minute too, and owns the time row, so feed every emitted value back here.
  final DateTime? value;

  /// The currently selected date range (range mode).
  final DateRange? range;

  /// Called when a date is selected ([WDatePickerMode.single] and
  /// [WDatePickerMode.dateTime]).
  ///
  /// `single` fires once, on the day tap that closes the popover. `dateTime`
  /// fires on every day tap AND every time step, each with the full composed
  /// instant; the confirm control only closes the popover.
  final ValueChanged<DateTime>? onChanged;

  /// Called when a date range is selected (range mode).
  final ValueChanged<DateRange>? onRangeChanged;

  /// Earliest selectable date.
  ///
  /// Day cells are compared at day granularity in every mode. In
  /// [WDatePickerMode.dateTime] the composed instant is additionally clamped
  /// to this bound, so a bound carrying a time of day is honoured to the
  /// minute.
  final DateTime? minDate;

  /// Latest selectable date.
  ///
  /// The [minDate] granularity note applies, with one consequence worth
  /// spelling out: a bound written as a bare day (`DateTime(2026, 8, 31)`) IS
  /// the instant Aug 31 00:00, so in [WDatePickerMode.dateTime] the last day
  /// admits only midnight and its step controls render disabled. Pass an
  /// explicit end-of-day (`DateTime(2026, 8, 31, 23, 59)`) to open the whole
  /// day.
  final DateTime? maxDate;

  /// Wind utility classes for the trigger container.
  final String? className;

  /// Placeholder text when no date is selected.
  final String placeholder;

  /// Whether the date picker is disabled.
  final bool disabled;

  /// Custom states for dynamic styling.
  final Set<String> states;

  /// Custom display format function.
  ///
  /// If not provided, dates are formatted as "MMM d, yyyy" (e.g., "Jan 15, 2025"),
  /// and [WDatePickerMode.dateTime] appends a 24-hour time ("Jan 15, 2025 14:30").
  final DateDisplayFormat? displayFormat;

  /// Minutes added or removed per minute step ([WDatePickerMode.dateTime]).
  ///
  /// Asserted between 1 and 59. A release build, where the assert is stripped,
  /// clamps an out-of-range value into that box rather than leaving the
  /// spinners inert.
  final int minuteStep;

  /// Label of the time row ([WDatePickerMode.dateTime]).
  final String timeLabel;

  /// Label of the control that confirms the picked instant and closes the
  /// popover ([WDatePickerMode.dateTime]).
  final String doneLabel;

  /// Creates a new [WDatePicker] instance.
  const WDatePicker({
    super.key,
    this.mode = WDatePickerMode.single,
    this.value,
    this.range,
    this.onChanged,
    this.onRangeChanged,
    this.minDate,
    this.maxDate,
    this.className,
    this.placeholder = 'Select date',
    this.disabled = false,
    this.states = const {},
    this.displayFormat,
    this.minuteStep = 5,
    this.timeLabel = 'Time',
    this.doneLabel = 'Done',
  }) : assert(minuteStep > 0 && minuteStep < 60,
            'WDatePicker: minuteStep must be between 1 and 59.');

  @override
  State<WDatePicker> createState() => _WDatePickerState();
}

class _WDatePickerState extends State<WDatePicker> {
  /// Popover height budget for the calendar alone.
  static const double _calendarMaxHeight = 400;

  /// Popover height budget with the time row below the calendar.
  static const double _dateTimeMaxHeight = 500;

  final PopoverController _popoverController = PopoverController();

  /// The currently focused month for calendar display.
  late DateTime _focusedMonth;

  /// The pending hour (0-23) of the time row.
  late int _hour;

  /// The pending minute (0-59) of the time row.
  late int _minute;

  /// The currently hovered date (for range preview).
  DateTime? _hoveredDate;

  /// The start of a range selection in progress.
  DateTime? _rangeStart;

  /// Whether the popover is currently open.
  bool _isOpen = false;

  /// Whether the trigger is being hovered.
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _initFocusedMonth();
    _initTime();
  }

  void _initFocusedMonth() {
    if (widget.mode != WDatePickerMode.range && widget.value != null) {
      _focusedMonth = _normalizeToMonth(widget.value!);
    } else if (widget.mode == WDatePickerMode.range && widget.range != null) {
      _focusedMonth = _normalizeToMonth(widget.range!.start);
    } else {
      _focusedMonth = _normalizeToMonth(DateTime.now());
    }
  }

  /// Seeds the time row from the current value, falling back to the wall clock
  /// so an empty `dateTime` picker opens on a plausible time instead of
  /// midnight.
  void _initTime() {
    final DateTime seed = widget.value ?? DateTime.now();
    _hour = seed.hour;
    _minute = seed.minute;
  }

  @override
  void didUpdateWidget(WDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update focused month if value changed externally
    if (widget.value != oldWidget.value && widget.value != null) {
      _focusedMonth = _normalizeToMonth(widget.value!);
      // `dateTime` mode is controlled, so an externally supplied instant owns
      // the time row too.
      if (widget.mode == WDatePickerMode.dateTime) {
        _hour = widget.value!.hour;
        _minute = widget.value!.minute;
      }
    }
    // A form reset drops the value back to null. Leaving the last picked time
    // in the row would advertise a time the picker no longer holds, so it goes
    // back to the wall-clock seed a never-touched picker starts from.
    if (widget.value == null && oldWidget.value != null) {
      _initTime();
    }
    if (widget.range != oldWidget.range && widget.range != null) {
      _focusedMonth = _normalizeToMonth(widget.range!.start);
    }
  }

  /// The minute step actually applied by the spinners.
  ///
  /// [WDatePicker.minuteStep] is asserted at construction, but asserts are
  /// stripped from a release build, and a step computed at runtime (a remote
  /// config value, a user preference) can still arrive out of range there.
  /// A step of 0 would make every minute increment a no-op and one of 60 or
  /// more would leave the 0-59 box on the first press, so both would leave the
  /// spinners silently inert. Clamping at the point of use keeps them moving.
  int get _minuteStep => widget.minuteStep.clamp(1, 59);

  /// Normalizes a date to midnight (removes time component).
  DateTime _normalizeToDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Normalizes a date to the first day of its month.
  DateTime _normalizeToMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Formats a date for display.
  String _formatDate(DateTime date) {
    if (widget.displayFormat != null) {
      return widget.displayFormat!(date);
    }
    return _defaultFormatDate(date);
  }

  /// Default date format: "Jan 15, 2025"
  String _defaultFormatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  /// Default time format: "14:30" (24-hour, zero padded).
  String _defaultFormatTime(int hour, int minute) {
    return '${_twoDigits(hour)}:${_twoDigits(minute)}';
  }

  String _twoDigits(int value) => value.toString().padLeft(2, '0');

  /// Formats the display text for the trigger.
  String _getDisplayText() {
    if (widget.mode == WDatePickerMode.range) {
      if (widget.range == null) {
        return widget.placeholder;
      }
      final start = _formatDate(widget.range!.start);
      if (widget.range!.end == null) {
        return '$start - ...';
      }
      final end = _formatDate(widget.range!.end!);
      return '$start - $end';
    }

    if (widget.value == null) {
      return widget.placeholder;
    }
    // A custom displayFormat receives the full DateTime, so it already owns the
    // time; only the default format needs the appended clock.
    if (widget.mode == WDatePickerMode.dateTime &&
        widget.displayFormat == null) {
      final time = _defaultFormatTime(widget.value!.hour, widget.value!.minute);
      return '${_defaultFormatDate(widget.value!)} $time';
    }
    return _formatDate(widget.value!);
  }

  /// Whether a date is selectable (within min/max constraints).
  bool _isDateSelectable(DateTime date) {
    final normalized = _normalizeToDay(date);
    if (widget.minDate != null &&
        normalized.isBefore(_normalizeToDay(widget.minDate!))) {
      return false;
    }
    if (widget.maxDate != null &&
        normalized.isAfter(_normalizeToDay(widget.maxDate!))) {
      return false;
    }
    return true;
  }

  /// Composes a picked day with the pending time.
  ///
  /// This is the one selection path that never runs through [_normalizeToDay],
  /// which is exactly why `dateTime` mode can carry an hour and a minute.
  DateTime _composeDateTime(DateTime day) {
    return _clampToWindow(
      DateTime(day.year, day.month, day.day, _hour, _minute),
    );
  }

  /// Pulls an instant back inside the min/max window.
  ///
  /// A day cell is enabled whenever ANY instant in it is legal, so composing it
  /// with the pending time can land outside the window. Clamping keeps the tap
  /// honest (the emitted value is the same legal instant the trigger then
  /// displays) instead of dropping it silently; the bound always sits on the
  /// tapped day, because a day fully outside the window is not selectable.
  DateTime _clampToWindow(DateTime instant) {
    if (widget.minDate != null && instant.isBefore(widget.minDate!)) {
      return widget.minDate!;
    }
    if (widget.maxDate != null && instant.isAfter(widget.maxDate!)) {
      return widget.maxDate!;
    }
    return instant;
  }

  /// The pending time moved by [hours] / [minutes], or `null` when the step
  /// would leave the 0-23 / 0-59 box or the min/max window.
  ///
  /// It deliberately does not wrap: rolling 23:00 up to 00:00 would move the
  /// emitted instant a full day BACKWARDS while the calendar kept showing the
  /// same day. A step at the edge reads as disabled instead.
  ({int hour, int minute})? _steppedTime({int hours = 0, int minutes = 0}) {
    final int hour = _hour + hours;
    final int minute = _minute + minutes;
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;

    final DateTime? current = widget.value;
    if (current != null) {
      final candidate = DateTime(
        current.year,
        current.month,
        current.day,
        hour,
        minute,
      );
      if (_clampToWindow(candidate) != candidate) return null;
    }

    return (hour: hour, minute: minute);
  }

  /// Applies a time step and re-emits the composed instant.
  ///
  /// With no date picked yet the step only moves the pending time: there is no
  /// day to compose against, so emitting a value would mean inventing one.
  void _stepTime({int hours = 0, int minutes = 0}) {
    final stepped = _steppedTime(hours: hours, minutes: minutes);
    if (stepped == null) return;

    setState(() {
      _hour = stepped.hour;
      _minute = stepped.minute;
    });

    final DateTime? current = widget.value;
    if (current != null) {
      widget.onChanged?.call(_composeDateTime(current));
    }
  }

  /// Handles date selection.
  void _onDateSelected(DateTime date) {
    if (!_isDateSelectable(date)) return;

    if (widget.mode == WDatePickerMode.dateTime) {
      // Keep the popover open: the time row below the calendar is the second
      // half of the selection.
      widget.onChanged?.call(_composeDateTime(date));
      return;
    }

    final normalized = _normalizeToDay(date);

    if (widget.mode == WDatePickerMode.single) {
      widget.onChanged?.call(normalized);
      _closePopover();
    } else {
      // Range mode
      if (_rangeStart == null) {
        // First click: set range start
        setState(() {
          _rangeStart = normalized;
        });
        widget.onRangeChanged?.call(DateRange(start: normalized));
      } else {
        // Second click: complete range
        DateTime start = _rangeStart!;
        DateTime end = normalized;

        // Swap if end is before start
        if (end.isBefore(start)) {
          final temp = start;
          start = end;
          end = temp;
        }

        widget.onRangeChanged?.call(DateRange(start: start, end: end));
        setState(() {
          _rangeStart = null;
        });
        _closePopover();
      }
    }
  }

  /// Navigate to previous month.
  void _previousMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1, 1);
    });
  }

  /// Navigate to next month.
  void _nextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 1);
    });
  }

  void _closePopover() {
    _popoverController.hide();
    setState(() {
      _isOpen = false;
      _hoveredDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Set<String> activeStates = {
      ...widget.states,
      if (widget.disabled) 'disabled',
      if (_isHovering) 'hover',
      if (_isOpen) 'focus',
      if (_isOpen) 'open',
      if (_hasValue) 'selected',
    };

    final String triggerClassName = widget.className ??
        'bg-white border border-gray-300 rounded-lg p-3 dark:bg-gray-800 dark:border-gray-600';

    final WindStyle styles = WindParser.parse(
      triggerClassName,
      context,
      states: activeStates,
    );

    // Accessibility: surface the closed trigger as a `textField` SemanticsNode
    // labelled with the placeholder (so Playwright `getByLabel(/select date/i)`
    // resolves) and carrying the ISO-formatted selected date as its
    // Semantics value. Wrapping at this level lets the existing WPopover +
    // trigger sub-tree render its visual content while still surfacing a
    // single, predictable Semantics node to the accessibility tree.
    return Semantics(
      container: true,
      textField: true,
      enabled: !widget.disabled,
      label: widget.placeholder,
      value: widget.value?.toIso8601String() ??
          (widget.mode == WDatePickerMode.range && widget.range != null
              ? widget.range!.start.toIso8601String()
              : null),
      child: MergeSemantics(
        child: _buildPopover(activeStates, styles, triggerClassName),
      ),
    );
  }

  /// Builds the WPopover trigger + content. Extracted so the build method
  /// can wrap the entire interactive surface with a single Semantics node
  /// without changing the existing popover/trigger composition.
  Widget _buildPopover(
    Set<String> activeStates,
    WindStyle styles,
    String triggerClassName,
  ) {
    return WPopover(
      controller: _popoverController,
      // WPopover handles autoFlip automatically - /no manual direction needed
      alignment: PopoverAlignment.bottomLeft,
      maxHeight: widget.mode == WDatePickerMode.dateTime
          ? _dateTimeMaxHeight
          : _calendarMaxHeight,
      disabled: widget.disabled,
      className:
          'w-[320px] bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-xl shadow-xl p-4',
      onOpen: () {
        setState(() {
          _isOpen = true;
          // Reset range selection state when opening
          if (widget.mode == WDatePickerMode.range &&
              widget.range?.isComplete == true) {
            _rangeStart = null;
          }
        });
      },
      onClose: () {
        setState(() {
          _isOpen = false;
          _hoveredDate = null;
        });
      },
      triggerBuilder: (context, isOpen, isHovering) {
        // Deferred state update to avoid conflicts
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _isHovering != isHovering) {
            setState(() => _isHovering = isHovering);
          }
        });

        return MouseRegion(
          cursor: widget.disabled
              ? SystemMouseCursors.forbidden
              : SystemMouseCursors.click,
          child: WDiv(
            className: triggerClassName,
            states: activeStates,
            child: Row(
              children: [
                Expanded(
                  child: WText(
                    _getDisplayText(),
                    className: _hasValue
                        ? 'text-gray-800 dark:text-gray-100'
                        : 'text-gray-400 dark:text-gray-500',
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  size: 18,
                  color: styles.color ?? Colors.grey.shade600,
                ),
              ],
            ),
          ),
        );
      },
      contentBuilder: (context, close) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _CalendarHeader(
              focusedMonth: _focusedMonth,
              onPreviousMonth: _previousMonth,
              onNextMonth: _nextMonth,
            ),
            const SizedBox(height: 12),
            _CalendarGrid(
              focusedMonth: _focusedMonth,
              selectedDate:
                  widget.mode == WDatePickerMode.range ? null : widget.value,
              selectedRange:
                  widget.mode == WDatePickerMode.range ? widget.range : null,
              rangeStart: _rangeStart,
              hoveredDate: _hoveredDate,
              minDate: widget.minDate,
              maxDate: widget.maxDate,
              onDateSelected: _onDateSelected,
              onDateHovered: (date) {
                if (widget.mode == WDatePickerMode.range &&
                    _rangeStart != null) {
                  setState(() => _hoveredDate = date);
                }
              },
            ),
            if (widget.mode == WDatePickerMode.dateTime) _buildTimeRow(),
          ],
        );
      },
    );
  }

  /// Builds the Wind-styled time row shown below the calendar in `dateTime`
  /// mode: two 24-hour spinners plus the confirm control. Every visual is a
  /// Wind primitive driven by className tokens, so the row themes with the rest
  /// of the picker; wind ships no Material time dialog and deliberately does
  /// not call `showTimePicker`.
  Widget _buildTimeRow() {
    return Semantics(
      container: true,
      // The spinners and the confirm control are their own nodes; without this
      // their labels would be absorbed into the row's label.
      explicitChildNodes: true,
      label: widget.timeLabel,
      value: _defaultFormatTime(_hour, _minute),
      child: WDiv(
        className: '''
          flex flex-row items-center justify-between
          mt-3 pt-3
          border-t border-gray-200 dark:border-gray-700
        ''',
        children: [
          WText(
            widget.timeLabel,
            className: 'text-sm font-medium text-gray-700 dark:text-gray-300',
          ),
          // `shrink-0` keeps the spinners at their intrinsic width: a `flex-row`
          // hands every plain child an equal Flexible share, which is half the
          // 320px popover and too narrow for two spinners plus the confirm
          // control.
          WDiv(
            className: 'flex flex-row items-center gap-2 shrink-0',
            children: [
              _buildTimeSpinner(
                unit: 'hour',
                value: _hour,
                onIncrement: () => _stepTime(hours: 1),
                onDecrement: () => _stepTime(hours: -1),
                canIncrement: _steppedTime(hours: 1) != null,
                canDecrement: _steppedTime(hours: -1) != null,
              ),
              WText(
                ':',
                className:
                    'text-sm font-semibold text-gray-800 dark:text-gray-100',
              ),
              _buildTimeSpinner(
                unit: 'minute',
                value: _minute,
                onIncrement: () => _stepTime(minutes: _minuteStep),
                onDecrement: () => _stepTime(minutes: -_minuteStep),
                canIncrement: _steppedTime(minutes: _minuteStep) != null,
                canDecrement: _steppedTime(minutes: -_minuteStep) != null,
              ),
              _buildDoneControl(),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds one up / readout / down spinner column for a time unit.
  Widget _buildTimeSpinner({
    required String unit,
    required int value,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
    required bool canIncrement,
    required bool canDecrement,
  }) {
    return WDiv(
      className: 'flex flex-col items-center',
      children: [
        _buildStepControl(
          icon: Icons.keyboard_arrow_up,
          semanticLabel: 'Increase $unit',
          enabled: canIncrement,
          onTap: onIncrement,
        ),
        WDiv(
          className: 'w-8 flex flex-row justify-center',
          child: WText(
            _twoDigits(value),
            className:
                'text-sm font-semibold text-gray-800 dark:text-gray-100 tabular-nums',
          ),
        ),
        _buildStepControl(
          icon: Icons.keyboard_arrow_down,
          semanticLabel: 'Decrease $unit',
          enabled: canDecrement,
          onTap: onDecrement,
        ),
      ],
    );
  }

  /// Builds a single step control. A step that would leave the 0-23 / 0-59 box
  /// or the min/max window renders greyed out and carries no tap callback, the
  /// same treatment an out-of-window day cell gets.
  Widget _buildStepControl({
    required IconData icon,
    required String semanticLabel,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return Semantics(
      button: true,
      enabled: enabled,
      label: semanticLabel,
      // The node declares the button role, so it also has to carry the action:
      // the GestureDetector below is not this node's semantics owner, which
      // would leave a screen reader (or an automation driver) with a control it
      // can name but not activate.
      onTap: enabled ? onTap : null,
      child: MouseRegion(
        cursor:
            enabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
        child: GestureDetector(
          onTap: enabled ? onTap : null,
          child: WDiv(
            className: enabled
                ? 'p-1 rounded hover:bg-gray-100 dark:hover:bg-gray-700'
                : 'p-1 rounded',
            child: WIcon(
              icon,
              className: enabled
                  ? 'text-lg text-gray-700 dark:text-gray-200'
                  : 'text-lg text-gray-300 dark:text-gray-600',
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the control that confirms the composed instant and closes the
  /// popover. `dateTime` mode keeps the popover open on a day tap, so it needs
  /// an explicit dismissal; every change is already emitted through
  /// [WDatePicker.onChanged], so closing commits nothing new.
  Widget _buildDoneControl() {
    return Semantics(
      button: true,
      label: widget.doneLabel,
      onTap: _closePopover,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: _closePopover,
          child: WDiv(
            className: 'px-3 py-1 rounded-lg bg-primary',
            child: WText(
              widget.doneLabel,
              className: 'text-xs font-medium text-white',
            ),
          ),
        ),
      ),
    );
  }

  bool get _hasValue {
    if (widget.mode == WDatePickerMode.range) {
      return widget.range != null;
    }
    return widget.value != null;
  }
}

/// Calendar header with month/year display and navigation.
class _CalendarHeader extends StatelessWidget {
  final DateTime focusedMonth;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  const _CalendarHeader({
    required this.focusedMonth,
    required this.onPreviousMonth,
    required this.onNextMonth,
  });

  String get _monthYearText {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${months[focusedMonth.month - 1]} ${focusedMonth.year}';
  }

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'flex items-center justify-between',
      children: [
        GestureDetector(
          onTap: onPreviousMonth,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: WDiv(
              className: 'p-1 rounded hover:bg-gray-100 dark:hover:bg-gray-700',
              child: const Icon(Icons.chevron_left, size: 20),
            ),
          ),
        ),
        WText(
          _monthYearText,
          className:
              'text-sm font-semibold text-gray-800 dark:text-gray-100 whitespace-nowrap',
        ),
        GestureDetector(
          onTap: onNextMonth,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: WDiv(
              className: 'p-1 rounded hover:bg-gray-100 dark:hover:bg-gray-700',
              child: const Icon(Icons.chevron_right, size: 20),
            ),
          ),
        ),
      ],
    );
  }
}

/// Calendar grid with 42 cells (6 weeks x 7 days).
class _CalendarGrid extends StatelessWidget {
  final DateTime focusedMonth;
  final DateTime? selectedDate;
  final DateRange? selectedRange;
  final DateTime? rangeStart;
  final DateTime? hoveredDate;
  final DateTime? minDate;
  final DateTime? maxDate;
  final ValueChanged<DateTime> onDateSelected;
  final ValueChanged<DateTime?> onDateHovered;

  const _CalendarGrid({
    required this.focusedMonth,
    this.selectedDate,
    this.selectedRange,
    this.rangeStart,
    this.hoveredDate,
    this.minDate,
    this.maxDate,
    required this.onDateSelected,
    required this.onDateHovered,
  });

  /// Normalizes a date to midnight.
  DateTime _normalizeToDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Gets the list of 42 dates to display (6 weeks starting Monday).
  List<DateTime> _getCalendarDates() {
    final firstDayOfMonth = DateTime(focusedMonth.year, focusedMonth.month, 1);

    // Get weekday (1 = Monday, 7 = Sunday)
    // Adjust to make Monday = 0
    int startWeekday = firstDayOfMonth.weekday - 1; // 0 = Monday

    // First date to show (may be from previous month)
    final firstDate = firstDayOfMonth.subtract(Duration(days: startWeekday));

    // Generate 42 dates
    return List.generate(42, (i) => firstDate.add(Duration(days: i)));
  }

  /// Whether a date is selectable.
  bool _isDateSelectable(DateTime date) {
    final normalized = _normalizeToDay(date);
    if (minDate != null && normalized.isBefore(_normalizeToDay(minDate!))) {
      return false;
    }
    if (maxDate != null && normalized.isAfter(_normalizeToDay(maxDate!))) {
      return false;
    }
    return true;
  }

  /// Whether a date is the selected date (single mode).
  bool _isSelected(DateTime date) {
    if (selectedDate == null) return false;
    return _normalizeToDay(date) == _normalizeToDay(selectedDate!);
  }

  /// Whether a date is part of the selected range.
  bool _isInRange(DateTime date) {
    final normalized = _normalizeToDay(date);

    // Check completed range
    if (selectedRange?.isComplete == true) {
      final start = _normalizeToDay(selectedRange!.start);
      final end = _normalizeToDay(selectedRange!.end!);
      return !normalized.isBefore(start) && !normalized.isAfter(end);
    }

    // Check in-progress range with hover preview
    if (rangeStart != null && hoveredDate != null) {
      DateTime start = _normalizeToDay(rangeStart!);
      DateTime end = _normalizeToDay(hoveredDate!);
      if (end.isBefore(start)) {
        final temp = start;
        start = end;
        end = temp;
      }
      return !normalized.isBefore(start) && !normalized.isAfter(end);
    }

    return false;
  }

  /// Whether a date is the start of a range.
  bool _isRangeStart(DateTime date) {
    final normalized = _normalizeToDay(date);
    if (rangeStart != null) {
      return normalized == _normalizeToDay(rangeStart!);
    }
    if (selectedRange != null) {
      return normalized == _normalizeToDay(selectedRange!.start);
    }
    return false;
  }

  /// Whether a date is the end of a range.
  bool _isRangeEnd(DateTime date) {
    final normalized = _normalizeToDay(date);
    if (selectedRange?.end != null) {
      return normalized == _normalizeToDay(selectedRange!.end!);
    }
    if (rangeStart != null && hoveredDate != null) {
      return normalized == _normalizeToDay(hoveredDate!);
    }
    return false;
  }

  /// Whether a date is in the current month.
  bool _isCurrentMonth(DateTime date) {
    return date.month == focusedMonth.month && date.year == focusedMonth.year;
  }

  /// Whether a date is today.
  bool _isToday(DateTime date) {
    final today = DateTime.now();
    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }

  @override
  Widget build(BuildContext context) {
    final dates = _getCalendarDates();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Weekday headers (Mon-Sun)
        _buildWeekdayHeaders(),
        const SizedBox(height: 4),
        // 6 rows of 7 days
        ...List.generate(6, (weekIndex) {
          final weekDates = dates.skip(weekIndex * 7).take(7).toList();
          return _buildWeekRow(weekDates);
        }),
      ],
    );
  }

  Widget _buildWeekdayHeaders() {
    const weekdays = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    return Row(
      children: weekdays.map((day) {
        return Expanded(
          child: Center(
            child: WText(
              day,
              className: 'text-xs font-medium text-gray-500 dark:text-gray-400',
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildWeekRow(List<DateTime> dates) {
    return Row(
      children: dates.map((date) => _buildDayCell(date)).toList(),
    );
  }

  Widget _buildDayCell(DateTime date) {
    final bool isCurrentMonth = _isCurrentMonth(date);
    final bool isSelectable = _isDateSelectable(date);
    final bool isSelected = _isSelected(date);
    final bool isToday = _isToday(date);
    final bool isInRange = _isInRange(date);
    final bool isRangeStart = _isRangeStart(date);
    final bool isRangeEnd = _isRangeEnd(date);

    // Build className based on state
    String bgClass = '';
    String textClass = '';
    String roundedClass = '';

    if (!isCurrentMonth) {
      textClass = 'text-gray-300 dark:text-gray-600';
    } else if (!isSelectable) {
      textClass = 'text-gray-300 dark:text-gray-600';
    } else if (isSelected || isRangeStart || isRangeEnd) {
      bgClass = 'bg-primary';
      textClass = 'text-white font-medium';
      roundedClass = 'rounded-full';
    } else if (isInRange) {
      bgClass = 'bg-primary-100 dark:bg-primary-900/30';
      textClass = 'text-primary-700 dark:text-primary-300';
    } else if (isToday) {
      bgClass = 'bg-gray-100 dark:bg-gray-700';
      textClass = 'text-gray-900 dark:text-gray-100 font-medium';
      roundedClass = 'rounded-full';
    } else {
      textClass = 'text-gray-700 dark:text-gray-200';
    }

    // Hover effect for selectable dates
    final hoverClass =
        isSelectable && !isSelected && !isRangeStart && !isRangeEnd
            ? 'hover:bg-gray-100 dark:hover:bg-gray-700'
            : '';

    final cellClassName =
        'w-full aspect-square flex items-center justify-center $bgClass $roundedClass $hoverClass';

    return Expanded(
      child: MouseRegion(
        cursor:
            isSelectable ? SystemMouseCursors.click : SystemMouseCursors.basic,
        onEnter: (_) {
          if (isSelectable) {
            onDateHovered(date);
          }
        },
        onExit: (_) => onDateHovered(null),
        child: GestureDetector(
          onTap: isSelectable ? () => onDateSelected(date) : null,
          child: Padding(
            padding: const EdgeInsets.all(1),
            child: WDiv(
              className: cellClassName,
              child: WText(
                '${date.day}',
                className: 'text-sm $textClass',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
