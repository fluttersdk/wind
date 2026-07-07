import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Responsive Typography Example
/// Demonstrates text that scales with screen size
class ResponsiveTypographyExamplePage extends StatelessWidget {
  const ResponsiveTypographyExamplePage({super.key});

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
                'w-full p-4 rounded-xl bg-gradient-to-r from-emerald-500 to-teal-500',
            children: [
              WText(
                'Responsive Typography',
                className: 'text-lg font-bold text-white',
              ),
              WText(
                'Text sizes scale up as screen size increases',
                className: 'text-sm text-emerald-100 mb-3',
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

          // Typography Demo
          WDiv(
            className: 'p-6 rounded-xl bg-white dark:bg-slate-800 shadow-lg',
            children: [
              // Heading
              WText(
                'Heading',
                className:
                    'text-2xl md:text-4xl lg:text-5xl font-bold text-gray-800 dark:text-white',
              ),
              WText(
                'text-2xl → md:text-4xl → lg:text-5xl',
                className: 'text-xs font-mono text-teal-500 mt-1',
              ),

              WDiv(className: 'h-6'),

              // Subheading
              WText(
                'Subheading text that scales with screen size',
                className:
                    'text-base md:text-lg lg:text-xl text-gray-600 dark:text-gray-400',
              ),
              WText(
                'text-base → md:text-lg → lg:text-xl',
                className: 'text-xs font-mono text-teal-500 mt-1',
              ),

              WDiv(className: 'h-6'),

              // Body
              WText(
                'Body text with responsive sizing. On mobile, this uses a smaller '
                'font size for better readability. On larger screens, the text size '
                'increases proportionally for comfortable reading.',
                className:
                    'text-sm md:text-base lg:text-lg text-gray-500 dark:text-gray-500',
              ),
              WText(
                'text-sm → md:text-base → lg:text-lg',
                className: 'text-xs font-mono text-teal-500 mt-1',
              ),
            ],
          ),

          // Code example
          WDiv(
            className: 'p-4 rounded-xl bg-slate-800',
            children: [
              WText('Code:', className: 'text-sm font-bold text-gray-300 mb-2'),
              WText(
                'WText(\n'
                '  "Heading",\n'
                '  className: "text-2xl md:text-4xl lg:text-5xl",\n'
                ')',
                className: 'text-sm font-mono text-teal-400',
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
        ${isActive ? 'bg-white text-teal-600' : 'bg-white/10 text-white/50'}
      ''',
      child: WText(label),
    );
  }
}
