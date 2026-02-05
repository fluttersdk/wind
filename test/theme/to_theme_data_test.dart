import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/src/theme/wind_theme_data.dart';
import 'package:fluttersdk_wind/src/theme/defaults/colors.dart'
    as default_colors;

void main() {
  group('WindThemeData.toThemeData', () {
    test('defaults map to light theme correctly', () {
      final windTheme = WindThemeData();
      final themeData = windTheme.toThemeData();

      expect(themeData.brightness, Brightness.light);
      expect(themeData.useMaterial3, true);
      // Fallback Primary is Indigo
      expect(
        themeData.colorScheme.primary.toARGB32(),
        default_colors.colors['indigo']![500]!.toARGB32(),
      );
      // Background default light is white
      expect(
        themeData.scaffoldBackgroundColor.toARGB32(),
        (default_colors.colors['white'] as Color).toARGB32(),
      );
    });

    test('dark brightness maps correctly', () {
      final windTheme = WindThemeData(brightness: Brightness.dark);
      final themeData = windTheme.toThemeData();

      expect(themeData.brightness, Brightness.dark);
      // Fallback Primary is Indigo
      expect(
        themeData.colorScheme.primary.toARGB32(),
        default_colors.colors['indigo']![500]!.toARGB32(),
      );
      // Background default dark is gray-900
      expect(
        themeData.scaffoldBackgroundColor.toARGB32(),
        default_colors.colors['gray']![900]!.toARGB32(),
      );
    });

    test('custom primary color is used', () {
      final customPrimary = Colors.purple;
      final windTheme = WindThemeData(colors: {'primary': customPrimary});
      final themeData = windTheme.toThemeData();

      expect(
        themeData.colorScheme.primary.toARGB32(),
        customPrimary.shade500.toARGB32(),
      );
    });

    test('custom background color is used', () {
      final customBg = Colors.pink;
      final windTheme = WindThemeData(colors: {'background': customBg});
      final themeData = windTheme.toThemeData();

      expect(
        themeData.scaffoldBackgroundColor.toARGB32(),
        customBg.shade500.toARGB32(),
      );
    });

    test('font family is applied', () {
      final windTheme = WindThemeData(fontFamilies: {'sans': 'Roboto'});
      final themeData = windTheme.toThemeData();

      expect(themeData.textTheme.bodyMedium?.fontFamily, 'Roboto');
    });
  });
}
