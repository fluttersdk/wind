import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/src/theme/wind_theme_data.dart';

void main() {
  group('WindThemeData Constructor Merging', () {
    test('merges user provided colors with defaults', () {
      final customColor = const MaterialColor(0xFF0000FF, {
        500: Color(0xFF0000FF),
      });
      final theme = WindThemeData(colors: {'customBlue': customColor});

      // Verify custom color exists
      expect(theme.colors['customBlue'], customColor);

      // Verify default color exists (e.g. red)
      // This is expected to fail with current implementation
      expect(
        theme.colors.containsKey('red'),
        isTrue,
        reason: 'Default "red" should be preserved',
      );
    });

    test('merges user provided screens with defaults', () {
      final theme = WindThemeData(screens: {'3xl': 2000});

      expect(theme.screens['3xl'], 2000);
      expect(
        theme.screens.containsKey('sm'),
        isTrue,
        reason: 'Default "sm" screen should be preserved',
      );
    });

    test('merges user provided fontSizes with defaults', () {
      final theme = WindThemeData(fontSizes: {'huge': 100.0});

      expect(theme.fontSizes['huge'], 100.0);
      expect(
        theme.fontSizes.containsKey('xs'),
        isTrue,
        reason: 'Default "xs" fontSize should be preserved',
      );
    });
  });
}
