import 'package:flutter/material.dart' hide DatePickerMode;
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class DatePickerBasicExamplePage extends StatefulWidget {
  const DatePickerBasicExamplePage({super.key});

  @override
  State<DatePickerBasicExamplePage> createState() =>
      _DatePickerBasicExamplePageState();
}

class _DatePickerBasicExamplePageState
    extends State<DatePickerBasicExamplePage> {
  DateTime? _date;
  DateTime? _constrainedDate;
  DateTime? _formattedDate;

  static const _triggerCls = '''
    w-full p-3 rounded-lg
    bg-white dark:bg-slate-800
    border border-slate-300 dark:border-slate-600
    hover:border-rose-500
  ''';

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'WDatePicker',
      description:
          'Calendar popover for single-date or date-range selection. Built on WPopover. value + onChanged for controlled state.',
      gradient: 'from-rose-500 to-pink-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Single-date selection with default Jan 15, 2025 display format.',
          child: WDiv(
            className: 'flex flex-col gap-2',
            children: [
              WDatePicker(
                value: _date,
                onChanged: (d) => setState(() => _date = d),
                placeholder: 'Select a date',
                className: _triggerCls,
              ),
              WText(
                'Selected: ${_date == null ? "—" : _date.toString().split(" ").first}',
                className:
                    'text-sm text-slate-500 dark:text-slate-400 font-mono',
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Min/Max Constraints',
          description:
              'minDate + maxDate restrict the selectable range. Out-of-range dates appear dimmed.',
          child: WDatePicker(
            value: _constrainedDate,
            onChanged: (d) => setState(() => _constrainedDate = d),
            minDate: DateTime.now(),
            maxDate: DateTime.now().add(const Duration(days: 90)),
            placeholder: 'Next 90 days only',
            className: _triggerCls,
          ),
        ),
        ExampleSection(
          title: 'Custom Display Format',
          description:
              'displayFormat receives the DateTime and returns the trigger text.',
          child: WDatePicker(
            value: _formattedDate,
            onChanged: (d) => setState(() => _formattedDate = d),
            displayFormat: (d) =>
                '${d.day.toString().padLeft(2, "0")}/${d.month.toString().padLeft(2, "0")}/${d.year}',
            placeholder: 'DD/MM/YYYY',
            className: _triggerCls,
          ),
        ),
        ExampleSection(
          title: 'Disabled',
          description:
              'disabled: true blocks the trigger. disabled: prefix dims it.',
          child: WDatePicker(
            value: DateTime(2026, 6, 15),
            onChanged: (_) {},
            disabled: true,
            className: '''
              $_triggerCls
              disabled:opacity-60 disabled:bg-slate-100
              dark:disabled:bg-slate-700
            ''',
          ),
        ),
      ],
    );
  }
}
