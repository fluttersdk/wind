import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Text Color Example
/// Demonstrates text color utilities: text-{color}-{shade}
class TypographyColorsPage extends StatelessWidget {
  const TypographyColorsPage({super.key});

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
              bg-gradient-to-r from-red-500 to-orange-500
            ''',
            children: [
              WText('Text Color', className: 'text-lg font-bold text-white'),
              WText(
                'Control text color with text-{color}-{shade}',
                className: 'text-sm text-red-100',
              ),
            ],
          ),

          // Color Examples
          _buildSection(
            title: 'Color Palette',
            description: 'Common text colors',
            children: [
              WDiv(
                className:
                    'flex flex-wrap gap-4 p-4 bg-gray-100 dark:bg-slate-800 rounded-lg overflow-x-auto',
                children: [
                  _buildColorChip('text-red-500', 'Red'),
                  _buildColorChip('text-blue-500', 'Blue'),
                  _buildColorChip('text-green-500', 'Green'),
                  _buildColorChip('text-yellow-500', 'Yellow'),
                  _buildColorChip('text-purple-500', 'Purple'),
                  _buildColorChip('text-pink-500', 'Pink'),
                ],
              ),
            ],
          ),

          // Shades
          _buildSection(
            title: 'Color Shades',
            description: 'From 50 (light) to 900 (dark)',
            children: [
              WDiv(
                className:
                    'flex flex-wrap gap-2 p-4 bg-gray-100 dark:bg-slate-800 rounded-lg overflow-x-auto',
                children: [
                  WText(
                    '50',
                    className: 'text-blue-50 bg-slate-700 px-2 py-1 rounded',
                  ),
                  WText(
                    '100',
                    className: 'text-blue-100 bg-slate-700 px-2 py-1 rounded',
                  ),
                  WText(
                    '200',
                    className: 'text-blue-200 bg-slate-700 px-2 py-1 rounded',
                  ),
                  WText('300', className: 'text-blue-300 px-2 py-1 rounded'),
                  WText('400', className: 'text-blue-400 px-2 py-1 rounded'),
                  WText('500', className: 'text-blue-500 px-2 py-1 rounded'),
                  WText('600', className: 'text-blue-600 px-2 py-1 rounded'),
                  WText('700', className: 'text-blue-700 px-2 py-1 rounded'),
                  WText('800', className: 'text-blue-800 px-2 py-1 rounded'),
                  WText('900', className: 'text-blue-900 px-2 py-1 rounded'),
                ],
              ),
            ],
          ),

          // Arbitrary Values
          _buildSection(
            title: 'Arbitrary Values',
            description: 'Custom hex colors',
            children: [
              WDiv(
                className:
                    'flex gap-4 p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
                children: [
                  WText(
                    'text-[#FF00FF]',
                    className: 'text-[#FF00FF] text-lg font-bold',
                  ),
                  WText(
                    'text-[#00CED1]',
                    className: 'text-[#00CED1] text-lg font-bold',
                  ),
                ],
              ),
            ],
          ),

          // Hover State
          _buildSection(
            title: 'Hover State',
            description: 'Color change on hover',
            children: [
              WDiv(
                className: 'p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
                child: WAnchor(
                  onTap: () {},
                  child: WText(
                    'Hover me (gray → blue)',
                    className:
                        'text-gray-500 hover:text-blue-500 text-lg font-bold',
                  ),
                ),
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
                  _buildRefRow('text-{color}-{shade}', 'e.g. text-red-500'),
                  _buildRefRow('text-{color}/opacity', 'e.g. text-red-500/50'),
                  _buildRefRow('text-[#hex]', 'Arbitrary color'),
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

  Widget _buildColorChip(String className, String label) {
    return WDiv(
      className: 'flex items-center gap-2',
      children: [WText(label, className: '$className text-lg font-bold')],
    );
  }

  Widget _buildRefRow(String className, String description) {
    return WDiv(
      className: 'flex gap-4',
      children: [
        WText(
          className,
          className:
              'font-mono text-sm text-indigo-600 dark:text-indigo-400 w-40',
        ),
        WText(
          description,
          className: 'text-sm text-gray-600 dark:text-gray-300',
        ),
      ],
    );
  }
}
