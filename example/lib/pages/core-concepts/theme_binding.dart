import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class ThemeBindingExamplePage extends StatelessWidget {
  const ThemeBindingExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Theme Binding',
      description:
          'Sync WindThemeData with Flutter\'s MaterialApp ThemeData. Native widgets pick up Wind colors and switch with dark mode automatically.',
      gradient: 'from-sky-500 to-indigo-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'The builder pattern hands you a controller. controller.toThemeData() emits a Material ThemeData wired to Wind tokens.',
          child: _CodeBlock(
            code: 'WindTheme(\n'
                '  data: WindThemeData(\n'
                '    colors: {\n'
                '      "primary": Colors.indigo,\n'
                '      "secondary": Colors.teal,\n'
                '    },\n'
                '  ),\n'
                '  builder: (context, controller) {\n'
                '    return MaterialApp(\n'
                '      theme: controller.toThemeData(),\n'
                '      home: const HomePage(),\n'
                '    );\n'
                '  },\n'
                ')',
          ),
        ),
        ExampleSection(
          title: 'Why Bind Themes',
          description:
              'Binding gives you a single source of truth for colors, typography, and brightness across both Wind and Material widgets.',
          child: WDiv(
            className: 'grid grid-cols-1 md:grid-cols-3 gap-3',
            children: const [
              _BenefitTile(
                icon: Icons.compare_arrows,
                title: 'Consistency',
                body: 'bg-primary-500 matches an ElevatedButton color.',
              ),
              _BenefitTile(
                icon: Icons.swap_vert,
                title: 'Inheritance',
                body:
                    'Standard Flutter widgets pick up Wind fonts and colors automatically.',
              ),
              _BenefitTile(
                icon: Icons.brightness_6,
                title: 'Automation',
                body:
                    'Toggling Wind dark mode flips MaterialApp.brightness in lockstep.',
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Toggling Themes',
          description:
              'The toggle button in this page\'s header calls the exact line below. Try it now; both Wind utilities and Material widgets switch together.',
          child: _CodeBlock(
            code: 'context.windTheme.toggleTheme();',
          ),
        ),
        const _MappingDemo(),
        ExampleSection(
          title: 'Static Binding',
          description:
              'When you do not need runtime toggling, bind once during init and skip the builder.',
          child: _CodeBlock(
            code: 'final theme = WindThemeData(\n'
                '  brightness: Brightness.dark,\n'
                '  colors: {"primary": Colors.purple},\n'
                ');\n\n'
                'return WindTheme(\n'
                '  data: theme,\n'
                '  child: MaterialApp(\n'
                '    theme: theme.toThemeData(),\n'
                '    home: const HomePage(),\n'
                '  ),\n'
                ');',
          ),
        ),
        ExampleSection(
          title: 'Mapping Reference',
          description:
              'How toThemeData() converts Wind tokens into Flutter ThemeData fields.',
          child: WDiv(
            className: 'flex flex-col gap-1',
            children: const [
              _MappingRow(
                from: 'colors["primary"]',
                to: 'colorScheme.primary',
              ),
              _MappingRow(
                from: 'colors["secondary"]',
                to: 'colorScheme.secondary',
              ),
              _MappingRow(
                from: 'colors["error"]',
                to: 'colorScheme.error',
              ),
              _MappingRow(
                from: 'colors["background"]',
                to: 'scaffoldBackgroundColor',
              ),
              _MappingRow(
                from: 'brightness',
                to: 'brightness',
              ),
              _MappingRow(
                from: 'fontFamilies["sans"]',
                to: 'textTheme.fontFamily',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MappingDemo extends StatelessWidget {
  const _MappingDemo();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final entries = [
      ('primary', scheme.primary, 'colorScheme.primary'),
      ('secondary', scheme.secondary, 'colorScheme.secondary'),
      ('surface', scheme.surface, 'colorScheme.surface'),
      ('error', scheme.error, 'colorScheme.error'),
    ];

    return ExampleSection(
      title: 'Live Mapping',
      description:
          'These swatches read directly from Theme.of(context).colorScheme. Toggling dark mode rebuilds them through the WindTheme controller.',
      child: WDiv(
        className: 'grid grid-cols-2 md:grid-cols-4 gap-3',
        children: entries.map((entry) {
          final (name, color, label) = entry;
          return WDiv(
            className: '''
              flex flex-col gap-2 p-3 rounded-lg
              bg-slate-50 dark:bg-slate-700/40
              border border-slate-200 dark:border-slate-700
            ''',
            children: [
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              WText(
                name,
                className:
                    'font-semibold text-slate-900 dark:text-white capitalize',
              ),
              WText(
                label,
                className:
                    'font-mono text-xs text-slate-500 dark:text-slate-400',
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _BenefitTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;

  const _BenefitTile({
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: '''
        flex flex-col gap-2 p-4 rounded-lg
        bg-slate-50 dark:bg-slate-700/40
        border border-slate-200 dark:border-slate-700
      ''',
      children: [
        WIcon(
          icon,
          className: 'w-5 h-5 text-sky-600 dark:text-sky-400',
        ),
        WText(
          title,
          className: 'font-semibold text-slate-900 dark:text-white',
        ),
        WText(
          body,
          className: 'text-sm text-slate-600 dark:text-slate-400',
        ),
      ],
    );
  }
}

class _MappingRow extends StatelessWidget {
  final String from;
  final String to;

  const _MappingRow({required this.from, required this.to});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: '''
        flex flex-row items-center gap-3
        px-3 py-2 rounded-md
        bg-slate-50 dark:bg-slate-700/40
      ''',
      children: [
        WDiv(
          className: 'flex-1',
          child: WText(
            from,
            className: 'font-mono text-sm text-slate-700 dark:text-slate-300',
          ),
        ),
        WIcon(
          Icons.arrow_forward,
          className: 'w-4 h-4 text-slate-400 dark:text-slate-500 shrink-0',
        ),
        WDiv(
          className: 'flex-1',
          child: WText(
            to,
            className: 'font-mono text-sm text-sky-600 dark:text-sky-400',
          ),
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
      child: WText(
        code,
        className: 'whitespace-pre text-emerald-400',
      ),
    );
  }
}
