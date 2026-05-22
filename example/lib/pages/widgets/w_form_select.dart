import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class WFormSelectExamplePage extends StatefulWidget {
  const WFormSelectExamplePage({super.key});

  @override
  State<WFormSelectExamplePage> createState() => _WFormSelectExamplePageState();
}

class _WFormSelectExamplePageState extends State<WFormSelectExamplePage> {
  final _formKey = GlobalKey<FormState>();
  String? _country;
  String? _saved;

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
      title: 'WFormSelect',
      description:
          'FormField-wrapped WSelect. Validates against the active value; error: prefix activates on failure. Same options API as WSelect.',
      gradient: 'from-indigo-500 to-blue-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Required country picker inside a Form. Validates on submit.',
          child: Form(
            key: _formKey,
            child: WDiv(
              className: 'flex flex-col gap-4',
              children: [
                WFormSelect<String>(
                  label: 'Country',
                  placeholder: 'Pick a country',
                  value: _country,
                  options: const [
                    SelectOption(value: 'us', label: 'United States'),
                    SelectOption(value: 'tr', label: 'Türkiye'),
                    SelectOption(value: 'de', label: 'Germany'),
                    SelectOption(value: 'fr', label: 'France'),
                    SelectOption(value: 'jp', label: 'Japan'),
                  ],
                  onChange: (v) => setState(() => _country = v),
                  onSaved: (v) => setState(() => _saved = v),
                  className: _triggerCls,
                  menuClassName: _menuCls,
                  validator: (v) =>
                      v == null ? 'Please select a country' : null,
                ),
                WButton(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                    }
                  },
                  className: '''
                    bg-indigo-600 hover:bg-indigo-700
                    text-white px-4 py-2 rounded-lg self-start
                  ''',
                  child: const WText('Submit',
                      className: 'text-white font-medium'),
                ),
                WText(
                  'Saved: ${_saved ?? "—"}',
                  className:
                      'font-mono text-sm text-slate-500 dark:text-slate-400',
                ),
              ],
            ),
          ),
        ),
        ExampleSection(
          title: 'Searchable',
          description:
              'searchable: true adds an inline filter input. Inherits the same form validation.',
          child: Form(
            child: WFormSelect<String>(
              label: 'Programming Language',
              placeholder: 'Search…',
              searchable: true,
              searchPlaceholder: 'Filter…',
              options: const [
                SelectOption(value: 'dart', label: 'Dart'),
                SelectOption(value: 'flutter', label: 'Flutter'),
                SelectOption(value: 'kotlin', label: 'Kotlin'),
                SelectOption(value: 'swift', label: 'Swift'),
                SelectOption(value: 'rust', label: 'Rust'),
                SelectOption(value: 'go', label: 'Go'),
                SelectOption(value: 'typescript', label: 'TypeScript'),
              ],
              className: _triggerCls,
              menuClassName: _menuCls,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (v) => v == null ? 'Required' : null,
            ),
          ),
        ),
      ],
    );
  }
}
