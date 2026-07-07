import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Responsive Grid Example
/// Demonstrates responsive grid columns: 1 -> 2 -> 3 -> 4 based on breakpoint
class ResponsiveGridExamplePage extends StatelessWidget {
  const ResponsiveGridExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return WDiv(
      className: 'flex flex-col overflow-y-auto gap-6 p-6 max-w-5xl',
      children: [
        _buildBreakpointIndicator(width),
        _buildSectionTitle('Responsive Grid'),
        _buildDescription(
          'Grid adapts columns based on screen size: '
          '1 col (mobile) → 2 cols (sm) → 3 cols (lg) → 4 cols (xl)',
        ),
        _buildResponsiveGrid(),
      ],
    );
  }

  Widget _buildBreakpointIndicator(double width) {
    return WDiv(
      className:
          'w-full p-4 rounded-xl bg-gradient-to-r from-indigo-500 to-purple-500',
      children: [
        WDiv(
          className: 'flex wrap items-center gap-2',
          children: [
            WDiv(
              className: 'px-3 py-1 rounded-full bg-white/20',
              child: WText(
                '${width.toInt()}px',
                className: 'text-sm font-mono text-white',
              ),
            ),
            _buildBreakpointBadge('base', width < 640),
            _buildBreakpointBadge('sm', width >= 640 && width < 768),
            _buildBreakpointBadge('md', width >= 768 && width < 1024),
            _buildBreakpointBadge('lg', width >= 1024 && width < 1280),
            _buildBreakpointBadge('xl', width >= 1280),
          ],
        ),
      ],
    );
  }

  Widget _buildBreakpointBadge(String label, bool isActive) {
    return WDiv(
      className: '''
        px-2 py-1 rounded text-xs font-bold
        ${isActive ? 'bg-white text-indigo-600' : 'bg-white/10 text-white/50'}
      ''',
      child: WText(label),
    );
  }

  Widget _buildSectionTitle(String title) {
    return WText(
      title,
      className: 'text-lg font-bold text-gray-800 dark:text-white',
    );
  }

  Widget _buildDescription(String text) {
    return WText(
      text,
      className: 'text-sm text-gray-600 dark:text-gray-400',
    );
  }

  Widget _buildResponsiveGrid() {
    final colors = [
      'bg-red-500',
      'bg-orange-500',
      'bg-amber-500',
      'bg-emerald-500',
      'bg-cyan-500',
      'bg-blue-500',
      'bg-violet-500',
      'bg-pink-500',
    ];

    return WDiv(
      className: '''
        grid gap-4
        grid-cols-1
        sm:grid-cols-2
        lg:grid-cols-3
        xl:grid-cols-4
      ''',
      children: List.generate(8, (index) {
        return WDiv(
          className: '''
            ${colors[index]} rounded-xl
            h-24 md:h-32
            flex items-center justify-center
          ''',
          child: WText(
            'Item ${index + 1}',
            className: 'text-white font-semibold',
          ),
        );
      }),
    );
  }
}
