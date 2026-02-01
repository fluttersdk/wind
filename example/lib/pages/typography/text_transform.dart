import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Text Transform Example
/// Demonstrates text transform utilities: uppercase, lowercase, capitalize
class TextTransformExamplePage extends StatelessWidget {
  const TextTransformExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'w-full h-full overflow-y-auto p-4',
      child: WDiv(
        className: 'flex flex-col gap-6',
        children: [
          // Header
          WDiv(
            className: '''
              w-full p-4 rounded-xl
              bg-gradient-to-r from-amber-500 to-yellow-500
            ''',
            children: [
              WText(
                'Text Transform',
                className: 'text-lg font-bold text-white',
              ),
              WText('Transform text case', className: 'text-sm text-amber-100'),
            ],
          ),

          // Transform Examples
          _buildSection(
            title: 'Transform Classes',
            description: 'Change text case transformations',
            children: [
              WDiv(
                className:
                    'flex flex-col gap-4 p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
                children: [
                  _buildTransformRow('uppercase', 'hello world', 'HELLO WORLD'),
                  _buildTransformRow('lowercase', 'HELLO WORLD', 'hello world'),
                  _buildTransformRow(
                    'capitalize',
                    'hello world',
                    'Hello World',
                  ),
                  _buildTransformRow(
                    'normal-case',
                    'Hello World',
                    'Hello World',
                  ),
                ],
              ),
            ],
          ),

          // Reference Table
          WDiv(
            className: 'p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
            children: [
              WText(
                'Quick Reference',
                className: 'font-semibold text-gray-800 dark:text-white mb-2',
              ),
              WDiv(
                className: 'flex flex-col gap-1',
                children: [
                  _buildRefRow('uppercase', 'HELLO'),
                  _buildRefRow('lowercase', 'hello'),
                  _buildRefRow('capitalize', 'Hello World'),
                  _buildRefRow('normal-case', 'Original Case'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String description,
    required List<Widget> children,
  }) {
    return WDiv(
      className: 'flex flex-col gap-2',
      children: [
        WText(
          title,
          className: 'font-semibold text-gray-800 dark:text-white font-mono',
        ),
        WText(
          description,
          className: 'text-sm text-gray-500 dark:text-gray-400',
        ),
        ...children,
      ],
    );
  }

  Widget _buildTransformRow(String className, String input, String output) {
    return WDiv(
      className:
          'flex items-center gap-4 p-3 bg-white dark:bg-slate-700 rounded-lg',
      children: [
        WText(
          className,
          className:
              'font-mono text-sm text-indigo-600 dark:text-indigo-400 w-28',
        ),
        WText(
          input,
          className: '$className text-lg text-gray-800 dark:text-white',
        ),
      ],
    );
  }

  Widget _buildRefRow(String className, String result) {
    return WDiv(
      className: 'flex gap-4',
      children: [
        WText(
          className,
          className:
              'font-mono text-sm text-indigo-600 dark:text-indigo-400 w-28',
        ),
        WText(result, className: 'text-sm text-gray-600 dark:text-gray-300'),
      ],
    );
  }
}
