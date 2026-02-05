import 'package:flutter/material.dart';

import '../parser/wind_parser.dart';
import 'w_div.dart';
import 'w_text.dart';

/// A calendar grid widget for date selection.
///
/// Displays a month view with weekday headers and selectable day cells.
/// Supports single date selection, date range highlighting, and date constraints.
///
/// Example:
/// ```dart
/// WCalendarGrid(
///   month: DateTime(2026, 2, 1),
///   selectedDate: DateTime(2026, 2, 15),
///   onDateSelected: (date) => print('Selected: $date'),
/// )
/// ```
class WCalendarGrid extends StatelessWidget {
  /// Creates a calendar grid for the specified month.
  const WCalendarGrid({
    super.key,
    required this.month,
    this.selectedDate,
    this.selectedRange,
    this.minDate,
    this.maxDate,
    this.onDateSelected,
    this.className,
    this.dayClassName,
    this.selectedDayClassName,
    this.disabledDayClassName,
    this.rangeDayClassName,
    this.todayClassName,
    this.weekdayHeaderClassName,
    this.firstDayOfWeek = DateTime.sunday,
  });

  /// The month to display (only year and month are used).
  final DateTime month;

  /// Currently selected single date.
  final DateTime? selectedDate;

  /// Currently selected date range.
  final DateTimeRange? selectedRange;

  /// Minimum selectable date.
  final DateTime? minDate;

  /// Maximum selectable date.
  final DateTime? maxDate;

  /// Callback when a date is selected.
  final ValueChanged<DateTime>? onDateSelected;

  /// Wind utility classes for the grid container.
  final String? className;

  /// Wind utility classes for day cells.
  final String? dayClassName;

  /// Wind utility classes for selected day cells.
  final String? selectedDayClassName;

  /// Wind utility classes for disabled day cells.
  final String? disabledDayClassName;

  /// Wind utility classes for days in range.
  final String? rangeDayClassName;

  /// Wind utility classes for today's date.
  final String? todayClassName;

  /// Wind utility classes for weekday headers.
  final String? weekdayHeaderClassName;

  /// First day of the week (default: Sunday).
  final int firstDayOfWeek;

  /// Weekday abbreviations starting from Sunday.
  static const List<String> _weekdays = [
    'Su',
    'Mo',
    'Tu',
    'We',
    'Th',
    'Fr',
    'Sa'
  ];

  @override
  Widget build(BuildContext context) {
    final effectiveClassName = className ?? '';
    final styles = WindParser.parse(effectiveClassName, context);

    return Container(
      decoration: styles.decoration,
      padding: styles.padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildWeekdayHeaders(context),
          const SizedBox(height: 8),
          _buildDaysGrid(context),
        ],
      ),
    );
  }

  Widget _buildWeekdayHeaders(BuildContext context) {
    final headerClassName = weekdayHeaderClassName ??
        'text-xs font-medium text-gray-500 dark:text-gray-400';

    // Reorder weekdays based on firstDayOfWeek
    final orderedWeekdays = <String>[];
    for (var i = 0; i < 7; i++) {
      final index = (firstDayOfWeek - 1 + i) % 7;
      orderedWeekdays.add(_weekdays[index]);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: orderedWeekdays.map((day) {
        return Expanded(
          child: Center(
            child: WText(
              day,
              className: headerClassName,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDaysGrid(BuildContext context) {
    final days = _generateDays();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var week = 0; week < days.length; week += 7)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (var i = 0; i < 7 && week + i < days.length; i++)
                  Expanded(child: _buildDayCell(context, days[week + i])),
              ],
            ),
          ),
      ],
    );
  }

  List<_DayData> _generateDays() {
    final year = month.year;
    final monthNum = month.month;

    // First day of the month
    final firstOfMonth = DateTime(year, monthNum, 1);
    // Last day of the month
    final lastOfMonth = DateTime(year, monthNum + 1, 0);

    // Calculate offset for first day based on firstDayOfWeek
    var startOffset = firstOfMonth.weekday - firstDayOfWeek;
    if (startOffset < 0) startOffset += 7;

    final days = <_DayData>[];

    // Add days from previous month
    if (startOffset > 0) {
      final prevMonth = DateTime(year, monthNum, 0);
      for (var i = startOffset - 1; i >= 0; i--) {
        days.add(_DayData(
          date: DateTime(prevMonth.year, prevMonth.month, prevMonth.day - i),
          isCurrentMonth: false,
        ));
      }
    }

    // Add days of current month
    for (var day = 1; day <= lastOfMonth.day; day++) {
      days.add(_DayData(
        date: DateTime(year, monthNum, day),
        isCurrentMonth: true,
      ));
    }

    // Add days from next month to complete the grid (6 weeks = 42 days)
    final remaining = 42 - days.length;
    for (var i = 1; i <= remaining; i++) {
      days.add(_DayData(
        date: DateTime(year, monthNum + 1, i),
        isCurrentMonth: false,
      ));
    }

    return days;
  }

  Widget _buildDayCell(BuildContext context, _DayData dayData) {
    final date = dayData.date;
    final isCurrentMonth = dayData.isCurrentMonth;
    final now = DateTime.now();
    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;

    // Check if date is disabled
    final isDisabled = _isDateDisabled(date);

    // Check if date is selected
    final isSelected = _isDateSelected(date);

    // Check if date is in range
    final rangePosition = _getRangePosition(date);

    // Determine className based on state
    String cellClassName;
    if (!isCurrentMonth) {
      cellClassName = disabledDayClassName ??
          'text-gray-300 dark:text-gray-600 cursor-default';
    } else if (isDisabled) {
      cellClassName = disabledDayClassName ??
          'text-gray-300 dark:text-gray-600 cursor-not-allowed';
    } else if (isSelected) {
      cellClassName = selectedDayClassName ??
          'bg-primary text-white rounded-full font-medium';
    } else if (rangePosition != _RangePosition.none) {
      cellClassName = rangeDayClassName ??
          'bg-primary/10 dark:bg-primary/20 text-gray-900 dark:text-gray-100';
    } else if (isToday) {
      cellClassName = todayClassName ??
          'border border-primary text-primary rounded-full font-medium';
    } else {
      cellClassName = dayClassName ??
          'text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-full';
    }

    // Add range edge styling
    if (rangePosition == _RangePosition.start) {
      cellClassName += ' rounded-l-full';
    } else if (rangePosition == _RangePosition.end) {
      cellClassName += ' rounded-r-full';
    }

    return GestureDetector(
      onTap: (isCurrentMonth && !isDisabled) ? () => _onDayTap(date) : null,
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        child: WDiv(
          className: 'w-8 h-8 flex items-center justify-center $cellClassName',
          child: WText(
            '${date.day}',
            className: 'text-sm',
          ),
        ),
      ),
    );
  }

  bool _isDateDisabled(DateTime date) {
    if (minDate != null) {
      final min = DateTime(minDate!.year, minDate!.month, minDate!.day);
      if (date.isBefore(min)) return true;
    }
    if (maxDate != null) {
      final max = DateTime(maxDate!.year, maxDate!.month, maxDate!.day);
      if (date.isAfter(max)) return true;
    }
    return false;
  }

  bool _isDateSelected(DateTime date) {
    if (selectedDate != null) {
      return date.year == selectedDate!.year &&
          date.month == selectedDate!.month &&
          date.day == selectedDate!.day;
    }
    if (selectedRange != null) {
      final start = selectedRange!.start;
      final end = selectedRange!.end;
      return (date.year == start.year &&
              date.month == start.month &&
              date.day == start.day) ||
          (date.year == end.year &&
              date.month == end.month &&
              date.day == end.day);
    }
    return false;
  }

  _RangePosition _getRangePosition(DateTime date) {
    if (selectedRange == null) return _RangePosition.none;

    final start = DateTime(selectedRange!.start.year,
        selectedRange!.start.month, selectedRange!.start.day);
    final end = DateTime(selectedRange!.end.year, selectedRange!.end.month,
        selectedRange!.end.day);
    final current = DateTime(date.year, date.month, date.day);

    if (current.isAtSameMomentAs(start)) return _RangePosition.start;
    if (current.isAtSameMomentAs(end)) return _RangePosition.end;
    if (current.isAfter(start) && current.isBefore(end)) {
      return _RangePosition.middle;
    }
    return _RangePosition.none;
  }

  void _onDayTap(DateTime date) {
    onDateSelected?.call(date);
  }
}

/// Internal data class for day cell.
class _DayData {
  const _DayData({
    required this.date,
    required this.isCurrentMonth,
  });

  final DateTime date;
  final bool isCurrentMonth;
}

/// Range position for styling.
enum _RangePosition {
  none,
  start,
  middle,
  end,
}
