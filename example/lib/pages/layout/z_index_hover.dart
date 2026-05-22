import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class ZIndexHoverExamplePage extends StatelessWidget {
  const ZIndexHoverExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Z-Index on Hover',
      description:
          'Combine z-* with hover: to bring an overlapping card to the front when the pointer enters it.',
      gradient: 'from-violet-600 to-purple-700',
      children: [
        ExampleSection(
          title: 'Pop on Hover',
          description:
              'Each card sits at z-0 but lifts to z-50 on hover. Try moving the mouse across the row.',
          child: SizedBox(
            height: 160,
            child: Stack(
              children: const [
                _HoverCard(left: 0, color: 'bg-indigo-500', label: 'Card 1'),
                _HoverCard(left: 60, color: 'bg-purple-500', label: 'Card 2'),
                _HoverCard(left: 120, color: 'bg-fuchsia-500', label: 'Card 3'),
                _HoverCard(left: 180, color: 'bg-pink-500', label: 'Card 4'),
              ],
            ),
          ),
        ),
        ExampleSection(
          title: 'Shadow Pairing',
          description:
              'Lifting the card on hover usually pairs with a stronger shadow. Same className technique.',
          child: WAnchor(
            onTap: () {},
            child: WDiv(
              className: '''
                z-0 hover:z-50
                p-6 rounded-xl duration-200
                bg-white dark:bg-slate-800
                shadow-sm hover:shadow-2xl
                border border-slate-200 dark:border-slate-700
              ''',
              child: const WText(
                'z-0 hover:z-50 + shadow-sm hover:shadow-2xl',
                className:
                    'font-mono text-sm text-slate-700 dark:text-slate-200',
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HoverCard extends StatelessWidget {
  final double left;
  final String color;
  final String label;

  const _HoverCard({
    required this.left,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: 20,
      child: WAnchor(
        onTap: () {},
        child: WDiv(
          className: '''
            z-0 hover:z-50
            w-24 h-24 rounded-lg duration-200
            $color
            shadow-md hover:shadow-2xl
            flex items-center justify-center
          ''',
          child: WText(
            label,
            className: 'text-white font-bold text-sm',
          ),
        ),
      ),
    );
  }
}
