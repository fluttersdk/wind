import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class TextTransformExamplePage extends StatelessWidget {
  const TextTransformExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Text Transform',
      description:
          'uppercase, lowercase, capitalize. Pair with normal-case to reset an ancestor transform on a child.',
      gradient: 'from-teal-500 to-emerald-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Each row uses a different transform. The source text stays the same; only the rendered case changes.',
          child: WDiv(
            className: 'flex flex-col gap-2',
            children: const [
              _TransformRow(label: 'uppercase', cls: 'uppercase'),
              _TransformRow(label: 'lowercase', cls: 'lowercase'),
              _TransformRow(label: 'capitalize', cls: 'capitalize'),
              _TransformRow(label: 'normal-case', cls: 'normal-case'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Headline Styling',
          description:
              'uppercase + tracking-widest + small text size is a classic section label pattern.',
          child: const WText(
            'featured projects',
            className:
                'uppercase tracking-widest text-sm font-bold text-teal-700 dark:text-teal-400',
          ),
        ),
        ExampleSection(
          title: 'Quick Reference',
          description:
              'Four named transforms. capitalize uppercases the first letter of each word.',
          child: WDiv(
            className: 'flex flex-col gap-1',
            children: const [
              _RefRow(cls: 'uppercase', val: 'UPPERCASE'),
              _RefRow(cls: 'lowercase', val: 'lowercase'),
              _RefRow(cls: 'capitalize', val: 'Title Case'),
              _RefRow(cls: 'normal-case', val: 'Mixed source (reset)'),
            ],
          ),
        ),
      ],
    );
  }
}

class _TransformRow extends StatelessWidget {
  final String label;
  final String cls;

  const _TransformRow({required this.label, required this.cls});

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
          'The quick brown Fox',
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
        WText(cls,
            className: 'font-mono text-sm text-teal-700 dark:text-teal-400'),
        WText(val, className: 'text-sm text-slate-600 dark:text-slate-300'),
      ],
    );
  }
}
