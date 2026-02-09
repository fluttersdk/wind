import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class DecorationColorExamplePage extends StatelessWidget {
  const DecorationColorExamplePage({super.key});

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
            title: 'Decoration Colors',
            description:
                'Utilities for controlling the color of text decorations.',
            child: WDiv(
              className: 'flex flex-col gap-4',
              children: [
                _buildDemo('decoration-slate-500', 'Slate Decoration'),
                _buildDemo('decoration-red-500', 'Red Decoration'),
                _buildDemo('decoration-orange-500', 'Orange Decoration'),
                _buildDemo('decoration-amber-500', 'Amber Decoration'),
                _buildDemo('decoration-green-500', 'Green Decoration'),
                _buildDemo('decoration-blue-500', 'Blue Decoration'),
                _buildDemo('decoration-indigo-500', 'Indigo Decoration'),
                _buildDemo('decoration-purple-500', 'Purple Decoration'),
                _buildDemo('decoration-pink-500', 'Pink Decoration'),
              ],
            ),
          ),
          _buildSection(
              title: 'Decoration Thickness',
              description:
                  'Combine with decoration thickness utilities for more control.',
              child: WDiv(
                className: 'flex flex-col gap-4',
                children: [
                  _buildDemo(
                      'decoration-red-500 decoration-1', 'Red + thin (1px)'),
                  _buildDemo('decoration-green-500 decoration-2',
                      'Green + medium (2px)'),
                  _buildDemo(
                      'decoration-blue-500 decoration-4', 'Blue + thick (4px)'),
                ],
              ))
        ],
      ),
    );
  }

  Widget _buildDemo(String className, String label) {
    return WDiv(
      className:
          'flex flex-col gap-2 p-4 border border-slate-200 dark:border-slate-700 rounded-lg',
      children: [
        WText(
          'The quick brown fox jumps over the lazy dog.',
          className:
              'text-xl underline decoration-2 $className text-slate-900 dark:text-white',
        ),
        WText(
          className,
          className: 'text-sm font-mono text-slate-500 dark:text-slate-400',
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className: 'bg-gradient-to-r from-blue-500 to-purple-600 rounded-xl p-6',
      child: WText(
        'Decoration Color',
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
}
