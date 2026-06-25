import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class WBadgeBasicExamplePage extends StatefulWidget {
  const WBadgeBasicExamplePage({super.key});

  @override
  State<WBadgeBasicExamplePage> createState() => _WBadgeBasicExamplePageState();
}

class _WBadgeBasicExamplePageState extends State<WBadgeBasicExamplePage> {
  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'WBadge',
      description:
          'Inline status / label pill. Caller supplies tone via className; no colors are baked in.',
      gradient: 'from-violet-500 to-purple-600',
      children: [
        ExampleSection(
          title: 'Status Tones',
          description:
              'Each badge carries bg-* and text-* with dark: pairs for full dark-mode support.',
          child: WDiv(
            className: 'flex flex-row flex-wrap gap-3',
            children: [
              WBadge(
                'Active',
                className:
                    'bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-100',
              ),
              WBadge(
                'Pending',
                className:
                    'bg-yellow-100 text-yellow-800 dark:bg-yellow-900 dark:text-yellow-100',
              ),
              WBadge(
                'Error',
                className:
                    'bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-100',
              ),
              WBadge(
                'Archived',
                className:
                    'bg-gray-100 text-gray-700 dark:bg-gray-800 dark:text-gray-300',
              ),
              WBadge(
                'New',
                className:
                    'bg-blue-100 text-blue-800 dark:bg-blue-900 dark:text-blue-100',
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Inline with Content',
          description:
              'WBadge sits naturally inline beside text or other widgets.',
          child: WDiv(
            className: 'flex flex-col gap-4',
            children: [
              WDiv(
                className: 'flex flex-row items-center gap-2',
                children: [
                  WText(
                    'Invoice #1042',
                    className:
                        'text-base font-medium text-gray-900 dark:text-white',
                  ),
                  WBadge(
                    'Paid',
                    className:
                        'bg-green-100 text-green-700 dark:bg-green-900 dark:text-green-200',
                  ),
                ],
              ),
              WDiv(
                className: 'flex flex-row items-center gap-2',
                children: [
                  WText(
                    'Order #5588',
                    className:
                        'text-base font-medium text-gray-900 dark:text-white',
                  ),
                  WBadge(
                    'In Transit',
                    className:
                        'bg-blue-100 text-blue-700 dark:bg-blue-900 dark:text-blue-200',
                  ),
                ],
              ),
              WDiv(
                className: 'flex flex-row items-center gap-2',
                children: [
                  WText(
                    'Subscription',
                    className:
                        'text-base font-medium text-gray-900 dark:text-white',
                  ),
                  WBadge(
                    'Overdue',
                    className:
                        'bg-red-100 text-red-700 dark:bg-red-900 dark:text-red-200',
                  ),
                ],
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'No className (Unstyled)',
          description:
              'Without className the badge renders unstyled: transparent background, inherited text color.',
          child: WDiv(
            className: 'flex flex-row gap-3',
            children: [
              WBadge('Draft'),
              WBadge('Internal'),
            ],
          ),
        ),
      ],
    );
  }
}
