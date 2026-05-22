import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class PositioningExamplePage extends StatelessWidget {
  const PositioningExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Positioning',
      description:
          'relative + absolute compose Flutter Stack and Positioned. Offsets (top/right/bottom/left), inset shortcuts, and negative pulls.',
      gradient: 'from-slate-600 to-slate-800',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'A relative parent becomes a Stack. Each absolute child becomes a Positioned widget.',
          child: WDiv(
            className: 'flex items-center justify-center p-4',
            child: WDiv(
              className: 'relative',
              children: [
                WDiv(
                  className:
                      'w-16 h-16 rounded-full bg-slate-300 dark:bg-slate-600',
                ),
                WDiv(
                  className: '''
                    absolute top-0 right-0
                    w-4 h-4 rounded-full
                    bg-red-500 border-2 border-white dark:border-slate-800
                  ''',
                ),
              ],
            ),
          ),
        ),
        ExampleSection(
          title: 'Offset Utilities',
          description:
              'top-{n}, right-{n}, bottom-{n}, left-{n} take values from the spacing scale (base 4px).',
          child: WDiv(
            className: '''
              relative h-48 rounded-lg
              bg-white dark:bg-slate-800
              border border-slate-200 dark:border-slate-700
            ''',
            children: [
              WDiv(
                className: '''
                  absolute top-2 left-2 px-3 py-1 rounded
                  bg-blue-500
                ''',
                child: const WText('top-2 left-2',
                    className: 'text-white text-sm font-mono'),
              ),
              WDiv(
                className: '''
                  absolute top-2 right-2 px-3 py-1 rounded
                  bg-emerald-500
                ''',
                child: const WText('top-2 right-2',
                    className: 'text-white text-sm font-mono'),
              ),
              WDiv(
                className: '''
                  absolute bottom-2 left-2 px-3 py-1 rounded
                  bg-amber-500
                ''',
                child: const WText('bottom-2 left-2',
                    className: 'text-white text-sm font-mono'),
              ),
              WDiv(
                className: '''
                  absolute bottom-2 right-2 px-3 py-1 rounded
                  bg-rose-500
                ''',
                child: const WText('bottom-2 right-2',
                    className: 'text-white text-sm font-mono'),
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Inset Shortcuts',
          description:
              'inset-0 fills all four sides. inset-x-{n} and inset-y-{n} target a single axis.',
          child: WDiv(
            className: '''
              relative w-full h-48 rounded-xl overflow-hidden
            ''',
            children: [
              WDiv(
                className: '''
                  w-full h-full
                  bg-gradient-to-br from-indigo-500 to-purple-600
                ''',
              ),
              WDiv(
                className: '''
                  absolute inset-0 flex items-end p-4
                  bg-gradient-to-t from-black/60 to-transparent
                ''',
                child: const WText(
                  'absolute inset-0',
                  className: 'text-white text-lg font-semibold',
                ),
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Negative Offsets',
          description:
              'Prefix with - to pull a child outside its parent. Classic for notification badges that overlap an icon corner.',
          child: WDiv(
            className: 'flex items-center justify-center p-6',
            child: WDiv(
              className: 'relative',
              children: [
                WDiv(
                  className: '''
                    w-12 h-12 rounded-lg
                    bg-slate-200 dark:bg-slate-700
                    flex items-center justify-center
                  ''',
                  child: WIcon(
                    Icons.notifications_outlined,
                    className: 'text-slate-700 dark:text-slate-200',
                  ),
                ),
                WDiv(
                  className: '''
                    absolute -top-1 -right-1
                    w-5 h-5 rounded-full bg-red-500
                    border-2 border-white dark:border-slate-800
                    flex items-center justify-center
                  ''',
                  child: const WText(
                    '3',
                    className: 'text-[10px] text-white font-bold',
                  ),
                ),
              ],
            ),
          ),
        ),
        ExampleSection(
          title: 'Quick Reference',
          description: 'Position types and the most common offset shortcuts.',
          child: WDiv(
            className: 'flex flex-col gap-1',
            children: const [
              _RefRow(cls: 'relative', maps: 'Stack parent'),
              _RefRow(cls: 'absolute', maps: 'Positioned child'),
              _RefRow(cls: 'top-{n}', maps: 'Distance from top'),
              _RefRow(cls: 'inset-0', maps: 'All four sides'),
              _RefRow(cls: '-top-{n}', maps: 'Pull above parent'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Arbitrary Pixels',
          description:
              'Bracket notation accepts exact pixel values. Percentages are not supported (Positioned uses logical pixels).',
          child: WDiv(
            className: '''
              relative h-24 rounded-lg
              bg-white dark:bg-slate-800
              border border-slate-200 dark:border-slate-700
            ''',
            children: [
              WDiv(
                className: '''
                  absolute top-[12px] left-[24px]
                  px-3 py-1 rounded bg-indigo-500
                ''',
                child: const WText(
                  'top-[12px] left-[24px]',
                  className: 'text-white text-sm font-mono',
                ),
              ),
            ],
          ),
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
        flex flex-row items-center gap-3
        px-3 py-2 rounded-md
        bg-slate-50 dark:bg-slate-700/40
      ''',
      children: [
        WDiv(
          className: 'w-32 shrink-0',
          child: WText(
            cls,
            className: 'font-mono text-sm text-slate-700 dark:text-slate-300',
          ),
        ),
        WText(
          maps,
          className: 'flex-1 text-sm text-slate-600 dark:text-slate-400',
        ),
      ],
    );
  }
}
