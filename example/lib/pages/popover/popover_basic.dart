import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class PopoverBasicExamplePage extends StatelessWidget {
  const PopoverBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'WPopover',
      description:
          'Overlay widget for dropdowns, menus, tooltips. triggerBuilder anchors the popover; contentBuilder renders the floating panel.',
      gradient: 'from-purple-500 to-violet-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Trigger button + dropdown menu. Tapping a menu item calls close.',
          child: WPopover(
            alignment: PopoverAlignment.bottomLeft,
            className: '''
              w-56 rounded-lg p-2
              bg-white dark:bg-slate-800
              shadow-xl border border-slate-200 dark:border-slate-700
            ''',
            triggerBuilder: (context, isOpen, isHovering) => WButton(
              onTap: () {},
              className: '''
                bg-purple-600 hover:bg-purple-700
                text-white px-4 py-2 rounded-lg duration-200
              ''',
              child:
                  const WText('Open Menu', className: 'text-white font-medium'),
            ),
            contentBuilder: (context, close) => WDiv(
              className: 'flex flex-col',
              children: [
                _MenuItem(
                    icon: Icons.person_outline, label: 'Profile', onTap: close),
                _MenuItem(
                    icon: Icons.settings_outlined,
                    label: 'Settings',
                    onTap: close),
                _MenuItem(icon: Icons.logout, label: 'Sign out', onTap: close),
              ],
            ),
          ),
        ),
        ExampleSection(
          title: 'Bounded Width (maxWidth)',
          description:
              'maxWidth caps the overlay so a long-content menu cannot stretch '
              'across the viewport. Use width to pin a fixed width instead.',
          child: WPopover(
            maxWidth: 220,
            className: '''
              rounded-lg p-2
              bg-white dark:bg-slate-800
              shadow-xl border border-slate-200 dark:border-slate-700
            ''',
            triggerBuilder: (context, isOpen, isHovering) => WButton(
              onTap: () {},
              className: '''
                bg-violet-600 hover:bg-violet-700
                text-white px-4 py-2 rounded-lg duration-200
              ''',
              child: const WText(
                'Last 24 hours',
                className: 'text-white font-medium',
              ),
            ),
            contentBuilder: (context, close) => WDiv(
              className: 'flex flex-col',
              children: [
                _MenuItem(
                  icon: Icons.schedule_outlined,
                  label: 'Last 24 hours',
                  onTap: close,
                ),
                _MenuItem(
                  icon: Icons.calendar_today_outlined,
                  label: 'Last 7 days',
                  onTap: close,
                ),
                _MenuItem(
                  icon: Icons.date_range_outlined,
                  label: 'Last 30 days',
                  onTap: close,
                ),
              ],
            ),
          ),
        ),
        ExampleSection(
          title: 'Trigger State',
          description:
              'triggerBuilder receives isOpen + isHovering — style the trigger reactively.',
          child: WPopover(
            className: '''
              w-64 rounded-lg p-3
              bg-white dark:bg-slate-800
              shadow-xl border border-slate-200 dark:border-slate-700
            ''',
            triggerBuilder: (context, isOpen, isHovering) => WDiv(
              className: '''
                px-4 py-2 rounded-lg duration-200 cursor-pointer
                ${isOpen ? "bg-purple-600 text-white" : "bg-slate-100 dark:bg-slate-700 text-slate-700 dark:text-slate-200"}
              ''',
              child: WText(
                isOpen ? 'Open' : 'Idle',
                className: 'font-medium',
              ),
            ),
            contentBuilder: (context, close) => const WText(
              'Trigger background changes based on isOpen.',
              className: 'text-sm text-slate-600 dark:text-slate-300',
            ),
          ),
        ),
        ExampleSection(
          title: 'Notification Panel',
          description:
              'Bigger contentBuilder with a list of dismissible items.',
          child: WPopover(
            className: '''
              w-80 rounded-xl p-3
              bg-white dark:bg-slate-800
              shadow-2xl border border-slate-200 dark:border-slate-700
            ''',
            triggerBuilder: (context, isOpen, isHovering) => WButton(
              onTap: () {},
              className: '''
                p-2 rounded-full duration-200
                bg-slate-100 hover:bg-slate-200
                dark:bg-slate-700 dark:hover:bg-slate-600
              ''',
              child: WIcon(Icons.notifications_outlined,
                  className: 'text-slate-700 dark:text-slate-200 w-5 h-5'),
            ),
            contentBuilder: (context, close) => WDiv(
              className: 'flex flex-col gap-2',
              children: [
                WText('Notifications',
                    className: 'font-bold text-slate-900 dark:text-white'),
                _NotifRow(label: 'New comment on your post'),
                _NotifRow(label: 'Build #423 passed'),
                _NotifRow(label: 'New follower: @jane'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return WAnchor(
      onTap: onTap,
      child: WDiv(
        className: '''
          w-full flex items-center gap-3 px-3 py-2 rounded
          hover:bg-slate-100 dark:hover:bg-slate-700
          duration-150
        ''',
        children: [
          WIcon(icon, className: 'text-slate-600 dark:text-slate-300 w-5 h-5'),
          WText(label,
              className: 'text-sm text-slate-900 dark:text-white font-medium'),
        ],
      ),
    );
  }
}

class _NotifRow extends StatelessWidget {
  final String label;

  const _NotifRow({required this.label});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: '''
        flex items-center gap-2 p-2 rounded
        bg-slate-50 dark:bg-slate-700/40
      ''',
      children: [
        WDiv(className: 'w-2 h-2 rounded-full bg-purple-500 shrink-0'),
        WText(label,
            className: 'text-sm text-slate-700 dark:text-slate-200 flex-1'),
      ],
    );
  }
}
