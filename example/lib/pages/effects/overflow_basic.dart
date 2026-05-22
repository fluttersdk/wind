import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class OverflowBasicExamplePage extends StatelessWidget {
  const OverflowBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Overflow',
      description:
          'Control what happens when content exceeds the container bounds: clip, scroll, or spill.',
      gradient: 'from-purple-500 to-pink-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Four keywords cover the bulk of overflow behavior. Pair with w-* / h-* to make the container constrain the content.',
          child: WDiv(
            className: 'grid grid-cols-1 sm:grid-cols-2 gap-4',
            children: [
              _OverflowBox(
                label: 'overflow-hidden',
                overflowClass: 'overflow-hidden',
              ),
              _OverflowBox(
                label: 'overflow-visible',
                overflowClass: 'overflow-visible',
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Scroll',
          description:
              'overflow-scroll wraps the subtree in a SingleChildScrollView. Scroll bars stay even when content fits.',
          child: WDiv(
            className: '''
              overflow-y-scroll h-40 p-4 rounded-lg
              bg-white dark:bg-slate-800
            ''',
            children: List.generate(
              12,
              (i) => WDiv(
                className: '''
                  py-2 border-b
                  border-slate-200 dark:border-slate-700
                ''',
                child: WText(
                  'Row ${i + 1}',
                  className: 'text-slate-700 dark:text-slate-300',
                ),
              ),
            ),
          ),
        ),
        ExampleSection(
          title: 'Auto',
          description:
              'overflow-auto enables scrolling only when content actually overflows. Below max-h-48 caps the height.',
          child: WDiv(
            className: '''
              overflow-y-auto max-h-48 p-4 rounded-lg
              bg-slate-100 dark:bg-slate-800
            ''',
            children: List.generate(
              8,
              (i) => WText(
                'Auto-scroll line ${i + 1}',
                className: 'text-sm py-1 text-slate-700 dark:text-slate-300',
              ),
            ),
          ),
        ),
        ExampleSection(
          title: 'Quick Reference',
          description:
              'Four keywords map to two Flutter idioms: clip vs scroll.',
          child: WDiv(
            className: 'flex flex-col gap-1',
            children: const [
              _RefRow(
                cls: 'overflow-hidden',
                maps: 'Clip.hardEdge',
                body: 'Clip overflowing content',
              ),
              _RefRow(
                cls: 'overflow-visible',
                maps: 'Clip.none',
                body: 'Allow content to spill out',
              ),
              _RefRow(
                cls: 'overflow-scroll',
                maps: 'SingleChildScrollView',
                body: 'Always scrollable',
              ),
              _RefRow(
                cls: 'overflow-auto',
                maps: 'Conditional scroll',
                body: 'Scroll only when needed',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OverflowBox extends StatelessWidget {
  final String label;
  final String overflowClass;

  const _OverflowBox({required this.label, required this.overflowClass});

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
          className: '''
            $overflowClass w-32 h-32 rounded-lg
            bg-white dark:bg-slate-800
            border border-slate-200 dark:border-slate-700
          ''',
          child: WDiv(
            className: 'w-48 h-48 bg-purple-500 rounded-lg',
          ),
        ),
      ],
    );
  }
}

class _RefRow extends StatelessWidget {
  final String cls;
  final String maps;
  final String body;

  const _RefRow({
    required this.cls,
    required this.maps,
    required this.body,
  });

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
            className: 'font-mono text-sm text-purple-700 dark:text-purple-400',
          ),
        ),
        WDiv(
          className: 'flex-1',
          child: WText(
            body,
            className: 'text-sm text-slate-600 dark:text-slate-300',
          ),
        ),
        WText(
          maps,
          className: 'font-mono text-xs text-slate-500 dark:text-slate-400',
        ),
      ],
    );
  }
}
