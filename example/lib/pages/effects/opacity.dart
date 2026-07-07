import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class OpacityExamplePage extends StatelessWidget {
  const OpacityExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Opacity',
      description:
          'opacity-{N} fades the entire element (content + background + borders). For background-only alpha use the color slash modifier instead.',
      gradient: 'from-violet-500 to-purple-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'A 20-step scale from opacity-0 (invisible) to opacity-100 (fully opaque). Pickable in increments of 5.',
          child: WDiv(
            className: 'wrap gap-3',
            children: const [
              _Tile(label: 'opacity-100', cls: 'opacity-100'),
              _Tile(label: 'opacity-75', cls: 'opacity-75'),
              _Tile(label: 'opacity-50', cls: 'opacity-50'),
              _Tile(label: 'opacity-25', cls: 'opacity-25'),
              _Tile(label: 'opacity-10', cls: 'opacity-10'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Interactive States',
          description:
              'Combine with hover: / disabled: / focus: to fade on interaction.',
          child: WDiv(
            className: 'wrap gap-3',
            children: [
              WButton(
                onTap: () {},
                className: '''
                  bg-violet-500 hover:opacity-80
                  text-white px-4 py-2 rounded
                ''',
                child: const WText('hover:opacity-80', className: 'text-white'),
              ),
              WButton(
                onTap: () {},
                disabled: true,
                className: '''
                  bg-violet-500 disabled:opacity-40
                  text-white px-4 py-2 rounded
                ''',
                child:
                    const WText('disabled:opacity-40', className: 'text-white'),
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Element vs Background Opacity',
          description:
              'opacity-50 fades EVERYTHING (text and bg). bg-{color}/50 fades only the background, keeping text crisp.',
          child: WDiv(
            className: 'grid grid-cols-1 sm:grid-cols-2 gap-3',
            children: const [
              _CompareCard(
                label: 'opacity-50',
                cls: 'opacity-50 bg-violet-500 text-white p-4',
                note: 'Both text + bg fade',
              ),
              _CompareCard(
                label: 'bg-violet-500/50',
                cls: 'bg-violet-500/50 text-white p-4',
                note: 'Only bg fades',
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Arbitrary Values',
          description: 'opacity-[0.X] accepts any decimal between 0.0 and 1.0.',
          child: WDiv(
            className: 'wrap gap-3',
            children: const [
              _Tile(label: 'opacity-[0.67]', cls: 'opacity-[0.67]'),
              _Tile(label: 'opacity-[0.33]', cls: 'opacity-[0.33]'),
              _Tile(label: 'opacity-[0.125]', cls: 'opacity-[0.125]'),
            ],
          ),
        ),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  final String label;
  final String cls;

  const _Tile({required this.label, required this.cls});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'flex flex-col gap-2 items-start',
      children: [
        WDiv(className: 'w-20 h-20 rounded-lg bg-violet-600 $cls'),
        WText(
          label,
          className: 'font-mono text-xs text-slate-700 dark:text-slate-300',
        ),
      ],
    );
  }
}

class _CompareCard extends StatelessWidget {
  final String label;
  final String cls;
  final String note;

  const _CompareCard({
    required this.label,
    required this.cls,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'flex flex-col gap-2',
      children: [
        WDiv(
          className: '$cls rounded-lg',
          child: WText(
            'Sample Text: $note',
            className: 'font-medium',
          ),
        ),
        WText(
          label,
          className: 'font-mono text-xs text-slate-700 dark:text-slate-300',
        ),
      ],
    );
  }
}
