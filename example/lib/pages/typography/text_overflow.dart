import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class TextOverflowExamplePage extends StatelessWidget {
  const TextOverflowExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Text Overflow',
      description:
          'Control what happens when text outgrows its container. truncate ends in ellipsis. line-clamp-{n} caps a paragraph at n lines.',
      gradient: 'from-amber-500 to-yellow-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'truncate is the most common: single-line, no wrap, ellipsis. line-clamp limits to n lines.',
          child: WDiv(
            className: 'flex flex-col gap-3',
            children: [
              WDiv(
                className: 'w-64',
                child: const WText(
                  'The quick brown fox jumps over the lazy dog.',
                  className: 'truncate text-slate-900 dark:text-white',
                ),
              ),
              WDiv(
                className: 'w-72',
                child: const WText(
                  'A multi-line block of text that is intentionally long. The line-clamp utility caps the visible lines and ends in an ellipsis. Everything past the third line is hidden.',
                  className: 'line-clamp-3 text-slate-900 dark:text-white',
                ),
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Quick Reference',
          description: 'Five utilities cover the bulk of overflow needs.',
          child: WDiv(
            className: 'flex flex-col gap-1',
            children: const [
              _RefRow(
                cls: 'truncate',
                desc: 'maxLines 1 + softWrap false + ellipsis',
              ),
              _RefRow(
                cls: 'text-ellipsis',
                desc: 'TextOverflow.ellipsis',
              ),
              _RefRow(cls: 'text-clip', desc: 'TextOverflow.clip'),
              _RefRow(
                cls: 'line-clamp-{n}',
                desc: 'maxLines n + ellipsis',
              ),
              _RefRow(
                cls: 'line-clamp-none',
                desc: 'maxLines: null (unlimited)',
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Responsive Line Clamp',
          description:
              '2 lines on mobile, 4 lines on tablet, unlimited on desktop. The reader sees a teaser on small screens and the full body on large ones.',
          child: const WText(
            'Responsive line clamping changes the maxLines value across breakpoints. The same paragraph displays a short teaser on a phone, a medium summary on a tablet, and the full text on a desktop. Try resizing the window to walk through every stage.',
            className:
                'line-clamp-2 md:line-clamp-4 lg:line-clamp-none text-slate-900 dark:text-white',
          ),
        ),
      ],
    );
  }
}

class _RefRow extends StatelessWidget {
  final String cls;
  final String desc;

  const _RefRow({required this.cls, required this.desc});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: '''
        flex flex-row items-center justify-between
        px-3 py-2 rounded-md
        bg-slate-50 dark:bg-slate-700/40
      ''',
      children: [
        WText(cls,
            className: 'font-mono text-sm text-amber-700 dark:text-amber-400'),
        WText(desc, className: 'text-sm text-slate-600 dark:text-slate-300'),
      ],
    );
  }
}
