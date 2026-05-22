import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class BackgroundColorBasicExamplePage extends StatelessWidget {
  const BackgroundColorBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Background Color',
      description:
          'bg-{color}-{shade} pulls from the theme palette. Pair with dark: to ship one className that works in both modes.',
      gradient: 'from-blue-500 to-indigo-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Pick a color name and shade. Every Tailwind color is built in.',
          child: WDiv(
            className: 'wrap gap-3',
            children: const [
              _Swatch(label: 'bg-blue-500', cls: 'bg-blue-500'),
              _Swatch(label: 'bg-red-500', cls: 'bg-red-500'),
              _Swatch(label: 'bg-green-500', cls: 'bg-green-500'),
              _Swatch(label: 'bg-amber-500', cls: 'bg-amber-500'),
              _Swatch(label: 'bg-purple-600', cls: 'bg-purple-600'),
              _Swatch(label: 'bg-slate-900', cls: 'bg-slate-900'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Special Tokens',
          description:
              'bg-white, bg-black, and bg-transparent are always available.',
          child: WDiv(
            className: 'wrap gap-3',
            children: const [
              _Swatch(
                  label: 'bg-white', cls: 'bg-white border border-slate-200'),
              _Swatch(label: 'bg-black', cls: 'bg-black'),
              _Swatch(
                label: 'bg-transparent',
                cls: 'bg-transparent border-2 border-dashed border-slate-400',
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Dark-Mode Adaptive',
          description:
              'Pair light + dark in the same className for one-line theming.',
          child: WDiv(
            className: '''
              p-6 rounded-lg
              bg-white dark:bg-slate-900
              border border-gray-200 dark:border-slate-800
            ''',
            child: const WText(
              'bg-white dark:bg-slate-900',
              className: 'font-mono text-sm text-gray-900 dark:text-white',
            ),
          ),
        ),
        ExampleSection(
          title: 'Arbitrary Hex',
          description: 'bg-[#RRGGBB] applies an exact color outside the theme.',
          child: WDiv(
            className: 'wrap gap-3',
            children: const [
              _Swatch(label: 'bg-[#1da1f2]', cls: 'bg-[#1da1f2]'),
              _Swatch(label: 'bg-[#ff5722]', cls: 'bg-[#ff5722]'),
              _Swatch(label: 'bg-[#7c3aed]', cls: 'bg-[#7c3aed]'),
            ],
          ),
        ),
      ],
    );
  }
}

class _Swatch extends StatelessWidget {
  final String label;
  final String cls;

  const _Swatch({required this.label, required this.cls});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'flex flex-col gap-2 items-start',
      children: [
        WDiv(className: 'w-20 h-20 rounded-lg $cls'),
        WText(
          label,
          className: 'font-mono text-xs text-slate-700 dark:text-slate-300',
        ),
      ],
    );
  }
}
