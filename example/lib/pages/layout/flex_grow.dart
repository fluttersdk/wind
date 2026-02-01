import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Flex Grow Example
/// Demonstrates flex-1, flex-none, and how items grow to fill space
class FlexGrowExamplePage extends StatelessWidget {
  const FlexGrowExamplePage({super.key});

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
              bg-gradient-to-r from-purple-500 to-pink-500
            ''',
            children: [
              WText(
                'Flex Grow & Shrink',
                className: 'text-lg font-bold text-white',
              ),
              WText(
                'Control how items grow to fill available space',
                className: 'text-sm text-purple-100',
              ),
            ],
          ),

          // flex-1 example
          _buildSection(
            title: 'flex-1 (grows to fill)',
            description: 'Middle item expands to fill available space',
            child: WDiv(
              className:
                  'flex gap-2 p-4 bg-gray-100 dark:bg-slate-700 rounded-lg',
              children: [
                WDiv(
                  className: '''
                    flex-none w-16 h-12 bg-blue-500 rounded-lg
                    flex items-center justify-center
                  ''',
                  child: WText(
                    'Fixed',
                    className: 'text-white text-xs font-medium',
                  ),
                ),
                WDiv(
                  className: '''
                    flex-1 h-12 bg-purple-500 rounded-lg
                    flex items-center justify-center
                  ''',
                  child: WText('flex-1', className: 'text-white font-bold'),
                ),
                WDiv(
                  className: '''
                    flex-none w-16 h-12 bg-blue-500 rounded-lg
                    flex items-center justify-center
                  ''',
                  child: WText(
                    'Fixed',
                    className: 'text-white text-xs font-medium',
                  ),
                ),
              ],
            ),
          ),

          // Multiple flex-1 example
          _buildSection(
            title: 'Multiple flex-1',
            description: 'Items share available space equally',
            child: WDiv(
              className:
                  'flex gap-2 p-4 bg-gray-100 dark:bg-slate-700 rounded-lg',
              children: [
                WDiv(
                  className: '''
                    flex-1 h-12 bg-emerald-500 rounded-lg
                    flex items-center justify-center
                  ''',
                  child: WText('flex-1', className: 'text-white font-bold'),
                ),
                WDiv(
                  className: '''
                    flex-1 h-12 bg-emerald-500 rounded-lg
                    flex items-center justify-center
                  ''',
                  child: WText('flex-1', className: 'text-white font-bold'),
                ),
                WDiv(
                  className: '''
                    flex-1 h-12 bg-emerald-500 rounded-lg
                    flex items-center justify-center
                  ''',
                  child: WText('flex-1', className: 'text-white font-bold'),
                ),
              ],
            ),
          ),

          // flex-none example
          _buildSection(
            title: 'flex-none (fixed size)',
            description: 'Item maintains its size, doesn\'t grow or shrink',
            child: WDiv(
              className:
                  'flex gap-2 p-4 bg-gray-100 dark:bg-slate-700 rounded-lg',
              children: [
                WDiv(
                  className: '''
                    flex-none w-24 h-12 bg-orange-500 rounded-lg
                    flex items-center justify-center
                  ''',
                  child: WText(
                    'flex-none',
                    className: 'text-white font-bold text-sm',
                  ),
                ),
                WDiv(
                  className: '''
                    flex-1 h-12 bg-gray-400 rounded-lg
                    flex items-center justify-center
                  ''',
                  child: WText('flex-1', className: 'text-white font-bold'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String description,
    required Widget child,
  }) {
    return WDiv(
      className: 'flex flex-col gap-2',
      children: [
        WText(title, className: 'font-semibold text-gray-800 dark:text-white'),
        WText(
          description,
          className: 'text-sm text-gray-500 dark:text-gray-400',
        ),
        child,
      ],
    );
  }
}
