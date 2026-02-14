import 'package:flutter/material.dart' hide DatePickerMode;
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Basic single date picker usage with default styling.
class DatePickerBasicExamplePage extends StatefulWidget {
  const DatePickerBasicExamplePage({super.key});

  @override
  State<DatePickerBasicExamplePage> createState() =>
      _DatePickerBasicExamplePageState();
}

class _DatePickerBasicExamplePageState
    extends State<DatePickerBasicExamplePage> {
  DateTime? _selectedDate;

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
                'bg-gradient-to-r from-blue-500 to-indigo-600 rounded-xl p-6',
            children: const [
              WText('Basic Date Picker',
                  className: 'text-2xl font-bold text-white'),
              WText(
                'Single date selection with default styling.',
                className: 'text-blue-100 mt-1',
              ),
            ],
          ),

          // Default
          _buildSection(
            title: 'Default',
            description:
                'No className — uses built-in trigger styling with dark mode support.',
            child: WDatePicker(
              value: _selectedDate,
              onChanged: (date) => setState(() => _selectedDate = date),
            ),
          ),

          // With Placeholder
          _buildSection(
            title: 'Custom Placeholder',
            description:
                'Set placeholder text shown when no value is selected.',
            child: WDatePicker(
              value: _selectedDate,
              onChanged: (date) => setState(() => _selectedDate = date),
              placeholder: 'Pick a birthday',
              className:
                  'w-full p-3 border border-gray-300 rounded-lg bg-white dark:bg-slate-800 dark:border-gray-600',
            ),
          ),

          // Custom Format
          _buildSection(
            title: 'Custom Display Format',
            description: 'Override the default date format with a function.',
            child: WDatePicker(
              value: _selectedDate,
              onChanged: (date) => setState(() => _selectedDate = date),
              displayFormat: (date) =>
                  '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}',
              className:
                  'w-full p-3 border border-gray-300 rounded-lg bg-white dark:bg-slate-800 dark:border-gray-600',
            ),
          ),

          // Disabled
          _buildSection(
            title: 'Disabled',
            description: 'Prevents interaction with a forbidden cursor.',
            child: WDatePicker(
              disabled: true,
              value: DateTime(2025, 6, 15),
              className:
                  'w-full p-3 border border-gray-300 rounded-lg disabled:opacity-50 disabled:bg-gray-100',
            ),
          ),

          // Selected Value Display
          if (_selectedDate != null)
            WDiv(
              className:
                  'p-4 bg-blue-50 dark:bg-blue-900/20 rounded-lg border border-blue-200 dark:border-blue-800',
              child: WText(
                'Selected: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                className: 'text-sm font-mono text-blue-700 dark:text-blue-300',
              ),
            ),
        ],
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
