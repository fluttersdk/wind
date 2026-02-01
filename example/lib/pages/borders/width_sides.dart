import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Border Sides Example Page - demonstrates directional border width.
class WidthSidesPage extends StatelessWidget {
  const WidthSidesPage({super.key});

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
              bg-gradient-to-r from-cyan-500 to-teal-500
            ''',
            children: const [
              WText(
                'Directional Borders',
                className: 'text-lg font-bold text-white',
              ),
              WText(
                'Apply borders to specific sides',
                className: 'text-sm text-cyan-100',
              ),
            ],
          ),

          // Single sides
          _buildSection(
            title: 'border-{t|r|b|l}-{width}',
            description: 'Border on a single side',
            children: [
              WDiv(
                className: 'flex gap-4 overflow-x-auto',
                children: const [
                  _SideBox(side: 't', label: 'Top'),
                  _SideBox(side: 'r', label: 'Right'),
                  _SideBox(side: 'b', label: 'Bottom'),
                  _SideBox(side: 'l', label: 'Left'),
                ],
              ),
            ],
          ),

          // Different widths
          _buildSection(
            title: 'Width Variations',
            description: 'Different thickness per side',
            children: [
              WDiv(
                className: 'flex gap-4 overflow-x-auto',
                children: const [
                  _VariableWidthBox(side: 't', width: '2', label: 't-2'),
                  _VariableWidthBox(side: 'b', width: '4', label: 'b-4'),
                  _VariableWidthBox(side: 'l', width: '8', label: 'l-8'),
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
                    'border-t-4 | border-r-4 | border-b-4 | border-l-4',
                    className:
                        'text-xs font-mono text-gray-600 dark:text-gray-400',
                  ),
                  WText(
                    'Combine with any color: border-t-4 border-red-500',
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

class _SideBox extends StatelessWidget {
  final String side;
  final String label;

  const _SideBox({required this.side, required this.label});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'flex flex-col items-center gap-2',
      children: [
        WDiv(
          className:
              'w-14 h-14 border-$side-4 border-teal-500 bg-teal-50 rounded',
        ),
        WText(
          label,
          className: 'text-xs text-gray-500 dark:text-gray-400 font-mono',
        ),
      ],
    );
  }
}

class _VariableWidthBox extends StatelessWidget {
  final String side;
  final String width;
  final String label;

  const _VariableWidthBox({
    required this.side,
    required this.width,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'flex flex-col items-center gap-2',
      children: [
        WDiv(
          className:
              'w-14 h-14 border-$side-$width border-cyan-500 bg-cyan-50 rounded',
        ),
        WText(
          label,
          className: 'text-xs text-gray-500 dark:text-gray-400 font-mono',
        ),
      ],
    );
  }
}
