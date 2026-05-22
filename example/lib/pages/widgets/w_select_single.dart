import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class WSelectSingleExamplePage extends StatefulWidget {
  const WSelectSingleExamplePage({super.key});

  @override
  State<WSelectSingleExamplePage> createState() =>
      _WSelectSingleExamplePageState();
}

class _WSelectSingleExamplePageState extends State<WSelectSingleExamplePage> {
  String? _fruit;
  String? _country;

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Single-Select',
      description:
          'Default mode of WSelect. Pick one value from a list. Pair searchable: true with longer lists for filtering.',
      gradient: 'from-indigo-500 to-blue-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Three options. The trigger displays the selected label or placeholder.',
          child: WSelect<String>(
            value: _fruit,
            options: const [
              SelectOption(value: 'apple', label: 'Apple'),
              SelectOption(value: 'banana', label: 'Banana'),
              SelectOption(value: 'cherry', label: 'Cherry'),
            ],
            onChange: (v) => setState(() => _fruit = v),
            placeholder: 'Pick a fruit',
            className: '''
              w-64 px-3 py-2 rounded-lg
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
          title: 'Searchable',
          description:
              'searchable: true adds a filter input on top of the list. searchPlaceholder customizes the prompt.',
          child: WSelect<String>(
            value: _country,
            searchable: true,
            searchPlaceholder: 'Search countries…',
            options: const [
              SelectOption(value: 'tr', label: 'Türkiye'),
              SelectOption(value: 'us', label: 'United States'),
              SelectOption(value: 'de', label: 'Germany'),
              SelectOption(value: 'fr', label: 'France'),
              SelectOption(value: 'jp', label: 'Japan'),
              SelectOption(value: 'br', label: 'Brazil'),
              SelectOption(value: 'in', label: 'India'),
              SelectOption(value: 'au', label: 'Australia'),
            ],
            onChange: (v) => setState(() => _country = v),
            placeholder: 'Pick a country',
            className: '''
              w-64 px-3 py-2 rounded-lg
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
      ],
    );
  }
}
