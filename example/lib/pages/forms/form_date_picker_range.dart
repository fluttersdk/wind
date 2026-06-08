import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

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
  String _summary = '';

  static const _triggerCls = '''
    w-full p-3 rounded-lg
    bg-white dark:bg-slate-800
    border border-slate-300 dark:border-slate-600
    hover:border-rose-500
    error:border-red-500 error:ring-2 error:ring-red-500/30
  ''';

  String _formatRange(DateRange? range) {
    if (range == null || !range.isComplete) return '—';
    String fmt(DateTime d) => d.toIso8601String().split('T').first;
    return '${fmt(range.start)} → ${fmt(range.end!)}';
  }

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Form Date Range',
      description:
          'mode: WDatePickerMode.range. Validator sees the range start; for length-based rules drive validation from onRangeChanged.',
      gradient: 'from-rose-500 to-pink-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Trip date range as a required field. The validator simply checks for a non-null start.',
          child: Form(
            key: _formKey,
            child: WDiv(
              className: 'flex flex-col gap-4',
              children: [
                WFormDatePicker(
                  label: 'Trip Dates',
                  mode: WDatePickerMode.range,
                  placeholder: 'Check-in / check-out',
                  className: _triggerCls,
                  onRangeChanged: (range) {
                    setState(() => _tripRange = range);
                  },
                  validator: (date) =>
                      date == null ? 'Please select your trip dates' : null,
                ),
                WButton(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      final r = _tripRange;
                      setState(() {
                        _summary = (r != null && r.isComplete)
                            ? 'Stay: ${r.end!.difference(r.start).inDays} nights'
                            : 'Pick a complete range';
                      });
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
                  'Range: ${_formatRange(_tripRange)}',
                  className:
                      'font-mono text-sm text-slate-500 dark:text-slate-400',
                ),
                if (_summary.isNotEmpty)
                  WText(
                    _summary,
                    className: 'font-medium text-rose-600 dark:text-rose-400',
                  ),
              ],
            ),
          ),
        ),
        ExampleSection(
          title: 'Minimum Stay (3 nights)',
          description:
              'Custom rule that auto-validates on interaction. Length is derived from onRangeChanged state, not from the validator argument.',
          child: _MinStayDemo(triggerCls: _triggerCls),
        ),
      ],
    );
  }
}

class _MinStayDemo extends StatefulWidget {
  const _MinStayDemo({required this.triggerCls});

  final String triggerCls;

  @override
  State<_MinStayDemo> createState() => _MinStayDemoState();
}

class _MinStayDemoState extends State<_MinStayDemo> {
  DateRange? _range;
  String? _externalError;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: WFormDatePicker(
        label: 'Stay (minimum 3 nights)',
        mode: WDatePickerMode.range,
        placeholder: 'Check-in / check-out',
        className: widget.triggerCls,
        states: _externalError == null ? null : const {'error'},
        onRangeChanged: (range) {
          setState(() {
            _range = range;
            if (!range.isComplete) {
              _externalError = null;
            } else {
              final nights = range.end!.difference(range.start).inDays;
              _externalError = nights < 3 ? 'At least 3 nights required' : null;
            }
          });
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (date) {
          if (date == null) return 'Pick a date range';
          return _externalError;
        },
        hint: _range == null
            ? null
            : 'Selected ${_range!.isComplete ? _range!.end!.difference(_range!.start).inDays : 0} nights',
      ),
    );
  }
}
