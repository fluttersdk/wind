import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Responsive Display Example
/// Demonstrates how to show/hide elements at different breakpoints
class ResponsiveDisplayExamplePage extends StatelessWidget {
  const ResponsiveDisplayExamplePage({super.key});

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
              bg-gradient-to-r from-teal-500 to-emerald-500
            ''',
            children: [
              WText(
                'Responsive Display',
                className: 'text-lg font-bold text-white',
              ),
              WText(
                'Show/hide elements at different breakpoints',
                className: 'text-sm text-teal-100',
              ),
            ],
          ),

          // Mobile Only
          _buildSection(
            title: 'md:hidden',
            description: 'Visible on mobile only (hidden on md+)',
            children: [
              WDiv(
                className: 'md:hidden p-4 bg-red-500 rounded-lg',
                child: WText(
                  '📱 Mobile Only - Hidden on md+',
                  className: 'text-white font-medium',
                ),
              ),
              WDiv(
                className:
                    'hidden md:block p-3 bg-gray-200 dark:bg-slate-700 rounded-lg',
                child: WText(
                  '(Resize to mobile to see red box)',
                  className: 'text-sm text-gray-500 dark:text-gray-400',
                ),
              ),
            ],
          ),

          // Desktop Only
          _buildSection(
            title: 'hidden md:block',
            description: 'Hidden on mobile, visible on md+',
            children: [
              WDiv(
                className: 'hidden md:block p-4 bg-green-500 rounded-lg',
                child: WText(
                  '🖥️ Desktop Only - Visible on md+',
                  className: 'text-white font-medium',
                ),
              ),
              WDiv(
                className:
                    'md:hidden p-3 bg-gray-200 dark:bg-slate-700 rounded-lg',
                child: WText(
                  '(Resize to md+ to see green box)',
                  className: 'text-sm text-gray-500 dark:text-gray-400',
                ),
              ),
            ],
          ),

          // Tablet Only
          _buildSection(
            title: 'hidden md:block lg:hidden',
            description: 'Visible only on tablet (md to lg)',
            children: [
              WDiv(
                className:
                    'hidden md:block lg:hidden p-4 bg-blue-500 rounded-lg',
                child: WText(
                  '📱 Tablet Only - md to lg',
                  className: 'text-white font-medium',
                ),
              ),
              WDiv(
                className:
                    'md:hidden p-3 bg-gray-200 dark:bg-slate-700 rounded-lg',
                child: WText(
                  '(Visible only between md and lg)',
                  className: 'text-sm text-gray-500 dark:text-gray-400',
                ),
              ),
              WDiv(
                className:
                    'hidden lg:block p-3 bg-gray-200 dark:bg-slate-700 rounded-lg',
                child: WText(
                  '(Resize to tablet size to see blue box)',
                  className: 'text-sm text-gray-500 dark:text-gray-400',
                ),
              ),
            ],
          ),

          // Large Only
          _buildSection(
            title: 'hidden lg:block',
            description: 'Hidden until lg breakpoint',
            children: [
              WDiv(
                className: 'hidden lg:block p-4 bg-purple-500 rounded-lg',
                child: WText(
                  '🖥️ Large Desktop - Visible on lg+',
                  className: 'text-white font-medium',
                ),
              ),
              WDiv(
                className:
                    'lg:hidden p-3 bg-gray-200 dark:bg-slate-700 rounded-lg',
                child: WText(
                  '(Resize to lg+ to see purple box)',
                  className: 'text-sm text-gray-500 dark:text-gray-400',
                ),
              ),
            ],
          ),

          // Combined Example
          _buildSection(
            title: 'Combined Patterns',
            description: 'Different content for each breakpoint',
            children: [
              WDiv(
                className: 'flex flex-col gap-2',
                children: [
                  // Mobile
                  WDiv(
                    className: 'md:hidden p-4 bg-orange-500 rounded-lg',
                    child: WText(
                      '📱 Mobile View',
                      className: 'text-white font-medium',
                    ),
                  ),
                  // Tablet
                  WDiv(
                    className:
                        'hidden md:block lg:hidden p-4 bg-cyan-500 rounded-lg',
                    child: WText(
                      '📲 Tablet View',
                      className: 'text-white font-medium',
                    ),
                  ),
                  // Desktop
                  WDiv(
                    className: 'hidden lg:block p-4 bg-pink-500 rounded-lg',
                    child: WText(
                      '🖥️ Desktop View',
                      className: 'text-white font-medium',
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Reference Table
          WDiv(
            className: 'p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
            children: [
              WText(
                'Breakpoints Reference',
                className: 'font-semibold text-gray-800 dark:text-white mb-2',
              ),
              WDiv(
                className: 'flex flex-col gap-1',
                children: [
                  _buildRefRow('sm:', '≥640px'),
                  _buildRefRow('md:', '≥768px'),
                  _buildRefRow('lg:', '≥1024px'),
                  _buildRefRow('xl:', '≥1280px'),
                  _buildRefRow('2xl:', '≥1536px'),
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

  Widget _buildRefRow(String prefix, String value) {
    return WDiv(
      className: 'flex gap-4',
      children: [
        WText(
          prefix,
          className:
              'font-mono text-sm text-indigo-600 dark:text-indigo-400 w-10',
        ),
        WText(value, className: 'text-sm text-gray-600 dark:text-gray-300'),
      ],
    );
  }
}
