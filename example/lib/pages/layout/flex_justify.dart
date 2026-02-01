import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Flex Justify Example
/// Demonstrates justify-content utilities for main axis alignment
class FlexJustifyExamplePage extends StatelessWidget {
  const FlexJustifyExamplePage({super.key});

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
              bg-gradient-to-r from-cyan-500 to-blue-500
            ''',
            children: [
              WText(
                'Justify Content',
                className: 'text-lg font-bold text-white',
              ),
              WText(
                'Control item position along the main axis',
                className: 'text-sm text-cyan-100',
              ),
            ],
          ),

          // justify-start
          _buildExample(
            label: 'justify-start',
            className:
                'flex justify-start gap-2 p-4 bg-gray-100 dark:bg-slate-700 rounded-lg',
          ),

          // justify-center
          _buildExample(
            label: 'justify-center',
            className:
                'flex justify-center gap-2 p-4 bg-gray-100 dark:bg-slate-700 rounded-lg',
          ),

          // justify-end
          _buildExample(
            label: 'justify-end',
            className:
                'flex justify-end gap-2 p-4 bg-gray-100 dark:bg-slate-700 rounded-lg',
          ),

          // justify-between
          _buildExample(
            label: 'justify-between',
            className:
                'flex justify-between p-4 bg-gray-100 dark:bg-slate-700 rounded-lg',
          ),

          // justify-around
          _buildExample(
            label: 'justify-around',
            className:
                'flex justify-around p-4 bg-gray-100 dark:bg-slate-700 rounded-lg',
          ),

          // justify-evenly
          _buildExample(
            label: 'justify-evenly',
            className:
                'flex justify-evenly p-4 bg-gray-100 dark:bg-slate-700 rounded-lg',
          ),
        ],
      ),
    );
  }

  Widget _buildExample({required String label, required String className}) {
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
              className: 'px-2 py-1 rounded bg-cyan-100 dark:bg-cyan-900/50',
              child: WText(
                'className: "$label"',
                className: 'text-xs font-mono text-cyan-700 dark:text-cyan-300',
              ),
            ),
          ],
        ),
        WDiv(
          className: className,
          children: [_buildBox('1'), _buildBox('2'), _buildBox('3')],
        ),
      ],
    );
  }

  Widget _buildBox(String label) {
    return WDiv(
      className:
          'w-12 h-12 bg-cyan-500 rounded-lg flex items-center justify-center',
      child: WText(label, className: 'text-white font-bold'),
    );
  }
}
