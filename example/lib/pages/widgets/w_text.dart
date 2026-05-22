import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class WTextExamplePage extends StatelessWidget {
  const WTextExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'WText',
      description:
          'Utility-styled text. text-{size}, font-{weight}, text-{color}, text-{align} compose freely; supports state prefixes and dark mode pairs.',
      gradient: 'from-indigo-500 to-blue-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'One className string sets size, weight, color, alignment, and line height in one go.',
          child: WText(
            'Design is not just what it looks like and feels like.',
            className: '''
              text-2xl font-bold text-center leading-tight
              text-slate-900 dark:text-white
            ''',
          ),
        ),
        ExampleSection(
          title: 'Sizes',
          description: 'Pulls from theme.fontSizes (xs → 6xl).',
          child: WDiv(
            className: 'flex flex-col gap-2',
            children: const [
              WText('text-xs',
                  className: 'text-xs text-slate-900 dark:text-white'),
              WText('text-base',
                  className: 'text-base text-slate-900 dark:text-white'),
              WText('text-xl',
                  className: 'text-xl text-slate-900 dark:text-white'),
              WText('text-3xl',
                  className: 'text-3xl text-slate-900 dark:text-white'),
              WText('text-5xl',
                  className: 'text-5xl text-slate-900 dark:text-white'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Weights & Style',
          description: 'font-{name} for weight, italic for slant.',
          child: WDiv(
            className: 'flex flex-col gap-1',
            children: const [
              WText('font-thin',
                  className:
                      'font-thin text-lg text-slate-900 dark:text-white'),
              WText('font-normal',
                  className:
                      'font-normal text-lg text-slate-900 dark:text-white'),
              WText('font-bold',
                  className:
                      'font-bold text-lg text-slate-900 dark:text-white'),
              WText('font-bold italic',
                  className:
                      'font-bold italic text-lg text-slate-900 dark:text-white'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Color + Opacity',
          description: 'text-{color} for tint. /N modifier for alpha.',
          child: WDiv(
            className: 'flex flex-col gap-1',
            children: const [
              WText('text-blue-500', className: 'text-blue-500 text-lg'),
              WText('text-blue-500/75', className: 'text-blue-500/75 text-lg'),
              WText('text-blue-500/50', className: 'text-blue-500/50 text-lg'),
              WText('text-emerald-600', className: 'text-emerald-600 text-lg'),
              WText('text-rose-600', className: 'text-rose-600 text-lg'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Layout Compose',
          description:
              'WText accepts padding, background, and borders — Wind auto-wraps in Container.',
          child: WText(
            'Alert: build failed at 14:32. Please retry.',
            className: '''
              bg-red-100 dark:bg-red-900/30
              text-red-700 dark:text-red-300
              p-4 rounded-lg
              border border-red-200 dark:border-red-800
            ''',
          ),
        ),
        ExampleSection(
          title: 'Overflow',
          description:
              'truncate (1-line ellipsis) or line-clamp-{n} (multi-line cap).',
          child: WDiv(
            className: 'flex flex-col gap-3',
            children: [
              WDiv(
                className: 'w-64',
                child: const WText(
                  'A very long single line that will be truncated with an ellipsis.',
                  className: 'truncate text-slate-900 dark:text-white',
                ),
              ),
              const WText(
                'A multi-line block that is intentionally long. line-clamp-2 caps it at two lines and ends in ellipsis. The third line you are reading right now will not appear in the rendered output.',
                className: 'line-clamp-2 text-slate-900 dark:text-white',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
