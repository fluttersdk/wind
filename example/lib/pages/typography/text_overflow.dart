import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Text Overflow Example
/// Demonstrates text overflow utilities: truncate, line-clamp, whitespace
class TextOverflowExamplePage extends StatelessWidget {
  const TextOverflowExamplePage({super.key});

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
              bg-gradient-to-r from-orange-500 to-red-500
            ''',
            children: const [
              WText('Text Overflow', className: 'text-lg font-bold text-white'),
              WText(
                'Control how text overflows its container',
                className: 'text-sm text-orange-100',
              ),
            ],
          ),

          // Truncate
          _buildSection(
            title: 'truncate',
            description: 'Single line with ellipsis',
            children: [
              WDiv(
                className: 'p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
                child: WDiv(
                  className: 'w-64',
                  child: const WText(
                    'This is a very long text that will be truncated with ellipsis',
                    className: 'truncate text-gray-800 dark:text-white',
                  ),
                ),
              ),
            ],
          ),

          // Line Clamp
          _buildSection(
            title: 'line-clamp-{n}',
            description: 'Clamp to specific number of lines',
            children: [
              WDiv(
                className:
                    'flex flex-col gap-4 p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
                children: [
                  WDiv(
                    className: 'flex flex-col gap-1',
                    children: const [
                      WText(
                        'line-clamp-2',
                        className:
                            'text-xs font-mono text-indigo-600 dark:text-indigo-400',
                      ),
                      WText(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.',
                        className: 'line-clamp-2 text-gray-800 dark:text-white',
                      ),
                    ],
                  ),
                  WDiv(
                    className: 'flex flex-col gap-1',
                    children: const [
                      WText(
                        'line-clamp-3',
                        className:
                            'text-xs font-mono text-indigo-600 dark:text-indigo-400',
                      ),
                      WText(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco.',
                        className: 'line-clamp-3 text-gray-800 dark:text-white',
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          // Whitespace
          _buildSection(
            title: 'Whitespace',
            description: 'Control text wrapping behavior',
            children: [
              WDiv(
                className:
                    'flex flex-col gap-4 p-4 bg-gray-100 dark:bg-slate-800 rounded-lg overflow-x-auto',
                children: [
                  WDiv(
                    className: 'flex flex-col gap-1',
                    children: const [
                      WText(
                        'whitespace-nowrap',
                        className:
                            'text-xs font-mono text-indigo-600 dark:text-indigo-400',
                      ),
                      WText(
                        'This text will not wrap, scroll horizontally to see more →',
                        className:
                            'whitespace-nowrap text-gray-800 dark:text-white',
                      ),
                    ],
                  ),
                  WDiv(
                    className: 'flex flex-col gap-1 w-48',
                    children: const [
                      WText(
                        'whitespace-normal',
                        className:
                            'text-xs font-mono text-indigo-600 dark:text-indigo-400',
                      ),
                      WText(
                        'This text will wrap normally when reaching the edge',
                        className:
                            'whitespace-normal text-gray-800 dark:text-white',
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          // Quick Reference
          WDiv(
            className: 'p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
            children: [
              const WText(
                'Quick Reference',
                className: 'font-semibold text-gray-800 dark:text-white mb-2',
              ),
              WDiv(
                className: 'flex flex-col gap-1',
                children: [
                  _buildRefRow('truncate', 'Single line ellipsis'),
                  _buildRefRow('line-clamp-{n}', 'Max lines (1-6)'),
                  _buildRefRow('text-ellipsis', 'Ellipsis overflow'),
                  _buildRefRow('whitespace-nowrap', 'Prevent wrapping'),
                  _buildRefRow('whitespace-normal', 'Normal wrapping'),
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
              'font-mono text-sm text-indigo-600 dark:text-indigo-400 w-36',
        ),
        WText(
          description,
          className: 'text-sm text-gray-600 dark:text-gray-300',
        ),
      ],
    );
  }
}
