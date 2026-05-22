import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class FlexBasicExamplePage extends StatelessWidget {
  const FlexBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Flex Direction',
      description:
          'flex-row puts children left to right (default). flex-col stacks them top to bottom. Reverse variants flip the axis without reordering the source list.',
      gradient: 'from-orange-500 to-red-600',
      children: [
        ExampleSection(
          title: 'Row (Default)',
          description:
              'Just flex creates a horizontal Row. gap-2 inserts the spacer between siblings.',
          child: WDiv(
            className: '''
              flex gap-2 p-4 rounded-lg
              bg-white dark:bg-slate-800
            ''',
            children: const [
              _Box(label: '1', color: 'bg-blue-500'),
              _Box(label: '2', color: 'bg-blue-500'),
              _Box(label: '3', color: 'bg-blue-500'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Column',
          description:
              'flex-col rewires the Flutter widget to a Column. gap-* still works.',
          child: WDiv(
            className: '''
              flex flex-col gap-2 p-4 rounded-lg
              bg-white dark:bg-slate-800
            ''',
            children: const [
              _Box(label: '1', color: 'bg-emerald-500'),
              _Box(label: '2', color: 'bg-emerald-500'),
              _Box(label: '3', color: 'bg-emerald-500'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Reverse',
          description:
              'flex-row-reverse mirrors the axis. Children stay in source order but render right-to-left.',
          child: WDiv(
            className: '''
              flex flex-row-reverse gap-2 p-4 rounded-lg
              bg-white dark:bg-slate-800
            ''',
            children: const [
              _Box(label: 'A', color: 'bg-amber-500'),
              _Box(label: 'B', color: 'bg-amber-500'),
              _Box(label: 'C', color: 'bg-amber-500'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Responsive Direction',
          description:
              'Column on mobile, row on md+. Same children, different shape per breakpoint.',
          child: WDiv(
            className: '''
              flex flex-col md:flex-row gap-2 p-4 rounded-lg
              bg-orange-50 dark:bg-orange-900/20
            ''',
            children: const [
              _Box(label: '1', color: 'bg-orange-500'),
              _Box(label: '2', color: 'bg-orange-500'),
              _Box(label: '3', color: 'bg-orange-500'),
            ],
          ),
        ),
      ],
    );
  }
}

class _Box extends StatelessWidget {
  final String label;
  final String color;

  const _Box({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: '$color w-12 h-12 rounded-lg flex items-center justify-center',
      child: WText(label, className: 'text-white font-bold'),
    );
  }
}
