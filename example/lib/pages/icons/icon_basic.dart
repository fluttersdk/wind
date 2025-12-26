import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Basic WIcon example showing icon styling with utility classes.
class IconBasicExamplePage extends StatelessWidget {
  const IconBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'p-6 bg-gray-100 h-full w-screen',
      children: [
        // Basic icons with colors
        const WText(
          'Icon Colors (text-{color})',
          className: 'font-bold text-sm text-gray-700 mb-2',
        ),
        WDiv(
          className: 'flex gap-4 mb-6',
          children: const [
            WIcon(Icons.star, className: 'text-yellow-500 text-2xl'),
            WIcon(Icons.favorite, className: 'text-red-500 text-2xl'),
            WIcon(Icons.thumb_up, className: 'text-blue-500 text-2xl'),
            WIcon(Icons.check_circle, className: 'text-green-500 text-2xl'),
            WIcon(Icons.warning, className: 'text-orange-500 text-2xl'),
          ],
        ),

        // Icon sizes using text-{size} classes
        const WText(
          'Icon Sizes (text-{size})',
          className: 'font-bold text-sm text-gray-700 mb-2',
        ),
        WDiv(
          className: 'flex items-end gap-4 mb-6',
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

        // Inheriting from parent WDiv
        const WText(
          'Inherit from Parent (like HTML)',
          className: 'font-bold text-sm text-gray-700 mb-2',
        ),
        WDiv(
          className: 'flex gap-4 mb-6',
          children: [
            // Red icons - inherit color and size from parent
            WDiv(
              className: 'flex items-center gap-2 text-red-500 text-xl',
              children: const [
                WIcon(Icons.favorite), // Inherits red and xl
                WText('Love'),
              ],
            ),
            // Blue icons - inherit color and size from parent
            WDiv(
              className: 'flex items-center gap-2 text-blue-500 text-xl',
              children: const [
                WIcon(Icons.thumb_up), // Inherits blue and xl
                WText('Like'),
              ],
            ),
            // Green icons - inherit color and size from parent
            WDiv(
              className: 'flex items-center gap-2 text-green-500 text-xl',
              children: const [
                WIcon(Icons.check), // Inherits green and xl
                WText('Done'),
              ],
            ),
          ],
        ),

        // Icon opacity
        const WText(
          'Icon Opacity',
          className: 'font-bold text-sm text-gray-700 mb-2',
        ),
        WDiv(
          className: 'flex gap-4 mb-6',
          children: const [
            WIcon(
              Icons.circle,
              className: 'text-blue-500 text-2xl opacity-100',
            ),
            WIcon(Icons.circle, className: 'text-blue-500 text-2xl opacity-80'),
            WIcon(Icons.circle, className: 'text-blue-500 text-2xl opacity-60'),
            WIcon(Icons.circle, className: 'text-blue-500 text-2xl opacity-40'),
            WIcon(Icons.circle, className: 'text-blue-500 text-2xl opacity-20'),
          ],
        ),

        // Sizes with w-{n} h-{n}
        const WText(
          'Pixel Sizes (w-{n} h-{n})',
          className: 'font-bold text-sm text-gray-700 mb-2',
        ),
        WDiv(
          className: 'flex items-end gap-4',
          children: const [
            WIcon(Icons.star, className: 'text-yellow-500 w-4 h-4'),
            WIcon(Icons.star, className: 'text-yellow-500 w-6 h-6'),
            WIcon(Icons.star, className: 'text-yellow-500 w-8 h-8'),
            WIcon(Icons.star, className: 'text-yellow-500 w-10 h-10'),
          ],
        ),
      ],
    );
  }
}
