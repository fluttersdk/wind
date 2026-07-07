import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

/// Demonstrates the "fill on desktop, scroll on narrow" primitive: an
/// `overflow-x-auto` wrapper around a `w-full min-w-[Npx]` flex table (the
/// shadcn Table pattern), plus the intrinsic-safe `flex flex-col items-stretch`
/// equal-width column.
class ResponsiveTableExamplePage extends StatelessWidget {
  const ResponsiveTableExamplePage({super.key});

  static const _rows = <(String, String, String)>[
    ('Checkout API', 'Operational', '2m ago'),
    ('Billing worker', 'Degraded', '5m ago'),
    ('Webhook relay', 'Operational', '1m ago'),
  ];

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Responsive Table',
      description:
          'overflow-x-auto + w-full min-w-[Npx] fills the container when wide '
          'and scrolls horizontally when narrow, with no unbounded-width crash.',
      gradient: 'from-green-500 to-teal-600',
      children: [
        ExampleSection(
          title: 'Fill on desktop, scroll on narrow',
          description:
              'The wrapper is overflow-x-auto; the table is w-full min-w-[560px]. '
              'Wide viewports fill; narrow viewports scroll horizontally.',
          child: WDiv(
            className: '''
              overflow-x-auto rounded-lg
              border border-slate-200 dark:border-slate-700
            ''',
            child: WDiv(
              className: 'w-full min-w-[560px] flex flex-col',
              children: [
                WDiv(
                  className: '''
                    flex flex-row px-4 py-2
                    bg-slate-100 dark:bg-slate-800
                  ''',
                  children: const [
                    _HeadCell('Service'),
                    _HeadCell('Status'),
                    _HeadCell('Updated'),
                  ],
                ),
                for (final row in _rows)
                  WDiv(
                    className: '''
                      flex flex-row px-4 py-2
                      border-t border-slate-200 dark:border-slate-700
                    ''',
                    children: [
                      _BodyCell(row.$1),
                      _BodyCell(row.$2),
                      _BodyCell(row.$3),
                    ],
                  ),
              ],
            ),
          ),
        ),
        ExampleSection(
          title: 'flex flex-col items-stretch',
          description:
              'Explicit items-stretch equalizes child widths (every card fills '
              'the column), matching grid items-stretch and staying crash-free '
              'under intrinsic-measuring ancestors.',
          child: WDiv(
            className: 'flex flex-col items-stretch gap-2',
            children: const [
              _StretchCard('Short'),
              _StretchCard('A considerably longer label than the first'),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeadCell extends StatelessWidget {
  final String label;

  const _HeadCell(this.label);

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'flex-1',
      child: WText(
        label,
        className: 'font-semibold text-slate-900 dark:text-white',
      ),
    );
  }
}

class _BodyCell extends StatelessWidget {
  final String value;

  const _BodyCell(this.value);

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'flex-1',
      child: WText(
        value,
        className: 'text-slate-700 dark:text-slate-300',
      ),
    );
  }
}

class _StretchCard extends StatelessWidget {
  final String label;

  const _StretchCard(this.label);

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: '''
        p-3 rounded-lg
        bg-white dark:bg-slate-800
        border border-slate-200 dark:border-slate-700
      ''',
      child: WText(
        label,
        className: 'text-slate-900 dark:text-white',
      ),
    );
  }
}
