import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class LetterSpacingExamplePage extends StatelessWidget {
  const LetterSpacingExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Letter Spacing',
      description:
          'tracking-{key} controls letterSpacing in em, as in Tailwind: a multiple of the font size, from tighter (-0.05em) to widest (0.1em).',
      gradient: 'from-purple-500 to-fuchsia-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Each row demonstrates a different tracking value. Watch the gaps between characters change.',
          child: WDiv(
            className: 'flex flex-col gap-2',
            children: const [
              _TrackRow(label: 'tracking-tighter', cls: 'tracking-tighter'),
              _TrackRow(label: 'tracking-tight', cls: 'tracking-tight'),
              _TrackRow(label: 'tracking-normal', cls: 'tracking-normal'),
              _TrackRow(label: 'tracking-wide', cls: 'tracking-wide'),
              _TrackRow(label: 'tracking-wider', cls: 'tracking-wider'),
              _TrackRow(label: 'tracking-widest', cls: 'tracking-widest'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Headline Styling',
          description:
              'Wide tracking with uppercase makes for striking section labels.',
          child: const WText(
            'TYPOGRAPHIC SCALE',
            className:
                'tracking-widest text-sm font-bold uppercase text-purple-700 dark:text-purple-400',
          ),
        ),
        ExampleSection(
          title: 'Quick Reference',
          description:
              'Six built-in em steps. The pixels shown are for 14px text (text-sm).',
          child: WDiv(
            className: 'flex flex-col gap-1',
            children: const [
              _RefRow(cls: 'tracking-tighter', val: '-0.05em (-0.7)'),
              _RefRow(cls: 'tracking-tight', val: '-0.025em (-0.35)'),
              _RefRow(cls: 'tracking-normal', val: '0em (default)'),
              _RefRow(cls: 'tracking-wide', val: '0.025em (0.35)'),
              _RefRow(cls: 'tracking-wider', val: '0.05em (0.7)'),
              _RefRow(cls: 'tracking-widest', val: '0.1em (1.4)'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Arbitrary Tracking',
          description:
              'tracking-[6px] applies exact logical pixels at any size; tracking-[-0.02em] scales with the font size.',
          child: WDiv(
            className: 'flex flex-col gap-2',
            children: const [
              WText(
                'B R A N D',
                className:
                    'tracking-[6px] text-xl font-bold text-slate-900 dark:text-white',
              ),
              WText(
                'Quarterly results',
                className:
                    'tracking-[-0.02em] text-3xl font-semibold text-slate-900 dark:text-white',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TrackRow extends StatelessWidget {
  final String label;
  final String cls;

  const _TrackRow({required this.label, required this.cls});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'flex flex-row items-baseline gap-4',
      children: [
        WDiv(
          className: 'w-36 shrink-0',
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
          className: 'font-mono text-sm text-purple-700 dark:text-purple-400',
        ),
        WText(
          val,
          className: 'font-mono text-sm text-slate-600 dark:text-slate-300',
        ),
      ],
    );
  }
}
