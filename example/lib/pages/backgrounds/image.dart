import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Background Image Example
/// Demonstrates background image utilities: url, size, position, repeat
class BackgroundImagePage extends StatelessWidget {
  const BackgroundImagePage({super.key});

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
              bg-gradient-to-r from-indigo-500 to-purple-500
            ''',
            children: [
              WText(
                'Background Image',
                className: 'text-lg font-bold text-white',
              ),
              WText(
                'Images, sizing, positioning and repeat',
                className: 'text-sm text-indigo-100',
              ),
            ],
          ),

          // Image Size
          _buildSection(
            title: 'Image Size',
            description: 'Control how the image fills its container',
            children: [
              WDiv(
                className: 'flex gap-4',
                children: [
                  _buildImageBox('bg-cover', 'Cover'),
                  _buildImageBox('bg-contain', 'Contain'),
                ],
              ),
            ],
          ),

          // Image Position
          _buildSection(
            title: 'Image Position',
            description: 'Control where the image is positioned',
            children: [
              WDiv(
                className: 'flex flex-wrap gap-3 overflow-x-auto',
                children: [
                  _buildPositionBox('bg-top', 'Top'),
                  _buildPositionBox('bg-center', 'Center'),
                  _buildPositionBox('bg-bottom', 'Bottom'),
                  _buildPositionBox('bg-left', 'Left'),
                  _buildPositionBox('bg-right', 'Right'),
                ],
              ),
              WDiv(
                className: 'flex flex-wrap gap-3 mt-3 overflow-x-auto',
                children: [
                  _buildPositionBox('bg-top-left', 'Top Left'),
                  _buildPositionBox('bg-top-right', 'Top Right'),
                  _buildPositionBox('bg-bottom-left', 'Bottom Left'),
                  _buildPositionBox('bg-bottom-right', 'Bottom Right'),
                ],
              ),
            ],
          ),

          // Image Repeat
          _buildSection(
            title: 'Image Repeat',
            description: 'Control how the image repeats',
            children: [
              WDiv(
                className: 'flex gap-4',
                children: [
                  _buildRepeatBox('bg-no-repeat', 'No Repeat'),
                  _buildRepeatBox('bg-repeat', 'Repeat'),
                ],
              ),
              WDiv(
                className: 'flex gap-4 mt-3',
                children: [
                  _buildRepeatBox('bg-repeat-x', 'Repeat X'),
                  _buildRepeatBox('bg-repeat-y', 'Repeat Y'),
                ],
              ),
            ],
          ),

          // Quick Reference
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
                  _buildRefRow('bg-[url(...)]', 'Set background image'),
                  _buildRefRow('bg-cover', 'Scale to cover container'),
                  _buildRefRow('bg-contain', 'Scale to fit container'),
                  _buildRefRow('bg-center', 'Center the image'),
                  _buildRefRow('bg-no-repeat', 'Don\'t repeat image'),
                  _buildRefRow('bg-repeat', 'Repeat in both directions'),
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

  Widget _buildImageBox(String sizeClass, String label) {
    return Expanded(
      child: WDiv(
        className: 'flex flex-col gap-1',
        children: [
          WDiv(
            className: '''
              $sizeClass bg-center bg-no-repeat h-32 rounded-lg border border-gray-300
              bg-[url(https://picsum.photos/200/300)]
            ''',
          ),
          WText(
            label,
            className: 'text-sm font-mono text-gray-600 dark:text-gray-400',
          ),
        ],
      ),
    );
  }

  Widget _buildPositionBox(String position, String label) {
    return WDiv(
      className: 'flex flex-col gap-1',
      children: [
        WDiv(
          className: '''
            $position bg-no-repeat w-20 h-20 rounded-lg border border-gray-300
            bg-[url(https://picsum.photos/50/50)]
          ''',
        ),
        WText(
          label,
          className: 'text-xs font-mono text-gray-600 dark:text-gray-400',
        ),
      ],
    );
  }

  Widget _buildRepeatBox(String repeat, String label) {
    return Expanded(
      child: WDiv(
        className: 'flex flex-col gap-1',
        children: [
          WDiv(
            className: '''
              $repeat bg-left-top h-24 rounded-lg border border-gray-300
              bg-[url(https://picsum.photos/30/30)]
            ''',
          ),
          WText(
            label,
            className: 'text-sm font-mono text-gray-600 dark:text-gray-400',
          ),
        ],
      ),
    );
  }

  Widget _buildRefRow(String className, String description) {
    return WDiv(
      className: 'flex gap-4',
      children: [
        WText(
          className,
          className:
              'font-mono text-sm text-indigo-600 dark:text-indigo-400 w-32',
        ),
        WText(
          description,
          className: 'text-sm text-gray-600 dark:text-gray-300',
        ),
      ],
    );
  }
}
