import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class ColorHelpersBasicExamplePage extends StatelessWidget {
  const ColorHelpersBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Color Helpers',
      description:
          'Dart API for resolving theme colors programmatically: wColor(), hexToColor(), parseColorOpacity(), applyOpacity().',
      gradient: 'from-pink-500 to-rose-600',
      children: [
        ExampleSection(
          title: 'wColor() — Resolve Theme Color',
          description:
              'Pass a color name and shade. Wind returns the resolved Color from the active theme.',
          child: WDiv(
            className: 'wrap gap-3',
            children: const [
              _ResolvedSwatch(name: 'blue', shade: 500),
              _ResolvedSwatch(name: 'red', shade: 600),
              _ResolvedSwatch(name: 'emerald', shade: 500),
              _ResolvedSwatch(name: 'amber', shade: 500),
              _ResolvedSwatch(name: 'purple', shade: 700),
              _ResolvedSwatch(name: 'slate', shade: 900),
            ],
          ),
        ),
        ExampleSection(
          title: 'hexToColor() — Hex String to Color',
          description: 'Accepts 3/4/6/8-digit hex with optional # prefix.',
          child: WDiv(
            className: 'wrap gap-3',
            children: const [
              _HexSwatch(hex: '#FF5733'),
              _HexSwatch(hex: '#1da1f2'),
              _HexSwatch(hex: '#50d71e'),
              _HexSwatch(hex: '#7c3aed'),
            ],
          ),
        ),
        ExampleSection(
          title: 'applyOpacity() — Adjust Alpha',
          description:
              'Same base color, descending alpha via applyOpacity(color, N).',
          child: WDiv(
            className: 'wrap gap-3',
            children: const [
              _OpacitySwatch(opacity: 1.0),
              _OpacitySwatch(opacity: 0.75),
              _OpacitySwatch(opacity: 0.5),
              _OpacitySwatch(opacity: 0.25),
              _OpacitySwatch(opacity: 0.1),
            ],
          ),
        ),
        ExampleSection(
          title: 'context.wColorExt — Extension Shortcut',
          description:
              'Same as wColor(context, ...). Cleaner inside build methods.',
          child: _CodeBlock(
            code: 'final primary = context.wColorExt("blue", shade: 600);\n'
                'final error = context.wColorExt("red", shade: 500);',
          ),
        ),
      ],
    );
  }
}

class _ResolvedSwatch extends StatelessWidget {
  final String name;
  final int shade;

  const _ResolvedSwatch({required this.name, required this.shade});

  @override
  Widget build(BuildContext context) {
    final color = wColor(context, name, shade: shade);
    return WDiv(
      className: 'flex flex-col gap-2 items-start',
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        WText(
          'wColor($name, $shade)',
          className: 'font-mono text-xs text-slate-700 dark:text-slate-300',
        ),
      ],
    );
  }
}

class _HexSwatch extends StatelessWidget {
  final String hex;

  const _HexSwatch({required this.hex});

  @override
  Widget build(BuildContext context) {
    final color = hexToColor(hex);
    return WDiv(
      className: 'flex flex-col gap-2 items-start',
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        WText(
          'hexToColor("$hex")',
          className: 'font-mono text-xs text-slate-700 dark:text-slate-300',
        ),
      ],
    );
  }
}

class _OpacitySwatch extends StatelessWidget {
  final double opacity;

  const _OpacitySwatch({required this.opacity});

  @override
  Widget build(BuildContext context) {
    final base = wColor(context, 'rose', shade: 500) ?? Colors.pink;
    return WDiv(
      className: 'flex flex-col gap-2 items-start',
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: applyOpacity(base, opacity),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        WText(
          'opacity ${opacity.toStringAsFixed(2)}',
          className: 'font-mono text-xs text-slate-700 dark:text-slate-300',
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
