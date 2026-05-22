import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class WDynamicBasicExamplePage extends StatefulWidget {
  const WDynamicBasicExamplePage({super.key});

  @override
  State<WDynamicBasicExamplePage> createState() =>
      _WDynamicBasicExamplePageState();
}

class _WDynamicBasicExamplePageState extends State<WDynamicBasicExamplePage> {
  String _lastAction = '—';

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'WDynamic',
      description:
          'Render a widget tree from a JSON Map at runtime. type + props + children schema, action map for callbacks, whitelist for safety.',
      gradient: 'from-fuchsia-500 to-purple-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'JSON Map describes the tree; WDynamic instantiates the live widgets.',
          child: WDynamic(
            json: const {
              'type': 'WDiv',
              'props': {
                'className':
                    'p-6 rounded-xl bg-white dark:bg-slate-800 shadow-sm border border-slate-200 dark:border-slate-700',
              },
              'children': [
                {
                  'type': 'WText',
                  'props': {
                    'text': 'Hello from JSON!',
                    'className':
                        'text-xl font-bold text-gray-800 dark:text-white',
                  },
                },
                {
                  'type': 'WText',
                  'props': {
                    'text':
                        'This entire card was instantiated from a Map<String, dynamic>.',
                    'className':
                        'text-sm text-slate-600 dark:text-slate-400 mt-1',
                  },
                },
              ],
            },
          ),
        ),
        ExampleSection(
          title: 'Action System',
          description:
              'onTap references a named handler in the actions map. Tap the JSON button to fire it.',
          child: WDiv(
            className: 'flex flex-col gap-3',
            children: [
              WDynamic(
                json: const {
                  'type': 'WButton',
                  'props': {
                    'className':
                        'bg-fuchsia-600 hover:bg-fuchsia-700 text-white px-4 py-2 rounded self-start',
                    'onTap': {
                      'action': 'recordTap',
                      'args': {'source': 'json-button'},
                    },
                  },
                  'children': [
                    {
                      'type': 'WText',
                      'props': {
                        'text': 'Tap me (defined in JSON)',
                        'className': 'text-white font-medium',
                      },
                    },
                  ],
                },
                actions: {
                  'recordTap': (Map<String, dynamic> args) {
                    setState(() {
                      _lastAction =
                          'recordTap fired with args=${args.toString()}';
                    });
                  },
                },
              ),
              WDiv(
                className: '''
                  px-3 py-2 rounded font-mono text-xs
                  bg-slate-100 dark:bg-slate-700
                  text-slate-700 dark:text-slate-300
                ''',
                child: WText('Last action: $_lastAction'),
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Form State (id auto-track)',
          description:
              'Widgets with an id auto-register in a shared store. Read state inside action handlers.',
          child: WDynamic(
            json: const {
              'type': 'WDiv',
              'props': {'className': 'flex flex-col gap-3'},
              'children': [
                {
                  'type': 'WInput',
                  'props': {
                    'id': 'username',
                    'placeholder': 'Type your name…',
                    'className':
                        'px-3 py-2 rounded border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-800 focus:ring-2 focus:ring-fuchsia-500/30',
                  },
                },
                {
                  'type': 'WButton',
                  'props': {
                    'className':
                        'bg-fuchsia-600 hover:bg-fuchsia-700 text-white px-4 py-2 rounded self-start',
                    'onTap': {'action': 'greet'},
                  },
                  'children': [
                    {
                      'type': 'WText',
                      'props': {
                        'text': 'Greet me',
                        'className': 'text-white font-medium',
                      },
                    },
                  ],
                },
              ],
            },
            actions: {
              'greet': (args, state) {
                final name = (state.get('username') as String?) ?? 'Guest';
                setState(() => _lastAction = 'Hello, $name!');
              },
            },
          ),
        ),
        ExampleSection(
          title: 'Custom Widget Builders',
          description:
              'Register builders for type names not in the whitelist. Custom widgets bypass the security whitelist.',
          child: WDynamic(
            json: const {
              'type': 'InfoCard',
              'props': {
                'title': 'Server-driven UI',
                'subtitle': 'This card is a custom builder',
              },
            },
            builders: {
              'InfoCard': (Map<String, dynamic> props, List<Widget> children) {
                return WDiv(
                  className: '''
                    flex items-center gap-3 p-4 rounded-xl
                    bg-fuchsia-50 dark:bg-fuchsia-900/30
                    border border-fuchsia-200 dark:border-fuchsia-800
                  ''',
                  children: [
                    WIcon(Icons.info,
                        className:
                            'text-fuchsia-600 dark:text-fuchsia-400 w-6 h-6'),
                    WDiv(
                      className: 'flex flex-col flex-1',
                      children: [
                        WText(
                          (props['title'] ?? '').toString(),
                          className:
                              'font-bold text-fuchsia-800 dark:text-fuchsia-200',
                        ),
                        WText(
                          (props['subtitle'] ?? '').toString(),
                          className:
                              'text-sm text-fuchsia-700 dark:text-fuchsia-300',
                        ),
                      ],
                    ),
                  ],
                );
              },
            },
          ),
        ),
      ],
    );
  }
}
