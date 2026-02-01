import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Example page demonstrating combined transition utilities with real-world patterns.
class TransitionCombinedPage extends StatelessWidget {
  const TransitionCombinedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'w-full h-full overflow-y-auto p-4',
      child: WDiv(
        className: 'flex flex-col gap-6',
        children: [
          // Header with gradient
          WDiv(
            className: '''
              w-full p-4 rounded-xl
              bg-gradient-to-r from-blue-500 to-indigo-500
            ''',
            children: [
              WText(
                'Combined Transitions',
                className: 'text-lg font-bold text-white',
              ),
              WText(
                'Real-world patterns combining duration and ease',
                className: 'text-sm text-blue-100',
              ),
            ],
          ),

          // Button examples
          _buildSection(
            title: 'Button Hover Effects',
            description: 'Common button transition patterns',
            children: [
              WDiv(
                className: 'flex gap-4 overflow-x-auto',
                children: [
                  WAnchor(
                    onTap: () {},
                    child: WDiv(
                      className: '''
                        bg-blue-500 hover:bg-blue-700 
                        duration-200 ease-in-out 
                        px-8 py-3 rounded-lg shadow-md hover:shadow-lg
                      ''',
                      child: WText(
                        'Primary',
                        className: 'text-white font-semibold',
                      ),
                    ),
                  ),
                  WAnchor(
                    onTap: () {},
                    child: WDiv(
                      className: '''
                        bg-gray-200 hover:bg-gray-300 
                        duration-200 ease-in-out 
                        px-8 py-3 rounded-lg
                      ''',
                      child: WText(
                        'Secondary',
                        className: 'text-gray-700 font-semibold',
                      ),
                    ),
                  ),
                  WAnchor(
                    onTap: () {},
                    child: WDiv(
                      className: '''
                        border-2 border-blue-500 hover:bg-blue-500 
                        duration-300 ease-out 
                        px-8 py-3 rounded-lg
                      ''',
                      child: WText(
                        'Outline',
                        className: 'text-blue-500 font-semibold',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Card example
          _buildSection(
            title: 'Card Hover Effect',
            description: 'Shadow and background transitions for cards',
            children: [
              WAnchor(
                onTap: () {},
                child: WDiv(
                  className: '''
                    bg-white dark:bg-slate-700 
                    hover:bg-gray-50 dark:hover:bg-slate-600
                    shadow-md hover:shadow-2xl 
                    duration-300 ease-out 
                    p-6 rounded-2xl w-[320px]
                  ''',
                  children: [
                    WText(
                      'Card Title',
                      className:
                          'text-xl font-bold text-gray-900 dark:text-white',
                    ),
                    WDiv(className: 'h-3'),
                    WText(
                      'Hover to see the shadow and background transition smoothly.',
                      className: 'text-gray-500 dark:text-gray-300',
                    ),
                    WDiv(className: 'h-4'),
                    WDiv(
                      className:
                          'bg-blue-100 dark:bg-blue-900 px-3 py-1 rounded-full',
                      child: WText(
                        'Tag',
                        className:
                            'text-blue-600 dark:text-blue-300 text-sm font-medium',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Color palette
          _buildSection(
            title: 'Color Palette Transitions',
            description: 'Smooth color changes on hover',
            children: [
              WDiv(
                className: 'flex gap-3 overflow-x-auto',
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

  Widget _colorBox(String colorClasses) {
    return WAnchor(
      onTap: () {},
      child: WDiv(
        className:
            '''
          $colorClasses duration-300 ease-in-out 
          w-[56px] h-[56px] rounded-xl shadow-sm hover:shadow-lg
        ''',
      ),
    );
  }
}
