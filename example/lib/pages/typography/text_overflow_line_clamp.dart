import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class TextOverflowLineClampExamplePage extends StatelessWidget {
  const TextOverflowLineClampExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Line Clamp',
      description:
          'line-clamp-{n} caps the paragraph at n lines and ends with an ellipsis. Any positive integer works.',
      gradient: 'from-amber-500 to-yellow-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Same source text, different clamp counts. Compare 2, 3, and 5 lines.',
          child: WDiv(
            className: 'grid grid-cols-1 md:grid-cols-3 gap-3',
            children: const [
              _ClampTile(label: 'line-clamp-2', cls: 'line-clamp-2'),
              _ClampTile(label: 'line-clamp-3', cls: 'line-clamp-3'),
              _ClampTile(label: 'line-clamp-5', cls: 'line-clamp-5'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Responsive Clamp',
          description:
              '2 lines on mobile, 4 on md+, unlimited on lg+. One className handles all three.',
          child: const WText(
            'Responsive line clamping is a powerful pattern. On small screens, the reader sees only a teaser; on larger screens, the entire body shows. The line-clamp-{n} utility accepts breakpoint prefixes so you can compose the cascade in one declaration. Resize the viewport to watch the cap change at 768px and again at 1024px.',
            className:
                'line-clamp-2 md:line-clamp-4 lg:line-clamp-none text-slate-900 dark:text-white',
          ),
        ),
      ],
    );
  }
}

const _kBodyText =
    'Wind treats line-clamp as a paragraph-level utility. Behind the scenes it sets maxLines to the requested count and applies TextOverflow.ellipsis. The component below uses the same source text at three different clamp values so the truncation behavior is visible side by side.';

class _ClampTile extends StatelessWidget {
  final String label;
  final String cls;

  const _ClampTile({required this.label, required this.cls});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: '''
        flex flex-col gap-2 p-3 rounded-lg
        bg-slate-50 dark:bg-slate-700/40
      ''',
      children: [
        WText(
          label,
          className: 'font-mono text-xs text-slate-500 dark:text-slate-400',
        ),
        WText(
          _kBodyText,
          className: '$cls text-sm text-slate-900 dark:text-white',
        ),
      ],
    );
  }
}
