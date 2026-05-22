import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

const _photoUrl = 'https://picsum.photos/seed/fit/600/400';

class WImageFitExamplePage extends StatelessWidget {
  const WImageFitExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Object Fit',
      description:
          'object-{cover|contain|fill|none|scale-down} controls how the image scales inside its container. Same source, different fit modes.',
      gradient: 'from-teal-500 to-emerald-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Each tile applies a different object-{fit} to the same 256×160 container.',
          child: WDiv(
            className: 'grid grid-cols-1 sm:grid-cols-2 gap-3',
            children: const [
              _FitTile(label: 'object-cover', fit: 'object-cover'),
              _FitTile(label: 'object-contain', fit: 'object-contain'),
              _FitTile(label: 'object-fill', fit: 'object-fill'),
              _FitTile(label: 'object-scale-down', fit: 'object-scale-down'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Quick Reference',
          description: 'Each fit maps to a Flutter BoxFit value.',
          child: WDiv(
            className: 'flex flex-col gap-1',
            children: const [
              _RefRow(cls: 'object-cover', maps: 'BoxFit.cover'),
              _RefRow(cls: 'object-contain', maps: 'BoxFit.contain'),
              _RefRow(cls: 'object-fill', maps: 'BoxFit.fill'),
              _RefRow(cls: 'object-none', maps: 'BoxFit.none'),
              _RefRow(cls: 'object-scale-down', maps: 'BoxFit.scaleDown'),
            ],
          ),
        ),
      ],
    );
  }
}

class _FitTile extends StatelessWidget {
  final String label;
  final String fit;

  const _FitTile({required this.label, required this.fit});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'flex flex-col gap-2',
      children: [
        WText(
          label,
          className: 'font-mono text-xs text-slate-500 dark:text-slate-400',
        ),
        WDiv(
          className:
              'h-40 rounded-lg overflow-hidden bg-slate-200 dark:bg-slate-700',
          child: WImage(
            src: _photoUrl,
            className: 'w-full h-full $fit',
          ),
        ),
      ],
    );
  }
}

class _RefRow extends StatelessWidget {
  final String cls;
  final String maps;

  const _RefRow({required this.cls, required this.maps});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: '''
        flex flex-row items-center justify-between gap-3
        px-3 py-2 rounded-md
        bg-slate-50 dark:bg-slate-700/40
      ''',
      children: [
        WText(cls,
            className: 'font-mono text-sm text-teal-700 dark:text-teal-400'),
        WText(maps,
            className: 'font-mono text-sm text-slate-600 dark:text-slate-300'),
      ],
    );
  }
}
