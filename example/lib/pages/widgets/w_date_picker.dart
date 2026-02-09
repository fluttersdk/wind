import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class WDatePickerExamplePage extends StatefulWidget {
  const WDatePickerExamplePage({super.key});

  @override
  State<WDatePickerExamplePage> createState() => _WDatePickerExamplePageState();
}

class _WDatePickerExamplePageState extends State<WDatePickerExamplePage> {
  DateTime? _date1;
  DateTime? _date2;

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
            title: 'Basic Date Picker',
            description: 'A simple date picker with default styling.',
            child: WDatePicker(
              value: _date1,
              onChanged: (date) => setState(() => _date1 = date),
              placeholder: 'Pick a date',
            ),
          ),
          _buildSection(
            title: 'With Custom Styling',
            description: 'Date picker with custom trigger and menu styling.',
            child: WDatePicker(
              value: _date2,
              onChanged: (date) => setState(() => _date2 = date),
              placeholder: 'Select appointment',
              className:
                  'bg-indigo-50 dark:bg-indigo-900/30 border-indigo-200 dark:border-indigo-700 text-indigo-900 dark:text-indigo-100 px-4 py-3 rounded-xl',
              menuClassName:
                  'bg-white dark:bg-slate-800 shadow-xl rounded-xl border border-indigo-100 dark:border-indigo-900',
            ),
          ),
          _buildSection(
            title: 'Disabled State',
            description: 'Date picker in disabled state.',
            child: WDatePicker(
              disabled: true,
              placeholder: 'Cannot select',
              className:
                  'bg-gray-100 dark:bg-gray-800 text-gray-400 border-gray-200 dark:border-gray-700 cursor-not-allowed',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className: 'bg-gradient-to-r from-blue-500 to-indigo-600 rounded-xl p-6',
      child: WText(
        'WDatePicker',
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
