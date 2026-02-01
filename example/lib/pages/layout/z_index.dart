import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Z-Index Example
/// Demonstrates z-index utilities within Stack widgets
class ZIndexExamplePage extends StatelessWidget {
  const ZIndexExamplePage({super.key});

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
              bg-gradient-to-r from-slate-700 to-slate-900
            ''',
            children: [
              WText('Z-Index', className: 'text-lg font-bold text-white'),
              WText(
                'Control stacking order in Stack widgets',
                className: 'text-sm text-slate-300',
              ),
            ],
          ),

          // Important Note
          WDiv(
            className:
                'p-4 bg-amber-100 dark:bg-amber-900/30 rounded-lg border border-amber-300 dark:border-amber-700',
            child: WText(
              '⚠️ Z-index only works inside Stack widgets. Flutter determines layer order by child position in the list.',
              className: 'text-sm text-amber-800 dark:text-amber-200',
            ),
          ),

          // Basic Stack
          _buildSection(
            title: 'Basic Z-Index',
            description: 'Higher z-index values appear on top',
            children: [
              WDiv(
                className: 'p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
                child: SizedBox(
                  height: 150,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: WDiv(
                          className:
                              'z-10 w-24 h-24 bg-blue-500 rounded-lg flex items-center justify-center',
                          child: WText(
                            'z-10',
                            className: 'text-white font-bold',
                          ),
                        ),
                      ),
                      Positioned(
                        left: 40,
                        top: 30,
                        child: WDiv(
                          className:
                              'z-20 w-24 h-24 bg-red-500 rounded-lg flex items-center justify-center',
                          child: WText(
                            'z-20',
                            className: 'text-white font-bold',
                          ),
                        ),
                      ),
                      Positioned(
                        left: 80,
                        top: 60,
                        child: WDiv(
                          className:
                              'z-30 w-24 h-24 bg-green-500 rounded-lg flex items-center justify-center',
                          child: WText(
                            'z-30',
                            className: 'text-white font-bold',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              WText(
                'Green (z-30) appears on top, then red (z-20), then blue (z-10)',
                className: 'text-xs text-gray-500 mt-1',
              ),
            ],
          ),

          // Preset Values
          _buildSection(
            title: 'Preset Values',
            description: 'Standard z-index values from theme',
            children: [
              WDiv(
                className: 'flex flex-wrap gap-2 overflow-x-auto',
                children: [
                  _buildZIndexChip('z-0', '0'),
                  _buildZIndexChip('z-10', '10'),
                  _buildZIndexChip('z-20', '20'),
                  _buildZIndexChip('z-30', '30'),
                  _buildZIndexChip('z-40', '40'),
                  _buildZIndexChip('z-50', '50'),
                ],
              ),
            ],
          ),

          // Arbitrary Values
          _buildSection(
            title: 'Arbitrary Values',
            description: 'Custom z-index with bracket notation',
            children: [
              WDiv(
                className: 'flex flex-wrap gap-2 overflow-x-auto',
                children: [
                  _buildZIndexChip('z-[100]', '100'),
                  _buildZIndexChip('z-[1000]', '1000'),
                  _buildZIndexChip('z-[-1]', '-1'),
                ],
              ),
            ],
          ),

          // Overlapping Cards Example
          _buildSection(
            title: 'Overlapping Cards',
            description: 'Practical example with card stack',
            children: [
              WDiv(
                className: 'p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
                child: SizedBox(
                  height: 180,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: WDiv(
                          className:
                              'z-10 w-48 p-4 bg-white dark:bg-slate-700 rounded-xl shadow-lg',
                          children: [
                            WText(
                              'Card 1',
                              className:
                                  'font-bold text-gray-800 dark:text-white',
                            ),
                            WText('z-10', className: 'text-sm text-gray-500'),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 30,
                        top: 30,
                        child: WDiv(
                          className:
                              'z-20 w-48 p-4 bg-white dark:bg-slate-700 rounded-xl shadow-lg',
                          children: [
                            WText(
                              'Card 2',
                              className:
                                  'font-bold text-gray-800 dark:text-white',
                            ),
                            WText('z-20', className: 'text-sm text-gray-500'),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 60,
                        top: 60,
                        child: WDiv(
                          className:
                              'z-30 w-48 p-4 bg-white dark:bg-slate-700 rounded-xl shadow-lg',
                          children: [
                            WText(
                              'Card 3',
                              className:
                                  'font-bold text-gray-800 dark:text-white',
                            ),
                            WText('z-30', className: 'text-sm text-gray-500'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Reference Table
          WDiv(
            className: 'p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
            children: [
              WText(
                'Quick Reference',
                className: 'font-semibold text-gray-800 dark:text-white mb-2',
              ),
              WDiv(
                className: 'flex flex-col gap-1',
                children: [
                  _buildRefRow('z-0', 'Base layer'),
                  _buildRefRow('z-10...z-50', 'Standard layers'),
                  _buildRefRow('z-auto', 'Reset/unset'),
                  _buildRefRow('z-[n]', 'Custom value'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String description,
    required List<Widget> children,
  }) {
    return WDiv(
      className: 'flex flex-col gap-2',
      children: [
        WText(
          title,
          className: 'font-semibold text-gray-800 dark:text-white font-mono',
        ),
        WText(
          description,
          className: 'text-sm text-gray-500 dark:text-gray-400',
        ),
        ...children,
      ],
    );
  }

  Widget _buildZIndexChip(String className, String value) {
    return WDiv(
      className: 'px-3 py-1 bg-indigo-100 dark:bg-indigo-900/50 rounded-full',
      child: WText(
        '$className → $value',
        className: 'text-sm font-mono text-indigo-700 dark:text-indigo-300',
      ),
    );
  }

  Widget _buildRefRow(String className, String description) {
    return WDiv(
      className: 'flex gap-4',
      children: [
        WText(
          className,
          className:
              'font-mono text-sm text-indigo-600 dark:text-indigo-400 w-28',
        ),
        WText(
          description,
          className: 'text-sm text-gray-600 dark:text-gray-300',
        ),
      ],
    );
  }
}
