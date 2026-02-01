import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Line Height Example
/// Demonstrates line height utilities: leading-tight through leading-loose
class LineHeightExamplePage extends StatelessWidget {
  const LineHeightExamplePage({super.key});

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
              bg-gradient-to-r from-rose-500 to-pink-500
            ''',
            children: [
              WText('Line Height', className: 'text-lg font-bold text-white'),
              WText(
                'Control leading with leading-{value}',
                className: 'text-sm text-rose-100',
              ),
            ],
          ),

          // Leading Examples
          _buildSection(
            title: 'Leading Scale',
            description: 'From tight to loose line height',
            children: [
              WDiv(
                className:
                    'grid grid-cols-2 gap-4 p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
                children: [
                  _buildLeadingBox('leading-none', '1'),
                  _buildLeadingBox('leading-tight', '1.25'),
                  _buildLeadingBox('leading-snug', '1.375'),
                  _buildLeadingBox('leading-normal', '1.5'),
                  _buildLeadingBox('leading-relaxed', '1.625'),
                  _buildLeadingBox('leading-loose', '2'),
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
                  _buildRefRow('leading-none', '1'),
                  _buildRefRow('leading-tight', '1.25'),
                  _buildRefRow('leading-normal', '1.5'),
                  _buildRefRow('leading-relaxed', '1.625'),
                  _buildRefRow('leading-loose', '2'),
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

  Widget _buildLeadingBox(String className, String value) {
    return WDiv(
      className:
          'flex flex-col gap-1 p-3 bg-white dark:bg-slate-700 rounded-lg',
      children: [
        WText(
          className,
          className: 'text-xs font-mono text-indigo-600 dark:text-indigo-400',
        ),
        WText(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod.',
          className: '$className text-sm text-gray-800 dark:text-white',
        ),
      ],
    );
  }

  Widget _buildRefRow(String className, String value) {
    return WDiv(
      className: 'flex gap-4',
      children: [
        WText(
          className,
          className:
              'font-mono text-sm text-indigo-600 dark:text-indigo-400 w-36',
        ),
        WText(value, className: 'text-sm text-gray-600 dark:text-gray-300'),
      ],
    );
  }
}
