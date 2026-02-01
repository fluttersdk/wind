import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Display Example
/// Demonstrates display utilities: block, flex, grid, hidden, invisible
class DisplayExamplePage extends StatelessWidget {
  const DisplayExamplePage({super.key});

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
              bg-gradient-to-r from-indigo-500 to-purple-500
            ''',
            children: [
              WText(
                'Display Utilities',
                className: 'text-lg font-bold text-white',
              ),
              WText(
                'Control how elements are displayed',
                className: 'text-sm text-indigo-100',
              ),
            ],
          ),

          // Block
          _buildSection(
            title: 'block',
            description: 'Standard box model (default)',
            children: [
              WDiv(
                className: 'block p-4 bg-blue-500 rounded-lg',
                child: WText(
                  'block',
                  className: 'text-white font-mono text-sm',
                ),
              ),
            ],
          ),

          // Flex
          _buildSection(
            title: 'flex',
            description: 'Flexbox layout - items in a row',
            children: [
              WDiv(
                className: 'flex gap-2 p-4 bg-emerald-500 rounded-lg',
                children: [_buildItem('1'), _buildItem('2'), _buildItem('3')],
              ),
            ],
          ),

          // Grid
          _buildSection(
            title: 'grid',
            description: 'Grid layout - items in columns/rows',
            children: [
              WDiv(
                className:
                    'grid grid-cols-3 gap-2 p-4 bg-violet-500 rounded-lg',
                children: [
                  _buildItem('1'),
                  _buildItem('2'),
                  _buildItem('3'),
                  _buildItem('4'),
                  _buildItem('5'),
                  _buildItem('6'),
                ],
              ),
            ],
          ),

          // Hidden
          _buildSection(
            title: 'hidden',
            description: 'Remove from layout completely',
            children: [
              WDiv(
                className:
                    'flex gap-2 p-4 bg-gray-200 dark:bg-slate-700 rounded-lg',
                children: [
                  WDiv(
                    className:
                        'w-12 h-12 bg-rose-500 rounded-lg flex items-center justify-center',
                    child: WText('1', className: 'text-white font-bold'),
                  ),
                  // Hidden element - use separate WDiv to demonstrate
                  WDiv(
                    className: 'hidden',
                    child: WDiv(
                      className:
                          'w-12 h-12 bg-rose-500 rounded-lg flex items-center justify-center',
                      child: WText('2', className: 'text-white font-bold'),
                    ),
                  ),
                  WDiv(
                    className:
                        'w-12 h-12 bg-rose-500 rounded-lg flex items-center justify-center',
                    child: WText('3', className: 'text-white font-bold'),
                  ),
                ],
              ),
              WText(
                'Item 2 is hidden (not rendered)',
                className: 'text-xs text-gray-500 mt-1',
              ),
            ],
          ),

          // Opacity-0 (alternative to invisible)
          _buildSection(
            title: 'opacity-0',
            description: 'Hide visually but maintain layout space',
            children: [
              WDiv(
                className:
                    'flex gap-2 p-4 bg-gray-200 dark:bg-slate-700 rounded-lg',
                children: [
                  WDiv(
                    className:
                        'w-12 h-12 bg-amber-500 rounded-lg flex items-center justify-center',
                    child: WText('1', className: 'text-white font-bold'),
                  ),
                  // Opacity-0: invisible but takes space
                  WDiv(
                    className:
                        'opacity-0 w-12 h-12 bg-amber-500 rounded-lg flex items-center justify-center',
                    child: WText('2', className: 'text-white font-bold'),
                  ),
                  WDiv(
                    className:
                        'w-12 h-12 bg-amber-500 rounded-lg flex items-center justify-center',
                    child: WText('3', className: 'text-white font-bold'),
                  ),
                ],
              ),
              WText(
                'Item 2 has opacity-0 (space preserved)',
                className: 'text-xs text-gray-500 mt-1',
              ),
            ],
          ),

          // Responsive Display
          _buildSection(
            title: 'Responsive Display',
            description: 'Show/hide at breakpoints',
            children: [
              WDiv(
                className: 'flex flex-col gap-2',
                children: [
                  WDiv(
                    className: 'md:hidden p-3 bg-red-500 rounded-lg',
                    child: WText(
                      'Visible on mobile only',
                      className: 'text-white text-sm',
                    ),
                  ),
                  WDiv(
                    className: 'hidden md:block p-3 bg-green-500 rounded-lg',
                    child: WText(
                      'Visible on md+ only',
                      className: 'text-white text-sm',
                    ),
                  ),
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

  Widget _buildItem(String label) {
    return WDiv(
      className:
          'w-10 h-10 bg-white/30 rounded-lg flex items-center justify-center',
      child: WText(label, className: 'text-white font-bold'),
    );
  }
}
