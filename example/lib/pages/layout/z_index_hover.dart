import 'package:material_ui/material_ui.dart';
import 'package:wind_kit/wind_kit.dart';

import '../../widgets/example_scaffold.dart';

class ZIndexHoverExamplePage extends StatelessWidget {
  const ZIndexHoverExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Paint Order and Hover',
      description:
          'Overlapping children paint in source order: the last child sits on top. Hover changes the shadow, not the stacking.',
      gradient: 'from-violet-600 to-purple-700',
      children: [
        ExampleSection(
          title: 'Source Order',
          description:
              'Card 4 is declared last, so it paints over Card 3, and so on down the row. Hovering a card deepens its shadow but does not bring it forward.',
          child: SizedBox(
            height: 160,
            child: Stack(
              children: const [
                _HoverCard(
                  left: 0,
                  color: 'bg-indigo-500 dark:bg-indigo-600',
                  label: 'Card 1',
                ),
                _HoverCard(
                  left: 60,
                  color: 'bg-purple-500 dark:bg-purple-600',
                  label: 'Card 2',
                ),
                _HoverCard(
                  left: 120,
                  color: 'bg-fuchsia-500 dark:bg-fuchsia-600',
                  label: 'Card 3',
                ),
                _HoverCard(
                  left: 180,
                  color: 'bg-pink-500 dark:bg-pink-600',
                  label: 'Card 4',
                ),
              ],
            ),
          ),
        ),
        ExampleSection(
          title: 'Hover Shadow',
          description:
              'A hover: variant can still deepen the shadow, which gives a lifted feel without changing the paint order.',
          child: WAnchor(
            onTap: () {},
            child: WDiv(
              className: '''
                p-6 rounded-xl duration-200
                bg-white dark:bg-slate-800
                shadow-sm hover:shadow-2xl
                border border-slate-200 dark:border-slate-700
              ''',
              child: const WText(
                'shadow-sm hover:shadow-2xl',
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
