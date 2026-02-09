import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class FormDatePickerBasicExamplePage extends StatefulWidget {
  const FormDatePickerBasicExamplePage({super.key});

  @override
  State<FormDatePickerBasicExamplePage> createState() =>
      _FormDatePickerBasicExamplePageState();
}

class _FormDatePickerBasicExamplePageState
    extends State<FormDatePickerBasicExamplePage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _date;

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
            title: 'Form Integration',
            description: 'Date picker validated within a standard Form.',
            child: Form(
              key: _formKey,
              child: WDiv(
                className: 'flex flex-col gap-4',
                children: [
                  WFormDatePicker(
                    label: 'Birth Date',
                    hint: 'Must be in the past',
                    validator: (date) {
                      if (date == null) return 'Date is required';
                      if (date.isAfter(DateTime.now()))
                        return 'Cannot be in future';
                      return null;
                    },
                    onChanged: (date) => setState(() => _date = date),
                    className: 'bg-white dark:bg-slate-900',
                  ),
                  WButton(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Form Valid!')),
                        );
                      }
                    },
                    className:
                        'bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 mt-2',
                    child: WText('Validate & Submit'),
                  ),
                ],
              ),
            ),
          ),
          _buildSection(
            title: 'Custom Error Styling',
            description: 'Date picker with custom error styles.',
            child: WFormDatePicker(
              label: 'Required Date',
              initialValue: null,
              autovalidateMode: AutovalidateMode.always,
              validator: (v) =>
                  v == null ? 'This field is absolutely required' : null,
              errorClassName:
                  'text-sm font-bold text-orange-600 dark:text-orange-400 mt-2 p-2 bg-orange-50 dark:bg-orange-900/20 rounded',
              className: 'border-2',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className: 'bg-gradient-to-r from-orange-500 to-red-600 rounded-xl p-6',
      child: WText(
        'WFormDatePicker',
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
