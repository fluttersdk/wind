import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class PaddingMarginBasicExamplePage extends StatelessWidget {
  const PaddingMarginBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Padding & Margin',
      description:
          'p-{n} adds inner space; m-{n} adds outer space. Direction shortcuts (px-, py-, pt-, mb- ...) target a single axis or side.',
      gradient: 'from-pink-500 to-rose-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'p-4 inserts 16px of padding inside the box. m-4 adds 16px of margin outside. Each step multiplies the 4px base unit.',
          child: WDiv(
            className: '''
              flex flex-col gap-3 items-center
              p-4 rounded-lg
              bg-pink-50 dark:bg-pink-900/20
            ''',
            child: WDiv(
              className: '''
                p-4 m-4 rounded
                bg-pink-500
              ''',
              child: const WText(
                'p-4 m-4',
                className: 'text-white font-mono text-sm',
              ),
            ),
          ),
        ),
        ExampleSection(
          title: 'Padding (inside)',
          description:
              'Compare p-2, p-4, p-8. The inner colored block stays the same; only the outer padding changes.',
          child: WDiv(
            className: 'flex flex-row items-end gap-4',
            children: const [
              _PaddingBox(label: 'p-2', paddingClass: 'p-2'),
              _PaddingBox(label: 'p-4', paddingClass: 'p-4'),
              _PaddingBox(label: 'p-8', paddingClass: 'p-8'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Directional Spacing',
          description:
              'px (horizontal), py (vertical), pt/pr/pb/pl (single side). Same for m.',
          child: WDiv(
            className: 'grid grid-cols-1 sm:grid-cols-3 gap-3',
            children: const [
              _DirectionTile(
                label: 'px-6 py-2',
                directionClass: 'px-6 py-2',
              ),
              _DirectionTile(
                label: 'pt-8 pb-2',
                directionClass: 'pt-8 pb-2',
              ),
              _DirectionTile(
                label: 'pl-12 pr-2',
                directionClass: 'pl-12 pr-2',
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Horizontal Centering',
          description:
              'mx-auto centers an element with a constrained width inside its parent. Works only when the element has a defined width.',
          child: WDiv(
            className: '''
              w-32 mx-auto py-3 rounded
              bg-pink-500
            ''',
            child: const WText(
              'mx-auto',
              className: 'text-white font-mono text-sm text-center',
            ),
          ),
        ),
        ExampleSection(
          title: 'Quick Reference',
          description:
              'p- and m- accept the full direction set (x, y, t, r, b, l) plus the auto shortcut.',
          child: WDiv(
            className: 'flex flex-col gap-1',
            children: const [
              _RefRow(cls: 'p-{n} / m-{n}', desc: 'All four sides'),
              _RefRow(cls: 'px-{n} / mx-{n}', desc: 'Horizontal axis'),
              _RefRow(cls: 'py-{n} / my-{n}', desc: 'Vertical axis'),
              _RefRow(cls: 'pt- pr- pb- pl-', desc: 'Single side'),
              _RefRow(cls: 'mx-auto', desc: 'Center with constrained width'),
              _RefRow(cls: 'p-[13px]', desc: 'Arbitrary pixel value'),
            ],
          ),
        ),
      ],
    );
  }
}

class _PaddingBox extends StatelessWidget {
  final String label;
  final String paddingClass;

  const _PaddingBox({required this.label, required this.paddingClass});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'flex flex-col items-center gap-2',
      children: [
        WText(
          label,
          className: 'font-mono text-xs text-slate-500 dark:text-slate-400',
        ),
        WDiv(
          className: '$paddingClass bg-pink-200 dark:bg-pink-900/40 rounded',
          child: WDiv(
            className: 'w-12 h-12 bg-pink-500 rounded',
          ),
        ),
      ],
    );
  }
}

class _DirectionTile extends StatelessWidget {
  final String label;
  final String directionClass;

  const _DirectionTile({
    required this.label,
    required this.directionClass,
  });

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'flex flex-col items-center gap-2',
      children: [
        WText(
          label,
          className: 'font-mono text-xs text-slate-500 dark:text-slate-400',
        ),
        WDiv(
          className: '$directionClass bg-pink-200 dark:bg-pink-900/40 rounded',
          child: WDiv(
            className: 'w-12 h-12 bg-pink-500 rounded',
          ),
        ),
      ],
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
          className: 'font-mono text-sm text-pink-700 dark:text-pink-400',
        ),
        WText(
          desc,
          className: 'text-sm text-slate-600 dark:text-slate-300',
        ),
      ],
    );
  }
}
