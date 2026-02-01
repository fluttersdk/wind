import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Letter Spacing Example
/// Demonstrates letter spacing utilities: tracking-tighter through tracking-widest
class LetterSpacingExamplePage extends StatelessWidget {
  const LetterSpacingExamplePage({super.key});

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
            children: [
              WText(
                'Letter Spacing',
                className: 'text-lg font-bold text-white',
              ),
              WText(
                'Control tracking with tracking-{value}',
                className: 'text-sm text-purple-100',
              ),
            ],
          ),

          // Tracking Examples
          _buildSection(
            title: 'Tracking Scale',
            description: 'From tight to wide letter spacing',
            children: [
              WDiv(
                className:
                    'flex flex-col gap-3 p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
                children: [
                  _buildTrackingRow('tracking-tighter', '-0.05em'),
                  _buildTrackingRow('tracking-tight', '-0.025em'),
                  _buildTrackingRow('tracking-normal', '0em'),
                  _buildTrackingRow('tracking-wide', '0.025em'),
                  _buildTrackingRow('tracking-wider', '0.05em'),
                  _buildTrackingRow('tracking-widest', '0.1em'),
                ],
              ),
            ],
          ),

          // Arbitrary Values
          _buildSection(
            title: 'Arbitrary Values',
            description: 'Custom spacing with bracket notation',
            children: [
              WDiv(
                className:
                    'flex flex-col gap-2 p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
                children: [
                  WText(
                    'tracking-[0.15em]',
                    className:
                        'tracking-[0.15em] text-lg text-gray-800 dark:text-white',
                  ),
                  WText(
                    'tracking-[2px]',
                    className:
                        'tracking-[2px] text-lg text-gray-800 dark:text-white',
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
                'Quick Reference',
                className: 'font-semibold text-gray-800 dark:text-white mb-2',
              ),
              WDiv(
                className: 'flex flex-col gap-1',
                children: [
                  _buildRefRow('tracking-tighter', '-0.05em'),
                  _buildRefRow('tracking-tight', '-0.025em'),
                  _buildRefRow('tracking-normal', '0em'),
                  _buildRefRow('tracking-wide', '0.025em'),
                  _buildRefRow('tracking-widest', '0.1em'),
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

  Widget _buildTrackingRow(String className, String value) {
    return WDiv(
      className: 'flex items-center gap-4 overflow-x-auto',
      children: [
        WText(
          className,
          className:
              'font-mono text-xs text-indigo-600 dark:text-indigo-400 w-36',
        ),
        WText(
          'The quick brown fox',
          className: '$className text-lg text-gray-800 dark:text-white',
        ),
      ],
    );
  }

  Widget _buildRefRow(String className, String value) {
    return WDiv(
      className: 'flex gap-4',
      children: [
        WText(
          className,
          className:
              'font-mono text-sm text-indigo-600 dark:text-indigo-400 w-36',
        ),
        WText(value, className: 'text-sm text-gray-600 dark:text-gray-300'),
      ],
    );
  }
}
