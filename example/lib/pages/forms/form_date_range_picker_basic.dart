import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class FormDateRangePickerBasicExamplePage extends StatefulWidget {
  const FormDateRangePickerBasicExamplePage({super.key});

  @override
  State<FormDateRangePickerBasicExamplePage> createState() =>
      _FormDateRangePickerBasicExamplePageState();
}

class _FormDateRangePickerBasicExamplePageState
    extends State<FormDateRangePickerBasicExamplePage> {
  final _formKey = GlobalKey<FormState>();

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
            title: 'Form Range Picker',
            description: 'Validating a date range selection.',
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  WFormDateRangePicker(
                    label: 'Travel Dates',
                    hint: 'Select check-in and check-out',
                    showPresets: true,
                    presets: [
                      DatePreset.last7Days(),
                      DatePreset.last30Days(),
                    ],
                    validator: (range) {
                      if (range == null) return 'Please select dates';
                      if (range.duration.inDays < 2)
                        return 'Minimum 2 days required';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  WButton(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Range Valid!')),
                        );
                      }
                    },
                    className:
                        'bg-indigo-600 text-white px-4 py-2 rounded-lg hover:bg-indigo-700 w-full',
                    child: WText('Book Dates'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className:
          'bg-gradient-to-r from-violet-500 to-fuchsia-600 rounded-xl p-6',
      child: WText(
        'WFormDateRangePicker',
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
