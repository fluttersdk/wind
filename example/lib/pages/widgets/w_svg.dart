import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class WSvgExamplePage extends StatelessWidget {
  const WSvgExamplePage({super.key});

  // Simple star SVG string for demo
  static const String starSvg = '''
<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M12 2L15.09 8.26L22 9.27L17 14.14L18.18 21.02L12 17.77L5.82 21.02L7 14.14L2 9.27L8.91 8.26L12 2Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';

  // Circle SVG string
  static const String circleSvg = '''
<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
<circle cx="12" cy="12" r="10" />
</svg>
''';

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className:
          'w-full h-full overflow-y-auto p-4 bg-gray-50 dark:bg-gray-900',
      scrollPrimary: true,
      child: WDiv(
        className: 'flex flex-col gap-6 max-w-4xl mx-auto',
        children: [
          _buildHeader(),
          _buildSection(
            title: 'Basic Usage (String Source)',
            description:
                'Rendering SVGs from string with basic sizing and coloring.',
            child: WDiv(
              className:
                  'flex flex-wrap gap-6 p-6 bg-white dark:bg-slate-800 rounded-xl shadow-sm',
              children: [
                WDiv(
                  className: 'flex flex-col items-center gap-2',
                  children: [
                    WSvg.string(starSvg, className: 'w-10 h-10 text-blue-500'),
                    WText('text-blue-500', className: 'text-xs font-mono'),
                  ],
                ),
                WDiv(
                  className: 'flex flex-col items-center gap-2',
                  children: [
                    WSvg.string(starSvg,
                        className: 'w-10 h-10 text-orange-500'),
                    WText('text-orange-500', className: 'text-xs font-mono'),
                  ],
                ),
                WDiv(
                  className: 'flex flex-col items-center gap-2',
                  children: [
                    WSvg.string(circleSvg,
                        className: 'w-10 h-10 fill-green-500'),
                    WText('fill-green-500', className: 'text-xs font-mono'),
                  ],
                ),
              ],
            ),
          ),
          _buildSection(
            title: 'Interactive States',
            description: 'SVGs responding to hover and focus states.',
            child: WDiv(
              className:
                  'flex flex-wrap gap-6 p-6 bg-white dark:bg-slate-800 rounded-xl shadow-sm',
              children: [
                WDiv(
                  className:
                      'group flex flex-col items-center gap-2 cursor-pointer',
                  children: [
                    WSvg.string(
                      starSvg,
                      className:
                          'w-12 h-12 text-gray-400 hover:text-yellow-400 transition-all duration-300',
                    ),
                    WText('Hover Me', className: 'text-xs text-gray-500'),
                  ],
                ),
              ],
            ),
          ),
          _buildSection(
            title: 'Sizing & Animation',
            description: 'Using Tailwind sizing classes and animate-spin.',
            child: WDiv(
              className:
                  'flex flex-wrap items-center gap-8 p-6 bg-white dark:bg-slate-800 rounded-xl shadow-sm',
              children: [
                WDiv(
                  className: 'flex flex-col items-center gap-2',
                  children: [
                    WSvg.string(starSvg, className: 'w-8 h-8 text-purple-500'),
                    WText('w-8 h-8', className: 'text-xs font-mono'),
                  ],
                ),
                WDiv(
                  className: 'flex flex-col items-center gap-2',
                  children: [
                    WSvg.string(starSvg,
                        className: 'w-16 h-16 text-purple-500'),
                    WText('w-16 h-16', className: 'text-xs font-mono'),
                  ],
                ),
                WDiv(
                  className: 'flex flex-col items-center gap-2',
                  children: [
                    WDiv(
                      className: 'animate-spin',
                      child: WSvg.string(
                        '''<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="5"/><path d="M12 1v2M12 21v2M4.22 4.22l1.42 1.42M18.36 18.36l1.42 1.42M1 12h2M21 12h2M4.22 19.78l1.42-1.42M18.36 5.64l1.42-1.42"/></svg>''',
                        className: 'w-12 h-12 text-amber-500',
                      ),
                    ),
                    WText('animate-spin', className: 'text-xs font-mono'),
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
          'bg-gradient-to-r from-orange-500 to-red-600 rounded-xl p-6 shadow-lg',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WText(
            'WSvg Widgets',
            className: 'text-2xl font-bold text-white mb-2',
          ),
          WText(
            'Render Scalable Vector Graphics with Tailwind utility styling.',
            className: 'text-orange-100',
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
      className: 'flex flex-col gap-4',
      children: [
        WDiv(
          className: 'flex flex-col',
          children: [
            WText(title,
                className:
                    'text-lg font-semibold text-slate-900 dark:text-white'),
            WText(description,
                className: 'text-sm text-slate-600 dark:text-slate-400'),
          ],
        ),
        child,
      ],
    );
  }
}
