import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class WSpacerBasicExamplePage extends StatelessWidget {
  const WSpacerBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'WSpacer',
      description:
          'Single-purpose SizedBox-backed widget for explicit gaps. h-{n} for vertical, w-{n} for horizontal. Lighter than a styled WDiv.',
      gradient: 'from-slate-500 to-slate-700',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'WSpacer between two stacked widgets. h-2 yields an 8px vertical gap.',
          child: WDiv(
            className: '''
              flex flex-col p-4 rounded-lg
              bg-slate-50 dark:bg-slate-700/40
            ''',
            children: [
              const WText('Label',
                  className: 'font-bold text-slate-900 dark:text-white'),
              const WSpacer(className: 'h-2'),
              WInput(
                placeholder: 'Enter text…',
                className: '''
                  w-full px-3 py-2 rounded
                  border border-slate-300 dark:border-slate-600
                  bg-white dark:bg-slate-800
                ''',
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Vertical Gaps',
          description:
              'Each spacer height controls how far apart the boxes sit.',
          child: WDiv(
            className: 'flex flex-col items-stretch',
            children: const [
              _Box(label: 'A'),
              WSpacer(className: 'h-1'),
              _Box(label: 'h-1 → 4px gap'),
              WSpacer(className: 'h-4'),
              _Box(label: 'h-4 → 16px gap'),
              WSpacer(className: 'h-8'),
              _Box(label: 'h-8 → 32px gap'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Horizontal Gaps',
          description: 'Switch to w-{n} when arranging items in a row.',
          child: WDiv(
            className:
                'flex flex-row items-center p-4 rounded-lg bg-slate-50 dark:bg-slate-700/40',
            children: const [
              _Pill(label: 'Save'),
              WSpacer(className: 'w-2'),
              _Pill(label: 'Cancel'),
              WSpacer(className: 'w-8'),
              _Pill(label: 'Delete'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Arbitrary Pixels',
          description: 'Brackets accept exact pixel values for one-off gaps.',
          child: WDiv(
            className: 'flex flex-col items-stretch',
            children: const [
              _Box(label: 'Above'),
              WSpacer(className: 'h-[13px]'),
              _Box(label: 'Below (13px gap above)'),
            ],
          ),
        ),
      ],
    );
  }
}

class _Box extends StatelessWidget {
  final String label;

  const _Box({required this.label});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: '''
        px-4 py-2 rounded
        bg-white dark:bg-slate-800
        border border-slate-200 dark:border-slate-700
      ''',
      child: WText(
        label,
        className: 'text-slate-700 dark:text-slate-200',
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;

  const _Pill({required this.label});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'px-3 py-1 rounded-full bg-slate-600',
      child: WText(label, className: 'text-white text-sm font-medium'),
    );
  }
}
