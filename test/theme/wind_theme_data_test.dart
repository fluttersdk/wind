import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/src/theme/wind_theme_data.dart';
import 'package:fluttersdk_wind/src/theme/defaults/colors.dart' as default_colors;

void main() {
  group('WindThemeData', () {
    test('initializes with light mode by default', () {
      final theme = WindThemeData();
      expect(theme.brightness, Brightness.light);
    });

    test('correctly resolves colors in light mode', () {
      final theme = WindThemeData(brightness: Brightness.light);
      final blue500 = theme.getColor('blue', 500);
      // In light mode, blue-500 should be its original color.
      expect(blue500, default_colors.colors['blue'][500]);
    });

    test('correctly inverts colors in dark mode', () {
      final theme = WindThemeData(brightness: Brightness.dark);
      final blue500 = theme.getColor('blue', 500);
      // In dark mode, blue-500 should be inverted to blue-400.
      expect(blue500, default_colors.colors['blue'][400]);
    });

    test('getOriginalColor always returns the base color', () {
      final lightTheme = WindThemeData(brightness: Brightness.light);
      final darkTheme = WindThemeData(brightness: Brightness.dark);

      final lightModeColor = lightTheme.getOriginalColor('blue', 500);
      final darkModeColor = darkTheme.getOriginalColor('blue', 500);

      // Both should return the original blue-500 color.
      final originalBlue500 = default_colors.colors['blue'][500];
      expect(lightModeColor, originalBlue500);
      expect(darkModeColor, originalBlue500);
    });

    test('copyWith creates a new instance with updated properties', () {
      final originalTheme = WindThemeData();
      final newTheme = originalTheme.copyWith(brightness: Brightness.dark);

      expect(newTheme.brightness, Brightness.dark);
      expect(newTheme.colors, originalTheme.colors);
      expect(newTheme.screens, originalTheme.screens);

      // Verify that the colors are inverted in the new dark theme.
      final invertedColor = newTheme.getColor('blue', 500);
      final expectedInvertedColor = default_colors.colors['blue'][400];
      expect(invertedColor, expectedInvertedColor);

      // Verify the original theme is unchanged.
      final originalColor = originalTheme.getColor('blue', 500);
      final expectedOriginalColor = default_colors.colors['blue'][500];
      expect(originalColor, expectedOriginalColor);
    });

    test('dark mode handles white and black colors correctly', () {
      final darkTheme = WindThemeData(brightness: Brightness.dark);

      // In dark mode, 'white' should resolve to a dark color (e.g., gray-900)
      final whiteAsDark = darkTheme.getColor('white', 50);
      expect(whiteAsDark, default_colors.colors['gray'][900]);

      // In dark mode, 'black' should resolve to a light color (e.g., gray-50)
      final blackAsLight = darkTheme.getColor('black', 50);
      expect(blackAsLight, default_colors.colors['gray'][50]);
    });

    test('copyWith merges new colors and screens with existing ones', () {
      final originalTheme = WindThemeData();
      const newColor = MaterialColor(0xFF0000FF, {500: Color(0xFF0000FF)});
      const newScreenSize = 1234;

      final extendedTheme = originalTheme.copyWith(
        colors: {'customBlue': newColor},
        screens: {'4xl': newScreenSize},
      );

      // Check if the new color is added.
      expect(extendedTheme.colors.containsKey('customBlue'), isTrue);
      expect(extendedTheme.colors['customBlue'], newColor);

      // Check if an original color still exists.
      expect(extendedTheme.colors.containsKey('red'), isTrue);

      // Check if the new screen size is added.
      expect(extendedTheme.screens.containsKey('4xl'), isTrue);
      expect(extendedTheme.screens['4xl'], newScreenSize);

      // Check if an original screen size still exists.
      expect(extendedTheme.screens.containsKey('sm'), isTrue);
    });

    test('getSpacing returns correct spacing values', () {
      final theme = WindThemeData();

      // Test integer multiplier
      expect(theme.getSpacing('2'), 8.0); // 2 * 4.0

      // Test fractional string
      expect(theme.getSpacing('full'), double.infinity);

      // Test invalid multiplier
      expect(() => theme.getSpacing('invalid'), throwsArgumentError);
    });

    test('getSpacing works with custom baseSpacingUnit', () {
      final theme = WindThemeData(baseSpacingUnit: 10.0);

      // Test integer multiplier
      expect(theme.getSpacing('3'), 30.0); // 3 * 10.0

      // Test fractional string
      expect(theme.getSpacing('full'), double.infinity);
    });

    test('getSpacing handles decimal multipliers', () {
      final theme = WindThemeData();

      // Test decimal multiplier
      expect(theme.getSpacing('2.5'), 10.0); // 2.5 * 4.0
    });

    test('getSpacing handles zero multiplier', () {
      final theme = WindThemeData();

      // Test zero multiplier
      expect(theme.getSpacing('0'), 0.0); // 0 * 4.0
    });

    test('getSpacing handles negative multiplier', () {
      final theme = WindThemeData();

      // Test negative multiplier
      expect(theme.getSpacing('-2'), -8.0); // -2 * 4.0
    });

    test('getSpacing handles large multipliers', () {
      final theme = WindThemeData();

      // Test large multiplier
      expect(theme.getSpacing('1000'), 4000.0); // 1000 * 4.0
    });

    test('getSpacing uses spacing fractions correctly', () {
      final theme = WindThemeData();

      // Test known spacing fraction
      expect(theme.getSpacing('full'), double.infinity);
    });
  });
}
