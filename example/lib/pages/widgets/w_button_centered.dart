import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class WButtonCenteredExamplePage extends StatelessWidget {
  const WButtonCenteredExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'w-full h-full overflow-y-auto p-4',
      scrollPrimary: true,
      child: WDiv(
        className: 'flex flex-col gap-6 max-w-4xl mx-auto',
        children: [
          _buildHeader(),
          _buildSection(
            title: 'Centered Content (Default)',
            description:
                'WButton uses justify-center by default to center its content.',
            child: WButton(
              onTap: () {},
              className:
                  'w-full bg-blue-500 hover:bg-blue-600 text-white py-3 rounded-lg flex justify-center items-center',
              child: const WText('Centered Text'),
            ),
          ),
          _buildSection(
            title: 'Flex Row Centering',
            description:
                'Using flex utilities to center an icon and text together.',
            child: WButton(
              onTap: () {},
              className:
                  'w-full bg-indigo-500 hover:bg-indigo-600 text-white py-3 rounded-lg flex justify-center items-center gap-2',
              child: WDiv(
                className: 'flex items-center gap-2',
                children: const [
                  WIcon(Icons.add, className: 'text-lg'),
                  WText('Create New Item'),
                ],
              ),
            ),
          ),
          _buildSection(
            title: 'Custom Alignment',
            description: 'Overriding default centering for specific layouts.',
            child: WDiv(
              className: 'flex flex-col gap-4',
              children: [
                WButton(
                  onTap: () {},
                  className:
                      'w-full bg-white dark:bg-slate-700 border border-gray-300 dark:border-gray-600 hover:bg-gray-50 dark:hover:bg-slate-600 py-3 px-4 rounded-lg flex justify-start',
                  child: const WText('Left Aligned'),
                ),
                WButton(
                  onTap: () {},
                  className:
                      'w-full bg-white dark:bg-slate-700 border border-gray-300 dark:border-gray-600 hover:bg-gray-50 dark:hover:bg-slate-600 py-3 px-4 rounded-lg flex justify-between items-center',
                  child: WDiv(
                    className: 'flex justify-between w-full items-center',
                    children: const [
                      WText('Space Between'),
                      WIcon(Icons.chevron_right, className: 'text-gray-400'),
                    ],
                  ),
                ),
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
      child: WDiv(
        className: 'flex flex-col gap-2',
        children: const [
          WText(
            'Button Layouts',
            className: 'text-2xl font-bold text-white',
          ),
          WText(
            'Examples of content alignment and centering within WButton.',
            className: 'text-white/80',
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
      className:
          'flex flex-col gap-4 p-6 bg-white dark:bg-slate-800 rounded-xl shadow-sm border border-gray-100 dark:border-gray-700',
      children: [
        WDiv(
          className: 'flex flex-col gap-1',
          children: [
            WText(title,
                className:
                    'text-lg font-semibold text-slate-900 dark:text-white'),
            WText(description,
                className: 'text-sm text-slate-500 dark:text-slate-400'),
          ],
        ),
        WDiv(
          className:
              'p-4 bg-gray-50 dark:bg-slate-900/50 rounded-lg border border-gray-100 dark:border-gray-700/50',
          child: child,
        ),
      ],
    );
  }
}
