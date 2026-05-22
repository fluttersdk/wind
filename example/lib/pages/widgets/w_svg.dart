import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

const _starSvg =
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/></svg>';

const _strokeStarSvg =
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/></svg>';

const _multiColorSvg =
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">'
    '<circle cx="30" cy="50" r="20" fill="#FF5733"/>'
    '<circle cx="60" cy="40" r="20" fill="#33C3FF"/>'
    '<circle cx="50" cy="70" r="20" fill="#FFD700"/>'
    '</svg>';

class WSvgExamplePage extends StatelessWidget {
  const WSvgExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'WSvg',
      description:
          'Utility-styled SVG. fill-{color} for solid shapes, stroke-{color} for outlines. preserve-colors bypasses the tint for multi-color art.',
      gradient: 'from-emerald-500 to-teal-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Solid SVG tinted via fill-{color}. Sizing via w/h or text-{size}.',
          child: WDiv(
            className: 'wrap gap-8 items-center',
            children: [
              WSvg.string(_starSvg, className: 'w-12 h-12 fill-amber-500'),
              WSvg.string(_starSvg, className: 'w-12 h-12 fill-rose-500'),
              WSvg.string(_starSvg, className: 'w-12 h-12 fill-emerald-500'),
              WSvg.string(_starSvg, className: 'w-12 h-12 fill-blue-500'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Stroke vs Fill',
          description:
              'stroke-{color} for line-style SVGs. fill-{color} for solid shapes. stroke takes priority when both are present.',
          child: WDiv(
            className: 'wrap gap-8 items-center',
            children: [
              WSvg.string(_starSvg, className: 'w-16 h-16 fill-emerald-500'),
              WSvg.string(_strokeStarSvg,
                  className: 'w-16 h-16 stroke-emerald-500'),
            ],
          ),
        ),
        ExampleSection(
          title: 'preserve-colors',
          description:
              'For multi-color art (logos, QR codes, illustrations) add preserve-colors to skip the ColorFilter.',
          child: WDiv(
            className: 'wrap gap-8 items-center',
            children: [
              WSvg.string(_multiColorSvg, className: 'w-16 h-16'),
              WSvg.string(_multiColorSvg,
                  className: 'w-16 h-16 preserve-colors'),
              const WText(
                  'left: tinted by default theme color\nright: preserve-colors keeps original',
                  className:
                      'text-xs text-slate-500 dark:text-slate-400 whitespace-pre'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Opacity + Transitions',
          description:
              'opacity-{n} and duration-{ms} compose with the color modifiers.',
          child: WAnchor(
            onTap: () {},
            child: WSvg.string(
              _starSvg,
              className: '''
                w-20 h-20 fill-emerald-500
                opacity-50 hover:opacity-100
                duration-300
              ''',
            ),
          ),
        ),
      ],
    );
  }
}
