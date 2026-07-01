import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class GridColsExamplePage extends StatelessWidget {
  const GridColsExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Grid Template Columns',
      description:
          'grid-cols-{n} sets the column count. Any positive integer works; Wind is not limited to the Tailwind 1-12 scale.',
      gradient: 'from-green-500 to-teal-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Pair grid with grid-cols-{n} to lay children out in even columns. gap-{n} spaces them apart.',
          child: WDiv(
            className: 'grid grid-cols-3 gap-3',
            children: List.generate(
              6,
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
          title: 'Column Counts',
          description:
              'Each row below switches grid-cols. Same children, different layout.',
          child: WDiv(
            className: 'flex flex-col gap-3',
            children: const [
              _GridRow(label: 'grid-cols-2', cols: 2, color: 'bg-emerald-500'),
              _GridRow(label: 'grid-cols-4', cols: 4, color: 'bg-teal-500'),
              _GridRow(label: 'grid-cols-6', cols: 6, color: 'bg-cyan-500'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Quick Reference',
          description:
              'Default scale covers 1–12 columns. Any other integer also resolves correctly.',
          child: WDiv(
            className: 'flex flex-col gap-1',
            children: const [
              _RefRow(cls: 'grid-cols-1', crossAxis: '1'),
              _RefRow(cls: 'grid-cols-3', crossAxis: '3'),
              _RefRow(cls: 'grid-cols-6', crossAxis: '6'),
              _RefRow(cls: 'grid-cols-12', crossAxis: '12'),
              _RefRow(cls: 'grid-cols-16', crossAxis: '16 (any int)'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Equal-Height Rows (items-stretch)',
          description:
              'Add items-stretch so every card in a row matches the tallest. '
              'The middle card has an extra line; all three still align.',
          child: WDiv(
            className: 'grid grid-cols-3 gap-3 items-stretch',
            children: const [
              _StatCard(label: 'Revenue', value: '\$12,480'),
              _StatCard(
                label: 'Signups',
                value: '1,204',
                delta: '+8% vs last week',
              ),
              _StatCard(label: 'Churn', value: '2.1%'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Arbitrary Integers',
          description:
              'No bracket syntax needed. Just write the integer you want.',
          child: WDiv(
            className: 'grid grid-cols-8 gap-1',
            children: List.generate(
              16,
              (i) => WDiv(
                className: '''
                  h-6 rounded
                  bg-gradient-to-br from-green-400 to-teal-500
                ''',
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _GridRow extends StatelessWidget {
  final String label;
  final int cols;
  final String color;

  const _GridRow({
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
          className: 'grid grid-cols-$cols gap-2',
          children: List.generate(
            cols,
            (i) => WDiv(
              className: 'h-10 rounded $color',
            ),
          ),
        ),
      ],
    );
  }
}

class _RefRow extends StatelessWidget {
  final String cls;
  final String crossAxis;

  const _RefRow({required this.cls, required this.crossAxis});

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
          className: 'font-mono text-sm text-green-700 dark:text-green-400',
        ),
        WText(
          'crossAxisCount: $crossAxis',
          className: 'font-mono text-sm text-slate-600 dark:text-slate-300',
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? delta;

  const _StatCard({required this.label, required this.value, this.delta});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: '''
        p-4 rounded-lg
        bg-white dark:bg-slate-800
        border border-slate-200 dark:border-slate-700
      ''',
      children: [
        WText(
          label,
          className: 'text-sm text-slate-500 dark:text-slate-400',
        ),
        WText(
          value,
          className: 'text-2xl font-bold text-slate-900 dark:text-white',
        ),
        if (delta != null)
          WText(
            delta!,
            className: 'text-xs text-green-600 dark:text-green-400',
          ),
      ],
    );
  }
}
