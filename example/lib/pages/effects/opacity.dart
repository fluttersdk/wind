import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Example page demonstrating opacity utility classes.
class OpacityExamplePage extends StatelessWidget {
  const OpacityExamplePage({super.key});

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
              bg-gradient-to-r from-slate-500 to-gray-600
            ''',
            children: const [
              WText('Opacity', className: 'text-lg font-bold text-white'),
              WText(
                'Control element transparency with opacity utilities',
                className: 'text-sm text-slate-200',
              ),
            ],
          ),

          // Standard opacity values
          _buildSection(
            title: 'opacity-{value}',
            description: 'Standard opacity values from 0 to 100',
            children: [
              WDiv(
                className: 'flex gap-3 overflow-x-auto',
                children: const [
                  _OpacityBox(value: '100', opacity: 1.0),
                  _OpacityBox(value: '75', opacity: 0.75),
                  _OpacityBox(value: '50', opacity: 0.50),
                  _OpacityBox(value: '25', opacity: 0.25),
                  _OpacityBox(value: '0', opacity: 0.0),
                ],
              ),
            ],
          ),

          // Fine-grained control
          _buildSection(
            title: 'Fine-Grained Control',
            description: 'Additional values for precise opacity control',
            children: [
              WDiv(
                className: 'flex gap-3 overflow-x-auto',
                children: const [
                  _OpacityBox(value: '95', opacity: 0.95),
                  _OpacityBox(value: '90', opacity: 0.90),
                  _OpacityBox(value: '80', opacity: 0.80),
                  _OpacityBox(value: '70', opacity: 0.70),
                  _OpacityBox(value: '60', opacity: 0.60),
                ],
              ),
              const SizedBox(height: 8),
              WDiv(
                className: 'flex gap-3 overflow-x-auto',
                children: const [
                  _OpacityBox(value: '40', opacity: 0.40),
                  _OpacityBox(value: '30', opacity: 0.30),
                  _OpacityBox(value: '20', opacity: 0.20),
                  _OpacityBox(value: '10', opacity: 0.10),
                  _OpacityBox(value: '5', opacity: 0.05),
                ],
              ),
            ],
          ),

          // Arbitrary values
          _buildSection(
            title: 'opacity-[value]',
            description: 'Use bracket notation for custom values',
            children: [
              WDiv(
                className: 'flex gap-3 overflow-x-auto',
                children: const [
                  _ArbitraryOpacityBox(value: '0.67'),
                  _ArbitraryOpacityBox(value: '0.35'),
                  _ArbitraryOpacityBox(value: '0.15'),
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
                    'opacity-0 → 0%  |  opacity-50 → 50%  |  opacity-100 → 100%',
                    className:
                        'text-xs font-mono text-gray-600 dark:text-gray-400',
                  ),
                  WText(
                    'opacity-[0.35] → Custom 35%',
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
  final String value;
  final double opacity;

  const _OpacityBox({required this.value, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'flex flex-col items-center gap-2',
      children: [
        WDiv(
          className: '''
            opacity-$value w-16 h-16 bg-blue-500 rounded-lg
            flex items-center justify-center
          ''',
          children: [
            WText(
              '${(opacity * 100).toInt()}%',
              className: 'text-white font-bold text-xs',
            ),
          ],
        ),
        WText(
          'opacity-$value',
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
          className: '''
            opacity-[$value] w-16 h-16 bg-purple-500 rounded-lg
            flex items-center justify-center
          ''',
          children: [WText(value, className: 'text-white font-bold text-xs')],
        ),
        WText(
          'opacity-[$value]',
          className: 'text-xs text-gray-500 dark:text-gray-400 font-mono',
        ),
      ],
    );
  }
}
