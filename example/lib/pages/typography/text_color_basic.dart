import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class TextColorBasicExamplePage extends StatelessWidget {
  const TextColorBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className:
          'w-full h-full overflow-y-auto bg-slate-50 dark:bg-slate-950 p-4',
      scrollPrimary: true,
      child: WDiv(
        className: 'flex flex-col gap-6 max-w-4xl mx-auto',
        children: [
          _buildHeader(),
          _buildColorSection(
            title: 'Slate',
            colors: [
              'text-slate-50',
              'text-slate-100',
              'text-slate-200',
              'text-slate-300',
              'text-slate-400',
              'text-slate-500',
              'text-slate-600',
              'text-slate-700',
              'text-slate-800',
              'text-slate-900',
              'text-slate-950',
            ],
          ),
          _buildColorSection(
            title: 'Red',
            colors: [
              'text-red-50',
              'text-red-100',
              'text-red-200',
              'text-red-300',
              'text-red-400',
              'text-red-500',
              'text-red-600',
              'text-red-700',
              'text-red-800',
              'text-red-900',
              'text-red-950',
            ],
          ),
          _buildColorSection(
            title: 'Blue',
            colors: [
              'text-blue-50',
              'text-blue-100',
              'text-blue-200',
              'text-blue-300',
              'text-blue-400',
              'text-blue-500',
              'text-blue-600',
              'text-blue-700',
              'text-blue-800',
              'text-blue-900',
              'text-blue-950',
            ],
          ),
          _buildColorSection(
            title: 'Green',
            colors: [
              'text-green-50',
              'text-green-100',
              'text-green-200',
              'text-green-300',
              'text-green-400',
              'text-green-500',
              'text-green-600',
              'text-green-700',
              'text-green-800',
              'text-green-900',
              'text-green-950',
            ],
          ),
          _buildColorSection(
            title: 'Special',
            colors: [
              'text-white',
              'text-black',
              'text-transparent',
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className:
          'bg-gradient-to-r from-blue-500 to-indigo-600 rounded-xl p-8 shadow-lg',
      children: [
        WText(
          'Text Color Basics',
          className: 'text-3xl font-bold text-white mb-2',
        ),
        WText(
          'Control the text color of an element using the text-{color}-{shade} utilities.',
          className: 'text-blue-100 text-lg',
        ),
      ],
    );
  }

  Widget _buildColorSection({
    required String title,
    required List<String> colors,
  }) {
    return WDiv(
      className:
          'flex flex-col gap-4 p-6 bg-white dark:bg-slate-900 rounded-xl shadow-sm border border-slate-200 dark:border-slate-800',
      children: [
        WText(title,
            className: 'text-xl font-bold text-slate-900 dark:text-white mb-2'),
        WDiv(
          className: 'grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-4',
          children:
              colors.map((colorClass) => _buildColorCard(colorClass)).toList(),
        ),
      ],
    );
  }

  Widget _buildColorCard(String colorClass) {
    // For very light text colors, we need a dark background to see them.
    // For very dark text colors, we need a light background.
    // We'll use a neutral background that contrasts reasonably well,
    // or toggle based on the brightness of the text color class (simplified logic).

    // Simple heuristic: 50-400 are light (need dark bg), 500-950 are dark (need light bg).
    // transparent/black/white are special.

    bool isLightColor = colorClass.contains('-50') ||
        colorClass.contains('-100') ||
        colorClass.contains('-200') ||
        colorClass.contains('-300') ||
        colorClass.contains('-400') ||
        colorClass.contains('white') ||
        colorClass.contains('transparent');

    String bgClass = isLightColor ? 'bg-slate-900' : 'bg-slate-100';
    if (colorClass.contains('text-slate-900') ||
        colorClass.contains('text-black')) {
      bgClass = 'bg-slate-100';
    }

    return WDiv(
      className:
          'flex flex-col items-center justify-center p-4 rounded-lg $bgClass border border-slate-200 dark:border-slate-700',
      children: [
        WText(
          'Quick Brown Fox',
          className: 'text-lg font-bold $colorClass mb-2',
        ),
        WText(
          colorClass,
          className: 'text-xs font-mono text-slate-500 dark:text-slate-400',
        ),
      ],
    );
  }
}
