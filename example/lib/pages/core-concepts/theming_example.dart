import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Demonstrates WindThemeData customization with unique colors, spacing, and typography.
class ThemingExamplePage extends StatelessWidget {
  const ThemingExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = WindTheme.dataOf(context);

    return WDiv(
      className: 'w-full h-full overflow-y-auto p-4',
      scrollPrimary: true,
      child: WDiv(
        className: 'flex flex-col gap-6 max-w-4xl mx-auto',
        children: [
          _buildHeader(),
          _buildColorPalette(themeData),
          _buildSpacingScale(themeData),
          _buildTypographyScale(themeData),
          _buildBorderRadiusScale(themeData),
          _buildShadowScale(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className: 'bg-gradient-to-r from-emerald-500 to-teal-600 rounded-xl p-6',
      child: WDiv(
        className: 'flex flex-col gap-2',
        children: [
          WText(
            'Theme Customization',
            className: 'text-2xl font-bold text-white',
          ),
          WText(
            'Explore your WindThemeData scales: colors, spacing, typography, and more.',
            className: 'text-emerald-100',
          ),
        ],
      ),
    );
  }

  Widget _buildColorPalette(WindThemeData themeData) {
    final colorNames = ['primary', 'slate', 'red', 'green', 'blue', 'purple'];
    final shades = [
      '50',
      '100',
      '200',
      '300',
      '400',
      '500',
      '600',
      '700',
      '800',
      '900'
    ];

    return _buildSection(
      title: 'Color Palette',
      description: 'Theme colors with MaterialColor-style shades (50-900)',
      child: WDiv(
        className: 'flex flex-col gap-4',
        children: colorNames.map((colorName) {
          return WDiv(
            className: 'flex flex-col gap-1',
            children: [
              WText(colorName,
                  className:
                      'text-sm font-medium text-slate-700 dark:text-slate-300 capitalize'),
              WDiv(
                className: 'flex gap-1',
                children: shades.map((shade) {
                  return WDiv(
                    className: 'w-8 h-8 rounded bg-$colorName-$shade',
                    child: const SizedBox.shrink(),
                  );
                }).toList(),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSpacingScale(WindThemeData themeData) {
    final spacingValues = ['1', '2', '3', '4', '6', '8', '10', '12', '16'];

    return _buildSection(
      title: 'Spacing Scale',
      description:
          'Base unit: ${themeData.baseSpacingUnit}px. Values multiply the base (p-4 = ${4 * themeData.baseSpacingUnit}px)',
      child: WDiv(
        className: 'flex items-end gap-2',
        children: spacingValues.map((value) {
          final pixels = int.parse(value) * themeData.baseSpacingUnit;
          return WDiv(
            className: 'flex flex-col items-center gap-1',
            children: [
              WDiv(
                className: 'w-8 bg-blue-500 rounded',
                child: SizedBox(height: pixels.toDouble()),
              ),
              WText(value, className: 'text-xs text-slate-500'),
              WText('${pixels.toInt()}px', className: 'text-xs text-slate-400'),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTypographyScale(WindThemeData themeData) {
    final sizes = [
      ('xs', 'text-xs'),
      ('sm', 'text-sm'),
      ('base', 'text-base'),
      ('lg', 'text-lg'),
      ('xl', 'text-xl'),
      ('2xl', 'text-2xl'),
      ('3xl', 'text-3xl'),
    ];

    return _buildSection(
      title: 'Typography Scale',
      description: 'Font sizes from theme with corresponding line heights',
      child: WDiv(
        className: 'flex flex-col gap-3',
        children: sizes.map((entry) {
          final (name, className) = entry;
          return WDiv(
            className: 'flex items-baseline gap-4 overflow-hidden',
            children: [
              WDiv(
                className: 'w-12 shrink-0',
                child:
                    WText(name, className: 'text-sm text-slate-500 font-mono'),
              ),
              WDiv(
                className: 'flex-1 min-w-0',
                child: WText(
                  'The quick brown fox jumps over the lazy dog',
                  className:
                      '$className text-slate-900 dark:text-white truncate',
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBorderRadiusScale(WindThemeData themeData) {
    final radii = [
      ('none', 'rounded-none'),
      ('sm', 'rounded-sm'),
      ('default', 'rounded'),
      ('md', 'rounded-md'),
      ('lg', 'rounded-lg'),
      ('xl', 'rounded-xl'),
      ('2xl', 'rounded-2xl'),
      ('full', 'rounded-full'),
    ];

    return _buildSection(
      title: 'Border Radius Scale',
      description: 'Rounded corners from sharp to fully circular',
      child: WDiv(
        className: 'flex gap-4 items-center',
        children: radii.map((entry) {
          final (name, className) = entry;
          return WDiv(
            className: 'flex flex-col items-center gap-2',
            children: [
              WDiv(
                className: 'w-12 h-12 bg-purple-500 $className',
                child: const SizedBox.shrink(),
              ),
              WText(name, className: 'text-xs text-slate-500'),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildShadowScale() {
    final shadows = [
      ('sm', 'shadow-sm'),
      ('default', 'shadow'),
      ('md', 'shadow-md'),
      ('lg', 'shadow-lg'),
      ('xl', 'shadow-xl'),
      ('2xl', 'shadow-2xl'),
    ];

    return _buildSection(
      title: 'Shadow Scale',
      description: 'Box shadows from subtle to dramatic',
      child: WDiv(
        className: 'flex gap-6 items-center py-4',
        children: shadows.map((entry) {
          final (name, className) = entry;
          return WDiv(
            className: 'flex flex-col items-center gap-3',
            children: [
              WDiv(
                className:
                    'w-16 h-16 bg-white dark:bg-slate-700 rounded-lg $className',
                child: const SizedBox.shrink(),
              ),
              WText(name, className: 'text-xs text-slate-500'),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String description,
    required Widget child,
  }) {
    return WDiv(
      className:
          'flex flex-col gap-4 p-5 bg-white dark:bg-slate-800 rounded-xl border border-slate-200 dark:border-slate-700',
      children: [
        WDiv(
          className: 'flex flex-col gap-1',
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
