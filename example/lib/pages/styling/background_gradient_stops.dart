import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class BackgroundGradientStopsExamplePage extends StatelessWidget {
  const BackgroundGradientStopsExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Gradient Stops',
      description:
          'from-, via-, and to- pick the color stops. Omit "to" to fade into transparent; chain "via" for a smoother arc.',
      gradient: 'from-cyan-400 to-blue-500',
      children: [
        ExampleSection(
          title: 'Single Stop (fade to transparent)',
          description: 'from-{color} alone fades into transparent at the end.',
          child: WDiv(
            className:
                'h-20 rounded-lg bg-gradient-to-r from-green-400 flex items-center justify-center',
            child: const WText(
              'from-green-400',
              className: 'text-white font-mono text-sm',
            ),
          ),
        ),
        ExampleSection(
          title: 'Two Stops',
          description:
              'from-{a} + to-{b} draws a straight color blend between the two.',
          child: WDiv(
            className:
                'h-20 rounded-lg bg-gradient-to-r from-green-400 to-blue-500 flex items-center justify-center',
            child: const WText(
              'from-green-400 to-blue-500',
              className: 'text-white font-mono text-sm',
            ),
          ),
        ),
        ExampleSection(
          title: 'Three Stops',
          description:
              'Insert via-{c} for a three-stop blend. The middle color sits at 50 percent.',
          child: WDiv(
            className:
                'h-20 rounded-lg bg-gradient-to-r from-green-400 via-blue-500 to-purple-600 flex items-center justify-center',
            child: const WText(
              'from-green-400 via-blue-500 to-purple-600',
              className: 'text-white font-mono text-sm',
            ),
          ),
        ),
        ExampleSection(
          title: 'Opacity in Stops',
          description:
              'Append /N to any stop color for alpha. Useful for subtle fade overlays.',
          child: WDiv(
            className: '''
              h-20 rounded-lg
              bg-gradient-to-r from-red-500/80 via-red-500/40 to-red-500/0
              flex items-center justify-center
            ''',
            child: const WText(
              'from-red-500/80 via-red-500/40 to-red-500/0',
              className: 'text-white font-mono text-xs',
            ),
          ),
        ),
      ],
    );
  }
}
