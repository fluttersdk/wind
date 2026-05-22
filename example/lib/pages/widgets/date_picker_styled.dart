import 'package:flutter/material.dart' hide DatePickerMode;
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class DatePickerStyledExamplePage extends StatefulWidget {
  const DatePickerStyledExamplePage({super.key});

  @override
  State<DatePickerStyledExamplePage> createState() =>
      _DatePickerStyledExamplePageState();
}

class _DatePickerStyledExamplePageState
    extends State<DatePickerStyledExamplePage> {
  DateTime? _ring;
  DateTime? _compact;
  DateTime? _shadow;

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Styling Variants',
      description:
          'className styles only the trigger. State prefixes (hover/focus/open/selected/disabled) compose freely.',
      gradient: 'from-rose-500 to-pink-600',
      children: [
        ExampleSection(
          title: 'Ring Focus Variant',
          description:
              'focus: variant adds ring + tinted border. selected: keeps the active state visible.',
          child: WDatePicker(
            value: _ring,
            onChanged: (d) => setState(() => _ring = d),
            placeholder: 'Click to focus',
            className: '''
              w-full p-3 rounded-lg
              bg-white dark:bg-slate-800
              border border-slate-300 dark:border-slate-600
              hover:border-rose-400
              focus:border-rose-500 focus:ring-2 focus:ring-rose-500/30
              selected:border-rose-500
            ''',
          ),
        ),
        ExampleSection(
          title: 'Compact Inline',
          description:
              'Small px / py + text-sm packs the trigger into a tight inline pill.',
          child: WDatePicker(
            value: _compact,
            onChanged: (d) => setState(() => _compact = d),
            placeholder: 'Date',
            className: '''
              px-3 py-1 rounded text-sm
              bg-slate-50 dark:bg-slate-700
              hover:bg-white dark:hover:bg-slate-600
              border border-slate-200 dark:border-slate-600
            ''',
          ),
        ),
        ExampleSection(
          title: 'Borderless Shadow',
          description:
              'Skip the border entirely; use shadow-* to delineate the trigger.',
          child: WDatePicker(
            value: _shadow,
            onChanged: (d) => setState(() => _shadow = d),
            placeholder: 'Pick a date',
            className: '''
              w-full p-3 rounded-xl
              bg-white dark:bg-slate-800
              shadow-md hover:shadow-lg duration-200
            ''',
          ),
        ),
      ],
    );
  }
}
