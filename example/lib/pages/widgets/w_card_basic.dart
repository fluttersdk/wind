import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class WCardBasicExamplePage extends StatelessWidget {
  const WCardBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'WCard',
      description:
          'Surface container with optional header and footer slots. All styling is className-driven.',
      gradient: 'from-slate-500 to-gray-700',
      children: [
        ExampleSection(
          title: 'Basic Card',
          description:
              'Rounded surface with border and shadow. The body is the required child slot.',
          child: WCard(
            className: '''
              rounded-xl
              bg-white dark:bg-gray-800
              border border-gray-200 dark:border-gray-700
              shadow-md
              p-5
            ''',
            child: WDiv(
              className: 'flex flex-col gap-2',
              children: [
                WText(
                  'Workspace Storage',
                  className:
                      'text-base font-semibold text-gray-900 dark:text-white',
                ),
                WText(
                  '14.2 GB of 20 GB used',
                  className: 'text-sm text-gray-500 dark:text-gray-400',
                ),
              ],
            ),
          ),
        ),
        ExampleSection(
          title: 'Card with Header',
          description: 'Pass header: to render a widget above the body.',
          child: WCard(
            className: '''
              rounded-xl
              bg-white dark:bg-gray-800
              border border-gray-200 dark:border-gray-700
              overflow-hidden
            ''',
            header: WDiv(
              className: '''
                px-5 py-4
                border-b border-gray-200 dark:border-gray-700
                bg-gray-50 dark:bg-gray-900
              ''',
              child: WText(
                'Recent Activity',
                className:
                    'text-sm font-semibold text-gray-700 dark:text-gray-300',
              ),
            ),
            child: WDiv(
              className: 'flex flex-col gap-0',
              children: [
                _buildActivityRow(
                  context,
                  label: 'alice@example.com signed in',
                  time: '2 min ago',
                ),
                _buildActivityRow(
                  context,
                  label: 'bob@example.com uploaded a file',
                  time: '14 min ago',
                ),
                _buildActivityRow(
                  context,
                  label: 'carol@example.com created a project',
                  time: '1 hour ago',
                ),
              ],
            ),
          ),
        ),
        ExampleSection(
          title: 'Card with Header and Footer',
          description:
              'Pass both header: and footer: for a full three-slot card.',
          child: WCard(
            className: '''
              rounded-xl
              bg-white dark:bg-gray-800
              border border-gray-200 dark:border-gray-700
              overflow-hidden
            ''',
            header: WDiv(
              className: '''
                px-5 py-4
                border-b border-gray-200 dark:border-gray-700
              ''',
              child: WText(
                'Team Plan',
                className:
                    'text-base font-semibold text-gray-900 dark:text-white',
              ),
            ),
            footer: WDiv(
              className: '''
                px-5 py-4
                border-t border-gray-200 dark:border-gray-700
                bg-gray-50 dark:bg-gray-900
                flex flex-row justify-end
              ''',
              child: WButton(
                onTap: () {},
                className: '''
                  px-4 py-2 rounded-lg text-sm font-medium
                  bg-blue-600 dark:bg-blue-500
                  hover:bg-blue-700 dark:hover:bg-blue-600
                ''',
                child: WText(
                  'Upgrade',
                  className: 'text-white',
                ),
              ),
            ),
            child: WDiv(
              className: 'px-5 py-4 flex flex-col gap-1',
              children: [
                WText(
                  '\$49 / month',
                  className: 'text-2xl font-bold text-gray-900 dark:text-white',
                ),
                WText(
                  'Up to 25 team members, 100 GB storage.',
                  className: 'text-sm text-gray-500 dark:text-gray-400',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityRow(BuildContext context,
      {required String label, required String time}) {
    return WDiv(
      className: '''
        flex flex-row items-center justify-between
        px-5 py-3
        border-b border-gray-100 dark:border-gray-700
      ''',
      children: [
        WText(
          label,
          className: 'text-sm text-gray-700 dark:text-gray-300 flex-1',
        ),
        WText(
          time,
          className: 'text-xs text-gray-400 dark:text-gray-500',
        ),
      ],
    );
  }
}
