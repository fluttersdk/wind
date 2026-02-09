import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Demonstrates the 'debug' class for Wind styling diagnostics.
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
    return WDiv(
      className: 'w-full h-full overflow-y-auto p-4',
      scrollPrimary: true,
      child: WDiv(
        className: 'flex flex-col gap-6 max-w-4xl mx-auto',
        children: [
          _buildHeader(),
          _buildDebugToggle(),
          _buildDemoWidget(),
          _buildOutputExplanation(),
          _buildUsageGuide(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className: 'bg-gradient-to-r from-amber-500 to-orange-600 rounded-xl p-6',
      child: WDiv(
        className: 'flex flex-col gap-2',
        children: [
          WText(
            'Debugging Wind Styles',
            className: 'text-2xl font-bold text-white',
          ),
          WText(
            'Add the "debug" class to any widget to see detailed parsing output in the console.',
            className: 'text-amber-100',
          ),
        ],
      ),
    );
  }

  Widget _buildDebugToggle() {
    return _buildSection(
      title: 'Toggle Debug Mode',
      description:
          'Enable debug to see console output when the widget below renders',
      child: WDiv(
        className: 'flex items-center gap-4',
        children: [
          WButton(
            className: _debugEnabled
                ? 'bg-green-500 hover:bg-green-600 text-white px-4 py-2 rounded-lg'
                : 'bg-slate-200 dark:bg-slate-700 hover:bg-slate-300 dark:hover:bg-slate-600 text-slate-700 dark:text-slate-300 px-4 py-2 rounded-lg',
            onTap: () => setState(() => _debugEnabled = !_debugEnabled),
            child: WText(
              _debugEnabled ? 'Debug ON' : 'Debug OFF',
              className: _debugEnabled
                  ? 'text-white font-medium'
                  : 'text-slate-700 dark:text-slate-300 font-medium',
            ),
          ),
          WText(
            _debugEnabled
                ? 'Check your console for debug output!'
                : 'Click to enable debug logging',
            className: 'text-sm text-slate-500 dark:text-slate-400',
          ),
        ],
      ),
    );
  }

  Widget _buildDemoWidget() {
    // The key forces rebuild when debug mode changes
    final baseClasses =
        'p-6 bg-blue-500 hover:bg-blue-600 text-white rounded-xl shadow-lg';
    final className = _debugEnabled ? '$baseClasses debug' : baseClasses;

    return _buildSection(
      title: 'Demo Widget',
      description:
          'This widget has debug ${_debugEnabled ? "enabled" : "disabled"}',
      child: WDiv(
        key: ValueKey('debug-$_debugEnabled'),
        className: className,
        children: [
          WText('Hover over me!', className: 'text-lg font-bold text-white'),
          WText(
            'className: "$className"',
            className: 'text-sm text-blue-100 mt-2 font-mono',
          ),
        ],
      ),
    );
  }

  Widget _buildOutputExplanation() {
    return _buildSection(
      title: 'What Debug Shows',
      description: 'The debug output includes several sections:',
      child: WDiv(
        className: 'flex flex-col gap-4',
        children: [
          _buildOutputItem(
            icon: '🌳',
            title: 'Composition Tree',
            description:
                'Shows how Wind interprets and composes your className utilities',
            example:
                'WDiv → Container → Padding(16) → DecoratedBox(bg: blue-500)',
          ),
          _buildOutputItem(
            icon: '🎨',
            title: 'Final Styles',
            description:
                'The resolved Flutter styling values after all utilities are applied',
            example:
                'padding: EdgeInsets.all(24), backgroundColor: Color(0xFF3B82F6)',
          ),
          _buildOutputItem(
            icon: '⏱️',
            title: 'Build Time',
            description:
                'How long the parsing took (useful for performance tuning)',
            example: 'Parse time: 0.42ms',
          ),
          _buildOutputItem(
            icon: '🔍',
            title: 'State Resolution',
            description:
                'Which state-prefixed classes were active (hover:, focus:, etc.)',
            example: 'Active states: [hover] → applied: hover:bg-blue-600',
          ),
        ],
      ),
    );
  }

  Widget _buildOutputItem({
    required String icon,
    required String title,
    required String description,
    required String example,
  }) {
    return WDiv(
      className: 'p-4 bg-slate-50 dark:bg-slate-700/50 rounded-lg',
      children: [
        WDiv(
          className: 'flex items-center gap-2',
          children: [
            WText(icon, className: 'text-lg'),
            WText(title,
                className: 'font-semibold text-slate-900 dark:text-white'),
          ],
        ),
        WText(description,
            className: 'text-sm text-slate-600 dark:text-slate-400 mt-1'),
        WDiv(
          className: 'mt-2 p-2 bg-slate-900 rounded font-mono text-xs',
          child: WText(example, className: 'text-green-400'),
        ),
      ],
    );
  }

  Widget _buildUsageGuide() {
    return _buildSection(
      title: 'How to Use',
      description: 'Just add "debug" to any className',
      child: WDiv(
        className: 'flex flex-col gap-3',
        children: [
          WDiv(
            className: 'p-3 bg-slate-900 rounded-lg font-mono text-sm',
            child: WText(
              "// Add 'debug' anywhere in the className\n"
              "WDiv(\n"
              "  className: 'p-4 bg-blue-500 rounded-lg debug',\n"
              "  child: ...\n"
              ")",
              className: 'text-green-400',
            ),
          ),
          WDiv(
            className:
                'p-3 bg-amber-50 dark:bg-amber-900/20 rounded-lg border border-amber-200 dark:border-amber-800',
            children: [
              WText('💡 Tip',
                  className:
                      'font-semibold text-amber-700 dark:text-amber-400'),
              WText(
                'Remove "debug" before production! It adds console overhead.',
                className: 'text-sm text-amber-600 dark:text-amber-300 mt-1',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String description,
    required Widget child,
  }) {
    return WDiv(
      className:
          'flex flex-col gap-4 p-5 bg-white dark:bg-slate-800 rounded-xl border border-slate-200 dark:border-slate-700',
      children: [
        WDiv(
          className: 'flex flex-col gap-1',
          children: [
            WText(title,
                className:
                    'text-lg font-semibold text-slate-900 dark:text-white'),
            WText(description,
                className: 'text-sm text-slate-600 dark:text-slate-400'),
          ],
        ),
        child,
      ],
    );
  }
}
