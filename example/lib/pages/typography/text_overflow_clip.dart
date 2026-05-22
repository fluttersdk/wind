import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class TextOverflowClipExamplePage extends StatelessWidget {
  const TextOverflowClipExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Ellipsis vs Clip',
      description:
          'text-ellipsis ends the line with three dots; text-clip simply cuts at the edge. Side by side comparison below.',
      gradient: 'from-amber-500 to-yellow-600',
      children: [
        ExampleSection(
          title: 'Ellipsis',
          description:
              'text-ellipsis renders the standard three-dot truncation. Most familiar to readers.',
          child: WDiv(
            className: 'w-64',
            child: const WText(
              'The quick brown fox jumps over the lazy dog and continues.',
              className:
                  'truncate text-ellipsis text-slate-900 dark:text-white',
            ),
          ),
        ),
        ExampleSection(
          title: 'Clip',
          description:
              'text-clip cuts at the edge without an ellipsis. Useful when the missing content is implied by surrounding UI.',
          child: WDiv(
            className: 'w-64',
            child: const WText(
              'The quick brown fox jumps over the lazy dog and continues.',
              className: 'truncate text-clip text-slate-900 dark:text-white',
            ),
          ),
        ),
      ],
    );
  }
}
