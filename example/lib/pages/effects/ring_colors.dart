import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Ring Colors Example Page - demonstrates ring color utilities.
class RingColorsExamplePage extends StatelessWidget {
  const RingColorsExamplePage({super.key});

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
            children: const [
              WText('Ring Colors', className: 'text-lg font-bold text-white'),
              WText(
                'Theme and arbitrary ring colors',
                className: 'text-sm text-emerald-100',
              ),
            ],
          ),

          // Theme colors
          _buildSection(
            title: 'ring-{color}-{shade}',
            description: 'Use any theme color for rings',
            children: [
              WDiv(
                className: 'flex gap-3 overflow-x-auto',
                children: const [
                  _ColorBox(color: 'red-500'),
                  _ColorBox(color: 'orange-500'),
                  _ColorBox(color: 'green-500'),
                  _ColorBox(color: 'blue-500'),
                  _ColorBox(color: 'purple-500'),
                ],
              ),
            ],
          ),

          // Arbitrary colors
          _buildSection(
            title: 'ring-[#hex]',
            description: 'Use custom hex colors',
            children: [
              WDiv(
                className: 'flex gap-3 overflow-x-auto',
                children: const [
                  _HexBox(hex: '#1da1f2', label: 'Twitter'),
                  _HexBox(hex: '#E1306C', label: 'Instagram'),
                  _HexBox(hex: '#25D366', label: 'WhatsApp'),
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
                    'ring-{color}-{shade} → ring-blue-500',
                    className:
                        'text-xs font-mono text-gray-600 dark:text-gray-400',
                  ),
                  WText(
                    'ring-[#hex] → ring-[#1da1f2]',
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

class _ColorBox extends StatelessWidget {
  final String color;

  const _ColorBox({required this.color});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'flex flex-col items-center gap-2',
      children: [
        WDiv(
          className:
              '''
            ring-4 ring-$color w-14 h-14 bg-white rounded-lg
            flex items-center justify-center
          ''',
        ),
        WText(
          color,
          className: 'text-xs text-gray-500 dark:text-gray-400 font-mono',
        ),
      ],
    );
  }
}

class _HexBox extends StatelessWidget {
  final String hex;
  final String label;

  const _HexBox({required this.hex, required this.label});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'flex flex-col items-center gap-2',
      children: [
        WDiv(
          className:
              '''
            ring-4 ring-[$hex] w-14 h-14 bg-white rounded-lg
            flex items-center justify-center
          ''',
        ),
        WText(
          label,
          className: 'text-xs text-gray-500 dark:text-gray-400 font-mono',
        ),
      ],
    );
  }
}
