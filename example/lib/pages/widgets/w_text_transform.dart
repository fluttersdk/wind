import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class WTextTransformExamplePage extends StatelessWidget {
  const WTextTransformExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'WText Alignment & Transform',
      description:
          'text-{align} for horizontal alignment. uppercase / lowercase / capitalize / normal-case for case transforms. Apply directly via className.',
      gradient: 'from-indigo-500 to-blue-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description: 'Combine alignment + transform in one declaration.',
          child: WDiv(
            className: 'flex flex-col gap-3',
            children: const [
              WText(
                'centered uppercase text',
                className:
                    'text-center uppercase text-lg text-slate-900 dark:text-white',
              ),
              WText(
                'capitalize me please',
                className: 'capitalize text-lg text-slate-900 dark:text-white',
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Alignment',
          description: 'text-left, text-center, text-right, text-justify.',
          child: WDiv(
            className: 'flex flex-col gap-2',
            children: const [
              _AlignRow(label: 'text-left', cls: 'text-left'),
              _AlignRow(label: 'text-center', cls: 'text-center'),
              _AlignRow(label: 'text-right', cls: 'text-right'),
              _AlignRow(label: 'text-justify', cls: 'text-justify'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Transform',
          description:
              'Four named case transforms. normal-case resets an ancestor transform.',
          child: WDiv(
            className: 'flex flex-col gap-1',
            children: const [
              WText('uppercase example',
                  className:
                      'uppercase text-lg text-slate-900 dark:text-white'),
              WText('LOWERCASE EXAMPLE',
                  className:
                      'lowercase text-lg text-slate-900 dark:text-white'),
              WText('capitalize each word',
                  className:
                      'capitalize text-lg text-slate-900 dark:text-white'),
              WText('Mixed Original Case',
                  className:
                      'normal-case text-lg text-slate-900 dark:text-white'),
            ],
          ),
        ),
      ],
    );
  }
}

class _AlignRow extends StatelessWidget {
  final String label;
  final String cls;

  const _AlignRow({required this.label, required this.cls});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'flex flex-col gap-1',
      children: [
        WText(
          label,
          className: 'font-mono text-xs text-slate-500 dark:text-slate-400',
        ),
        WDiv(
          className: 'w-full p-3 rounded bg-slate-50 dark:bg-slate-700/40',
          child: WText(
            'The quick brown fox jumps over the lazy dog.',
            className: '$cls text-slate-900 dark:text-white',
          ),
        ),
      ],
    );
  }
}
