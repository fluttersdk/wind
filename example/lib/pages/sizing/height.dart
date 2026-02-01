import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Height Example
/// Demonstrates height utilities: fixed, full, screen, arbitrary
class HeightExamplePage extends StatelessWidget {
  const HeightExamplePage({super.key});

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
              bg-gradient-to-r from-emerald-500 to-teal-500
            ''',
            children: [
              WText(
                'Height Utilities',
                className: 'text-lg font-bold text-white',
              ),
              WText(
                'Control element height',
                className: 'text-sm text-emerald-100',
              ),
            ],
          ),

          // Fixed Height
          _buildSection(
            title: 'Fixed Height',
            children: [
              WDiv(
                className: 'flex gap-3 items-end',
                children: [
                  _buildHeightDemo('h-8', 'h-8 w-16 bg-emerald-500', '32px'),
                  _buildHeightDemo('h-12', 'h-12 w-16 bg-emerald-500', '48px'),
                  _buildHeightDemo('h-16', 'h-16 w-16 bg-teal-500', '64px'),
                  _buildHeightDemo('h-24', 'h-24 w-16 bg-cyan-500', '96px'),
                  _buildHeightDemo('h-32', 'h-32 w-16 bg-sky-500', '128px'),
                ],
              ),
            ],
          ),

          // Full Height Demo
          _buildSection(
            title: 'h-full (100%)',
            children: [
              WDiv(
                className:
                    'h-48 bg-gray-100 dark:bg-slate-700 rounded-lg p-2 flex gap-2',
                children: [
                  WDiv(
                    className:
                        'h-full w-16 bg-green-500 rounded-lg flex items-center justify-center',
                    child: WText(
                      'h-full',
                      className: 'text-white text-xs font-mono',
                    ),
                  ),
                  WDiv(
                    className:
                        'h-1/2 w-16 bg-lime-500 rounded-lg flex items-center justify-center',
                    child: WText(
                      'h-1/2',
                      className: 'text-white text-xs font-mono',
                    ),
                  ),
                  WDiv(
                    className: 'flex-1 flex flex-col gap-1',
                    children: [
                      WText(
                        'Container: h-48',
                        className: 'text-xs text-gray-600 dark:text-gray-300',
                      ),
                      WText(
                        'h-full = 100% of parent',
                        className: 'text-xs text-gray-500',
                      ),
                      WText(
                        'h-1/2 = 50% of parent',
                        className: 'text-xs text-gray-500',
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          // Screen Height
          _buildSection(
            title: 'Screen Height',
            children: [
              WDiv(
                className: 'p-3 rounded-lg bg-gray-100 dark:bg-slate-700',
                child: WText(
                  'h-screen = 100vh (viewport height)',
                  className:
                      'text-sm text-gray-600 dark:text-gray-300 font-mono',
                ),
              ),
            ],
          ),

          // Arbitrary Values
          _buildSection(
            title: 'Arbitrary Values',
            children: [
              WDiv(
                className: 'flex gap-3 items-end',
                children: [
                  _buildHeightDemo(
                    'h-[50px]',
                    'h-[50px] w-20 bg-amber-500',
                    '50px',
                  ),
                  _buildHeightDemo(
                    'h-[80px]',
                    'h-[80px] w-20 bg-orange-500',
                    '80px',
                  ),
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
    required List<Widget> children,
  }) {
    return WDiv(
      className: 'flex flex-col gap-2',
      children: [
        WText(title, className: 'font-semibold text-gray-800 dark:text-white'),
        ...children,
      ],
    );
  }

  Widget _buildHeightDemo(String label, String className, String value) {
    return WDiv(
      className: 'flex flex-col items-center gap-1',
      children: [
        WDiv(
          className: '$className rounded-lg flex items-center justify-center',
          child: WText(label, className: 'text-white text-xs font-mono'),
        ),
        WText(value, className: 'text-gray-500 text-xs'),
      ],
    );
  }
}
