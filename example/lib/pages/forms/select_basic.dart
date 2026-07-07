import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class SelectBasicExamplePage extends StatefulWidget {
  const SelectBasicExamplePage({super.key});

  @override
  State<SelectBasicExamplePage> createState() => _SelectBasicExamplePageState();
}

class _SelectBasicExamplePageState extends State<SelectBasicExamplePage> {
  String? _language;
  List<String> _tags = const ['flutter', 'wind'];

  static const _triggerCls = '''
    w-64 px-3 py-2 rounded-lg
    bg-white dark:bg-slate-800
    border border-slate-300 dark:border-slate-600
    hover:border-indigo-500
  ''';

  static const _menuCls = '''
    rounded-lg
    bg-white dark:bg-slate-800
    shadow-xl border border-slate-200 dark:border-slate-700
  ''';

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'WSelect',
      description:
          'Utility-first dropdown built on WPopover. Single + multi + searchable + async load + tagging: all from one widget.',
      gradient: 'from-indigo-500 to-blue-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Single-select with three static options. value + onChange for controlled state.',
          child: WSelect<String>(
            value: _language,
            options: const [
              SelectOption(value: 'dart', label: 'Dart'),
              SelectOption(value: 'flutter', label: 'Flutter'),
              SelectOption(value: 'rust', label: 'Rust'),
              SelectOption(value: 'go', label: 'Go'),
            ],
            onChange: (v) => setState(() => _language = v),
            placeholder: 'Pick a language',
            className: _triggerCls,
            menuClassName: _menuCls,
          ),
        ),
        ExampleSection(
          title: 'Searchable',
          description:
              'searchable: true adds a filter input above the option list.',
          child: WSelect<String>(
            value: _language,
            searchable: true,
            searchPlaceholder: 'Filter languages…',
            options: const [
              SelectOption(value: 'dart', label: 'Dart'),
              SelectOption(value: 'flutter', label: 'Flutter'),
              SelectOption(value: 'rust', label: 'Rust'),
              SelectOption(value: 'go', label: 'Go'),
              SelectOption(value: 'kotlin', label: 'Kotlin'),
              SelectOption(value: 'swift', label: 'Swift'),
              SelectOption(value: 'typescript', label: 'TypeScript'),
            ],
            onChange: (v) => setState(() => _language = v),
            placeholder: 'Pick a language',
            className: _triggerCls,
            menuClassName: _menuCls,
          ),
        ),
        ExampleSection(
          title: 'Multi-Select',
          description:
              'isMulti: true switches to chips. values + onMultiChange for controlled state.',
          child: WSelect<String>(
            isMulti: true,
            values: _tags,
            options: const [
              SelectOption(value: 'flutter', label: 'Flutter'),
              SelectOption(value: 'wind', label: 'Wind'),
              SelectOption(value: 'dart', label: 'Dart'),
              SelectOption(value: 'firebase', label: 'Firebase'),
              SelectOption(value: 'supabase', label: 'Supabase'),
            ],
            onMultiChange: (list) => setState(() => _tags = list),
            placeholder: 'Pick tags',
            className: _triggerCls,
            menuClassName: _menuCls,
          ),
        ),
        ExampleSection(
          title: 'Disabled',
          description:
              'disabled: true blocks the trigger. Activates disabled: prefix.',
          child: WSelect<String>(
            value: 'dart',
            disabled: true,
            options: const [SelectOption(value: 'dart', label: 'Dart')],
            onChange: (_) {},
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
