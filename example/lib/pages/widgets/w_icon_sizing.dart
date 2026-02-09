import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class WIconSizingExamplePage extends StatelessWidget {
  const WIconSizingExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'w-full h-full overflow-y-auto p-4',
      scrollPrimary: true,
      child: WDiv(
        className: 'flex flex-col gap-6 max-w-4xl mx-auto',
        children: [
          _buildHeader(),
          _buildSection(
            title: 'Typography Based Sizing',
            description:
                'Icons scale with text-{size} utilities, matching surrounding text.',
            child: WDiv(
              className: 'flex flex-wrap items-end gap-4',
              children: const [
                WIcon(Icons.star, className: 'text-xs text-amber-500'),
                WIcon(Icons.star, className: 'text-sm text-amber-500'),
                WIcon(Icons.star, className: 'text-base text-amber-500'),
                WIcon(Icons.star, className: 'text-lg text-amber-500'),
                WIcon(Icons.star, className: 'text-xl text-amber-500'),
                WIcon(Icons.star, className: 'text-2xl text-amber-500'),
                WIcon(Icons.star, className: 'text-3xl text-amber-500'),
                WIcon(Icons.star, className: 'text-4xl text-amber-500'),
              ],
            ),
          ),
          _buildSection(
            title: 'Explicit Dimensions',
            description: 'Using w-{size} and h-{size} for precise control.',
            child: WDiv(
              className: 'flex items-end gap-4',
              children: const [
                WIcon(Icons.favorite, className: 'w-4 h-4 text-red-500'),
                WIcon(Icons.favorite, className: 'w-8 h-8 text-red-500'),
                WIcon(Icons.favorite, className: 'w-12 h-12 text-red-500'),
                WIcon(Icons.favorite, className: 'w-16 h-16 text-red-500'),
                WIcon(Icons.favorite, className: 'w-20 h-20 text-red-500'),
              ],
            ),
          ),
          _buildSection(
            title: 'Inherited Sizing',
            description:
                'Icons inherit size and color from parent typography context.',
            child: WDiv(
              className: 'flex flex-col gap-4',
              children: [
                WDiv(
                  className: 'text-xl text-blue-500 flex items-center gap-2',
                  children: const [
                    WIcon(Icons.check_circle),
                    WText('Inherits text-xl and blue color'),
                  ],
                ),
                WDiv(
                  className: 'text-sm text-gray-500 flex items-center gap-2',
                  children: const [
                    WIcon(Icons.info),
                    WText('Inherits text-sm and gray color'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className:
          'bg-gradient-to-r from-amber-500 to-orange-600 rounded-xl p-6 shadow-lg',
      child: WDiv(
        className: 'flex flex-col gap-2',
        children: const [
          WText(
            'Icon Sizing',
            className: 'text-2xl font-bold text-white',
          ),
          WText(
            'Control icon sizes using typography scales or explicit dimensions.',
            className: 'text-white/80',
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String description,
    required Widget child,
  }) {
    return WDiv(
      className:
          'flex flex-col gap-4 p-6 bg-white dark:bg-slate-800 rounded-xl shadow-sm border border-gray-100 dark:border-gray-700',
      children: [
        WDiv(
          className: 'flex flex-col gap-1',
          children: [
            WText(title,
                className:
                    'text-lg font-semibold text-slate-900 dark:text-white'),
            WText(description,
                className: 'text-sm text-slate-500 dark:text-slate-400'),
          ],
        ),
        WDiv(
          className:
              'p-4 bg-gray-50 dark:bg-slate-900/50 rounded-lg border border-gray-100 dark:border-gray-700/50',
          child: child,
        ),
      ],
    );
  }
}
