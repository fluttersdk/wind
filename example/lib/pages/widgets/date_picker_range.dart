import 'package:flutter/material.dart' hide DatePickerMode;
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Date range picker with hover preview.
class DatePickerRangeExamplePage extends StatefulWidget {
  const DatePickerRangeExamplePage({super.key});

  @override
  State<DatePickerRangeExamplePage> createState() =>
      _DatePickerRangeExamplePageState();
}

class _DatePickerRangeExamplePageState
    extends State<DatePickerRangeExamplePage> {
  DateRange? _tripRange;
  DateRange? _bookingRange;

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'w-full h-full overflow-y-auto p-4',
      scrollPrimary: true,
      child: WDiv(
        className: 'flex flex-col gap-6 max-w-4xl mx-auto',
        children: [
          // Header
          WDiv(
            className:
                'bg-gradient-to-r from-violet-500 to-purple-600 rounded-xl p-6',
            children: const [
              WText('Date Range Selection',
                  className: 'text-2xl font-bold text-white'),
              WText(
                'Two-click range selection with hover preview between dates.',
                className: 'text-violet-100 mt-1',
              ),
            ],
          ),

          // Basic Range
          _buildSection(
            title: 'Trip Duration',
            description:
                'Click once to set start, hover to preview, click again to complete.',
            child: WDatePicker(
              mode: DatePickerMode.range,
              range: _tripRange,
              onRangeChanged: (range) => setState(() => _tripRange = range),
              placeholder: 'Check-in / Check-out',
              className:
                  'w-full p-3 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-slate-800',
            ),
          ),

          // Range with Constraints
          _buildSection(
            title: 'Constrained Range',
            description: 'Only dates within the next 90 days are selectable.',
            child: WDatePicker(
              mode: DatePickerMode.range,
              range: _bookingRange,
              minDate: DateTime.now(),
              maxDate: DateTime.now().add(const Duration(days: 90)),
              onRangeChanged: (range) => setState(() => _bookingRange = range),
              placeholder: 'Select booking window',
              className:
                  'w-full p-3 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-slate-800',
            ),
          ),

          // Range Display
          if (_tripRange != null)
            WDiv(
              className:
                  'p-4 bg-violet-50 dark:bg-violet-900/20 rounded-lg border border-violet-200 dark:border-violet-800',
              children: [
                WText(
                  'Start: ${_formatDate(_tripRange!.start)}',
                  className:
                      'text-sm font-mono text-violet-700 dark:text-violet-300',
                ),
                if (_tripRange!.isComplete)
                  WText(
                    'End: ${_formatDate(_tripRange!.end!)} — ${_tripRange!.end!.difference(_tripRange!.start).inDays} days',
                    className:
                        'text-sm font-mono text-violet-700 dark:text-violet-300',
                  ),
              ],
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildSection({
    required String title,
    required String description,
    required Widget child,
  }) {
    return WDiv(
      className:
          'flex flex-col gap-4 p-4 bg-white dark:bg-slate-800 rounded-lg shadow-sm border border-slate-200 dark:border-slate-700',
      children: [
        WText(title,
            className: 'text-lg font-semibold text-slate-900 dark:text-white'),
        WText(description,
            className: 'text-sm text-slate-600 dark:text-slate-400'),
        child,
      ],
    );
  }
}
