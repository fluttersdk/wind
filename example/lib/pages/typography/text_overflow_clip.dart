import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class TextOverflowClipExamplePage extends StatelessWidget {
  const TextOverflowClipExamplePage({super.key});

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
            title: 'Text Clip',
            description:
                'Use text-clip to clip text at the bounds of the container without an ellipsis. This effectively just hides the overflow.',
            child: _buildExample(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className: 'bg-gradient-to-r from-pink-500 to-rose-600 rounded-xl p-6',
      child: WText(
        'Text Overflow: Clip',
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
      className: 'flex flex-col gap-6',
      children: [
        WDiv(
          className:
              'w-64 bg-white dark:bg-slate-800 p-4 rounded border border-slate-200 dark:border-slate-700',
          children: [
            WText('Default (Wrap):', className: 'text-xs text-slate-400 mb-1'),
            const WText(
              'The quick brown fox jumps over the lazy dog and runs away.',
              className: 'text-slate-900 dark:text-white',
            ),
          ],
        ),
        WDiv(
          className:
              'w-64 bg-white dark:bg-slate-800 p-4 rounded border border-slate-200 dark:border-slate-700',
          children: [
            WText('With text-clip (and whitespace-nowrap):',
                className: 'text-xs text-slate-400 mb-1'),
            const WText(
              'The quick brown fox jumps over the lazy dog and runs away.',
              className:
                  'text-clip whitespace-nowrap overflow-hidden text-slate-900 dark:text-white',
            ),
          ],
        ),
      ],
    );
  }
}
