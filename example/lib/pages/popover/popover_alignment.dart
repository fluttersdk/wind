import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// WPopover alignment examples showing all 6 alignment options.
class PopoverAlignmentExamplePage extends StatelessWidget {
  const PopoverAlignmentExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'w-full h-full overflow-y-auto p-4',
      child: WDiv(
        className: 'flex flex-col gap-6',
        children: [
          // Header with gradient
          WDiv(
            className: '''
              w-full p-4 rounded-xl
              bg-gradient-to-r from-amber-500 to-orange-500
            ''',
            children: const [
              WText(
                'Popover Alignment',
                className: 'text-lg font-bold text-white',
              ),
              WText(
                'All 6 alignment positions',
                className: 'text-sm text-amber-100',
              ),
            ],
          ),

          // Bottom alignments
          _buildSection(
            title: 'Bottom Alignments',
            description: 'Opens below the trigger',
            children: [
              WDiv(
                className: 'flex gap-4 flex-wrap',
                children: [
                  _alignmentDemo('bottomLeft', PopoverAlignment.bottomLeft),
                  _alignmentDemo('bottomCenter', PopoverAlignment.bottomCenter),
                  _alignmentDemo('bottomRight', PopoverAlignment.bottomRight),
                ],
              ),
            ],
          ),

          // Spacer for top alignments
          const WDiv(className: 'h-24'),

          // Top alignments
          _buildSection(
            title: 'Top Alignments',
            description: 'Opens above the trigger',
            children: [
              WDiv(
                className: 'flex gap-4 flex-wrap',
                children: [
                  _alignmentDemo('topLeft', PopoverAlignment.topLeft),
                  _alignmentDemo('topCenter', PopoverAlignment.topCenter),
                  _alignmentDemo('topRight', PopoverAlignment.topRight),
                ],
              ),
            ],
          ),

          // Quick Reference
          WDiv(
            className: 'p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
            children: [
              const WText(
                'PopoverAlignment',
                className: 'font-semibold text-gray-800 dark:text-white mb-2',
              ),
              WDiv(
                className: 'flex flex-col gap-1',
                children: [
                  _referenceRow('bottomLeft', 'Default'),
                  _referenceRow('bottomCenter', 'Centered'),
                  _referenceRow('bottomRight', 'Right-aligned'),
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

  Widget _referenceRow(String className, String value) {
    return WDiv(
      className: 'flex justify-between',
      children: [
        WText(
          className,
          className: 'text-sm font-mono text-gray-600 dark:text-gray-300',
        ),
        WText(value, className: 'text-sm text-gray-500 dark:text-gray-400'),
      ],
    );
  }

  Widget _alignmentDemo(String label, PopoverAlignment alignment) {
    return WPopover(
      alignment: alignment,
      className: '''
        w-40 p-3
        bg-white dark:bg-slate-800
        border border-gray-200 dark:border-gray-700
        rounded-lg shadow-lg
      ''',
      triggerBuilder: (context, isOpen, isHovering) => WDiv(
        className:
            '''
          px-4 py-2 rounded-lg
          bg-gray-800 dark:bg-gray-700
          ${isOpen ? 'ring-2 ring-blue-400' : ''}
        ''',
        child: WText(label, className: 'text-white text-sm'),
      ),
      contentBuilder: (context, close) => WDiv(
        className: 'flex flex-col gap-2',
        children: [
          WText(
            'Alignment: $label',
            className: 'font-medium text-sm text-gray-800 dark:text-gray-200',
          ),
          const WText(
            'Uses this alignment.',
            className: 'text-xs text-gray-600 dark:text-gray-400',
          ),
          WButton(
            onTap: close,
            className: '''
              w-full px-3 py-1 mt-1 rounded text-center
              bg-gray-100 dark:bg-slate-700
              hover:bg-gray-200 dark:hover:bg-slate-600
              duration-150
            ''',
            child: const WText(
              'Close',
              className: 'text-sm text-gray-700 dark:text-gray-300',
            ),
          ),
        ],
      ),
    );
  }
}
