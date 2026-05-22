import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class WButtonCenteredExamplePage extends StatelessWidget {
  const WButtonCenteredExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'WButton Layouts',
      description:
          'WButton uses flexbox semantics internally. Add justify-center / items-center to control content alignment.',
      gradient: 'from-blue-600 to-indigo-700',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'w-full + justify-center renders a full-width button with centered content.',
          child: WButton(
            onTap: () {},
            className: '''
              w-full bg-blue-500 hover:bg-blue-600
              justify-center py-3 rounded-lg duration-200
            ''',
            child: const WText(
              'Centered Full Width',
              className: 'text-white font-medium',
            ),
          ),
        ),
        ExampleSection(
          title: 'Icon + Label',
          description:
              'Center an icon next to a label with flex items-center justify-center gap-N.',
          child: WButton(
            onTap: () {},
            className: '''
              w-full bg-emerald-500 hover:bg-emerald-600
              py-3 rounded-lg duration-200
            ''',
            child: WDiv(
              className: 'flex flex-row items-center justify-center gap-2',
              children: [
                WIcon(Icons.check, className: 'text-white w-5 h-5'),
                const WText('Confirm', className: 'text-white font-medium'),
              ],
            ),
          ),
        ),
        ExampleSection(
          title: 'Asymmetric Layout',
          description:
              'justify-between pushes icon and text to opposite ends. Useful for "next" / "previous" patterns.',
          child: WButton(
            onTap: () {},
            className: '''
              w-full bg-slate-100 dark:bg-slate-800
              px-4 py-3 rounded-lg
              border border-slate-200 dark:border-slate-700
              hover:border-blue-500 duration-200
            ''',
            child: WDiv(
              className: 'flex flex-row items-center justify-between gap-3',
              children: [
                const WText(
                  'Next step',
                  className: 'text-slate-900 dark:text-white font-medium',
                ),
                WIcon(Icons.arrow_forward,
                    className: 'text-slate-700 dark:text-slate-200'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
