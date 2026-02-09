import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class TextColorOpacityExamplePage extends StatelessWidget {
  const TextColorOpacityExamplePage({super.key});

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
          _buildOpacitySection(
            title: 'Primary Blue Opacity',
            baseColor: 'text-blue-600',
          ),
          _buildOpacitySection(
            title: 'Alert Red Opacity',
            baseColor: 'text-red-500',
          ),
          _buildOpacitySection(
            title: 'Success Green Opacity',
            baseColor: 'text-green-500',
          ),
          _buildOpacitySection(
            title: 'Black & White Opacity',
            baseColor: 'text-black', // Special handling for white in the method
            altColor: 'text-white',
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className:
          'bg-gradient-to-r from-purple-500 to-pink-600 rounded-xl p-8 shadow-lg',
      children: [
        WText(
          'Text Color Opacity',
          className: 'text-3xl font-bold text-white mb-2',
        ),
        WText(
          'Control the opacity of your text color using the color opacity modifier.',
          className: 'text-purple-100 text-lg',
        ),
      ],
    );
  }

  Widget _buildOpacitySection({
    required String title,
    required String baseColor,
    String? altColor,
  }) {
    final opacities = [100, 90, 80, 75, 70, 60, 50, 40, 30, 25, 20, 10, 5, 0];

    return WDiv(
      className:
          'flex flex-col gap-4 p-6 bg-white dark:bg-slate-900 rounded-xl shadow-sm border border-slate-200 dark:border-slate-800',
      children: [
        WText(title,
            className: 'text-xl font-bold text-slate-900 dark:text-white mb-2'),
        WDiv(
          className: 'flex flex-col gap-0',
          children: [
            ...opacities.map((opacity) {
              final colorClass =
                  opacity == 100 ? baseColor : '$baseColor/$opacity';
              return _buildOpacityRow(colorClass, opacity, false);
            }),
            if (altColor != null)
              ...opacities.map((opacity) {
                final colorClass =
                    opacity == 100 ? altColor : '$altColor/$opacity';
                return _buildOpacityRow(colorClass, opacity, true);
              }),
          ],
        ),
      ],
    );
  }

  Widget _buildOpacityRow(String colorClass, int opacity, bool isDarkBg) {
    // For white/light colors, we force a dark background
    // For black/dark colors, we use light background
    // Unless specifically requested via isDarkBg

    final bgClass = isDarkBg || colorClass.contains('text-white')
        ? 'bg-slate-800 dark:bg-slate-950'
        : 'bg-slate-50 dark:bg-slate-100';

    final labelColor = isDarkBg || colorClass.contains('text-white')
        ? 'text-slate-400'
        : 'text-slate-500';

    return WDiv(
      className:
          'flex flex-row items-center justify-between p-4 $bgClass border-b border-slate-100 dark:border-slate-800 last:border-0',
      children: [
        WText(
          'The quick brown fox jumps over the lazy dog.',
          className: 'text-lg font-medium $colorClass',
        ),
        WDiv(
          className: 'flex flex-col items-end',
          children: [
            WText(
              colorClass,
              className: 'text-xs font-mono font-bold $labelColor',
            ),
            WText(
              'Opacity $opacity%',
              className: 'text-[10px] $labelColor',
            ),
          ],
        ),
      ],
    );
  }
}
