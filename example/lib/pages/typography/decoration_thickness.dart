import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class DecorationThicknessExamplePage extends StatelessWidget {
  const DecorationThicknessExamplePage({super.key});

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
            title: 'Decoration Thickness',
            description:
                'Utilities for controlling the thickness of text decorations.',
            child: WDiv(
              className: 'flex flex-col gap-4',
              children: [
                _buildDemo('decoration-0', '0px Thickness'),
                _buildDemo('decoration-1', '1px Thickness'),
                _buildDemo('decoration-2', '2px Thickness'),
                _buildDemo('decoration-4', '4px Thickness'),
                _buildDemo('decoration-8', '8px Thickness'),
              ],
            ),
          ),
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
              'text-xl underline decoration-blue-500 $className text-slate-900 dark:text-white',
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
        'Decoration Thickness',
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
