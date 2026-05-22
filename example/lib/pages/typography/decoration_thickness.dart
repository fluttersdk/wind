import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class DecorationThicknessExamplePage extends StatelessWidget {
  const DecorationThicknessExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Decoration Thickness',
      description:
          'decoration-{N} sets the underline thickness in pixels. Standard scale runs 0, 1, 2, 4, 8; brackets accept arbitrary values.',
      gradient: 'from-orange-500 to-amber-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Each row uses a different decoration-{N}. Watch the underline get heavier as the number grows.',
          child: WDiv(
            className: 'flex flex-col gap-2',
            children: const [
              _ThickRow(label: 'decoration-1', cls: 'underline decoration-1'),
              _ThickRow(label: 'decoration-2', cls: 'underline decoration-2'),
              _ThickRow(label: 'decoration-4', cls: 'underline decoration-4'),
              _ThickRow(label: 'decoration-8', cls: 'underline decoration-8'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Arbitrary Thickness',
          description: 'Brackets accept exact px values.',
          child: const WText(
            'decoration-[3px]',
            className:
                'underline decoration-[3px] text-lg text-slate-900 dark:text-white',
          ),
        ),
      ],
    );
  }
}

class _ThickRow extends StatelessWidget {
  final String label;
  final String cls;

  const _ThickRow({required this.label, required this.cls});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'flex flex-row items-baseline gap-4',
      children: [
        WDiv(
          className: 'w-40 shrink-0',
          child: WText(
            label,
            className: 'font-mono text-xs text-slate-500 dark:text-slate-400',
          ),
        ),
        WText(
          'The quick brown fox',
          className: '$cls text-lg text-slate-900 dark:text-white',
        ),
      ],
    );
  }
}
