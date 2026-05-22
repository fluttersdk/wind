import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class TextColorBasicExamplePage extends StatelessWidget {
  const TextColorBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Text Color',
      description:
          'text-{color}-{shade} pulls from the theme palette. Combine with dark: to ship a single string that works in both modes.',
      gradient: 'from-red-500 to-orange-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Pick a color name and a shade (50-950). Every Tailwind color is available out of the box.',
          child: WDiv(
            className: 'flex flex-col gap-2',
            children: const [
              _ColorRow(label: 'text-red-500', cls: 'text-red-500'),
              _ColorRow(label: 'text-green-600', cls: 'text-green-600'),
              _ColorRow(label: 'text-blue-500', cls: 'text-blue-500'),
              _ColorRow(label: 'text-amber-500', cls: 'text-amber-500'),
              _ColorRow(label: 'text-purple-600', cls: 'text-purple-600'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Slate Palette',
          description:
              'A common neutral scale. Use lower shades for backgrounds, higher shades for body text.',
          child: WDiv(
            className: 'flex flex-col gap-1',
            children: const [
              _ColorRow(
                  label: 'text-slate-900',
                  cls: 'text-slate-900 dark:text-white'),
              _ColorRow(
                  label: 'text-slate-700',
                  cls: 'text-slate-700 dark:text-slate-200'),
              _ColorRow(
                  label: 'text-slate-500',
                  cls: 'text-slate-500 dark:text-slate-400'),
              _ColorRow(
                  label: 'text-slate-400',
                  cls: 'text-slate-400 dark:text-slate-500'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Special Tokens',
          description:
              'text-white, text-black, and text-transparent are always available.',
          child: WDiv(
            className: '''
              p-4 rounded-lg
              bg-gradient-to-r from-red-500 to-orange-600
            ''',
            children: const [
              WText('text-white',
                  className: 'text-white font-semibold text-lg'),
              WText('text-black',
                  className: 'text-black font-semibold text-lg'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Arbitrary Hex',
          description:
              'text-[#RRGGBB] applies an exact hex color. Useful for brand colors not registered in the theme.',
          child: const WText(
            'text-[#50d71e]',
            className: 'text-[#50d71e] text-lg font-mono',
          ),
        ),
      ],
    );
  }
}

class _ColorRow extends StatelessWidget {
  final String label;
  final String cls;

  const _ColorRow({required this.label, required this.cls});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'flex flex-row items-baseline gap-4',
      children: [
        WDiv(
          className: 'w-40 shrink-0',
          child: WText(
            label,
            className: 'font-mono text-xs text-slate-500 dark:text-slate-400',
          ),
        ),
        WText(
          'The quick brown fox',
          className: '$cls text-lg',
        ),
      ],
    );
  }
}
