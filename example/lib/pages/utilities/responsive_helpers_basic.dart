import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class ResponsiveHelpersBasicExamplePage extends StatelessWidget {
  const ResponsiveHelpersBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final breakpoint = context.wActiveBreakpoint;

    return ExampleScaffold(
      title: 'Responsive Helpers',
      description:
          'Dart API for breakpoint detection: context.wIsMobile/Tablet/Desktop, context.wActiveBreakpoint, wScreen(), wScreenIs().',
      gradient: 'from-cyan-500 to-teal-600',
      children: [
        ExampleSection(
          title: 'Live Breakpoint Badge',
          description:
              'Resize the window. The active badge swaps as you cross thresholds.',
          child: WDiv(
            className: 'flex items-center gap-3',
            children: [
              _BreakpointBadge(active: breakpoint),
              WText(
                'width: ${width.toInt()}px',
                className:
                    'font-mono text-sm text-slate-600 dark:text-slate-400',
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Device Class Booleans',
          description:
              'Convenience flags from context. Useful for picking layouts in Dart code.',
          child: WDiv(
            className: 'flex flex-col gap-1',
            children: [
              _BoolRow(label: 'context.wIsMobile', value: context.wIsMobile),
              _BoolRow(label: 'context.wIsTablet', value: context.wIsTablet),
              _BoolRow(label: 'context.wIsDesktop', value: context.wIsDesktop),
            ],
          ),
        ),
        ExampleSection(
          title: 'Breakpoint Pixel Values',
          description:
              'wScreen(context, name) returns the raw px threshold from your theme.',
          child: WDiv(
            className: 'flex flex-col gap-1',
            children: const [
              _BreakpointPxRow(name: 'sm'),
              _BreakpointPxRow(name: 'md'),
              _BreakpointPxRow(name: 'lg'),
              _BreakpointPxRow(name: 'xl'),
              _BreakpointPxRow(name: '2xl'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Conditional Layout',
          description:
              'Common pattern: pick a widget tree from a Dart-side conditional.',
          child: _CodeBlock(
            code: '@override\n'
                'Widget build(BuildContext context) {\n'
                '  if (context.wIsMobile) return const MobileLayout();\n'
                '  if (context.wIsTablet) return const TabletLayout();\n'
                '  return const DesktopLayout();\n'
                '}',
          ),
        ),
      ],
    );
  }
}

class _BreakpointBadge extends StatelessWidget {
  final String active;

  const _BreakpointBadge({required this.active});

  @override
  Widget build(BuildContext context) {
    final color = switch (active) {
      'base' => 'bg-red-500',
      'sm' => 'bg-orange-500',
      'md' => 'bg-yellow-500',
      'lg' => 'bg-green-500',
      'xl' => 'bg-blue-500',
      '2xl' => 'bg-purple-500',
      _ => 'bg-slate-500',
    };
    return WDiv(
      className: '$color px-4 py-2 rounded-lg',
      child: WText(
        active,
        className: 'text-white font-mono font-bold',
      ),
    );
  }
}

class _BoolRow extends StatelessWidget {
  final String label;
  final bool value;

  const _BoolRow({required this.label, required this.value});

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
            className: 'font-mono text-sm text-cyan-700 dark:text-cyan-400'),
        WDiv(
          className: value
              ? 'px-2 py-0.5 rounded bg-emerald-500'
              : 'px-2 py-0.5 rounded bg-slate-400 dark:bg-slate-600',
          child: WText(
            value.toString(),
            className: 'text-white font-mono text-xs font-bold',
          ),
        ),
      ],
    );
  }
}

class _BreakpointPxRow extends StatelessWidget {
  final String name;

  const _BreakpointPxRow({required this.name});

  @override
  Widget build(BuildContext context) {
    final px = wScreen(context, name);
    return WDiv(
      className: '''
        flex flex-row items-center justify-between gap-3
        px-3 py-2 rounded-md
        bg-slate-50 dark:bg-slate-700/40
      ''',
      children: [
        WText('wScreen(context, "$name")',
            className: 'font-mono text-sm text-cyan-700 dark:text-cyan-400'),
        WText(px != null ? '${px}px' : 'null',
            className: 'font-mono text-sm text-slate-700 dark:text-slate-200'),
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
