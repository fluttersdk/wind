import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class BackgroundGradientBasicExamplePage extends StatelessWidget {
  const BackgroundGradientBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Background Gradient',
      description:
          'bg-gradient-to-{dir} + from-{color} (+ optional via, to) composes a linear gradient. Eight directions, three color stops.',
      gradient: 'from-cyan-400 to-blue-500',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description: 'Two-color gradient pointing right. The simplest form.',
          child: WDiv(
            className:
                'h-24 rounded-lg bg-gradient-to-r from-cyan-500 to-blue-500 flex items-center justify-center',
            child: const WText(
              'bg-gradient-to-r from-cyan-500 to-blue-500',
              className: 'text-white font-mono text-sm',
            ),
          ),
        ),
        ExampleSection(
          title: 'Three-Color Gradient',
          description:
              'Insert via-{color} for a three-stop gradient. Useful for rainbow strips and hero backgrounds.',
          child: WDiv(
            className:
                'h-24 rounded-lg bg-gradient-to-r from-indigo-500 via-purple-500 to-pink-500 flex items-center justify-center',
            child: const WText(
              'from-indigo-500 via-purple-500 to-pink-500',
              className: 'text-white font-mono text-sm',
            ),
          ),
        ),
        ExampleSection(
          title: 'Eight Directions',
          description:
              'bg-gradient-to-{t|tr|r|br|b|bl|l|tl}. Each cardinal + diagonal direction available.',
          child: WDiv(
            className: 'grid grid-cols-2 sm:grid-cols-4 gap-3',
            children: const [
              _DirTile(label: 'to-t', cls: 'bg-gradient-to-t'),
              _DirTile(label: 'to-tr', cls: 'bg-gradient-to-tr'),
              _DirTile(label: 'to-r', cls: 'bg-gradient-to-r'),
              _DirTile(label: 'to-br', cls: 'bg-gradient-to-br'),
              _DirTile(label: 'to-b', cls: 'bg-gradient-to-b'),
              _DirTile(label: 'to-bl', cls: 'bg-gradient-to-bl'),
              _DirTile(label: 'to-l', cls: 'bg-gradient-to-l'),
              _DirTile(label: 'to-tl', cls: 'bg-gradient-to-tl'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Dark Mode Pair',
          description:
              'Define separate gradient stops for light and dark with dark: prefixes.',
          child: WDiv(
            className: '''
              h-24 rounded-lg flex items-center justify-center
              bg-gradient-to-r from-slate-100 to-slate-200
              dark:from-slate-800 dark:to-slate-900
            ''',
            child: const WText(
              'from-slate-100 to-slate-200 dark:from-slate-800 dark:to-slate-900',
              className: 'text-slate-900 dark:text-white font-mono text-xs',
            ),
          ),
        ),
      ],
    );
  }
}

class _DirTile extends StatelessWidget {
  final String label;
  final String cls;

  const _DirTile({required this.label, required this.cls});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'flex flex-col gap-1 items-start',
      children: [
        WDiv(
          className: 'w-full h-16 rounded $cls from-cyan-400 to-blue-600',
        ),
        WText(
          label,
          className: 'font-mono text-xs text-slate-700 dark:text-slate-300',
        ),
      ],
    );
  }
}
