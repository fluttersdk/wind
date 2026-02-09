import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class FontWeightBasicExamplePage extends StatelessWidget {
  const FontWeightBasicExamplePage({super.key});

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
            title: 'Font Weights',
            description:
                'Utilities for controlling the font weight of an element.',
            child: WDiv(
              className: 'flex flex-col gap-4',
              children: [
                _buildWeightItem('font-thin', '100',
                    'The quick brown fox jumps over the lazy dog.'),
                _buildWeightItem('font-extralight', '200',
                    'The quick brown fox jumps over the lazy dog.'),
                _buildWeightItem('font-light', '300',
                    'The quick brown fox jumps over the lazy dog.'),
                _buildWeightItem('font-normal', '400',
                    'The quick brown fox jumps over the lazy dog.'),
                _buildWeightItem('font-medium', '500',
                    'The quick brown fox jumps over the lazy dog.'),
                _buildWeightItem('font-semibold', '600',
                    'The quick brown fox jumps over the lazy dog.'),
                _buildWeightItem('font-bold', '700',
                    'The quick brown fox jumps over the lazy dog.'),
                _buildWeightItem('font-extrabold', '800',
                    'The quick brown fox jumps over the lazy dog.'),
                _buildWeightItem('font-black', '900',
                    'The quick brown fox jumps over the lazy dog.'),
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
          'bg-gradient-to-r from-indigo-500 to-purple-600 rounded-xl p-6 shadow-lg',
      child: WDiv(
        className: 'flex flex-col gap-2',
        children: [
          WText(
            'Font Weight',
            className: 'text-3xl font-bold text-white',
          ),
          WText(
            'Control the font weight of text elements.',
            className: 'text-indigo-100 text-lg',
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

  Widget _buildWeightItem(String className, String weight, String text) {
    return WDiv(
      className:
          'flex flex-col md:flex-row md:items-center gap-2 md:gap-8 p-4 rounded-lg hover:bg-slate-50 dark:hover:bg-slate-700/50 transition-colors',
      children: [
        WDiv(
          className: 'w-32 flex-shrink-0',
          children: [
            WText(className,
                className:
                    'text-sm font-medium text-purple-600 dark:text-purple-400 font-mono'),
            WText('Weight $weight',
                className: 'text-xs text-slate-400 dark:text-slate-500'),
          ],
        ),
        WText(
          text,
          className:
              '$className text-lg text-slate-900 dark:text-white truncate',
        ),
      ],
    );
  }
}
