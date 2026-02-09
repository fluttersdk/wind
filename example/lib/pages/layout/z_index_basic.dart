import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class ZIndexBasicExamplePage extends StatelessWidget {
  const ZIndexBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'w-full h-full overflow-y-auto p-4',
      scrollPrimary: true,
      child: WDiv(
        className: 'flex flex-col gap-6 max-w-4xl mx-auto',
        children: [
          // Header
          WDiv(
            className:
                'bg-gradient-to-r from-purple-500 to-indigo-600 rounded-xl p-6 shadow-lg',
            children: [
              WText('Z-Index Basic',
                  className: 'text-2xl font-bold text-white'),
              WText(
                'Control stacking order with z-* utilities',
                className: 'text-white/80 mt-2',
              ),
            ],
          ),

          // Description
          WDiv(
            className:
                'p-4 bg-blue-50 dark:bg-blue-900/20 rounded-lg border border-blue-100 dark:border-blue-800',
            child: WText(
              'Use z-index utilities to control the vertical stacking order of elements. These utilities only affect elements within a Stack widget.',
              className: 'text-sm text-blue-800 dark:text-blue-200',
            ),
          ),

          // Demo 1: Basic Overlap
          _buildSection(
            title: 'Basic Stacking',
            description:
                'Elements with higher z-index values appear on top of those with lower values.',
            child: WDiv(
              className:
                  'p-8 bg-gray-100 dark:bg-slate-800 rounded-xl border border-gray-200 dark:border-slate-700',
              child: SizedBox(
                height: 200,
                child: Stack(
                  children: [
                    // Base Layer (z-10)
                    Positioned(
                      top: 0,
                      left: 0,
                      child: WDiv(
                        className:
                            'z-10 w-32 h-32 bg-blue-500 rounded-xl shadow-md flex items-center justify-center',
                        child: WText('z-10',
                            className: 'text-white font-bold text-xl'),
                      ),
                    ),
                    // Middle Layer (z-20)
                    Positioned(
                      top: 40,
                      left: 40,
                      child: WDiv(
                        className:
                            'z-20 w-32 h-32 bg-emerald-500 rounded-xl shadow-md flex items-center justify-center',
                        child: WText('z-20',
                            className: 'text-white font-bold text-xl'),
                      ),
                    ),
                    // Top Layer (z-30)
                    Positioned(
                      top: 80,
                      left: 80,
                      child: WDiv(
                        className:
                            'z-30 w-32 h-32 bg-rose-500 rounded-xl shadow-md flex items-center justify-center',
                        child: WText('z-30',
                            className: 'text-white font-bold text-xl'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Demo 2: Reverse Order
          _buildSection(
            title: 'Layering Context',
            description:
                'Even if defined earlier in the code, a higher z-index brings the element forward.',
            child: WDiv(
              className:
                  'p-8 bg-gray-100 dark:bg-slate-800 rounded-xl border border-gray-200 dark:border-slate-700',
              child: SizedBox(
                height: 200,
                child: Stack(
                  children: [
                    // Defined First but Highest Z-Index
                    Positioned(
                      top: 80,
                      left: 80,
                      child: WDiv(
                        className:
                            'z-50 w-32 h-32 bg-amber-500 rounded-xl shadow-md flex items-center justify-center border-4 border-white dark:border-slate-800',
                        child: WText('z-50',
                            className: 'text-white font-bold text-xl'),
                      ),
                    ),
                    // Defined Second
                    Positioned(
                      top: 40,
                      left: 40,
                      child: WDiv(
                        className:
                            'z-20 w-32 h-32 bg-purple-500 rounded-xl shadow-md flex items-center justify-center',
                        child: WText('z-20',
                            className: 'text-white font-bold text-xl'),
                      ),
                    ),
                    // Defined Last but Lowest Z-Index
                    Positioned(
                      top: 0,
                      left: 0,
                      child: WDiv(
                        className:
                            'z-0 w-32 h-32 bg-gray-500 rounded-xl shadow-md flex items-center justify-center',
                        child: WText('z-0',
                            className: 'text-white font-bold text-xl'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
          className: 'flex flex-col gap-1',
          children: [
            WText(title,
                className: 'text-lg font-bold text-slate-900 dark:text-white'),
            WText(description,
                className: 'text-sm text-slate-500 dark:text-slate-400'),
          ],
        ),
        child,
      ],
    );
  }
}
