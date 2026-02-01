import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Font Weight Example
/// Demonstrates font weight utilities: font-thin through font-black
class FontWeightExamplePage extends StatelessWidget {
  const FontWeightExamplePage({super.key});

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
              bg-gradient-to-r from-emerald-500 to-teal-500
            ''',
            children: [
              WText('Font Weight', className: 'text-lg font-bold text-white'),
              WText(
                'Control font weight with font-{weight}',
                className: 'text-sm text-emerald-100',
              ),
            ],
          ),

          // Weight Examples
          _buildSection(
            title: 'Weight Scale',
            description: 'From font-thin (100) to font-black (900)',
            children: [
              WDiv(
                className:
                    'flex flex-col gap-3 p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
                children: [
                  _buildWeightRow('font-thin', '100'),
                  _buildWeightRow('font-extralight', '200'),
                  _buildWeightRow('font-light', '300'),
                  _buildWeightRow('font-normal', '400'),
                  _buildWeightRow('font-medium', '500'),
                  _buildWeightRow('font-semibold', '600'),
                  _buildWeightRow('font-bold', '700'),
                  _buildWeightRow('font-extrabold', '800'),
                  _buildWeightRow('font-black', '900'),
                ],
              ),
            ],
          ),

          // Arbitrary Values
          _buildSection(
            title: 'Arbitrary Values',
            description: 'Custom weights with bracket notation',
            children: [
              WDiv(
                className:
                    'flex flex-col gap-2 p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
                children: [
                  WText(
                    'font-[700]',
                    className:
                        'font-[700] text-lg text-gray-800 dark:text-white',
                  ),
                  WText(
                    'font-[550]',
                    className:
                        'font-[550] text-lg text-gray-800 dark:text-white',
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
                  _buildRefRow('font-thin', '100'),
                  _buildRefRow('font-light', '300'),
                  _buildRefRow('font-normal', '400'),
                  _buildRefRow('font-medium', '500'),
                  _buildRefRow('font-semibold', '600'),
                  _buildRefRow('font-bold', '700'),
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

  Widget _buildWeightRow(String className, String weight) {
    return WDiv(
      className: 'flex items-center gap-4',
      children: [
        WText(
          className,
          className:
              'font-mono text-xs text-indigo-600 dark:text-indigo-400 w-32',
        ),
        WText(
          'The quick brown fox',
          className: '$className text-lg text-gray-800 dark:text-white',
        ),
      ],
    );
  }

  Widget _buildRefRow(String className, String weight) {
    return WDiv(
      className: 'flex gap-4',
      children: [
        WText(
          className,
          className:
              'font-mono text-sm text-indigo-600 dark:text-indigo-400 w-32',
        ),
        WText(weight, className: 'text-sm text-gray-600 dark:text-gray-300'),
      ],
    );
  }
}
