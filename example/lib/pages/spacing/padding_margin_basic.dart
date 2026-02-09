import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class PaddingMarginBasicExamplePage extends StatelessWidget {
  const PaddingMarginBasicExamplePage({super.key});

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
            title: 'Padding vs Margin',
            description:
                'Visualizing the difference between padding (inner space) and margin (outer space).',
            child: _buildDemo(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className: 'bg-gradient-to-r from-blue-500 to-indigo-600 rounded-xl p-6',
      child: WText(
        'Padding & Margin Basic',
        className: 'text-2xl font-bold text-white',
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
          'flex flex-col gap-4 p-4 bg-white dark:bg-slate-800 rounded-lg shadow-sm',
      children: [
        WText(title,
            className: 'text-lg font-semibold text-slate-900 dark:text-white'),
        WText(description,
            className: 'text-sm text-slate-600 dark:text-slate-400'),
        child,
      ],
    );
  }

  Widget _buildDemo() {
    return WDiv(
      className: 'flex flex-col gap-8',
      children: [
        // Margin Example
        WDiv(
          className: 'flex flex-col gap-2',
          children: [
            WText('Margin (m-6)',
                className: 'font-medium text-slate-700 dark:text-slate-300'),
            WDiv(
              className:
                  'bg-amber-100 dark:bg-amber-900/30 rounded-lg border border-amber-200 dark:border-amber-700/50',
              child: WDiv(
                className: 'm-6 bg-blue-500 rounded-lg p-4 shadow-sm',
                child: WText('m-6 pushes away from container edges',
                    className: 'text-white text-center'),
              ),
            ),
          ],
        ),

        // Padding Example
        WDiv(
          className: 'flex flex-col gap-2',
          children: [
            WText('Padding (p-6)',
                className: 'font-medium text-slate-700 dark:text-slate-300'),
            WDiv(
              className: 'bg-blue-500 rounded-lg p-6 shadow-sm',
              child: WDiv(
                className: 'bg-white dark:bg-slate-800 rounded p-4',
                child: WText('p-6 pushes content inward',
                    className: 'text-slate-900 dark:text-white text-center'),
              ),
            ),
          ],
        ),

        // Combined Example
        WDiv(
          className: 'flex flex-col gap-2',
          children: [
            WText('Combined (m-4 + p-6)',
                className: 'font-medium text-slate-700 dark:text-slate-300'),
            WDiv(
              className:
                  'bg-amber-100 dark:bg-amber-900/30 rounded-lg border border-amber-200 dark:border-amber-700/50',
              child: WDiv(
                className: 'm-4 bg-blue-500 rounded-lg p-6 shadow-sm',
                child: WDiv(
                  className: 'bg-white dark:bg-slate-800 rounded p-4',
                  child: WText('m-4 (outer) + p-6 (inner)',
                      className:
                          'text-slate-900 dark:text-white text-center font-mono'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
