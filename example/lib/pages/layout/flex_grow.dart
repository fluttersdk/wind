import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class FlexGrowExamplePage extends StatelessWidget {
  const FlexGrowExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Flex Grow & Shrink',
      description:
          'flex-1 wraps a child in Expanded. shrink-0 preserves intrinsic size. Mix them to build sidebars, search bars, and toolbars.',
      gradient: 'from-orange-500 to-red-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Fixed-width sidebar, flexible content. shrink-0 stops the sidebar from collapsing.',
          child: WDiv(
            className: '''
              flex p-2 rounded-lg
              bg-white dark:bg-slate-800
              border border-slate-200 dark:border-slate-700
            ''',
            children: const [
              _Box(
                color: 'bg-slate-300 dark:bg-slate-700',
                label: 'shrink-0',
                widthClass: 'w-16',
                extras: 'shrink-0',
              ),
              _Box(
                color: 'bg-orange-500',
                label: 'flex-1',
                widthClass: '',
                extras: 'flex-1 ml-2',
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Multiple Flex Factors',
          description:
              'flex-1, flex-2, flex-3 share remaining space in their numeric ratio.',
          child: WDiv(
            className: '''
              flex gap-2 p-2 rounded-lg
              bg-white dark:bg-slate-800
            ''',
            children: const [
              _FactorBox(
                  label: 'flex-1',
                  factorClass: 'flex-1',
                  color: 'bg-amber-400'),
              _FactorBox(
                  label: 'flex-2',
                  factorClass: 'flex-2',
                  color: 'bg-orange-500'),
              _FactorBox(
                  label: 'flex-3', factorClass: 'flex-3', color: 'bg-red-500'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Quick Reference',
          description: 'Five tokens cover the bulk of flex sizing scenarios.',
          child: WDiv(
            className: 'flex flex-col gap-1',
            children: const [
              _RefRow(cls: 'flex-1', desc: 'Expanded() — grow to fill'),
              _RefRow(
                  cls: 'flex-{n}',
                  desc: 'Specific flex factor (n is any integer)'),
              _RefRow(cls: 'flex-grow', desc: 'Alias of flex-1'),
              _RefRow(cls: 'shrink', desc: 'Allow shrinking (FlexFit.loose)'),
              _RefRow(
                  cls: 'shrink-0', desc: 'Preserve intrinsic size (no wrap)'),
              _RefRow(cls: 'flex-none', desc: 'Do not grow or shrink'),
            ],
          ),
        ),
      ],
    );
  }
}

class _Box extends StatelessWidget {
  final String color;
  final String label;
  final String widthClass;
  final String extras;

  const _Box({
    required this.color,
    required this.label,
    required this.widthClass,
    required this.extras,
  });

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className:
          '$widthClass $extras $color h-16 rounded flex items-center justify-center',
      child: WText(
        label,
        className: 'text-white font-mono text-sm font-bold',
      ),
    );
  }
}

class _FactorBox extends StatelessWidget {
  final String label;
  final String factorClass;
  final String color;

  const _FactorBox({
    required this.label,
    required this.factorClass,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className:
          '$factorClass $color h-16 rounded flex items-center justify-center',
      child: WText(
        label,
        className: 'text-white font-mono font-bold',
      ),
    );
  }
}

class _RefRow extends StatelessWidget {
  final String cls;
  final String desc;

  const _RefRow({required this.cls, required this.desc});

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
          className: 'font-mono text-sm text-orange-700 dark:text-orange-400',
        ),
        WText(
          desc,
          className:
              'flex-1 text-sm text-slate-600 dark:text-slate-300 text-right',
        ),
      ],
    );
  }
}
