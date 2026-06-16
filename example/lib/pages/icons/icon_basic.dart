import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

/// Demonstrates WIcon: className-driven sizing and tinting, animations,
/// opacity modifiers, and runtime-dynamic foregroundColor for values that
/// cannot be expressed as a static text-{color} token.
class IconBasicExamplePage extends StatefulWidget {
  const IconBasicExamplePage({super.key});

  @override
  State<IconBasicExamplePage> createState() => _IconBasicExamplePageState();
}

class _IconBasicExamplePageState extends State<IconBasicExamplePage> {
  // Simulates per-category colors coming from a database or runtime config.
  // Using foregroundColor avoids creating a new parser-cache entry per value.
  static const List<(String, Color)> _categoryPalette = <(String, Color)>[
    ('Work', Color(0xFF3B82F6)),
    ('Personal', Color(0xFF10B981)),
    ('Urgent', Color(0xFFEF4444)),
    ('Shopping', Color(0xFFF59E0B)),
    ('Travel', Color(0xFF8B5CF6)),
  ];
  int _categoryIndex = 0;

  (String, Color) get _activeCategory =>
      _categoryPalette[_categoryIndex % _categoryPalette.length];

  @override
  Widget build(BuildContext context) {
    final (categoryName, categoryColor) = _activeCategory;

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
        ExampleSection(
          title: 'Runtime-Dynamic Color',
          description:
              'Use foregroundColor for values unknown at compile time (per-category colors, user themes). '
              'The className keeps text-{size} for sizing; foregroundColor overrides the tint at runtime '
              'without creating a new parser-cache entry per value.',
          child: WDiv(
            className:
                'flex flex-col gap-4 p-4 bg-gray-50 dark:bg-slate-800 rounded-lg',
            children: [
              WDiv(
                className: 'flex flex-row items-center gap-4',
                children: [
                  WIcon(
                    Icons.label,
                    className: 'text-4xl',
                    foregroundColor: categoryColor,
                  ),
                  WDiv(
                    className: 'flex flex-col gap-1',
                    children: [
                      WText(
                        categoryName,
                        className:
                            'text-base font-semibold text-gray-900 dark:text-white',
                      ),
                      WText(
                        '#${categoryColor.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}',
                        className:
                            'text-xs font-mono text-gray-500 dark:text-gray-400',
                      ),
                    ],
                  ),
                ],
              ),
              WAnchor(
                onTap: () => setState(
                  () => _categoryIndex =
                      (_categoryIndex + 1) % _categoryPalette.length,
                ),
                child: const WDiv(
                  className:
                      'px-3 py-2 rounded-md bg-blue-500 hover:bg-blue-600',
                  child: WText(
                    'Cycle category color',
                    className: 'text-white text-sm font-medium',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
