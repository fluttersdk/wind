import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class FontStyleBasicExamplePage extends StatelessWidget {
  const FontStyleBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Font Style',
      description:
          'italic and not-italic toggle FontStyle.italic on or off. Use the reset class to override an italic ancestor.',
      gradient: 'from-indigo-500 to-violet-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Apply italic to slant the text. not-italic restores upright.',
          child: WDiv(
            className: 'flex flex-col gap-2',
            children: const [
              _StyleRow(label: 'italic', cls: 'italic'),
              _StyleRow(label: 'not-italic', cls: 'not-italic'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Reset Pattern',
          description:
              'A parent applies italic; a child resets it with not-italic. Useful inside markdown-derived content.',
          child: WDiv(
            className: 'italic text-slate-900 dark:text-white',
            children: const [
              WText('This paragraph is italic by default.',
                  className: 'italic'),
              WText('This sentence resets to upright.',
                  className: 'not-italic'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Quick Reference',
          description: 'Two values, one toggle.',
          child: WDiv(
            className: 'flex flex-col gap-1',
            children: const [
              _RefRow(cls: 'italic', maps: 'FontStyle.italic'),
              _RefRow(cls: 'not-italic', maps: 'FontStyle.normal'),
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
          className: 'w-24 shrink-0',
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
  final String maps;

  const _RefRow({required this.cls, required this.maps});

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
          maps,
          className: 'font-mono text-sm text-slate-600 dark:text-slate-300',
        ),
      ],
    );
  }
}
