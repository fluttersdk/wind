import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/src/theme/wind_theme_data.dart';
import 'package:fluttersdk_wind/src/theme/defaults/colors.dart'
    as default_colors;

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

    test('returns base colors regardless of brightness', () {
      final lightTheme = WindThemeData(brightness: Brightness.light);
      final darkTheme = WindThemeData(brightness: Brightness.dark);
      // getColor returns base colors; inversion is handled at parse time
      expect(
        lightTheme.getColor('blue', 500),
        default_colors.colors['blue'][500],
      );
      expect(
        darkTheme.getColor('blue', 500),
        default_colors.colors['blue'][500],
      );
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

      // getColor returns base colors regardless of brightness
      final darkColor = newTheme.getColor('blue', 500);
      final expectedColor = default_colors.colors['blue'][500];
      expect(darkColor, expectedColor);

      // Verify the original theme is unchanged.
      final originalColor = originalTheme.getColor('blue', 500);
      final expectedOriginalColor = default_colors.colors['blue'][500];
      expect(originalColor, expectedOriginalColor);
    });

    test('handles white and black colors correctly', () {
      final theme = WindThemeData();

      // Just verify they don't throw
      expect(() => theme.getColor('white', 500), returnsNormally);
      expect(() => theme.getColor('black', 500), returnsNormally);
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

    test('tryGetSpacing matches getSpacing for known tokens', () {
      final theme = WindThemeData();

      expect(theme.tryGetSpacing('4'), theme.getSpacing('4'));
      expect(theme.tryGetSpacing('2.5'), theme.getSpacing('2.5'));
      expect(theme.tryGetSpacing('full'), double.infinity);
    });

    test('tryGetSpacing returns null for an unknown token', () {
      final theme = WindThemeData();

      expect(theme.tryGetSpacing('primary'), isNull);
      expect(theme.tryGetSpacing('foo'), isNull);
      expect(theme.tryGetSpacing('abc'), isNull);
    });
  });

  group('WindThemeData value equality', () {
    test('two default instances compare equal and share a hashCode', () {
      // The equality guard in WindThemeController.setTheme and
      // _WindThemeState.didUpdateWidget is load-bearing: identity-only
      // equality would let a fresh default WindThemeData() on a parent
      // rebuild clobber a prior toggleTheme() choice.
      final a = WindThemeData();
      final b = WindThemeData();

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('instances differing by a scalar field are not equal', () {
      final light = WindThemeData();
      final dark = WindThemeData(brightness: Brightness.dark);

      expect(light, isNot(equals(dark)));
    });

    test('instances differing by baseSpacingUnit are not equal', () {
      final a = WindThemeData();
      final b = WindThemeData(baseSpacingUnit: 8);

      expect(a, isNot(equals(b)));
    });

    test('copyWith that changes nothing stays equal', () {
      final a = WindThemeData();
      final b = a.copyWith();

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    group('default primary token (WIND-3 brand seed)', () {
      test('seeds a default `primary` color aliased to Tailwind blue', () {
        final theme = WindThemeData();

        expect(theme.isValidColor('primary'), isTrue);
        expect(theme.isValidColor('primary', shade: 500), isTrue);
        expect(
          theme.getColor('primary', 500),
          default_colors.colors['blue'][500],
        );
      });

      test('primary shades mirror the blue swatch 1:1', () {
        final theme = WindThemeData();

        for (final shade in <int>[50, 100, 500, 600, 700, 900]) {
          expect(
            theme.getColor('primary', shade),
            default_colors.colors['blue'][shade],
            reason: 'primary-$shade should equal blue-$shade',
          );
        }
      });

      test('a consumer primary overrides the seeded default', () {
        final theme = WindThemeData(colors: {'primary': Colors.red});

        expect(
          theme.getColor('primary', 500)?.toARGB32(),
          Colors.red.shade500.toARGB32(),
        );
      });

      test(
        'toThemeData keeps its indigo Material baseline when primary is '
        'left at the seeded default',
        () {
          final themeData = WindThemeData().toThemeData();

          // The seeded `primary` token drives Wind widgets only; the Material
          // ColorScheme retains indigo unless the consumer sets a brand color.
          expect(
            themeData.colorScheme.primary.toARGB32(),
            default_colors.colors['indigo'][500].toARGB32(),
          );
        },
      );

      test('toThemeData seeds the Material scheme from a custom primary', () {
        final themeData =
            WindThemeData(colors: {'primary': Colors.purple}).toThemeData();

        expect(
          themeData.colorScheme.primary.toARGB32(),
          Colors.purple.shade500.toARGB32(),
        );
      });
    });
  });
}
