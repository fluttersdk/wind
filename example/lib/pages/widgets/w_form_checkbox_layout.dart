import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class WFormCheckboxLayoutExamplePage extends StatefulWidget {
  const WFormCheckboxLayoutExamplePage({super.key});

  @override
  State<WFormCheckboxLayoutExamplePage> createState() =>
      _WFormCheckboxLayoutExamplePageState();
}

class _WFormCheckboxLayoutExamplePageState
    extends State<WFormCheckboxLayoutExamplePage> {
  bool _notifications = false;
  bool _marketing = true;
  bool _danger = false;

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Form Checkbox Layout',
      description:
          'WFormCheckbox stacks checkbox + label horizontally and hint/error below. label / labelText / hint / errorClassName all tunable.',
      gradient: 'from-emerald-500 to-green-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description: 'Checkbox + label + hint in a clean vertical stack.',
          child: WFormCheckbox(
            value: _notifications,
            onChanged: (v) => setState(() => _notifications = v),
            labelText: 'Push notifications',
            hint: 'Enable to get real-time updates on your device.',
            className: '''
              w-6 h-6 rounded-md
              border-2 border-slate-300 dark:border-slate-600
              checked:bg-emerald-600 checked:border-transparent
            ''',
          ),
        ),
        ExampleSection(
          title: 'Bold Label',
          description:
              'labelClassName lets you escalate the label to a primary heading.',
          child: WFormCheckbox(
            value: _marketing,
            onChanged: (v) => setState(() => _marketing = v),
            labelText: 'Marketing emails',
            labelClassName: 'text-lg font-bold text-slate-900 dark:text-white',
            hint: 'Occasional product news. Unsubscribe anytime.',
            hintClassName: 'text-sm text-slate-500 dark:text-slate-400 mt-1',
            className: '''
              w-6 h-6 rounded-md
              border-2 border-slate-300 dark:border-slate-600
              checked:bg-emerald-600 checked:border-transparent
            ''',
          ),
        ),
        ExampleSection(
          title: 'Custom Error Styling',
          description:
              'errorClassName takes any Wind className. Required state surfaces a bold red message.',
          child: Form(
            child: WFormCheckbox(
              value: _danger,
              onChanged: (v) => setState(() => _danger = v),
              labelText: 'Confirm I want to delete my account',
              errorClassName:
                  'text-red-600 dark:text-red-400 font-bold mt-2 italic',
              className: '''
                w-6 h-6 rounded-md
                border-2 border-red-300 dark:border-red-700
                checked:bg-red-500 checked:border-transparent
                error:border-red-500
              ''',
              autovalidateMode: AutovalidateMode.always,
              validator: (v) =>
                  v != true ? 'Please confirm before continuing' : null,
            ),
          ),
        ),
      ],
    );
  }
}
