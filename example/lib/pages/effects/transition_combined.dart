import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Example page demonstrating combined transition utilities with real-world patterns.
class TransitionCombinedPage extends StatelessWidget {
  const TransitionCombinedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WindTheme(
      child: Scaffold(
        body: WDiv(
          className: 'bg-gray-100 p-8',
          children: [
            WText(
              'Combined Transitions',
              className: 'text-2xl font-bold text-gray-900',
            ),
            WDiv(className: 'h-8'),

            // Button Examples
            WText(
              'Button Hover Effect',
              className: 'text-lg font-semibold text-gray-700',
            ),
            WDiv(className: 'h-4'),
            WDiv(
              className: 'flex flex-row gap-4',
              children: [
                WAnchor(
                  onTap: () {},
                  child: WDiv(
                    className:
                        'bg-blue-500 hover:bg-blue-700 duration-200 ease-in-out px-8 py-3 rounded-lg shadow-md hover:shadow-lg',
                    child: WText(
                      'Primary',
                      className: 'text-white font-semibold',
                    ),
                  ),
                ),
                WAnchor(
                  onTap: () {},
                  child: WDiv(
                    className:
                        'bg-gray-200 hover:bg-gray-300 duration-200 ease-in-out px-8 py-3 rounded-lg',
                    child: WText(
                      'Secondary',
                      className: 'text-gray-700 font-semibold',
                    ),
                  ),
                ),
                WAnchor(
                  onTap: () {},
                  child: WDiv(
                    className:
                        'border-2 border-blue-500 hover:bg-blue-500 duration-300 ease-out px-8 py-3 rounded-lg',
                    child: WText(
                      'Outline',
                      className: 'text-blue-500 hover:text-white font-semibold',
                    ),
                  ),
                ),
              ],
            ),

            WDiv(className: 'h-10'),

            // Card Example
            WText(
              'Card Hover Effect',
              className: 'text-lg font-semibold text-gray-700',
            ),
            WDiv(className: 'h-4'),
            WAnchor(
              onTap: () {},
              child: WDiv(
                className:
                    'bg-white hover:bg-gray-50 shadow-md hover:shadow-2xl duration-300 ease-out p-6 rounded-2xl w-[320px]',
                children: [
                  WText(
                    'Card Title',
                    className: 'text-xl font-bold text-gray-900',
                  ),
                  WDiv(className: 'h-3'),
                  WText(
                    'Hover to see the shadow and background transition smoothly.',
                    className: 'text-gray-500',
                  ),
                  WDiv(className: 'h-4'),
                  WDiv(
                    className: 'bg-blue-100 px-3 py-1 rounded-full',
                    child: WText(
                      'Tag',
                      className: 'text-blue-600 text-sm font-medium',
                    ),
                  ),
                ],
              ),
            ),

            WDiv(className: 'h-10'),

            // Color Palette
            WText(
              'Color Palette Transitions',
              className: 'text-lg font-semibold text-gray-700',
            ),
            WDiv(className: 'h-4'),
            WDiv(
              className: 'flex flex-row gap-3',
              children: [
                _colorBox('bg-red-400 hover:bg-red-600'),
                _colorBox('bg-orange-400 hover:bg-orange-600'),
                _colorBox('bg-amber-400 hover:bg-amber-600'),
                _colorBox('bg-emerald-400 hover:bg-emerald-600'),
                _colorBox('bg-teal-400 hover:bg-teal-600'),
                _colorBox('bg-sky-400 hover:bg-sky-600'),
                _colorBox('bg-indigo-400 hover:bg-indigo-600'),
                _colorBox('bg-purple-400 hover:bg-purple-600'),
                _colorBox('bg-pink-400 hover:bg-pink-600'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _colorBox(String colorClasses) {
    return WAnchor(
      onTap: () {},
      child: WDiv(
        className:
            '$colorClasses duration-300 ease-in-out w-[56px] h-[56px] rounded-xl shadow-sm hover:shadow-lg',
      ),
    );
  }
}
