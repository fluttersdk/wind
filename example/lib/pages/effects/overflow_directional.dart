import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class OverflowDirectionalExamplePage extends StatelessWidget {
  const OverflowDirectionalExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Directional Overflow',
      description:
          'overflow-x-{mode} and overflow-y-{mode} target a single axis. Useful for horizontal tab bars or tall list panels.',
      gradient: 'from-purple-500 to-pink-600',
      children: [
        ExampleSection(
          title: 'Horizontal Scroll',
          description:
              'overflow-x-auto creates a horizontal scroll lane. Children stay at their intrinsic width.',
          child: WDiv(
            className: '''
              overflow-x-auto p-2 rounded-lg
              bg-white dark:bg-slate-800
            ''',
            child: WDiv(
              className: 'flex gap-2',
              children: List.generate(
                12,
                (i) => WDiv(
                  className: '''
                    shrink-0 w-32 h-20 rounded-lg
                    flex items-center justify-center
                    bg-gradient-to-br from-purple-400 to-pink-500
                  ''',
                  child: WText(
                    'Card ${i + 1}',
                    className: 'text-white font-medium',
                  ),
                ),
              ),
            ),
          ),
        ),
        ExampleSection(
          title: 'Vertical Scroll',
          description:
              'overflow-y-scroll always shows a vertical scroll lane, even when content fits.',
          child: WDiv(
            className: '''
              overflow-y-scroll h-40 p-3 rounded-lg
              bg-white dark:bg-slate-800
            ''',
            children: List.generate(
              16,
              (i) => WDiv(
                className: '''
                  py-2 border-b
                  border-slate-200 dark:border-slate-700
                ''',
                child: WText(
                  'List row ${i + 1}',
                  className: 'text-sm text-slate-700 dark:text-slate-300',
                ),
              ),
            ),
          ),
        ),
        ExampleSection(
          title: 'Cross-Axis Hidden',
          description:
              'overflow-x-scroll + overflow-y-hidden gives a strict horizontal lane with no vertical bleed.',
          child: WDiv(
            className: '''
              overflow-x-scroll overflow-y-hidden h-24
              p-2 rounded-lg
              bg-white dark:bg-slate-800
            ''',
            child: WDiv(
              className: 'flex items-center gap-2',
              children: List.generate(
                10,
                (i) => WDiv(
                  className: '''
                    shrink-0 w-20 h-16 rounded
                    bg-purple-500
                    flex items-center justify-center
                  ''',
                  child: WText(
                    '${i + 1}',
                    className: 'text-white font-bold',
                  ),
                ),
              ),
            ),
          ),
        ),
        ExampleSection(
          title: 'Quick Reference',
          description: 'Axis prefix + mode. Combine freely.',
          child: WDiv(
            className: 'flex flex-col gap-1',
            children: const [
              _RefRow(
                  cls: 'overflow-x-auto',
                  desc: 'Scroll horizontally when needed'),
              _RefRow(
                  cls: 'overflow-y-scroll', desc: 'Always scroll vertically'),
              _RefRow(
                  cls: 'overflow-x-hidden', desc: 'Clip horizontal overflow'),
              _RefRow(
                  cls: 'overflow-y-visible', desc: 'Allow vertical overflow'),
            ],
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
        WText(
          cls,
          className: 'font-mono text-sm text-purple-700 dark:text-purple-400',
        ),
        WText(
          desc,
          className:
              'flex-1 text-sm text-slate-600 dark:text-slate-300 text-right',
        ),
      ],
    );
  }
}
