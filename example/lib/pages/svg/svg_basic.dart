import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// WSvg example showing fill, stroke, and styling with utility classes.
class SvgBasicExamplePage extends StatelessWidget {
  const SvgBasicExamplePage({super.key});

  // Sample inline SVG icons
  static const _starSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
  <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/>
</svg>
''';

  static const _heartSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
  <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/>
</svg>
''';

  static const _checkSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
  <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
</svg>
''';

  static const _circleSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
  <circle cx="12" cy="12" r="10"/>
</svg>
''';

  static const _squareSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
  <rect x="3" y="3" width="18" height="18" rx="2"/>
</svg>
''';

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'p-6 bg-gray-100 h-full w-screen',
      children: [
        // Fill colors
        const WText(
          'Fill Colors (fill-{color})',
          className: 'font-bold text-sm text-gray-700 mb-2',
        ),
        WDiv(
          className: 'flex gap-4 mb-6',
          children: const [
            WSvg.string(_starSvg, className: 'fill-yellow-500 w-8 h-8'),
            WSvg.string(_heartSvg, className: 'fill-red-500 w-8 h-8'),
            WSvg.string(_starSvg, className: 'fill-blue-500 w-8 h-8'),
            WSvg.string(_heartSvg, className: 'fill-green-500 w-8 h-8'),
            WSvg.string(_checkSvg, className: 'fill-purple-500 w-8 h-8'),
          ],
        ),

        // Stroke colors (outlined icons)
        const WText(
          'Stroke Colors (stroke-{color})',
          className: 'font-bold text-sm text-gray-700 mb-2',
        ),
        WDiv(
          className: 'flex gap-4 mb-6',
          children: const [
            WSvg.string(_circleSvg, className: 'stroke-red-500 w-8 h-8'),
            WSvg.string(_squareSvg, className: 'stroke-blue-500 w-8 h-8'),
            WSvg.string(_circleSvg, className: 'stroke-green-500 w-8 h-8'),
            WSvg.string(_squareSvg, className: 'stroke-orange-500 w-8 h-8'),
            WSvg.string(_circleSvg, className: 'stroke-purple-500 w-8 h-8'),
          ],
        ),

        // Stroke width
        const WText(
          'Stroke Width (stroke-{width})',
          className: 'font-bold text-sm text-gray-700 mb-2',
        ),
        WDiv(
          className: 'flex gap-4 mb-6',
          children: const [
            WSvg.string(_circleSvg, className: 'stroke-1 w-8 h-8'),
            WSvg.string(_squareSvg, className: 'stroke-2 w-8 h-8'),
            WSvg.string(_circleSvg, className: 'stroke-3 w-8 h-8'),
            WSvg.string(_squareSvg, className: 'stroke-4 w-8 h-8'),
            WSvg.string(_circleSvg, className: 'stroke-5 w-8 h-8'),
          ],
        ),

        // Inheriting from parent WDiv
        const WText(
          'Inherit from Parent (like WIcon)',
          className: 'font-bold text-sm text-gray-700 mb-2',
        ),
        WDiv(
          className: 'flex gap-4 mb-6',
          children: [
            WDiv(
              className: 'flex items-center gap-2 text-red-500 text-xl',
              children: const [WSvg.string(_heartSvg), WText('Love')],
            ),
            WDiv(
              className: 'flex items-center gap-2 text-blue-500 text-xl',
              children: const [WSvg.string(_starSvg), WText('Star')],
            ),
            WDiv(
              className: 'flex items-center gap-2 text-green-500 text-xl',
              children: const [WSvg.string(_checkSvg), WText('Done')],
            ),
          ],
        ),

        // Sizes with text-{size}
        const WText(
          'Text Sizes (text-sm, text-lg, text-2xl)',
          className: 'font-bold text-sm text-gray-700 mb-2',
        ),
        WDiv(
          className: 'flex items-end gap-4 mb-6',
          children: const [
            WSvg.string(_starSvg, className: 'fill-gray-600 text-sm'),
            WSvg.string(_starSvg, className: 'fill-gray-600 text-base'),
            WSvg.string(_starSvg, className: 'fill-gray-600 text-lg'),
            WSvg.string(_starSvg, className: 'fill-gray-600 text-xl'),
            WSvg.string(_starSvg, className: 'fill-gray-600 text-2xl'),
            WSvg.string(_starSvg, className: 'fill-gray-600 text-3xl'),
          ],
        ),

        // Pixel sizes with w-{n} h-{n}
        const WText(
          'Pixel Sizes (w-4 h-4, w-8 h-8, w-12 h-12)',
          className: 'font-bold text-sm text-gray-700 mb-2',
        ),
        WDiv(
          className: 'flex items-end gap-4',
          children: const [
            WSvg.string(_starSvg, className: 'fill-yellow-500 w-4 h-4'),
            WSvg.string(_starSvg, className: 'fill-yellow-500 w-6 h-6'),
            WSvg.string(_starSvg, className: 'fill-yellow-500 w-8 h-8'),
            WSvg.string(_starSvg, className: 'fill-yellow-500 w-10 h-10'),
            WSvg.string(_starSvg, className: 'fill-yellow-500 w-12 h-12'),
          ],
        ),
      ],
    );
  }
}
