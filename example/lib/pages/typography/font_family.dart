import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Font Family Example
/// Demonstrates font family utilities: font-sans, font-serif, font-mono
class FontFamilyExamplePage extends StatelessWidget {
  const FontFamilyExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WindTheme(
      data: WindThemeData(
        fontFamilies: {
          'sans': GoogleFonts.inter().fontFamily!,
          'serif': GoogleFonts.merriweather().fontFamily!,
          'mono': GoogleFonts.jetBrainsMono().fontFamily!,
          'display': GoogleFonts.poppins().fontFamily!,
        },
      ),
      child: WDiv(
        className: 'w-full h-full overflow-y-auto p-4',
        child: WDiv(
          className: 'flex flex-col gap-6',
          children: [
            // Header
            WDiv(
              className: '''
                w-full p-4 rounded-xl
                bg-gradient-to-r from-fuchsia-500 to-pink-500
              ''',
              children: [
                WText('Font Family', className: 'text-lg font-bold text-white'),
                WText(
                  'Control the font family of text elements',
                  className: 'text-sm text-fuchsia-100',
                ),
              ],
            ),

            // font-sans
            _buildSection(
              title: 'font-sans',
              description: 'System UI, sans-serif fonts (default)',
              children: [
                WDiv(
                  className: 'p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
                  child: WText(
                    'The quick brown fox jumps over the lazy dog.',
                    className:
                        'font-sans text-lg text-gray-800 dark:text-white',
                  ),
                ),
              ],
            ),

            // font-serif
            _buildSection(
              title: 'font-serif',
              description: 'Serif fonts for elegant typography',
              children: [
                WDiv(
                  className: 'p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
                  child: WText(
                    'The quick brown fox jumps over the lazy dog.',
                    className:
                        'font-serif text-lg text-gray-800 dark:text-white',
                  ),
                ),
              ],
            ),

            // font-mono
            _buildSection(
              title: 'font-mono',
              description: 'Monospace fonts for code',
              children: [
                WDiv(
                  className: 'p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
                  child: WText(
                    'const message = "Hello, World!";',
                    className:
                        'font-mono text-lg text-gray-800 dark:text-white',
                  ),
                ),
              ],
            ),

            // Custom: font-display
            _buildSection(
              title: 'font-display (Custom)',
              description: 'Custom font family defined in theme',
              children: [
                WDiv(
                  className: 'p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
                  child: WText(
                    'Beautiful Display Typography',
                    className:
                        'font-display text-xl font-semibold text-gray-800 dark:text-white',
                  ),
                ),
              ],
            ),

            // Arbitrary Values
            _buildSection(
              title: 'Arbitrary Values',
              description: 'Custom font family with bracket notation',
              children: [
                WDiv(
                  className: 'p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
                  child: WText(
                    'This uses font-[Roboto]',
                    className:
                        'font-[Roboto] text-lg text-gray-800 dark:text-white',
                  ),
                ),
              ],
            ),

            // Comparison
            _buildSection(
              title: 'Side by Side',
              description: 'Compare different font families',
              children: [
                WDiv(
                  className: 'flex flex-col gap-3',
                  children: [
                    _buildFontRow('font-sans', 'Sans Serif', 'font-sans'),
                    _buildFontRow('font-serif', 'Serif Style', 'font-serif'),
                    _buildFontRow('font-mono', 'Monospace', 'font-mono'),
                    _buildFontRow('font-display', 'Display', 'font-display'),
                  ],
                ),
              ],
            ),

            // Reference Table
            WDiv(
              className: 'p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
              children: [
                WText(
                  'Quick Reference',
                  className: 'font-semibold text-gray-800 dark:text-white mb-2',
                ),
                WDiv(
                  className: 'flex flex-col gap-1',
                  children: [
                    _buildRefRow('font-sans', 'System UI, sans-serif'),
                    _buildRefRow('font-serif', 'Georgia, serif'),
                    _buildRefRow('font-mono', 'Monospace'),
                    _buildRefRow('font-[Name]', 'Custom font family'),
                  ],
                ),
              ],
            ),
          ],
        ),
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

  Widget _buildFontRow(String className, String label, String fontClass) {
    return WDiv(
      className:
          'flex items-center gap-4 p-3 bg-white dark:bg-slate-700 rounded-lg',
      children: [
        WText(
          className,
          className:
              'font-mono text-sm text-indigo-600 dark:text-indigo-400 w-28',
        ),
        WText(
          label,
          className: '$fontClass text-lg text-gray-800 dark:text-white',
        ),
      ],
    );
  }

  Widget _buildRefRow(String className, String description) {
    return WDiv(
      className: 'flex gap-4',
      children: [
        WText(
          className,
          className:
              'font-mono text-sm text-indigo-600 dark:text-indigo-400 w-28',
        ),
        WText(
          description,
          className: 'text-sm text-gray-600 dark:text-gray-300',
        ),
      ],
    );
  }
}
