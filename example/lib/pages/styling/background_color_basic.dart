import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class BackgroundColorBasicExamplePage extends StatelessWidget {
  const BackgroundColorBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'w-full h-full overflow-y-auto p-4 bg-white dark:bg-slate-900',
      scrollPrimary: true,
      child: WDiv(
        className: 'flex flex-col gap-8 max-w-5xl mx-auto',
        children: [
          _buildHeader(),
          _buildColorSection('Slate', 'slate'),
          _buildColorSection('Gray', 'gray'),
          _buildColorSection('Zinc', 'zinc'),
          _buildColorSection('Neutral', 'neutral'),
          _buildColorSection('Stone', 'stone'),
          _buildColorSection('Red', 'red'),
          _buildColorSection('Orange', 'orange'),
          _buildColorSection('Amber', 'amber'),
          _buildColorSection('Yellow', 'yellow'),
          _buildColorSection('Lime', 'lime'),
          _buildColorSection('Green', 'green'),
          _buildColorSection('Emerald', 'emerald'),
          _buildColorSection('Teal', 'teal'),
          _buildColorSection('Cyan', 'cyan'),
          _buildColorSection('Sky', 'sky'),
          _buildColorSection('Blue', 'blue'),
          _buildColorSection('Indigo', 'indigo'),
          _buildColorSection('Violet', 'violet'),
          _buildColorSection('Purple', 'purple'),
          _buildColorSection('Fuchsia', 'fuchsia'),
          _buildColorSection('Pink', 'pink'),
          _buildColorSection('Rose', 'rose'),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className:
          'flex flex-col gap-2 pb-4 border-b border-slate-200 dark:border-slate-800',
      children: [
        WText(
          'Background Color',
          className: 'text-3xl font-bold text-slate-900 dark:text-white',
        ),
        WText(
          'Utilities for controlling an element\'s background color.',
          className: 'text-lg text-slate-600 dark:text-slate-400',
        ),
      ],
    );
  }

  Widget _buildColorSection(String title, String colorName) {
    final shades = [50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 950];

    return WDiv(
      className: 'flex flex-col gap-3',
      children: [
        WText(
          title,
          className: 'text-lg font-semibold text-slate-900 dark:text-white',
        ),
        WDiv(
          className:
              'grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 xl:grid-cols-11 gap-4',
          children: shades.map((shade) {
            final className = 'bg-$colorName-$shade';
            // Dark text for light backgrounds (50-400), Light text for dark backgrounds (500-950)
            final textColor = shade <= 400 ? 'text-slate-900' : 'text-white';

            return WDiv(
              className:
                  '$className h-24 rounded-lg flex flex-col items-center justify-center p-2 shadow-sm ring-1 ring-inset ring-black/5 dark:ring-white/10',
              children: [
                WText(
                  className,
                  className:
                      '$textColor text-xs font-mono font-medium text-center break-all',
                ),
                WText(
                  '$shade',
                  className: '$textColor text-[10px] opacity-70 mt-1',
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
