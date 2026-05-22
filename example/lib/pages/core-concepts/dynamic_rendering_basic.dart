import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class DynamicRenderingBasicExamplePage extends StatefulWidget {
  const DynamicRenderingBasicExamplePage({super.key});

  @override
  State<DynamicRenderingBasicExamplePage> createState() =>
      _DynamicRenderingBasicExamplePageState();
}

class _DynamicRenderingBasicExamplePageState
    extends State<DynamicRenderingBasicExamplePage> {
  String _lastAction = '—';

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Dynamic Rendering',
      description:
          'Render Flutter widget trees from JSON at runtime via WDynamic. Server-driven UI, A/B layouts, white-label apps from a single binary.',
      gradient: 'from-fuchsia-500 to-purple-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Pass a JSON map to WDynamic. Every Wind utility, dark mode prefix, and state modifier works exactly like it does in static Dart.',
          child: WDynamic(
            json: {
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
                        'This entire card came from a Map<String, dynamic>.',
                    'className': 'text-sm text-slate-600 dark:text-slate-400',
                  },
                },
              ],
            },
          ),
        ),
        ExampleSection(
          title: 'JSON Schema',
          description:
              'Three keys: type names the widget, props maps to constructor parameters, children nests subtrees.',
          child: _CodeBlock(
            code: '{\n'
                '  "type": "WidgetType",\n'
                '  "props": { /* className, text, id, onTap, ... */ },\n'
                '  "children": [ /* nested widgets */ ]\n'
                '}',
          ),
        ),
        ExampleSection(
          title: 'Action System',
          description:
              'Interactive widgets reference named handlers. Tap the JSON button below; the handler updates Dart state.',
          child: WDiv(
            className: 'flex flex-col gap-3',
            children: [
              WDynamic(
                json: {
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
          title: 'Form State Management',
          description:
              'Widgets with an id automatically register their value in a shared store. Read it inside any action handler.',
          child: WDynamic(
            json: {
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
          title: 'Security & Whitelisting',
          description:
              'Only widgets on the default whitelist render. Use denyWidgets to remove types from the allow list at runtime.',
          child: _CodeBlock(
            code: 'WDynamic(\n'
                '  json: untrustedJson,\n'
                '  denyWidgets: {"WButton", "Stack"},\n'
                ')',
          ),
        ),
        ExampleSection(
          title: 'Custom Widget Builders',
          description:
              'Register a builder under any type name. The closure receives parsed props and resolved children.',
          child: _CodeBlock(
            code: 'WDynamic(\n'
                '  json: {"type": "ProfileCard", "props": {"name": "Alice"}},\n'
                '  builders: {\n'
                '    "ProfileCard": (props, children) {\n'
                '      return WDiv(\n'
                '        className: "p-4 bg-white rounded-lg",\n'
                '        child: WText(props["name"] ?? ""),\n'
                '      );\n'
                '    },\n'
                '  },\n'
                ')',
          ),
        ),
        ExampleSection(
          title: 'Error Handling',
          description:
              'Unknown types and build exceptions fall through to optional callbacks. maxDepth guards against runaway recursion.',
          child: _CodeBlock(
            code: 'WDynamic(\n'
                '  json: myJson,\n'
                '  maxDepth: 100,\n'
                '  onUnknownWidget: (type, props) => WText("Unknown: \$type"),\n'
                '  onError: (type, error) => WText("Error: \$error"),\n'
                ')',
          ),
        ),
      ],
    );
  }
}

class _CodeBlock extends StatelessWidget {
  final String code;

  const _CodeBlock({required this.code});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: '''
        p-4 rounded-lg font-mono text-xs
        bg-slate-900 dark:bg-slate-950
        text-emerald-400
        overflow-x-auto
      ''',
      child: WText(
        code,
        className: 'whitespace-pre text-emerald-400',
      ),
    );
  }
}
