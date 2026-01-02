import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// WPopover alignment examples showing all 6 alignment options.
class PopoverAlignmentExamplePage extends StatelessWidget {
  const PopoverAlignmentExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: WDiv(
        className: 'p-6 bg-gray-100 min-h-screen',
        children: [
          const WText(
            'Popover Alignment Options',
            className: 'font-bold text-lg text-gray-800 mb-2',
          ),
          const WText(
            'Demonstrates all 6 alignment positions',
            className: 'text-gray-600 mb-6',
          ),

          // Bottom alignments
          const WText(
            'Bottom Alignments',
            className: 'font-semibold text-gray-700 mb-3',
          ),
          WDiv(
            className: 'flex gap-4 mb-8',
            children: [
              _AlignmentDemo(
                label: 'bottomLeft',
                alignment: PopoverAlignment.bottomLeft,
              ),
              _AlignmentDemo(
                label: 'bottomCenter',
                alignment: PopoverAlignment.bottomCenter,
              ),
              _AlignmentDemo(
                label: 'bottomRight',
                alignment: PopoverAlignment.bottomRight,
              ),
            ],
          ),

          // Top alignments
          const WText(
            'Top Alignments',
            className: 'font-semibold text-gray-700 mb-3',
          ),
          WDiv(
            className: 'flex gap-4 py-32',
            children: [
              _AlignmentDemo(
                label: 'topLeft',
                alignment: PopoverAlignment.topLeft,
              ),
              _AlignmentDemo(
                label: 'topCenter',
                alignment: PopoverAlignment.topCenter,
              ),
              _AlignmentDemo(
                label: 'topRight',
                alignment: PopoverAlignment.topRight,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AlignmentDemo extends StatelessWidget {
  final String label;
  final PopoverAlignment alignment;

  const _AlignmentDemo({required this.label, required this.alignment});

  @override
  Widget build(BuildContext context) {
    return WPopover(
      alignment: alignment,
      className: '''
        w-40 bg-white dark:bg-gray-800
        border border-gray-200 rounded-lg shadow-lg p-3
      ''',
      triggerBuilder: (context, isOpen, isHovering) => WDiv(
        className:
            '''
          px-4 py-2 bg-gray-800 rounded-lg
          ${isOpen ? 'ring-2 ring-blue-400' : ''}
        ''',
        child: WText(label, className: 'text-white text-sm'),
      ),
      contentBuilder: (context, close) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WText(
            'Alignment: $label',
            className: 'font-medium text-gray-800 text-sm',
          ),
          const WDiv(className: 'h-2'),
          const WText(
            'This popover uses the specified alignment.',
            className: 'text-gray-600 text-xs',
          ),
          const WDiv(className: 'h-3'),
          GestureDetector(
            onTap: close,
            child: WDiv(
              className: 'px-3 py-1 bg-gray-100 rounded text-center',
              child: const WText('Close', className: 'text-gray-700 text-sm'),
            ),
          ),
        ],
      ),
    );
  }
}
