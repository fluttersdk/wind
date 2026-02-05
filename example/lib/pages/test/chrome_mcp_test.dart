import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Chrome MCP Test Page
/// Used for testing Wind UI components via Chrome MCP browser automation
class ChromeMcpTestPage extends StatelessWidget {
  const ChromeMcpTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return WDiv(
      className: 'w-full h-full overflow-y-auto p-6',
      child: WDiv(
        className: 'flex flex-col gap-6 max-w-4xl',
        children: [
          // Header
          WDiv(
            className:
                'p-4 rounded-xl bg-gradient-to-r from-green-500 to-teal-500',
            children: [
              WText(
                'Chrome MCP Test Page [v1.0.1]',
                className: 'text-xl font-bold text-white',
              ),
              WText(
                'Testing Wind UI components via browser automation',
                className: 'text-sm text-green-100',
              ),
              WDiv(className: 'h-2'),
              WDiv(
                className: 'px-3 py-1 rounded-full bg-white/20 inline-block',
                child: WText(
                  'Viewport: ${width.toInt()}px',
                  className: 'text-sm font-mono text-white',
                ),
              ),
            ],
          ),

          // Test: Flex Layout
          _buildTestSection(
            title: 'Flex Layout Test',
            description: 'Testing flex-row and gap utilities',
            child: WDiv(
              className: 'flex flex-row gap-4',
              children: [
                _buildColorBox('bg-red-500', '1'),
                _buildColorBox('bg-orange-500', '2'),
                _buildColorBox('bg-yellow-500', '3'),
              ],
            ),
          ),

          // Test: Overflow Hidden
          _buildTestSection(
            title: 'Overflow Hidden Test',
            description: 'Testing overflow-hidden with rounded corners',
            child: WDiv(
              className: 'rounded-xl overflow-hidden',
              children: [
                WDiv(
                  className: 'bg-blue-500 p-4',
                  child: WText('Header', className: 'text-white font-bold'),
                ),
                WDiv(
                  className: 'bg-blue-100 dark:bg-blue-900 p-4',
                  child: WText(
                    'Content area with overflow-hidden parent',
                    className: 'text-blue-800 dark:text-blue-200',
                  ),
                ),
              ],
            ),
          ),

          // Test: Grid Layout
          _buildTestSection(
            title: 'Grid Layout Test',
            description: 'Testing grid with responsive columns',
            child: WDiv(
              className: 'grid grid-cols-2 md:grid-cols-4 gap-3',
              children: List.generate(8, (i) {
                final colors = [
                  'bg-purple-500',
                  'bg-pink-500',
                  'bg-indigo-500',
                  'bg-cyan-500',
                  'bg-emerald-500',
                  'bg-amber-500',
                  'bg-rose-500',
                  'bg-violet-500',
                ];
                return _buildColorBox(colors[i], '${i + 1}');
              }),
            ),
          ),

          // Test: Typography
          _buildTestSection(
            title: 'Typography Test',
            description: 'Testing text sizes and weights',
            child: WDiv(
              className: 'flex flex-col gap-2',
              children: [
                WText('text-xs',
                    className: 'text-xs text-gray-700 dark:text-gray-300'),
                WText('text-sm',
                    className: 'text-sm text-gray-700 dark:text-gray-300'),
                WText('text-base',
                    className: 'text-base text-gray-700 dark:text-gray-300'),
                WText('text-lg font-semibold',
                    className:
                        'text-lg font-semibold text-gray-700 dark:text-gray-300'),
                WText('text-xl font-bold',
                    className:
                        'text-xl font-bold text-gray-700 dark:text-gray-300'),
                WText('text-2xl font-extrabold',
                    className:
                        'text-2xl font-extrabold text-gray-700 dark:text-gray-300'),
              ],
            ),
          ),

          // Test: Buttons
          _buildTestSection(
            title: 'Button Test',
            description: 'Testing WButton with hover states',
            child: WDiv(
              className: 'flex flex-wrap gap-3',
              children: [
                WButton(
                  onTap: () {},
                  child: WDiv(
                    className:
                        'px-4 py-2 rounded-lg bg-blue-500 hover:bg-blue-600 transition-colors',
                    child:
                        WText('Primary', className: 'text-white font-medium'),
                  ),
                ),
                WButton(
                  onTap: () {},
                  child: WDiv(
                    className:
                        'px-4 py-2 rounded-lg bg-gray-200 dark:bg-gray-700 hover:bg-gray-300 dark:hover:bg-gray-600 transition-colors',
                    child: WText('Secondary',
                        className: 'text-gray-800 dark:text-white font-medium'),
                  ),
                ),
                WButton(
                  onTap: () {},
                  child: WDiv(
                    className:
                        'px-4 py-2 rounded-lg bg-red-500 hover:bg-red-600 transition-colors',
                    child: WText('Danger', className: 'text-white font-medium'),
                  ),
                ),
              ],
            ),
          ),

          // Console log test
          WDiv(
            className: 'p-4 rounded-xl bg-slate-800',
            children: [
              WText('Console Test',
                  className: 'text-sm font-bold text-gray-300 mb-2'),
              WText(
                'Check browser console - a test message should appear.',
                className: 'text-sm text-gray-400',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTestSection({
    required String title,
    required String description,
    required Widget child,
  }) {
    return WDiv(
      className: 'p-4 rounded-xl bg-white dark:bg-slate-800 shadow-sm',
      children: [
        WText(title, className: 'font-bold text-gray-800 dark:text-white'),
        WText(description,
            className: 'text-sm text-gray-500 dark:text-gray-400 mb-3'),
        child,
      ],
    );
  }

  Widget _buildColorBox(String bgColor, String label) {
    return WDiv(
      className:
          '$bgColor w-12 h-12 rounded-lg flex items-center justify-center',
      child: WText(label, className: 'text-white font-bold'),
    );
  }
}
