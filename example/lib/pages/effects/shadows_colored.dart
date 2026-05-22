import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class ShadowsColoredExamplePage extends StatelessWidget {
  const ShadowsColoredExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Colored Shadows',
      description:
          'shadow-{color} tints the shadow with a theme color. Pair with size for distinct elevation effects.',
      gradient: 'from-slate-700 to-slate-900',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description: 'Each tile pairs shadow-lg with a different color tint.',
          child: WDiv(
            className: 'wrap gap-6 py-4',
            children: const [
              _ColoredTile(label: 'shadow-blue-500', cls: 'shadow-blue-500'),
              _ColoredTile(label: 'shadow-red-500', cls: 'shadow-red-500'),
              _ColoredTile(
                  label: 'shadow-emerald-500', cls: 'shadow-emerald-500'),
              _ColoredTile(label: 'shadow-amber-500', cls: 'shadow-amber-500'),
              _ColoredTile(
                  label: 'shadow-purple-500', cls: 'shadow-purple-500'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Color + Opacity',
          description:
              'Append /N to any shadow color for an alpha tweak. Subtle tinted shadows for hero cards.',
          child: WDiv(
            className: 'wrap gap-6 py-4',
            children: const [
              _ColoredTile(
                  label: 'shadow-red-500/50', cls: 'shadow-red-500/50'),
              _ColoredTile(
                  label: 'shadow-blue-500/30', cls: 'shadow-blue-500/30'),
              _ColoredTile(
                  label: 'shadow-emerald-500/40', cls: 'shadow-emerald-500/40'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Arbitrary Hex',
          description:
              'shadow-[#RRGGBB] applies an exact color outside the theme.',
          child: WDiv(
            className: 'wrap gap-6 py-4',
            children: const [
              _ColoredTile(label: 'shadow-[#50d71e]', cls: 'shadow-[#50d71e]'),
              _ColoredTile(label: 'shadow-[#ff5722]', cls: 'shadow-[#ff5722]'),
            ],
          ),
        ),
      ],
    );
  }
}

class _ColoredTile extends StatelessWidget {
  final String label;
  final String cls;

  const _ColoredTile({required this.label, required this.cls});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'flex flex-col gap-2 items-center',
      children: [
        WDiv(
          className: '''
            w-24 h-24 rounded-lg
            bg-white dark:bg-slate-800
            shadow-lg $cls
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
