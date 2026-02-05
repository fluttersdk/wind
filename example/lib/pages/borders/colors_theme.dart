import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Border Colors Example Page - demonstrates theme color utilities.
class ColorsThemePage extends StatelessWidget {
  const ColorsThemePage({super.key});

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
              bg-gradient-to-r from-rose-500 to-orange-500
            ''',
            children: const [
              WText('Border Colors', className: 'text-lg font-bold text-white'),
              WText(
                'Theme color border utilities',
                className: 'text-sm text-rose-100',
              ),
            ],
          ),

          // Theme colors
          _buildSection(
            title: 'border-{color}-{shade}',
            description: 'Use any theme color for borders',
            children: [
              WDiv(
                className: 'flex gap-3 overflow-x-auto',
                children: const [
                  _ColorBox(color: 'red-500'),
                  _ColorBox(color: 'orange-500'),
                  _ColorBox(color: 'amber-500'),
                  _ColorBox(color: 'green-500'),
                  _ColorBox(color: 'blue-500'),
                  _ColorBox(color: 'purple-500'),
                ],
              ),
            ],
          ),

          // Color opacity
          _buildSection(
            title: 'border-{color}/opacity',
            description: 'Control border color opacity',
            children: [
              WDiv(
                className: 'flex gap-3 overflow-x-auto',
                children: const [
                  _OpacityBox(opacity: '100'),
                  _OpacityBox(opacity: '75'),
                  _OpacityBox(opacity: '50'),
                  _OpacityBox(opacity: '25'),
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
                    'border-{color}-{shade} → border-blue-500',
                    className:
                        'text-xs font-mono text-gray-600 dark:text-gray-400',
                  ),
                  WText(
                    'border-{color}/opacity → border-blue-500/50',
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
        WDiv(className: 'w-12 h-12 border-2 border-$color rounded-lg bg-white'),
        WText(
          color,
          className: 'text-xs text-gray-500 dark:text-gray-400 font-mono',
        ),
      ],
    );
  }
}

class _OpacityBox extends StatelessWidget {
  final String opacity;

  const _OpacityBox({required this.opacity});

  @override
  Widget build(BuildContext context) {
    final opacityClass =
        opacity == '100' ? 'border-rose-500' : 'border-rose-500/$opacity';
    return WDiv(
      className: 'flex flex-col items-center gap-2',
      children: [
        WDiv(className: 'w-12 h-12 border-4 $opacityClass rounded-lg bg-white'),
        WText(
          '$opacity%',
          className: 'text-xs text-gray-500 dark:text-gray-400 font-mono',
        ),
      ],
    );
  }
}
