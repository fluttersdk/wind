import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class WSelectMultiExamplePage extends StatefulWidget {
  const WSelectMultiExamplePage({super.key});

  @override
  State<WSelectMultiExamplePage> createState() =>
      _WSelectMultiExamplePageState();
}

class _WSelectMultiExamplePageState extends State<WSelectMultiExamplePage> {
  List<String> _colors = const ['red', 'blue'];
  List<String> _tags = const [];

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Multi-Select',
      description:
          'isMulti: true turns WSelect into a chip-based multi picker. values + onMultiChange for controlled state.',
      gradient: 'from-indigo-500 to-blue-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Selected items render as removable chips inside the trigger.',
          child: WSelect<String>(
            isMulti: true,
            values: _colors,
            options: const [
              SelectOption(value: 'red', label: 'Red'),
              SelectOption(value: 'blue', label: 'Blue'),
              SelectOption(value: 'green', label: 'Green'),
              SelectOption(value: 'amber', label: 'Amber'),
              SelectOption(value: 'purple', label: 'Purple'),
            ],
            onMultiChange: (list) => setState(() => _colors = list),
            placeholder: 'Pick colors',
            className: '''
              w-80 px-3 py-2 rounded-lg
              bg-white dark:bg-slate-800
              border border-slate-300 dark:border-slate-600
              hover:border-indigo-500
            ''',
            menuClassName: '''
              rounded-lg
              bg-white dark:bg-slate-800
              shadow-xl border border-slate-200 dark:border-slate-700
            ''',
          ),
        ),
        ExampleSection(
          title: 'Searchable Multi',
          description:
              'Combine isMulti + searchable for tag pickers with many options.',
          child: WSelect<String>(
            isMulti: true,
            searchable: true,
            searchPlaceholder: 'Search tags…',
            values: _tags,
            options: const [
              SelectOption(value: 'flutter', label: 'Flutter'),
              SelectOption(value: 'wind', label: 'Wind'),
              SelectOption(value: 'dart', label: 'Dart'),
              SelectOption(value: 'firebase', label: 'Firebase'),
              SelectOption(value: 'supabase', label: 'Supabase'),
              SelectOption(value: 'graphql', label: 'GraphQL'),
              SelectOption(value: 'sqlite', label: 'SQLite'),
              SelectOption(value: 'mqtt', label: 'MQTT'),
            ],
            onMultiChange: (list) => setState(() => _tags = list),
            placeholder: 'Pick tags',
            className: '''
              w-80 px-3 py-2 rounded-lg
              bg-white dark:bg-slate-800
              border border-slate-300 dark:border-slate-600
              hover:border-indigo-500
            ''',
            menuClassName: '''
              rounded-lg
              bg-white dark:bg-slate-800
              shadow-xl border border-slate-200 dark:border-slate-700
            ''',
          ),
        ),
        ExampleSection(
          title: 'Selected Snapshot',
          description: 'Live list of currently selected values.',
          child: WDiv(
            className: '''
              flex flex-col gap-1 p-3 rounded
              bg-slate-50 dark:bg-slate-700/40
            ''',
            children: [
              WText(
                'colors: ${_colors.join(", ")}',
                className:
                    'font-mono text-sm text-slate-700 dark:text-slate-200',
              ),
              WText(
                'tags: ${_tags.isEmpty ? "—" : _tags.join(", ")}',
                className:
                    'font-mono text-sm text-slate-700 dark:text-slate-200',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
