import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class FontWeightBasicExamplePage extends StatelessWidget {
  const FontWeightBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Font Weight',
      description:
          'Nine named weights from font-thin (100) through font-black (900). Every step maps directly to a Flutter FontWeight constant.',
      gradient: 'from-indigo-500 to-violet-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Each row applies a different font-{name}. Watch the strokes thicken from top to bottom.',
          child: WDiv(
            className: 'flex flex-col gap-2',
            children: const [
              _WeightRow(label: 'font-thin', cls: 'font-thin'),
              _WeightRow(label: 'font-extralight', cls: 'font-extralight'),
              _WeightRow(label: 'font-light', cls: 'font-light'),
              _WeightRow(label: 'font-normal', cls: 'font-normal'),
              _WeightRow(label: 'font-medium', cls: 'font-medium'),
              _WeightRow(label: 'font-semibold', cls: 'font-semibold'),
              _WeightRow(label: 'font-bold', cls: 'font-bold'),
              _WeightRow(label: 'font-extrabold', cls: 'font-extrabold'),
              _WeightRow(label: 'font-black', cls: 'font-black'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Quick Reference',
          description:
              'Each name maps to a numeric weight that Flutter exposes as FontWeight.wN.',
          child: WDiv(
            className: 'flex flex-col gap-1',
            children: const [
              _RefRow(cls: 'font-thin', val: '100'),
              _RefRow(cls: 'font-light', val: '300'),
              _RefRow(cls: 'font-normal', val: '400 (default)'),
              _RefRow(cls: 'font-medium', val: '500'),
              _RefRow(cls: 'font-semibold', val: '600'),
              _RefRow(cls: 'font-bold', val: '700'),
              _RefRow(cls: 'font-black', val: '900'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Responsive Weight',
          description:
              'Normal on mobile, bold on md+. Useful for headings that scale up on desktop.',
          child: const WText(
            'Responsive Weight',
            className:
                'font-normal md:font-bold text-xl text-slate-900 dark:text-white',
          ),
        ),
        ExampleSection(
          title: 'Arbitrary Weight',
          description:
              'font-[N] accepts an integer. Wind maps it to the nearest standard weight.',
          child: const WText(
            'font-[550]',
            className: 'font-[550] text-lg text-slate-900 dark:text-white',
          ),
        ),
      ],
    );
  }
}

class _WeightRow extends StatelessWidget {
  final String label;
  final String cls;

  const _WeightRow({required this.label, required this.cls});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'flex flex-row items-baseline gap-4',
      children: [
        WDiv(
          className: 'w-32 shrink-0',
          child: WText(
            label,
            className: 'font-mono text-xs text-slate-500 dark:text-slate-400',
          ),
        ),
        WText(
          'The quick brown fox',
          className: '$cls text-lg text-slate-900 dark:text-white',
        ),
      ],
    );
  }
}

class _RefRow extends StatelessWidget {
  final String cls;
  final String val;

  const _RefRow({required this.cls, required this.val});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: '''
        flex flex-row items-center justify-between
        px-3 py-2 rounded-md
        bg-slate-50 dark:bg-slate-700/40
      ''',
      children: [
        WText(
          cls,
          className: 'font-mono text-sm text-indigo-700 dark:text-indigo-400',
        ),
        WText(
          val,
          className: 'font-mono text-sm text-slate-600 dark:text-slate-300',
        ),
      ],
    );
  }
}
