import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Text Alignment Example
/// Demonstrates text alignment utilities: text-left, text-center, text-right, text-justify
class TypographyAlignmentPage extends StatelessWidget {
  const TypographyAlignmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          WDiv(
            className: '''
              w-full p-4 rounded-xl
              bg-gradient-to-r from-violet-500 to-purple-500
            ''',
            children: [
              WText(
                'Text Alignment',
                className: 'text-lg font-bold text-white',
              ),
              WText(
                'Control text alignment with text-{align}',
                className: 'text-sm text-violet-100',
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Alignment Classes
          WText(
            'Alignment Classes',
            className: 'font-semibold text-gray-800 dark:text-white font-mono',
          ),
          const SizedBox(height: 4),
          WText(
            'Position text within its container',
            className: 'text-sm text-gray-500 dark:text-gray-400',
          ),
          const SizedBox(height: 16),

          // text-left
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                WText(
                  'text-left',
                  className: 'text-xs font-mono text-indigo-600 mb-2',
                ),
                WText(
                  'This text is aligned to the left.',
                  className: 'text-left text-gray-800',
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // text-center
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                WText(
                  'text-center',
                  className:
                      'text-xs font-mono text-indigo-600 mb-2 text-center',
                ),
                WText(
                  'This text is aligned to the center.',
                  className: 'text-center text-gray-800',
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // text-right
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                WText(
                  'text-right',
                  className:
                      'text-xs font-mono text-indigo-600 mb-2 text-right',
                ),
                WText(
                  'This text is aligned to the right.',
                  className: 'text-right text-gray-800',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Justify
          WText(
            'text-justify',
            className: 'font-semibold text-gray-800 dark:text-white font-mono',
          ),
          const SizedBox(height: 4),
          WText(
            'Justify text to fill the container width',
            className: 'text-sm text-gray-500',
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: WText(
              'Justified text spreads each line to fill the full container width, adding extra space between words so both the left and right edges stay flush. It works best for dense, multi-line paragraphs where a clean block shape matters more than even word spacing, such as printed articles or terms of service.',
              className: 'text-justify text-gray-800',
            ),
          ),
          const SizedBox(height: 24),

          // Reference Table
          WDiv(
            className: 'p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
            children: [
              WText(
                'Quick Reference',
                className: 'font-semibold text-gray-800 dark:text-white mb-2',
              ),
              _buildRefRow('text-left', 'Align left'),
              _buildRefRow('text-center', 'Align center'),
              _buildRefRow('text-right', 'Align right'),
              _buildRefRow('text-justify', 'Justify'),
              _buildRefRow('text-start', 'Start (RTL aware)'),
              _buildRefRow('text-end', 'End (RTL aware)'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRefRow(String className, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: WText(
              className,
              className: 'font-mono text-sm text-indigo-600',
            ),
          ),
          Expanded(
            child: WText(description, className: 'text-sm text-gray-600'),
          ),
        ],
      ),
    );
  }
}
