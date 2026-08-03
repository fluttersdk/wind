import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class DatePickerDatetimeExamplePage extends StatefulWidget {
  const DatePickerDatetimeExamplePage({super.key});

  @override
  State<DatePickerDatetimeExamplePage> createState() =>
      _DatePickerDatetimeExamplePageState();
}

class _DatePickerDatetimeExamplePageState
    extends State<DatePickerDatetimeExamplePage> {
  DateTime? _deployAt;
  DateTime? _slot;
  DateTime? _reviewAt;
  DateTime? _windowStart;
  DateTime? _windowEnd;

  static const _triggerCls = '''
    w-full p-3 rounded-lg
    bg-white dark:bg-slate-800
    border border-slate-300 dark:border-slate-600
    hover:border-rose-500 dark:hover:border-rose-400
  ''';

  static const _readoutCls = '''
    text-sm font-mono
    text-slate-500 dark:text-slate-400
  ''';

  /// The last selectable instant of the seventh day from today.
  ///
  /// Spelled out to 23:59 on purpose: a bare `DateTime(y, m, d)` bound is that
  /// day at midnight, which would cap the last day at 00:00.
  DateTime get _weekEnd {
    final DateTime day = DateTime.now().add(const Duration(days: 7));
    return DateTime(day.year, day.month, day.day, 23, 59);
  }

  String _formatInstant(DateTime? instant) {
    if (instant == null) return '—';
    return instant.toIso8601String().substring(0, 16).replaceFirst('T', ' ');
  }

  String get _windowLength {
    if (_windowStart == null || _windowEnd == null) return 'Pick both ends';
    final Duration span = _windowEnd!.difference(_windowStart!);
    if (span.isNegative) return 'The end is before the start';
    return '${span.inHours}h ${span.inMinutes.remainder(60)}m';
  }

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'WDatePicker · dateTime',
      description:
          'WDatePickerMode.dateTime keeps the time of day. The tapped day is composed with a stepped time row and emitted as one local DateTime, where single and range modes strike everything to midnight.',
      gradient: 'from-rose-500 to-pink-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'The popover stays open after a day tap: the time row below the calendar is the second half of the selection, and the confirm control closes it. onChanged fires on every day tap and every step.',
          child: WDiv(
            className: 'flex flex-col gap-2',
            children: [
              WDatePicker(
                mode: WDatePickerMode.dateTime,
                value: _deployAt,
                onChanged: (value) => setState(() => _deployAt = value),
                placeholder: 'Schedule the deploy',
                className: _triggerCls,
              ),
              WText(
                'Emitted: ${_formatInstant(_deployAt)}',
                className: _readoutCls,
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Minute Step',
          description:
              'minuteStep sets how far one press of the minute spinner moves. 15 gives quarter-hour booking slots; the default is 5.',
          child: WDiv(
            className: 'flex flex-col gap-2',
            children: [
              WDatePicker(
                mode: WDatePickerMode.dateTime,
                value: _slot,
                onChanged: (value) => setState(() => _slot = value),
                minuteStep: 15,
                placeholder: 'Book a 15-minute slot',
                className: _triggerCls,
              ),
              WText(
                'Emitted: ${_formatInstant(_slot)}',
                className: _readoutCls,
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Row Labels and Display Format',
          description:
              'timeLabel names the row, doneLabel names the confirm control, and displayFormat owns the whole trigger text (including the clock) once you provide it.',
          child: WDiv(
            className: 'flex flex-col gap-2',
            children: [
              WDatePicker(
                mode: WDatePickerMode.dateTime,
                value: _reviewAt,
                onChanged: (value) => setState(() => _reviewAt = value),
                timeLabel: 'Starts at',
                doneLabel: 'Apply',
                displayFormat: (value) =>
                    '${value.day.toString().padLeft(2, "0")}.${value.month.toString().padLeft(2, "0")}.${value.year} · '
                    '${value.hour.toString().padLeft(2, "0")}:${value.minute.toString().padLeft(2, "0")}',
                placeholder: 'Schedule the review',
                className: _triggerCls,
              ),
              WText(
                'Emitted: ${_formatInstant(_reviewAt)}',
                className: _readoutCls,
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Instant-Level Bounds',
          description:
              'minDate and maxDate are compared on the full instant here, not on the day. A step that would leave the window renders greyed out, and a day tap that would land outside it is pulled back to the bound.',
          child: WDiv(
            className: 'flex flex-col gap-4',
            children: [
              WDiv(
                className: 'flex flex-col gap-2',
                children: [
                  WText(
                    'Maintenance window · start',
                    className:
                        'text-xs font-medium uppercase text-slate-500 dark:text-slate-400',
                  ),
                  WDatePicker(
                    mode: WDatePickerMode.dateTime,
                    value: _windowStart,
                    onChanged: (value) => setState(() {
                      _windowStart = value;
                      // Keep the pair coherent: an end before the new start is
                      // no longer a window.
                      if (_windowEnd != null && _windowEnd!.isBefore(value)) {
                        _windowEnd = null;
                      }
                    }),
                    minDate: DateTime.now(),
                    maxDate: _weekEnd,
                    minuteStep: 30,
                    placeholder: 'Within the next 7 days',
                    className: _triggerCls,
                  ),
                ],
              ),
              WDiv(
                className: 'flex flex-col gap-2',
                children: [
                  WText(
                    'Maintenance window · end',
                    className:
                        'text-xs font-medium uppercase text-slate-500 dark:text-slate-400',
                  ),
                  WDatePicker(
                    mode: WDatePickerMode.dateTime,
                    value: _windowEnd,
                    onChanged: (value) => setState(() => _windowEnd = value),
                    // The start is the floor, so the second picker can never
                    // produce a negative window.
                    minDate: _windowStart ?? DateTime.now(),
                    maxDate: _weekEnd,
                    minuteStep: 30,
                    placeholder: 'After the start',
                    className: _triggerCls,
                  ),
                ],
              ),
              WText(
                'Window length: $_windowLength',
                className: _readoutCls,
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Inside a Form',
          description:
              'WFormDatePicker forwards mode, minuteStep, timeLabel and doneLabel unchanged, and the FormField holds the full instant, so a validator can compare times of day.',
          child: Form(
            child: WFormDatePicker(
              mode: WDatePickerMode.dateTime,
              label: 'Call with the customer',
              hint: 'Office hours run 09:00 to 18:00',
              minuteStep: 15,
              timeLabel: 'Time',
              doneLabel: 'Confirm',
              autovalidateMode: AutovalidateMode.onUserInteraction,
              className: '''
                $_triggerCls
                error:border-red-500 dark:error:border-red-400
              ''',
              validator: (value) {
                if (value == null) return 'Pick a date and a time';
                if (value.hour < 9 || value.hour >= 18) {
                  return 'Office hours run 09:00 to 18:00';
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }
}
