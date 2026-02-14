import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class WDynamicBasicExamplePage extends StatefulWidget {
  const WDynamicBasicExamplePage({super.key});

  @override
  State<WDynamicBasicExamplePage> createState() =>
      _WDynamicBasicExamplePageState();
}

class _WDynamicBasicExamplePageState extends State<WDynamicBasicExamplePage> {
  int _tapCount = 0;
  String _greeting = '';
  WDynamicController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = WDynamicController();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className:
          'w-full h-full overflow-y-auto p-4 bg-gray-50 dark:bg-gray-900',
      scrollPrimary: true,
      child: WDiv(
        className: 'flex flex-col gap-6 max-w-4xl mx-auto',
        children: [
          _buildHeader(),
          _buildSection(
            title: 'Basic Layout',
            description: 'Simple static JSON rendering',
            child: WDynamic(
              json: const {
                'type': 'WDiv',
                'props': {
                  'className':
                      'p-6 bg-white dark:bg-slate-800 rounded-xl shadow-sm'
                },
                'children': [
                  {
                    'type': 'WText',
                    'props': {
                      'text': 'Hello from JSON!',
                      'className':
                          'text-xl font-bold text-gray-800 dark:text-white'
                    }
                  },
                  {
                    'type': 'WText',
                    'props': {
                      'text':
                          'This entire UI is rendered from a Map/JSON structure.',
                      'className':
                          'text-sm text-gray-500 dark:text-gray-400 mt-2'
                    }
                  },
                ],
              },
            ),
          ),
          _buildSection(
            title: 'Nested Layout with Icons',
            description: 'Shows flex layout with icons',
            child: WDynamic(
              json: const {
                'type': 'WDiv',
                'props': {
                  'className':
                      'flex flex-col gap-3 p-4 bg-white dark:bg-slate-800 rounded-xl shadow-sm'
                },
                'children': [
                  {
                    'type': 'WDiv',
                    'props': {'className': 'flex items-center gap-3'},
                    'children': [
                      {
                        'type': 'WIcon',
                        'props': {
                          'icon': 'star',
                          'className': 'text-yellow-500 text-2xl'
                        }
                      },
                      {
                        'type': 'WText',
                        'props': {
                          'text': 'Featured Item',
                          'className':
                              'font-semibold text-gray-800 dark:text-white'
                        }
                      },
                    ],
                  },
                  {
                    'type': 'WDiv',
                    'props': {'className': 'flex items-center gap-3'},
                    'children': [
                      {
                        'type': 'WIcon',
                        'props': {
                          'icon': 'check',
                          'className': 'text-green-500 text-2xl'
                        }
                      },
                      {
                        'type': 'WText',
                        'props': {
                          'text': 'Completed Task',
                          'className':
                              'font-semibold text-gray-800 dark:text-white'
                        }
                      },
                    ],
                  },
                  {
                    'type': 'WDiv',
                    'props': {'className': 'flex items-center gap-3'},
                    'children': [
                      {
                        'type': 'WIcon',
                        'props': {
                          'icon': 'info',
                          'className': 'text-blue-500 text-2xl'
                        }
                      },
                      {
                        'type': 'WText',
                        'props': {
                          'text': 'Information Notice',
                          'className':
                              'font-semibold text-gray-800 dark:text-white'
                        }
                      },
                    ],
                  },
                ],
              },
            ),
          ),
          _buildSection(
            title: 'Actions & Events',
            description: 'Shows button with action handler',
            child: WDiv(
              className:
                  'flex flex-col gap-4 p-4 bg-white dark:bg-slate-800 rounded-xl shadow-sm',
              children: [
                WDynamic(
                  json: const {
                    'type': 'WButton',
                    'props': {
                      'className':
                          'bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded-lg',
                      'onTap': {'action': 'increment'},
                    },
                    'children': [
                      {
                        'type': 'WText',
                        'props': {'text': 'Tap Me!'}
                      }
                    ],
                  },
                  actions: {
                    'increment':
                        (Map<String, dynamic> args, WDynamicState state) {
                      setState(() => _tapCount++);
                    },
                  },
                ),
                WText(
                  'Button tapped $_tapCount times',
                  className: 'text-gray-600 dark:text-gray-400 text-center',
                ),
              ],
            ),
          ),
          _buildSection(
            title: 'Form State Management',
            description: 'Shows input with auto state tracking via controller',
            child: WDiv(
              className: 'flex flex-col gap-4',
              children: [
                WDynamic(
                  json: const {
                    'type': 'WDiv',
                    'props': {
                      'className':
                          'flex flex-col gap-4 p-4 bg-white dark:bg-slate-800 rounded-xl shadow-sm'
                    },
                    'children': [
                      {
                        'type': 'WInput',
                        'props': {
                          'id': 'username',
                          'placeholder': 'Enter your name...',
                          'className':
                              'border border-gray-300 dark:border-gray-600 rounded-lg',
                        },
                      },
                      {
                        'type': 'WButton',
                        'props': {
                          'className':
                              'bg-green-500 hover:bg-green-600 text-white px-4 py-2 rounded-lg',
                          'onTap': {'action': 'greet'},
                        },
                        'children': [
                          {
                            'type': 'WText',
                            'props': {'text': 'Greet'}
                          }
                        ],
                      },
                    ],
                  },
                  controller: _controller,
                  actions: {
                    'greet': (Map<String, dynamic> args, WDynamicState state) {
                      final name = state.get('username') ?? 'World';
                      setState(() => _greeting = 'Hello, $name!');
                    },
                  },
                ),
                if (_greeting.isNotEmpty)
                  WText(
                    _greeting,
                    className:
                        'text-lg font-semibold text-green-600 dark:text-green-400 text-center mt-2',
                  ),
              ],
            ),
          ),
          _buildSection(
            title: 'Custom Widget Builders',
            description: 'Shows extending with custom builders',
            child: WDynamic(
              json: const {
                'type': 'InfoCard',
                'props': {
                  'title': 'Custom Widget',
                  'subtitle': 'Built with a custom builder'
                },
              },
              builders: {
                'InfoCard':
                    (Map<String, dynamic> props, List<Widget> children) {
                  return WDiv(
                    className:
                        'p-4 bg-gradient-to-r from-indigo-50 to-purple-50 dark:from-indigo-900/30 dark:to-purple-900/30 rounded-xl border border-indigo-200 dark:border-indigo-700',
                    child: WDiv(
                      className: 'flex items-center gap-3',
                      children: [
                        WIcon(Icons.extension,
                            className: 'text-indigo-500 text-2xl'),
                        WDiv(
                          className: 'flex flex-col',
                          children: [
                            WText(props['title'] ?? '',
                                className:
                                    'font-bold text-indigo-800 dark:text-indigo-200'),
                            WText(props['subtitle'] ?? '',
                                className:
                                    'text-sm text-indigo-600 dark:text-indigo-400'),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              },
            ),
          ),
          _buildSection(
            title: 'Quick Reference',
            description: 'JSON schema overview',
            child: WDiv(
              className:
                  'p-6 bg-white dark:bg-slate-800 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700',
              child: WDiv(
                className: 'flex flex-col gap-3',
                children: [
                  _buildReferenceRow(
                      'type', 'Widget type (WDiv, WText, WButton...)'),
                  _buildReferenceRow(
                      'props', 'Widget properties (className, text, onTap...)'),
                  _buildReferenceRow('children', 'Nested widget array'),
                  _buildReferenceRow('id', 'Auto-tracked form state key'),
                  _buildReferenceRow(
                      'onTap', '{"action": "name", "args": {...}}'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className:
          'bg-gradient-to-r from-violet-500 to-purple-600 rounded-xl p-6 shadow-lg',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WText(
            'WDynamic - Server Driven UI',
            className: 'text-2xl font-bold text-white mb-2',
          ),
          WText(
            'Render Flutter widget trees from JSON configuration with actions and state management.',
            className: 'text-violet-50',
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String description,
    required Widget child,
  }) {
    return WDiv(
      className: 'flex flex-col gap-4',
      children: [
        WDiv(
          className: 'flex flex-col',
          children: [
            WText(title,
                className:
                    'text-lg font-semibold text-slate-900 dark:text-white'),
            WText(description,
                className: 'text-sm text-slate-600 dark:text-slate-400'),
          ],
        ),
        child,
      ],
    );
  }

  Widget _buildReferenceRow(String key, String description) {
    return WDiv(
      className: 'flex gap-4',
      children: [
        WText(
          key,
          className:
              'font-mono text-sm font-semibold text-violet-600 dark:text-violet-400 w-24',
        ),
        WText(
          '→',
          className: 'text-gray-400',
        ),
        WText(
          description,
          className: 'flex-1 text-sm text-gray-600 dark:text-gray-400',
        ),
      ],
    );
  }
}
