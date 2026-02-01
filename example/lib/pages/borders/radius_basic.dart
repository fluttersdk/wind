import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Border Radius Example Page - demonstrates rounded corner utilities.
class RadiusBasicPage extends StatelessWidget {
  const RadiusBasicPage({super.key});

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
            children: const [
              WText('Border Radius', className: 'text-lg font-bold text-white'),
              WText(
                'Rounded corner utilities',
                className: 'text-sm text-purple-100',
              ),
            ],
          ),

          // Basic radius
          _buildSection(
            title: 'rounded-{size}',
            description: 'Basic border radius utilities',
            children: [
              WDiv(
                className: 'flex gap-4 overflow-x-auto',
                children: const [
                  _RadiusBox(value: 'sm', label: '2px'),
                  _RadiusBox(value: '', label: '4px'),
                  _RadiusBox(value: 'md', label: '6px'),
                  _RadiusBox(value: 'lg', label: '8px'),
                  _RadiusBox(value: 'xl', label: '12px'),
                  _RadiusBox(value: '2xl', label: '16px'),
                ],
              ),
            ],
          ),

          // Special values
          _buildSection(
            title: 'Special Values',
            description: 'Full circle and no radius',
            children: [
              WDiv(
                className: 'flex gap-4 overflow-x-auto',
                children: const [
                  _RadiusBox(value: 'full', label: '9999px'),
                  _RadiusBox(value: 'none', label: '0px'),
                ],
              ),
            ],
          ),

          // Directional radius
          _buildSection(
            title: 'rounded-{dir}-{size}',
            description: 'Apply radius to specific corners',
            children: [
              WDiv(
                className: 'flex gap-4 overflow-x-auto',
                children: const [
                  _DirectionalRadiusBox(value: 't-lg', label: 'Top'),
                  _DirectionalRadiusBox(value: 'r-lg', label: 'Right'),
                  _DirectionalRadiusBox(value: 'b-lg', label: 'Bottom'),
                  _DirectionalRadiusBox(value: 'l-lg', label: 'Left'),
                ],
              ),
              const SizedBox(height: 8),
              WDiv(
                className: 'flex gap-4 overflow-x-auto',
                children: const [
                  _DirectionalRadiusBox(value: 'tl-xl', label: 'TL'),
                  _DirectionalRadiusBox(value: 'tr-xl', label: 'TR'),
                  _DirectionalRadiusBox(value: 'bl-xl', label: 'BL'),
                  _DirectionalRadiusBox(value: 'br-xl', label: 'BR'),
                ],
              ),
            ],
          ),

          // Quick Reference
          WDiv(
            className: 'p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
            children: [
              const WText(
                'Quick Reference',
                className: 'font-semibold text-gray-800 dark:text-white mb-2',
              ),
              WDiv(
                className: 'flex flex-col gap-1',
                children: const [
                  WText(
                    'rounded-sm | rounded | rounded-md | rounded-lg | rounded-xl',
                    className:
                        'text-xs font-mono text-gray-600 dark:text-gray-400',
                  ),
                  WText(
                    'rounded-{t|r|b|l|tl|tr|bl|br}-{size}',
                    className:
                        'text-xs font-mono text-gray-600 dark:text-gray-400',
                  ),
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
}

class _RadiusBox extends StatelessWidget {
  final String value;
  final String label;

  const _RadiusBox({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final radiusClass = value.isEmpty ? 'rounded' : 'rounded-$value';
    return WDiv(
      className: 'flex flex-col items-center gap-2',
      children: [
        WDiv(className: 'w-14 h-14 $radiusClass bg-purple-500'),
        WText(
          radiusClass,
          className: 'text-xs text-gray-500 dark:text-gray-400 font-mono',
        ),
      ],
    );
  }
}

class _DirectionalRadiusBox extends StatelessWidget {
  final String value;
  final String label;

  const _DirectionalRadiusBox({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'flex flex-col items-center gap-2',
      children: [
        WDiv(className: 'w-14 h-14 rounded-$value bg-pink-500'),
        WText(
          label,
          className: 'text-xs text-gray-500 dark:text-gray-400 font-mono',
        ),
      ],
    );
  }
}
