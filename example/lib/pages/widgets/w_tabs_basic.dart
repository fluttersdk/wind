import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class WTabsBasicExamplePage extends StatefulWidget {
  const WTabsBasicExamplePage({super.key});

  @override
  State<WTabsBasicExamplePage> createState() => _WTabsBasicExamplePageState();
}

class _WTabsBasicExamplePageState extends State<WTabsBasicExamplePage> {
  int _overviewTab = 0;
  int _pillTab = 0;

  static const List<String> _overviewLabels = [
    'Overview',
    'Activity',
    'Settings'
  ];
  static const List<String> _pillLabels = [
    'All',
    'Open',
    'Resolved',
    'Archived'
  ];

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'WTabs',
      description:
          'Controlled tabs. selected: state prefix activates on the active tab.',
      gradient: 'from-rose-500 to-pink-600',
      children: [
        ExampleSection(
          title: 'Underline Tabs',
          description:
              'The selected tab shows an underline border via selected:border-b-2.',
          child: WTabs(
            tabs: _overviewLabels,
            selectedIndex: _overviewTab,
            onChanged: (i) => setState(() => _overviewTab = i),
            listClassName: '''
              flex flex-row
              border-b border-gray-200 dark:border-gray-700
            ''',
            tabClassName: '''
              px-4 py-3 text-sm font-medium
              text-gray-500 dark:text-gray-400
              selected:text-rose-600 dark:selected:text-rose-400
              selected:border-b-2 selected:border-rose-600 dark:selected:border-rose-400
            ''',
            panelClassName: 'pt-4',
            panelBuilder: (index) => _buildOverviewPanel(index),
          ),
        ),
        ExampleSection(
          title: 'Pill Tabs',
          description:
              'Segmented control style using background and rounded tokens.',
          child: WTabs(
            tabs: _pillLabels,
            selectedIndex: _pillTab,
            onChanged: (i) => setState(() => _pillTab = i),
            listClassName: '''
              flex flex-row gap-1
              p-1 rounded-lg
              bg-gray-100 dark:bg-gray-800
            ''',
            tabClassName: '''
              px-3 py-1.5 rounded-md text-sm font-medium
              text-gray-600 dark:text-gray-400
              selected:bg-white dark:selected:bg-gray-700
              selected:text-gray-900 dark:selected:text-white
              selected:shadow-sm
            ''',
            panelClassName: 'pt-4',
            panelBuilder: (index) => _buildPillPanel(index),
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewPanel(int index) {
    const panels = [
      (
        'Project Overview',
        'The project is on track. 3 milestones completed, 2 remaining.'
      ),
      (
        'Recent Activity',
        'John Doe pushed 4 commits. Alice reviewed 2 pull requests.'
      ),
      (
        'Settings',
        'Notifications, permissions, and integrations are configured.'
      ),
    ];
    final (title, body) = panels[index];
    return WDiv(
      className: '''
        p-4 rounded-lg
        bg-white dark:bg-gray-800
        border border-gray-200 dark:border-gray-700
      ''',
      children: [
        WText(
          title,
          className: 'text-base font-semibold text-gray-900 dark:text-white',
        ),
        WText(
          body,
          className: 'text-sm text-gray-500 dark:text-gray-400',
        ),
      ],
    );
  }

  Widget _buildPillPanel(int index) {
    const panels = [
      ('48 issues total', 'Showing all open and closed issues.'),
      ('12 open', '5 are assigned to you.'),
      ('29 resolved', 'Resolved in the last 30 days.'),
      ('7 archived', 'Older than 90 days.'),
    ];
    final (title, body) = panels[index];
    return WDiv(
      className: '''
        p-4 rounded-lg
        bg-white dark:bg-gray-800
        border border-gray-200 dark:border-gray-700
      ''',
      children: [
        WText(
          title,
          className: 'text-base font-semibold text-gray-900 dark:text-white',
        ),
        WText(
          body,
          className: 'text-sm text-gray-500 dark:text-gray-400',
        ),
      ],
    );
  }
}
