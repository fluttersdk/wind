import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Shadow Example
/// Demonstrates shadow utilities: sizes, colors, opacity, arbitrary
class ShadowExamplePage extends StatelessWidget {
  const ShadowExamplePage({super.key});

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
              bg-gradient-to-r from-slate-600 to-slate-800
            ''',
            children: [
              WText('Shadow', className: 'text-lg font-bold text-white'),
              WText(
                'Control box shadow with shadow-{size}',
                className: 'text-sm text-slate-300',
              ),
            ],
          ),

          // Shadow Sizes
          _buildSection(
            title: 'Shadow Sizes',
            description: 'Preset shadow intensities from subtle to dramatic',
            children: [
              WDiv(
                className: 'flex gap-4 overflow-x-auto p-2',
                children: [
                  _buildShadowBox('shadow-sm', 'sm'),
                  _buildShadowBox('shadow', 'default'),
                  _buildShadowBox('shadow-md', 'md'),
                  _buildShadowBox('shadow-lg', 'lg'),
                  _buildShadowBox('shadow-xl', 'xl'),
                  _buildShadowBox('shadow-2xl', '2xl'),
                ],
              ),
            ],
          ),

          // Shadow None
          _buildSection(
            title: 'Remove Shadow',
            description: 'Use shadow-none to remove shadow',
            children: [
              WDiv(
                className: 'flex gap-4',
                children: [
                  _buildShadowBox('shadow-lg', 'With shadow'),
                  _buildShadowBox('shadow-none', 'shadow-none'),
                ],
              ),
            ],
          ),

          // Shadow Colors
          _buildSection(
            title: 'Shadow Colors',
            description: 'Colorize shadows with shadow-{color}-{shade}',
            children: [
              WDiv(
                className: 'flex gap-4 overflow-x-auto p-2',
                children: [
                  _buildColoredShadowBox(
                    'shadow-xl shadow-blue-500 dark:shadow-blue-400',
                    'Blue',
                  ),
                  _buildColoredShadowBox(
                    'shadow-xl shadow-red-500 dark:shadow-red-400',
                    'Red',
                  ),
                  _buildColoredShadowBox(
                    'shadow-xl shadow-green-500 dark:shadow-green-400',
                    'Green',
                  ),
                  _buildColoredShadowBox(
                    'shadow-xl shadow-purple-500 dark:shadow-purple-400',
                    'Purple',
                  ),
                ],
              ),
            ],
          ),

          // Arbitrary Colors
          _buildSection(
            title: 'Arbitrary Colors',
            description: 'Custom shadow colors with bracket notation',
            children: [
              WDiv(
                className: 'flex gap-4 overflow-x-auto p-2',
                children: [
                  _buildColoredShadowBox(
                    'shadow-xl shadow-[#1da1f2]',
                    '#1da1f2',
                  ),
                  _buildColoredShadowBox(
                    'shadow-xl shadow-[#FF5733]',
                    '#FF5733',
                  ),
                  _buildColoredShadowBox(
                    'shadow-xl shadow-[#6B5B95]',
                    '#6B5B95',
                  ),
                ],
              ),
            ],
          ),

          // Shadow Opacity
          _buildSection(
            title: 'Shadow Opacity',
            description: 'Control shadow color opacity with /modifier',
            children: [
              WDiv(
                className: 'flex gap-4 overflow-x-auto p-2',
                children: [
                  _buildColoredShadowBox('shadow-xl shadow-red-500', '100%'),
                  _buildColoredShadowBox('shadow-xl shadow-red-500/75', '75%'),
                  _buildColoredShadowBox('shadow-xl shadow-red-500/50', '50%'),
                  _buildColoredShadowBox('shadow-xl shadow-red-500/25', '25%'),
                ],
              ),
            ],
          ),

          // Quick Reference
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
                  _buildRefRow('shadow-sm', 'Subtle shadow'),
                  _buildRefRow('shadow', 'Default shadow'),
                  _buildRefRow('shadow-md', 'Medium shadow'),
                  _buildRefRow('shadow-lg', 'Large shadow'),
                  _buildRefRow('shadow-xl', 'Extra large shadow'),
                  _buildRefRow('shadow-2xl', 'Dramatic shadow'),
                  _buildRefRow('shadow-none', 'Remove shadow'),
                  _buildRefRow('shadow-{color}-{shade}', 'Colored shadow'),
                  _buildRefRow('shadow-[#hex]', 'Arbitrary color'),
                  _buildRefRow('shadow-{color}/opacity', 'With opacity'),
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

  Widget _buildShadowBox(String shadowClass, String label) {
    return WDiv(
      className:
          '$shadowClass w-24 h-24 bg-white dark:bg-slate-700 rounded-lg flex items-center justify-center',
      child: WText(
        label,
        className: 'text-xs font-mono text-gray-600 dark:text-gray-300',
      ),
    );
  }

  Widget _buildColoredShadowBox(String shadowClass, String label) {
    return WDiv(
      className:
          '$shadowClass w-24 h-24 bg-white dark:bg-slate-700 rounded-lg flex items-center justify-center',
      child: WText(
        label,
        className: 'text-xs font-mono text-gray-600 dark:text-gray-300',
      ),
    );
  }

  Widget _buildRefRow(String className, String description) {
    return WDiv(
      className: 'flex gap-4',
      children: [
        WText(
          className,
          className:
              'font-mono text-sm text-indigo-600 dark:text-indigo-400 w-48',
        ),
        WText(
          description,
          className: 'text-sm text-gray-600 dark:text-gray-300',
        ),
      ],
    );
  }
}
