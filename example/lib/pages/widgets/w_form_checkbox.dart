import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class WFormCheckboxExamplePage extends StatefulWidget {
  const WFormCheckboxExamplePage({super.key});

  @override
  State<WFormCheckboxExamplePage> createState() =>
      _WFormCheckboxExamplePageState();
}

class _WFormCheckboxExamplePageState extends State<WFormCheckboxExamplePage> {
  final _formKey = GlobalKey<FormState>();
  bool _terms = false;
  bool _newsletter = true;

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'WFormCheckbox',
      description:
          'FormField-wrapped WCheckbox. validator receives the bool value; error: prefix activates on failure.',
      gradient: 'from-emerald-500 to-green-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Required terms checkbox. Submitting without checking shows the error message.',
          child: Form(
            key: _formKey,
            child: WDiv(
              className: 'flex flex-col gap-4',
              children: [
                WFormCheckbox(
                  value: _terms,
                  onChanged: (v) => setState(() => _terms = v),
                  labelText: 'I agree to the Terms of Service',
                  className: '''
                    w-5 h-5 rounded-md
                    border-2 border-slate-300 dark:border-slate-600
                    checked:bg-emerald-600 checked:border-transparent
                    error:border-red-500
                  ''',
                  validator: (v) =>
                      v != true ? 'You must agree to continue' : null,
                ),
                WButton(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Form submitted'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  className: '''
                    bg-emerald-600 hover:bg-emerald-700
                    text-white px-4 py-2 rounded-lg self-start
                  ''',
                  child: const WText('Submit',
                      className: 'text-white font-medium'),
                ),
              ],
            ),
          ),
        ),
        ExampleSection(
          title: 'Custom Icon + Colors',
          description:
              'checkIcon swaps the default tick. iconClassName styles the icon itself.',
          child: WFormCheckbox(
            value: _newsletter,
            onChanged: (v) => setState(() => _newsletter = v),
            labelText: 'Subscribe to weekly newsletter',
            checkIcon: Icons.mark_email_read_outlined,
            className: '''
              w-7 h-7 rounded-full
              border-2 border-pink-300 dark:border-pink-700
              checked:bg-pink-500 checked:border-transparent
            ''',
            iconClassName: 'text-white text-sm',
            labelClassName:
                'text-base font-medium text-slate-900 dark:text-white',
          ),
        ),
      ],
    );
  }
}
