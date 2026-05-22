import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class UtilityFirstHeroExamplePage extends StatelessWidget {
  const UtilityFirstHeroExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Utility-First Fundamentals',
      description:
          'Build UIs by composing small, single-purpose utility classes directly on widgets. No more deeply nested decoration trees.',
      gradient: 'from-violet-500 to-fuchsia-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'A single WDiv composes layout, spacing, background, radius, shadow, and border in one className string.',
          child: WDiv(
            className: '''
              flex flex-col gap-4 p-6 rounded-xl
              bg-white dark:bg-slate-800
              shadow-lg dark:shadow-none
              border border-gray-100 dark:border-slate-700
            ''',
            children: [
              WText(
                'Utility-First',
                className:
                    'text-2xl font-bold text-blue-600 dark:text-blue-400',
              ),
              WText(
                'Style your Flutter apps with ease.',
                className: 'text-gray-500 dark:text-gray-400',
              ),
              WButton(
                onTap: () {},
                className: '''
                  bg-blue-600 hover:bg-blue-700
                  text-white px-4 py-2 rounded-lg
                  self-start
                ''',
                child: const WText('Get Started',
                    className: 'text-white font-medium'),
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'The Shift in Thinking',
          description:
              'Traditional Flutter nests Container + BoxDecoration + TextStyle. Wind flattens it to a single className string.',
          child: WDiv(
            className: 'grid grid-cols-1 lg:grid-cols-2 gap-4',
            children: const [
              _CodeCard(
                label: 'Standard Flutter',
                accent: _CodeAccent.muted,
                code:
                    'Container(\n  padding: EdgeInsets.all(16),\n  decoration: BoxDecoration(\n    color: Colors.white,\n    borderRadius: BorderRadius.circular(12),\n    boxShadow: [\n      BoxShadow(\n        color: Colors.black.withOpacity(0.1),\n        blurRadius: 10,\n      ),\n    ],\n  ),\n  child: Text(\n    "Hello World",\n    style: TextStyle(\n      fontSize: 18,\n      fontWeight: FontWeight.bold,\n    ),\n  ),\n)',
              ),
              _CodeCard(
                label: 'With Wind',
                accent: _CodeAccent.win,
                code:
                    'WDiv(\n  className: "p-4 bg-white rounded-xl shadow-lg",\n  child: WText(\n    "Hello World",\n    className: "text-lg font-bold",\n  ),\n)',
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Why Utility-First',
          description:
              'Four architectural advantages over the traditional decoration-tree approach.',
          child: WDiv(
            className: 'grid grid-cols-1 md:grid-cols-2 gap-3',
            children: const [
              _BenefitTile(
                icon: Icons.bolt_outlined,
                title: 'Development Velocity',
                body:
                    'Stay in your widget tree. No jumping between files to adjust styling.',
              ),
              _BenefitTile(
                icon: Icons.tune_outlined,
                title: 'Design Consistency',
                body:
                    'Standardized scale (p-4 = 16px) replaces magic numbers everywhere.',
              ),
              _BenefitTile(
                icon: Icons.handyman_outlined,
                title: 'Improved Maintainability',
                body:
                    'Styles are local to the widget. No CSS-like global side effects.',
              ),
              _BenefitTile(
                icon: Icons.layers_outlined,
                title: 'Declarative Modifiers',
                body:
                    'Responsive (md:), dark mode (dark:), states (hover:) as simple prefixes.',
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'How It Works',
          description:
              'Wind transforms strings into Flutter styles through a cached, four-step pipeline.',
          child: WDiv(
            className: 'flex flex-col gap-2',
            children: const [
              _PipelineStep(
                step: 1,
                title: 'Context Initialization',
                body:
                    'WindContext captures breakpoint, brightness, platform, and theme scales.',
              ),
              _PipelineStep(
                step: 2,
                title: 'Parsing',
                body:
                    'WindParser tokenizes className and delegates to 17 specialized parsers.',
              ),
              _PipelineStep(
                step: 3,
                title: 'Style Composition',
                body: 'Parsers emit an immutable, typed WindStyle object.',
              ),
              _PipelineStep(
                step: 4,
                title: 'Widget Application',
                body:
                    'W-prefixed widgets build the optimal Flutter tree (Padding, DecoratedBox, ...) only when needed.',
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Quick Reference',
          description:
              'Five categories cover the bulk of everyday styling. Each example resolves through a dedicated parser.',
          child: WDiv(
            className: 'grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-3',
            children: const [
              _CategoryChip(label: 'Layout', sample: 'flex grid hidden'),
              _CategoryChip(label: 'Spacing', sample: 'p-4 m-2 gap-4'),
              _CategoryChip(label: 'Sizing', sample: 'w-full h-64'),
              _CategoryChip(label: 'Colors', sample: 'bg-blue-500'),
              _CategoryChip(label: 'Borders', sample: 'rounded-lg ring-2'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Syntax Guide',
          description:
              'Five syntactic patterns cover every utility class shape Wind accepts.',
          child: WDiv(
            className: 'flex flex-col gap-2',
            children: const [
              _SyntaxRow(pattern: 'Standard', example: 'p-4'),
              _SyntaxRow(pattern: 'Negative', example: '-m-4'),
              _SyntaxRow(pattern: 'Arbitrary', example: 'w-[350px]'),
              _SyntaxRow(pattern: 'Opacity', example: 'bg-blue-500/50'),
              _SyntaxRow(pattern: 'Modifier', example: 'md:flex-row'),
            ],
          ),
        ),
      ],
    );
  }
}

enum _CodeAccent { muted, win }

class _CodeCard extends StatelessWidget {
  final String label;
  final _CodeAccent accent;
  final String code;

  const _CodeCard({
    required this.label,
    required this.accent,
    required this.code,
  });

  @override
  Widget build(BuildContext context) {
    final dot = accent == _CodeAccent.win
        ? 'bg-emerald-500'
        : 'bg-red-500 dark:bg-red-400';

    return WDiv(
      className: 'flex flex-col gap-2',
      children: [
        WDiv(
          className: 'flex items-center gap-2',
          children: [
            WDiv(className: 'w-3 h-3 rounded-full $dot'),
            WText(
              label,
              className: 'font-medium text-slate-700 dark:text-slate-300',
            ),
          ],
        ),
        WDiv(
          className: '''
            rounded-lg p-4 font-mono text-xs
            bg-slate-900 dark:bg-slate-950
            text-emerald-400
            overflow-x-auto
          ''',
          child: WText(code, className: 'whitespace-pre text-emerald-400'),
        ),
      ],
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
          className: 'w-5 h-5 text-violet-600 dark:text-violet-400',
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

class _PipelineStep extends StatelessWidget {
  final int step;
  final String title;
  final String body;

  const _PipelineStep({
    required this.step,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: '''
        flex flex-row items-start gap-3 p-3 rounded-lg
        bg-slate-50 dark:bg-slate-700/40
      ''',
      children: [
        WDiv(
          className: '''
            w-7 h-7 rounded-full shrink-0
            flex items-center justify-center
            bg-violet-600 dark:bg-violet-500
          ''',
          child: WText(
            '$step',
            className: 'text-white text-sm font-bold',
          ),
        ),
        WDiv(
          className: 'flex flex-col flex-1 gap-1',
          children: [
            WText(
              title,
              className: 'font-semibold text-slate-900 dark:text-white',
            ),
            WText(
              body,
              className: 'text-sm text-slate-600 dark:text-slate-400',
            ),
          ],
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final String sample;

  const _CategoryChip({required this.label, required this.sample});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: '''
        flex flex-col gap-1 p-3 rounded-lg
        bg-slate-50 dark:bg-slate-700/40
        border border-slate-200 dark:border-slate-700
      ''',
      children: [
        WText(
          label,
          className: 'font-semibold text-slate-900 dark:text-white',
        ),
        WText(
          sample,
          className: 'font-mono text-xs text-violet-600 dark:text-violet-400',
        ),
      ],
    );
  }
}

class _SyntaxRow extends StatelessWidget {
  final String pattern;
  final String example;

  const _SyntaxRow({required this.pattern, required this.example});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: '''
        flex flex-row items-center justify-between
        px-3 py-2 rounded-md
        bg-slate-50 dark:bg-slate-700/40
      ''',
      children: [
        WText(
          pattern,
          className: 'text-sm font-medium text-slate-700 dark:text-slate-300',
        ),
        WText(
          example,
          className: 'font-mono text-sm text-violet-600 dark:text-violet-400',
        ),
      ],
    );
  }
}
