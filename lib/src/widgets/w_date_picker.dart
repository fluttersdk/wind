import 'package:flutter/material.dart';

import '../parser/wind_parser.dart';
import '../parser/wind_style.dart';
import 'w_div.dart';
import 'w_popover.dart';
import 'w_text.dart';

/// Date picker selection mode.
enum DatePickerMode {
  /// Single date selection.
  single,

  /// Date range selection (start and end dates).
  range,
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
///   mode: DatePickerMode.range,
///   range: _dateRange,
///   onRangeChanged: (range) => setState(() => _dateRange = range),
///   className: 'w-full p-3 border rounded-lg',
///   placeholder: 'Select date range',
/// )
/// ```
class WDatePicker extends StatefulWidget {
  /// Selection mode: single date or date range.
  final DatePickerMode mode;

  /// The currently selected date (single mode).
  final DateTime? value;

  /// The currently selected date range (range mode).
  final DateRange? range;

  /// Called when a date is selected (single mode).
  final ValueChanged<DateTime>? onChanged;

  /// Called when a date range is selected (range mode).
  final ValueChanged<DateRange>? onRangeChanged;

  /// Minimum selectable date.
  final DateTime? minDate;

  /// Maximum selectable date.
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
  /// If not provided, dates are formatted as "MMM d, yyyy" (e.g., "Jan 15, 2025").
  final DateDisplayFormat? displayFormat;

  /// Creates a new [WDatePicker] instance.
  const WDatePicker({
    super.key,
    this.mode = DatePickerMode.single,
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
  });

  @override
  State<WDatePicker> createState() => _WDatePickerState();
}

class _WDatePickerState extends State<WDatePicker> {
  final PopoverController _popoverController = PopoverController();

  /// The currently focused month for calendar display.
  late DateTime _focusedMonth;

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
  }

  void _initFocusedMonth() {
    if (widget.mode == DatePickerMode.single && widget.value != null) {
      _focusedMonth = _normalizeToMonth(widget.value!);
    } else if (widget.mode == DatePickerMode.range && widget.range != null) {
      _focusedMonth = _normalizeToMonth(widget.range!.start);
    } else {
      _focusedMonth = _normalizeToMonth(DateTime.now());
    }
  }

  @override
  void didUpdateWidget(WDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update focused month if value changed externally
    if (widget.value != oldWidget.value && widget.value != null) {
      _focusedMonth = _normalizeToMonth(widget.value!);
    }
    if (widget.range != oldWidget.range && widget.range != null) {
      _focusedMonth = _normalizeToMonth(widget.range!.start);
    }
  }

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

  /// Formats the display text for the trigger.
  String _getDisplayText() {
    if (widget.mode == DatePickerMode.single) {
      return widget.value != null
          ? _formatDate(widget.value!)
          : widget.placeholder;
    } else {
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

  /// Handles date selection.
  void _onDateSelected(DateTime date) {
    if (!_isDateSelectable(date)) return;

    final normalized = _normalizeToDay(date);

    if (widget.mode == DatePickerMode.single) {
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

    return WPopover(
      controller: _popoverController,
      // WPopover handles autoFlip automatically - no manual direction needed
      alignment: PopoverAlignment.bottomLeft,
      maxHeight: 400,
      disabled: widget.disabled,
      className:
          'w-[320px] bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-xl shadow-xl p-4',
      onOpen: () {
        setState(() {
          _isOpen = true;
          // Reset range selection state when opening
          if (widget.mode == DatePickerMode.range &&
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
                  widget.mode == DatePickerMode.single ? widget.value : null,
              selectedRange:
                  widget.mode == DatePickerMode.range ? widget.range : null,
              rangeStart: _rangeStart,
              hoveredDate: _hoveredDate,
              minDate: widget.minDate,
              maxDate: widget.maxDate,
              onDateSelected: _onDateSelected,
              onDateHovered: (date) {
                if (widget.mode == DatePickerMode.range &&
                    _rangeStart != null) {
                  setState(() => _hoveredDate = date);
                }
              },
            ),
          ],
        );
      },
    );
  }

  bool get _hasValue {
    if (widget.mode == DatePickerMode.single) {
      return widget.value != null;
    }
    return widget.range != null;
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
      bgClass = 'bg-blue-500';
      textClass = 'text-white font-medium';
      roundedClass = 'rounded-full';
    } else if (isInRange) {
      bgClass = 'bg-blue-100 dark:bg-blue-900/30';
      textClass = 'text-blue-700 dark:text-blue-300';
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
