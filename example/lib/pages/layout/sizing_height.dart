import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class SizingHeightExamplePage extends StatelessWidget {
  const SizingHeightExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className:
          'w-full h-full overflow-y-auto p-4 bg-slate-50 dark:bg-slate-900',
      scrollPrimary: true,
      child: WDiv(
        className: 'flex flex-col gap-6 max-w-4xl mx-auto pb-20',
        children: [
          _buildHeader(),
          WDiv(
            className:
                'grid grid-cols-2 md:grid-cols-4 gap-4 items-end h-[400px] overflow-hidden bg-white dark:bg-slate-800 p-4 rounded-xl border border-slate-200 dark:border-slate-700',
            children: [
              _buildCol('h-16', 'h-16'),
              _buildCol('h-24', 'h-24'),
              _buildCol('h-32', 'h-32'),
              _buildCol('h-full', 'h-full bg-orange-500'),
            ],
          ),
          _buildSection(
            title: 'Fractional Heights',
            child: WDiv(
              className:
                  'h-64 flex gap-4 bg-white dark:bg-slate-800 p-4 rounded-xl border border-slate-200 dark:border-slate-700',
              children: [
                _buildCol('h-1/4', 'h-1/4 bg-green-500 w-16'),
                _buildCol('h-1/2', 'h-1/2 bg-green-500 w-16'),
                _buildCol('h-3/4', 'h-3/4 bg-green-500 w-16'),
                _buildCol('h-full', 'h-full bg-green-600 w-16'),
              ],
            ),
          ),
          _buildSection(
            title: 'Viewport Height',
            child: WDiv(
              className:
                  'w-full h-32 bg-purple-100 dark:bg-purple-900/30 rounded flex items-center justify-center border border-dashed border-purple-300',
              child: WText('h-screen (See below)',
                  className: 'text-purple-700 dark:text-purple-300'),
            ),
          ),
          WDiv(
            className:
                'h-screen w-full bg-purple-600 flex items-center justify-center rounded-xl shadow-2xl',
            child: WText('h-screen (100vh)',
                className: 'text-white font-bold text-2xl'),
          ),
        ],
      ),
    );
  }

  Widget _buildCol(String label, String heightClass) {
    String colorClass = heightClass.contains('bg-') ? '' : 'bg-red-500';
    String widthClass = heightClass.contains('w-') ? '' : 'w-full';

    return WDiv(
      className:
          '$heightClass $colorClass $widthClass rounded flex items-end justify-center pb-2 shadow-sm',
      child: WText(label, className: 'text-white text-xs font-mono font-bold'),
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className:
          'bg-white dark:bg-slate-800 rounded-xl p-6 border-l-4 border-red-500 shadow-sm',
      child: WText('Height Utilities',
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
