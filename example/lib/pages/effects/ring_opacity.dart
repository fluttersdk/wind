import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Ring Opacity Example Page - demonstrates ring color opacity.
class RingOpacityExamplePage extends StatelessWidget {
  const RingOpacityExamplePage({super.key});

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
              bg-gradient-to-r from-violet-500 to-purple-500
            ''',
            children: const [
              WText('Ring Opacity', className: 'text-lg font-bold text-white'),
              WText(
                'Control ring color transparency',
                className: 'text-sm text-violet-100',
              ),
            ],
          ),

          // Opacity values
          _buildSection(
            title: 'ring-{color}/opacity',
            description: 'Apply opacity to ring colors',
            children: [
              WDiv(
                className: 'flex gap-4 overflow-x-auto',
                children: const [
                  _OpacityBox(opacity: '100'),
                  _OpacityBox(opacity: '75'),
                  _OpacityBox(opacity: '50'),
                  _OpacityBox(opacity: '25'),
                  _OpacityBox(opacity: '10'),
                ],
              ),
            ],
          ),

          // Arbitrary opacity
          _buildSection(
            title: 'Arbitrary Opacity',
            description: 'Use bracket notation for precise values',
            children: [
              WDiv(
                className: 'flex gap-4 overflow-x-auto',
                children: const [
                  _ArbitraryOpacityBox(value: '0.67'),
                  _ArbitraryOpacityBox(value: '0.33'),
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
                    'ring-blue-500/50 → 50% opacity',
                    className:
                        'text-xs font-mono text-gray-600 dark:text-gray-400',
                  ),
                  WText(
                    'ring-blue-500/[0.33] → 33% opacity',
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

class _OpacityBox extends StatelessWidget {
  final String opacity;

  const _OpacityBox({required this.opacity});

  @override
  Widget build(BuildContext context) {
    final opacityClass = opacity == '100'
        ? 'ring-blue-500'
        : 'ring-blue-500/$opacity';
    return WDiv(
      className: 'flex flex-col items-center gap-2',
      children: [
        WDiv(
          className:
              '''
            ring-4 $opacityClass w-16 h-16 bg-white rounded-lg
            flex items-center justify-center
          ''',
          children: [
            WText('$opacity%', className: 'text-xs text-gray-600 font-medium'),
          ],
        ),
        WText(
          '/$opacity',
          className: 'text-xs text-gray-500 dark:text-gray-400 font-mono',
        ),
      ],
    );
  }
}

class _ArbitraryOpacityBox extends StatelessWidget {
  final String value;

  const _ArbitraryOpacityBox({required this.value});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'flex flex-col items-center gap-2',
      children: [
        WDiv(
          className:
              '''
            ring-4 ring-purple-500/[$value] w-16 h-16 bg-white rounded-lg
            flex items-center justify-center
          ''',
          children: [
            WText(value, className: 'text-xs text-gray-600 font-medium'),
          ],
        ),
        WText(
          '/[$value]',
          className: 'text-xs text-gray-500 dark:text-gray-400 font-mono',
        ),
      ],
    );
  }
}
