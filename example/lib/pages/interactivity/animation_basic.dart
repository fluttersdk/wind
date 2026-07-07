import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class InteractivityAnimationExamplePage extends StatelessWidget {
  const InteractivityAnimationExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Animation',
      description:
          'animate-{spin|ping|pulse|bounce} adds a continuous motion to any widget. Drop-in for loaders, skeletons, badges, and attention nudges.',
      gradient: 'from-pink-500 to-rose-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'animate-spin on an icon = loader. animate-pulse on a placeholder = skeleton.',
          child: WDiv(
            className: 'wrap gap-6 py-4 items-center',
            children: [
              WDiv(
                className: '''
                  animate-spin w-8 h-8 rounded-full
                  border-4 border-blue-500 border-t-transparent
                ''',
              ),
              WDiv(
                className: 'flex flex-col gap-2 w-48',
                children: [
                  WDiv(
                    className:
                        'animate-pulse h-3 w-full rounded bg-slate-200 dark:bg-slate-700',
                  ),
                  WDiv(
                    className:
                        'animate-pulse h-3 w-2/3 rounded bg-slate-200 dark:bg-slate-700',
                  ),
                ],
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Spin',
          description: 'Continuous 360° rotation. Perfect for loaders.',
          child: WDiv(
            className: 'wrap gap-6 items-center py-4',
            children: [
              WDiv(
                className: '''
                  animate-spin w-10 h-10 rounded-full
                  border-4 border-pink-500 border-t-transparent
                ''',
              ),
              WIcon(
                Icons.refresh,
                className: 'animate-spin text-pink-600 dark:text-pink-400',
              ),
              WIcon(
                Icons.settings_outlined,
                className: 'animate-spin text-slate-600 dark:text-slate-300',
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Ping',
          description:
              'Element scales outward and fades (radar pulse / notification dot).',
          child: WDiv(
            className: 'wrap gap-8 items-center py-6',
            children: const [
              _PingDot(color: 'sky'),
              _PingDot(color: 'rose'),
              _PingDot(color: 'emerald'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Pulse',
          description:
              'Smooth opacity in/out. Use for skeleton loaders and placeholders.',
          child: WDiv(
            className: '''
              animate-pulse flex gap-4 items-center p-3 rounded-lg
              bg-slate-50 dark:bg-slate-700/40
            ''',
            children: [
              WDiv(
                className: '''
                  w-10 h-10 rounded-full
                  bg-slate-200 dark:bg-slate-600
                ''',
              ),
              WDiv(
                className: 'flex flex-col gap-2 flex-1',
                children: [
                  WDiv(
                    className:
                        'h-3 w-2/3 rounded bg-slate-200 dark:bg-slate-600',
                  ),
                  WDiv(
                    className:
                        'h-3 w-1/2 rounded bg-slate-200 dark:bg-slate-600',
                  ),
                ],
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Bounce',
          description:
              'Vertical hop. Scroll prompts, CTA arrows, attention markers.',
          child: WDiv(
            className: 'wrap gap-6 items-center py-6',
            children: [
              WIcon(
                Icons.keyboard_arrow_down,
                className: 'animate-bounce text-slate-500 dark:text-slate-400',
              ),
              WIcon(
                Icons.arrow_upward,
                className: 'animate-bounce text-pink-600 dark:text-pink-400',
              ),
              WDiv(
                className: 'animate-bounce px-3 py-1 rounded-full bg-pink-500',
                child: const WText(
                  'New',
                  className: 'text-white font-bold text-xs',
                ),
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Quick Reference',
          description: 'Five values cover every built-in animation.',
          child: WDiv(
            className: 'flex flex-col gap-1',
            children: const [
              _RefRow(cls: 'animate-none', desc: 'No animation (reset)'),
              _RefRow(cls: 'animate-spin', desc: 'Continuous 360° rotation'),
              _RefRow(cls: 'animate-ping', desc: 'Outward scale + fade'),
              _RefRow(cls: 'animate-pulse', desc: 'Opacity in/out'),
              _RefRow(cls: 'animate-bounce', desc: 'Vertical hop'),
            ],
          ),
        ),
      ],
    );
  }
}

class _PingDot extends StatelessWidget {
  final String color;

  const _PingDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: Stack(
        alignment: Alignment.center,
        children: [
          WDiv(
            className: '''
              animate-ping w-8 h-8
              rounded-full bg-$color-400 opacity-75
            ''',
          ),
          WDiv(
            className: 'w-4 h-4 rounded-full bg-$color-500',
          ),
        ],
      ),
    );
  }
}

class _RefRow extends StatelessWidget {
  final String cls;
  final String desc;

  const _RefRow({required this.cls, required this.desc});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: '''
        flex flex-row items-center justify-between gap-3
        px-3 py-2 rounded-md
        bg-slate-50 dark:bg-slate-700/40
      ''',
      children: [
        WText(cls,
            className: 'font-mono text-sm text-pink-700 dark:text-pink-400'),
        WText(desc, className: 'text-sm text-slate-600 dark:text-slate-300'),
      ],
    );
  }
}
