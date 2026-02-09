import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Overflow Basic Example
/// Demonstrates overflow utilities: overflow-hidden, overflow-visible, overflow-scroll
class OverflowBasicExamplePage extends StatelessWidget {
  const OverflowBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'w-full h-full overflow-y-auto p-4',
      child: WDiv(
        className: 'flex flex-col gap-6',
        children: [
          // Header
          WDiv(
            className: '''
              w-full p-4 rounded-xl
              bg-gradient-to-r from-rose-500 to-pink-500
            ''',
            children: [
              WText('Overflow', className: 'text-lg font-bold text-white'),
              WText(
                'Control how content overflows its container',
                className: 'text-sm text-rose-100',
              ),
            ],
          ),

          // overflow-visible
          _buildSection(
            title: 'overflow-visible',
            description:
                'Content can overflow outside container bounds (default)',
            children: [
              WDiv(
                className:
                    'p-8 bg-gray-100 dark:bg-slate-800 rounded-lg h-40 flex items-center justify-center',
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Container boundary (visible border)
                    WDiv(
                      className:
                          'w-20 h-20 border-2 border-dashed border-blue-500 rounded-lg',
                    ),
                    // Overflowing content
                    Positioned(
                      top: -16,
                      left: -16,
                      child: WDiv(
                        className:
                            'w-32 h-32 bg-blue-400/80 rounded-lg flex items-center justify-center',
                        child: WText(
                          '128x128',
                          className: 'text-white text-xs font-mono font-bold',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              WText(
                'Container is 80x80 (dashed border), content is 128x128 → content visible outside',
                className: 'text-xs text-gray-500 mt-1',
              ),
            ],
          ),

          // overflow-hidden
          _buildSection(
            title: 'overflow-hidden',
            description: 'Clip content that overflows the container',
            children: [
              WDiv(
                className:
                    'p-8 bg-gray-100 dark:bg-slate-800 rounded-lg h-40 flex items-center justify-center',
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Container boundary (visible border) - same as visible section
                    WDiv(
                      className:
                          'w-20 h-20 border-2 border-dashed border-red-500 rounded-lg',
                    ),
                    // Container with overflow-hidden (clipped content)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        width: 80,
                        height: 80,
                        child: Stack(
                          clipBehavior: Clip.hardEdge,
                          children: [
                            // Overflowing content (will be clipped)
                            Positioned(
                              top: -16,
                              left: -16,
                              child: WDiv(
                                className:
                                    'w-32 h-32 bg-red-500/80 rounded-lg flex items-center justify-center',
                                child: WText(
                                  '128x128',
                                  className:
                                      'text-white text-xs font-mono font-bold',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              WText(
                'Container is 80x80 (dashed border), content is 128x128 → only visible inside container',
                className: 'text-xs text-gray-500 mt-1',
              ),
            ],
          ),

          // overflow-scroll
          _buildSection(
            title: 'overflow-scroll',
            description: 'Enable scrolling for overflow content',
            children: [
              WDiv(
                className: 'p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
                child: WDiv(
                  className: 'flex justify-center',
                  child: WDiv(
                    className:
                        'overflow-scroll w-24 h-24 bg-green-500 rounded-lg',
                    child: WDiv(
                      className:
                          'w-48 h-48 bg-green-300 rounded-lg flex items-center justify-center',
                      child: WText(
                        '192x192',
                        className: 'text-green-900 text-xs font-mono',
                      ),
                    ),
                  ),
                ),
              ),
              WText(
                'Container is 96x96, content is 192x192 → scrollable in both directions',
                className: 'text-xs text-gray-500 mt-1',
              ),
            ],
          ),

          // overflow-auto
          _buildSection(
            title: 'overflow-auto',
            description: 'Auto scrolling (scroll only when needed)',
            children: [
              WDiv(
                className: 'p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
                child: WDiv(
                  className: 'flex justify-center',
                  child: WDiv(
                    className:
                        'overflow-auto w-24 h-24 bg-amber-500 rounded-lg',
                    child: WDiv(
                      className:
                          'w-48 h-48 bg-amber-300 rounded-lg flex items-center justify-center',
                      child: WText(
                        '192x192',
                        className: 'text-amber-900 text-xs font-mono',
                      ),
                    ),
                  ),
                ),
              ),
              WText(
                'Scrollbars appear only when content overflows',
                className: 'text-xs text-gray-500 mt-1',
              ),
            ],
          ),

          // Reference Table
          WDiv(
            className: 'p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
            children: [
              WText(
                'Quick Reference',
                className: 'font-semibold text-gray-800 dark:text-white mb-2',
              ),
              WDiv(
                className: 'flex flex-col gap-1',
                children: [
                  _buildRefRow('overflow-visible', 'Allow overflow (default)'),
                  _buildRefRow('overflow-hidden', 'Clip with ClipRect'),
                  _buildRefRow('overflow-scroll', 'Always scrollable'),
                  _buildRefRow('overflow-auto', 'Scroll when needed'),
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

  Widget _buildRefRow(String className, String description) {
    return WDiv(
      className: 'flex gap-4',
      children: [
        WText(
          className,
          className:
              'font-mono text-sm text-indigo-600 dark:text-indigo-400 w-36',
        ),
        WText(
          description,
          className: 'text-sm text-gray-600 dark:text-gray-300',
        ),
      ],
    );
  }
}
