import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Responsive Visibility Example
/// Demonstrates show/hide elements based on breakpoints
class ResponsiveVisibilityExamplePage extends StatelessWidget {
  const ResponsiveVisibilityExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return WDiv(
      className: 'w-full h-full overflow-y-auto p-4',
      child: WDiv(
        className: 'flex flex-col gap-4 max-w-4xl',
        children: [
          // Header
          WDiv(
            className: 'w-full p-4 rounded-xl bg-gradient-to-r from-amber-500 to-orange-500',
            children: [
              WText(
                'Show/Hide Elements',
                className: 'text-lg font-bold text-white',
              ),
              WText(
                'Elements appear or disappear based on screen size',
                className: 'text-sm text-amber-100 mb-3',
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

          // Mobile only
          WDiv(
            className: 'block md:hidden p-4 rounded-xl bg-red-500',
            child: WDiv(
              className: 'flex items-center gap-3',
              children: [
                WIcon(Icons.phone_android, className: 'text-white text-2xl'),
                WDiv(
                  children: [
                    WText('Mobile Only', className: 'text-white font-bold'),
                    WText('block md:hidden', className: 'text-white/70 text-sm font-mono'),
                  ],
                ),
              ],
            ),
          ),

          // Tablet only (md to lg)
          WDiv(
            className: 'hidden md:block lg:hidden p-4 rounded-xl bg-amber-500',
            child: WDiv(
              className: 'flex items-center gap-3',
              children: [
                WIcon(Icons.tablet_android, className: 'text-white text-2xl'),
                WDiv(
                  children: [
                    WText('Tablet Only', className: 'text-white font-bold'),
                    WText('hidden md:block lg:hidden', className: 'text-white/70 text-sm font-mono'),
                  ],
                ),
              ],
            ),
          ),

          // Desktop only (lg+)
          WDiv(
            className: 'hidden lg:block p-4 rounded-xl bg-emerald-500',
            child: WDiv(
              className: 'flex items-center gap-3',
              children: [
                WIcon(Icons.desktop_windows, className: 'text-white text-2xl'),
                WDiv(
                  children: [
                    WText('Desktop Only', className: 'text-white font-bold'),
                    WText('hidden lg:block', className: 'text-white/70 text-sm font-mono'),
                  ],
                ),
              ],
            ),
          ),

          // Always visible
          WDiv(
            className: 'p-4 rounded-xl bg-gray-200 dark:bg-slate-700 border-2 border-dashed border-gray-400 dark:border-slate-500',
            child: WDiv(
              className: 'flex items-center justify-center gap-2',
              children: [
                WIcon(Icons.visibility, className: 'text-gray-500 dark:text-gray-400'),
                WText(
                  'Always visible (no breakpoint prefix)',
                  className: 'text-gray-600 dark:text-gray-300',
                ),
              ],
            ),
          ),

          // Code example
          WDiv(
            className: 'p-4 rounded-xl bg-slate-800',
            children: [
              WText('Code:', className: 'text-sm font-bold text-gray-300 mb-2'),
              WText(
                '// Mobile only\n'
                'className: "block md:hidden"\n\n'
                '// Desktop only\n'
                'className: "hidden lg:block"',
                className: 'text-sm font-mono text-amber-400',
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
        ${isActive ? 'bg-white text-orange-600' : 'bg-white/10 text-white/50'}
      ''',
      child: WText(label),
    );
  }
}
