import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class BordersPreviewExamplePage extends StatelessWidget {
  const BordersPreviewExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Borders',
      description:
          'border (1px default), border-{n} for width, border-{color} for color, rounded-{size} for radius. Stack any combination.',
      gradient: 'from-rose-500 to-pink-600',
      children: [
        ExampleSection(
          title: 'Width',
          description: 'border-{0|1|2|4|8} sets the width. border alone = 1px.',
          child: WDiv(
            className: 'wrap gap-6 py-4',
            children: const [
              _BorderTile(label: 'border', cls: 'border'),
              _BorderTile(label: 'border-2', cls: 'border-2'),
              _BorderTile(label: 'border-4', cls: 'border-4'),
              _BorderTile(label: 'border-8', cls: 'border-8'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Color',
          description:
              'border-{color}-{shade} tints the border. Pair with dark: for theme-aware borders.',
          child: WDiv(
            className: 'wrap gap-6 py-4',
            children: const [
              _BorderTile(
                  label: 'border-rose-500', cls: 'border-2 border-rose-500'),
              _BorderTile(
                  label: 'border-blue-500', cls: 'border-2 border-blue-500'),
              _BorderTile(
                  label: 'border-emerald-500',
                  cls: 'border-2 border-emerald-500'),
              _BorderTile(
                  label: 'border-amber-500', cls: 'border-2 border-amber-500'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Individual Sides',
          description:
              'border-{t|r|b|l}-{n} targets a single side. Useful for dividers and asymmetric accents.',
          child: WDiv(
            className: 'wrap gap-6 py-4',
            children: const [
              _BorderTile(
                  label: 'border-t-4', cls: 'border-t-4 border-rose-500'),
              _BorderTile(
                  label: 'border-b-4', cls: 'border-b-4 border-rose-500'),
              _BorderTile(
                  label: 'border-l-4', cls: 'border-l-4 border-rose-500'),
              _BorderTile(
                  label: 'border-r-4', cls: 'border-r-4 border-rose-500'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Radius',
          description:
              'rounded-{size} controls corner radius. Pair with rounded-{corner}-{size} for asymmetric shapes.',
          child: WDiv(
            className: 'wrap gap-6 py-4',
            children: const [
              _RadiusTile(label: 'rounded-none', cls: 'rounded-none'),
              _RadiusTile(label: 'rounded', cls: 'rounded'),
              _RadiusTile(label: 'rounded-md', cls: 'rounded-md'),
              _RadiusTile(label: 'rounded-lg', cls: 'rounded-lg'),
              _RadiusTile(label: 'rounded-xl', cls: 'rounded-xl'),
              _RadiusTile(label: 'rounded-2xl', cls: 'rounded-2xl'),
              _RadiusTile(label: 'rounded-full', cls: 'rounded-full'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Corner-Specific Radius',
          description:
              'rounded-t-lg rounds top corners only. rounded-tl-lg rounds the top-left corner only.',
          child: WDiv(
            className: 'wrap gap-6 py-4',
            children: const [
              _RadiusTile(label: 'rounded-t-xl', cls: 'rounded-t-xl'),
              _RadiusTile(label: 'rounded-r-xl', cls: 'rounded-r-xl'),
              _RadiusTile(label: 'rounded-tl-2xl', cls: 'rounded-tl-2xl'),
              _RadiusTile(label: 'rounded-br-2xl', cls: 'rounded-br-2xl'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Arbitrary Values',
          description:
              'Brackets accept exact pixel widths, hex colors, and radii.',
          child: WDiv(
            className: 'wrap gap-6 py-4',
            children: const [
              _BorderTile(
                  label: 'border-[3px] border-[#50d71e]',
                  cls: 'border-[3px] border-[#50d71e]'),
              _RadiusTile(label: 'rounded-[10px]', cls: 'rounded-[10px]'),
            ],
          ),
        ),
      ],
    );
  }
}

class _BorderTile extends StatelessWidget {
  final String label;
  final String cls;

  const _BorderTile({required this.label, required this.cls});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'flex flex-col gap-2 items-center',
      children: [
        WDiv(
          className: '''
            w-20 h-20 rounded-lg
            bg-white dark:bg-slate-800
            $cls
          ''',
        ),
        WText(
          label,
          className: 'font-mono text-xs text-slate-700 dark:text-slate-300',
        ),
      ],
    );
  }
}

class _RadiusTile extends StatelessWidget {
  final String label;
  final String cls;

  const _RadiusTile({required this.label, required this.cls});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'flex flex-col gap-2 items-center',
      children: [
        WDiv(
          className: '''
            w-20 h-20
            bg-rose-500
            $cls
          ''',
        ),
        WText(
          label,
          className: 'font-mono text-xs text-slate-700 dark:text-slate-300',
        ),
      ],
    );
  }
}
