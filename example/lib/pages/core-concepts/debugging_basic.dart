import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class DebuggingBasicExamplePage extends StatefulWidget {
  const DebuggingBasicExamplePage({super.key});

  @override
  State<DebuggingBasicExamplePage> createState() =>
      _DebuggingBasicExamplePageState();
}

class _DebuggingBasicExamplePageState extends State<DebuggingBasicExamplePage> {
  bool _debugEnabled = false;

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Debugging',
      description:
          'Add the debug class to any className to see the resolved widget composition, final styles, and build time in the dev console.',
      gradient: 'from-amber-500 to-orange-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Drop debug anywhere in the className. The Wind parser prints a full report to the dev console on next build.',
          child: WDiv(
            className: '''
              debug flex p-4 rounded-lg
              bg-blue-500
            ''',
            child: const WText(
              'Debugging active',
              className: 'text-white font-medium',
            ),
          ),
        ),
        _ToggleSection(
          enabled: _debugEnabled,
          onToggle: () => setState(() => _debugEnabled = !_debugEnabled),
        ),
        ExampleSection(
          title: 'What Debug Prints',
          description:
              'Each toggle produces three sections in the console output. Each one peels back one layer of the resolution pipeline.',
          child: WDiv(
            className: 'flex flex-col gap-3',
            children: const [
              _OutputCard(
                title: 'Composition Tree',
                body:
                    'Final Flutter widget hierarchy after Wind expands className into Padding / DecoratedBox / Row / ...',
                sample:
                    'Padding(\n  padding: EdgeInsets.all(16.0),\n  child: DecoratedBox(\n    decoration: BoxDecoration(\n      color: Color(0xFF3B82F6),\n      borderRadius: BorderRadius.circular(8.0),\n    ),\n  ),\n)',
              ),
              _OutputCard(
                title: 'Final Styles',
                body:
                    'Resolved WindStyle. Already merged across base, responsive, dark, and state prefixes.',
                sample:
                    'WindStyle(\n  padding: EdgeInsets.all(16.0),\n  backgroundColor: Color(0xFF3B82F6),\n  borderRadius: BorderRadius.circular(8.0),\n  isFlex: true,\n)',
              ),
              _OutputCard(
                title: 'Build Time',
                body:
                    'Microseconds spent parsing className and building the tree. Spikes over 1ms hint at heavy class complexity.',
                sample: 'Build Time: 142µs',
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Quick Reference',
          description:
              'Three pieces of output, one knob. The debug class is widget-scoped: parents and children stay quiet.',
          child: WDiv(
            className: 'flex flex-col gap-1',
            children: const [
              _RefRow(field: 'debug', purpose: 'Utility class on any widget'),
              _RefRow(
                  field: 'Composition Tree', purpose: 'Pseudo-Dart hierarchy'),
              _RefRow(field: 'Final Styles', purpose: 'WindStyle field dump'),
              _RefRow(
                  field: 'Build Time',
                  purpose: 'Microsecond performance audit'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Common Scenarios',
          description:
              'Add debug to confirm responsive resolution, state propagation, or unexpected wrapper widgets.',
          child: WDiv(
            className: 'flex flex-col gap-2',
            children: const [
              _ScenarioRow(
                title: 'Inspecting responsive styles',
                body:
                    'Resize the viewport with debug active. The logger re-fires with the new active breakpoint.',
              ),
              _ScenarioRow(
                title: 'Verifying state variants',
                body:
                    'Hover or focus a widget. The log updates to show the merged hover: / focus: styles.',
              ),
              _ScenarioRow(
                title: 'Analyzing layout layers',
                body:
                    'Use the composition tree to find which utility produced an unexpected Padding or DecoratedBox.',
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'External Tooling',
          description:
              'For E2E drivers and inspectors, call Wind.installDebugResolver() inside kDebugMode at startup. Tree-shaken in release.',
          child: _CodeBlock(
            code: 'import "package:flutter/foundation.dart";\n'
                'import "package:fluttersdk_wind/fluttersdk_wind.dart";\n\n'
                'void main() {\n'
                '  if (kDebugMode) {\n'
                '    Wind.installDebugResolver();\n'
                '  }\n'
                '  runApp(const MyApp());\n'
                '}',
          ),
        ),
      ],
    );
  }
}

class _ToggleSection extends StatelessWidget {
  final bool enabled;
  final VoidCallback onToggle;

  const _ToggleSection({required this.enabled, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final baseClasses =
        'p-6 bg-blue-500 hover:bg-blue-600 rounded-xl shadow-lg';
    final className = enabled ? '$baseClasses debug' : baseClasses;

    return ExampleSection(
      title: 'Try It Live',
      description:
          'Toggle debug on the demo widget. With the dev console open, hover or rebuild to watch the report appear.',
      child: WDiv(
        className: 'flex flex-col gap-4',
        children: [
          WDiv(
            className: 'wrap items-center gap-3',
            children: [
              WButton(
                onTap: onToggle,
                className: enabled
                    ? 'bg-emerald-500 hover:bg-emerald-600 text-white px-4 py-2 rounded-lg'
                    : 'bg-slate-200 hover:bg-slate-300 dark:bg-slate-700 dark:hover:bg-slate-600 px-4 py-2 rounded-lg',
                child: WText(
                  enabled ? 'Debug ON' : 'Debug OFF',
                  className: enabled
                      ? 'text-white font-medium'
                      : 'text-slate-700 dark:text-slate-200 font-medium',
                ),
              ),
              WText(
                enabled
                    ? 'Watch the console for the report.'
                    : 'Click to inject debug into the demo widget below.',
                className: 'text-sm text-slate-600 dark:text-slate-400',
              ),
            ],
          ),
          WDiv(
            key: ValueKey('debug-$enabled'),
            className: className,
            children: [
              const WText(
                'Hover me!',
                className: 'text-lg font-bold text-white',
              ),
              WText(
                'className: "$className"',
                className: 'text-sm font-mono text-blue-100 mt-1',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OutputCard extends StatelessWidget {
  final String title;
  final String body;
  final String sample;

  const _OutputCard({
    required this.title,
    required this.body,
    required this.sample,
  });

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: '''
        flex flex-col gap-2 p-3 rounded-lg
        bg-slate-50 dark:bg-slate-700/40
        border border-slate-200 dark:border-slate-700
      ''',
      children: [
        WText(
          title,
          className: 'font-semibold text-slate-900 dark:text-white',
        ),
        WText(
          body,
          className: 'text-sm text-slate-600 dark:text-slate-400',
        ),
        WDiv(
          className: '''
            mt-1 p-3 rounded font-mono text-xs
            bg-slate-900 dark:bg-slate-950
            overflow-x-auto
          ''',
          child: WText(
            sample,
            className: 'whitespace-pre text-emerald-400',
          ),
        ),
      ],
    );
  }
}

class _RefRow extends StatelessWidget {
  final String field;
  final String purpose;

  const _RefRow({required this.field, required this.purpose});

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
          field,
          className: 'font-mono text-sm text-amber-600 dark:text-amber-400',
        ),
        WText(
          purpose,
          className: 'text-sm text-slate-600 dark:text-slate-400',
        ),
      ],
    );
  }
}

class _ScenarioRow extends StatelessWidget {
  final String title;
  final String body;

  const _ScenarioRow({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: '''
        flex flex-col gap-1 p-3 rounded-lg
        bg-slate-50 dark:bg-slate-700/40
      ''',
      children: [
        WText(
          title,
          className: 'font-medium text-slate-900 dark:text-white',
        ),
        WText(
          body,
          className: 'text-sm text-slate-600 dark:text-slate-400',
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
