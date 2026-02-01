import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Responsive Layout Example
/// Demonstrates sidebar layout: stacked on mobile, side-by-side on desktop
class ResponsiveLayoutExamplePage extends StatelessWidget {
  const ResponsiveLayoutExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isLarge = width >= 1024;

    return WDiv(
      className: 'w-full h-full overflow-y-auto p-4',
      child: WDiv(
        className: 'flex flex-col gap-4 max-w-4xl',
        children: [
          // Header
          WDiv(
            className: 'w-full p-4 rounded-xl bg-gradient-to-r from-cyan-500 to-blue-500',
            children: [
              WText(
                'Responsive Layout',
                className: 'text-lg font-bold text-white',
              ),
              WText(
                'Sidebar stacks on mobile, side-by-side on lg+',
                className: 'text-sm text-cyan-100 mb-3',
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
                  _buildBadge('base', width < 640),
                  _buildBadge('sm', width >= 640 && width < 768),
                  _buildBadge('md', width >= 768 && width < 1024),
                  _buildBadge('lg', width >= 1024 && width < 1280),
                  _buildBadge('xl', width >= 1280),
                ],
              ),
            ],
          ),

          // Layout Demo - manuel Row/Column switch (lg:flex-row demo)
          WDiv(
            className: 'rounded-xl overflow-hidden shadow-lg',
            child: isLarge
                ? WDiv(
                    className: 'flex flex-row',
                    children: [
                      _buildSidebar(isVertical: true),
                      WDiv(
                        className: 'flex-1',
                        child: _buildMainContent(),
                      ),
                    ],
                  )
                : WDiv(
                    className: 'flex flex-col',
                    children: [
                      _buildSidebar(isVertical: false),
                      _buildMainContent(),
                    ],
                  ),
          ),

          // Code example
          WDiv(
            className: 'p-4 rounded-xl bg-slate-800',
            children: [
              WText(
                'Code:',
                className: 'text-sm font-bold text-gray-300 mb-2',
              ),
              WText(
                'WDiv(\n'
                '  className: "flex flex-col lg:flex-row",\n'
                '  children: [sidebar, mainContent],\n'
                ')',
                className: 'text-sm font-mono text-cyan-400',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String label, bool isActive) {
    return WDiv(
      className: '''
        px-2 py-1 rounded text-xs font-bold
        ${isActive ? 'bg-white text-blue-600' : 'bg-white/10 text-white/50'}
      ''',
      child: WText(label),
    );
  }

  Widget _buildSidebar({required bool isVertical}) {
    return WDiv(
      className: 'bg-slate-800 p-4',
      children: [
        WText('Sidebar', className: 'text-white font-bold mb-3'),
        WDiv(
          className: 'flex ${isVertical ? "flex-col" : "flex-row"} gap-2',
          children: [
            _buildNavItem(Icons.home, 'Home'),
            _buildNavItem(Icons.search, 'Search'),
            _buildNavItem(Icons.settings, 'Settings'),
          ],
        ),
      ],
    );
  }

  Widget _buildNavItem(IconData icon, String label) {
    return WButton(
      onTap: () {},
      child: WDiv(
        className: 'flex items-center gap-2 px-3 py-2 rounded-lg bg-white/10 hover:bg-white/20 transition-colors',
        children: [
          WIcon(icon, className: 'text-white text-sm'),
          WText(label, className: 'text-white text-sm'),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return WDiv(
      className: 'bg-white dark:bg-slate-700 p-4 min-h-48',
      children: [
        WText(
          'Main Content',
          className: 'text-lg font-bold text-gray-800 dark:text-white',
        ),
        WDiv(className: 'h-2'),
        WText(
          'This area takes the remaining space with flex-1. '
          'On mobile, it stacks below the sidebar. On lg+, it appears side-by-side.',
          className: 'text-sm text-gray-600 dark:text-gray-300',
        ),
        WDiv(className: 'h-4'),
        WDiv(
          className: 'flex flex-wrap gap-2',
          children: [
            _buildTag('flex-col'),
            _buildTag('lg:flex-row'),
            _buildTag('w-full'),
            _buildTag('lg:w-56'),
            _buildTag('flex-1'),
          ],
        ),
      ],
    );
  }

  Widget _buildTag(String label) {
    return WDiv(
      className: 'px-2 py-1 rounded bg-cyan-100 dark:bg-cyan-900/50 text-cyan-700 dark:text-cyan-300 text-xs font-mono',
      child: WText(label),
    );
  }
}
