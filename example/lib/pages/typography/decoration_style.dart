import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class DecorationStyleExamplePage extends StatelessWidget {
  const DecorationStyleExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Decoration Style',
      description:
          'decoration-{style} changes the shape of the underline: solid (default), double, dotted, dashed, or wavy.',
      gradient: 'from-orange-500 to-amber-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Five styles. Pair with decoration-{color} and decoration-{thickness} for fine control.',
          child: WDiv(
            className: 'flex flex-col gap-2',
            children: const [
              _StyleRow(
                  label: 'decoration-solid', cls: 'underline decoration-solid'),
              _StyleRow(
                  label: 'decoration-double',
                  cls: 'underline decoration-double'),
              _StyleRow(
                  label: 'decoration-dotted',
                  cls: 'underline decoration-dotted'),
              _StyleRow(
                  label: 'decoration-dashed',
                  cls: 'underline decoration-dashed'),
              _StyleRow(
                  label: 'decoration-wavy', cls: 'underline decoration-wavy'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Quick Reference',
          description: 'Five named values mirror CSS text-decoration-style.',
          child: WDiv(
            className: 'flex flex-col gap-1',
            children: const [
              _RefRow(cls: 'decoration-solid', desc: 'Single straight line'),
              _RefRow(cls: 'decoration-double', desc: 'Two parallel lines'),
              _RefRow(cls: 'decoration-dotted', desc: 'Series of dots'),
              _RefRow(cls: 'decoration-dashed', desc: 'Series of dashes'),
              _RefRow(cls: 'decoration-wavy', desc: 'Squiggly underline'),
            ],
          ),
        ),
      ],
    );
  }
}

class _StyleRow extends StatelessWidget {
  final String label;
  final String cls;

  const _StyleRow({required this.label, required this.cls});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'flex flex-row items-baseline gap-4',
      children: [
        WDiv(
          className: 'w-48 shrink-0',
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
  final String desc;

  const _RefRow({required this.cls, required this.desc});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: '''
        flex flex-row items-center justify-between
        px-3 py-2 rounded-md
        bg-slate-50 dark:bg-slate-700/40
      ''',
      children: [
        WText(cls,
            className:
                'font-mono text-sm text-orange-700 dark:text-orange-400'),
        WText(desc, className: 'text-sm text-slate-600 dark:text-slate-300'),
      ],
    );
  }
}
