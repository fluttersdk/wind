import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class ResponsiveDisplayExamplePage extends StatelessWidget {
  const ResponsiveDisplayExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Responsive Display',
      description:
          'Mix display utilities with breakpoint prefixes to switch between hidden, block, flex, and grid per screen size.',
      gradient: 'from-blue-500 to-indigo-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Hidden on mobile, flex on md+. Resize the window to see the row appear once you cross 768px.',
          child: WDiv(
            className: '''
              hidden md:flex items-center gap-4
              p-4 rounded-lg
              bg-white dark:bg-slate-800
              border border-slate-200 dark:border-slate-700
            ''',
            children: const [
              _Pill(color: 'bg-blue-500', label: 'A'),
              _Pill(color: 'bg-indigo-500', label: 'B'),
              _Pill(color: 'bg-purple-500', label: 'C'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Hide On Large Screens',
          description:
              'block on mobile, hidden on lg+. The card disappears once the viewport reaches 1024px.',
          child: WDiv(
            className: '''
              block lg:hidden p-4 rounded-lg text-white
              bg-gradient-to-r from-blue-500 to-indigo-600
            ''',
            child: const WText(
              'Visible only below 1024px',
              className: 'font-medium text-white',
            ),
          ),
        ),
        ExampleSection(
          title: 'Per-Breakpoint Stages',
          description:
              'Each badge below toggles in at a specific breakpoint. Resize to walk through the cascade.',
          child: WDiv(
            className: 'wrap gap-2',
            children: const [
              _BreakpointBadge(label: 'base', cls: 'block'),
              _BreakpointBadge(label: 'sm+', cls: 'hidden sm:block'),
              _BreakpointBadge(label: 'md+', cls: 'hidden md:block'),
              _BreakpointBadge(label: 'lg+', cls: 'hidden lg:block'),
              _BreakpointBadge(label: 'xl+', cls: 'hidden xl:block'),
              _BreakpointBadge(label: '2xl+', cls: 'hidden 2xl:block'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Dark Mode Switch',
          description:
              'hidden dark:block reverses the visibility based on theme. Toggle the moon button to swap.',
          child: WDiv(
            className: 'flex flex-col gap-2',
            children: const [
              WDiv(
                className: '''
                  block dark:hidden p-4 rounded-lg text-white
                  bg-blue-500
                ''',
                child: WText(
                  'Visible in light mode only',
                  className: 'text-white font-medium',
                ),
              ),
              WDiv(
                className: '''
                  hidden dark:block p-4 rounded-lg text-white
                  bg-indigo-500
                ''',
                child: WText(
                  'Visible in dark mode only',
                  className: 'text-white font-medium',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final String color;
  final String label;

  const _Pill({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: '$color w-12 h-12 rounded-lg flex items-center justify-center',
      child: WText(label, className: 'text-white font-bold'),
    );
  }
}

class _BreakpointBadge extends StatelessWidget {
  final String label;
  final String cls;

  const _BreakpointBadge({required this.label, required this.cls});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: '''
        $cls px-3 py-1 rounded-full
        bg-blue-100 dark:bg-blue-900/40
      ''',
      child: WText(
        label,
        className: 'font-mono text-sm text-blue-700 dark:text-blue-300',
      ),
    );
  }
}
