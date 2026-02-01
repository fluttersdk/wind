import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Font Size Example
/// Demonstrates font size utilities: text-xs through text-9xl
class FontSizeExamplePage extends StatelessWidget {
  const FontSizeExamplePage({super.key});

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
              bg-gradient-to-r from-blue-500 to-cyan-500
            ''',
            children: [
              WText('Font Size', className: 'text-lg font-bold text-white'),
              WText(
                'Control text size with text-{size}',
                className: 'text-sm text-blue-100',
              ),
            ],
          ),

          // Size Examples
          _buildSection(
            title: 'Size Scale',
            description: 'From text-xs to text-4xl',
            children: [
              WDiv(
                className:
                    'flex flex-col gap-3 p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
                children: [
                  _buildSizeRow('text-xs', '12px'),
                  _buildSizeRow('text-sm', '14px'),
                  _buildSizeRow('text-base', '16px'),
                  _buildSizeRow('text-lg', '18px'),
                  _buildSizeRow('text-xl', '20px'),
                  _buildSizeRow('text-2xl', '24px'),
                  _buildSizeRow('text-3xl', '30px'),
                  _buildSizeRow('text-4xl', '36px'),
                ],
              ),
            ],
          ),

          // Arbitrary Values
          _buildSection(
            title: 'Arbitrary Values',
            description: 'Custom sizes with bracket notation',
            children: [
              WDiv(
                className:
                    'flex flex-col gap-2 p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
                children: [
                  WText(
                    'text-[20px]',
                    className: 'text-[20px] text-gray-800 dark:text-white',
                  ),
                  WText(
                    'text-[1.5rem]',
                    className: 'text-[1.5rem] text-gray-800 dark:text-white',
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
                  _buildRefRow('text-xs', '12px'),
                  _buildRefRow('text-sm', '14px'),
                  _buildRefRow('text-base', '16px'),
                  _buildRefRow('text-lg', '18px'),
                  _buildRefRow('text-xl', '20px'),
                  _buildRefRow('text-2xl', '24px'),
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

  Widget _buildSizeRow(String className, String size) {
    return WDiv(
      className: 'flex items-end gap-4 overflow-x-auto',
      children: [
        WText(
          className,
          className:
              'font-mono text-xs text-indigo-600 dark:text-indigo-400 w-24',
        ),
        WText(
          'The quick brown fox',
          className: '$className text-gray-800 dark:text-white',
        ),
      ],
    );
  }

  Widget _buildRefRow(String className, String size) {
    return WDiv(
      className: 'flex gap-4',
      children: [
        WText(
          className,
          className:
              'font-mono text-sm text-indigo-600 dark:text-indigo-400 w-24',
        ),
        WText(size, className: 'text-sm text-gray-600 dark:text-gray-300'),
      ],
    );
  }
}
