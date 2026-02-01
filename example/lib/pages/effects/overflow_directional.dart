import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Overflow Directional Example
/// Demonstrates axis-specific overflow: overflow-x-*, overflow-y-*
class OverflowDirectionalExamplePage extends StatelessWidget {
  const OverflowDirectionalExamplePage({super.key});

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
              bg-gradient-to-r from-cyan-500 to-blue-500
            ''',
            children: [
              WText(
                'Directional Overflow',
                className: 'text-lg font-bold text-white',
              ),
              WText(
                'Control overflow per axis',
                className: 'text-sm text-cyan-100',
              ),
            ],
          ),

          // overflow-x-scroll
          _buildSection(
            title: 'overflow-x-scroll',
            description: 'Horizontal scroll only',
            children: [
              WDiv(
                className: 'p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
                child: WDiv(
                  className:
                      'overflow-x-scroll w-48 h-20 bg-purple-500 rounded-lg',
                  child: WDiv(
                    className:
                        'w-96 h-20 bg-purple-300 flex items-center justify-center',
                    child: WText(
                      'Wide content (384px)',
                      className: 'text-purple-900 font-mono text-sm',
                    ),
                  ),
                ),
              ),
              WText(
                'Container is 192px wide, content is 384px → horizontal scroll',
                className: 'text-xs text-gray-500 mt-1',
              ),
            ],
          ),

          // overflow-y-scroll
          _buildSection(
            title: 'overflow-y-scroll',
            description: 'Vertical scroll only',
            children: [
              WDiv(
                className: 'p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
                child: WDiv(
                  className:
                      'overflow-y-scroll w-48 h-24 bg-teal-500 rounded-lg',
                  child: WDiv(
                    className:
                        'w-48 h-64 bg-teal-300 flex items-center justify-center',
                    child: WText(
                      'Tall content (256px)',
                      className: 'text-teal-900 font-mono text-sm',
                    ),
                  ),
                ),
              ),
              WText(
                'Container is 96px tall, content is 256px → vertical scroll',
                className: 'text-xs text-gray-500 mt-1',
              ),
            ],
          ),

          // overflow-x-hidden
          _buildSection(
            title: 'overflow-x-hidden',
            description: 'Clip horizontal overflow',
            children: [
              WDiv(
                className: 'p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
                child: WDiv(
                  className:
                      'overflow-x-hidden w-48 h-20 bg-orange-500 rounded-lg',
                  child: WDiv(
                    className:
                        'w-96 h-20 bg-orange-300 flex items-center justify-center',
                    child: WText(
                      'Wide content (384px)',
                      className: 'text-orange-900 font-mono text-sm',
                    ),
                  ),
                ),
              ),
              WText(
                'Container is 192px wide, content is 384px → clipped horizontally',
                className: 'text-xs text-gray-500 mt-1',
              ),
            ],
          ),

          // overflow-y-hidden
          _buildSection(
            title: 'overflow-y-hidden',
            description: 'Clip vertical overflow',
            children: [
              WDiv(
                className: 'p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
                child: WDiv(
                  className:
                      'overflow-y-hidden w-48 h-24 bg-pink-500 rounded-lg',
                  child: WDiv(
                    className:
                        'w-48 h-64 bg-pink-300 flex items-center justify-center',
                    child: WText(
                      'Tall content (256px)',
                      className: 'text-pink-900 font-mono text-sm',
                    ),
                  ),
                ),
              ),
              WText(
                'Container is 96px tall, content is 256px → clipped vertically',
                className: 'text-xs text-gray-500 mt-1',
              ),
            ],
          ),

          // Reference Table
          WDiv(
            className: 'p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
            children: [
              WText(
                'Directional Classes',
                className: 'font-semibold text-gray-800 dark:text-white mb-2',
              ),
              WDiv(
                className: 'flex flex-col gap-1',
                children: [
                  _buildRefRow('overflow-x-scroll', 'Horizontal scroll'),
                  _buildRefRow('overflow-y-scroll', 'Vertical scroll'),
                  _buildRefRow('overflow-x-hidden', 'Clip horizontal'),
                  _buildRefRow('overflow-y-hidden', 'Clip vertical'),
                  _buildRefRow('overflow-x-auto', 'Horizontal auto'),
                  _buildRefRow('overflow-y-auto', 'Vertical auto'),
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
              'font-mono text-sm text-indigo-600 dark:text-indigo-400 w-40',
        ),
        WText(
          description,
          className: 'text-sm text-gray-600 dark:text-gray-300',
        ),
      ],
    );
  }
}
