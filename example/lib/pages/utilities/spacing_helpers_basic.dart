import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class SpacingHelpersBasicExamplePage extends StatelessWidget {
  const SpacingHelpersBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    final unit = context.windThemeData.baseSpacingUnit;

    return ExampleScaffold(
      title: 'Spacing Helpers',
      description:
          'Dart API for the spacing scale: wSpacing(context, N) and context.wSpacingExt(N). Both return N × baseSpacingUnit.',
      gradient: 'from-orange-500 to-red-600',
      children: [
        ExampleSection(
          title: 'Live Scale',
          description:
              'Current baseSpacingUnit: ${unit}px. Each bar below is wSpacing(context, N) wide.',
          child: WDiv(
            className: 'flex flex-col gap-2',
            children: const [
              _SpacingBar(multiplier: 1),
              _SpacingBar(multiplier: 2),
              _SpacingBar(multiplier: 4),
              _SpacingBar(multiplier: 6),
              _SpacingBar(multiplier: 8),
              _SpacingBar(multiplier: 12),
              _SpacingBar(multiplier: 16),
              _SpacingBar(multiplier: 24),
            ],
          ),
        ),
        ExampleSection(
          title: 'Fractional Multipliers',
          description:
              'wSpacing also accepts decimals, useful for tight spacings that the className scale does not include.',
          child: WDiv(
            className: 'flex flex-col gap-2',
            children: const [
              _SpacingBar(multiplier: 0.5),
              _SpacingBar(multiplier: 1.5),
              _SpacingBar(multiplier: 2.5),
              _SpacingBar(multiplier: 3.5),
            ],
          ),
        ),
        ExampleSection(
          title: 'Mixing With Material Widgets',
          description:
              'Wind values plug straight into standard EdgeInsets and SizedBox.',
          child: _CodeBlock(
            code: 'Container(\n'
                '  padding: EdgeInsets.all(context.wSpacingExt(4)), // 16px\n'
                '  child: Text("Hello"),\n'
                ')\n\n'
                'const SizedBox(\n'
                '  width: 0, // placeholder; use wSpacing for dynamic\n'
                ')',
          ),
        ),
        ExampleSection(
          title: 'Raw baseSpacingUnit',
          description:
              'Read the active unit straight from the theme for custom math.',
          child: _CodeBlock(
            code:
                'final unit = context.windThemeData.baseSpacingUnit; // 4.0 by default\n'
                'final custom = (unit * 3) + 2.0;                       // 14.0',
          ),
        ),
      ],
    );
  }
}

class _SpacingBar extends StatelessWidget {
  final num multiplier;

  const _SpacingBar({required this.multiplier});

  @override
  Widget build(BuildContext context) {
    final px = wSpacing(context, multiplier);
    return WDiv(
      className: 'flex flex-row items-center gap-3',
      children: [
        WDiv(
          className: 'w-24 shrink-0',
          child: WText(
            'wSpacing($multiplier)',
            className: 'font-mono text-xs text-slate-500 dark:text-slate-400',
          ),
        ),
        Container(
          width: px,
          height: 12,
          decoration: BoxDecoration(
            color: wColor(context, 'orange', shade: 500),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        WText(
          '${px.toStringAsFixed(1)}px',
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
