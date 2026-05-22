import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class WFormMultiSelectExamplePage extends StatefulWidget {
  const WFormMultiSelectExamplePage({super.key});

  @override
  State<WFormMultiSelectExamplePage> createState() =>
      _WFormMultiSelectExamplePageState();
}

class _WFormMultiSelectExamplePageState
    extends State<WFormMultiSelectExamplePage> {
  final _formKey = GlobalKey<FormState>();
  List<String> _interests = const [];

  static const _triggerCls = '''
    w-full px-3 py-2 rounded-lg
    bg-white dark:bg-slate-800
    border border-slate-300 dark:border-slate-600
    hover:border-indigo-500
    error:border-red-500 error:ring-2 error:ring-red-500/30
  ''';

  static const _menuCls = '''
    rounded-lg
    bg-white dark:bg-slate-800
    shadow-xl border border-slate-200 dark:border-slate-700
  ''';

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'WFormMultiSelect',
      description:
          'Multi-value variant of WFormSelect. values: List<T>; validator receives the list. Selected values render as removable chips.',
      gradient: 'from-indigo-500 to-blue-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Pick at least one interest. Validator runs against the selected list.',
          child: Form(
            key: _formKey,
            child: WDiv(
              className: 'flex flex-col gap-4',
              children: [
                WFormMultiSelect<String>(
                  label: 'Interests',
                  values: _interests,
                  placeholder: 'Choose interests',
                  options: const [
                    SelectOption(value: 'flutter', label: 'Flutter'),
                    SelectOption(value: 'wind', label: 'Wind'),
                    SelectOption(value: 'dart', label: 'Dart'),
                    SelectOption(value: 'react', label: 'React'),
                    SelectOption(value: 'rust', label: 'Rust'),
                  ],
                  onMultiChange: (list) => setState(() => _interests = list),
                  className: _triggerCls,
                  menuClassName: _menuCls,
                  validator: (vs) =>
                      (vs == null || vs.isEmpty) ? 'Pick at least one' : null,
                ),
                WButton(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Selected: ${_interests.join(", ")}',
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  className: '''
                    bg-indigo-600 hover:bg-indigo-700
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
          title: 'Min Selection',
          description:
              'Validate against length. Auto-validate mode shows the error as soon as the user opens and closes the menu.',
          child: Form(
            child: WFormMultiSelect<String>(
              label: 'Skills (pick at least 2)',
              hint: 'Required for the engineering profile.',
              options: const [
                SelectOption(value: 'js', label: 'JavaScript'),
                SelectOption(value: 'ts', label: 'TypeScript'),
                SelectOption(value: 'py', label: 'Python'),
                SelectOption(value: 'go', label: 'Go'),
                SelectOption(value: 'rust', label: 'Rust'),
              ],
              className: _triggerCls,
              menuClassName: _menuCls,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (vs) {
                if (vs == null || vs.length < 2) return 'Pick at least 2';
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }
}
