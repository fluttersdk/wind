import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Width Example
/// Demonstrates width utilities: fixed, percentage, fractional, arbitrary
class WidthExamplePage extends StatelessWidget {
  const WidthExamplePage({super.key});

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
              bg-gradient-to-r from-blue-500 to-cyan-500
            ''',
            children: [
              WText(
                'Width Utilities',
                className: 'text-lg font-bold text-white',
              ),
              WText(
                'Control element width',
                className: 'text-sm text-blue-100',
              ),
            ],
          ),

          // Fixed Width
          _buildSection(
            title: 'Fixed Width',
            children: [
              _buildDemo('w-8', 'w-8 h-8 bg-blue-500', '32px'),
              _buildDemo('w-16', 'w-16 h-8 bg-blue-500', '64px'),
              _buildDemo('w-32', 'w-32 h-8 bg-blue-500', '128px'),
              _buildDemo('w-48', 'w-48 h-8 bg-indigo-500', '192px'),
            ],
          ),

          // Fractional Width
          _buildSection(
            title: 'Fractional Width',
            children: [
              _buildFraction('w-1/4', 'w-1/4 h-8 bg-purple-500'),
              _buildFraction('w-1/2', 'w-1/2 h-8 bg-purple-500'),
              _buildFraction('w-3/4', 'w-3/4 h-8 bg-violet-500'),
              _buildFraction('w-full', 'w-full h-8 bg-fuchsia-500'),
            ],
          ),

          // Screen Width
          _buildSection(
            title: 'Screen Width',
            children: [
              WDiv(
                className: 'p-3 rounded-lg bg-gray-100 dark:bg-slate-700',
                child: WText(
                  'w-screen = 100vw (viewport width)',
                  className:
                      'text-sm text-gray-600 dark:text-gray-300 font-mono',
                ),
              ),
            ],
          ),

          // Arbitrary Values
          _buildSection(
            title: 'Arbitrary Values',
            children: [
              _buildDemo('w-[100px]', 'w-[100px] h-8 bg-emerald-500', '100px'),
              _buildFraction('w-[50%]', 'w-[50%] h-8 bg-teal-500'),
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

  Widget _buildDemo(String label, String className, String value) {
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

  Widget _buildFraction(String label, String className) {
    return WDiv(
      className: '$className rounded-lg flex items-center justify-center',
      child: WText(label, className: 'text-white text-xs font-mono'),
    );
  }
}
