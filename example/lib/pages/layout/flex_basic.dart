import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Flex Basic Example
/// Demonstrates flex direction (row vs column) and basic flex usage
class FlexBasicExamplePage extends StatelessWidget {
  const FlexBasicExamplePage({super.key});

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
              bg-gradient-to-r from-blue-500 to-indigo-500
            ''',
            children: [
              WText(
                'Flex Direction',
                className: 'text-lg font-bold text-white',
              ),
              WText(
                'Use flex-row and flex-col to control item arrangement',
                className: 'text-sm text-blue-100',
              ),
            ],
          ),

          // Flex Row Example
          _buildSection(
            title: 'flex (row by default)',
            code: 'className: "flex gap-2"',
            child: WDiv(
              className:
                  'flex gap-2 p-4 bg-gray-100 dark:bg-slate-700 rounded-lg',
              children: [
                _buildBox('1', 'bg-blue-500'),
                _buildBox('2', 'bg-blue-500'),
                _buildBox('3', 'bg-blue-500'),
              ],
            ),
          ),

          // Flex Column Example
          _buildSection(
            title: 'flex flex-col',
            code: 'className: "flex flex-col gap-2"',
            child: WDiv(
              className:
                  'flex flex-col gap-2 p-4 bg-gray-100 dark:bg-slate-700 rounded-lg',
              children: [
                _buildBox('1', 'bg-green-500'),
                _buildBox('2', 'bg-green-500'),
                _buildBox('3', 'bg-green-500'),
              ],
            ),
          ),

          // Flex Wrap Example
          _buildSection(
            title: 'flex flex-wrap',
            code: 'className: "flex flex-wrap gap-2"',
            child: WDiv(
              className:
                  'flex flex-wrap gap-2 p-4 bg-gray-100 dark:bg-slate-700 rounded-lg',
              children: [
                _buildBox('1', 'bg-purple-500'),
                _buildBox('2', 'bg-purple-500'),
                _buildBox('3', 'bg-purple-500'),
                _buildBox('4', 'bg-purple-500'),
                _buildBox('5', 'bg-purple-500'),
                _buildBox('6', 'bg-purple-500'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String code,
    required Widget child,
  }) {
    return WDiv(
      className: 'flex flex-col gap-2',
      children: [
        WDiv(
          className: 'flex items-center justify-between',
          children: [
            WText(
              title,
              className: 'font-semibold text-gray-800 dark:text-white',
            ),
            WDiv(
              className: 'px-2 py-1 rounded bg-slate-200 dark:bg-slate-600',
              child: WText(
                code,
                className: 'text-xs font-mono text-gray-600 dark:text-gray-300',
              ),
            ),
          ],
        ),
        child,
      ],
    );
  }

  Widget _buildBox(String label, String bgColor) {
    return WDiv(
      className:
          '$bgColor w-12 h-12 rounded-lg flex items-center justify-center',
      child: WText(label, className: 'text-white font-bold'),
    );
  }
}
