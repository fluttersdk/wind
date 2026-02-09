import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class WDatePickerSingleExamplePage extends StatefulWidget {
  const WDatePickerSingleExamplePage({super.key});

  @override
  State<WDatePickerSingleExamplePage> createState() =>
      _WDatePickerSingleExamplePageState();
}

class _WDatePickerSingleExamplePageState
    extends State<WDatePickerSingleExamplePage> {
  DateTime? _selectedDate;
  DateTime? _constrainedDate;

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'w-full h-full overflow-y-auto p-4',
      scrollPrimary: true,
      child: WDiv(
        className: 'flex flex-col gap-6 max-w-4xl mx-auto',
        children: [
          _buildHeader(),
          _buildSection(
            title: 'Single Date Selection',
            description: 'Standard mode for selecting a single date.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WDatePicker(
                  value: _selectedDate,
                  onChanged: (date) => setState(() => _selectedDate = date),
                ),
                if (_selectedDate != null)
                  WText(
                    'Selected: ${_selectedDate.toString().split(' ')[0]}',
                    className: 'text-sm text-blue-600 dark:text-blue-400 mt-2',
                  ),
              ],
            ),
          ),
          _buildSection(
            title: 'Date Constraints',
            description:
                'Restricts selection to a specific range (e.g., next 7 days).',
            child: WDatePicker(
              value: _constrainedDate,
              onChanged: (date) => setState(() => _constrainedDate = date),
              placeholder: 'Select within next 7 days',
              minDate: DateTime.now(),
              maxDate: DateTime.now().add(const Duration(days: 7)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className: 'bg-gradient-to-r from-purple-500 to-pink-600 rounded-xl p-6',
      child: WText(
        'Single Date Selection',
        className: 'text-2xl font-bold text-white',
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String description,
    required Widget child,
  }) {
    return WDiv(
      className:
          'flex flex-col gap-4 p-6 bg-white dark:bg-slate-800 rounded-lg shadow-sm border border-gray-100 dark:border-gray-700',
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
