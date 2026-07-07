import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class WDivBasicExamplePage extends StatelessWidget {
  const WDivBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'WDiv',
      description:
          'The fundamental building block. Replaces Container, Row, Column, Wrap, GridView, and SingleChildScrollView in one widget. The className picks the right layout.',
      gradient: 'from-blue-500 to-cyan-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'A styled container with flex layout. One className declares layout, spacing, background, radius, and shadow.',
          child: WDiv(
            className: '''
              flex flex-col gap-4 p-6 rounded-xl
              bg-white dark:bg-slate-800
              shadow-lg dark:shadow-none
              border border-slate-200 dark:border-slate-700
            ''',
            children: [
              WText('Hello Wind',
                  className:
                      'text-2xl font-bold text-slate-900 dark:text-white'),
              WText('This is a styled container.',
                  className: 'text-slate-600 dark:text-slate-400'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Single Child vs Children',
          description:
              'child for one widget; children for layout modes. They are mutually exclusive.',
          child: WDiv(
            className: 'flex flex-col gap-3',
            children: [
              WDiv(
                className: 'p-4 rounded bg-blue-500',
                child: const WText('Single child',
                    className: 'text-white font-medium'),
              ),
              WDiv(
                className: 'flex flex-row gap-2',
                children: const [
                  _Box(color: 'bg-blue-400'),
                  _Box(color: 'bg-blue-500'),
                  _Box(color: 'bg-blue-600'),
                ],
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Layout Modes',
          description:
              'block, flex, grid, wrap, hidden: each maps to a different Flutter widget under the hood.',
          child: WDiv(
            className: 'flex flex-col gap-3',
            children: [
              _ModeRow(
                label: 'flex flex-row',
                content: WDiv(
                  className: 'flex flex-row gap-2',
                  children: const [
                    _Box(color: 'bg-cyan-400'),
                    _Box(color: 'bg-cyan-500'),
                    _Box(color: 'bg-cyan-600'),
                  ],
                ),
              ),
              _ModeRow(
                label: 'grid grid-cols-4',
                content: WDiv(
                  className: 'grid grid-cols-4 gap-2',
                  children: const [
                    _Box(color: 'bg-blue-400'),
                    _Box(color: 'bg-blue-500'),
                    _Box(color: 'bg-blue-600'),
                    _Box(color: 'bg-blue-700'),
                  ],
                ),
              ),
              _ModeRow(
                label: 'wrap',
                content: WDiv(
                  className: 'wrap gap-2',
                  children: List.generate(
                    6,
                    (i) => WDiv(
                      className:
                          'px-3 py-1 rounded-full bg-cyan-100 dark:bg-cyan-900/40',
                      child: WText(
                        'Tag ${i + 1}',
                        className: 'text-sm text-cyan-700 dark:text-cyan-300',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Interactive State',
          description:
              'WDiv auto-becomes interactive when className includes hover: / focus: / active:.',
          child: WDiv(
            className: '''
              p-6 rounded-xl cursor-pointer duration-200
              bg-blue-50 hover:bg-blue-100
              dark:bg-blue-900/20 dark:hover:bg-blue-900/40
              border border-blue-200 dark:border-blue-800
              hover:shadow-lg
            ''',
            children: [
              WIcon(Icons.touch_app, className: 'text-blue-500 text-3xl'),
              const WText('Hover & Click Me',
                  className: 'text-blue-700 dark:text-blue-300 font-bold mt-2'),
            ],
          ),
        ),
      ],
    );
  }
}

class _Box extends StatelessWidget {
  final String color;

  const _Box({required this.color});

  @override
  Widget build(BuildContext context) {
    return WDiv(className: '$color w-12 h-12 rounded');
  }
}

class _ModeRow extends StatelessWidget {
  final String label;
  final Widget content;

  const _ModeRow({required this.label, required this.content});

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
          className: 'font-mono text-xs text-slate-500 dark:text-slate-400',
        ),
        content,
      ],
    );
  }
}
