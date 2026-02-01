import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Ring Basic Example Page - demonstrates ring width, offset, and inset.
class RingBasicExamplePage extends StatelessWidget {
  const RingBasicExamplePage({super.key});

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
              bg-gradient-to-r from-blue-500 to-cyan-500
            ''',
            children: const [
              WText('Ring', className: 'text-lg font-bold text-white'),
              WText('Focus ring utilities', className: 'text-sm text-blue-100'),
            ],
          ),

          // Ring widths
          _buildSection(
            title: 'ring-{width}',
            description: 'Control the width of the ring',
            children: [
              WDiv(
                className: 'flex gap-4 overflow-x-auto',
                children: const [
                  _RingBox(width: '0', label: '0px'),
                  _RingBox(width: '1', label: '1px'),
                  _RingBox(width: '2', label: '2px'),
                  _RingBox(width: '', label: '3px'),
                  _RingBox(width: '4', label: '4px'),
                  _RingBox(width: '8', label: '8px'),
                ],
              ),
            ],
          ),

          // Ring offset
          _buildSection(
            title: 'ring-offset-{width}',
            description: 'Add space between element and ring',
            children: [
              WDiv(
                className: 'flex gap-4 overflow-x-auto',
                children: const [
                  _OffsetBox(offset: '0'),
                  _OffsetBox(offset: '1'),
                  _OffsetBox(offset: '2'),
                  _OffsetBox(offset: '4'),
                ],
              ),
            ],
          ),

          // Ring inset
          _buildSection(
            title: 'ring-inset',
            description: 'Render the ring inside the element',
            children: [
              WDiv(
                className: 'flex gap-4 overflow-x-auto',
                children: const [
                  _InsetBox(inset: false),
                  _InsetBox(inset: true),
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
                    'ring | ring-2 | ring-4 | ring-8',
                    className:
                        'text-xs font-mono text-gray-600 dark:text-gray-400',
                  ),
                  WText(
                    'ring-offset-{0|1|2|4|8} | ring-inset',
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

class _RingBox extends StatelessWidget {
  final String width;
  final String label;

  const _RingBox({required this.width, required this.label});

  @override
  Widget build(BuildContext context) {
    final ringClass = width.isEmpty ? 'ring' : 'ring-$width';
    return WDiv(
      className: 'flex flex-col items-center gap-2',
      children: [
        WDiv(
          className:
              '''
            $ringClass ring-blue-500 w-16 h-16 bg-white rounded-lg
            flex items-center justify-center
          ''',
          children: [
            WText(label, className: 'text-xs text-gray-600 font-medium'),
          ],
        ),
        WText(
          ringClass,
          className: 'text-xs text-gray-500 dark:text-gray-400 font-mono',
        ),
      ],
    );
  }
}

class _OffsetBox extends StatelessWidget {
  final String offset;

  const _OffsetBox({required this.offset});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'flex flex-col items-center gap-2',
      children: [
        WDiv(
          className:
              '''
            ring-4 ring-offset-$offset ring-blue-500 w-16 h-16 bg-white rounded-lg
            flex items-center justify-center
          ''',
          children: [
            WText(
              '${offset}px',
              className: 'text-xs text-gray-600 font-medium',
            ),
          ],
        ),
        WText(
          'offset-$offset',
          className: 'text-xs text-gray-500 dark:text-gray-400 font-mono',
        ),
      ],
    );
  }
}

class _InsetBox extends StatelessWidget {
  final bool inset;

  const _InsetBox({required this.inset});

  @override
  Widget build(BuildContext context) {
    final insetClass = inset ? 'ring-inset' : '';
    return WDiv(
      className: 'flex flex-col items-center gap-2',
      children: [
        WDiv(
          className:
              '''
            ring-4 $insetClass ring-blue-500 w-16 h-16 bg-blue-100 rounded-lg
            flex items-center justify-center
          ''',
          children: [
            WText(
              inset ? 'Inset' : 'Normal',
              className: 'text-xs text-gray-600 font-medium',
            ),
          ],
        ),
        WText(
          inset ? 'ring-inset' : 'default',
          className: 'text-xs text-gray-500 dark:text-gray-400 font-mono',
        ),
      ],
    );
  }
}
