import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class IconBasicExamplePage extends StatelessWidget {
  const IconBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'WIcon',
      description:
          'Utility-styled icon. text-{size} sets the size, text-{color} sets the tint. Inherits from the surrounding DefaultTextStyle when unset.',
      gradient: 'from-amber-500 to-orange-500',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description: 'A single WIcon with color + size from className.',
          child: WDiv(
            className: 'flex items-center gap-4',
            children: [
              WIcon(
                Icons.star,
                className: 'text-yellow-400 text-3xl',
              ),
              const WText(
                'text-yellow-400 text-3xl',
                className:
                    'font-mono text-sm text-slate-600 dark:text-slate-300',
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Color Palette',
          description:
              'text-{color} picks from the theme palette. Same icon, different tints.',
          child: WDiv(
            className: 'wrap gap-6 items-center',
            children: [
              WIcon(Icons.favorite, className: 'text-red-500 text-3xl'),
              WIcon(Icons.thumb_up, className: 'text-blue-500 text-3xl'),
              WIcon(Icons.check_circle, className: 'text-emerald-500 text-3xl'),
              WIcon(Icons.warning_amber, className: 'text-amber-500 text-3xl'),
              WIcon(Icons.bolt, className: 'text-purple-500 text-3xl'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Animations',
          description:
              'Drop animate-spin / animate-pulse / animate-bounce on the icon.',
          child: WDiv(
            className: 'wrap gap-8 items-center py-2',
            children: [
              WIcon(Icons.refresh,
                  className:
                      'text-blue-600 dark:text-blue-400 text-3xl animate-spin'),
              WIcon(Icons.notifications,
                  className: 'text-amber-500 text-3xl animate-pulse'),
              WIcon(Icons.arrow_downward,
                  className: 'text-emerald-500 text-3xl animate-bounce'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Color Opacity',
          description:
              'text-{color}/{N} applies an alpha modifier to the icon tint.',
          child: WDiv(
            className: 'wrap gap-6 items-center',
            children: [
              WIcon(Icons.error, className: 'text-red-500 text-3xl'),
              WIcon(Icons.error, className: 'text-red-500/75 text-3xl'),
              WIcon(Icons.error, className: 'text-red-500/50 text-3xl'),
              WIcon(Icons.error, className: 'text-red-500/25 text-3xl'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Interactive Icon',
          description:
              'Wrap in WAnchor + hover: prefix to react to user input.',
          child: WAnchor(
            onTap: () {},
            child: WIcon(
              Icons.settings,
              className: '''
                text-3xl duration-200
                text-slate-400 dark:text-slate-500
                hover:text-blue-500 dark:hover:text-blue-400
                hover:rotate-180
              ''',
            ),
          ),
        ),
      ],
    );
  }
}
