import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class BackgroundColorOpacityExamplePage extends StatelessWidget {
  const BackgroundColorOpacityExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Background Opacity',
      description:
          'Append /N to any bg-{color} to apply N percent alpha. bg-blue-500/50 = blue with 50 percent opacity.',
      gradient: 'from-blue-500 to-indigo-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Same color, descending opacity. The slash takes any integer 0-100.',
          child: WDiv(
            className: 'wrap gap-3',
            children: const [
              _Swatch(label: 'bg-blue-500', cls: 'bg-blue-500'),
              _Swatch(label: 'bg-blue-500/75', cls: 'bg-blue-500/75'),
              _Swatch(label: 'bg-blue-500/50', cls: 'bg-blue-500/50'),
              _Swatch(label: 'bg-blue-500/25', cls: 'bg-blue-500/25'),
              _Swatch(label: 'bg-blue-500/10', cls: 'bg-blue-500/10'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Overlay Pattern',
          description:
              'Combine with positioning to layer translucent overlays on top of images or gradients.',
          child: WDiv(
            className: '''
              relative h-32 rounded-lg overflow-hidden
              bg-gradient-to-r from-cyan-500 to-blue-600
            ''',
            children: const [
              WDiv(
                className: 'absolute inset-0 bg-black/40',
              ),
              WDiv(
                className: 'absolute inset-0 flex items-center justify-center',
                child: WText(
                  'absolute inset-0 bg-black/40',
                  className: 'text-white font-mono text-sm',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Swatch extends StatelessWidget {
  final String label;
  final String cls;

  const _Swatch({required this.label, required this.cls});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'flex flex-col gap-2 items-start',
      children: [
        WDiv(
          className:
              'w-20 h-20 rounded-lg $cls border border-slate-200 dark:border-slate-700',
        ),
        WText(
          label,
          className: 'font-mono text-xs text-slate-700 dark:text-slate-300',
        ),
      ],
    );
  }
}
