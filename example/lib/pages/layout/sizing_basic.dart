import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class SizingBasicExamplePage extends StatelessWidget {
  const SizingBasicExamplePage({super.key});

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
            title: 'Fixed Sizing',
            description: 'Use fixed values like w-16, h-16 (multiples of 4px).',
            child: WDiv(
              className: 'flex flex-wrap gap-4 items-end',
              children: [
                _buildBox('w-16 h-16', 'w-16 h-16 bg-blue-500'),
                _buildBox('w-24 h-24', 'w-24 h-24 bg-blue-600'),
                _buildBox('w-32 h-32', 'w-32 h-32 bg-blue-700'),
              ],
            ),
          ),
          _buildSection(
            title: 'Percentage Sizing',
            description:
                'Use fractions like 1/2, 1/3, full for relative sizing.',
            child: WDiv(
              className:
                  'flex flex-col gap-4 w-full bg-white dark:bg-slate-800 p-4 rounded-lg border border-slate-200 dark:border-slate-700',
              children: [
                _buildBox('w-1/4', 'w-1/4 h-12 bg-green-500'),
                _buildBox('w-1/2', 'w-1/2 h-12 bg-green-600'),
                _buildBox('w-3/4', 'w-3/4 h-12 bg-green-700'),
                _buildBox('w-full', 'w-full h-12 bg-green-800'),
              ],
            ),
          ),
          _buildSection(
            title: 'Viewport Sizing',
            description: 'Relative to the screen dimensions.',
            child: WDiv(
              className: 'flex flex-col gap-4',
              children: [
                WText('This box is w-screen (scroll horizontally to see)',
                    className: 'text-sm text-slate-500 mb-2'),
                WDiv(
                  className:
                      'w-screen h-16 bg-purple-500 flex items-center justify-center text-white font-mono mb-4',
                  child: WText('w-screen'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBox(String label, String classes) {
    return WDiv(
      className: '$classes rounded flex items-center justify-center shadow-sm',
      child: WText(label, className: 'text-white text-xs font-mono font-bold'),
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className:
          'bg-gradient-to-r from-indigo-500 to-blue-600 rounded-xl p-6 shadow-lg',
      child: WDiv(
        className: 'flex flex-col gap-2',
        children: [
          WText('Sizing Basics', className: 'text-2xl font-bold text-white'),
          WText('Core concepts for width and height utilities in Wind.',
              className: 'text-blue-100'),
        ],
      ),
    );
  }

  Widget _buildSection(
      {required String title,
      required String description,
      required Widget child}) {
    return WDiv(
      className: 'flex flex-col gap-4',
      children: [
        WDiv(
          className: 'flex flex-col gap-1',
          children: [
            WText(title,
                className: 'text-lg font-bold text-slate-900 dark:text-white'),
            WText(description,
                className: 'text-sm text-slate-600 dark:text-slate-400'),
          ],
        ),
        child,
      ],
    );
  }
}
