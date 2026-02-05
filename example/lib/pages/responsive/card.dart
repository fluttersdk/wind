import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Responsive Card Example
/// Demonstrates card that changes from vertical to horizontal layout
class ResponsiveCardExamplePage extends StatelessWidget {
  const ResponsiveCardExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMedium = width >= 768;

    return WDiv(
      className: 'w-full h-full overflow-y-auto p-4',
      child: WDiv(
        className: 'flex flex-col gap-4 max-w-4xl',
        children: [
          // Header
          WDiv(
            className:
                'w-full p-4 rounded-xl bg-gradient-to-r from-pink-500 to-rose-500',
            children: [
              WText(
                'Responsive Card',
                className: 'text-lg font-bold text-white',
              ),
              WText(
                'Card stacks vertically on mobile, horizontally on md+',
                className: 'text-sm text-pink-100 mb-3',
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

          // Responsive Card Demo
          WDiv(
            className:
                'rounded-xl overflow-hidden shadow-lg bg-white dark:bg-slate-800',
            child: isMedium
                ? WDiv(
                    className: 'flex flex-row',
                    children: [
                      _buildImagePlaceholder(isWide: false),
                      WDiv(
                        className: 'flex-1',
                        child: _buildCardContent(),
                      ),
                    ],
                  )
                : WDiv(
                    className: 'flex flex-col',
                    children: [
                      _buildImagePlaceholder(isWide: true),
                      _buildCardContent(),
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
                '  className: "flex flex-col md:flex-row",\n'
                '  children: [image, content],\n'
                ')',
                className: 'text-sm font-mono text-pink-400',
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
        ${isActive ? 'bg-white text-rose-600' : 'bg-white/10 text-white/50'}
      ''',
      child: WText(label),
    );
  }

  Widget _buildImagePlaceholder({required bool isWide}) {
    return WDiv(
      className: '''
        ${isWide ? 'w-full h-48' : 'w-48 min-h-48'}
        bg-gradient-to-br from-cyan-400 to-blue-500
        flex items-center justify-center
      ''',
      child: WIcon(
        Icons.image,
        className: 'text-white/50 text-5xl',
      ),
    );
  }

  Widget _buildCardContent() {
    return WDiv(
      className: 'p-4',
      children: [
        WText(
          'Responsive Card Title',
          className: 'text-lg font-bold text-gray-800 dark:text-white',
        ),
        WDiv(className: 'h-2'),
        WText(
          'This card uses flex-col on mobile and md:flex-row on tablet+. '
          'The image takes full width on mobile (w-full) and fixed width on larger screens (md:w-48).',
          className: 'text-sm text-gray-600 dark:text-gray-400',
        ),
        WDiv(className: 'h-4'),
        WDiv(
          className: 'flex flex-wrap gap-2',
          children: [
            _buildTag('flex-col'),
            _buildTag('md:flex-row'),
            _buildTag('w-full'),
            _buildTag('md:w-48'),
          ],
        ),
      ],
    );
  }

  Widget _buildTag(String label) {
    return WDiv(
      className:
          'px-2 py-1 rounded bg-rose-100 dark:bg-rose-900/50 text-rose-600 dark:text-rose-300 text-xs font-mono',
      child: WText(label),
    );
  }
}
