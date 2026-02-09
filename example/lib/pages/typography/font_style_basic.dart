import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class FontStyleBasicExamplePage extends StatelessWidget {
  const FontStyleBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className:
          'w-full h-full overflow-y-auto p-4 bg-slate-50 dark:bg-slate-900',
      scrollPrimary: true,
      child: WDiv(
        className: 'flex flex-col gap-6 max-w-4xl mx-auto',
        children: [
          _buildHeader(),
          _buildSection(
            title: 'Font Style',
            description:
                'Utilities for controlling the font style of an element.',
            child: WDiv(
              className: 'flex flex-col gap-8',
              children: [
                _buildStyleExample(
                  'italic',
                  'italic',
                  'The quick brown fox jumps over the lazy dog.',
                  'Use the italic utility to make text italic.',
                ),
                _buildStyleExample(
                  'not-italic',
                  'not-italic',
                  'The quick brown fox jumps over the lazy dog.',
                  'Use the not-italic utility to display text normally. This is typically used to reset italic text at different breakpoints.',
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
          'bg-gradient-to-r from-pink-500 to-rose-600 rounded-xl p-6 shadow-lg',
      child: WDiv(
        className: 'flex flex-col gap-2',
        children: [
          WText(
            'Font Style',
            className: 'text-3xl font-bold text-white',
          ),
          WText(
            'Utilities for controlling the font style of text.',
            className: 'text-pink-100 text-lg',
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
          'flex flex-col gap-4 p-6 bg-white dark:bg-slate-800 rounded-xl shadow-sm border border-slate-200 dark:border-slate-700',
      children: [
        WDiv(
          className:
              'flex flex-col gap-1 border-b border-slate-100 dark:border-slate-700 pb-4',
          children: [
            WText(title,
                className: 'text-xl font-bold text-slate-900 dark:text-white'),
            WText(description,
                className: 'text-sm text-slate-500 dark:text-slate-400'),
          ],
        ),
        child,
      ],
    );
  }

  Widget _buildStyleExample(
      String className, String label, String text, String description) {
    return WDiv(
      className: 'flex flex-col gap-3',
      children: [
        WDiv(
          className: 'flex items-baseline justify-between',
          children: [
            WText(label,
                className:
                    'text-sm font-medium text-pink-600 dark:text-pink-400 font-mono'),
          ],
        ),
        WDiv(
          className:
              'p-6 bg-slate-50 dark:bg-slate-900/50 rounded-lg border border-slate-100 dark:border-slate-700',
          child: WText(
            text,
            className: 'text-xl text-slate-900 dark:text-white $className',
          ),
        ),
        WText(
          description,
          className: 'text-sm text-slate-500 dark:text-slate-400',
        ),
      ],
    );
  }
}
