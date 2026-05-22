import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class FontFamilyExamplePage extends StatelessWidget {
  const FontFamilyExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Font Family',
      description:
          'font-sans, font-serif, and font-mono pick the typeface. Wind ships sensible defaults; override per scale via WindThemeData.fontFamilies.',
      gradient: 'from-sky-500 to-blue-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'The three default families. Each maps to a curated system font stack.',
          child: WDiv(
            className: 'flex flex-col gap-3',
            children: const [
              _FamilyRow(label: 'font-sans', fontClass: 'font-sans'),
              _FamilyRow(label: 'font-serif', fontClass: 'font-serif'),
              _FamilyRow(label: 'font-mono', fontClass: 'font-mono'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Monospace for Code',
          description:
              'font-mono pairs naturally with a slate background and rounded corners for inline code snippets.',
          child: WDiv(
            className: '''
              p-4 rounded-lg font-mono text-sm
              bg-slate-900 dark:bg-slate-950
              text-emerald-400
            ''',
            child: const WText('const pi = 3.14159;'),
          ),
        ),
        ExampleSection(
          title: 'Responsive Family',
          description:
              'Switch the family per breakpoint. Useful for compact mobile heading vs serif editorial on desktop.',
          child: const WText(
            'Responsive Typography',
            className:
                'font-sans md:font-serif lg:font-mono text-xl text-slate-900 dark:text-white',
          ),
        ),
        ExampleSection(
          title: 'Quick Reference',
          description: 'Three default family slots ship out of the box.',
          child: WDiv(
            className: 'flex flex-col gap-1',
            children: const [
              _RefRow(cls: 'font-sans', desc: 'ui-sans-serif, system-ui, …'),
              _RefRow(cls: 'font-serif', desc: 'ui-serif, Georgia, …'),
              _RefRow(
                  cls: 'font-mono', desc: 'ui-monospace, SFMono-Regular, …'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Arbitrary Family',
          description:
              'font-[Roboto] applies the literal family name. Useful for one-off branding text without theme changes.',
          child: const WText(
            'Custom Branding',
            className: 'font-[Roboto] text-xl text-slate-900 dark:text-white',
          ),
        ),
        ExampleSection(
          title: 'Custom Theme Families',
          description:
              'Add named families through WindThemeData.fontFamilies. Each key becomes a new font-{key} utility.',
          child: _CodeBlock(
            code: 'WindThemeData(\n'
                '  fontFamilies: {\n'
                '    "sans": "Inter",\n'
                '    "display": "Oswald",\n'
                '  },\n'
                ')\n\n'
                '// Now usable as: font-display',
          ),
        ),
      ],
    );
  }
}

class _FamilyRow extends StatelessWidget {
  final String label;
  final String fontClass;

  const _FamilyRow({required this.label, required this.fontClass});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'flex flex-col gap-1',
      children: [
        WText(
          label,
          className: 'font-mono text-xs text-slate-500 dark:text-slate-400',
        ),
        WText(
          'The quick brown fox jumps over the lazy dog',
          className: '$fontClass text-lg text-slate-900 dark:text-white',
        ),
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
        WText(
          cls,
          className: 'font-mono text-sm text-sky-700 dark:text-sky-400',
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
