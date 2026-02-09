import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class WTextExamplePage extends StatelessWidget {
  const WTextExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className:
          'w-full h-full overflow-y-auto p-4 bg-gray-50 dark:bg-gray-900',
      scrollPrimary: true,
      child: WDiv(
        className: 'flex flex-col gap-6 max-w-4xl mx-auto pb-12',
        children: [
          _buildHeader(),
          _buildSection(
            title: 'Typography Scale',
            description: 'Responsive font sizes from text-xs to text-6xl',
            child: WDiv(
              className: 'flex flex-col gap-4',
              children: [
                _buildDemoRow(
                    'text-xs', 'The quick brown fox jumps over the lazy dog'),
                _buildDemoRow(
                    'text-sm', 'The quick brown fox jumps over the lazy dog'),
                _buildDemoRow(
                    'text-base', 'The quick brown fox jumps over the lazy dog'),
                _buildDemoRow(
                    'text-lg', 'The quick brown fox jumps over the lazy dog'),
                _buildDemoRow(
                    'text-xl', 'The quick brown fox jumps over the lazy dog'),
                _buildDemoRow(
                    'text-2xl', 'The quick brown fox jumps over the lazy dog'),
                _buildDemoRow('text-3xl', 'The quick brown fox'),
              ],
            ),
          ),
          _buildSection(
            title: 'Font Weights',
            description: 'Control font weight from thin (100) to black (900)',
            child: WDiv(
              className: 'flex flex-col gap-4',
              children: [
                _buildDemoRow(
                    'font-thin', 'The quick brown fox jumps over the lazy dog'),
                _buildDemoRow('font-light',
                    'The quick brown fox jumps over the lazy dog'),
                _buildDemoRow('font-normal',
                    'The quick brown fox jumps over the lazy dog'),
                _buildDemoRow('font-medium',
                    'The quick brown fox jumps over the lazy dog'),
                _buildDemoRow('font-semibold',
                    'The quick brown fox jumps over the lazy dog'),
                _buildDemoRow(
                    'font-bold', 'The quick brown fox jumps over the lazy dog'),
                _buildDemoRow('font-black',
                    'The quick brown fox jumps over the lazy dog'),
              ],
            ),
          ),
          _buildSection(
            title: 'Colors & Opacity',
            description: 'Apply theme colors and opacity modifiers',
            child: WDiv(
              className: 'grid grid-cols-1 md:grid-cols-2 gap-4',
              children: [
                WText('text-blue-500',
                    className: 'text-lg font-bold text-blue-500'),
                WText('text-purple-600',
                    className: 'text-lg font-bold text-purple-600'),
                WText('text-green-500/50',
                    className: 'text-lg font-bold text-green-500/50'),
                WText('text-red-500/25',
                    className: 'text-lg font-bold text-red-500/25'),
              ],
            ),
          ),
          _buildSection(
            title: 'Decorations',
            description: 'Visual styling for text content',
            child: WDiv(
              className: 'flex flex-col gap-4',
              children: [
                WText('Underlined text', className: 'underline text-lg'),
                WText('Line-through text',
                    className: 'line-through text-lg text-gray-500'),
                WText('No underline', className: 'no-underline text-lg'),
                WDiv(
                  className: 'flex gap-2 items-center',
                  children: [
                    WText('Decoration Style:', className: 'text-gray-500'),
                    WText('Wavy',
                        className:
                            'underline decoration-wavy decoration-red-500 text-lg'),
                    WText('Dotted',
                        className:
                            'underline decoration-dotted decoration-blue-500 text-lg'),
                  ],
                ),
              ],
            ),
          ),
          _buildSection(
            title: 'Spacing & Line Height',
            description:
                'Control tracking (letter spacing) and leading (line height)',
            child: WDiv(
              className: 'flex flex-col gap-6',
              children: [
                WDiv(
                  className: 'space-y-2',
                  children: [
                    WText('Tracking (Letter Spacing)',
                        className: 'text-sm font-bold text-gray-500 uppercase'),
                    WText('tracking-tighter',
                        className:
                            'tracking-tighter text-lg bg-gray-100 dark:bg-gray-800 p-2 rounded'),
                    WText('tracking-widest',
                        className:
                            'tracking-widest text-lg bg-gray-100 dark:bg-gray-800 p-2 rounded'),
                  ],
                ),
                WDiv(
                  className: 'space-y-2',
                  children: [
                    WText('Leading (Line Height)',
                        className: 'text-sm font-bold text-gray-500 uppercase'),
                    WDiv(
                      className: 'grid grid-cols-1 md:grid-cols-2 gap-4',
                      children: [
                        WDiv(
                          className: 'p-3 bg-gray-100 dark:bg-gray-800 rounded',
                          children: [
                            WText('leading-none',
                                className: 'text-xs text-gray-500 mb-1'),
                            WText(
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                              className: 'leading-none text-sm',
                            ),
                          ],
                        ),
                        WDiv(
                          className: 'p-3 bg-gray-100 dark:bg-gray-800 rounded',
                          children: [
                            WText('leading-loose',
                                className: 'text-xs text-gray-500 mb-1'),
                            WText(
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                              className: 'leading-loose text-sm',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className:
          'bg-gradient-to-r from-blue-600 to-indigo-600 rounded-xl p-8 shadow-lg',
      children: [
        WText(
          'WText',
          className: 'text-3xl font-bold text-white mb-2',
        ),
        WText(
          'Utility-first typography component that translates class strings into optimized Flutter text widgets.',
          className: 'text-blue-100 text-lg max-w-2xl leading-relaxed',
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
      className:
          'flex flex-col p-6 bg-white dark:bg-gray-800 rounded-xl shadow-sm border border-gray-100 dark:border-gray-700',
      children: [
        WText(title,
            className: 'text-xl font-bold text-gray-900 dark:text-white mb-1'),
        WText(description,
            className: 'text-sm text-gray-500 dark:text-gray-400 mb-6'),
        child,
      ],
    );
  }

  Widget _buildDemoRow(String className, String text) {
    return WDiv(
      className:
          'flex flex-col md:flex-row md:items-center gap-2 md:gap-4 border-b border-gray-100 dark:border-gray-700 last:border-0 pb-3 last:pb-0',
      children: [
        WText(className,
            className:
                'text-xs font-mono text-purple-600 dark:text-purple-400 w-32 shrink-0'),
        WText(text, className: '$className text-gray-900 dark:text-gray-100'),
      ],
    );
  }
}
