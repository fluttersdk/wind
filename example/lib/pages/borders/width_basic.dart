import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Border Width Example Page - demonstrates border width utilities.
class WidthBasicPage extends StatelessWidget {
  const WidthBasicPage({super.key});

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
              bg-gradient-to-r from-indigo-500 to-blue-500
            ''',
            children: const [
              WText('Border Width', className: 'text-lg font-bold text-white'),
              WText(
                'Control border thickness',
                className: 'text-sm text-indigo-100',
              ),
            ],
          ),

          // Basic widths
          _buildSection(
            title: 'border-{width}',
            description: 'Uniform border width on all sides',
            children: [
              WDiv(
                className: 'flex gap-4 overflow-x-auto',
                children: const [
                  _WidthBox(value: '', label: '1px'),
                  _WidthBox(value: '2', label: '2px'),
                  _WidthBox(value: '4', label: '4px'),
                  _WidthBox(value: '8', label: '8px'),
                  _WidthBox(value: '0', label: '0px'),
                ],
              ),
            ],
          ),

          // Arbitrary width
          _buildSection(
            title: 'border-[value]',
            description: 'Custom border width with bracket notation',
            children: [
              WDiv(
                className: 'flex gap-4 overflow-x-auto',
                children: const [
                  _ArbitraryWidthBox(value: '3px'),
                  _ArbitraryWidthBox(value: '5px'),
                  _ArbitraryWidthBox(value: '6px'),
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
                    'border | border-2 | border-4 | border-8 | border-0',
                    className:
                        'text-xs font-mono text-gray-600 dark:text-gray-400',
                  ),
                  WText(
                    'border-[3px] → Custom width',
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

class _WidthBox extends StatelessWidget {
  final String value;
  final String label;

  const _WidthBox({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final widthClass = value.isEmpty ? 'border' : 'border-$value';
    return WDiv(
      className: 'flex flex-col items-center gap-2',
      children: [
        WDiv(className: 'w-14 h-14 $widthClass border-indigo-500 bg-indigo-50'),
        WText(
          label,
          className: 'text-xs text-gray-500 dark:text-gray-400 font-mono',
        ),
      ],
    );
  }
}

class _ArbitraryWidthBox extends StatelessWidget {
  final String value;

  const _ArbitraryWidthBox({required this.value});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'flex flex-col items-center gap-2',
      children: [
        WDiv(className: 'w-14 h-14 border-[$value] border-blue-500 bg-blue-50'),
        WText(
          value,
          className: 'text-xs text-gray-500 dark:text-gray-400 font-mono',
        ),
      ],
    );
  }
}
