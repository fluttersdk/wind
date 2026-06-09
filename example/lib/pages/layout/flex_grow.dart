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
          title: 'grow vs grow-0',
          description:
              'grow is an alias for flex-1 (Expanded). grow-0 keeps the item at its natural size and refuses to expand.',
          child: WDiv(
            className: '''
              flex gap-2 p-2 rounded-lg
              bg-white dark:bg-slate-800
            ''',
            children: const [
              _FactorBox(
                label: 'grow-0\n(stays fixed)',
                factorClass: 'grow-0 w-20',
                color: 'bg-slate-400 dark:bg-slate-600',
              ),
              _FactorBox(
                label: 'grow\n(fills rest)',
                factorClass: 'grow',
                color: 'bg-green-500 dark:bg-green-600',
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'basis-* (flex-basis)',
          description:
              'basis-* sets the initial main-axis size before grow/shrink apply. basis-1/2 takes half, basis-1/3 takes a third, basis-full spans the whole axis.',
          child: WDiv(
            className: 'flex flex-col gap-2',
            children: const [
              _BasisRow(
                left: 'basis-1/3',
                leftClass: 'basis-1/3',
                leftColor: 'bg-violet-400 dark:bg-violet-600',
                right: 'basis-2/3 (remainder)',
                rightClass: 'grow',
                rightColor: 'bg-violet-200 dark:bg-violet-800',
              ),
              _BasisRow(
                left: 'basis-1/2',
                leftClass: 'basis-1/2',
                leftColor: 'bg-indigo-400 dark:bg-indigo-600',
                right: 'basis-1/2',
                rightClass: 'basis-1/2',
                rightColor: 'bg-indigo-200 dark:bg-indigo-800',
              ),
              _BasisRow(
                left: 'basis-[80px]',
                leftClass: 'basis-[80px]',
                leftColor: 'bg-sky-400 dark:bg-sky-600',
                right: 'grow (fills rest)',
                rightClass: 'grow',
                rightColor: 'bg-sky-200 dark:bg-sky-800',
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Smart Column Stretch',
          description:
              'A flex flex-col stretches each WDiv child to the column width by default (no w-full needed). Add items-start to shrink children to content size.',
          child: WDiv(
            className: 'flex flex-col gap-4',
            children: const [
              _StretchDemo(
                label: 'Default: children fill column width',
                containerClass: 'flex flex-col gap-2',
                showItemsStart: false,
              ),
              _StretchDemo(
                label: 'items-start: children size to content',
                containerClass: 'flex flex-col gap-2 items-start',
                showItemsStart: true,
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Clickable Row Stretch (WAnchor / WButton)',
          description:
              'WAnchor and WButton column children also stretch to the column width by default. A nav sidebar built from WAnchor rows fills its container without w-full or items-stretch.',
          child: const _ClickableStretchDemo(),
        ),
        ExampleSection(
          title: 'Quick Reference',
          description: 'Eight tokens cover the bulk of flex sizing scenarios.',
          child: WDiv(
            className: 'flex flex-col gap-1',
            children: const [
              _RefRow(cls: 'flex-1', desc: 'Expanded() — grow to fill'),
              _RefRow(
                  cls: 'flex-{n}',
                  desc: 'Specific flex factor (n is any integer)'),
              _RefRow(cls: 'flex-grow / grow', desc: 'Alias of flex-1'),
              _RefRow(cls: 'grow-0', desc: 'Keep intrinsic size, no growing'),
              _RefRow(cls: 'shrink', desc: 'Allow shrinking (FlexFit.loose)'),
              _RefRow(
                  cls: 'shrink-0', desc: 'Preserve intrinsic size (no wrap)'),
              _RefRow(cls: 'flex-none', desc: 'Do not grow or shrink'),
              _RefRow(
                  cls: 'basis-1/2 / basis-1/3 / basis-full',
                  desc: 'Fractional flex-basis'),
              _RefRow(cls: 'basis-[Npx]', desc: 'Fixed flex-basis in pixels'),
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

class _BasisRow extends StatelessWidget {
  final String left;
  final String leftClass;
  final String leftColor;
  final String right;
  final String rightClass;
  final String rightColor;

  const _BasisRow({
    required this.left,
    required this.leftClass,
    required this.leftColor,
    required this.right,
    required this.rightClass,
    required this.rightColor,
  });

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'flex gap-1',
      children: [
        WDiv(
          className:
              '$leftClass $leftColor h-14 rounded flex items-center justify-center',
          child: WText(
            left,
            className: 'font-mono text-xs font-bold text-white text-center',
          ),
        ),
        WDiv(
          className:
              '$rightClass $rightColor h-14 rounded flex items-center justify-center',
          child: WText(
            right,
            className: 'font-mono text-xs font-bold text-white/80 text-center',
          ),
        ),
      ],
    );
  }
}

class _ClickableStretchDemo extends StatelessWidget {
  const _ClickableStretchDemo();

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: '''
        flex flex-col gap-4 p-4 rounded-xl
        bg-white dark:bg-slate-800
        border border-slate-200 dark:border-slate-700
      ''',
      children: [
        WText(
          'Sidebar nav: WAnchor rows fill column width automatically',
          className: 'text-xs font-mono text-slate-500 dark:text-slate-400',
        ),
        WDiv(
          className: '''
            flex flex-col
            rounded-lg overflow-hidden
            border border-slate-200 dark:border-slate-700
          ''',
          children: [
            _NavRow(
              icon: '▶',
              label: 'Dashboard',
              color: 'bg-orange-500 dark:bg-orange-600',
              onTap: () {},
            ),
            _NavRow(
              icon: '◉',
              label: 'Projects',
              color: 'bg-orange-400 dark:bg-orange-500',
              onTap: () {},
            ),
            _NavRow(
              icon: '◈',
              label: 'Settings',
              color: 'bg-orange-300 dark:bg-orange-400',
              onTap: () {},
            ),
          ],
        ),
        WText(
          'WButton rows also stretch, no w-full needed',
          className: 'text-xs font-mono text-slate-500 dark:text-slate-400',
        ),
        WDiv(
          className: 'flex flex-col gap-2',
          children: [
            WButton(
              className: '''
                px-4 py-3 rounded-lg
                bg-slate-100 dark:bg-slate-700
                text-slate-800 dark:text-slate-100
              ''',
              onTap: () {},
              child: WText(
                'Save draft',
                className: 'font-semibold text-sm',
              ),
            ),
            WButton(
              className: '''
                px-4 py-3 rounded-lg
                bg-orange-500 dark:bg-orange-600
              ''',
              onTap: () {},
              child: WText(
                'Publish',
                className: 'font-semibold text-sm text-white dark:text-white',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _NavRow extends StatelessWidget {
  final String icon;
  final String label;
  final String color;
  final VoidCallback onTap;

  const _NavRow({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return WAnchor(
      onTap: onTap,
      child: WDiv(
        className: '''
          flex flex-row items-center gap-3
          px-4 py-3
          $color
        ''',
        children: [
          WText(icon, className: 'text-white dark:text-white text-sm'),
          WText(
            label,
            className: 'text-white dark:text-white font-semibold text-sm',
          ),
        ],
      ),
    );
  }
}

class _StretchDemo extends StatelessWidget {
  final String label;
  final String containerClass;
  final bool showItemsStart;

  const _StretchDemo({
    required this.label,
    required this.containerClass,
    required this.showItemsStart,
  });

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'flex flex-col gap-2',
      children: [
        WText(
          label,
          className: 'text-xs font-mono text-slate-500 dark:text-slate-400',
        ),
        WDiv(
          className: '''
            $containerClass p-2 rounded-lg
            bg-slate-100 dark:bg-slate-700
          ''',
          children: [
            WDiv(
              className: '''
                px-3 py-2 rounded
                bg-orange-400 dark:bg-orange-600
              ''',
              child: WText(
                'Nav bar',
                className: 'text-white dark:text-white font-semibold text-sm',
              ),
            ),
            WDiv(
              className: '''
                px-3 py-2 rounded
                bg-orange-300 dark:bg-orange-500
              ''',
              child: WText(
                'Content card',
                className: 'text-white dark:text-white text-sm',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
