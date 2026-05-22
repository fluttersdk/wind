import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class DirectionalExamplePage extends StatelessWidget {
  const DirectionalExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Directional Spacing',
      description:
          'Target a single axis (px-, py-) or a single side (pt-, pr-, pb-, pl-). Same shape for margin.',
      gradient: 'from-pink-500 to-rose-600',
      children: [
        ExampleSection(
          title: 'Horizontal Axis (px-)',
          description:
              'px-N adds N units of padding on both the left and right sides.',
          child: WDiv(
            className: 'flex flex-col gap-2',
            children: const [
              _Box(label: 'px-2', padClass: 'px-2 py-2'),
              _Box(label: 'px-6', padClass: 'px-6 py-2'),
              _Box(label: 'px-12', padClass: 'px-12 py-2'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Vertical Axis (py-)',
          description:
              'py-N adds N units of padding on both the top and bottom.',
          child: WDiv(
            className: 'flex flex-col gap-2',
            children: const [
              _Box(label: 'py-2', padClass: 'px-3 py-2'),
              _Box(label: 'py-6', padClass: 'px-3 py-6'),
              _Box(label: 'py-12', padClass: 'px-3 py-12'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Single Side',
          description:
              'pt-, pr-, pb-, pl- target one side. Use for asymmetric layouts like sidebars or status bars.',
          child: WDiv(
            className: 'flex flex-col gap-2',
            children: const [
              _Box(label: 'pt-8', padClass: 'pt-8 pb-2 px-3'),
              _Box(label: 'pl-12', padClass: 'pl-12 pr-2 py-2'),
              _Box(label: 'pb-8 pr-12', padClass: 'pb-8 pr-12 pt-2 pl-2'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Margin Variants',
          description:
              'mx-, my-, mt-, etc. mirror padding but add space outside the box.',
          child: WDiv(
            className: '''
              p-3 rounded-lg
              bg-pink-50 dark:bg-pink-900/20
            ''',
            children: [
              WDiv(
                className: '''
                  mx-6 my-2 px-3 py-2 rounded
                  bg-pink-500
                ''',
                child: const WText(
                  'mx-6 my-2',
                  className: 'text-white font-mono text-sm',
                ),
              ),
              WDiv(
                className: '''
                  ml-12 mr-2 mt-2 mb-2 px-3 py-2 rounded
                  bg-rose-500
                ''',
                child: const WText(
                  'ml-12 mr-2 mt-2 mb-2',
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

class _Box extends StatelessWidget {
  final String label;
  final String padClass;

  const _Box({required this.label, required this.padClass});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: '$padClass bg-pink-200 dark:bg-pink-900/40 rounded',
      child: WDiv(
        className: 'h-8 bg-pink-500 rounded flex items-center justify-center',
        child: WText(
          label,
          className: 'text-white font-mono text-xs',
        ),
      ),
    );
  }
}
