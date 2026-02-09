import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class WSpacerResponsiveExamplePage extends StatelessWidget {
  const WSpacerResponsiveExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className:
          'w-full h-full overflow-y-auto p-4 bg-gray-50 dark:bg-gray-900',
      scrollPrimary: true,
      child: WDiv(
        className: 'flex flex-col gap-6 max-w-4xl mx-auto',
        children: [
          _buildHeader(),
          _buildSection(
            title: 'Responsive Vertical Spacing',
            description:
                'Resize window to see gap change: h-2 (mobile) → h-8 (md) → h-16 (lg)',
            child: WDiv(
              className:
                  'flex flex-col border border-gray-200 dark:border-gray-700 rounded-lg p-4 bg-white dark:bg-slate-800',
              children: [
                WDiv(
                    className:
                        'p-4 bg-purple-100 dark:bg-purple-900/30 rounded text-center',
                    child: WText('Top Element')),

                // The responsive spacer
                const WSpacer(
                    className:
                        'h-2 md:h-8 lg:h-16 bg-red-500/10'), // Added bg to visualize the gap

                WDiv(
                    className:
                        'p-4 bg-purple-100 dark:bg-purple-900/30 rounded text-center',
                    child: WText('Bottom Element')),
                WText('Gap visualizer (red tint) shows the spacer height.',
                    className: 'text-xs text-gray-400 mt-2 text-center'),
              ],
            ),
          ),
          _buildSection(
            title: 'Responsive Horizontal Spacing',
            description:
                'Resize window to see gap change: w-2 (mobile) → w-12 (md)',
            child: WDiv(
              className:
                  'flex flex-row items-center border border-gray-200 dark:border-gray-700 rounded-lg p-4 bg-white dark:bg-slate-800',
              children: [
                WDiv(
                    className:
                        'p-4 bg-orange-100 dark:bg-orange-900/30 rounded',
                    child: WText('Left')),

                // The responsive spacer
                const WSpacer(className: 'w-2 md:w-12 bg-blue-500/10 h-10'),

                WDiv(
                    className:
                        'p-4 bg-orange-100 dark:bg-orange-900/30 rounded',
                    child: WText('Right')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className:
          'bg-gradient-to-r from-purple-500 to-pink-600 rounded-xl p-6 shadow-lg',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WText(
            'Responsive Spacer',
            className: 'text-2xl font-bold text-white mb-2',
          ),
          WText(
            'Adapting gaps based on screen size (sm, md, lg, xl).',
            className: 'text-purple-100',
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
      className: 'flex flex-col gap-4',
      children: [
        WDiv(
          className: 'flex flex-col',
          children: [
            WText(title,
                className:
                    'text-lg font-semibold text-slate-900 dark:text-white'),
            WText(description,
                className: 'text-sm text-slate-600 dark:text-slate-400'),
          ],
        ),
        child,
      ],
    );
  }
}
