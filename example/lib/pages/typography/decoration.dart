import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class TypographyDecorationPage extends StatelessWidget {
  const TypographyDecorationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Text Decoration',
      description:
          'underline, overline, line-through. Combine with decoration-{color}, decoration-{style}, decoration-{thickness} for fine control.',
      gradient: 'from-orange-500 to-amber-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Four primitives cover the bulk of text decoration needs.',
          child: WDiv(
            className: 'flex flex-col gap-2',
            children: const [
              _DecoRow(label: 'underline', cls: 'underline'),
              _DecoRow(label: 'overline', cls: 'overline'),
              _DecoRow(label: 'line-through', cls: 'line-through'),
              _DecoRow(label: 'no-underline', cls: 'no-underline'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Composed Styling',
          description:
              'underline + decoration-blue-500 + decoration-wavy + decoration-2 is one className that combines color, style, and thickness.',
          child: const WText(
            'Styled Decoration',
            className:
                'underline decoration-blue-500 decoration-wavy decoration-2 text-lg text-slate-900 dark:text-white',
          ),
        ),
        ExampleSection(
          title: 'Quick Reference',
          description:
              'Decoration classes map cleanly to Flutter TextDecoration.',
          child: WDiv(
            className: 'flex flex-col gap-1',
            children: const [
              _RefRow(cls: 'underline', val: 'TextDecoration.underline'),
              _RefRow(cls: 'overline', val: 'TextDecoration.overline'),
              _RefRow(cls: 'line-through', val: 'TextDecoration.lineThrough'),
              _RefRow(cls: 'no-underline', val: 'TextDecoration.none'),
            ],
          ),
        ),
      ],
    );
  }
}

class _DecoRow extends StatelessWidget {
  final String label;
  final String cls;

  const _DecoRow({required this.label, required this.cls});

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
        WText(cls,
            className:
                'font-mono text-sm text-orange-700 dark:text-orange-400'),
        WText(val,
            className: 'font-mono text-sm text-slate-600 dark:text-slate-300'),
      ],
    );
  }
}
