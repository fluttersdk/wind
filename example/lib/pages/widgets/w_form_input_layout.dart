import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class WFormInputLayoutExamplePage extends StatelessWidget {
  const WFormInputLayoutExamplePage({super.key});

  static const _inputCls = '''
    w-full px-3 py-2 rounded-lg
    bg-white dark:bg-slate-800
    border border-slate-300 dark:border-slate-600
    focus:border-blue-500 focus:ring-2 focus:ring-blue-500/30
    error:border-red-500 error:ring-2 error:ring-red-500/30
  ''';

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Form Input Layout',
      description:
          'WFormInput stacks label + input + (hint or error) vertically. Each slot has its own className for fine-tuning.',
      gradient: 'from-blue-500 to-cyan-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Label above, hint below. The hint is hidden when an error is present.',
          child: WFormInput(
            label: 'Account Number',
            placeholder: '12 digits',
            hint: 'Found on the back of your statement.',
            className: _inputCls,
          ),
        ),
        ExampleSection(
          title: 'Custom Label & Error',
          description:
              'labelClassName and errorClassName override the defaults for tighter visual control.',
          child: WFormInput(
            label: 'Password',
            type: InputType.password,
            labelClassName:
                'text-xs uppercase tracking-wider font-bold text-slate-700 dark:text-slate-300 mb-2',
            className: _inputCls,
            errorClassName:
                'text-red-600 dark:text-red-400 font-bold italic mt-2',
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (v) =>
                v == null || v.length < 8 ? 'Password too short' : null,
          ),
        ),
        ExampleSection(
          title: 'Hide Error String',
          description:
              'showError: false keeps the error: prefix active on the input but suppresses the message text — useful when you render your own.',
          child: WFormInput(
            label: 'Email',
            placeholder: 'you@example.com',
            showError: false,
            className: _inputCls,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (v) =>
                (v == null || !v.contains('@')) ? 'Invalid' : null,
          ),
        ),
      ],
    );
  }
}
