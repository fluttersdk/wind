import 'package:flutter/material.dart' hide DatePickerMode;
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Form date picker in range mode with validation.
class FormDatePickerRangeExamplePage extends StatefulWidget {
  const FormDatePickerRangeExamplePage({super.key});

  @override
  State<FormDatePickerRangeExamplePage> createState() =>
      _FormDatePickerRangeExamplePageState();
}

class _FormDatePickerRangeExamplePageState
    extends State<FormDatePickerRangeExamplePage> {
  final _formKey = GlobalKey<FormState>();
  DateRange? _tripRange;
  DateRange? _stayRange;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final buffer = StringBuffer('Form valid!');
      if (_tripRange?.isComplete == true) {
        final days = _tripRange!.end!.difference(_tripRange!.start).inDays;
        buffer.write(' Trip: $days days.');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(buffer.toString())),
      );
    }
  }

  void _reset() {
    _formKey.currentState!.reset();
    setState(() {
      _tripRange = null;
      _stayRange = null;
    });
  }

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
                'bg-gradient-to-r from-amber-500 to-orange-600 rounded-xl p-6',
            children: const [
              WText('Form Date Range',
                  className: 'text-2xl font-bold text-white'),
              WText(
                'WFormDatePicker in range mode with validation and error states.',
                className: 'text-amber-100 mt-1',
              ),
            ],
          ),

          Form(
            key: _formKey,
            child: WDiv(
              className: 'flex flex-col gap-6',
              children: [
                // Required Range
                _buildSection(
                  title: 'Required Trip Dates',
                  description:
                      'Validates that a range start has been selected.',
                  child: WFormDatePicker(
                    mode: DatePickerMode.range,
                    label: 'Trip Dates',
                    hint: 'Select your check-in and check-out dates',
                    initialRange: _tripRange,
                    onRangeChanged: (range) =>
                        setState(() => _tripRange = range),
                    validator: (value) =>
                        value == null ? 'Please select your trip dates' : null,
                    className:
                        'w-full p-3 border border-gray-300 dark:border-gray-600 '
                        'rounded-lg bg-white dark:bg-slate-800 '
                        'error:border-red-500 error:ring-2 error:ring-red-200 '
                        'dark:error:ring-red-900/30',
                  ),
                ),

                // Constrained Range
                _buildSection(
                  title: 'Constrained Stay',
                  description:
                      'Only future dates within the next 60 days are selectable.',
                  child: WFormDatePicker(
                    mode: DatePickerMode.range,
                    label: 'Stay Duration',
                    placeholder: 'Select stay window',
                    initialRange: _stayRange,
                    minDate: DateTime.now(),
                    maxDate: DateTime.now().add(const Duration(days: 60)),
                    onRangeChanged: (range) =>
                        setState(() => _stayRange = range),
                    validator: (value) =>
                        value == null ? 'Stay dates are required' : null,
                    className:
                        'w-full p-3 border border-gray-300 dark:border-gray-600 '
                        'rounded-lg bg-white dark:bg-slate-800 '
                        'error:border-red-500',
                  ),
                ),

                // Range Info
                if (_tripRange?.isComplete == true)
                  WDiv(
                    className:
                        'p-4 bg-amber-50 dark:bg-amber-900/20 rounded-lg border border-amber-200 dark:border-amber-800',
                    child: WText(
                      'Trip: ${_tripRange!.end!.difference(_tripRange!.start).inDays} days selected',
                      className:
                          'text-sm font-mono text-amber-700 dark:text-amber-300',
                    ),
                  ),

                // Action Buttons
                WDiv(
                  className: 'flex gap-4 pt-4',
                  children: [
                    WButton(
                      onTap: _submit,
                      className:
                          'bg-amber-600 hover:bg-amber-700 text-white px-8 py-3 rounded-lg font-bold shadow-md transition-all',
                      child: const Text('Validate'),
                    ),
                    WButton(
                      onTap: _reset,
                      className:
                          'bg-slate-200 dark:bg-slate-700 text-slate-700 dark:text-slate-200 px-8 py-3 rounded-lg font-bold hover:bg-slate-300 dark:hover:bg-slate-600 transition-all',
                      child: const Text('Reset'),
                    ),
                  ],
                ),
              ],
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
