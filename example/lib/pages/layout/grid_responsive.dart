import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Grid Responsive Example
/// Demonstrates responsive grid columns that adapt to screen size
class GridResponsiveExamplePage extends StatelessWidget {
  const GridResponsiveExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return WDiv(
      className: 'w-full h-full overflow-y-auto p-4',
      child: WDiv(
        className: 'flex flex-col gap-6 max-w-4xl',
        children: [
          // Header with breakpoint indicator
          WDiv(
            className: '''
              w-full p-4 rounded-xl
              bg-gradient-to-r from-emerald-500 to-teal-500
            ''',
            children: [
              WText(
                'Responsive Grid',
                className: 'text-lg font-bold text-white',
              ),
              WText(
                'Grid adapts columns based on screen size',
                className: 'text-sm text-emerald-100 mb-3',
              ),
              WDiv(
                className: 'flex flex-wrap items-center gap-2',
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
          ),

          // Responsive Grid Demo
          WDiv(
            className: 'flex flex-col gap-2',
            children: [
              WText(
                'Responsive Columns',
                className: 'font-semibold text-gray-800 dark:text-white',
              ),
              // Show code badge only on md+ screens to avoid overflow
              WDiv(
                className: 'hidden md:block',
                child: WDiv(
                  className:
                      'px-2 py-1 rounded bg-emerald-100 dark:bg-emerald-900/50 inline-block',
                  child: WText(
                    'grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4',
                    className:
                        'text-xs font-mono text-emerald-700 dark:text-emerald-300',
                  ),
                ),
              ),
              WDiv(
                className: '''
                  grid gap-3
                  grid-cols-1
                  sm:grid-cols-2
                  lg:grid-cols-3
                  xl:grid-cols-4
                ''',
                children: List.generate(8, (index) {
                  final colors = [
                    'bg-emerald-500',
                    'bg-teal-500',
                    'bg-cyan-500',
                    'bg-sky-500',
                    'bg-blue-500',
                    'bg-indigo-500',
                    'bg-violet-500',
                    'bg-purple-500',
                  ];
                  return WDiv(
                    className:
                        '''
                      ${colors[index]} rounded-xl
                      h-24 flex items-center justify-center
                    ''',
                    child: WText(
                      'Item ${index + 1}',
                      className: 'text-white font-semibold',
                    ),
                  );
                }),
              ),
            ],
          ),

          // Column count indicator - hidden on mobile, shown on md+
          WDiv(
            className:
                'hidden md:block p-4 rounded-xl bg-gray-100 dark:bg-slate-700',
            children: [
              WText(
                'Current Layout',
                className: 'font-semibold text-gray-800 dark:text-white mb-2',
              ),
              WDiv(
                className: 'flex flex-wrap gap-2',
                children: [
                  _buildLayoutTag('grid-cols-1', width < 640),
                  _buildLayoutTag(
                    'sm:grid-cols-2',
                    width >= 640 && width < 1024,
                  ),
                  _buildLayoutTag(
                    'lg:grid-cols-3',
                    width >= 1024 && width < 1280,
                  ),
                  _buildLayoutTag('xl:grid-cols-4', width >= 1280),
                ],
              ),
            ],
          ),

          // Code example
          WDiv(
            className: 'p-4 rounded-xl bg-slate-800',
            children: [
              WText('Code:', className: 'text-sm font-bold text-gray-300 mb-2'),
              WText(
                'WDiv(\n'
                '  className: \'\'\'\n'
                '    grid gap-3\n'
                '    grid-cols-1\n'
                '    sm:grid-cols-2\n'
                '    lg:grid-cols-3\n'
                '    xl:grid-cols-4\n'
                '  \'\'\',\n'
                '  children: [...],\n'
                ')',
                className: 'text-sm font-mono text-emerald-400',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBreakpointBadge(String label, bool isActive) {
    return WDiv(
      className:
          '''
        px-2 py-1 rounded text-xs font-bold
        ${isActive ? 'bg-white text-emerald-600' : 'bg-white/10 text-white/50'}
      ''',
      child: WText(label),
    );
  }

  Widget _buildLayoutTag(String label, bool isActive) {
    return WDiv(
      className:
          '''
        px-3 py-1 rounded-lg text-sm font-mono
        ${isActive ? 'bg-emerald-500 text-white' : 'bg-gray-200 dark:bg-slate-600 text-gray-500 dark:text-gray-400'}
      ''',
      child: WText(label),
    );
  }
}
