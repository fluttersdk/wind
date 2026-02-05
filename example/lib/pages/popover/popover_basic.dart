import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Basic WPopover example showing dropdown menu.
class PopoverBasicExamplePage extends StatelessWidget {
  const PopoverBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'w-full h-full overflow-y-auto p-4',
      child: WDiv(
        className: 'flex flex-col gap-6',
        children: [
          // Header with gradient
          WDiv(
            className: '''
              w-full p-4 rounded-xl
              bg-gradient-to-r from-violet-500 to-purple-500
            ''',
            children: const [
              WText('WPopover', className: 'text-lg font-bold text-white'),
              WText(
                'Flexible popover for dropdowns and menus',
                className: 'text-sm text-violet-100',
              ),
            ],
          ),

          // Basic popover
          _buildSection(
            title: 'Basic Dropdown',
            description: 'Simple menu with actions',
            children: [
              WPopover(
                alignment: PopoverAlignment.bottomLeft,
                className: '''
                  w-48 py-1
                  bg-white dark:bg-slate-800
                  border border-gray-200 dark:border-gray-700
                  rounded-lg shadow-xl
                ''',
                triggerBuilder: (context, isOpen, isHovering) => WDiv(
                  className: '''
                    px-4 py-2 rounded-lg flex items-center gap-2
                    bg-blue-500 ${isHovering ? 'bg-blue-600' : ''}
                  ''',
                  children: [
                    const WText(
                      'Open Menu',
                      className: 'text-white font-medium',
                    ),
                    Icon(
                      isOpen ? Icons.expand_less : Icons.expand_more,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
                contentBuilder: (context, close) => WDiv(
                  className: 'flex flex-col',
                  children: [
                    _menuItem(context, Icons.person, 'Profile', close),
                    _menuItem(context, Icons.settings, 'Settings', close),
                    const Divider(height: 1),
                    _menuItem(
                      context,
                      Icons.logout,
                      'Sign Out',
                      close,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Styled popover
          _buildSection(
            title: 'Custom Styling',
            description: 'Gradient background with custom content',
            children: [
              WPopover(
                alignment: PopoverAlignment.bottomLeft,
                className: '''
                  w-64 p-4 rounded-xl shadow-2xl
                  bg-gradient-to-br from-purple-500 to-indigo-600
                ''',
                triggerBuilder: (context, isOpen, isHovering) => WDiv(
                  className: '''
                    px-4 py-2 rounded-lg flex items-center gap-2
                    border-2 border-purple-500
                    ${isHovering ? 'bg-purple-50 dark:bg-purple-900/20' : 'bg-white dark:bg-slate-800'}
                  ''',
                  children: const [
                    Icon(Icons.palette, color: Colors.purple),
                    WText(
                      'Styled Popover',
                      className: 'text-purple-700 dark:text-purple-300',
                    ),
                  ],
                ),
                contentBuilder: (context, close) => WDiv(
                  className: 'flex flex-col gap-2',
                  children: [
                    const WText(
                      'Custom Design',
                      className: 'text-white font-bold text-lg',
                    ),
                    const WText(
                      'Use className for gradients, shadows, and more.',
                      className: 'text-purple-100 text-sm',
                    ),
                    const WDiv(className: 'h-2'),
                    WButton(
                      onTap: close,
                      className: '''
                        px-4 py-2 rounded-lg
                        bg-white hover:bg-purple-50
                        duration-150
                      ''',
                      child: const WText(
                        'Got it!',
                        className: 'text-purple-600 font-medium text-center',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Quick Reference
          WDiv(
            className: 'p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
            children: [
              const WText(
                'Key Props',
                className: 'font-semibold text-gray-800 dark:text-white mb-2',
              ),
              WDiv(
                className: 'flex flex-col gap-1',
                children: [
                  _referenceRow('alignment:', 'Popover position'),
                  _referenceRow('className:', 'Popover styling'),
                  _referenceRow('closeOnContentTap:', 'Auto-close'),
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

  Widget _referenceRow(String className, String value) {
    return WDiv(
      className: 'flex justify-between',
      children: [
        WText(
          className,
          className: 'text-sm font-mono text-gray-600 dark:text-gray-300',
        ),
        WText(value, className: 'text-sm text-gray-500 dark:text-gray-400'),
      ],
    );
  }

  Widget _menuItem(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback close, {
    Color? color,
  }) {
    return WAnchor(
      onTap: () {
        close();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$label tapped')));
      },
      child: WDiv(
        className: '''
          w-full px-4 py-2 flex items-center gap-3
          hover:bg-gray-100 dark:hover:bg-slate-700
        ''',
        children: [
          Icon(icon, size: 20, color: color ?? Colors.grey.shade600),
          WText(
            label,
            className: color != null
                ? 'text-red-600'
                : 'text-gray-800 dark:text-gray-200',
          ),
        ],
      ),
    );
  }
}
