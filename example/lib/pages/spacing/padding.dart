import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Padding Example
/// Demonstrates padding utilities: all sides, axis, individual sides
class PaddingExamplePage extends StatelessWidget {
  const PaddingExamplePage({super.key});

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
              WText(
                'Padding Utilities',
                className: 'text-lg font-bold text-white',
              ),
              WText(
                'Inner spacing of elements',
                className: 'text-sm text-rose-100',
              ),
            ],
          ),

          // All Sides
          _buildSection(
            title: 'All Sides (p-{n})',
            children: [
              _buildPaddingDemo('p-2', 'p-2 bg-rose-500', '8px'),
              _buildPaddingDemo('p-4', 'p-4 bg-rose-500', '16px'),
              _buildPaddingDemo('p-6', 'p-6 bg-pink-500', '24px'),
            ],
          ),

          // Axis Padding
          _buildSection(
            title: 'Axis (px-{n}, py-{n})',
            children: [
              _buildPaddingDemo(
                'px-6',
                'px-6 py-1 bg-purple-500',
                'horizontal',
              ),
              _buildPaddingDemo('py-6', 'py-6 px-2 bg-violet-500', 'vertical'),
            ],
          ),

          // Individual Sides
          _buildSection(
            title: 'Individual Sides',
            children: [
              _buildPaddingDemo('pt-4', 'pt-4 pb-1 px-2 bg-indigo-500', 'top'),
              _buildPaddingDemo('pb-4', 'pb-4 pt-1 px-2 bg-blue-500', 'bottom'),
              _buildPaddingDemo('pl-6', 'pl-6 pr-2 py-1 bg-cyan-500', 'left'),
              _buildPaddingDemo('pr-6', 'pr-6 pl-2 py-1 bg-teal-500', 'right'),
            ],
          ),

          // Arbitrary Values
          _buildSection(
            title: 'Arbitrary Values',
            children: [
              _buildPaddingDemo('p-[10px]', 'p-[10px] bg-amber-500', '10px'),
              _buildPaddingDemo('p-[20px]', 'p-[20px] bg-orange-500', '20px'),
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
      className: 'flex flex-col gap-2',
      children: [
        WText(title, className: 'font-semibold text-gray-800 dark:text-white'),
        ...children,
      ],
    );
  }

  Widget _buildPaddingDemo(String label, String className, String info) {
    return WDiv(
      className: 'flex items-center gap-3',
      children: [
        WDiv(
          className:
              'border-2 border-dashed border-gray-300 dark:border-gray-600 rounded-lg',
          child: WDiv(
            className: '$className rounded-lg',
            child: WText(label, className: 'text-white text-xs font-mono'),
          ),
        ),
        WText(info, className: 'text-gray-500 text-sm'),
      ],
    );
  }
}
