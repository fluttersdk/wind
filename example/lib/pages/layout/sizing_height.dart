import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class SizingHeightExamplePage extends StatelessWidget {
  const SizingHeightExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Height',
      description:
          'h-{n} mirrors w-{n} on the vertical axis. h-screen reaches the full viewport. h-full needs a constrained parent.',
      gradient: 'from-yellow-500 to-orange-500',
      children: [
        ExampleSection(
          title: 'Fixed Height',
          description: 'Spacing-scale heights. h-16 = 64px, h-32 = 128px.',
          child: WDiv(
            className: 'flex items-end gap-3',
            children: const [
              _HBar(label: 'h-8', heightClass: 'h-8'),
              _HBar(label: 'h-16', heightClass: 'h-16'),
              _HBar(label: 'h-32', heightClass: 'h-32'),
              _HBar(label: 'h-48', heightClass: 'h-48'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Arbitrary Height',
          description: 'Bracket notation accepts exact pixel values.',
          child: WDiv(
            className: 'flex items-end gap-3',
            children: const [
              _HBar(label: 'h-[60px]', heightClass: 'h-[60px]'),
              _HBar(label: 'h-[120px]', heightClass: 'h-[120px]'),
              _HBar(label: 'h-[180px]', heightClass: 'h-[180px]'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Min and Max Height',
          description:
              'min-h-{n} forces a floor; max-h-{n} caps the height. Combine with overflow-y-auto when content can grow.',
          child: WDiv(
            className: 'flex flex-col gap-2',
            children: [
              WDiv(
                className: '''
                  min-h-32 p-3 rounded
                  bg-yellow-100 dark:bg-yellow-900/30
                ''',
                child: const WText(
                  'min-h-32: at least 128px tall',
                  className: 'text-sm text-slate-700 dark:text-slate-200',
                ),
              ),
              WDiv(
                className: '''
                  max-h-32 overflow-y-auto p-3 rounded
                  bg-orange-100 dark:bg-orange-900/30
                ''',
                children: List.generate(
                  10,
                  (i) => WText(
                    'Row ${i + 1}',
                    className:
                        'text-sm text-slate-700 dark:text-slate-200 py-1',
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

class _HBar extends StatelessWidget {
  final String label;
  final String heightClass;

  const _HBar({required this.label, required this.heightClass});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'flex flex-col items-center gap-1',
      children: [
        WText(
          label,
          className: 'font-mono text-xs text-slate-500 dark:text-slate-400',
        ),
        WDiv(
          className: '$heightClass w-12 rounded bg-orange-500',
        ),
      ],
    );
  }
}
