import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class ThemingExamplePage extends StatelessWidget {
  const ThemingExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = WindTheme.dataOf(context);

    return ExampleScaffold(
      title: 'Theme Configuration',
      description:
          'WindThemeData drives every utility. Override any of 24 fields; unset ones inherit the Tailwind-equivalent defaults.',
      gradient: 'from-emerald-500 to-teal-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Wrap the app once. Override only the fields you need; merge with defaults is automatic.',
          child: _CodeBlock(
            code: 'WindTheme(\n'
                '  data: WindThemeData(\n'
                '    colors: {\n'
                '      "brand": Colors.indigo,\n'
                '    },\n'
                '    fontFamilies: {"sans": "Inter"},\n'
                '    baseSpacingUnit: 4.0,\n'
                '  ),\n'
                '  child: MaterialApp(\n'
                '    home: MyHome(),\n'
                '  ),\n'
                ')',
          ),
        ),
        const _ColorPaletteSection(),
        _SpacingScaleSection(themeData: themeData),
        const _TypographyScaleSection(),
        const _BorderRadiusSection(),
        const _ShadowScaleSection(),
        const _AliasesSection(),
        ExampleSection(
          title: 'Theme Change Callbacks',
          description:
              'onThemeChanged fires only on user-initiated toggleTheme() calls. Use it to persist preference.',
          child: _CodeBlock(
            code: 'WindTheme(\n'
                '  data: WindThemeData(),\n'
                '  onThemeChanged: (brightness) {\n'
                '    Vault.set(\n'
                '      "theme_mode",\n'
                '      brightness == Brightness.dark ? "dark" : "light",\n'
                '    );\n'
                '  },\n'
                '  child: MaterialApp(home: MyHome()),\n'
                ')',
          ),
        ),
        ExampleSection(
          title: 'Reset to System',
          description:
              'After a manual toggle, automatic system brightness sync is disabled. Call resetToSystem() to re-enable it.',
          child: _CodeBlock(
            code: 'context.windTheme.resetToSystem();',
          ),
        ),
        ExampleSection(
          title: 'copyWith for Variants',
          description:
              'Build dark or branded variants from a base theme without retyping every field.',
          child: _CodeBlock(
            code: 'final dark = baseTheme.copyWith(\n'
                '  brightness: Brightness.dark,\n'
                '  ringColor: Colors.amber,\n'
                ');',
          ),
        ),
      ],
    );
  }
}

class _ColorPaletteSection extends StatelessWidget {
  const _ColorPaletteSection();

  final _colors = const ['primary', 'slate', 'red', 'green', 'blue', 'purple'];
  final _shades = const [
    '50',
    '100',
    '200',
    '300',
    '400',
    '500',
    '600',
    '700',
    '800',
    '900'
  ];

  @override
  Widget build(BuildContext context) {
    return ExampleSection(
      title: 'Color Palettes',
      description:
          'Define a MaterialColor under colors["brand"] and every shade utility (bg-brand-50 … bg-brand-900) is available.',
      child: WDiv(
        className: 'flex flex-col gap-3',
        children: _colors.map((color) {
          return WDiv(
            className: 'flex flex-col gap-1',
            children: [
              WText(
                color,
                className:
                    'text-sm font-medium capitalize text-slate-700 dark:text-slate-300',
              ),
              WDiv(
                className: 'flex gap-1 overflow-x-auto',
                children: _shades.map((shade) {
                  return WDiv(
                    className: 'w-8 h-8 rounded shrink-0 bg-$color-$shade',
                  );
                }).toList(),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _SpacingScaleSection extends StatelessWidget {
  final WindThemeData themeData;

  const _SpacingScaleSection({required this.themeData});

  @override
  Widget build(BuildContext context) {
    final values = const ['1', '2', '3', '4', '6', '8', '10', '12', '16'];
    final base = themeData.baseSpacingUnit;

    return ExampleSection(
      title: 'Spacing Scale',
      description:
          'Each numeric step multiplies baseSpacingUnit (currently ${base}px). p-4 → ${(4 * base).toInt()}px of padding.',
      child: WDiv(
        className: 'flex items-end gap-2 overflow-x-auto',
        children: values.map((value) {
          final pixels = int.parse(value) * base;
          return WDiv(
            className: 'flex flex-col items-center gap-1 shrink-0',
            children: [
              WDiv(
                className: 'w-8 bg-emerald-500 rounded',
                child: SizedBox(height: pixels.toDouble()),
              ),
              WText(
                value,
                className:
                    'text-xs font-mono text-slate-700 dark:text-slate-300',
              ),
              WText(
                '${pixels.toInt()}px',
                className: 'text-xs text-slate-500 dark:text-slate-400',
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _TypographyScaleSection extends StatelessWidget {
  const _TypographyScaleSection();

  @override
  Widget build(BuildContext context) {
    const rows = [
      ('xs', 'text-xs'),
      ('sm', 'text-sm'),
      ('base', 'text-base'),
      ('lg', 'text-lg'),
      ('xl', 'text-xl'),
      ('2xl', 'text-2xl'),
      ('3xl', 'text-3xl'),
    ];

    return ExampleSection(
      title: 'Typography Scale',
      description:
          'fontSizes drives the text-{name} parser. Override per-key to retune the entire app.',
      child: WDiv(
        className: 'flex flex-col gap-3',
        children: rows.map((entry) {
          final (name, className) = entry;
          return WDiv(
            className: 'flex items-baseline gap-4',
            children: [
              WDiv(
                className: 'w-14 shrink-0',
                child: WText(
                  name,
                  className:
                      'text-sm font-mono text-slate-500 dark:text-slate-400',
                ),
              ),
              WDiv(
                className: 'flex-1 min-w-0',
                child: WText(
                  'The quick brown fox jumps over the lazy dog',
                  className:
                      '$className text-slate-900 dark:text-white truncate',
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _BorderRadiusSection extends StatelessWidget {
  const _BorderRadiusSection();

  @override
  Widget build(BuildContext context) {
    const radii = [
      ('none', 'rounded-none'),
      ('sm', 'rounded-sm'),
      ('default', 'rounded'),
      ('md', 'rounded-md'),
      ('lg', 'rounded-lg'),
      ('xl', 'rounded-xl'),
      ('2xl', 'rounded-2xl'),
      ('full', 'rounded-full'),
    ];

    return ExampleSection(
      title: 'Border Radius',
      description:
          'rounded-{key} maps directly to borderRadius entries in the theme.',
      child: WDiv(
        className: 'wrap gap-4',
        children: radii.map((entry) {
          final (name, className) = entry;
          return WDiv(
            className: 'flex flex-col items-center gap-2',
            children: [
              WDiv(className: 'w-12 h-12 bg-emerald-500 $className'),
              WText(
                name,
                className:
                    'text-xs font-mono text-slate-500 dark:text-slate-400',
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _ShadowScaleSection extends StatelessWidget {
  const _ShadowScaleSection();

  @override
  Widget build(BuildContext context) {
    const shadows = [
      ('sm', 'shadow-sm'),
      ('default', 'shadow'),
      ('md', 'shadow-md'),
      ('lg', 'shadow-lg'),
      ('xl', 'shadow-xl'),
      ('2xl', 'shadow-2xl'),
    ];

    return ExampleSection(
      title: 'Shadow Scale',
      description:
          'Each key resolves to a List<BoxShadow>. Useful for layered glassy cards.',
      child: WDiv(
        className: 'wrap gap-6 py-4',
        children: shadows.map((entry) {
          final (name, className) = entry;
          return WDiv(
            className: 'flex flex-col items-center gap-3',
            children: [
              WDiv(
                className:
                    'w-16 h-16 bg-white dark:bg-slate-700 rounded-lg $className',
              ),
              WText(
                name,
                className:
                    'text-xs font-mono text-slate-500 dark:text-slate-400',
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _AliasesSection extends StatelessWidget {
  const _AliasesSection();

  @override
  Widget build(BuildContext context) {
    const aliasMap = {
      'row': 'flex flex-row',
      'col': 'flex flex-col',
      'center': 'items-center justify-center',
    };

    return ExampleSection(
      title: 'Aliases',
      description:
          'Map shorthand tokens to full class strings via WindThemeData(aliases: {...}). '
          'The alias is expanded recursively before parsing, so "row center gap-2" and '
          '"flex flex-row items-center justify-center gap-2" produce identical layout.',
      child: WindTheme(
        data: WindThemeData(aliases: aliasMap),
        child: WDiv(
          className: 'flex flex-col gap-4',
          children: [
            WDiv(
              className: 'flex flex-col gap-2',
              children: [
                WText(
                  'Alias form',
                  className: 'text-xs font-semibold uppercase tracking-wide '
                      'text-slate-500 dark:text-slate-400',
                ),
                WDiv(
                  className: 'p-3 rounded-lg bg-slate-100 dark:bg-slate-800',
                  child: WDiv(
                    className: 'row center gap-2',
                    children: [
                      WDiv(
                        className: 'w-8 h-8 rounded bg-emerald-500',
                      ),
                      WDiv(
                        className: 'w-8 h-8 rounded bg-teal-500',
                      ),
                      WDiv(
                        className: 'w-8 h-8 rounded bg-cyan-500',
                      ),
                      WText(
                        'row center gap-2',
                        className:
                            'text-xs font-mono text-slate-600 dark:text-slate-300',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            WDiv(
              className: 'flex flex-col gap-2',
              children: [
                WText(
                  'Expanded form (identical output)',
                  className: 'text-xs font-semibold uppercase tracking-wide '
                      'text-slate-500 dark:text-slate-400',
                ),
                WDiv(
                  className: 'p-3 rounded-lg bg-slate-100 dark:bg-slate-800',
                  child: WDiv(
                    className:
                        'flex flex-row items-center justify-center gap-2',
                    children: [
                      WDiv(
                        className: 'w-8 h-8 rounded bg-emerald-500',
                      ),
                      WDiv(
                        className: 'w-8 h-8 rounded bg-teal-500',
                      ),
                      WDiv(
                        className: 'w-8 h-8 rounded bg-cyan-500',
                      ),
                      WText(
                        'flex flex-row items-center justify-center gap-2',
                        className:
                            'text-xs font-mono text-slate-600 dark:text-slate-300',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            _CodeBlock(
              code: 'WindTheme(\n'
                  '  data: WindThemeData(\n'
                  '    aliases: {\n'
                  "      'row': 'flex flex-row',\n"
                  "      'col': 'flex flex-col',\n"
                  "      'center': 'items-center justify-center',\n"
                  '    },\n'
                  '  ),\n'
                  '  child: WDiv(\n'
                  "    className: 'row center gap-2',\n"
                  '    children: [...],\n'
                  '  ),\n'
                  ')',
            ),
          ],
        ),
      ),
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
      child: WText(
        code,
        className: 'whitespace-pre text-emerald-400',
      ),
    );
  }
}
