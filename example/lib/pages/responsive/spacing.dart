import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Responsive Spacing Example
/// Demonstrates padding and margins that adapt to screen size
class ResponsiveSpacingExamplePage extends StatelessWidget {
  const ResponsiveSpacingExamplePage({super.key});

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
            className:
                'w-full p-4 rounded-xl bg-gradient-to-r from-violet-500 to-purple-500',
            children: [
              WText(
                'Responsive Spacing',
                className: 'text-lg font-bold text-white',
              ),
              WText(
                'Padding, max-width and gap adapt based on screen size',
                className: 'text-sm text-violet-100 mb-3',
              ),
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
                  _buildBadge('base', width < 640),
                  _buildBadge('sm', width >= 640 && width < 768),
                  _buildBadge('md', width >= 768 && width < 1024),
                  _buildBadge('lg', width >= 1024 && width < 1280),
                  _buildBadge('xl', width >= 1280),
                ],
              ),
            ],
          ),

          // Responsive padding
          WDiv(
            className: '''
              p-4 md:p-6 lg:p-8
              rounded-xl bg-violet-100 dark:bg-violet-900/30
              border-2 border-dashed border-violet-300 dark:border-violet-700
            ''',
            children: [
              WText(
                'Responsive Padding',
                className: 'font-bold text-violet-800 dark:text-violet-200',
              ),
              WText(
                'p-4 → md:p-6 → lg:p-8',
                className:
                    'text-sm font-mono text-violet-600 dark:text-violet-400 mt-1',
              ),
              WDiv(className: 'h-2'),
              WText(
                'This container has 16px padding on mobile, 24px on tablet, and 32px on desktop.',
                className: 'text-sm text-violet-700 dark:text-violet-300',
              ),
            ],
          ),

          // Responsive max-width
          WDiv(
            className: '''
              w-full max-w-xs md:max-w-md lg:max-w-2xl
              p-4 rounded-xl
              bg-purple-100 dark:bg-purple-900/30
              border-2 border-dashed border-purple-300 dark:border-purple-700
            ''',
            children: [
              WText(
                'Responsive Max-Width',
                className: 'font-bold text-purple-800 dark:text-purple-200',
              ),
              WText(
                'max-w-xs → md:max-w-md → lg:max-w-2xl',
                className:
                    'text-sm font-mono text-purple-600 dark:text-purple-400 mt-1',
              ),
              WDiv(className: 'h-2'),
              WText(
                'This container grows wider on larger screens.',
                className: 'text-sm text-purple-700 dark:text-purple-300',
              ),
            ],
          ),

          // Responsive gap
          WDiv(
            className: '''
              p-4 rounded-xl
              bg-fuchsia-100 dark:bg-fuchsia-900/30
              border-2 border-dashed border-fuchsia-300 dark:border-fuchsia-700
            ''',
            children: [
              WText(
                'Responsive Gap',
                className: 'font-bold text-fuchsia-800 dark:text-fuchsia-200',
              ),
              WText(
                'gap-2 → md:gap-4 → lg:gap-6',
                className:
                    'text-sm font-mono text-fuchsia-600 dark:text-fuchsia-400 mt-1',
              ),
              WDiv(className: 'h-4'),
              WDiv(
                className: 'flex wrap gap-2 md:gap-4 lg:gap-6',
                children: List.generate(4, (i) {
                  return WDiv(
                    className:
                        'w-16 h-16 rounded-lg bg-fuchsia-500 flex items-center justify-center',
                    child: WText(
                      '${i + 1}',
                      className: 'text-white font-bold',
                    ),
                  );
                }),
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
                '  className: "p-4 md:p-6 lg:p-8",\n'
                '  child: content,\n'
                ')',
                className: 'text-sm font-mono text-violet-400',
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
        ${isActive ? 'bg-white text-purple-600' : 'bg-white/10 text-white/50'}
      ''',
      child: WText(label),
    );
  }
}
