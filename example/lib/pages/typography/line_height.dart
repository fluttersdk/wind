import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class LineHeightExamplePage extends StatelessWidget {
  const LineHeightExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Line Height',
      description:
          'leading-{key} controls vertical breathing room. Relative keys (none/tight/normal/loose) follow the font size; numeric keys (leading-6) set a fixed pixel height.',
      gradient: 'from-fuchsia-500 to-pink-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Six relative keys ship by default. Each is a multiplier against the current font size.',
          child: WDiv(
            className: 'grid grid-cols-1 md:grid-cols-2 gap-3',
            children: const [
              _LeadingTile(label: 'leading-none', cls: 'leading-none'),
              _LeadingTile(label: 'leading-tight', cls: 'leading-tight'),
              _LeadingTile(label: 'leading-snug', cls: 'leading-snug'),
              _LeadingTile(label: 'leading-normal', cls: 'leading-normal'),
              _LeadingTile(label: 'leading-relaxed', cls: 'leading-relaxed'),
              _LeadingTile(label: 'leading-loose', cls: 'leading-loose'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Fixed Line Heights',
          description:
              'leading-{n} fixes the line box height to n × baseSpacingUnit. Independent of font size.',
          child: WDiv(
            className: 'flex flex-col gap-3',
            children: const [
              _LeadingTile(label: 'leading-6 (24px)', cls: 'leading-6'),
              _LeadingTile(label: 'leading-8 (32px)', cls: 'leading-8'),
              _LeadingTile(label: 'leading-10 (40px)', cls: 'leading-10'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Quick Reference',
          description:
              'Relative scale below; fixed pixel scale runs leading-3 (12px) through leading-10 (40px).',
          child: WDiv(
            className: 'flex flex-col gap-1',
            children: const [
              _RefRow(cls: 'leading-none', val: '1'),
              _RefRow(cls: 'leading-tight', val: '1.25'),
              _RefRow(cls: 'leading-snug', val: '1.375'),
              _RefRow(cls: 'leading-normal', val: '1.5'),
              _RefRow(cls: 'leading-relaxed', val: '1.625'),
              _RefRow(cls: 'leading-loose', val: '2'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Arbitrary Leading',
          description:
              'Brackets accept fixed px, rem, or unitless multipliers.',
          child: const WText(
            'Custom 1.8 multiplier: the lines have a precise 1.8× breathing distance from one another for editorial layouts.',
            className: 'leading-[1.8] text-base text-slate-900 dark:text-white',
          ),
        ),
      ],
    );
  }
}

class _LeadingTile extends StatelessWidget {
  final String label;
  final String cls;

  const _LeadingTile({required this.label, required this.cls});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: '''
        flex flex-col gap-1 p-3 rounded-lg
        bg-slate-50 dark:bg-slate-700/40
      ''',
      children: [
        WText(
          label,
          className: 'font-mono text-xs text-slate-500 dark:text-slate-400',
        ),
        WText(
          'The quick brown fox jumps over the lazy dog. The same sentence rendered with adjusted leading lets you see the vertical rhythm change.',
          className: '$cls text-sm text-slate-900 dark:text-white',
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
        WText(
          cls,
          className: 'font-mono text-sm text-fuchsia-700 dark:text-fuchsia-400',
        ),
        WText(
          val,
          className: 'font-mono text-sm text-slate-600 dark:text-slate-300',
        ),
      ],
    );
  }
}
