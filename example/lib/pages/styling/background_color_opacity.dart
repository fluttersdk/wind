import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class BackgroundColorOpacityExamplePage extends StatelessWidget {
  const BackgroundColorOpacityExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'w-full h-full overflow-y-auto p-4 bg-white dark:bg-slate-900',
      scrollPrimary: true,
      child: WDiv(
        className: 'flex flex-col gap-8 max-w-5xl mx-auto',
        children: [
          _buildHeader(),
          _buildOpacitySection(),
          _buildGridExamples(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className:
          'flex flex-col gap-2 pb-4 border-b border-slate-200 dark:border-slate-800',
      children: [
        WText(
          'Background Opacity',
          className: 'text-3xl font-bold text-slate-900 dark:text-white',
        ),
        WText(
          'Utilities for controlling the opacity of an element\'s background color.',
          className: 'text-lg text-slate-600 dark:text-slate-400',
        ),
      ],
    );
  }

  Widget _buildOpacitySection() {
    final opacities = [
      0,
      5,
      10,
      20,
      25,
      30,
      40,
      50,
      60,
      70,
      75,
      80,
      90,
      95,
      100
    ];

    return WDiv(
      className: 'flex flex-col gap-4',
      children: [
        WText(
          'Opacity Scale',
          className: 'text-lg font-semibold text-slate-900 dark:text-white',
        ),
        WDiv(
          className:
              'bg-stripes-slate-100 dark:bg-stripes-slate-800 p-4 rounded-xl',
          child: WDiv(
            className: 'grid grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-4',
            children: opacities.map((opacity) {
              final className = 'bg-blue-600/$opacity';

              return WDiv(
                className: 'flex flex-col gap-2',
                children: [
                  WDiv(
                    className:
                        '$className h-16 rounded-lg shadow-sm border border-slate-200 dark:border-slate-700',
                  ),
                  WText(
                    'bg-blue-600/$opacity',
                    className:
                        'text-xs font-mono text-slate-600 dark:text-slate-400 text-center',
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildGridExamples() {
    return WDiv(
      className: 'flex flex-col gap-4',
      children: [
        WText(
          'Practical Examples',
          className: 'text-lg font-semibold text-slate-900 dark:text-white',
        ),
        WDiv(
          className: 'grid grid-cols-1 md:grid-cols-2 gap-6',
          children: [
            _buildExampleCard('bg-red-500/10', 'bg-red-500/10',
                'text-red-700 dark:text-red-300'),
            _buildExampleCard('bg-green-500/20', 'bg-green-500/20',
                'text-green-700 dark:text-green-300'),
            _buildExampleCard('bg-purple-600/30', 'bg-purple-600/30',
                'text-purple-700 dark:text-purple-300'),
            _buildExampleCard('bg-amber-500/15', 'bg-amber-500/15',
                'text-amber-800 dark:text-amber-200'),
          ],
        ),
      ],
    );
  }

  Widget _buildExampleCard(String bgClass, String label, String textClass) {
    return WDiv(
      className: '$bgClass p-6 rounded-xl flex items-center justify-between',
      children: [
        WDiv(
          className: 'flex flex-col',
          children: [
            WText('Status Label', className: 'font-semibold $textClass'),
            WText('Description text here',
                className: 'text-sm opacity-80 $textClass'),
          ],
        ),
        WText(
          label,
          className:
              'text-xs font-mono py-1 px-2 bg-white/50 dark:bg-black/20 rounded $textClass',
        ),
      ],
    );
  }
}
