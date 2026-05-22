import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

const _photoUrl = 'https://picsum.photos/seed/wind/800/600';
const _avatarUrl = 'https://picsum.photos/seed/avatar/200/200';

class ImageBasicExamplePage extends StatelessWidget {
  const ImageBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'WImage',
      description:
          'Utility-styled image. Network and asset sources. object-{fit}, aspect-*, w-*/h-*, rounded-*, and shadow-* all compose freely.',
      gradient: 'from-teal-500 to-emerald-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Full-width hero with object-cover, rounded corners, and shadow.',
          child: WImage(
            src: _photoUrl,
            alt: 'Forest landscape',
            className: 'w-full h-64 object-cover rounded-xl shadow-lg',
          ),
        ),
        ExampleSection(
          title: 'Avatar Pattern',
          description: 'Circular avatar with ring border and tight crop.',
          child: WDiv(
            className: 'wrap gap-3 items-center',
            children: [
              WImage(
                src: _avatarUrl,
                className: '''
                  w-12 h-12 rounded-full object-cover
                  border-2 border-white dark:border-slate-700
                  shadow-sm
                ''',
              ),
              WImage(
                src: _avatarUrl,
                className: '''
                  w-16 h-16 rounded-full object-cover
                  ring-2 ring-teal-500
                ''',
              ),
              WImage(
                src: _avatarUrl,
                className: '''
                  w-20 h-20 rounded-full object-cover
                  ring-4 ring-emerald-500 ring-offset-2
                  ring-offset-white dark:ring-offset-slate-900
                ''',
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Card Thumbnails',
          description: 'Grid of cards each with a top-rounded image header.',
          child: WDiv(
            className: 'grid grid-cols-1 sm:grid-cols-3 gap-3',
            children: List.generate(
              3,
              (i) => WDiv(
                className: '''
                  flex flex-col rounded-lg overflow-hidden
                  bg-white dark:bg-slate-800
                  border border-slate-200 dark:border-slate-700
                ''',
                children: [
                  WImage(
                    src: 'https://picsum.photos/seed/card$i/400/220',
                    className: 'w-full h-32 object-cover',
                  ),
                  WDiv(
                    className: 'p-3',
                    child: WText(
                      'Card ${i + 1}',
                      className: 'font-semibold text-slate-900 dark:text-white',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        ExampleSection(
          title: 'Interactive',
          description:
              'Wrap in WAnchor for hover/tap. opacity-* and scale-* animate via duration-*.',
          child: WAnchor(
            onTap: () {},
            child: WImage(
              src: _photoUrl,
              className: '''
                w-full h-48 object-cover rounded-xl
                opacity-90 hover:opacity-100 duration-300
              ''',
            ),
          ),
        ),
      ],
    );
  }
}
