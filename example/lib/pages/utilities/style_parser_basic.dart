import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class StyleParserBasicExamplePage extends StatefulWidget {
  const StyleParserBasicExamplePage({super.key});

  @override
  State<StyleParserBasicExamplePage> createState() =>
      _StyleParserBasicExamplePageState();
}

class _StyleParserBasicExamplePageState
    extends State<StyleParserBasicExamplePage> {
  String _className = 'p-4 bg-blue-500 rounded-lg text-white font-bold';

  @override
  Widget build(BuildContext context) {
    final style = wStyle(context, _className);
    final bgColor = style.decoration?.color;
    final padding = style.padding;
    final radius = (style.decoration?.borderRadius as BorderRadius?)?.topLeft.x;
    final textColor = style.color;
    final fontWeight = style.fontWeight;
    final fontSize = style.fontSize;

    return ExampleScaffold(
      title: 'Style Parser',
      description:
          'wStyle(context, className) returns a WindStyle with resolved Flutter properties. Apply to plain Container/Text widgets when className is not an option.',
      gradient: 'from-purple-500 to-fuchsia-600',
      children: [
        ExampleSection(
          title: 'Try It Live',
          description:
              'Type any utility string. The parser resolves Flutter properties below.',
          child: WDiv(
            className: 'flex flex-col gap-3',
            children: [
              WInput(
                value: _className,
                onChanged: (v) => setState(() => _className = v),
                className: '''
                  w-full px-3 py-2 rounded-lg font-mono text-sm
                  bg-white dark:bg-slate-800
                  border border-slate-300 dark:border-slate-600
                  focus:ring-2 focus:ring-purple-500/30
                ''',
              ),
              Container(
                padding: padding,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius:
                      radius != null ? BorderRadius.circular(radius) : null,
                ),
                child: Text(
                  'Live Preview',
                  style: TextStyle(
                    color: textColor,
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                  ),
                ),
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Resolved Properties',
          description: 'These are read from the WindStyle returned by wStyle.',
          child: WDiv(
            className: 'flex flex-col gap-1',
            children: [
              _PropRow(
                  label: 'decoration.color',
                  value: bgColor?.toString() ?? 'null'),
              _PropRow(label: 'padding', value: padding?.toString() ?? 'null'),
              _PropRow(
                  label: 'decoration.borderRadius',
                  value: radius != null
                      ? 'BorderRadius.all(Radius.circular($radius))'
                      : 'null'),
              _PropRow(
                  label: 'textStyle.color',
                  value: textColor?.toString() ?? 'null'),
              _PropRow(
                  label: 'textStyle.fontWeight',
                  value: fontWeight?.toString() ?? 'null'),
              _PropRow(
                  label: 'textStyle.fontSize',
                  value: fontSize?.toString() ?? 'null'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Apply to Plain Flutter Widgets',
          description:
              'Use wStyle to bring Wind into Container, Text, AppBar, ListTile: anything outside the W-prefixed family.',
          child: _CodeBlock(
            code: 'final style = wStyle(context, "p-4 bg-red-500 rounded");\n\n'
                'return Container(\n'
                '  padding: style.padding,\n'
                '  decoration: style.decoration,\n'
                '  child: Text(\n'
                '    "Native widget",\n'
                '    style: style.textStyle,\n'
                '  ),\n'
                ');',
          ),
        ),
      ],
    );
  }
}

class _PropRow extends StatelessWidget {
  final String label;
  final String value;

  const _PropRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: '''
        flex flex-row items-center justify-between gap-3
        px-3 py-2 rounded-md
        bg-slate-50 dark:bg-slate-700/40
      ''',
      children: [
        WDiv(
          className: 'w-44 shrink-0',
          child: WText(label,
              className:
                  'font-mono text-sm text-purple-700 dark:text-purple-400'),
        ),
        WDiv(
          className: 'flex-1 min-w-0',
          child: WText(value,
              className:
                  'font-mono text-xs text-slate-700 dark:text-slate-200'),
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
      child: WText(code, className: 'whitespace-pre text-emerald-400'),
    );
  }
}
