import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class WSwitchBasicExamplePage extends StatefulWidget {
  const WSwitchBasicExamplePage({super.key});

  @override
  State<WSwitchBasicExamplePage> createState() =>
      _WSwitchBasicExamplePageState();
}

class _WSwitchBasicExamplePageState extends State<WSwitchBasicExamplePage> {
  bool _notifications = true;
  bool _darkMode = false;
  bool _autoSave = true;
  bool _analytics = false;

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'WSwitch',
      description:
          'Controlled toggle. checked: state prefix activates when value is true.',
      gradient: 'from-teal-500 to-cyan-600',
      children: [
        ExampleSection(
          title: 'Basic Toggle',
          description:
              'Track and thumb are fully className-driven. The thumb is a flex '
              'child; justify-start -> checked:justify-end slides it.',
          child: WDiv(
            className: 'flex flex-row items-center gap-3',
            children: [
              WSwitch(
                value: _notifications,
                onChanged: (val) => setState(() => _notifications = val),
                className: '''
                  w-11 h-6 rounded-full px-0.5 border-2
                  flex items-center justify-start checked:justify-end
                  border-gray-300 dark:border-gray-600
                  bg-gray-200 dark:bg-gray-700
                  checked:bg-teal-500 checked:border-teal-500
                  dark:checked:bg-teal-400 dark:checked:border-teal-400
                ''',
                thumbClassName:
                    'w-4 h-4 rounded-full bg-white dark:bg-gray-100 shadow',
              ),
              WText(
                'Push notifications',
                className: 'text-sm text-gray-700 dark:text-gray-300',
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Settings List',
          description: 'Multiple controlled switches in a vertical list.',
          child: WDiv(
            className: '''
              rounded-xl overflow-hidden
              border border-gray-200 dark:border-gray-700
            ''',
            children: [
              _buildSettingRow(
                label: 'Dark mode',
                description: 'Switch the app to dark theme',
                value: _darkMode,
                onChanged: (v) => setState(() => _darkMode = v),
              ),
              _buildSettingRow(
                label: 'Auto-save',
                description: 'Save changes automatically',
                value: _autoSave,
                onChanged: (v) => setState(() => _autoSave = v),
              ),
              _buildSettingRow(
                label: 'Analytics',
                description: 'Help improve the product',
                value: _analytics,
                onChanged: (v) => setState(() => _analytics = v),
                isLast: true,
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Disabled State',
          description:
              'disabled: true blocks interaction and activates the disabled: prefix.',
          child: WDiv(
            className: 'flex flex-row items-center gap-3',
            children: [
              WSwitch(
                value: true,
                onChanged: null,
                disabled: true,
                className: '''
                  w-11 h-6 rounded-full px-0.5 border-2
                  flex items-center justify-start checked:justify-end
                  border-teal-400 dark:border-teal-600
                  checked:bg-teal-400 checked:border-teal-400
                  dark:checked:bg-teal-600 dark:checked:border-teal-600
                  disabled:opacity-50
                ''',
                thumbClassName:
                    'w-4 h-4 rounded-full bg-white dark:bg-gray-100',
              ),
              WText(
                'Enforced by admin (disabled)',
                className: 'text-sm text-gray-500 dark:text-gray-400',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingRow({
    required String label,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isLast = false,
  }) {
    return WDiv(
      className: '''
        flex flex-row items-center justify-between
        px-5 py-4
        bg-white dark:bg-gray-800
        ${isLast ? '' : 'border-b border-gray-200 dark:border-gray-700'}
      ''',
      children: [
        WDiv(
          className: 'flex flex-col gap-0.5 flex-1',
          children: [
            WText(
              label,
              className: 'text-sm font-medium text-gray-900 dark:text-white',
            ),
            WText(
              description,
              className: 'text-xs text-gray-500 dark:text-gray-400',
            ),
          ],
        ),
        WSwitch(
          value: value,
          onChanged: onChanged,
          className: '''
            w-11 h-6 rounded-full px-0.5 border-2
            flex items-center justify-start checked:justify-end
            border-gray-300 dark:border-gray-600
            bg-gray-200 dark:bg-gray-700
            checked:bg-teal-500 checked:border-teal-500
            dark:checked:bg-teal-400 dark:checked:border-teal-400
          ''',
          thumbClassName:
              'w-4 h-4 rounded-full bg-white dark:bg-gray-100 shadow',
        ),
      ],
    );
  }
}
