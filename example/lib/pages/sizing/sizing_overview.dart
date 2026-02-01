import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Sizing Overview Example
/// Demonstrates width, height, min/max constraints
class SizingOverviewExamplePage extends StatelessWidget {
  const SizingOverviewExamplePage({super.key});

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
              bg-gradient-to-r from-sky-500 to-blue-500
            ''',
            children: [
              WText(
                'Sizing Utilities',
                className: 'text-lg font-bold text-white',
              ),
              WText(
                'Width, Height, and Constraints',
                className: 'text-sm text-sky-100',
              ),
            ],
          ),

          // Width Examples
          _buildSection(
            title: 'Width',
            children: [
              _buildWidthDemo('w-16', 'w-16 h-10 bg-blue-500', '64px'),
              _buildWidthDemo('w-32', 'w-32 h-10 bg-blue-500', '128px'),
              _buildWidthDemo('w-48', 'w-48 h-10 bg-indigo-500', '192px'),
            ],
          ),

          // Fractional Widths
          _buildSection(
            title: 'Fractional Widths',
            children: [
              WDiv(
                className: 'flex flex-col gap-2',
                children: [
                  _buildFractionDemo('w-1/4', 'w-1/4 h-8 bg-rose-500'),
                  _buildFractionDemo('w-1/2', 'w-1/2 h-8 bg-rose-500'),
                  _buildFractionDemo('w-3/4', 'w-3/4 h-8 bg-rose-500'),
                  _buildFractionDemo('w-full', 'w-full h-8 bg-violet-500'),
                ],
              ),
            ],
          ),

          // Height Examples
          _buildSection(
            title: 'Height',
            children: [
              WDiv(
                className: 'flex gap-3 items-end',
                children: [
                  _buildHeightDemo('h-8', 'h-8 w-14 bg-emerald-500', '32px'),
                  _buildHeightDemo('h-12', 'h-12 w-14 bg-emerald-500', '48px'),
                  _buildHeightDemo('h-16', 'h-16 w-14 bg-teal-500', '64px'),
                  _buildHeightDemo('h-24', 'h-24 w-14 bg-cyan-500', '96px'),
                ],
              ),
            ],
          ),

          // Max-Width Examples (constrained to parent)
          _buildSection(
            title: 'Max-Width',
            children: [
              WDiv(
                className: 'flex flex-col gap-2',
                children: [
                  _buildConstrainedMaxWidth('max-w-xs', '320px'),
                  _buildConstrainedMaxWidth('max-w-sm', '384px'),
                ],
              ),
              WText(
                'Larger sizes: max-w-md (448px), max-w-lg (512px), max-w-xl (576px)...',
                className: 'text-xs text-gray-500 dark:text-gray-400 mt-2',
              ),
            ],
          ),

          // Min Width/Height
          _buildSection(
            title: 'Min Constraints',
            children: [
              WDiv(
                className: 'flex flex-col gap-2',
                children: [
                  WDiv(
                    className:
                        'min-w-32 h-10 bg-amber-500 rounded-lg px-3 flex items-center',
                    child: WText(
                      'min-w-32 (128px min)',
                      className: 'text-white text-xs font-mono',
                    ),
                  ),
                  WDiv(
                    className: 'min-h-12 bg-orange-500 rounded-lg px-3 py-2',
                    child: WText(
                      'min-h-12 (48px min)',
                      className: 'text-white text-xs font-mono',
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Arbitrary Values
          _buildSection(
            title: 'Arbitrary Values',
            children: [
              WDiv(
                className: 'flex flex-col gap-2',
                children: [
                  WDiv(
                    className:
                        'w-[100px] h-10 bg-purple-500 rounded-lg flex items-center justify-center',
                    child: WText(
                      'w-[100px]',
                      className: 'text-white text-xs font-mono',
                    ),
                  ),
                  WDiv(
                    className:
                        'w-[50%] h-10 bg-fuchsia-500 rounded-lg flex items-center justify-center',
                    child: WText(
                      'w-[50%]',
                      className: 'text-white text-xs font-mono',
                    ),
                  ),
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
    required List<Widget> children,
  }) {
    return WDiv(
      className: 'flex flex-col gap-3',
      children: [
        WText(
          title,
          className: 'font-bold text-lg text-gray-800 dark:text-white',
        ),
        ...children,
      ],
    );
  }

  Widget _buildWidthDemo(String label, String className, String value) {
    return WDiv(
      className: 'flex items-center gap-3',
      children: [
        WDiv(
          className: '$className rounded-lg flex items-center justify-center',
          child: WText(label, className: 'text-white text-xs font-mono'),
        ),
        WText(value, className: 'text-gray-500 text-sm'),
      ],
    );
  }

  Widget _buildFractionDemo(String label, String className) {
    return WDiv(
      className: '$className rounded-lg flex items-center justify-center',
      child: WText(label, className: 'text-white text-xs font-mono'),
    );
  }

  Widget _buildHeightDemo(String label, String className, String value) {
    return WDiv(
      className: 'flex flex-col items-center gap-1',
      children: [
        WDiv(
          className: '$className rounded-lg flex items-center justify-center',
          child: WText(label, className: 'text-white text-xs font-mono'),
        ),
        WText(value, className: 'text-gray-500 text-xs'),
      ],
    );
  }

  Widget _buildConstrainedMaxWidth(String className, String value) {
    return WDiv(
      className: 'flex items-center gap-3',
      children: [
        WDiv(
          className:
              '$className w-full h-8 bg-purple-500 rounded-lg flex items-center justify-center',
          child: WText(className, className: 'text-white text-xs font-mono'),
        ),
        WText(value, className: 'text-gray-500 text-sm flex-none'),
      ],
    );
  }
}
