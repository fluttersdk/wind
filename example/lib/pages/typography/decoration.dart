import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Text Decoration Example
/// Demonstrates text decoration utilities: underline, line-through, overline
class TypographyDecorationPage extends StatelessWidget {
  const TypographyDecorationPage({super.key});

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
              bg-gradient-to-r from-teal-500 to-cyan-500
            ''',
            children: [
              WText(
                'Text Decoration',
                className: 'text-lg font-bold text-white',
              ),
              WText(
                'Underline, strike-through, and more',
                className: 'text-sm text-teal-100',
              ),
            ],
          ),

          // Decoration Types
          _buildSection(
            title: 'Decoration Types',
            description: 'Basic text decorations',
            children: [
              WDiv(
                className:
                    'flex flex-wrap gap-4 p-4 bg-gray-100 dark:bg-slate-800 rounded-lg overflow-x-auto',
                children: [
                  WText(
                    'underline',
                    className:
                        'underline text-lg text-gray-800 dark:text-white',
                  ),
                  WText(
                    'overline',
                    className: 'overline text-lg text-gray-800 dark:text-white',
                  ),
                  WText(
                    'line-through',
                    className:
                        'line-through text-lg text-gray-800 dark:text-white',
                  ),
                  WText(
                    'no-underline',
                    className:
                        'no-underline text-lg text-gray-800 dark:text-white',
                  ),
                ],
              ),
            ],
          ),

          // Decoration Color
          _buildSection(
            title: 'Decoration Color',
            description: 'Color the decoration line',
            children: [
              WDiv(
                className:
                    'flex flex-wrap gap-4 p-4 bg-gray-100 dark:bg-slate-800 rounded-lg overflow-x-auto',
                children: [
                  WText(
                    'decoration-red-500',
                    className:
                        'underline decoration-red-500 text-lg text-gray-800 dark:text-white',
                  ),
                  WText(
                    'decoration-blue-500',
                    className:
                        'underline decoration-blue-500 text-lg text-gray-800 dark:text-white',
                  ),
                  WText(
                    'decoration-green-500',
                    className:
                        'underline decoration-green-500 text-lg text-gray-800 dark:text-white',
                  ),
                ],
              ),
            ],
          ),

          // Decoration Style
          _buildSection(
            title: 'Decoration Style',
            description: 'Line style variations',
            children: [
              WDiv(
                className:
                    'flex flex-wrap gap-4 p-4 bg-gray-100 dark:bg-slate-800 rounded-lg overflow-x-auto',
                children: [
                  WText(
                    'solid',
                    className:
                        'underline decoration-solid text-lg text-gray-800 dark:text-white',
                  ),
                  WText(
                    'double',
                    className:
                        'underline decoration-double text-lg text-gray-800 dark:text-white',
                  ),
                  WText(
                    'dotted',
                    className:
                        'underline decoration-dotted text-lg text-gray-800 dark:text-white',
                  ),
                  WText(
                    'dashed',
                    className:
                        'underline decoration-dashed text-lg text-gray-800 dark:text-white',
                  ),
                  WText(
                    'wavy',
                    className:
                        'underline decoration-wavy text-lg text-gray-800 dark:text-white',
                  ),
                ],
              ),
            ],
          ),

          // Decoration Thickness
          _buildSection(
            title: 'Decoration Thickness',
            description: 'Line thickness',
            children: [
              WDiv(
                className:
                    'flex flex-wrap gap-4 p-4 bg-gray-100 dark:bg-slate-800 rounded-lg overflow-x-auto',
                children: [
                  WText(
                    'decoration-1',
                    className:
                        'underline decoration-1 text-lg text-gray-800 dark:text-white',
                  ),
                  WText(
                    'decoration-2',
                    className:
                        'underline decoration-2 text-lg text-gray-800 dark:text-white',
                  ),
                  WText(
                    'decoration-4',
                    className:
                        'underline decoration-4 text-lg text-gray-800 dark:text-white',
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
                  _buildRefRow('underline', 'Underline text'),
                  _buildRefRow('line-through', 'Strike-through'),
                  _buildRefRow('decoration-{color}', 'Decoration color'),
                  _buildRefRow('decoration-{style}', 'solid, wavy, etc.'),
                  _buildRefRow('decoration-{n}', 'Thickness (1, 2, 4)'),
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
