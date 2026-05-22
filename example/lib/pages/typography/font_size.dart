import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class FontSizeExamplePage extends StatelessWidget {
  const FontSizeExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Font Size',
      description:
          'text-{size} sets the font size from a 10-step scale (xs → 6xl). The forward-slash modifier (text-lg/loose) also sets line height in one shot.',
      gradient: 'from-blue-500 to-cyan-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Twelve named sizes cover most needs. Beyond text-6xl, use bracket syntax or extend the theme.',
          child: WDiv(
            className: 'flex flex-col gap-2',
            children: const [
              _SizeRow(label: 'text-xs', cls: 'text-xs'),
              _SizeRow(label: 'text-sm', cls: 'text-sm'),
              _SizeRow(label: 'text-base', cls: 'text-base'),
              _SizeRow(label: 'text-lg', cls: 'text-lg'),
              _SizeRow(label: 'text-xl', cls: 'text-xl'),
              _SizeRow(label: 'text-2xl', cls: 'text-2xl'),
              _SizeRow(label: 'text-3xl', cls: 'text-3xl'),
              _SizeRow(label: 'text-4xl', cls: 'text-4xl'),
              _SizeRow(label: 'text-5xl', cls: 'text-5xl'),
              _SizeRow(label: 'text-6xl', cls: 'text-6xl'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Size + Line Height',
          description:
              'Append /value to set both font size and line height at once. Accepts named leading or numeric spacing units.',
          child: WDiv(
            className: 'flex flex-col gap-3',
            children: const [
              WText(
                'text-lg/loose — generous breathing room',
                className: 'text-lg/loose text-slate-900 dark:text-white',
              ),
              WText(
                'text-base/7 — fixed 28px line height',
                className: 'text-base/7 text-slate-900 dark:text-white',
              ),
              WText(
                'text-xl/[32px] — arbitrary',
                className: 'text-xl/[32px] text-slate-900 dark:text-white',
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Responsive Size',
          description:
              'Shrink heading on mobile, grow on lg+. The text reflows naturally.',
          child: const WText(
            'Responsive Heading',
            className:
                'text-sm md:text-base lg:text-2xl font-semibold text-slate-900 dark:text-white',
          ),
        ),
        ExampleSection(
          title: 'Arbitrary Sizes',
          description:
              'Brackets accept exact px or rem. Use sparingly — prefer the scale for consistency.',
          child: WDiv(
            className: 'flex flex-col gap-2',
            children: const [
              WText(
                'text-[15px]',
                className: 'text-[15px] text-slate-900 dark:text-white',
              ),
              WText(
                'text-[1.5rem]',
                className: 'text-[1.5rem] text-slate-900 dark:text-white',
              ),
              WText(
                'text-[80px]',
                className: 'text-[80px] text-slate-900 dark:text-white',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SizeRow extends StatelessWidget {
  final String label;
  final String cls;

  const _SizeRow({required this.label, required this.cls});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'flex flex-row items-baseline gap-4',
      children: [
        WDiv(
          className: 'w-20 shrink-0',
          child: WText(
            label,
            className: 'font-mono text-xs text-slate-500 dark:text-slate-400',
          ),
        ),
        WText(
          'The quick brown fox',
          className: '$cls text-slate-900 dark:text-white',
        ),
      ],
    );
  }
}
