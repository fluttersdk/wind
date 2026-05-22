import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class SizingWidthExamplePage extends StatelessWidget {
  const SizingWidthExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Width',
      description:
          'w-{n} uses the spacing scale (base 4px). Fractions (w-1/2) map to percentages. w-full fills the parent.',
      gradient: 'from-yellow-500 to-orange-500',
      children: [
        ExampleSection(
          title: 'Fixed Width',
          description:
              'Spacing-scale widths. w-32 = 128px, w-64 = 256px, and so on.',
          child: WDiv(
            className: 'flex flex-col gap-2',
            children: const [
              _Bar(label: 'w-16', widthClass: 'w-16'),
              _Bar(label: 'w-32', widthClass: 'w-32'),
              _Bar(label: 'w-64', widthClass: 'w-64'),
              _Bar(label: 'w-96', widthClass: 'w-96'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Fractional Width',
          description:
              'Percentages expressed as fractions: w-1/2, w-1/3, w-3/4.',
          child: WDiv(
            className: 'flex flex-col gap-2',
            children: const [
              _Bar(label: 'w-1/4', widthClass: 'w-1/4'),
              _Bar(label: 'w-1/3', widthClass: 'w-1/3'),
              _Bar(label: 'w-1/2', widthClass: 'w-1/2'),
              _Bar(label: 'w-3/4', widthClass: 'w-3/4'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Full and Screen',
          description:
              'w-full fills the parent. w-screen ignores the parent and stretches to the viewport.',
          child: WDiv(
            className: 'flex flex-col gap-2',
            children: const [
              _Bar(label: 'w-full', widthClass: 'w-full'),
              _Bar(label: 'w-screen', widthClass: 'w-screen'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Arbitrary Width',
          description:
              'Bracket notation accepts exact pixel or percentage values.',
          child: WDiv(
            className: 'flex flex-col gap-2',
            children: const [
              _Bar(label: 'w-[200px]', widthClass: 'w-[200px]'),
              _Bar(label: 'w-[60%]', widthClass: 'w-[60%]'),
            ],
          ),
        ),
      ],
    );
  }
}

class _Bar extends StatelessWidget {
  final String label;
  final String widthClass;

  const _Bar({required this.label, required this.widthClass});

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
          className: '$widthClass h-8 rounded bg-yellow-500',
        ),
      ],
    );
  }
}
