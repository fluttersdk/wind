import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class TextAlignResponsiveExamplePage extends StatelessWidget {
  const TextAlignResponsiveExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Responsive Text Align',
      description:
          'Switch alignment per breakpoint. Mobile readers expect centered hero text; desktop layouts often go left-aligned.',
      gradient: 'from-rose-500 to-red-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Center on mobile, left on md+. Resize the window to see the alignment flip.',
          child: WDiv(
            className: '''
              w-full p-4 rounded
              bg-slate-50 dark:bg-slate-700/40
            ''',
            child: const WText(
              'Responsive Alignment',
              className:
                  'text-center md:text-left text-lg text-slate-900 dark:text-white',
            ),
          ),
        ),
        ExampleSection(
          title: 'Three-Stage Cascade',
          description:
              'left → center → right as the viewport grows. Useful for editorial layouts that re-balance across screen sizes.',
          child: WDiv(
            className: '''
              w-full p-4 rounded
              bg-rose-50 dark:bg-rose-900/20
            ''',
            child: const WText(
              'text-left sm:text-center lg:text-right',
              className:
                  'text-left sm:text-center lg:text-right font-mono text-slate-900 dark:text-white',
            ),
          ),
        ),
      ],
    );
  }
}
