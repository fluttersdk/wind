import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// WDiv Widget Showcase
class WDivExamplePage extends StatelessWidget {
  const WDivExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'w-full h-full overflow-y-auto p-4',
      child: WDiv(
        className: 'flex flex-col gap-6',
        children: [
          // Header
          WDiv(
            className: 'w-full p-4 rounded-xl bg-blue-500',
            children: const [
              WText('WDiv', className: 'text-lg font-bold text-white'),
              WText(
                'The fundamental building block',
                className: 'text-sm text-blue-100',
              ),
            ],
          ),

          // Basic Block
          _section('Basic Block', 'Simple container with styling', [
            WDiv(
              className: 'p-4 bg-white dark:bg-slate-700 rounded-lg shadow-sm',
              child: const WText(
                'I am a card',
                className: 'text-gray-800 dark:text-white',
              ),
            ),
          ]),

          // Flex Row
          _section('Flex Row', 'Horizontal layout with flex flex-row', [
            WDiv(
              className:
                  'flex flex-row gap-4 p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
              children: [
                WDiv(
                  className: 'w-12 h-12 bg-red-500 rounded-lg',
                  child: const SizedBox(),
                ),
                WDiv(
                  className: 'w-12 h-12 bg-green-500 rounded-lg',
                  child: const SizedBox(),
                ),
                WDiv(
                  className: 'w-12 h-12 bg-blue-500 rounded-lg',
                  child: const SizedBox(),
                ),
              ],
            ),
          ]),

          // Flex Column
          _section('Flex Column', 'Vertical layout with flex flex-col', [
            WDiv(
              className:
                  'flex flex-col gap-2 p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
              children: const [
                WText('Item 1', className: 'text-gray-800 dark:text-white'),
                WText('Item 2', className: 'text-gray-800 dark:text-white'),
                WText('Item 3', className: 'text-gray-800 dark:text-white'),
              ],
            ),
          ]),

          // Grid
          _section('Grid Layout', 'Grid with grid grid-cols-3', [
            WDiv(
              className:
                  'grid grid-cols-3 gap-2 p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
              children: List.generate(
                6,
                (i) => WDiv(
                  className: 'p-3 bg-indigo-500 rounded text-center',
                  child: WText('${i + 1}', className: 'text-white font-bold'),
                ),
              ),
            ),
          ]),

          // Sizing
          _section('Sizing', 'Width and height utilities', [
            WDiv(
              className:
                  'flex flex-row gap-2 p-4 bg-gray-100 dark:bg-slate-800 rounded-lg overflow-x-auto',
              children: [
                WDiv(
                  className:
                      'w-16 h-16 bg-purple-500 rounded flex items-center justify-center',
                  child: const WText('w-16', className: 'text-white text-xs'),
                ),
                WDiv(
                  className:
                      'w-24 h-16 bg-purple-500 rounded flex items-center justify-center',
                  child: const WText('w-24', className: 'text-white text-xs'),
                ),
                WDiv(
                  className:
                      'w-32 h-16 bg-purple-500 rounded flex items-center justify-center',
                  child: const WText('w-32', className: 'text-white text-xs'),
                ),
              ],
            ),
          ]),

          // Spacing
          _section('Spacing', 'Padding and margin', [
            WDiv(
              className: 'bg-gray-100 dark:bg-slate-800 rounded-lg',
              child: WDiv(
                className: 'p-6 bg-blue-200 dark:bg-blue-900 m-4 rounded',
                child: const WText(
                  'p-6 m-4',
                  className: 'text-blue-800 dark:text-blue-200',
                ),
              ),
            ),
          ]),

          // Backgrounds
          _section('Backgrounds', 'Solid colors and gradients', [
            WDiv(
              className:
                  'flex flex-row gap-2 p-4 bg-gray-100 dark:bg-slate-800 rounded-lg overflow-x-auto',
              children: [
                WDiv(
                  className: 'w-20 h-20 bg-red-500 rounded-lg',
                  child: const SizedBox(),
                ),
                WDiv(
                  className:
                      'w-20 h-20 bg-gradient-to-r from-blue-500 to-purple-500 rounded-lg',
                  child: const SizedBox(),
                ),
                WDiv(
                  className:
                      'w-20 h-20 bg-gradient-to-b from-green-400 to-teal-500 rounded-lg',
                  child: const SizedBox(),
                ),
              ],
            ),
          ]),

          // Borders
          _section('Borders', 'Border width, color, and radius', [
            WDiv(
              className:
                  'flex flex-row gap-4 p-4 bg-gray-100 dark:bg-slate-800 rounded-lg overflow-x-auto',
              children: [
                WDiv(
                  className: 'w-16 h-16 border-2 border-gray-400 rounded',
                  child: const SizedBox(),
                ),
                WDiv(
                  className: 'w-16 h-16 border-2 border-blue-500 rounded-lg',
                  child: const SizedBox(),
                ),
                WDiv(
                  className: 'w-16 h-16 border-2 border-red-500 rounded-full',
                  child: const SizedBox(),
                ),
              ],
            ),
          ]),

          // Shadows
          _section('Shadows', 'Box shadow utilities', [
            WDiv(
              className:
                  'flex flex-row gap-4 p-4 bg-gray-100 dark:bg-slate-800 rounded-lg overflow-x-auto',
              children: [
                WDiv(
                  className: 'w-16 h-16 bg-white shadow rounded-lg',
                  child: const SizedBox(),
                ),
                WDiv(
                  className: 'w-16 h-16 bg-white shadow-md rounded-lg',
                  child: const SizedBox(),
                ),
                WDiv(
                  className: 'w-16 h-16 bg-white shadow-xl rounded-lg',
                  child: const SizedBox(),
                ),
              ],
            ),
          ]),

          // Quick Reference
          WDiv(
            className: 'p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
            children: [
              const WText(
                'Quick Reference',
                className: 'font-semibold text-gray-800 dark:text-white mb-2',
              ),
              WDiv(
                className: 'flex flex-col gap-1',
                children: [
                  _ref('flex flex-row/col', 'Flexbox layout'),
                  _ref('grid grid-cols-{n}', 'Grid layout'),
                  _ref('gap-{n}', 'Spacing between items'),
                  _ref('items-*, justify-*', 'Alignment'),
                  _ref('w-*, h-*', 'Width/height'),
                  _ref('p-*, m-*', 'Padding/margin'),
                  _ref('bg-{color}', 'Background'),
                  _ref('border-*, rounded-*', 'Borders'),
                  _ref('shadow-*', 'Box shadows'),
                  _ref('hover:*, dark:*', 'States'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _section(String title, String desc, List<Widget> items) {
    return WDiv(
      className: 'flex flex-col gap-2',
      children: [
        WText(
          title,
          className: 'font-semibold text-gray-800 dark:text-white font-mono',
        ),
        WText(desc, className: 'text-sm text-gray-500 dark:text-gray-400'),
        ...items,
      ],
    );
  }

  Widget _ref(String cls, String desc) {
    return WDiv(
      className: 'flex gap-4',
      children: [
        WText(
          cls,
          className: 'font-mono text-sm text-blue-600 dark:text-blue-400',
        ),
        WText(desc, className: 'text-sm text-gray-600 dark:text-gray-300'),
      ],
    );
  }
}
