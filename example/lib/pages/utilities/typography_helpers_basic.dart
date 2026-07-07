import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class TypographyHelpersBasicExamplePage extends StatelessWidget {
  const TypographyHelpersBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Typography Helpers',
      description:
          'Dart API for type tokens: wFontSize(), wFontWeight(), context.wFontSizeExt(), context.wFontWeightExt(). Resolves theme values to Flutter primitives.',
      gradient: 'from-amber-500 to-orange-500',
      children: [
        ExampleSection(
          title: 'wFontSize(): Resolve Pixel Size',
          description:
              'Every named size from xs to 6xl maps to a double pixel value.',
          child: WDiv(
            className: 'flex flex-col gap-2',
            children: const [
              _FontSizeRow(name: 'xs'),
              _FontSizeRow(name: 'sm'),
              _FontSizeRow(name: 'base'),
              _FontSizeRow(name: 'lg'),
              _FontSizeRow(name: 'xl'),
              _FontSizeRow(name: '2xl'),
              _FontSizeRow(name: '4xl'),
            ],
          ),
        ),
        ExampleSection(
          title: 'wFontWeight(): Resolve FontWeight',
          description: 'Named weights map to Flutter FontWeight constants.',
          child: WDiv(
            className: 'flex flex-col gap-2',
            children: const [
              _FontWeightRow(name: 'thin'),
              _FontWeightRow(name: 'light'),
              _FontWeightRow(name: 'normal'),
              _FontWeightRow(name: 'medium'),
              _FontWeightRow(name: 'semibold'),
              _FontWeightRow(name: 'bold'),
              _FontWeightRow(name: 'black'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Theme Scale Access',
          description:
              'Iterate the full scale via context.windThemeData.fontSizes.',
          child: _CodeBlock(
            code: 'final theme = context.windThemeData;\n\n'
                'for (final entry in theme.fontSizes.entries) {\n'
                '  print("\${entry.key}: \${entry.value}");\n'
                '}\n\n'
                '// Or pick a specific weight from the map:\n'
                'final bold = theme.fontWeights["bold"];',
          ),
        ),
        ExampleSection(
          title: 'Use With Material Widgets',
          description:
              'Apply Wind tokens to plain Text widgets where className is unavailable.',
          child: Builder(
            builder: (context) {
              final size = context.wFontSizeExt('xl');
              final weight = context.wFontWeightExt('bold');
              final color = context.wColorExt('amber', shade: 600);
              return Text(
                'Direct Text widget styled via context.wFontSizeExt + wFontWeightExt + wColorExt',
                style: TextStyle(
                  fontSize: size,
                  fontWeight: weight,
                  color: color,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _FontSizeRow extends StatelessWidget {
  final String name;

  const _FontSizeRow({required this.name});

  @override
  Widget build(BuildContext context) {
    final size = wFontSize(context, name);
    return WDiv(
      className: 'flex flex-row items-baseline gap-4',
      children: [
        WDiv(
          className: 'w-32 shrink-0',
          child: WText(
            'wFontSize("$name")',
            className: 'font-mono text-xs text-slate-500 dark:text-slate-400',
          ),
        ),
        WText(
          'The quick brown fox',
          className: 'text-$name text-slate-900 dark:text-white',
        ),
        WText(
          size != null ? '${size}px' : 'null',
          className: 'font-mono text-xs text-slate-500 dark:text-slate-400',
        ),
      ],
    );
  }
}

class _FontWeightRow extends StatelessWidget {
  final String name;

  const _FontWeightRow({required this.name});

  @override
  Widget build(BuildContext context) {
    final weight = wFontWeight(context, name);
    return WDiv(
      className: 'flex flex-row items-baseline gap-4',
      children: [
        WDiv(
          className: 'w-40 shrink-0',
          child: WText(
            'wFontWeight("$name")',
            className: 'font-mono text-xs text-slate-500 dark:text-slate-400',
          ),
        ),
        WText(
          'The quick brown fox',
          className: 'font-$name text-lg text-slate-900 dark:text-white',
        ),
        WText(
          weight?.toString() ?? 'null',
          className: 'font-mono text-xs text-slate-500 dark:text-slate-400',
        ),
      ],
    );
  }
}

class _CodeBlock extends StatelessWidget {
  final String code;

  const _CodeBlock({required this.code});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: '''
        p-4 rounded-lg font-mono text-xs
        bg-slate-900 dark:bg-slate-950
        text-emerald-400
        overflow-x-auto
      ''',
      child: WText(code, className: 'whitespace-pre text-emerald-400'),
    );
  }
}
