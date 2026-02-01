import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Aspect Ratio Example
/// Demonstrates aspect ratio utilities: aspect-square, aspect-video, aspect-[custom]
class AspectRatioExamplePage extends StatelessWidget {
  const AspectRatioExamplePage({super.key});

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
              bg-gradient-to-r from-violet-500 to-purple-500
            ''',
            children: [
              WText('Aspect Ratio', className: 'text-lg font-bold text-white'),
              WText(
                'Control the aspect ratio of elements',
                className: 'text-sm text-violet-100',
              ),
            ],
          ),

          // Square
          _buildSection(
            title: 'aspect-square',
            description: 'Square aspect ratio (1:1)',
            children: [
              WDiv(
                className:
                    'w-32 aspect-square bg-blue-500 rounded-lg flex items-center justify-center',
                child: WText('1:1', className: 'text-white font-bold'),
              ),
            ],
          ),

          // Video
          _buildSection(
            title: 'aspect-video',
            description: 'Video aspect ratio (16:9)',
            children: [
              WDiv(
                className:
                    'w-64 aspect-video bg-red-500 rounded-lg flex items-center justify-center',
                child: WText('16:9', className: 'text-white font-bold'),
              ),
            ],
          ),

          // Auto
          _buildSection(
            title: 'aspect-auto',
            description: 'No aspect ratio constraint',
            children: [
              WDiv(
                className:
                    'w-32 h-24 aspect-auto bg-green-500 rounded-lg flex items-center justify-center',
                child: WText('auto', className: 'text-white font-bold'),
              ),
            ],
          ),

          // Arbitrary Values
          _buildSection(
            title: 'Arbitrary Values',
            description: 'Custom aspect ratios with bracket notation',
            children: [
              WDiv(
                className: 'flex flex-wrap gap-4 overflow-x-auto',
                children: [
                  _buildAspectBox('aspect-[4/3]', '4:3', 'purple', 120),
                  _buildAspectBox('aspect-[21/9]', '21:9', 'orange', 160),
                  _buildAspectBox('aspect-[3/2]', '3:2', 'teal', 120),
                  _buildAspectBox('aspect-[9/16]', '9:16', 'pink', 80),
                ],
              ),
            ],
          ),

          // Use Cases
          _buildSection(
            title: 'Common Use Cases',
            description: 'Practical examples',
            children: [
              WDiv(
                className: 'grid grid-cols-2 gap-4',
                children: [
                  // Image placeholder
                  WDiv(
                    className: 'flex flex-col gap-2',
                    children: [
                      WText(
                        'Image Card',
                        className:
                            'text-sm font-medium text-gray-600 dark:text-gray-300',
                      ),
                      WDiv(
                        className:
                            'w-full aspect-video bg-gradient-to-br from-indigo-400 to-purple-500 rounded-lg flex items-center justify-center',
                        child: WText('📷', className: 'text-3xl'),
                      ),
                    ],
                  ),
                  // Avatar
                  WDiv(
                    className: 'flex flex-col gap-2',
                    children: [
                      WText(
                        'Avatar',
                        className:
                            'text-sm font-medium text-gray-600 dark:text-gray-300',
                      ),
                      WDiv(
                        className:
                            'w-20 aspect-square bg-gradient-to-br from-emerald-400 to-cyan-500 rounded-full flex items-center justify-center',
                        child: WText('👤', className: 'text-2xl'),
                      ),
                    ],
                  ),
                ],
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
                  _buildRefRow('aspect-square', '1:1'),
                  _buildRefRow('aspect-video', '16:9'),
                  _buildRefRow('aspect-auto', 'none'),
                  _buildRefRow('aspect-[4/3]', '4:3'),
                  _buildRefRow('aspect-[21/9]', '21:9'),
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

  Widget _buildAspectBox(
    String aspectClass,
    String label,
    String color,
    double width,
  ) {
    return WDiv(
      className: 'flex flex-col items-center gap-2',
      children: [
        WText(label, className: 'text-xs font-mono text-gray-500'),
        SizedBox(
          width: width,
          child: WDiv(
            className:
                '$aspectClass bg-$color-500 rounded-lg flex items-center justify-center',
            child: WText(label, className: 'text-white font-bold text-sm'),
          ),
        ),
      ],
    );
  }

  Widget _buildRefRow(String className, String value) {
    return WDiv(
      className: 'flex gap-4',
      children: [
        WText(
          className,
          className:
              'font-mono text-sm text-indigo-600 dark:text-indigo-400 w-32',
        ),
        WText(value, className: 'text-sm text-gray-600 dark:text-gray-300'),
      ],
    );
  }
}
