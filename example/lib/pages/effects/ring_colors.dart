import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class RingColorsExamplePage extends StatelessWidget {
  const RingColorsExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Ring Color',
      description:
          'ring-{color} tints the ring with any theme color. Supports the /N opacity modifier.',
      gradient: 'from-amber-500 to-yellow-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Each tile applies a 4px ring tinted with a different color.',
          child: WDiv(
            className: 'wrap gap-6 py-4',
            children: const [
              _ColorRingTile(label: 'ring-blue-500', cls: 'ring-blue-500'),
              _ColorRingTile(label: 'ring-red-500', cls: 'ring-red-500'),
              _ColorRingTile(
                  label: 'ring-emerald-500', cls: 'ring-emerald-500'),
              _ColorRingTile(label: 'ring-purple-500', cls: 'ring-purple-500'),
              _ColorRingTile(label: 'ring-pink-500', cls: 'ring-pink-500'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Color Opacity',
          description:
              'Append /N to fade the ring color. Useful for subtle focus rings on intense backgrounds.',
          child: WDiv(
            className: 'wrap gap-6 py-4',
            children: const [
              _ColorRingTile(label: 'ring-red-500', cls: 'ring-red-500'),
              _ColorRingTile(label: 'ring-red-500/75', cls: 'ring-red-500/75'),
              _ColorRingTile(label: 'ring-red-500/50', cls: 'ring-red-500/50'),
              _ColorRingTile(label: 'ring-red-500/25', cls: 'ring-red-500/25'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Focus Ring Pattern',
          description:
              'Classic focus styling: ring + offset + color triggered by the focus: prefix.',
          child: WInput(
            placeholder: 'Click here to see the focus ring',
            className: '''
              w-full px-3 py-2 rounded-lg
              bg-white dark:bg-slate-800
              border border-gray-300 dark:border-gray-600
              focus:ring-2 focus:ring-amber-500 focus:ring-offset-2
              focus:ring-offset-white dark:focus:ring-offset-slate-900
            ''',
          ),
        ),
      ],
    );
  }
}

class _ColorRingTile extends StatelessWidget {
  final String label;
  final String cls;

  const _ColorRingTile({required this.label, required this.cls});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'flex flex-col gap-2 items-center',
      children: [
        WDiv(
          className: '''
            w-20 h-20 rounded-lg
            bg-white dark:bg-slate-800
            ring-4 $cls
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
