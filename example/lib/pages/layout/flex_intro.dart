import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class FlexIntroExamplePage extends StatelessWidget {
  const FlexIntroExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Flexbox & Layout',
      description:
          'flex turns WDiv into a Row/Column. Pair with flex-row, flex-col, gap-*, items-*, justify-* to compose layouts.',
      gradient: 'from-orange-500 to-red-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'flex defaults to a horizontal row. gap-4 inserts spacing between children. items-center centers along the cross axis.',
          child: WDiv(
            className: '''
              flex items-center gap-4 p-4 rounded-lg
              bg-white dark:bg-slate-800
            ''',
            children: const [
              _Pill(label: 'Logo', color: 'bg-orange-500'),
              _Pill(label: 'Home', color: 'bg-amber-500'),
              _Pill(label: 'About', color: 'bg-red-500'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Flex Direction',
          description:
              'flex-row puts children horizontally. flex-col stacks them vertically.',
          child: WDiv(
            className: 'grid grid-cols-1 md:grid-cols-2 gap-3',
            children: const [
              _DirectionBox(
                label: 'flex flex-row',
                directionClass: 'flex flex-row',
                color: 'bg-orange-400',
              ),
              _DirectionBox(
                label: 'flex flex-col',
                directionClass: 'flex flex-col',
                color: 'bg-red-400',
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Quick Reference',
          description:
              'Every flex utility maps cleanly to a Flutter property. The parser preserves the CSS mental model.',
          child: WDiv(
            className: 'flex flex-col gap-1',
            children: const [
              _RefRow(cls: 'flex', maps: 'Row by default'),
              _RefRow(cls: 'flex-col', maps: 'Column'),
              _RefRow(cls: 'flex-row-reverse', maps: 'Row mirrored'),
              _RefRow(cls: 'justify-{align}', maps: 'MainAxisAlignment'),
              _RefRow(cls: 'items-{align}', maps: 'CrossAxisAlignment'),
              _RefRow(cls: 'gap-{n}', maps: 'SizedBox spacer'),
              _RefRow(cls: 'flex-1', maps: 'Expanded()'),
              _RefRow(cls: 'shrink-0', maps: 'Keep intrinsic size'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Responsive Direction',
          description:
              'Stack on mobile, distribute horizontally on md+. One class string, two layouts.',
          child: WDiv(
            className: '''
              flex flex-col md:flex-row gap-4 p-4 rounded-lg
              bg-orange-50 dark:bg-orange-900/20
            ''',
            children: const [
              _ResponsiveCard(label: 'Card A', color: 'bg-orange-500'),
              _ResponsiveCard(label: 'Card B', color: 'bg-red-500'),
              _ResponsiveCard(label: 'Card C', color: 'bg-amber-500'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Wrap (not flex-wrap)',
          description:
              'Flutter Row/Column do not wrap. Use the wrap utility to render a Wrap widget instead.',
          child: WDiv(
            className: '''
              wrap gap-2 p-4 rounded-lg
              bg-white dark:bg-slate-800
            ''',
            children: List.generate(8, (i) {
              return WDiv(
                className: '''
                  px-3 py-1 rounded-full
                  bg-orange-100 dark:bg-orange-900/40
                ''',
                child: WText(
                  'Item ${i + 1}',
                  className: 'text-sm text-orange-700 dark:text-orange-300',
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final String color;

  const _Pill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: '$color px-3 py-1 rounded-full',
      child: WText(label, className: 'text-white text-sm font-medium'),
    );
  }
}

class _DirectionBox extends StatelessWidget {
  final String label;
  final String directionClass;
  final String color;

  const _DirectionBox({
    required this.label,
    required this.directionClass,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: '''
        flex flex-col gap-2 p-3 rounded-lg
        bg-slate-50 dark:bg-slate-700/40
      ''',
      children: [
        WText(
          label,
          className: 'font-mono text-sm text-slate-700 dark:text-slate-300',
        ),
        WDiv(
          className: '$directionClass gap-2',
          children: List.generate(3, (i) {
            return WDiv(
              className: '$color w-10 h-10 rounded',
              child: WText(
                '${i + 1}',
                className: 'text-white text-sm font-bold text-center',
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _ResponsiveCard extends StatelessWidget {
  final String label;
  final String color;

  const _ResponsiveCard({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: '$color flex-1 p-4 rounded-lg',
      child: WText(label, className: 'text-white font-medium text-center'),
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
          className: 'w-36 shrink-0',
          child: WText(
            cls,
            className: 'font-mono text-sm text-orange-600 dark:text-orange-400',
          ),
        ),
        WText(
          maps,
          className: 'flex-1 text-sm text-slate-600 dark:text-slate-300',
        ),
      ],
    );
  }
}
