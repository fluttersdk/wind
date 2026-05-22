import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class TextOverflowTruncateExamplePage extends StatelessWidget {
  const TextOverflowTruncateExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Truncate',
      description:
          'truncate is shorthand for maxLines 1 + softWrap false + TextOverflow.ellipsis. The most common overflow pattern.',
      gradient: 'from-amber-500 to-yellow-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Force a single-line ellipsis on long text. The container width drives the cut-off point.',
          child: WDiv(
            className: 'w-64',
            child: const WText(
              'The quick brown fox jumps over the lazy dog and continues to do so.',
              className: 'truncate text-slate-900 dark:text-white',
            ),
          ),
        ),
        ExampleSection(
          title: 'Inside a Row',
          description:
              'Combine truncate with flex-1 to make a child shrink while siblings stay at their intrinsic width.',
          child: WDiv(
            className: '''
              flex items-center gap-3 p-3 rounded
              bg-slate-50 dark:bg-slate-700/40
            ''',
            children: [
              WDiv(
                className: 'w-10 h-10 rounded-full bg-amber-500 shrink-0',
              ),
              WDiv(
                className: 'flex-1 min-w-0',
                child: const WText(
                  'Jane Doe — Senior Engineer at a long-named company that has many people',
                  className: 'truncate text-slate-900 dark:text-white',
                ),
              ),
              WDiv(
                className:
                    'px-2 py-1 rounded bg-amber-100 dark:bg-amber-900/40 shrink-0',
                child: const WText(
                  'NEW',
                  className:
                      'text-xs font-bold text-amber-700 dark:text-amber-300',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
