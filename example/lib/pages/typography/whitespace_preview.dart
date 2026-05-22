import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class WhitespacePreviewExamplePage extends StatelessWidget {
  const WhitespacePreviewExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Whitespace & Wrapping',
      description:
          'whitespace-nowrap forces single-line. whitespace-normal restores wrapping. text-balance balances lines for headings.',
      gradient: 'from-teal-500 to-emerald-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Same text inside the same width container. The whitespace utility decides whether it wraps.',
          child: WDiv(
            className: 'flex flex-col gap-3',
            children: const [
              _WhitespaceTile(
                label: 'whitespace-normal',
                cls: 'whitespace-normal',
              ),
              _WhitespaceTile(
                label: 'whitespace-nowrap',
                cls: 'whitespace-nowrap overflow-hidden',
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Quick Reference',
          description: 'Five aliases cover the same conceptual space.',
          child: WDiv(
            className: 'flex flex-col gap-1',
            children: const [
              _RefRow(
                  cls: 'whitespace-normal', desc: 'softWrap: true (default)'),
              _RefRow(cls: 'whitespace-nowrap', desc: 'softWrap: false'),
              _RefRow(cls: 'text-wrap', desc: 'Alias of whitespace-normal'),
              _RefRow(cls: 'text-nowrap', desc: 'Alias of whitespace-nowrap'),
              _RefRow(cls: 'text-balance', desc: 'Balance lines for headings'),
            ],
          ),
        ),
      ],
    );
  }
}

class _WhitespaceTile extends StatelessWidget {
  final String label;
  final String cls;

  const _WhitespaceTile({required this.label, required this.cls});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: '''
        flex flex-col gap-1 p-3 rounded-lg
        bg-slate-50 dark:bg-slate-700/40
      ''',
      children: [
        WText(
          label,
          className: 'font-mono text-xs text-slate-500 dark:text-slate-400',
        ),
        WDiv(
          className: 'w-64',
          child: WText(
            'This is a single sentence that may or may not wrap depending on the utility you apply.',
            className: '$cls text-sm text-slate-900 dark:text-white',
          ),
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
            className: 'font-mono text-sm text-teal-700 dark:text-teal-400'),
        WText(desc, className: 'text-sm text-slate-600 dark:text-slate-300'),
      ],
    );
  }
}
