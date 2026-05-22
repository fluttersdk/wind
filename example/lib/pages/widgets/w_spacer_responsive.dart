import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class WSpacerResponsiveExamplePage extends StatelessWidget {
  const WSpacerResponsiveExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Responsive Spacer',
      description:
          'WSpacer accepts the same responsive prefixes as className. Tighten gaps on mobile, loosen on desktop.',
      gradient: 'from-slate-500 to-slate-700',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'h-4 md:h-8 — 16px gap on mobile, 32px on md+. Resize the window to see the spacing change.',
          child: WDiv(
            className: 'flex flex-col items-stretch',
            children: const [
              _Card(label: 'Above'),
              WSpacer(className: 'h-4 md:h-8'),
              _Card(label: 'Below'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Cascading Breakpoints',
          description:
              'Stack prefixes for a multi-stage cascade: h-2 base, h-4 sm+, h-8 lg+, h-12 xl+.',
          child: WDiv(
            className: 'flex flex-col items-stretch',
            children: const [
              _Card(label: 'First'),
              WSpacer(className: 'h-2 sm:h-4 lg:h-8 xl:h-12'),
              _Card(label: 'Second — cascading gap'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Horizontal Cascade',
          description:
              'Same idea applied horizontally with w-{n} prefixes inside a flex row.',
          child: WDiv(
            className:
                'flex flex-row items-center p-4 rounded-lg bg-slate-50 dark:bg-slate-700/40',
            children: const [
              _Pill(label: 'A'),
              WSpacer(className: 'w-2 sm:w-4 lg:w-12'),
              _Pill(label: 'B'),
            ],
          ),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  final String label;

  const _Card({required this.label});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: '''
        p-4 rounded-lg
        bg-white dark:bg-slate-800
        border border-slate-200 dark:border-slate-700
      ''',
      child: WText(
        label,
        className: 'text-slate-700 dark:text-slate-200',
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;

  const _Pill({required this.label});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'px-3 py-1 rounded-full bg-slate-600',
      child: WText(label, className: 'text-white text-sm font-medium'),
    );
  }
}
