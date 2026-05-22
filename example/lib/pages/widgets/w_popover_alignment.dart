import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class WPopoverAlignmentExamplePage extends StatelessWidget {
  const WPopoverAlignmentExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Popover Alignment',
      description:
          'alignment selects where the floating panel sits relative to the trigger. Six anchor points cover the common layouts. autoFlip mirrors when an edge would clip.',
      gradient: 'from-purple-500 to-violet-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Each chip below opens its popover anchored to a different alignment.',
          child: WDiv(
            className: 'wrap gap-3',
            children: const [
              _AlignChip(
                  label: 'bottomLeft', alignment: PopoverAlignment.bottomLeft),
              _AlignChip(
                  label: 'bottomRight',
                  alignment: PopoverAlignment.bottomRight),
              _AlignChip(
                  label: 'bottomCenter',
                  alignment: PopoverAlignment.bottomCenter),
              _AlignChip(label: 'topLeft', alignment: PopoverAlignment.topLeft),
              _AlignChip(
                  label: 'topRight', alignment: PopoverAlignment.topRight),
              _AlignChip(
                  label: 'topCenter', alignment: PopoverAlignment.topCenter),
            ],
          ),
        ),
        ExampleSection(
          title: 'Quick Reference',
          description: 'Six alignment constants; default is bottomLeft.',
          child: WDiv(
            className: 'flex flex-col gap-1',
            children: const [
              _RefRow(
                  cls: 'PopoverAlignment.bottomLeft', pos: 'Below + left edge'),
              _RefRow(
                  cls: 'PopoverAlignment.bottomRight',
                  pos: 'Below + right edge'),
              _RefRow(
                  cls: 'PopoverAlignment.bottomCenter',
                  pos: 'Below + centered'),
              _RefRow(
                  cls: 'PopoverAlignment.topLeft', pos: 'Above + left edge'),
              _RefRow(
                  cls: 'PopoverAlignment.topRight', pos: 'Above + right edge'),
              _RefRow(
                  cls: 'PopoverAlignment.topCenter', pos: 'Above + centered'),
            ],
          ),
        ),
      ],
    );
  }
}

class _AlignChip extends StatelessWidget {
  final String label;
  final PopoverAlignment alignment;

  const _AlignChip({required this.label, required this.alignment});

  @override
  Widget build(BuildContext context) {
    return WPopover(
      alignment: alignment,
      className: '''
        w-48 rounded-lg p-3
        bg-white dark:bg-slate-800
        shadow-xl border border-slate-200 dark:border-slate-700
      ''',
      triggerBuilder: (context, isOpen, isHovering) => WButton(
        onTap: () {},
        className: '''
          bg-purple-600 hover:bg-purple-700
          text-white px-3 py-2 rounded-lg text-sm font-mono duration-200
        ''',
        child: WText(label, className: 'text-white text-sm font-mono'),
      ),
      contentBuilder: (context, close) => WText(
        'Anchored at $label',
        className: 'text-sm text-slate-700 dark:text-slate-200',
      ),
    );
  }
}

class _RefRow extends StatelessWidget {
  final String cls;
  final String pos;

  const _RefRow({required this.cls, required this.pos});

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
                'font-mono text-sm text-purple-700 dark:text-purple-400'),
        WText(pos, className: 'text-sm text-slate-600 dark:text-slate-300'),
      ],
    );
  }
}
