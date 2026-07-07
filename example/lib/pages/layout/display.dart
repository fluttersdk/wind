import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class DisplayExamplePage extends StatelessWidget {
  const DisplayExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Display',
      description:
          'Pick the layout mode for a WDiv: block, flex, grid, wrap, or hidden. Each maps to a Flutter widget.',
      gradient: 'from-blue-500 to-indigo-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'The display utility decides whether WDiv renders a Container, Row/Column, GridView, Wrap, or SizedBox.shrink.',
          child: _CodeBlock(
            code: 'WDiv(className: "flex gap-4", children: [...])\n'
                'WDiv(className: "grid grid-cols-3", children: [...])\n'
                'WDiv(className: "hidden", child: ...)',
          ),
        ),
        ExampleSection(
          title: 'Block',
          description:
              'Default mode. WDiv lays children out vertically when no display utility is set.',
          child: WDiv(
            className: '''
              block p-4 rounded-lg
              bg-white dark:bg-slate-800
              border border-slate-200 dark:border-slate-700
            ''',
            child: const WText(
              'I am a block element',
              className: 'text-slate-900 dark:text-white',
            ),
          ),
        ),
        ExampleSection(
          title: 'Flex',
          description:
              'flex turns WDiv into a Row by default. Add flex-col for vertical.',
          child: WDiv(
            className: '''
              flex items-center gap-4 p-4 rounded-lg
              bg-white dark:bg-slate-800
            ''',
            children: [
              WDiv(className: 'w-10 h-10 bg-blue-500 rounded'),
              const WText(
                'Flex item',
                className: 'text-slate-900 dark:text-white',
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Grid',
          description:
              'grid resolves to a GridView with crossAxisCount = grid-cols-{n}.',
          child: WDiv(
            className: 'grid grid-cols-3 gap-3',
            children: const [
              _GridCell(color: 'bg-blue-200 dark:bg-blue-900/40'),
              _GridCell(color: 'bg-blue-300 dark:bg-blue-800/40'),
              _GridCell(color: 'bg-blue-400 dark:bg-blue-700/40'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Wrap',
          description:
              'wrap renders a Flutter Wrap. Children flow to the next line when they run out of room.',
          child: WDiv(
            className: 'wrap gap-2 p-4 bg-white dark:bg-slate-800 rounded-lg',
            children: List.generate(8, (i) {
              return WDiv(
                className: '''
                  px-3 py-1 rounded-full
                  bg-indigo-100 dark:bg-indigo-900/40
                ''',
                child: WText(
                  'Tag ${i + 1}',
                  className: 'text-sm text-indigo-700 dark:text-indigo-300',
                ),
              );
            }),
          ),
        ),
        ExampleSection(
          title: 'Hidden',
          description:
              'hidden replaces the subtree with SizedBox.shrink(). Conditional rendering with no layout shift.',
          child: WDiv(
            className: 'flex gap-4',
            children: const [
              WDiv(
                className: '''
                  px-4 py-2 rounded
                  bg-emerald-100 dark:bg-emerald-900/40
                ''',
                child: WText(
                  'Visible',
                  className: 'text-emerald-700 dark:text-emerald-300',
                ),
              ),
              WDiv(
                className: 'hidden',
                child: WText('You will not see me'),
              ),
              WDiv(
                className: '''
                  px-4 py-2 rounded
                  bg-rose-100 dark:bg-rose-900/40
                ''',
                child: WText(
                  'Also visible',
                  className: 'text-rose-700 dark:text-rose-300',
                ),
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Quick Reference',
          description:
              'Five keywords cover every layout mode Wind supports today.',
          child: WDiv(
            className: 'flex flex-col gap-1',
            children: const [
              _RefRow(cls: 'block', body: 'Default. Container or Column.'),
              _RefRow(cls: 'flex', body: 'Row/Column with flex semantics.'),
              _RefRow(cls: 'grid', body: 'GridView with grid-cols-{n}.'),
              _RefRow(cls: 'wrap', body: 'Wrap widget: multi-line flow.'),
              _RefRow(
                  cls: 'hidden', body: 'SizedBox.shrink: removes from tree.'),
            ],
          ),
        ),
      ],
    );
  }
}

class _GridCell extends StatelessWidget {
  final String color;

  const _GridCell({required this.color});

  @override
  Widget build(BuildContext context) {
    return WDiv(className: 'h-20 $color rounded');
  }
}

class _RefRow extends StatelessWidget {
  final String cls;
  final String body;

  const _RefRow({required this.cls, required this.body});

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
          className: 'w-24 shrink-0',
          child: WText(
            cls,
            className: 'font-mono text-sm text-blue-600 dark:text-blue-400',
          ),
        ),
        WText(
          body,
          className: 'flex-1 text-sm text-slate-600 dark:text-slate-300',
        ),
      ],
    );
  }
}

class _CodeBlock extends StatelessWidget {
  final String code;

  const _CodeBlock({required this.code});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: '''
        p-4 rounded-lg font-mono text-xs
        bg-slate-900 dark:bg-slate-950
        text-emerald-400
        overflow-x-auto
      ''',
      child: WText(
        code,
        className: 'whitespace-pre text-emerald-400',
      ),
    );
  }
}
