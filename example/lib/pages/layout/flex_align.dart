import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Flex Align Example
/// Demonstrates items-* utilities for cross axis alignment
class FlexAlignExamplePage extends StatelessWidget {
  const FlexAlignExamplePage({super.key});

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
              bg-gradient-to-r from-amber-500 to-orange-500
            ''',
            children: [
              WText('Align Items', className: 'text-lg font-bold text-white'),
              WText(
                'Control item position along the cross axis',
                className: 'text-sm text-amber-100',
              ),
            ],
          ),

          // items-start
          _buildExample(
            label: 'items-start',
            className:
                'flex items-start gap-2 h-24 p-4 bg-gray-100 dark:bg-slate-700 rounded-lg',
            boxes: [
              _buildBox('1', height: 'h-8'),
              _buildBox('2', height: 'h-12'),
              _buildBox('3', height: 'h-6'),
            ],
          ),

          // items-center
          _buildExample(
            label: 'items-center',
            className:
                'flex items-center gap-2 h-24 p-4 bg-gray-100 dark:bg-slate-700 rounded-lg',
            boxes: [
              _buildBox('1', height: 'h-8'),
              _buildBox('2', height: 'h-12'),
              _buildBox('3', height: 'h-6'),
            ],
          ),

          // items-end
          _buildExample(
            label: 'items-end',
            className:
                'flex items-end gap-2 h-24 p-4 bg-gray-100 dark:bg-slate-700 rounded-lg',
            boxes: [
              _buildBox('1', height: 'h-8'),
              _buildBox('2', height: 'h-12'),
              _buildBox('3', height: 'h-6'),
            ],
          ),

          // items-stretch
          _buildExample(
            label: 'items-stretch',
            className:
                'flex items-stretch gap-2 h-24 p-4 bg-gray-100 dark:bg-slate-700 rounded-lg',
            boxes: [
              _buildStretchBox('1'),
              _buildStretchBox('2'),
              _buildStretchBox('3'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExample({
    required String label,
    required String className,
    required List<Widget> boxes,
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
              className: 'px-2 py-1 rounded bg-amber-100 dark:bg-amber-900/50',
              child: WText(
                'className: "$label"',
                className:
                    'text-xs font-mono text-amber-700 dark:text-amber-300',
              ),
            ),
          ],
        ),
        WDiv(className: className, children: boxes),
      ],
    );
  }

  Widget _buildBox(String label, {required String height}) {
    return WDiv(
      className:
          'w-12 $height bg-amber-500 rounded-lg flex items-center justify-center',
      child: WText(label, className: 'text-white font-bold'),
    );
  }

  Widget _buildStretchBox(String label) {
    return WDiv(
      className:
          'w-12 bg-amber-500 rounded-lg flex items-center justify-center',
      child: WText(label, className: 'text-white font-bold'),
    );
  }
}
