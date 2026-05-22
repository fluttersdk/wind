import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class BackgroundImagePage extends StatelessWidget {
  const BackgroundImagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Background Image',
      description:
          'bg-[url(...)] sets the background image. Pair with bg-cover / bg-contain for sizing and bg-{position} for alignment.',
      gradient: 'from-emerald-500 to-teal-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Network URL inside the bg-[url(...)] bracket syntax. bg-cover scales to fill the container.',
          child: WDiv(
            className: '''
              h-48 w-full rounded-lg
              bg-[url(https://picsum.photos/seed/wind/800/400)]
              bg-cover bg-center
              flex items-end p-4
            ''',
            child: const WText(
              'bg-cover bg-center',
              className:
                  'text-white font-bold font-mono text-sm bg-black/40 px-2 py-1 rounded',
            ),
          ),
        ),
        ExampleSection(
          title: 'Cover vs Contain',
          description:
              'bg-cover scales to FILL (may crop). bg-contain scales to FIT (may leave gaps).',
          child: WDiv(
            className: 'grid grid-cols-1 sm:grid-cols-2 gap-3',
            children: const [
              _ImageTile(label: 'bg-cover', cls: 'bg-cover bg-center'),
              _ImageTile(
                  label: 'bg-contain',
                  cls: 'bg-contain bg-center bg-no-repeat'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Position',
          description:
              'bg-{top|bottom|left|right|center|top-left|...} positions the image.',
          child: WDiv(
            className: 'grid grid-cols-2 sm:grid-cols-3 gap-3',
            children: const [
              _ImageTile(label: 'bg-top', cls: 'bg-cover bg-top'),
              _ImageTile(label: 'bg-center', cls: 'bg-cover bg-center'),
              _ImageTile(label: 'bg-bottom', cls: 'bg-cover bg-bottom'),
            ],
          ),
        ),
      ],
    );
  }
}

class _ImageTile extends StatelessWidget {
  final String label;
  final String cls;

  const _ImageTile({required this.label, required this.cls});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'flex flex-col gap-2',
      children: [
        WDiv(
          className: '''
            h-32 w-full rounded-lg
            bg-[url(https://picsum.photos/seed/wind/800/400)]
            $cls
            bg-slate-200 dark:bg-slate-700
          ''',
        ),
        WText(
          label,
          className: 'font-mono text-xs text-slate-700 dark:text-slate-300',
        ),
      ],
    );
  }
}
