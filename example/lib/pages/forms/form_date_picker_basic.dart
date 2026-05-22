import 'package:flutter/material.dart' hide DatePickerMode;
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class FormDatePickerBasicExamplePage extends StatefulWidget {
  const FormDatePickerBasicExamplePage({super.key});

  @override
  State<FormDatePickerBasicExamplePage> createState() =>
      _FormDatePickerBasicExamplePageState();
}

class _FormDatePickerBasicExamplePageState
    extends State<FormDatePickerBasicExamplePage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _savedDate;

  static const _triggerCls = '''
    w-full p-3 rounded-lg
    bg-white dark:bg-slate-800
    border border-slate-300 dark:border-slate-600
    hover:border-rose-500
    error:border-red-500 error:ring-2 error:ring-red-500/30
  ''';

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'WFormDatePicker',
      description:
          'FormField-wrapped WDatePicker. Validator receives DateTime?; error: prefix activates on failure. Label + hint + error stacked vertically.',
      gradient: 'from-rose-500 to-pink-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Required event date inside a Form. Validates on submit.',
          child: Form(
            key: _formKey,
            child: WDiv(
              className: 'flex flex-col gap-4',
              children: [
                WFormDatePicker(
                  label: 'Event Date',
                  hint: 'When should we host it?',
                  className: _triggerCls,
                  onSaved: (date) => setState(() => _savedDate = date),
                  validator: (date) => date == null ? 'Date is required' : null,
                ),
                WButton(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                    }
                  },
                  className: '''
                    bg-rose-600 hover:bg-rose-700
                    text-white px-4 py-2 rounded-lg self-start
                  ''',
                  child: const WText('Submit',
                      className: 'text-white font-medium'),
                ),
                WText(
                  'Saved: ${_savedDate?.toIso8601String().split("T").first ?? "—"}',
                  className:
                      'font-mono text-sm text-slate-500 dark:text-slate-400',
                ),
              ],
            ),
          ),
        ),
        ExampleSection(
          title: 'Future Dates Only',
          description:
              'Combine validator + minDate. The error message fires when the user picks a past date or no date at all.',
          child: Form(
            child: WFormDatePicker(
              label: 'Departure Date',
              minDate: DateTime.now(),
              className: _triggerCls,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (date) {
                if (date == null) return 'Please select a departure date';
                if (date.isBefore(DateTime.now())) {
                  return 'Date must be in the future';
                }
                return null;
              },
            ),
          ),
        ),
        ExampleSection(
          title: 'Minimalist Style',
          description:
              'Drop the box, lean on a single underline. labelClassName + className keep things lightweight.',
          child: WFormDatePicker(
            label: 'WHEN',
            labelClassName:
                'text-xs uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-1',
            className: '''
              border-b border-slate-200 dark:border-slate-700
              py-2 rounded-none
              focus:border-rose-500
              error:border-red-500
            ''',
            hint: 'Optional',
          ),
        ),
      ],
    );
  }
}
