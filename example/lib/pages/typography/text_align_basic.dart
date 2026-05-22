import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class TextAlignBasicExamplePage extends StatelessWidget {
  const TextAlignBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Text Align',
      description:
          'Six alignment keywords map directly to Flutter TextAlign. text-start and text-end are direction-aware (RTL-safe).',
      gradient: 'from-rose-500 to-red-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Each row applies a different text-{align}. The paragraph realigns inside its parent.',
          child: WDiv(
            className: 'flex flex-col gap-2',
            children: const [
              _AlignRow(label: 'text-left', cls: 'text-left'),
              _AlignRow(label: 'text-center', cls: 'text-center'),
              _AlignRow(label: 'text-right', cls: 'text-right'),
              _AlignRow(label: 'text-justify', cls: 'text-justify'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Direction-Aware',
          description:
              'text-start and text-end respect the active text direction. In RTL locales they flip automatically.',
          child: WDiv(
            className: 'flex flex-col gap-2',
            children: const [
              _AlignRow(label: 'text-start', cls: 'text-start'),
              _AlignRow(label: 'text-end', cls: 'text-end'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Quick Reference',
          description: 'Each class maps directly to a Flutter TextAlign value.',
          child: WDiv(
            className: 'flex flex-col gap-1',
            children: const [
              _RefRow(cls: 'text-left', val: 'TextAlign.left'),
              _RefRow(cls: 'text-center', val: 'TextAlign.center'),
              _RefRow(cls: 'text-right', val: 'TextAlign.right'),
              _RefRow(cls: 'text-justify', val: 'TextAlign.justify'),
              _RefRow(cls: 'text-start', val: 'TextAlign.start'),
              _RefRow(cls: 'text-end', val: 'TextAlign.end'),
            ],
          ),
        ),
      ],
    );
  }
}

class _AlignRow extends StatelessWidget {
  final String label;
  final String cls;

  const _AlignRow({required this.label, required this.cls});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'flex flex-col gap-1',
      children: [
        WText(
          label,
          className: 'font-mono text-xs text-slate-500 dark:text-slate-400',
        ),
        WDiv(
          className: '''
            w-full p-3 rounded
            bg-slate-50 dark:bg-slate-700/40
          ''',
          child: WText(
            'The quick brown fox jumps over the lazy dog.',
            className: '$cls text-slate-900 dark:text-white',
          ),
        ),
      ],
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
        flex flex-row items-center justify-between
        px-3 py-2 rounded-md
        bg-slate-50 dark:bg-slate-700/40
      ''',
      children: [
        WText(cls,
            className: 'font-mono text-sm text-rose-700 dark:text-rose-400'),
        WText(val,
            className: 'font-mono text-sm text-slate-600 dark:text-slate-300'),
      ],
    );
  }
}
