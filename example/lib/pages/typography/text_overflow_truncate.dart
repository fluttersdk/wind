import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class TextOverflowTruncateExamplePage extends StatelessWidget {
  const TextOverflowTruncateExamplePage({super.key});

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
            title: 'Text Truncation',
            description:
                'Use the truncate utility to truncate text with an ellipsis (...) when it overflows its container.',
            child: _buildExample(),
          ),
          _buildSection(
            title: 'In Flex Container',
            description:
                'Truncation inside a flex container. Note: You often need min-w-0 on the flex child to allow truncation.',
            child: _buildFlexExample(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className: 'bg-gradient-to-r from-blue-500 to-indigo-600 rounded-xl p-6',
      child: WText(
        'Text Overflow: Truncate',
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
          'flex flex-col gap-4 p-4 bg-white dark:bg-slate-800 rounded-lg shadow-sm border border-slate-200 dark:border-slate-700',
      children: [
        WText(title,
            className: 'text-lg font-semibold text-slate-900 dark:text-white'),
        WText(description,
            className: 'text-sm text-slate-600 dark:text-slate-400'),
        WDiv(
          className:
              'p-6 bg-slate-50 dark:bg-slate-900 rounded-lg border border-slate-200 dark:border-slate-700',
          child: child,
        ),
      ],
    );
  }

  Widget _buildExample() {
    return WDiv(
      className: 'flex flex-col gap-4',
      children: [
        WDiv(
          className:
              'w-64 bg-white dark:bg-slate-800 p-4 rounded border border-slate-200 dark:border-slate-700',
          children: [
            WText('Without truncate:',
                className: 'text-xs text-slate-400 mb-1'),
            const WText(
              'The quick brown fox jumps over the lazy dog and runs away.',
              className:
                  'whitespace-nowrap overflow-hidden text-slate-900 dark:text-white',
            ),
          ],
        ),
        WDiv(
          className:
              'w-64 bg-white dark:bg-slate-800 p-4 rounded border border-slate-200 dark:border-slate-700',
          children: [
            WText('With truncate:', className: 'text-xs text-slate-400 mb-1'),
            const WText(
              'The quick brown fox jumps over the lazy dog and runs away.',
              className: 'truncate text-slate-900 dark:text-white',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFlexExample() {
    return WDiv(
      className:
          'flex gap-4 w-full bg-white dark:bg-slate-800 p-4 rounded border border-slate-200 dark:border-slate-700',
      children: [
        WDiv(
          className:
              'w-12 h-12 bg-blue-500 rounded-full flex items-center justify-center shrink-0',
          child: const WText('IMG', className: 'text-xs text-white'),
        ),
        WDiv(
          className: 'flex flex-col min-w-0 flex-1',
          children: [
            const WText(
              'This title is way too long and should be truncated properly in this flex container',
              className: 'truncate font-bold text-slate-900 dark:text-white',
            ),
            const WText(
              'Detailed description that also might run on a bit too long for the available space.',
              className: 'truncate text-sm text-slate-500',
            ),
          ],
        ),
      ],
    );
  }
}
