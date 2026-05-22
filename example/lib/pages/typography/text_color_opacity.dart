import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class TextColorOpacityExamplePage extends StatelessWidget {
  const TextColorOpacityExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Text Color Opacity',
      description:
          'Append /N to any color utility to apply N percent alpha. text-blue-500/50 = the blue with 50 percent opacity.',
      gradient: 'from-red-500 to-orange-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Same color, descending opacity. The slash takes any integer 0-100.',
          child: WDiv(
            className: 'flex flex-col gap-2',
            children: const [
              _Row(label: 'text-blue-500', cls: 'text-blue-500'),
              _Row(label: 'text-blue-500/75', cls: 'text-blue-500/75'),
              _Row(label: 'text-blue-500/50', cls: 'text-blue-500/50'),
              _Row(label: 'text-blue-500/25', cls: 'text-blue-500/25'),
              _Row(label: 'text-blue-500/10', cls: 'text-blue-500/10'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Quick Reference',
          description:
              'Opacity modifier syntax is universal across text-, bg-, border-, and ring- utilities.',
          child: WDiv(
            className: 'flex flex-col gap-1',
            children: const [
              _RefRow(cls: 'text-{color}/0', val: 'transparent'),
              _RefRow(cls: 'text-{color}/50', val: '50% alpha'),
              _RefRow(cls: 'text-{color}/100', val: 'fully opaque (default)'),
            ],
          ),
        ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String cls;

  const _Row({required this.label, required this.cls});

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
        WText(cls,
            className: 'font-mono text-sm text-red-700 dark:text-red-400'),
        WText(val,
            className: 'font-mono text-sm text-slate-600 dark:text-slate-300'),
      ],
    );
  }
}
