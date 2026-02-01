import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Border Arbitrary Colors Example Page - demonstrates hex color borders.
class ColorsArbitraryPage extends StatelessWidget {
  const ColorsArbitraryPage({super.key});

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
              bg-gradient-to-r from-fuchsia-500 to-violet-500
            ''',
            children: const [
              WText(
                'Arbitrary Colors',
                className: 'text-lg font-bold text-white',
              ),
              WText(
                'Use custom hex colors for borders',
                className: 'text-sm text-fuchsia-100',
              ),
            ],
          ),

          // Hex colors
          _buildSection(
            title: 'border-[#hex]',
            description: 'Use any hex color value',
            children: [
              WDiv(
                className: 'flex gap-4 overflow-x-auto',
                children: const [
                  _HexColorBox(hex: '#FF5733', label: 'Coral'),
                  _HexColorBox(hex: '#3498DB', label: 'Blue'),
                  _HexColorBox(hex: '#1DA1F2', label: 'Twitter'),
                  _HexColorBox(hex: '#E1306C', label: 'Instagram'),
                ],
              ),
            ],
          ),

          // Brand colors
          _buildSection(
            title: 'Brand Colors',
            description: 'Use exact brand colors',
            children: [
              WDiv(
                className: 'flex gap-4 overflow-x-auto',
                children: const [
                  _HexColorBox(hex: '#4285F4', label: 'Google'),
                  _HexColorBox(hex: '#1877F2', label: 'Facebook'),
                  _HexColorBox(hex: '#25D366', label: 'WhatsApp'),
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
                    'border-[#FF5733] → Any hex color',
                    className:
                        'text-xs font-mono text-gray-600 dark:text-gray-400',
                  ),
                  WText(
                    'Supports 3, 4, 6, and 8 digit hex codes',
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

class _HexColorBox extends StatelessWidget {
  final String hex;
  final String label;

  const _HexColorBox({required this.hex, required this.label});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'flex flex-col items-center gap-2',
      children: [
        WDiv(className: 'w-14 h-14 border-2 border-[$hex] rounded-lg bg-white'),
        WText(
          label,
          className: 'text-xs text-gray-500 dark:text-gray-400 font-mono',
        ),
        WText(
          hex,
          className: 'text-xs text-gray-400 dark:text-gray-500 font-mono',
        ),
      ],
    );
  }
}
