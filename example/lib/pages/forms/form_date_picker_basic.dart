import 'package:flutter/material.dart' hide DatePickerMode;
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// WFormDatePicker example with form validation.
class FormDatePickerBasicExamplePage extends StatefulWidget {
  const FormDatePickerBasicExamplePage({super.key});

  @override
  State<FormDatePickerBasicExamplePage> createState() =>
      _FormDatePickerBasicExamplePageState();
}

class _FormDatePickerBasicExamplePageState
    extends State<FormDatePickerBasicExamplePage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  DateRange? _selectedRange;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form is valid!')),
      );
    }
  }

  void _reset() {
    _formKey.currentState!.reset();
    setState(() {
      _selectedDate = null;
      _selectedRange = null;
    });
  }

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
                'bg-gradient-to-r from-emerald-500 to-teal-600 rounded-xl p-6 shadow-lg',
            children: const [
              WText('WFormDatePicker',
                  className: 'text-2xl font-bold text-white'),
              WText(
                'Form-integrated date picker with validation and error states.',
                className: 'text-emerald-100 mt-1',
              ),
            ],
          ),

          Form(
            key: _formKey,
            child: WDiv(
              className: 'flex flex-col gap-8',
              children: [
                // Required Single Date
                _buildSection(
                  title: 'Required Selection',
                  description: 'Validates that a date must be selected.',
                  child: WFormDatePicker(
                    label: 'Pick a Date',
                    initialValue: _selectedDate,
                    onChanged: (date) => setState(() => _selectedDate = date),
                    validator: (value) =>
                        value == null ? 'Please select a date' : null,
                    className: '''
                      w-full p-3 border border-gray-300 dark:border-gray-600 
                      rounded-lg bg-white dark:bg-slate-800
                      error:border-red-500 error:ring-2 error:ring-red-200 dark:error:ring-red-900/30
                    ''',
                  ),
                ),

                // Date Range in Form
                _buildSection(
                  title: 'Date Range Validation',
                  description:
                      'Selecting a range also works within the form flow.',
                  child: WFormDatePicker(
                    mode: DatePickerMode.range,
                    label: 'Stay Duration',
                    hint: 'Select your check-in and check-out dates',
                    initialRange: _selectedRange,
                    onRangeChanged: (range) =>
                        setState(() => _selectedRange = range),
                    validator: (value) {
                      if (value == null) return 'Selection is required';
                      // Note: value here is range.start.
                      // For more complex range validation, you'd use _selectedRange.
                      return null;
                    },
                    className: '''
                      w-full p-3 border border-gray-300 dark:border-gray-600 
                      rounded-lg bg-white dark:bg-slate-800
                      error:border-red-500
                    ''',
                  ),
                ),

                // Constraints in Form
                _buildSection(
                  title: 'Constraints & Validation',
                  description: 'Combining min/max dates with validation.',
                  child: WFormDatePicker(
                    label: 'Future Event',
                    minDate: DateTime.now(),
                    placeholder: 'Select a future date',
                    validator: (value) =>
                        value == null ? 'Date is mandatory' : null,
                    className:
                        'w-full p-3 border border-gray-300 rounded-lg error:border-red-500',
                  ),
                ),

                // Action Buttons
                WDiv(
                  className: 'flex gap-4 pt-4',
                  children: [
                    WButton(
                      onTap: _submit,
                      className:
                          'bg-emerald-600 hover:bg-emerald-700 text-white px-8 py-3 rounded-lg font-bold shadow-md active:scale-95 transition-all',
                      child: const Text('Validate Form'),
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
      ],
    );
  }
}
