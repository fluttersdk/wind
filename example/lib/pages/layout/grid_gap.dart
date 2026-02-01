import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Grid Gap Example
/// Demonstrates gap utilities for grid spacing
class GridGapExamplePage extends StatelessWidget {
  const GridGapExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'w-full h-full overflow-y-auto p-4',
      child: WDiv(
        className: 'flex flex-col gap-6 max-w-2xl',
        children: [
          // Header
          WDiv(
            className: '''
              w-full p-4 rounded-xl
              bg-gradient-to-r from-indigo-500 to-violet-500
            ''',
            children: [
              WText('Grid Gap', className: 'text-lg font-bold text-white'),
              WText(
                'Control spacing between grid items',
                className: 'text-sm text-indigo-100',
              ),
            ],
          ),

          // gap-2
          _buildExample(
            label: 'gap-2 (8px)',
            code: 'grid grid-cols-3 gap-2',
            gapClass: 'gap-2',
            color: 'bg-indigo-500',
          ),

          // gap-4
          _buildExample(
            label: 'gap-4 (16px)',
            code: 'grid grid-cols-3 gap-4',
            gapClass: 'gap-4',
            color: 'bg-violet-500',
          ),

          // gap-6
          _buildExample(
            label: 'gap-6 (24px)',
            code: 'grid grid-cols-3 gap-6',
            gapClass: 'gap-6',
            color: 'bg-purple-500',
          ),

          // gap-x and gap-y
          WDiv(
            className: 'flex flex-col gap-2',
            children: [
              WDiv(
                className: 'flex items-center gap-2',
                children: [
                  WText(
                    'gap-x-4 gap-y-2',
                    className: 'font-semibold text-gray-800 dark:text-white',
                  ),
                  WDiv(
                    className:
                        'px-2 py-1 rounded bg-indigo-100 dark:bg-indigo-900/50',
                    child: WText(
                      'Different H/V gaps',
                      className:
                          'text-xs font-mono text-indigo-700 dark:text-indigo-300',
                    ),
                  ),
                ],
              ),
              WDiv(
                className:
                    'grid grid-cols-3 gap-x-4 gap-y-2 p-4 bg-gray-100 dark:bg-slate-700 rounded-lg',
                children: List.generate(
                  6,
                  (i) => _buildBox('${i + 1}', 'bg-fuchsia-500'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExample({
    required String label,
    required String code,
    required String gapClass,
    required String color,
  }) {
    return WDiv(
      className: 'flex flex-col gap-2',
      children: [
        WDiv(
          className: 'flex items-center gap-2',
          children: [
            WText(
              label,
              className: 'font-semibold text-gray-800 dark:text-white',
            ),
            WDiv(
              className:
                  'px-2 py-1 rounded bg-indigo-100 dark:bg-indigo-900/50',
              child: WText(
                code,
                className:
                    'text-xs font-mono text-indigo-700 dark:text-indigo-300',
              ),
            ),
          ],
        ),
        WDiv(
          className:
              'grid grid-cols-3 $gapClass p-4 bg-gray-100 dark:bg-slate-700 rounded-lg',
          children: List.generate(6, (i) => _buildBox('${i + 1}', color)),
        ),
      ],
    );
  }

  Widget _buildBox(String label, String color) {
    return WDiv(
      className: '$color h-12 rounded-lg flex items-center justify-center',
      child: WText(label, className: 'text-white font-bold'),
    );
  }
}
