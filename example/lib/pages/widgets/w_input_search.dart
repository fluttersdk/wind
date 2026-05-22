import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class WInputSearchExamplePage extends StatefulWidget {
  const WInputSearchExamplePage({super.key});

  @override
  State<WInputSearchExamplePage> createState() =>
      _WInputSearchExamplePageState();
}

class _WInputSearchExamplePageState extends State<WInputSearchExamplePage> {
  String _query = '';
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Search & Adornments',
      description:
          'prefix / suffix slots accept any Widget. Pair with WIcon for search bars, password toggles, and clear buttons.',
      gradient: 'from-blue-500 to-cyan-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'WIcon as prefix; padding-left compensates for the icon overlap.',
          child: WInput(
            value: _query,
            onChanged: (v) => setState(() => _query = v),
            placeholder: 'Search…',
            prefix: WIcon(
              Icons.search,
              className: 'text-slate-400 dark:text-slate-500',
            ),
            className: '''
              w-full pl-10 pr-3 py-2 rounded-full
              bg-slate-100 dark:bg-slate-700
              border border-transparent
              focus:bg-white dark:focus:bg-slate-800
              focus:border-blue-500 focus:ring-2 focus:ring-blue-500/30
            ''',
          ),
        ),
        ExampleSection(
          title: 'Password Toggle',
          description:
              'suffix slot holds a WButton that toggles InputType.password / text.',
          child: WInput(
            type: _obscure ? InputType.password : InputType.text,
            placeholder: 'Enter password',
            suffix: WButton(
              onTap: () => setState(() => _obscure = !_obscure),
              className:
                  'p-2 rounded hover:bg-slate-100 dark:hover:bg-slate-700 duration-150',
              child: WIcon(
                _obscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                className: 'text-slate-500 dark:text-slate-400 w-5 h-5',
              ),
            ),
            className: '''
              w-full px-3 py-2 rounded-lg
              bg-white dark:bg-slate-800
              border border-slate-300 dark:border-slate-600
              focus:border-blue-500 focus:ring-2 focus:ring-blue-500/30
            ''',
          ),
        ),
        ExampleSection(
          title: 'Clear Button',
          description:
              'Show a clear button only when the field has text. Tap clears value.',
          child: WInput(
            value: _query,
            onChanged: (v) => setState(() => _query = v),
            placeholder: 'Type then clear…',
            suffix: _query.isEmpty
                ? null
                : WButton(
                    onTap: () => setState(() => _query = ''),
                    className:
                        'p-1 rounded-full hover:bg-slate-100 dark:hover:bg-slate-700',
                    child: WIcon(Icons.close,
                        className:
                            'text-slate-500 dark:text-slate-400 w-4 h-4'),
                  ),
            className: '''
              w-full px-3 py-2 rounded-lg
              bg-white dark:bg-slate-800
              border border-slate-300 dark:border-slate-600
              focus:border-blue-500 focus:ring-2 focus:ring-blue-500/30
            ''',
          ),
        ),
      ],
    );
  }
}
