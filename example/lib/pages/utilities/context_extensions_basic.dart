import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class ContextExtensionsBasicExamplePage extends StatelessWidget {
  const ContextExtensionsBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.windIsDark;
    final breakpoint = context.wActiveBreakpoint;
    final width = MediaQuery.of(context).size.width;

    return ExampleScaffold(
      title: 'Context Extensions',
      description:
          'BuildContext getters expose Wind theme + responsive + helpers ergonomically: context.windTheme, context.windIsDark, context.wIsMobile, context.wColorExt, ...',
      gradient: 'from-sky-500 to-blue-600',
      children: [
        ExampleSection(
          title: 'Live Readout',
          description:
              'Resize and toggle dark mode to see these getters update in real time.',
          child: WDiv(
            className: 'flex flex-col gap-2',
            children: [
              _ReadoutRow(
                  label: 'context.windIsDark', value: isDark.toString()),
              _ReadoutRow(
                  label: 'context.wActiveBreakpoint', value: breakpoint),
              _ReadoutRow(
                  label: 'context.wIsMobile',
                  value: context.wIsMobile.toString()),
              _ReadoutRow(
                  label: 'context.wIsTablet',
                  value: context.wIsTablet.toString()),
              _ReadoutRow(
                  label: 'context.wIsDesktop',
                  value: context.wIsDesktop.toString()),
              _ReadoutRow(
                  label: 'MediaQuery width', value: '${width.toInt()}px'),
            ],
          ),
        ),
        ExampleSection(
          title: 'context.windTheme — Toggle from Anywhere',
          description:
              'The header toggle uses this exact call. Available globally without provider drilling.',
          child: _CodeBlock(
            code: 'context.windTheme.toggleTheme();\n'
                'context.windTheme.setBrightness(Brightness.dark);',
          ),
        ),
        ExampleSection(
          title: 'context.wColorExt — Color Resolver',
          description:
              'Resolves a theme color in one call. The block below shows three live resolutions.',
          child: WDiv(
            className: 'wrap gap-3',
            children: const [
              _LiveColor(name: 'sky', shade: 500),
              _LiveColor(name: 'rose', shade: 600),
              _LiveColor(name: 'amber', shade: 500),
            ],
          ),
        ),
        ExampleSection(
          title: 'context.wStyleExt — Parse className',
          description:
              'Parse any utility string into a WindStyle to apply on plain Flutter widgets.',
          child: _CodeBlock(
            code:
                'final style = context.wStyleExt("p-4 bg-blue-500 rounded-lg");\n\n'
                '// Use directly on a standard widget:\n'
                'Container(\n'
                '  padding: style.padding,\n'
                '  decoration: style.decoration,\n'
                '  child: ...\n'
                ')',
          ),
        ),
      ],
    );
  }
}

class _ReadoutRow extends StatelessWidget {
  final String label;
  final String value;

  const _ReadoutRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: '''
        flex flex-row items-center justify-between gap-3
        px-3 py-2 rounded-md
        bg-slate-50 dark:bg-slate-700/40
      ''',
      children: [
        WText(label,
            className: 'font-mono text-sm text-sky-700 dark:text-sky-400'),
        WText(value,
            className: 'font-mono text-sm text-slate-700 dark:text-slate-200'),
      ],
    );
  }
}

class _LiveColor extends StatelessWidget {
  final String name;
  final int shade;

  const _LiveColor({required this.name, required this.shade});

  @override
  Widget build(BuildContext context) {
    final color = context.wColorExt(name, shade: shade);
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
          'wColorExt("$name", shade: $shade)',
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
