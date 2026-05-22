import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class CheckboxBasicExamplePage extends StatefulWidget {
  const CheckboxBasicExamplePage({super.key});

  @override
  State<CheckboxBasicExamplePage> createState() =>
      _CheckboxBasicExamplePageState();
}

class _CheckboxBasicExamplePageState extends State<CheckboxBasicExamplePage> {
  bool _terms = false;
  bool _newsletter = true;
  bool _danger = false;

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'WCheckbox',
      description:
          'Utility-styled checkbox. value + onChanged for controlled state. checked: prefix activates when value is true.',
      gradient: 'from-emerald-500 to-green-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'A standard square checkbox with checked: prefix flipping the background.',
          child: WDiv(
            className: 'flex flex-row items-center gap-3',
            children: [
              WCheckbox(
                value: _terms,
                onChanged: (v) => setState(() => _terms = v),
                className: '''
                  w-6 h-6 rounded-md
                  border-2 border-slate-300 dark:border-slate-600
                  checked:bg-emerald-600 checked:border-transparent
                  hover:border-emerald-500 duration-150
                ''',
              ),
              WText(
                'I agree to the terms',
                className: 'text-slate-900 dark:text-white',
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Sizes & Shapes',
          description:
              'Size via w/h. rounded-* for square vs circular variants.',
          child: WDiv(
            className: 'flex flex-row items-center gap-6',
            children: [
              WCheckbox(
                value: _newsletter,
                onChanged: (v) => setState(() => _newsletter = v),
                className: '''
                  w-4 h-4 rounded-sm
                  border-2 border-slate-300 dark:border-slate-600
                  checked:bg-emerald-500 checked:border-transparent
                ''',
              ),
              WCheckbox(
                value: _newsletter,
                onChanged: (v) => setState(() => _newsletter = v),
                className: '''
                  w-6 h-6 rounded-md
                  border-2 border-slate-300 dark:border-slate-600
                  checked:bg-emerald-500 checked:border-transparent
                ''',
              ),
              WCheckbox(
                value: _newsletter,
                onChanged: (v) => setState(() => _newsletter = v),
                className: '''
                  w-8 h-8 rounded-full
                  border-2 border-slate-300 dark:border-slate-600
                  checked:bg-emerald-500 checked:border-transparent
                ''',
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Custom Check Icon',
          description:
              'checkIcon swaps the default Icons.check. Pair with iconClassName to style.',
          child: WDiv(
            className: 'flex flex-row items-center gap-3',
            children: [
              WCheckbox(
                value: _danger,
                onChanged: (v) => setState(() => _danger = v),
                checkIcon: Icons.warning_amber,
                className: '''
                  w-8 h-8 rounded-md
                  border-2 border-red-300 dark:border-red-700
                  checked:bg-red-500 checked:border-transparent
                ''',
                iconClassName: 'text-white text-base',
              ),
              WText(
                'Confirm dangerous action',
                className: 'text-slate-900 dark:text-white',
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Disabled State',
          description:
              'disabled: true blocks interaction and activates the disabled: prefix.',
          child: WDiv(
            className: 'flex flex-row items-center gap-3',
            children: [
              WCheckbox(
                value: true,
                onChanged: (_) {},
                disabled: true,
                className: '''
                  w-6 h-6 rounded-md
                  border-2 border-slate-300 dark:border-slate-600
                  checked:bg-emerald-500 checked:border-transparent
                  disabled:opacity-60
                ''',
              ),
              WText(
                'Disabled (checked)',
                className: 'text-slate-500 dark:text-slate-400',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
