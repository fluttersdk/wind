import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// WDatePicker widget examples.
class WDatePickerExamplePage extends StatefulWidget {
  const WDatePickerExamplePage({super.key});

  @override
  State<WDatePickerExamplePage> createState() => _WDatePickerExamplePageState();
}

class _WDatePickerExamplePageState extends State<WDatePickerExamplePage> {
  DateTime? _singleDate;
  DateRange? _dateRange;
  DateTime? _constrainedDate;
  DateTime? _styledDate;

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'w-full h-full overflow-y-auto p-4',
      scrollPrimary: true,
      child: WDiv(
        className: 'flex flex-col gap-8 max-w-4xl mx-auto',
        children: [
          // Header
          WDiv(
            className:
                'bg-gradient-to-r from-blue-500 to-indigo-600 rounded-xl p-6 shadow-lg',
            children: const [
              WText('WDatePicker', className: 'text-2xl font-bold text-white'),
              WText(
                'Utility-first date picker with single and range selection support.',
                className: 'text-blue-100 mt-1',
              ),
            ],
          ),

          // Single Date Selection
          _buildSection(
            title: 'Single Date',
            description: 'The default mode for selecting a single date.',
            className:
                'w-full p-3 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-slate-800',
            child: WDatePicker(
              value: _singleDate,
              onChanged: (date) => setState(() => _singleDate = date),
              placeholder: 'Pick a day',
              className:
                  'w-full p-3 border border-gray-300 dark:border-gray-600 rounded-lg',
            ),
          ),

          // Date Range Selection
          _buildSection(
            title: 'Date Range',
            description: 'Select a start and end date with hover preview.',
            className:
                'w-full p-3 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-slate-800',
            child: WDatePicker(
              mode: WDatePickerMode.range,
              range: _dateRange,
              onRangeChanged: (range) => setState(() => _dateRange = range),
              placeholder: 'Select duration',
              className:
                  'w-full p-3 border border-gray-300 dark:border-gray-600 rounded-lg',
            ),
          ),

          // Constraints
          _buildSection(
            title: 'Constraints (Min/Max)',
            description:
                'Limit selection between Jan 1, 2025 and Dec 31, 2025.',
            className:
                'w-full p-3 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-slate-800',
            child: WDatePicker(
              value: _constrainedDate,
              minDate: DateTime(2025, 1, 1),
              maxDate: DateTime(2025, 12, 31),
              onChanged: (date) => setState(() => _constrainedDate = date),
              placeholder: 'Select in 2025',
              className:
                  'w-full p-3 border border-gray-300 dark:border-gray-600 rounded-lg',
            ),
          ),

          // Custom Styling
          _buildSection(
            title: 'Custom Styling',
            description:
                'Using Wind utilities to style the trigger and states.',
            className:
                'w-full p-3 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-slate-800',
            child: WDatePicker(
              value: _styledDate,
              onChanged: (date) => setState(() => _styledDate = date),
              placeholder: 'Custom Styled Picker',
              className: '''
                w-full p-4 bg-slate-100 dark:bg-slate-900 
                border-2 border-dashed border-slate-300 dark:border-slate-700
                rounded-2xl hover:border-blue-500 dark:hover:border-blue-400
                transition-all duration-300
              ''',
            ),
          ),

          // Disabled State
          _buildSection(
            title: 'Disabled',
            description: 'Interaction is blocked and styling is updated.',
            className:
                'w-full p-3 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-slate-800',
            child: const WDatePicker(
              disabled: true,
              placeholder: 'Cannot pick this',
              className:
                  'w-full p-3 border border-gray-300 dark:border-gray-600 rounded-lg opacity-50',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String description,
    required String className,
    required Widget child,
  }) {
    return WDiv(
      className: 'flex flex-col gap-3',
      children: [
        WDiv(
          children: [
            WText(title,
                className: 'text-lg font-bold text-slate-900 dark:text-white'),
            WText(description,
                className: 'text-sm text-slate-500 dark:text-slate-400'),
          ],
        ),
        WDiv(
          className:
              'bg-slate-50 dark:bg-slate-900/50 p-6 rounded-xl border border-slate-200 dark:border-slate-800',
          child: child,
        ),
        WDiv(
          className: 'bg-slate-800 rounded-lg p-3',
          child: WText(
            className.trim().replaceAll(RegExp(r'\s+'), ' '),
            className: 'text-xs font-mono text-blue-300',
          ),
        ),
      ],
    );
  }
}
