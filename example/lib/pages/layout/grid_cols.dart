import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Grid Cols Example
/// Demonstrates grid-cols utilities for column layouts
class GridColsExamplePage extends StatelessWidget {
  const GridColsExamplePage({super.key});

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
              bg-gradient-to-r from-rose-500 to-pink-500
            ''',
            children: [
              WText('Grid Columns', className: 'text-lg font-bold text-white'),
              WText(
                'Use grid-cols-{n} to create column layouts',
                className: 'text-sm text-rose-100',
              ),
            ],
          ),

          // grid-cols-2
          _buildExample(
            label: 'grid-cols-2',
            code: 'grid grid-cols-2 gap-2',
            columns: 2,
            itemCount: 4,
            color: 'bg-rose-500',
          ),

          // grid-cols-3
          _buildExample(
            label: 'grid-cols-3',
            code: 'grid grid-cols-3 gap-2',
            columns: 3,
            itemCount: 6,
            color: 'bg-pink-500',
          ),

          // grid-cols-4
          _buildExample(
            label: 'grid-cols-4',
            code: 'grid grid-cols-4 gap-2',
            columns: 4,
            itemCount: 8,
            color: 'bg-fuchsia-500',
          ),
        ],
      ),
    );
  }

  Widget _buildExample({
    required String label,
    required String code,
    required int columns,
    required int itemCount,
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
              className: 'px-2 py-1 rounded bg-rose-100 dark:bg-rose-900/50',
              child: WText(
                code,
                className: 'text-xs font-mono text-rose-700 dark:text-rose-300',
              ),
            ),
          ],
        ),
        WDiv(
          className:
              'grid grid-cols-$columns gap-2 p-4 bg-gray-100 dark:bg-slate-700 rounded-lg',
          children: List.generate(
            itemCount,
            (i) => _buildBox('${i + 1}', color),
          ),
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
