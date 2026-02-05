import 'package:flutter/material.dart';

import '../parser/wind_parser.dart';
import 'w_button.dart';
import 'w_icon.dart';
import 'w_text.dart';

/// A calendar header widget for month/year display and navigation.
///
/// Displays the current month and year with previous/next navigation buttons.
/// Supports date constraints to disable navigation outside allowed range.
///
/// Example:
/// ```dart
/// WCalendarHeader(
///   month: DateTime(2026, 2, 1),
///   onMonthChanged: (newMonth) => setState(() => _month = newMonth),
/// )
/// ```
class WCalendarHeader extends StatelessWidget {
  /// Creates a calendar header for the specified month.
  const WCalendarHeader({
    super.key,
    required this.month,
    this.onMonthChanged,
    this.className,
    this.minDate,
    this.maxDate,
    this.locale,
    this.monthYearClassName,
    this.buttonClassName,
    this.disabledButtonClassName,
  });

  /// The month to display (only year and month are used).
  final DateTime month;

  /// Callback when the month changes via navigation.
  final ValueChanged<DateTime>? onMonthChanged;

  /// Wind utility classes for the header container.
  final String? className;

  /// Minimum navigable date.
  final DateTime? minDate;

  /// Maximum navigable date.
  final DateTime? maxDate;

  /// Locale for month name formatting.
  final Locale? locale;

  /// Wind utility classes for the month/year text.
  final String? monthYearClassName;

  /// Wind utility classes for navigation buttons.
  final String? buttonClassName;

  /// Wind utility classes for disabled navigation buttons.
  final String? disabledButtonClassName;

  @override
  Widget build(BuildContext context) {
    final effectiveClassName = className ?? '';
    final styles = WindParser.parse(effectiveClassName, context);

    final canGoPrevious = _canNavigateToPreviousMonth();
    final canGoNext = _canNavigateToNextMonth();

    return Container(
      decoration: styles.decoration,
      padding: styles.padding ?? const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavigationButton(
            icon: Icons.chevron_left,
            onTap: canGoPrevious ? _goToPreviousMonth : null,
            enabled: canGoPrevious,
          ),
          Expanded(child: _buildMonthYearDisplay(context)),
          _buildNavigationButton(
            icon: Icons.chevron_right,
            onTap: canGoNext ? _goToNextMonth : null,
            enabled: canGoNext,
          ),
        ],
      ),
    );
  }

  Widget _buildMonthYearDisplay(BuildContext context) {
    final displayText = '${_monthName(month.month)} ${month.year}';

    final textClassName = monthYearClassName ??
        'text-base font-semibold text-gray-900 dark:text-gray-100';

    return WText(
      displayText,
      className: textClassName,
    );
  }

  /// Month names in English.
  static const List<String> _monthNames = [
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
    'December',
  ];

  String _monthName(int month) => _monthNames[month - 1];

  Widget _buildNavigationButton({
    required IconData icon,
    required VoidCallback? onTap,
    required bool enabled,
  }) {
    final effectiveClassName = enabled
        ? (buttonClassName ??
            'p-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700 text-gray-600 dark:text-gray-400')
        : (disabledButtonClassName ??
            'p-2 rounded-lg text-gray-300 dark:text-gray-600 cursor-not-allowed');

    return WButton(
      onTap: onTap,
      disabled: !enabled,
      className: effectiveClassName,
      child: WIcon(icon, className: 'text-xl'),
    );
  }

  bool _canNavigateToPreviousMonth() {
    if (minDate == null) return true;

    final previousMonth = DateTime(month.year, month.month - 1, 1);
    final minMonth = DateTime(minDate!.year, minDate!.month, 1);

    return !previousMonth.isBefore(minMonth);
  }

  bool _canNavigateToNextMonth() {
    if (maxDate == null) return true;

    final nextMonth = DateTime(month.year, month.month + 1, 1);
    final maxMonth = DateTime(maxDate!.year, maxDate!.month, 1);

    return !nextMonth.isAfter(maxMonth);
  }

  void _goToPreviousMonth() {
    final previousMonth = DateTime(month.year, month.month - 1, 1);
    onMonthChanged?.call(previousMonth);
  }

  void _goToNextMonth() {
    final nextMonth = DateTime(month.year, month.month + 1, 1);
    onMonthChanged?.call(nextMonth);
  }
}
