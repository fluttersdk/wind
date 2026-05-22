import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class DarkModeBasicExamplePage extends StatelessWidget {
  const DarkModeBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Dark Mode',
      description:
          'The dark: prefix applies styles only when dark mode is active. Toggle the icon on the right to switch modes and watch every card adapt.',
      gradient: 'from-slate-700 to-slate-900',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Prefix any utility with dark: to give it a separate dark-mode value. Colors, borders, and shadows all switch together.',
          child: WDiv(
            className: '''
              p-6 rounded-xl
              bg-white dark:bg-slate-900
              shadow-lg dark:shadow-none
              border border-gray-200 dark:border-slate-800
            ''',
            child: WText(
              'Dark Mode Support',
              className: 'text-gray-900 dark:text-white font-bold',
            ),
          ),
        ),
        ExampleSection(
          title: 'Adaptive Colors',
          description:
              'Background and text both follow the active mode through paired light/dark tokens on the same className.',
          child: WDiv(
            className: '''
              p-4 rounded-lg
              bg-gray-100 dark:bg-gray-800
            ''',
            child: WText(
              'Adaptive text colors',
              className: 'text-gray-900 dark:text-gray-100',
            ),
          ),
        ),
        ExampleSection(
          title: 'Manual Toggling',
          description:
              'Calling context.windTheme.toggleTheme() flips between light and dark. The toggle button at the top right uses this exact call.',
          child: WDiv(
            className: '''
              p-4 rounded-lg font-mono text-sm
              bg-slate-100 dark:bg-slate-700
              text-slate-700 dark:text-slate-200
            ''',
            child: WText('context.windTheme.toggleTheme();'),
          ),
        ),
        ExampleSection(
          title: 'Responsive Dark Mode',
          description:
              'Combine dark: with breakpoint prefixes. This card is blue on every screen, but turns red on lg+ ONLY when dark mode is active.',
          child: WDiv(
            className: '''
              p-6 rounded-xl text-white text-center font-medium
              bg-blue-500 lg:dark:bg-red-500
            ''',
            child: WText('bg-blue-500 lg:dark:bg-red-500'),
          ),
        ),
        ExampleSection(
          title: 'Best Practices',
          description:
              'Prefer deep slates over pure black, and soften borders so they stay subtle without disappearing in dark mode.',
          child: WDiv(
            className: 'grid grid-cols-1 md:grid-cols-2 gap-4',
            children: [
              _BestPracticeCard(
                heading: 'Recommended',
                bgClass:
                    'bg-white dark:bg-slate-900 border-gray-200 dark:border-slate-800',
                code: 'dark:bg-slate-900',
                tone: _Tone.good,
              ),
              _BestPracticeCard(
                heading: 'Use sparingly',
                bgClass:
                    'bg-white dark:bg-black border-gray-200 dark:border-gray-700',
                code: 'dark:bg-black',
                tone: _Tone.caution,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

enum _Tone { good, caution }

class _BestPracticeCard extends StatelessWidget {
  final String heading;
  final String bgClass;
  final String code;
  final _Tone tone;

  const _BestPracticeCard({
    required this.heading,
    required this.bgClass,
    required this.code,
    required this.tone,
  });

  @override
  Widget build(BuildContext context) {
    final accent = tone == _Tone.good
        ? 'text-emerald-600 dark:text-emerald-400'
        : 'text-amber-600 dark:text-amber-400';

    return WDiv(
      className: '''
        p-6 rounded-xl border
        $bgClass
        flex flex-col gap-2
      ''',
      children: [
        WText(
          heading,
          className: 'text-sm font-semibold $accent',
        ),
        WText(
          code,
          className: '''
            font-mono text-sm
            text-gray-900 dark:text-white
          ''',
        ),
      ],
    );
  }
}
