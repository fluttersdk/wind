import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class GridResponsiveExamplePage extends StatelessWidget {
  const GridResponsiveExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Responsive Grid',
      description:
          'Prefix grid-cols-{n} with breakpoint modifiers to switch the column count per screen size.',
      gradient: 'from-green-500 to-teal-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              '1 column on mobile, 3 on md+, 6 on lg+. The same children automatically reflow.',
          child: WDiv(
            className: 'grid grid-cols-1 md:grid-cols-3 lg:grid-cols-6 gap-3',
            children: List.generate(
              12,
              (i) => WDiv(
                className: '''
                  h-16 rounded-lg flex items-center justify-center
                  bg-green-500
                ''',
                child: WText(
                  '${i + 1}',
                  className: 'text-white font-bold',
                ),
              ),
            ),
          ),
        ),
        ExampleSection(
          title: 'Card Grid',
          description:
              'A common content layout: 1 column on phones, 2 on tablets, 3 on desktops, 4 on large screens.',
          child: WDiv(
            className: '''
              grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4
            ''',
            children: List.generate(
              8,
              (i) => WDiv(
                className: '''
                  p-4 rounded-lg
                  bg-white dark:bg-slate-800
                  border border-slate-200 dark:border-slate-700
                ''',
                children: [
                  WDiv(
                    className: '''
                      w-10 h-10 rounded-lg
                      bg-gradient-to-br from-emerald-400 to-teal-600
                    ''',
                  ),
                  WText(
                    'Card ${i + 1}',
                    className:
                        'mt-3 font-semibold text-slate-900 dark:text-white',
                  ),
                  WText(
                    'Reflows across breakpoints.',
                    className:
                        'mt-1 text-sm text-slate-600 dark:text-slate-400',
                  ),
                ],
              ),
            ),
          ),
        ),
        ExampleSection(
          title: 'Asymmetric Cascade',
          description:
              '2 → 4 → 12 columns. Each step packs more content per row.',
          child: WDiv(
            className: 'flex flex-col gap-2',
            children: const [
              _CascadeRow(
                  label: 'grid-cols-2', cols: 2, color: 'bg-emerald-500'),
              _CascadeRow(label: 'grid-cols-4', cols: 4, color: 'bg-teal-500'),
              _CascadeRow(
                  label: 'grid-cols-12', cols: 12, color: 'bg-cyan-500'),
            ],
          ),
        ),
      ],
    );
  }
}

class _CascadeRow extends StatelessWidget {
  final String label;
  final int cols;
  final String color;

  const _CascadeRow({
    required this.label,
    required this.cols,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'flex flex-col gap-2',
      children: [
        WText(
          label,
          className: 'font-mono text-sm text-slate-600 dark:text-slate-400',
        ),
        WDiv(
          className: 'grid grid-cols-$cols gap-1',
          children: List.generate(
            cols,
            (i) => WDiv(className: 'h-8 $color rounded'),
          ),
        ),
      ],
    );
  }
}
