import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Explicit Animation Example Page - demonstrates animate-* classes.
class AnimationBasicExamplePage extends StatelessWidget {
  const AnimationBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'w-full h-full overflow-y-auto p-4',
      child: WDiv(
        className: 'flex flex-col gap-6',
        children: [
          // Header
          WDiv(
            className: '''
              w-full p-4 rounded-xl
              bg-gradient-to-r from-purple-500 to-pink-500
            ''',
            children: const [
              WText('Animation', className: 'text-lg font-bold text-white'),
              WText(
                'Explicit animation utilities',
                className: 'text-sm text-purple-100',
              ),
            ],
          ),

          // Spin animation
          _buildSection(
            title: 'animate-spin',
            description: 'Continuous rotation for loading spinners',
            children: [
              WDiv(
                className: 'flex gap-6 items-center overflow-x-auto',
                children: const [
                  WIcon(
                    Icons.refresh,
                    className: 'text-blue-500 text-3xl animate-spin',
                  ),
                  WDiv(className: 'w-8 h-8 bg-purple-500 rounded animate-spin'),
                  WIcon(
                    Icons.settings,
                    className: 'text-gray-600 text-3xl animate-spin',
                  ),
                ],
              ),
            ],
          ),

          // Pulse animation
          _buildSection(
            title: 'animate-pulse',
            description: 'Opacity pulse for skeleton loaders',
            children: [
              WDiv(
                className: 'flex gap-4 items-start overflow-x-auto',
                children: [
                  const WDiv(
                    className:
                        'w-12 h-12 bg-gray-300 rounded-full animate-pulse',
                  ),
                  WDiv(
                    className: 'flex flex-col gap-2',
                    children: const [
                      WDiv(
                        className: 'h-3 w-32 bg-gray-300 rounded animate-pulse',
                      ),
                      WDiv(
                        className: 'h-3 w-24 bg-gray-300 rounded animate-pulse',
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          // Bounce animation
          _buildSection(
            title: 'animate-bounce',
            description: 'Vertical bounce for scroll indicators',
            children: [
              WDiv(
                className: 'flex gap-6 items-end h-12 overflow-x-auto',
                children: const [
                  WIcon(
                    Icons.arrow_downward,
                    className: 'text-blue-500 text-2xl animate-bounce',
                  ),
                  WIcon(
                    Icons.keyboard_arrow_down,
                    className: 'text-green-500 text-3xl animate-bounce',
                  ),
                  WDiv(className: 'w-5 h-5 bg-red-500 rounded animate-bounce'),
                ],
              ),
            ],
          ),

          // Ping animation
          _buildSection(
            title: 'animate-ping',
            description: 'Scale and fade out for notifications',
            children: [
              WDiv(
                className: 'flex gap-8 items-center overflow-x-auto',
                children: [
                  _NotificationBadge(
                    icon: Icons.notifications,
                    badgeColor: 'bg-red-500',
                  ),
                  _NotificationBadge(
                    icon: Icons.mail,
                    badgeColor: 'bg-blue-500',
                  ),
                  const WDiv(
                    className: 'w-4 h-4 bg-green-500 rounded-full animate-ping',
                  ),
                ],
              ),
            ],
          ),

          // Quick Reference
          WDiv(
            className: 'p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
            children: [
              const WText(
                'Quick Reference',
                className: 'font-semibold text-gray-800 dark:text-white mb-2',
              ),
              WDiv(
                className: 'flex flex-col gap-1',
                children: const [
                  WText(
                    'animate-spin | animate-pulse | animate-bounce | animate-ping',
                    className:
                        'text-xs font-mono text-gray-600 dark:text-gray-400',
                  ),
                  WText(
                    'animate-none (to remove)',
                    className:
                        'text-xs font-mono text-gray-600 dark:text-gray-400',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String description,
    required List<Widget> children,
  }) {
    return WDiv(
      className: 'flex flex-col gap-2',
      children: [
        WText(
          title,
          className: 'font-semibold text-gray-800 dark:text-white font-mono',
        ),
        WText(
          description,
          className: 'text-sm text-gray-500 dark:text-gray-400',
        ),
        ...children,
      ],
    );
  }
}

class _NotificationBadge extends StatelessWidget {
  final IconData icon;
  final String badgeColor;

  const _NotificationBadge({required this.icon, required this.badgeColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: Stack(
        children: [
          Positioned.fill(
            child: Center(child: Icon(icon, size: 28, color: Colors.grey)),
          ),
          Positioned(
            right: 2,
            top: 2,
            child: WDiv(
              className: 'w-3 h-3 $badgeColor rounded-full animate-ping',
            ),
          ),
        ],
      ),
    );
  }
}
