import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class WSpacerBasicExamplePage extends StatelessWidget {
  const WSpacerBasicExamplePage({super.key});

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
            title: 'Vertical Spacing',
            description:
                'Using h-4 (16px) and h-8 (32px) to separate elements vertically.',
            child: WDiv(
              className:
                  'flex flex-col border border-gray-200 dark:border-gray-700 rounded-lg p-4 bg-white dark:bg-slate-800',
              children: [
                WDiv(
                    className:
                        'h-12 bg-blue-100 dark:bg-blue-900/30 rounded flex items-center justify-center',
                    child: WText('Item 1')),
                const WSpacer(className: 'h-4'),
                WDiv(
                    className:
                        'h-12 bg-blue-100 dark:bg-blue-900/30 rounded flex items-center justify-center',
                    child: WText('Item 2 (h-4 gap above)')),
                const WSpacer(className: 'h-8'),
                WDiv(
                    className:
                        'h-12 bg-blue-100 dark:bg-blue-900/30 rounded flex items-center justify-center',
                    child: WText('Item 3 (h-8 gap above)')),
              ],
            ),
          ),
          _buildSection(
            title: 'Horizontal Spacing',
            description:
                'Using w-4 (16px) and w-8 (32px) to separate elements horizontally in a flex row.',
            child: WDiv(
              className:
                  'flex flex-row border border-gray-200 dark:border-gray-700 rounded-lg p-4 bg-white dark:bg-slate-800 overflow-x-auto',
              children: [
                WDiv(
                    className:
                        'w-24 h-12 bg-green-100 dark:bg-green-900/30 rounded flex items-center justify-center',
                    child: WText('Item A')),
                const WSpacer(className: 'w-4'),
                WDiv(
                    className:
                        'w-24 h-12 bg-green-100 dark:bg-green-900/30 rounded flex items-center justify-center',
                    child: WText('Item B')),
                const WSpacer(className: 'w-8'),
                WDiv(
                    className:
                        'w-24 h-12 bg-green-100 dark:bg-green-900/30 rounded flex items-center justify-center',
                    child: WText('Item C')),
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
          'bg-gradient-to-r from-blue-500 to-indigo-600 rounded-xl p-6 shadow-lg',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WText(
            'WSpacer Basic',
            className: 'text-2xl font-bold text-white mb-2',
          ),
          WText(
            'Simple lightweight widget for adding consistent gaps between elements.',
            className: 'text-blue-100',
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
