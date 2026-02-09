import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class DarkModeBasicExamplePage extends StatelessWidget {
  const DarkModeBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className:
          'w-full h-full overflow-y-auto p-4 bg-gray-50 dark:bg-gray-900 transition-colors duration-300',
      scrollPrimary: true,
      children: [
        _buildHeader(),

        // Main Content
        WDiv(
          className: 'flex flex-col gap-8 max-w-4xl mx-auto pb-12',
          children: [
            // Backgrounds
            _buildSection(
              title: 'Background Adaptation',
              description:
                  'Use dark:bg-{color} to define alternative backgrounds for dark mode.',
              child: WDiv(
                className: 'grid grid-cols-1 md:grid-cols-2 gap-4',
                children: [
                  _buildCard(
                    className: 'bg-white dark:bg-slate-800 shadow-sm',
                    label: 'Surface',
                    code: 'bg-white\ndark:bg-slate-800',
                  ),
                  _buildCard(
                    className: 'bg-blue-50 dark:bg-blue-900/30 shadow-sm',
                    label: 'Tinted',
                    code: 'bg-blue-50\ndark:bg-blue-900/30',
                  ),
                ],
              ),
            ),

            // Typography
            _buildSection(
              title: 'Typography Colors',
              description:
                  'Invert text contrast automatically with dark:text-{color}.',
              child: WDiv(
                className:
                    'p-6 rounded-xl border border-gray-200 dark:border-gray-700 bg-white dark:bg-slate-800',
                children: [
                  WText(
                    'Primary Heading',
                    className:
                        'text-2xl font-bold text-gray-900 dark:text-white mb-2',
                  ),
                  WText(
                    'Secondary text automatically softens in both modes to maintain readability hierarchies.',
                    className: 'text-gray-500 dark:text-gray-400 mb-4',
                  ),
                  WText(
                    'text-gray-900 dark:text-white',
                    className:
                        'text-xs font-mono text-blue-500 dark:text-blue-400 bg-blue-50 dark:bg-blue-900/20 p-2 rounded',
                  ),
                ],
              ),
            ),

            // Borders & Dividers
            _buildSection(
              title: 'Borders & Dividers',
              description:
                  'Subtle borders need adjustments to stay visible but not harsh.',
              child: WDiv(
                className: 'grid grid-cols-1 md:grid-cols-2 gap-4',
                children: [
                  WDiv(
                    className:
                        'h-24 rounded-lg border-2 border-dashed border-gray-300 dark:border-gray-600 flex items-center justify-center',
                    child: const WText('Dashed Border',
                        className:
                            'text-gray-500 dark:text-gray-400 font-medium'),
                  ),
                  WDiv(
                    className:
                        'h-24 rounded-lg border border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-800 flex items-center justify-center',
                    child: const WText('Subtle Border',
                        className:
                            'text-gray-500 dark:text-gray-400 font-medium'),
                  ),
                ],
              ),
            ),

            // Interactive States
            _buildSection(
              title: 'Interactive States',
              description:
                  'Combine hover and focus states with dark mode for rich interactivity.',
              child: WDiv(
                className: 'wrap gap-4',
                children: [
                  WButton(
                    onTap: () {},
                    className:
                        'px-6 py-2.5 rounded-lg bg-blue-600 hover:bg-blue-700 dark:bg-blue-500 dark:hover:bg-blue-400 transition-colors',
                    child: const WText('Primary Button',
                        className: 'text-white font-medium'),
                  ),
                  WButton(
                    onTap: () {},
                    className:
                        'px-6 py-2.5 rounded-lg border border-gray-300 dark:border-gray-600 hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors',
                    child: const WText('Secondary Button',
                        className:
                            'text-gray-700 dark:text-gray-200 font-medium'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className: 'mb-8 mt-2',
      children: [
        const WText(
          'Dark Mode',
          className: 'text-3xl font-bold text-gray-900 dark:text-white mb-2',
        ),
        const WText(
          'The dark: prefix lets you style your site differently when dark mode is enabled.',
          className: 'text-lg text-gray-600 dark:text-gray-300 max-w-2xl',
        ),
        WDiv(
          className:
              'mt-4 inline-flex items-center gap-2 px-3 py-1.5 rounded-md bg-yellow-100 dark:bg-yellow-900/30 text-yellow-800 dark:text-yellow-200 border border-yellow-200 dark:border-yellow-700/50',
          children: const [
            WIcon(Icons.lightbulb_outline, className: 'text-sm'),
            WText(
                'Tip: Toggle the theme icon in the app bar to test these styles.',
                className: 'text-sm font-medium'),
          ],
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required String description,
    required Widget child,
  }) {
    return WDiv(
      className: 'flex flex-col gap-4',
      children: [
        WDiv(
          children: [
            WText(title,
                className:
                    'text-xl font-semibold text-gray-900 dark:text-white mb-1'),
            WText(description, className: 'text-gray-500 dark:text-gray-400'),
          ],
        ),
        child,
      ],
    );
  }

  Widget _buildCard({
    required String className,
    required String label,
    required String code,
  }) {
    return WDiv(
      className:
          'p-6 rounded-xl flex flex-col justify-between h-32 $className transition-colors duration-300',
      children: [
        WText(label, className: 'font-medium text-gray-900 dark:text-white'),
        WText(code,
            className:
                'font-mono text-xs text-gray-500 dark:text-gray-400 whitespace-pre'),
      ],
    );
  }
}
