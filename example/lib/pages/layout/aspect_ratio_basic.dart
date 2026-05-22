import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class AspectRatioBasicExamplePage extends StatelessWidget {
  const AspectRatioBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Aspect Ratio',
      description:
          'Lock an element to a specific width-to-height ratio. Drop-in for video frames, square thumbnails, and custom ratios.',
      gradient: 'from-amber-400 to-orange-500',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'aspect-square forces 1:1, aspect-video forces 16:9. The width drives the height.',
          child: WDiv(
            className: 'flex flex-col items-stretch gap-4',
            children: const [
              _AspectTile(
                label: 'aspect-square',
                ratioClass: 'aspect-square',
                color: 'bg-amber-500',
              ),
              _AspectTile(
                label: 'aspect-video',
                ratioClass: 'aspect-video',
                color: 'bg-orange-500',
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Video (16:9)',
          description:
              'Standard ratio for embedded video frames or hero images.',
          child: WDiv(
            className: 'flex flex-col items-stretch',
            child: WDiv(
              className:
                  'aspect-video bg-black rounded-lg flex items-center justify-center',
              child: const WText(
                'Video Placeholder',
                className: 'text-white font-medium',
              ),
            ),
          ),
        ),
        ExampleSection(
          title: 'Square (1:1)',
          description:
              'Perfect square at any width. Combine with w-{n} or w-1/2 to control the dimensions.',
          child: WDiv(
            className: 'flex flex-row gap-4',
            children: const [
              _SquareBox(label: 'w-16', sizeClass: 'w-16'),
              _SquareBox(label: 'w-24', sizeClass: 'w-24'),
              _SquareBox(label: 'w-32', sizeClass: 'w-32'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Quick Reference',
          description:
              'Three built-in ratios. Use bracket syntax for anything else.',
          child: WDiv(
            className: 'flex flex-col gap-1',
            children: const [
              _RefRow(cls: 'aspect-auto', ratio: 'null', use: 'No constraint'),
              _RefRow(
                  cls: 'aspect-square', ratio: '1 / 1', use: 'Avatars, thumbs'),
              _RefRow(
                  cls: 'aspect-video', ratio: '16 / 9', use: 'Video frames'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Responsive Design',
          description:
              'Combine aspect-* with breakpoint prefixes to switch ratios per screen size.',
          child: WDiv(
            className: 'flex flex-col items-stretch',
            child: WDiv(
              className: '''
                aspect-square md:aspect-video
                bg-gradient-to-br from-amber-400 to-orange-600 rounded-lg
                flex items-center justify-center
              ''',
              child: const WText(
                'aspect-square md:aspect-video',
                className: 'text-white font-mono text-sm',
              ),
            ),
          ),
        ),
        ExampleSection(
          title: 'Arbitrary Values',
          description:
              'Use aspect-[w/h] for any custom ratio. Both numbers must be numeric.',
          child: WDiv(
            className: 'flex flex-col items-stretch gap-4',
            children: const [
              _AspectTile(
                label: 'aspect-[4/3]',
                ratioClass: 'aspect-[4/3]',
                color: 'bg-amber-600',
              ),
              _AspectTile(
                label: 'aspect-[21/9]',
                ratioClass: 'aspect-[21/9]',
                color: 'bg-orange-600',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AspectTile extends StatelessWidget {
  final String label;
  final String ratioClass;
  final String color;

  const _AspectTile({
    required this.label,
    required this.ratioClass,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className:
          '$ratioClass $color rounded-lg flex items-center justify-center',
      child: WText(label, className: 'text-white font-mono text-sm'),
    );
  }
}

class _SquareBox extends StatelessWidget {
  final String label;
  final String sizeClass;

  const _SquareBox({required this.label, required this.sizeClass});

  @override
  Widget build(BuildContext context) {
    final size = sizeClass.replaceFirst('w-', '');
    return WDiv(
      className:
          '$sizeClass h-$size bg-amber-500 rounded-lg flex items-center justify-center',
      child: WText(label, className: 'text-white font-mono text-xs'),
    );
  }
}

class _RefRow extends StatelessWidget {
  final String cls;
  final String ratio;
  final String use;

  const _RefRow({required this.cls, required this.ratio, required this.use});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: '''
        flex flex-row items-center justify-between gap-3
        px-3 py-2 rounded-md
        bg-slate-50 dark:bg-slate-700/40
      ''',
      children: [
        WText(
          cls,
          className:
              'flex-1 font-mono text-sm text-amber-700 dark:text-amber-400',
        ),
        WText(
          ratio,
          className:
              'w-20 font-mono text-sm text-slate-600 dark:text-slate-300',
        ),
        WText(
          use,
          className:
              'flex-1 text-sm text-slate-600 dark:text-slate-400 text-right',
        ),
      ],
    );
  }
}
