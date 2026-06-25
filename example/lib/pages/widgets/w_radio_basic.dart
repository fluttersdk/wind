import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class WRadioBasicExamplePage extends StatefulWidget {
  const WRadioBasicExamplePage({super.key});

  @override
  State<WRadioBasicExamplePage> createState() => _WRadioBasicExamplePageState();
}

class _WRadioBasicExamplePageState extends State<WRadioBasicExamplePage> {
  String _plan = 'pro';
  String _theme = 'system';
  String? _priority;

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'WRadio',
      description:
          'Controlled radio button. selected: state prefix activates when value == groupValue.',
      gradient: 'from-indigo-500 to-blue-600',
      children: [
        ExampleSection(
          title: 'Plan Selection',
          description:
              'All radios in a group share the same groupValue and onChanged.',
          child: WDiv(
            className: 'flex flex-col gap-3',
            children: [
              _buildRadioRow(
                value: 'starter',
                label: 'Starter',
                description: 'Free, up to 3 projects',
              ),
              _buildRadioRow(
                value: 'pro',
                label: 'Pro',
                description: '\$12 / month, unlimited projects',
              ),
              _buildRadioRow(
                value: 'enterprise',
                label: 'Enterprise',
                description: 'Custom pricing, SSO, SLAs',
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Horizontal Group',
          description: 'Radio buttons arranged in a row.',
          child: WDiv(
            className: 'flex flex-row gap-6',
            children: [
              for (final option in ['light', 'dark', 'system'])
                WDiv(
                  className: 'flex flex-row items-center gap-2',
                  children: [
                    WRadio<String>(
                      value: option,
                      groupValue: _theme,
                      onChanged: (val) => setState(() => _theme = val),
                      className: '''
                        w-5 h-5 rounded-full border-2
                        border-gray-300 dark:border-gray-600
                        items-center justify-center
                        selected:border-indigo-500 dark:selected:border-indigo-400
                        hover:border-indigo-400 dark:hover:border-indigo-300
                      ''',
                      indicatorClassName: '''
                        w-2.5 h-2.5 rounded-full
                        bg-indigo-500 dark:bg-indigo-400
                      ''',
                    ),
                    WText(
                      option[0].toUpperCase() + option.substring(1),
                      className: 'text-sm text-gray-700 dark:text-gray-300',
                    ),
                  ],
                ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Nullable groupValue',
          description:
              'groupValue may be null; no option is selected until the user taps one.',
          child: WDiv(
            className: 'flex flex-col gap-3',
            children: [
              for (final option in ['Low', 'Medium', 'High', 'Critical'])
                WDiv(
                  className: 'flex flex-row items-center gap-3',
                  children: [
                    WRadio<String>(
                      value: option,
                      groupValue: _priority,
                      onChanged: (val) => setState(() => _priority = val),
                      className: '''
                        w-5 h-5 rounded-full border-2
                        border-gray-300 dark:border-gray-600
                        items-center justify-center
                        selected:border-indigo-500 dark:selected:border-indigo-400
                      ''',
                      indicatorClassName: '''
                        w-2.5 h-2.5 rounded-full
                        bg-indigo-500 dark:bg-indigo-400
                      ''',
                    ),
                    WText(
                      option,
                      className: 'text-sm text-gray-700 dark:text-gray-300',
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRadioRow({
    required String value,
    required String label,
    required String description,
  }) {
    final isSelected = _plan == value;
    return WDiv(
      className: '''
        flex flex-row items-center gap-4 p-4 rounded-lg border-2
        border-gray-200 dark:border-gray-700
        bg-white dark:bg-gray-800
        ${isSelected ? 'border-indigo-500 dark:border-indigo-400 bg-indigo-50 dark:bg-indigo-950' : ''}
      ''',
      children: [
        WRadio<String>(
          value: value,
          groupValue: _plan,
          onChanged: (val) => setState(() => _plan = val),
          className: '''
            w-5 h-5 rounded-full border-2
            border-gray-300 dark:border-gray-600
            items-center justify-center
            selected:border-indigo-500 dark:selected:border-indigo-400
          ''',
          indicatorClassName: '''
            w-2.5 h-2.5 rounded-full
            bg-indigo-500 dark:bg-indigo-400
          ''',
        ),
        WDiv(
          className: 'flex flex-col gap-0.5 flex-1',
          children: [
            WText(
              label,
              className: 'text-sm font-semibold text-gray-900 dark:text-white',
            ),
            WText(
              description,
              className: 'text-xs text-gray-500 dark:text-gray-400',
            ),
          ],
        ),
      ],
    );
  }
}
