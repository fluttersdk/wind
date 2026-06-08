import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class DatePickerRangeExamplePage extends StatefulWidget {
  const DatePickerRangeExamplePage({super.key});

  @override
  State<DatePickerRangeExamplePage> createState() =>
      _DatePickerRangeExamplePageState();
}

class _DatePickerRangeExamplePageState
    extends State<DatePickerRangeExamplePage> {
  DateRange? _range;

  static const _triggerCls = '''
    w-full p-3 rounded-lg
    bg-white dark:bg-slate-800
    border border-slate-300 dark:border-slate-600
    hover:border-rose-500
  ''';

  String _formatRange(DateRange? r) {
    if (r == null) return '—';
    final start = r.start.toString().split(' ').first;
    final end = r.end?.toString().split(' ').first ?? '…';
    return '$start → $end';
  }

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Date Range Picker',
      description:
          'mode: WDatePickerMode.range enables two-click range selection with hover preview. range + onRangeChanged for controlled state.',
      gradient: 'from-rose-500 to-pink-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'First click sets start. Hover paints the candidate range. Second click commits the end.',
          child: WDiv(
            className: 'flex flex-col gap-3',
            children: [
              WDatePicker(
                mode: WDatePickerMode.range,
                range: _range,
                onRangeChanged: (r) => setState(() => _range = r),
                placeholder: 'Check-in / Check-out',
                className: _triggerCls,
              ),
              WDiv(
                className: '''
                  p-3 rounded font-mono text-sm
                  bg-slate-50 dark:bg-slate-700/40
                ''',
                children: [
                  WText(
                    'Range: ${_formatRange(_range)}',
                    className: 'text-slate-700 dark:text-slate-200',
                  ),
                  if (_range != null && _range!.isComplete)
                    WText(
                      'Days: ${_range!.end!.difference(_range!.start).inDays}',
                      className: 'text-slate-500 dark:text-slate-400 mt-1',
                    ),
                ],
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'How It Works',
          description:
              'onRangeChanged fires twice: once with start only (end == null), once with the complete range.',
          child: WDiv(
            className: 'flex flex-col gap-1',
            children: const [
              _Step(n: 1, text: 'First click → DateRange(start, end: null)'),
              _Step(n: 2, text: 'Hover → preview highlights candidate range'),
              _Step(
                  n: 3,
                  text: 'Second click → DateRange(start, end: …) commits'),
              _Step(n: 4, text: 'If end < start, swap automatically'),
            ],
          ),
        ),
      ],
    );
  }
}

class _Step extends StatelessWidget {
  final int n;
  final String text;

  const _Step({required this.n, required this.text});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: '''
        flex flex-row items-center gap-3
        px-3 py-2 rounded-md
        bg-slate-50 dark:bg-slate-700/40
      ''',
      children: [
        WDiv(
          className: '''
            w-6 h-6 rounded-full
            bg-rose-500
            flex items-center justify-center
          ''',
          child: WText(
            '$n',
            className: 'text-white text-xs font-bold',
          ),
        ),
        WText(
          text,
          className: 'flex-1 text-sm text-slate-700 dark:text-slate-200',
        ),
      ],
    );
  }
}
