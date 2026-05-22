import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class WBreakpointExamplePage extends StatelessWidget {
  const WBreakpointExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'WBreakpoint',
      description:
          'Builder-per-breakpoint widget for structural switches. Use only when widget TYPE or child COUNT differs per breakpoint; className prefixes cover styling differences.',
      gradient: 'from-cyan-500 to-blue-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'A different WidgetBuilder runs per breakpoint. base is required; sm/md/lg/xl are optional fallbacks.',
          child: WBreakpoint(
            base: (_) => WDiv(
              className: 'p-4 rounded-lg bg-red-500',
              child: const WText('base (mobile)',
                  className: 'text-white font-bold'),
            ),
            md: (_) => WDiv(
              className: 'p-4 rounded-lg bg-amber-500',
              child: const WText('md', className: 'text-white font-bold'),
            ),
            lg: (_) => WDiv(
              className: 'p-4 rounded-lg bg-emerald-500',
              child: const WText('lg', className: 'text-white font-bold'),
            ),
            xl: (_) => WDiv(
              className: 'p-4 rounded-lg bg-blue-500',
              child: const WText('xl', className: 'text-white font-bold'),
            ),
          ),
        ),
        ExampleSection(
          title: 'Structural Switch',
          description:
              'Mobile uses a stacked Column; md+ uses a 3-column grid. Widget TYPES differ, so WBreakpoint is the right call.',
          child: WBreakpoint(
            base: (_) => WDiv(
              className: 'flex flex-col gap-3',
              children: const [
                _Card(label: 'Card 1', color: 'bg-cyan-500'),
                _Card(label: 'Card 2', color: 'bg-cyan-500'),
                _Card(label: 'Card 3', color: 'bg-cyan-500'),
              ],
            ),
            md: (_) => WDiv(
              className: 'grid grid-cols-3 gap-3',
              children: const [
                _Card(label: 'Card 1', color: 'bg-blue-500'),
                _Card(label: 'Card 2', color: 'bg-blue-500'),
                _Card(label: 'Card 3', color: 'bg-blue-500'),
              ],
            ),
          ),
        ),
        ExampleSection(
          title: 'When NOT to Use',
          description:
              'If only styles differ between breakpoints, className prefixes are simpler.',
          child: WDiv(
            className: 'flex flex-col gap-2',
            children: const [
              _Compare(
                bad: 'WBreakpoint for style swap',
                good: 'flex-col md:flex-row gap-2 md:gap-8',
              ),
              _Compare(
                bad: 'WBreakpoint for hide/show',
                good: 'hidden md:block',
              ),
              _Compare(
                bad: 'WBreakpoint for reorder',
                good: 'order-2 md:order-1',
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Resolution Order',
          description:
              'Picks the highest defined builder at or below the active breakpoint. Falls back to base when nothing matches.',
          child: WDiv(
            className: '''
              p-4 rounded-lg font-mono text-xs
              bg-slate-900 dark:bg-slate-950
              text-emerald-400
              overflow-x-auto
            ''',
            child: const WText(
              'active = lg, defined = { base, sm, md }\n'
              '  walks lg → md → sm\n'
              '  md has a builder → uses md\n\n'
              'active = sm, defined = { base, md }\n'
              '  walks sm → base\n'
              '  base wins (md is above sm)',
              className: 'whitespace-pre text-emerald-400',
            ),
          ),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  final String label;
  final String color;

  const _Card({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: '$color p-4 rounded-lg',
      child: WText(label, className: 'text-white font-bold text-center'),
    );
  }
}

class _Compare extends StatelessWidget {
  final String bad;
  final String good;

  const _Compare({required this.bad, required this.good});

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
          className: 'w-56 shrink-0',
          child: WText(
            bad,
            className: 'text-sm text-rose-600 dark:text-rose-400',
          ),
        ),
        WText(
          'use $good',
          className:
              'flex-1 font-mono text-sm text-emerald-600 dark:text-emerald-400',
        ),
      ],
    );
  }
}
