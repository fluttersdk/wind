import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class RingBasicExamplePage extends StatelessWidget {
  const RingBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Ring',
      description:
          'ring-{width} adds an outline that does NOT consume layout space. Perfect for focus indicators and highlights.',
      gradient: 'from-amber-500 to-yellow-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Each tile applies a different ring-{width}. Default ring is 3px and blue-500.',
          child: WDiv(
            className: 'wrap gap-6 py-4',
            children: const [
              _RingTile(label: 'ring-0', cls: 'ring-0'),
              _RingTile(label: 'ring-1', cls: 'ring-1'),
              _RingTile(label: 'ring-2', cls: 'ring-2'),
              _RingTile(label: 'ring (3px)', cls: 'ring'),
              _RingTile(label: 'ring-4', cls: 'ring-4'),
              _RingTile(label: 'ring-8', cls: 'ring-8'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Ring Offset',
          description:
              'ring-offset-{N} adds a transparent gap between the element and the ring.',
          child: WDiv(
            className: 'wrap gap-6 py-4',
            children: const [
              _RingTile(
                label: 'ring-2 ring-offset-0',
                cls: 'ring-2 ring-offset-0',
              ),
              _RingTile(
                label: 'ring-2 ring-offset-2',
                cls:
                    'ring-2 ring-offset-2 ring-offset-white dark:ring-offset-slate-900',
              ),
              _RingTile(
                label: 'ring-2 ring-offset-4',
                cls:
                    'ring-2 ring-offset-4 ring-offset-white dark:ring-offset-slate-900',
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Ring Inset',
          description:
              'ring-inset renders the ring INSIDE the element instead of outside.',
          child: WDiv(
            className: 'flex justify-center py-4',
            child: WDiv(
              className: '''
                w-32 h-32 rounded-xl
                bg-amber-100 dark:bg-amber-900/40
                ring-4 ring-inset ring-amber-500
                flex items-center justify-center
              ''',
              child: const WText(
                'ring-4 ring-inset',
                className:
                    'font-mono text-sm text-amber-700 dark:text-amber-300',
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RingTile extends StatelessWidget {
  final String label;
  final String cls;

  const _RingTile({required this.label, required this.cls});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'flex flex-col gap-2 items-center',
      children: [
        WDiv(
          className: '''
            w-20 h-20 rounded-lg
            bg-amber-200 dark:bg-amber-900/40
            $cls
          ''',
        ),
        WText(
          label,
          className: 'font-mono text-xs text-slate-700 dark:text-slate-300',
        ),
      ],
    );
  }
}
