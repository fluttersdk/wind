import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class DirectionalExamplePage extends StatelessWidget {
  const DirectionalExamplePage({super.key});

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
            title: 'Padding Directions',
            description: 'Control padding on specific sides or axes.',
            child: _buildPaddingDemo(),
          ),
          _buildSection(
            title: 'Margin Directions',
            description: 'Control margin on specific sides or axes.',
            child: _buildMarginDemo(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className: 'bg-gradient-to-r from-emerald-500 to-teal-600 rounded-xl p-6',
      child: WText(
        'Directional Spacing',
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

  Widget _buildPaddingDemo() {
    return WDiv(
      className: 'flex flex-col gap-4',
      children: [
        WText('Axis Padding',
            className: 'text-sm font-bold uppercase text-slate-500 mt-2'),
        WDiv(
          className: 'grid grid-cols-1 md:grid-cols-2 gap-4',
          children: [
            _buildPaddingVisualizer('px-8 (Horizontal)', 'px-8', 'bg-blue-500'),
            _buildPaddingVisualizer('py-8 (Vertical)', 'py-8', 'bg-purple-500'),
          ],
        ),
        WText('Side Padding',
            className: 'text-sm font-bold uppercase text-slate-500 mt-2'),
        WDiv(
          className: 'grid grid-cols-1 md:grid-cols-2 gap-4',
          children: [
            _buildPaddingVisualizer('pt-8 (Top)', 'pt-8', 'bg-indigo-500'),
            _buildPaddingVisualizer('pb-8 (Bottom)', 'pb-8', 'bg-pink-500'),
            _buildPaddingVisualizer('pl-8 (Left)', 'pl-8', 'bg-orange-500'),
            _buildPaddingVisualizer('pr-8 (Right)', 'pr-8', 'bg-teal-500'),
          ],
        ),
      ],
    );
  }

  Widget _buildMarginDemo() {
    return WDiv(className: 'flex flex-col gap-4', children: [
      WText('Axis Margin',
          className: 'text-sm font-bold uppercase text-slate-500 mt-2'),
      WDiv(className: 'grid grid-cols-1 md:grid-cols-2 gap-4', children: [
        _buildMarginVisualizer('mx-8 (Horizontal)', 'mx-8'),
        _buildMarginVisualizer('my-8 (Vertical)', 'my-8'),
      ]),
      WText('Side Margin',
          className: 'text-sm font-bold uppercase text-slate-500 mt-2'),
      WDiv(className: 'grid grid-cols-1 md:grid-cols-2 gap-4', children: [
        _buildMarginVisualizer('mt-4 (Top)', 'mt-4'),
        _buildMarginVisualizer('mb-4 (Bottom)', 'mb-4'),
        _buildMarginVisualizer('ml-8 (Left)', 'ml-8'),
        _buildMarginVisualizer('mr-8 (Right)', 'mr-8'),
      ]),
    ]);
  }

  Widget _buildPaddingVisualizer(
      String label, String className, String colorClass) {
    return WDiv(
      className: 'flex flex-col gap-2',
      children: [
        WText(label,
            className:
                'text-xs font-medium text-slate-500 dark:text-slate-400'),
        WDiv(
          className: '$colorClass rounded-lg',
          child: WDiv(
            className:
                '$className bg-white/20', // visible padding area via transparency
            child: WDiv(
              className:
                  'bg-white dark:bg-slate-900 rounded p-3 flex justify-center items-center',
              child: WText(className,
                  className:
                      'font-mono text-xs text-slate-900 dark:text-white'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMarginVisualizer(String label, String className) {
    return WDiv(
      className: 'flex flex-col gap-2',
      children: [
        WText(label,
            className:
                'text-xs font-medium text-slate-500 dark:text-slate-400'),
        WDiv(
          className:
              'bg-amber-100 dark:bg-amber-900/20 border border-amber-200 dark:border-amber-800 rounded-lg',
          child: WDiv(
            className:
                '$className bg-blue-500 text-white p-3 rounded text-center text-xs font-mono',
            child: WText(className),
          ),
        ),
      ],
    );
  }
}
