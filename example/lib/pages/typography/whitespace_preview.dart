import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class WhitespacePreviewExamplePage extends StatelessWidget {
  const WhitespacePreviewExamplePage({super.key});

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
            title: 'whitespace-normal (Default)',
            description: 'Text wraps normally to the next line.',
            child: WDiv(
              className:
                  'w-64 p-4 bg-slate-100 dark:bg-slate-800 rounded-lg border border-slate-200 dark:border-slate-700',
              child: WText(
                'This is a long sentence that will wrap to the next line when it reaches the container edge.',
                className: 'text-slate-900 dark:text-white whitespace-normal',
              ),
            ),
          ),
          _buildSection(
            title: 'whitespace-nowrap',
            description: 'Text stays on a single line without wrapping.',
            child: WDiv(
              className:
                  'w-64 p-4 bg-slate-100 dark:bg-slate-800 rounded-lg border border-slate-200 dark:border-slate-700 overflow-x-auto',
              child: WText(
                'This is a long sentence that will not wrap to the next line.',
                className: 'text-slate-900 dark:text-white whitespace-nowrap',
              ),
            ),
          ),
          _buildSection(
            title: 'Comparison',
            description: 'Same text with different whitespace settings.',
            child: WDiv(
              className: 'flex flex-col gap-4',
              children: [
                _buildComparisonBox(
                  label: 'whitespace-normal',
                  className: 'whitespace-normal',
                  bgColor: 'bg-blue-100 dark:bg-blue-900/30',
                ),
                _buildComparisonBox(
                  label: 'whitespace-nowrap',
                  className: 'whitespace-nowrap',
                  bgColor: 'bg-green-100 dark:bg-green-900/30',
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
      className: 'bg-gradient-to-r from-teal-500 to-cyan-600 rounded-xl p-6',
      children: [
        WText(
          'Whitespace Utilities',
          className: 'text-2xl font-bold text-white',
        ),
        WText(
          'Control text wrapping behavior',
          className: 'text-white/80 mt-2',
        ),
      ],
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

  Widget _buildComparisonBox({
    required String label,
    required String className,
    required String bgColor,
  }) {
    return WDiv(
      className: 'flex flex-col gap-2',
      children: [
        WText(label,
            className: 'text-xs font-mono text-slate-500 dark:text-slate-400'),
        WDiv(
          className: 'w-64 p-3 $bgColor rounded-lg overflow-x-auto',
          child: WText(
            'The quick brown fox jumps over the lazy dog near the riverbank.',
            className: 'text-slate-900 dark:text-white $className',
          ),
        ),
      ],
    );
  }
}
