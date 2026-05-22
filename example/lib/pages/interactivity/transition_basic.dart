import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class TransitionBasicExamplePage extends StatelessWidget {
  const TransitionBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Transitions',
      description:
          'duration-{ms} + ease-{curve} make state changes smooth. Pair with hover:, focus:, active: for tactile reactions.',
      gradient: 'from-indigo-500 to-violet-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'duration-300 ease-in-out smooths a hover: bg color change over 300ms with a soft start and finish.',
          child: WDiv(
            className: '''
              bg-blue-500 hover:bg-orange-500
              duration-300 ease-in-out
              px-6 py-4 rounded-lg self-start
            ''',
            child: const WText(
              'Hover me — 300ms ease-in-out',
              className: 'text-white font-medium',
            ),
          ),
        ),
        ExampleSection(
          title: 'Duration',
          description:
              'Compare 75ms, 200ms, 500ms, 1000ms on the same hover. Watch how the snap softens as the duration grows.',
          child: WDiv(
            className: 'wrap gap-3',
            children: const [
              _HoverPill(label: 'duration-75', cls: 'duration-75'),
              _HoverPill(label: 'duration-200', cls: 'duration-200'),
              _HoverPill(label: 'duration-500', cls: 'duration-500'),
              _HoverPill(label: 'duration-1000', cls: 'duration-1000'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Easing',
          description: 'Same duration, different curve. The feel changes.',
          child: WDiv(
            className: 'wrap gap-3',
            children: const [
              _HoverPill(label: 'ease-linear', cls: 'ease-linear duration-500'),
              _HoverPill(label: 'ease-in', cls: 'ease-in duration-500'),
              _HoverPill(label: 'ease-out', cls: 'ease-out duration-500'),
              _HoverPill(label: 'ease-in-out', cls: 'ease-in-out duration-500'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Combined With Other Properties',
          description:
              'Transitions apply to every animatable property change at once: color, shadow, transform, border, opacity.',
          child: WDiv(
            className: '''
              p-6 rounded-xl duration-300 ease-out
              bg-white dark:bg-slate-800
              border border-slate-200 dark:border-slate-700
              shadow-sm hover:shadow-2xl
              hover:border-indigo-500
            ''',
            children: const [
              WText(
                'Interactive Card',
                className: 'font-semibold text-slate-900 dark:text-white',
              ),
              WText(
                'Hover for shadow + border transition over 300ms.',
                className: 'text-sm text-slate-600 dark:text-slate-400 mt-1',
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Quick Reference',
          description:
              'Eight built-in durations and four easing curves. Compose freely.',
          child: WDiv(
            className: 'flex flex-col gap-1',
            children: const [
              _RefRow(cls: 'duration-75', val: '75ms'),
              _RefRow(cls: 'duration-200', val: '200ms (typical UI)'),
              _RefRow(cls: 'duration-500', val: '500ms'),
              _RefRow(cls: 'duration-1000', val: '1000ms'),
              _RefRow(cls: 'ease-linear', val: 'Curves.linear'),
              _RefRow(cls: 'ease-in', val: 'Curves.easeIn'),
              _RefRow(cls: 'ease-out', val: 'Curves.easeOut'),
              _RefRow(cls: 'ease-in-out', val: 'Curves.easeInOut'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Arbitrary Values',
          description: 'Brackets accept exact ms durations and Flutter Curves.',
          child: WDiv(
            className: '''
              bg-indigo-500 hover:bg-orange-500
              duration-[420ms] ease-[Curves.bounceOut]
              px-6 py-4 rounded-lg self-start
            ''',
            child: const WText(
              'duration-[420ms] ease-[Curves.bounceOut]',
              className: 'text-white font-mono text-sm',
            ),
          ),
        ),
      ],
    );
  }
}

class _HoverPill extends StatelessWidget {
  final String label;
  final String cls;

  const _HoverPill({required this.label, required this.cls});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'bg-indigo-500 hover:bg-orange-500 $cls px-4 py-2 rounded',
      child: WText(
        label,
        className: 'text-white font-mono text-sm',
      ),
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
        flex flex-row items-center justify-between gap-3
        px-3 py-2 rounded-md
        bg-slate-50 dark:bg-slate-700/40
      ''',
      children: [
        WText(cls,
            className:
                'font-mono text-sm text-indigo-700 dark:text-indigo-400'),
        WText(val,
            className: 'font-mono text-sm text-slate-600 dark:text-slate-300'),
      ],
    );
  }
}
