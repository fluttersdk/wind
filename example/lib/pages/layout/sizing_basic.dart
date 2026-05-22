import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class SizingBasicExamplePage extends StatelessWidget {
  const SizingBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Sizing',
      description:
          'w-{n} and h-{n} set explicit dimensions. Fractions (w-1/2), full (w-full), screen (w-screen), and arbitrary pixels are all supported.',
      gradient: 'from-yellow-500 to-orange-500',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Fixed pixel widths follow the spacing scale (base 4px). Percentages and viewport units are aliases.',
          child: WDiv(
            className: 'flex flex-col gap-3',
            children: const [
              _SizingRow(label: 'w-32 (128px)', sizeClass: 'w-32'),
              _SizingRow(label: 'w-1/2 (50%)', sizeClass: 'w-1/2'),
              _SizingRow(label: 'w-full (100%)', sizeClass: 'w-full'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Max-Width Scale',
          description:
              'max-w-{key} caps the width. Combine with mx-auto for a centered, readable column.',
          child: WDiv(
            className: 'flex flex-col gap-2',
            children: const [
              _MaxWidthRow(label: 'max-w-xs (320px)', maxClass: 'max-w-xs'),
              _MaxWidthRow(label: 'max-w-md (448px)', maxClass: 'max-w-md'),
              _MaxWidthRow(label: 'max-w-2xl (672px)', maxClass: 'max-w-2xl'),
              _MaxWidthRow(label: 'max-w-4xl (896px)', maxClass: 'max-w-4xl'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Quick Reference',
          description:
              'Fixed sizes follow the spacing scale; fractions take CSS-like keys.',
          child: WDiv(
            className: 'flex flex-col gap-1',
            children: const [
              _RefRow(cls: 'w-0 / h-0', value: '0px'),
              _RefRow(cls: 'w-4 / h-4', value: '16px'),
              _RefRow(cls: 'w-16 / h-16', value: '64px'),
              _RefRow(cls: 'w-full / h-full', value: '100% of parent'),
              _RefRow(cls: 'w-screen / h-screen', value: '100vw / 100vh'),
              _RefRow(cls: 'w-1/2', value: '50%'),
              _RefRow(cls: 'w-1/3', value: '33.33%'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Responsive Sizing',
          description:
              'Full width on mobile, half on md, third on lg. The same element shrinks as the viewport grows.',
          child: WDiv(
            className: 'flex justify-center',
            child: WDiv(
              className: '''
                w-full md:w-1/2 lg:w-1/3 h-16 rounded-lg
                bg-gradient-to-r from-yellow-400 to-orange-500
                flex items-center justify-center
              ''',
              child: const WText(
                'w-full md:w-1/2 lg:w-1/3',
                className: 'text-white font-mono text-sm',
              ),
            ),
          ),
        ),
        ExampleSection(
          title: 'Arbitrary Values',
          description: 'Bracket notation accepts exact pixels or percentages.',
          child: WDiv(
            className: 'flex flex-col gap-3',
            children: [
              WDiv(
                className: 'w-[350px] h-12 bg-yellow-500 rounded-lg',
                child: const WText('w-[350px]',
                    className: 'text-white text-sm font-mono pl-3 self-center'),
              ),
              WDiv(
                className: 'w-[33%] h-12 bg-orange-500 rounded-lg',
                child: const WText('w-[33%]',
                    className: 'text-white text-sm font-mono pl-3 self-center'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SizingRow extends StatelessWidget {
  final String label;
  final String sizeClass;

  const _SizingRow({required this.label, required this.sizeClass});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'flex flex-col gap-1',
      children: [
        WText(
          label,
          className: 'text-xs font-mono text-slate-500 dark:text-slate-400',
        ),
        WDiv(
          className: '$sizeClass h-12 bg-yellow-500 rounded-lg',
        ),
      ],
    );
  }
}

class _MaxWidthRow extends StatelessWidget {
  final String label;
  final String maxClass;

  const _MaxWidthRow({required this.label, required this.maxClass});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'flex flex-col gap-1',
      children: [
        WText(
          label,
          className: 'text-xs font-mono text-slate-500 dark:text-slate-400',
        ),
        WDiv(
          className: '''
            $maxClass h-8 rounded
            bg-gradient-to-r from-yellow-400 to-orange-500
          ''',
        ),
      ],
    );
  }
}

class _RefRow extends StatelessWidget {
  final String cls;
  final String value;

  const _RefRow({required this.cls, required this.value});

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
          value,
          className: 'font-mono text-sm text-slate-600 dark:text-slate-300',
        ),
      ],
    );
  }
}
