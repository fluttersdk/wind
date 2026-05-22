import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class AnchorBasicExamplePage extends StatelessWidget {
  const AnchorBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'WAnchor',
      description:
          'Foundation interaction wrapper. Detects hover/focus/press and propagates state to descendants via WindAnchorStateProvider. No styling of its own.',
      gradient: 'from-violet-500 to-purple-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Wrap any layout in WAnchor to make its descendants react to hover and focus.',
          child: WAnchor(
            onTap: () {},
            child: WDiv(
              className: '''
                p-4 rounded-lg duration-200
                bg-white dark:bg-slate-800
                hover:bg-gray-100 dark:hover:bg-slate-700
                border border-slate-200 dark:border-slate-700
              ''',
              child: const WText(
                'Hover me',
                className: 'text-slate-900 dark:text-white font-medium',
              ),
            ),
          ),
        ),
        ExampleSection(
          title: 'Gestures',
          description:
              'onTap, onLongPress, and onDoubleTap each map to a separate callback. Click the card to fire onTap.',
          child: WAnchor(
            onTap: () {},
            onLongPress: () {},
            onDoubleTap: () {},
            child: WDiv(
              className: '''
                p-6 rounded-xl duration-200
                bg-violet-500 hover:bg-violet-600
                active:bg-violet-700
              ''',
              child: const WText(
                'Tap / double tap / long press',
                className: 'text-white font-medium',
              ),
            ),
          ),
        ),
        ExampleSection(
          title: 'Disabled State',
          description:
              'isDisabled blocks gestures AND activates the disabled: prefix on descendants.',
          child: WAnchor(
            isDisabled: true,
            onTap: () {},
            child: WDiv(
              className: '''
                p-4 rounded-lg
                bg-violet-500 disabled:bg-slate-300 disabled:opacity-60
                dark:disabled:bg-slate-700
              ''',
              child: const WText(
                'I am disabled',
                className: 'text-white font-medium',
              ),
            ),
          ),
        ),
        ExampleSection(
          title: 'State Propagation',
          description:
              'Hover on the outer card; the inner WText also picks up the hover state via WindAnchorStateProvider.',
          child: WAnchor(
            onTap: () {},
            child: WDiv(
              className: '''
                p-4 rounded-lg duration-200
                bg-white dark:bg-slate-800
                hover:bg-violet-50 dark:hover:bg-violet-900/20
                border border-slate-200 dark:border-slate-700
              ''',
              children: const [
                WText(
                  'Card Title',
                  className: '''
                    font-bold duration-200
                    text-slate-900 dark:text-white
                    hover:text-violet-600 dark:hover:text-violet-400
                  ''',
                ),
                WText(
                  'Hovering anywhere on this card recolors the title above.',
                  className: 'text-sm text-slate-500 dark:text-slate-400 mt-1',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
