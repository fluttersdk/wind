import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class ShadowsBasicExamplePage extends StatelessWidget {
  const ShadowsBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Box Shadow',
      description:
          'shadow-{size} applies one of six built-in shadow scales. shadow-none removes any inherited shadow.',
      gradient: 'from-slate-700 to-slate-900',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Each tile applies a different shadow size. Higher sizes = larger blur.',
          child: WDiv(
            className: 'wrap gap-6 py-4',
            children: const [
              _ShadowTile(label: 'shadow-sm', cls: 'shadow-sm'),
              _ShadowTile(label: 'shadow', cls: 'shadow'),
              _ShadowTile(label: 'shadow-md', cls: 'shadow-md'),
              _ShadowTile(label: 'shadow-lg', cls: 'shadow-lg'),
              _ShadowTile(label: 'shadow-xl', cls: 'shadow-xl'),
              _ShadowTile(label: 'shadow-2xl', cls: 'shadow-2xl'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Quick Reference',
          description: 'Six named sizes + shadow-none reset.',
          child: WDiv(
            className: 'flex flex-col gap-1',
            children: const [
              _RefRow(cls: 'shadow-sm', blur: 'blur 2'),
              _RefRow(cls: 'shadow', blur: 'blur 3 (default)'),
              _RefRow(cls: 'shadow-md', blur: 'blur 6'),
              _RefRow(cls: 'shadow-lg', blur: 'blur 15'),
              _RefRow(cls: 'shadow-xl', blur: 'blur 25'),
              _RefRow(cls: 'shadow-2xl', blur: 'blur 50'),
              _RefRow(cls: 'shadow-none', blur: 'no shadow'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Responsive Shadows',
          description:
              'Combine with breakpoint prefixes to scale shadow with screen size.',
          child: WDiv(
            className: 'flex justify-center py-6',
            child: WDiv(
              className: '''
                w-32 h-32 rounded-xl
                bg-white dark:bg-slate-800
                shadow-sm md:shadow-lg xl:shadow-2xl
                flex items-center justify-center
              ''',
              child: const WText(
                'sm: small\nmd: large\nxl: extreme',
                className:
                    'font-mono text-xs text-slate-700 dark:text-slate-300 whitespace-pre text-center',
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ShadowTile extends StatelessWidget {
  final String label;
  final String cls;

  const _ShadowTile({required this.label, required this.cls});

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

class _RefRow extends StatelessWidget {
  final String cls;
  final String blur;

  const _RefRow({required this.cls, required this.blur});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: '''
        flex flex-row items-center justify-between
        px-3 py-2 rounded-md
        bg-slate-50 dark:bg-slate-700/40
      ''',
      children: [
        WText(cls,
            className: 'font-mono text-sm text-slate-700 dark:text-slate-300'),
        WText(blur,
            className: 'font-mono text-sm text-slate-500 dark:text-slate-400'),
      ],
    );
  }
}
