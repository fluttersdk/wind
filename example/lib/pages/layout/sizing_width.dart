import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class SizingWidthExamplePage extends StatelessWidget {
  const SizingWidthExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className:
          'w-full h-full overflow-y-auto p-4 bg-slate-50 dark:bg-slate-900',
      scrollPrimary: true,
      child: WDiv(
        className: 'flex flex-col gap-6 max-w-4xl mx-auto',
        children: [
          _buildHeader(),
          _buildSection(
            title: 'Fixed Widths',
            child: WDiv(
              className: 'flex flex-col gap-2',
              children: [
                _buildBar('w-4', 'w-4'),
                _buildBar('w-8', 'w-8'),
                _buildBar('w-16', 'w-16'),
                _buildBar('w-24', 'w-24'),
                _buildBar('w-32', 'w-32'),
                _buildBar('w-48', 'w-48'),
                _buildBar('w-64', 'w-64'),
                _buildBar('w-96', 'w-96'),
              ],
            ),
          ),
          _buildSection(
            title: 'Fluid Widths',
            child: WDiv(
              className: 'flex flex-col gap-2 w-full',
              children: [
                _buildBar('w-1/2', 'w-1/2 bg-indigo-500'),
                _buildBar('w-1/3', 'w-1/3 bg-indigo-500'),
                _buildBar('w-2/3', 'w-2/3 bg-indigo-500'),
                _buildBar('w-1/4', 'w-1/4 bg-indigo-500'),
                _buildBar('w-full', 'w-full bg-indigo-600'),
              ],
            ),
          ),
          _buildSection(
            title: 'Arbitrary Widths',
            child: WDiv(
              className: 'flex flex-col gap-2',
              children: [
                _buildBar('w-[50px]', 'w-[50px] bg-pink-500'),
                _buildBar('w-[10%]', 'w-[10%] bg-pink-500'),
                _buildBar('w-[200px]', 'w-[200px] bg-pink-500'),
              ],
            ),
          ),
          _buildSection(
            title: 'Auto Width',
            child: WDiv(
              className: 'flex gap-4 items-start',
              children: [
                WDiv(
                  className: 'w-auto p-4 bg-teal-500 rounded text-white',
                  child: WText('w-auto (hugs content)'),
                ),
                WDiv(
                  className:
                      'w-32 p-4 bg-teal-800 rounded text-white overflow-hidden whitespace-nowrap',
                  child: WText('w-32 (truncated)'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(String label, String widthClass) {
    // Default color if not specified
    String colorClass = widthClass.contains('bg-') ? '' : 'bg-blue-500';

    return WDiv(
      className:
          '$widthClass $colorClass h-8 rounded flex items-center px-2 shadow-sm whitespace-nowrap overflow-hidden',
      child: WText(label, className: 'text-white text-xs font-mono'),
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className:
          'bg-white dark:bg-slate-800 rounded-xl p-6 border-l-4 border-blue-500 shadow-sm',
      child: WText('Width Utilities',
          className: 'text-2xl font-bold text-slate-900 dark:text-white'),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return WDiv(
      className: 'flex flex-col gap-3',
      children: [
        WText(title,
            className:
                'text-lg font-semibold text-slate-800 dark:text-slate-200'),
        child,
      ],
    );
  }
}
