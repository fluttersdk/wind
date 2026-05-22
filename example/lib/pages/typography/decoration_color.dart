import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class DecorationColorExamplePage extends StatelessWidget {
  const DecorationColorExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Decoration Color',
      description:
          'decoration-{color}-{shade} sets the underline / overline color independent of the text color.',
      gradient: 'from-orange-500 to-amber-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Each row pairs underline with a different decoration color.',
          child: WDiv(
            className: 'flex flex-col gap-2',
            children: const [
              _DecoColorRow(
                label: 'decoration-red-500',
                cls: 'underline decoration-red-500',
              ),
              _DecoColorRow(
                label: 'decoration-green-500',
                cls: 'underline decoration-green-500',
              ),
              _DecoColorRow(
                label: 'decoration-blue-500',
                cls: 'underline decoration-blue-500',
              ),
              _DecoColorRow(
                label: 'decoration-purple-500',
                cls: 'underline decoration-purple-500',
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Independent of Text Color',
          description:
              'text-* and decoration-* resolve separately. Slate text with an amber underline is one short string.',
          child: const WText(
            'Body text with a brand-accent underline',
            className:
                'underline decoration-amber-500 text-slate-700 dark:text-slate-200 text-lg',
          ),
        ),
        ExampleSection(
          title: 'Arbitrary Hex',
          description: 'decoration-[#RRGGBB] for exact hex values.',
          child: const WText(
            'decoration-[#50d71e]',
            className:
                'underline decoration-[#50d71e] text-slate-900 dark:text-white text-lg font-mono',
          ),
        ),
      ],
    );
  }
}

class _DecoColorRow extends StatelessWidget {
  final String label;
  final String cls;

  const _DecoColorRow({required this.label, required this.cls});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'flex flex-row items-baseline gap-4',
      children: [
        WDiv(
          className: 'w-48 shrink-0',
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
