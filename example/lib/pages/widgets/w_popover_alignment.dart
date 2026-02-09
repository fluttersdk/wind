import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class WPopoverAlignmentExamplePage extends StatelessWidget {
  const WPopoverAlignmentExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className:
          'w-full h-full overflow-y-auto p-4 bg-gray-50 dark:bg-slate-900',
      scrollPrimary: true,
      child: WDiv(
        className: 'flex flex-col gap-6 max-w-4xl mx-auto pb-32',
        children: [
          _buildHeader(),
          _buildAlignmentGrid(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className:
          'bg-gradient-to-r from-purple-500 to-pink-600 rounded-xl p-6 shadow-lg',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WText(
            'WPopover Alignment',
            className: 'text-2xl font-bold text-white mb-2',
          ),
          WText(
            'Demonstration of different popover placement strategies.',
            className: 'text-purple-100',
          ),
        ],
      ),
    );
  }

  Widget _buildAlignmentGrid(BuildContext context) {
    return WDiv(
      className:
          'flex flex-col gap-6 p-6 bg-white dark:bg-slate-800 rounded-xl shadow-sm border border-gray-100 dark:border-slate-700',
      children: [
        WText(
          'Click buttons to see popover positioning',
          className: 'text-lg font-bold text-slate-900 dark:text-white mb-4',
        ),

        // Top Row
        WDiv(
          className: 'flex flex-wrap gap-4 justify-between',
          children: [
            _buildPopoverDemo(
              context,
              'Top Left',
              PopoverAlignment.topLeft,
              'bg-blue-500 hover:bg-blue-600',
            ),
            _buildPopoverDemo(
              context,
              'Top Center',
              PopoverAlignment.topCenter,
              'bg-blue-500 hover:bg-blue-600',
            ),
            _buildPopoverDemo(
              context,
              'Top Right',
              PopoverAlignment.topRight,
              'bg-blue-500 hover:bg-blue-600',
            ),
          ],
        ),

        // Spacing
        const WSpacer(className: 'h-16'),

        // Bottom Row
        WDiv(
          className: 'flex flex-wrap gap-4 justify-between',
          children: [
            _buildPopoverDemo(
              context,
              'Bottom Left',
              PopoverAlignment.bottomLeft,
              'bg-emerald-500 hover:bg-emerald-600',
            ),
            _buildPopoverDemo(
              context,
              'Bottom Center',
              PopoverAlignment.bottomCenter,
              'bg-emerald-500 hover:bg-emerald-600',
            ),
            _buildPopoverDemo(
              context,
              'Bottom Right',
              PopoverAlignment.bottomRight,
              'bg-emerald-500 hover:bg-emerald-600',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPopoverDemo(
    BuildContext context,
    String label,
    PopoverAlignment alignment,
    String btnClass,
  ) {
    return WPopover(
      alignment: alignment,
      className:
          'w-48 bg-white dark:bg-slate-700 shadow-xl rounded-lg p-3 border border-gray-100 dark:border-slate-600',
      triggerBuilder: (context, isOpen, isHovering) => WButton(
        className:
            '$btnClass text-white px-4 py-2 rounded-lg transition-colors shadow-sm',
        child: WText(label, className: 'font-medium'),
      ),
      contentBuilder: (context, close) => WDiv(
        className: 'flex flex-col gap-2',
        children: [
          WText(
            'Aligned: ${label}',
            className: 'font-bold text-sm text-slate-800 dark:text-slate-200',
          ),
          WText(
            'This content is positioned relative to the trigger.',
            className: 'text-xs text-slate-500 dark:text-slate-400',
          ),
          const WSpacer(className: 'h-2'),
          WButton(
            onTap: close,
            className:
                'w-full bg-blue-500 hover:bg-blue-600 text-white py-2 rounded-lg text-sm font-medium transition-colors shadow-sm',
            child: WDiv(
              className: 'flex items-center justify-center gap-2',
              children: [
                WIcon(Icons.close, className: 'text-sm text-white'),
                WText('Close', className: 'text-white'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
