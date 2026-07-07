import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class WAnchorFlexExamplePage extends StatelessWidget {
  const WAnchorFlexExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'WAnchor Layouts',
      description:
          'WAnchor has no layout of its own. Wrap a styled WDiv to add hover/press state to any flex row, card, or button-like surface.',
      gradient: 'from-violet-500 to-purple-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'WAnchor + WDiv with flex layout. Icon + label both adopt hover state.',
          child: WAnchor(
            onTap: () {},
            child: WDiv(
              className: '''
                flex items-center gap-2 p-3 rounded duration-200
                bg-gray-50 dark:bg-slate-700/40
                hover:bg-gray-100 dark:hover:bg-slate-700
              ''',
              children: [
                WIcon(Icons.add, className: 'text-blue-500 dark:text-blue-400'),
                const WText('Add Item',
                    className: 'text-slate-900 dark:text-white font-medium'),
              ],
            ),
          ),
        ),
        ExampleSection(
          title: 'Navigation Link',
          description:
              'Compact horizontal pattern used in nav bars and side menus.',
          child: WDiv(
            className: 'flex flex-col',
            children: [
              _NavLink(icon: Icons.dashboard_outlined, label: 'Dashboard'),
              _NavLink(icon: Icons.folder_outlined, label: 'Projects'),
              _NavLink(icon: Icons.settings_outlined, label: 'Settings'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Card Lift Effect',
          description:
              'Hover raises shadow + tints background, works for entire interactive cards.',
          child: WAnchor(
            onTap: () {},
            child: WDiv(
              className: '''
                p-6 rounded-xl duration-300
                bg-white dark:bg-slate-800
                shadow-sm hover:shadow-2xl
                border border-slate-200 dark:border-slate-700
                hover:border-violet-500 dark:hover:border-violet-400
              ''',
              children: const [
                WText(
                  'Hover to lift',
                  className: '''
                    font-bold duration-200
                    text-slate-900 dark:text-white
                    hover:text-violet-600 dark:hover:text-violet-400
                  ''',
                ),
                WText(
                  'shadow-sm → hover:shadow-2xl + border tint',
                  className: 'text-sm text-slate-500 dark:text-slate-400 mt-1',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _NavLink extends StatelessWidget {
  final IconData icon;
  final String label;

  const _NavLink({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return WAnchor(
      onTap: () {},
      child: WDiv(
        className: '''
          flex items-center gap-3 px-4 py-2 rounded duration-150
          text-slate-600 dark:text-slate-400
          hover:bg-violet-50 dark:hover:bg-violet-900/20
          hover:text-violet-600 dark:hover:text-violet-300
        ''',
        children: [
          WIcon(icon, className: 'text-slate-500 dark:text-slate-400 w-5 h-5'),
          WText(label, className: 'font-medium'),
        ],
      ),
    );
  }
}
