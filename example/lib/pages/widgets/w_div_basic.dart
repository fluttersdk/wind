import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class WDivBasicExamplePage extends StatelessWidget {
  const WDivBasicExamplePage({super.key});

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
            title: 'Basic Container Styling',
            description:
                'WDiv replacing Container with padding, background, border, and radius.',
            child: WDiv(
              className:
                  'p-6 bg-white dark:bg-slate-800 border border-gray-200 dark:border-gray-700 rounded-xl shadow-sm',
              child: WText(
                'I am a styled WDiv container.',
                className: 'text-gray-800 dark:text-gray-200 font-medium',
              ),
            ),
          ),
          _buildSection(
            title: 'Flex Layout',
            description:
                'WDiv acting as a Row (flex-row) with gap and alignment.',
            child: WDiv(
              className:
                  'flex flex-row items-center gap-4 p-4 bg-white dark:bg-slate-800 rounded-lg shadow-sm',
              children: [
                WDiv(
                    className:
                        'w-12 h-12 rounded-full bg-blue-500 flex items-center justify-center text-white font-bold',
                    child: WText('1')),
                WDiv(
                    className: 'flex-1',
                    child: WText('Flex Item (flex-1)',
                        className: 'text-gray-700 dark:text-gray-300')),
                WDiv(
                    className:
                        'px-3 py-1 bg-gray-100 dark:bg-gray-700 rounded text-sm',
                    child: WText('Badge')),
              ],
            ),
          ),
          _buildSection(
            title: 'Interactive State',
            description: 'WDiv with hover: and active: states.',
            child: WDiv(
              className:
                  'cursor-pointer p-6 rounded-xl border border-blue-200 bg-blue-50 hover:bg-blue-100 hover:shadow-lg hover:border-blue-400 transition-all duration-200 dark:bg-blue-900/20 dark:border-blue-800 dark:hover:bg-blue-900/40',
              child: WDiv(
                className: 'flex flex-col items-center gap-2',
                children: [
                  WIcon(Icons.touch_app, className: 'text-blue-500 text-3xl'),
                  WText('Hover & Click Me',
                      className: 'text-blue-700 dark:text-blue-300 font-bold'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className:
          'bg-gradient-to-r from-teal-500 to-emerald-600 rounded-xl p-6 shadow-lg',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WText(
            'WDiv Basics',
            className: 'text-2xl font-bold text-white mb-2',
          ),
          WText(
            'The fundamental building block for layout, styling, and structure.',
            className: 'text-teal-50',
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
