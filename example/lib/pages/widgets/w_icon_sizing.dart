import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class WIconSizingExamplePage extends StatelessWidget {
  const WIconSizingExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Icon Sizing',
      description:
          'WIcon supports two sizing modes. Explicit w-{n} h-{n} wins; otherwise text-{size} sets both size and the surrounding text rhythm.',
      gradient: 'from-amber-500 to-orange-500',
      children: [
        ExampleSection(
          title: 'Typography Sizing',
          description:
              'text-{size} pulls from fontSizes scale. Icons inherit the same line-height as adjacent text.',
          child: WDiv(
            className: 'flex flex-col gap-3',
            children: [
              _SizeRow(
                  size: 'text-sm',
                  child: WIcon(Icons.info,
                      className: 'text-sm text-amber-600 dark:text-amber-400')),
              _SizeRow(
                  size: 'text-base',
                  child: WIcon(Icons.info,
                      className:
                          'text-base text-amber-600 dark:text-amber-400')),
              _SizeRow(
                  size: 'text-xl',
                  child: WIcon(Icons.info,
                      className: 'text-xl text-amber-600 dark:text-amber-400')),
              _SizeRow(
                  size: 'text-3xl',
                  child: WIcon(Icons.info,
                      className:
                          'text-3xl text-amber-600 dark:text-amber-400')),
              _SizeRow(
                  size: 'text-5xl',
                  child: WIcon(Icons.info,
                      className:
                          'text-5xl text-amber-600 dark:text-amber-400')),
            ],
          ),
        ),
        ExampleSection(
          title: 'Explicit Sizing',
          description:
              'w-{n} h-{n} are absolute pixel values; bypass the text scale.',
          child: WDiv(
            className: 'wrap gap-8 items-center py-2',
            children: [
              WIcon(Icons.star, className: 'w-6 h-6 text-amber-500'),
              WIcon(Icons.star, className: 'w-10 h-10 text-amber-500'),
              WIcon(Icons.star, className: 'w-16 h-16 text-amber-500'),
              WIcon(Icons.star, className: 'w-24 h-24 text-amber-500'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Priority',
          description:
              'Explicit w-{n} h-{n} wins over text-{size} when both are set.',
          child: WDiv(
            className: 'flex flex-col gap-1',
            children: const [
              _RefRow(
                cls: 'text-3xl',
                desc: 'Typography sizing (30px default)',
              ),
              _RefRow(
                cls: 'w-12 h-12',
                desc: 'Explicit (48px); overrides any text-{size}',
              ),
              _RefRow(
                cls: 'text-3xl w-6 h-6',
                desc: 'w/h wins → 24px',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SizeRow extends StatelessWidget {
  final String size;
  final Widget child;

  const _SizeRow({required this.size, required this.child});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'flex flex-row items-baseline gap-4',
      children: [
        WDiv(
          className: 'w-24 shrink-0',
          child: WText(
            size,
            className: 'font-mono text-xs text-slate-500 dark:text-slate-400',
          ),
        ),
        child,
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
        flex flex-row items-center justify-between gap-3
        px-3 py-2 rounded-md
        bg-slate-50 dark:bg-slate-700/40
      ''',
      children: [
        WText(cls,
            className: 'font-mono text-sm text-amber-700 dark:text-amber-400'),
        WText(desc, className: 'text-sm text-slate-600 dark:text-slate-300'),
      ],
    );
  }
}
