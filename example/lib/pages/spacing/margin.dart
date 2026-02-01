import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Margin Example
/// Demonstrates margin utilities: all sides, axis, individual sides, mx-auto
class MarginExamplePage extends StatelessWidget {
  const MarginExamplePage({super.key});

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
              bg-gradient-to-r from-amber-500 to-orange-500
            ''',
            children: [
              WText(
                'Margin Utilities',
                className: 'text-lg font-bold text-white',
              ),
              WText(
                'Outer spacing of elements',
                className: 'text-sm text-amber-100',
              ),
            ],
          ),

          // All Sides
          _buildSection(
            title: 'All Sides (m-{n})',
            children: [
              _buildMarginDemo('m-2', 'm-2 bg-amber-500'),
              _buildMarginDemo('m-4', 'm-4 bg-amber-500'),
            ],
          ),

          // Axis Margin
          _buildSection(
            title: 'Axis (mx-{n}, my-{n})',
            children: [
              _buildMarginDemo('mx-6', 'mx-6 bg-orange-500'),
              _buildMarginDemo('my-4', 'my-4 bg-red-500'),
            ],
          ),

          // mx-auto (centering)
          _buildSection(
            title: 'Horizontal Centering (mx-auto)',
            children: [
              WDiv(
                className: 'bg-gray-100 dark:bg-slate-700 rounded-lg p-2',
                children: [
                  WDiv(
                    className:
                        'mx-auto w-32 h-10 bg-emerald-500 rounded-lg flex items-center justify-center',
                    child: WText(
                      'mx-auto',
                      className: 'text-white text-xs font-mono',
                    ),
                  ),
                ],
              ),
              WText(
                'Centers element horizontally within parent',
                className: 'text-xs text-gray-500 dark:text-gray-400',
              ),
            ],
          ),

          // Individual Sides
          _buildSection(
            title: 'Individual Sides',
            children: [
              _buildMarginDemo('mt-4', 'mt-4 bg-blue-500'),
              _buildMarginDemo('mb-4', 'mb-4 bg-indigo-500'),
              _buildMarginDemo('ml-8', 'ml-8 bg-violet-500'),
              _buildMarginDemo('mr-8', 'mr-8 bg-purple-500'),
            ],
          ),

          // Arbitrary Values
          _buildSection(
            title: 'Arbitrary Values',
            children: [_buildMarginDemo('m-[10px]', 'm-[10px] bg-pink-500')],
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
      className: 'flex flex-col gap-2',
      children: [
        WText(title, className: 'font-semibold text-gray-800 dark:text-white'),
        ...children,
      ],
    );
  }

  Widget _buildMarginDemo(String label, String className) {
    return WDiv(
      className: 'bg-gray-100 dark:bg-slate-700 rounded-lg',
      child: WDiv(
        className: '$className rounded-lg px-3 py-2',
        child: WText(label, className: 'text-white text-xs font-mono'),
      ),
    );
  }
}
