import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class BackgroundGradientStopsExamplePage extends StatelessWidget {
  const BackgroundGradientStopsExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'w-full h-full overflow-y-auto p-4 bg-white dark:bg-slate-900',
      scrollPrimary: true,
      child: WDiv(
        className: 'flex flex-col gap-8 max-w-5xl mx-auto',
        children: [
          _buildHeader(),
          _buildThreeStopsSection(),
          _buildStopsShowcase(),
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
          'Gradient Color Stops',
          className: 'text-3xl font-bold text-slate-900 dark:text-white',
        ),
        WText(
          'Utilities for controlling the color stops in background gradients.',
          className: 'text-lg text-slate-600 dark:text-slate-400',
        ),
      ],
    );
  }

  Widget _buildThreeStopsSection() {
    return WDiv(
      className: 'flex flex-col gap-4',
      children: [
        WText(
          'Starting, Ending, and Middle Stops',
          className: 'text-lg font-semibold text-slate-900 dark:text-white',
        ),
        WText(
          'Use from-*, via-*, and to-* utilities to create gradients with three colors.',
          className: 'text-sm text-slate-600 dark:text-slate-400',
        ),
        WDiv(
          className:
              'h-48 rounded-xl bg-gradient-to-r from-indigo-500 via-purple-500 to-pink-500 flex items-center justify-center shadow-lg',
          child: WDiv(
            className:
                'bg-white/10 backdrop-blur-md p-4 rounded-lg border border-white/20',
            children: [
              WText(
                'bg-gradient-to-r from-indigo-500 via-purple-500 to-pink-500',
                className:
                    'text-white font-mono text-sm sm:text-base font-bold text-center',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStopsShowcase() {
    return WDiv(
      className: 'flex flex-col gap-4',
      children: [
        WText(
          'More Examples',
          className: 'text-lg font-semibold text-slate-900 dark:text-white',
        ),
        WDiv(
          className: 'grid grid-cols-1 md:grid-cols-2 gap-6',
          children: [
            _buildStopCard(
              'bg-gradient-to-r from-green-400 to-blue-500',
              'Two Colors (Default)',
              'from-green-400 to-blue-500',
            ),
            _buildStopCard(
              'bg-gradient-to-r from-green-400 via-yellow-500 to-blue-500',
              'Three Colors (With via)',
              'from-green-400 via-yellow-500 to-blue-500',
            ),
            _buildStopCard(
              'bg-gradient-to-r from-red-500 via-orange-500 to-yellow-500',
              'Sunset Gradient',
              'from-red-500 via-orange-500 to-yellow-500',
            ),
            _buildStopCard(
              'bg-gradient-to-r from-slate-900 via-purple-900 to-slate-900',
              'Deep Space',
              'from-slate-900 via-purple-900 to-slate-900',
            ),
            _buildStopCard(
              'bg-gradient-to-r from-pink-300 via-purple-300 to-indigo-400',
              'Pastel Dreams',
              'from-pink-300 via-purple-300 to-indigo-400',
            ),
            _buildStopCard(
              'bg-gradient-to-b from-transparent via-black/50 to-black',
              'Overlay Gradient',
              'from-transparent via-black/50 to-black',
              darkBg: false, // Show on checkerboard if possible, or just gray
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStopCard(String className, String title, String code,
      {bool darkBg = true}) {
    return WDiv(
      className:
          'flex flex-col rounded-xl overflow-hidden shadow-sm border border-slate-200 dark:border-slate-700',
      children: [
        WDiv(
          className: '$className h-32 w-full flex items-center justify-center',
        ),
        WDiv(
          className:
              'w-full p-4 bg-white dark:bg-slate-800 flex flex-col gap-1',
          children: [
            WText(
              title,
              className: 'text-sm font-semibold text-slate-900 dark:text-white',
            ),
            WText(
              code,
              className:
                  'text-xs font-mono text-slate-500 dark:text-slate-400 break-all',
            ),
          ],
        ),
      ],
    );
  }
}
