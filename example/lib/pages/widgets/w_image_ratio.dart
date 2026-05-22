import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

const _photoUrl = 'https://picsum.photos/seed/ratio/1200/800';

class WImageRatioExamplePage extends StatelessWidget {
  const WImageRatioExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Image Aspect Ratio',
      description:
          'Pair WImage with aspect-{ratio} to lock the height to a known proportion of the width.',
      gradient: 'from-teal-500 to-emerald-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'w-full + aspect-video produces a 16:9 hero. The image always covers the box.',
          child: WDiv(
            className: 'flex flex-col items-stretch',
            child: WDiv(
              className: 'aspect-video rounded-lg overflow-hidden',
              child: WImage(
                src: _photoUrl,
                className: 'w-full h-full object-cover',
              ),
            ),
          ),
        ),
        ExampleSection(
          title: 'Square Thumbnails',
          description:
              'aspect-square in a grid creates uniform tiles regardless of source dimensions.',
          child: WDiv(
            className: 'grid grid-cols-3 gap-2',
            children: List.generate(
              6,
              (i) => WDiv(
                className: 'aspect-square rounded-lg overflow-hidden',
                child: WImage(
                  src: 'https://picsum.photos/seed/sq$i/300/300',
                  className: 'w-full h-full object-cover',
                ),
              ),
            ),
          ),
        ),
        ExampleSection(
          title: 'Custom Ratio',
          description:
              'Use aspect-[w/h] for arbitrary ratios outside the built-in set.',
          child: WDiv(
            className: 'flex flex-col items-stretch gap-3',
            children: [
              WDiv(
                className: 'aspect-[4/3] rounded-lg overflow-hidden',
                child: WImage(
                  src: _photoUrl,
                  className: 'w-full h-full object-cover',
                ),
              ),
              WDiv(
                className: 'aspect-[21/9] rounded-lg overflow-hidden',
                child: WImage(
                  src: _photoUrl,
                  className: 'w-full h-full object-cover',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
