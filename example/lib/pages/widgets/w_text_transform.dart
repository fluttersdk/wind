import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class WTextTransformExamplePage extends StatelessWidget {
  const WTextTransformExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className:
          'w-full h-full overflow-y-auto p-4 bg-gray-50 dark:bg-gray-900',
      scrollPrimary: true,
      child: WDiv(
        className: 'flex flex-col gap-6 max-w-4xl mx-auto pb-12',
        children: [
          _buildHeader(),
          _buildSection(
            title: 'Case Transformation',
            description: 'Utilities for controlling text capitalization',
            child: WDiv(
              className: 'grid gap-4',
              children: [
                _buildTransformDemo(
                  'uppercase',
                  'Transforms text to uppercase',
                  'the quick brown fox',
                ),
                _buildTransformDemo(
                  'lowercase',
                  'Transforms text to lowercase',
                  'The Quick Brown Fox',
                ),
                _buildTransformDemo(
                  'capitalize',
                  'Capitalizes the first letter of each word',
                  'the quick brown fox',
                ),
                _buildTransformDemo(
                  'normal-case',
                  'Preserves original casing',
                  'The Quick Brown Fox',
                ),
              ],
            ),
          ),
          _buildSection(
            title: 'Interactive Preview',
            description: 'See how transforms affect your text in real-time',
            child: const _TransformPlayground(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className:
          'bg-gradient-to-r from-emerald-500 to-teal-600 rounded-xl p-8 shadow-lg',
      children: [
        WText(
          'Text Transform',
          className: 'text-3xl font-bold text-white mb-2',
        ),
        WText(
          'Utilities for controlling the capitalization of text.',
          className: 'text-emerald-50 text-lg max-w-2xl leading-relaxed',
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required String description,
    required Widget child,
  }) {
    return WDiv(
      className:
          'flex flex-col p-6 bg-white dark:bg-gray-800 rounded-xl shadow-sm border border-gray-100 dark:border-gray-700',
      children: [
        WText(title,
            className: 'text-xl font-bold text-gray-900 dark:text-white mb-1'),
        WText(description,
            className: 'text-sm text-gray-500 dark:text-gray-400 mb-6'),
        child,
      ],
    );
  }

  Widget _buildTransformDemo(
      String className, String description, String sampleText) {
    return WDiv(
      className:
          'flex flex-col md:flex-row md:items-center gap-4 p-4 bg-gray-50 dark:bg-gray-900/50 rounded-lg border border-gray-200 dark:border-gray-700',
      children: [
        WDiv(
          className: 'flex flex-col w-48 shrink-0',
          children: [
            WText(className,
                className:
                    'font-mono text-sm font-bold text-purple-600 dark:text-purple-400'),
            WText(description, className: 'text-xs text-gray-500'),
          ],
        ),
        WDiv(
          className: 'flex-1',
          child: WText(
            sampleText,
            className:
                '$className text-lg font-medium text-gray-900 dark:text-white',
          ),
        ),
        WDiv(
          className: 'hidden md:block',
          child: WText(
            'Original: "$sampleText"',
            className: 'text-xs text-gray-400 font-mono',
          ),
        ),
      ],
    );
  }
}

class _TransformPlayground extends StatefulWidget {
  const _TransformPlayground();

  @override
  State<_TransformPlayground> createState() => _TransformPlaygroundState();
}

class _TransformPlaygroundState extends State<_TransformPlayground> {
  String _selectedTransform = 'uppercase';
  String _text = 'Type something here...';

  final List<String> _transforms = [
    'uppercase',
    'lowercase',
    'capitalize',
    'normal-case'
  ];

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'flex flex-col gap-6',
      children: [
        WDiv(
          className: 'flex flex-col gap-2',
          children: [
            WText('1. Choose a transform',
                className:
                    'text-sm font-bold text-gray-700 dark:text-gray-300'),
            WDiv(
              className: 'flex flex-wrap gap-2',
              children: _transforms
                  .map((t) => WButton(
                        onTap: () => setState(() => _selectedTransform = t),
                        className:
                            'px-4 py-2 rounded-lg border transition-all ${_selectedTransform == t ? 'bg-emerald-100 border-emerald-500 text-emerald-700 dark:bg-emerald-900/30 dark:border-emerald-500 dark:text-emerald-300' : 'bg-white border-gray-200 text-gray-600 hover:border-gray-300 dark:bg-gray-800 dark:border-gray-700 dark:text-gray-400'}',
                        child: WText(t, className: 'font-medium'),
                      ))
                  .toList(),
            ),
          ],
        ),
        WDiv(
          className: 'flex flex-col gap-2',
          children: [
            WText('2. Type text',
                className:
                    'text-sm font-bold text-gray-700 dark:text-gray-300'),
            WInput(
              value: _text,
              onChanged: (v) => setState(() => _text = v),
              className:
                  'w-full p-3 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 focus:ring-2 focus:ring-emerald-500/20 focus:border-emerald-500 transition-all',
            ),
          ],
        ),
        WDiv(
          className: 'flex flex-col gap-2',
          children: [
            WText('Result',
                className:
                    'text-sm font-bold text-gray-700 dark:text-gray-300'),
            WDiv(
              className:
                  'p-6 bg-gray-900 rounded-xl flex items-center justify-center min-h-[100px]',
              child: WText(
                _text,
                className:
                    '$_selectedTransform text-2xl font-bold text-white text-center',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
