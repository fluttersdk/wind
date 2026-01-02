import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Basic WPopover example showing simple dropdown menu.
class PopoverBasicExamplePage extends StatelessWidget {
  const PopoverBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'p-6 bg-gray-100 min-h-screen',
      children: [
        const WText(
          'Basic Popover',
          className: 'font-bold text-lg text-gray-800 mb-4',
        ),

        // Basic popover with simple menu
        WPopover(
          alignment: PopoverAlignment.bottomLeft,
          className: '''
            w-48 bg-white dark:bg-gray-800
            border border-gray-200 dark:border-gray-700
            rounded-lg shadow-xl py-1
          ''',
          triggerBuilder: (context, isOpen, isHovering) => WDiv(
            className:
                '''
              px-4 py-2 bg-blue-500 rounded-lg
              ${isHovering ? 'bg-blue-600' : ''}
            ''',
            child: WDiv(
              className: 'flex items-center gap-2',
              children: [
                const WText('Open Menu', className: 'text-white font-medium'),
                Icon(
                  isOpen ? Icons.expand_less : Icons.expand_more,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ),
          ),
          contentBuilder: (context, close) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _MenuItem(
                icon: Icons.person,
                label: 'Profile',
                onTap: () {
                  close();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile tapped')),
                  );
                },
              ),
              _MenuItem(
                icon: Icons.settings,
                label: 'Settings',
                onTap: () {
                  close();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Settings tapped')),
                  );
                },
              ),
              const Divider(height: 1),
              _MenuItem(
                icon: Icons.logout,
                label: 'Sign Out',
                color: Colors.red,
                onTap: () {
                  close();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sign out tapped')),
                  );
                },
              ),
            ],
          ),
        ),

        const WDiv(className: 'h-8'),

        const WText(
          'Popover with Custom Styling',
          className: 'font-bold text-lg text-gray-800 mb-4',
        ),

        // Styled popover
        WPopover(
          alignment: PopoverAlignment.bottomLeft,
          className: '''
            w-64 bg-gradient-to-br from-purple-500 to-indigo-600
            rounded-xl shadow-2xl p-4
          ''',
          triggerBuilder: (context, isOpen, isHovering) => WDiv(
            className:
                '''
              px-4 py-2 border-2 border-purple-500 rounded-lg
              ${isHovering ? 'bg-purple-50' : 'bg-white'}
            ''',
            child: WDiv(
              className: 'flex items-center gap-2',
              children: [
                const Icon(Icons.palette, color: Colors.purple),
                const WText('Styled Popover', className: 'text-purple-700'),
              ],
            ),
          ),
          contentBuilder: (context, close) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const WText(
                'Custom Design',
                className: 'text-white font-bold text-lg',
              ),
              const WDiv(className: 'h-2'),
              const WText(
                'Use className to create beautiful popover designs with gradients, shadows, and more.',
                className: 'text-purple-100 text-sm',
              ),
              const WDiv(className: 'h-4'),
              GestureDetector(
                onTap: close,
                child: WDiv(
                  className: 'px-4 py-2 bg-white rounded-lg',
                  child: const WText(
                    'Got it!',
                    className: 'text-purple-600 font-medium text-center',
                  ),
                ),
              ),
            ],
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
  final Color? color;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Icon(icon, size: 20, color: color ?? Colors.grey.shade700),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  color: color ?? Colors.grey.shade800,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
