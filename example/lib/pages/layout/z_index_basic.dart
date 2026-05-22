import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class ZIndexBasicExamplePage extends StatelessWidget {
  const ZIndexBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Z-Index',
      description:
          'z-{n} sets the stack order inside a Stack widget. Higher values render above lower ones.',
      gradient: 'from-violet-600 to-purple-700',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Three overlapping boxes. The z-index decides which one ends up on top.',
          child: SizedBox(
            height: 160,
            child: Stack(
              children: [
                _ZBox(
                    left: 0,
                    top: 0,
                    color: 'bg-blue-500',
                    zClass: 'z-0',
                    label: 'z-0'),
                _ZBox(
                    left: 40,
                    top: 30,
                    color: 'bg-red-500',
                    zClass: 'z-10',
                    label: 'z-10'),
                _ZBox(
                    left: 80,
                    top: 60,
                    color: 'bg-green-500',
                    zClass: 'z-20',
                    label: 'z-20'),
              ],
            ),
          ),
        ),
        ExampleSection(
          title: 'Quick Reference',
          description:
              'Six standard stops cover most UI needs. Use bracket syntax for exact integers.',
          child: WDiv(
            className: 'flex flex-col gap-1',
            children: const [
              _RefRow(cls: 'z-0', value: '0'),
              _RefRow(cls: 'z-10', value: '10'),
              _RefRow(cls: 'z-20', value: '20'),
              _RefRow(cls: 'z-30', value: '30'),
              _RefRow(cls: 'z-40', value: '40'),
              _RefRow(cls: 'z-50', value: '50'),
              _RefRow(cls: 'z-auto', value: 'null (resets)'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Arbitrary Values',
          description: 'z-[N] accepts any integer, positive or negative.',
          child: WDiv(
            className: 'flex flex-col gap-1',
            children: const [
              _RefRow(cls: 'z-[100]', value: '100'),
              _RefRow(cls: 'z-[9999]', value: '9999 (above modals)'),
              _RefRow(cls: 'z-[-1]', value: '-1 (behind)'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Custom Theme Tokens',
          description: 'Add named z-index tokens via WindThemeData.zIndices.',
          child: _CodeBlock(
            code: 'WindThemeData(\n'
                '  zIndices: {\n'
                '    "modal": 9999,\n'
                '    "popover": 5000,\n'
                '  },\n'
                ')\n\n'
                '// Then use: z-modal, z-popover',
          ),
        ),
      ],
    );
  }
}

class _ZBox extends StatelessWidget {
  final double left;
  final double top;
  final String color;
  final String zClass;
  final String label;

  const _ZBox({
    required this.left,
    required this.top,
    required this.color,
    required this.zClass,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: WDiv(
        className: '''
          $zClass $color w-24 h-24 rounded-lg
          flex items-center justify-center
          shadow-lg
        ''',
        child: WText(
          label,
          className: 'text-white font-mono font-bold',
        ),
      ),
    );
  }
}

class _RefRow extends StatelessWidget {
  final String cls;
  final String value;

  const _RefRow({required this.cls, required this.value});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: '''
        flex flex-row items-center justify-between
        px-3 py-2 rounded-md
        bg-slate-50 dark:bg-slate-700/40
      ''',
      children: [
        WText(
          cls,
          className: 'font-mono text-sm text-violet-700 dark:text-violet-400',
        ),
        WText(
          value,
          className: 'font-mono text-sm text-slate-600 dark:text-slate-300',
        ),
      ],
    );
  }
}

class _CodeBlock extends StatelessWidget {
  final String code;

  const _CodeBlock({required this.code});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: '''
        p-4 rounded-lg font-mono text-xs
        bg-slate-900 dark:bg-slate-950
        text-emerald-400
        overflow-x-auto
      ''',
      child: WText(
        code,
        className: 'whitespace-pre text-emerald-400',
      ),
    );
  }
}
