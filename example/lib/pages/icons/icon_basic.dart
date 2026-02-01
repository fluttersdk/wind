import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Basic WIcon example showing icon styling with utility classes.
class IconBasicExamplePage extends StatelessWidget {
  const IconBasicExamplePage({super.key});

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
              bg-gradient-to-r from-rose-500 to-pink-500
            ''',
            children: const [
              WText('WIcon', className: 'text-lg font-bold text-white'),
              WText(
                'Utility-first icon component with parent inheritance',
                className: 'text-sm text-rose-100',
              ),
            ],
          ),

          // Colors
          _buildSection(
            title: 'Icon Colors',
            description: 'Use text-{color} to set icon color',
            children: [
              WDiv(
                className: 'flex gap-4 overflow-x-auto',
                children: const [
                  WIcon(Icons.star, className: 'text-yellow-500 text-2xl'),
                  WIcon(Icons.favorite, className: 'text-red-500 text-2xl'),
                  WIcon(Icons.thumb_up, className: 'text-blue-500 text-2xl'),
                  WIcon(
                    Icons.check_circle,
                    className: 'text-green-500 text-2xl',
                  ),
                  WIcon(Icons.warning, className: 'text-orange-500 text-2xl'),
                ],
              ),
            ],
          ),

          // Text sizes
          _buildSection(
            title: 'Text Sizes',
            description: 'Use text-{size} for font-relative sizing',
            children: [
              WDiv(
                className: 'flex items-end gap-4 overflow-x-auto',
                children: const [
                  WIcon(Icons.home, className: 'text-gray-600 text-xs'),
                  WIcon(Icons.home, className: 'text-gray-600 text-sm'),
                  WIcon(Icons.home, className: 'text-gray-600 text-base'),
                  WIcon(Icons.home, className: 'text-gray-600 text-lg'),
                  WIcon(Icons.home, className: 'text-gray-600 text-xl'),
                  WIcon(Icons.home, className: 'text-gray-600 text-2xl'),
                  WIcon(Icons.home, className: 'text-gray-600 text-3xl'),
                ],
              ),
            ],
          ),

          // Parent inheritance
          _buildSection(
            title: 'Parent Inheritance',
            description: 'Icons inherit color and size from parent',
            children: [
              WDiv(
                className: 'flex gap-4 overflow-x-auto',
                children: [
                  WDiv(
                    className: 'flex items-center gap-2 text-red-500 text-xl',
                    children: const [WIcon(Icons.favorite), WText('Love')],
                  ),
                  WDiv(
                    className: 'flex items-center gap-2 text-blue-500 text-xl',
                    children: const [WIcon(Icons.thumb_up), WText('Like')],
                  ),
                  WDiv(
                    className: 'flex items-center gap-2 text-green-500 text-xl',
                    children: const [WIcon(Icons.check), WText('Done')],
                  ),
                ],
              ),
            ],
          ),

          // Animations
          _buildSection(
            title: 'Animations',
            description: 'Use animate-* classes for icon animations',
            children: [
              WDiv(
                className: 'flex gap-6 overflow-x-auto',
                children: const [
                  WIcon(
                    Icons.refresh,
                    className: 'text-blue-500 text-2xl animate-spin',
                  ),
                  WIcon(
                    Icons.circle,
                    className: 'text-gray-400 text-2xl animate-pulse',
                  ),
                  WIcon(
                    Icons.arrow_downward,
                    className: 'text-green-500 text-2xl animate-bounce',
                  ),
                ],
              ),
            ],
          ),

          // Opacity
          _buildSection(
            title: 'Opacity',
            description: 'Use opacity-{n} for transparency',
            children: [
              WDiv(
                className: 'flex gap-4 overflow-x-auto',
                children: const [
                  WIcon(
                    Icons.circle,
                    className: 'text-blue-500 text-2xl opacity-100',
                  ),
                  WIcon(
                    Icons.circle,
                    className: 'text-blue-500 text-2xl opacity-80',
                  ),
                  WIcon(
                    Icons.circle,
                    className: 'text-blue-500 text-2xl opacity-60',
                  ),
                  WIcon(
                    Icons.circle,
                    className: 'text-blue-500 text-2xl opacity-40',
                  ),
                  WIcon(
                    Icons.circle,
                    className: 'text-blue-500 text-2xl opacity-20',
                  ),
                ],
              ),
            ],
          ),

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
                  _referenceRow('text-{color}', 'Icon color'),
                  _referenceRow('text-{size}', 'Font-relative size'),
                  _referenceRow('w-{n} h-{n}', 'Pixel dimensions'),
                  _referenceRow('opacity-{n}', 'Opacity'),
                  _referenceRow('animate-spin', 'Spinning animation'),
                  _referenceRow('animate-pulse', 'Pulse animation'),
                  _referenceRow('animate-bounce', 'Bounce animation'),
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

  Widget _referenceRow(String className, String value) {
    return WDiv(
      className: 'flex justify-between',
      children: [
        WText(
          className,
          className: 'text-sm font-mono text-gray-600 dark:text-gray-300',
        ),
        WText(value, className: 'text-sm text-gray-500 dark:text-gray-400'),
      ],
    );
  }
}
