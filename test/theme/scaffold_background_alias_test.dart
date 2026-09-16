import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Pins that `ThemeData.scaffoldBackgroundColor` agrees with the colour the
/// app's own pages are painted with.
///
/// The two are read by different layers and had no reason to agree. An app
/// paints its canvas through a `bg-surface` className on a widget of its own,
/// while anything Material puts BEHIND a page reads
/// `scaffoldBackgroundColor`, which this class filled from `colors['background']`
/// or, failing that, from wind's own white and gray-900 defaults. Nothing
/// painted a page, so nobody noticed.
///
/// `magic` 0.0.12 starts painting one, to stop a pushed route showing the page
/// underneath it through a transparent page. That turns the disagreement into
/// a visible wrong colour on every screen, worst in dark mode: measured on one
/// consumer, the alias resolved to `#07090C` while this field was `#111827`.
///
/// `colors['background']` cannot fix it on the consumer's side, because it
/// holds ONE colour for both brightnesses and a themed app needs a different
/// canvas in each. Hence reading the alias, which already carries both.
void main() {
  group('scaffoldBackgroundColor follows the bg-surface alias', () {
    const Map<String, String> aliases = {
      'bg-surface': 'bg-[#F9FAFB] dark:bg-[#07090C]',
    };

    test('light takes the bare token', () {
      final ThemeData theme = WindThemeData(aliases: aliases).toThemeData();

      expect(theme.scaffoldBackgroundColor.toARGB32(), 0xFFF9FAFB);
    });

    test('dark takes the dark: pair, not the bare token', () {
      final ThemeData theme = WindThemeData(
        aliases: aliases,
        brightness: Brightness.dark,
      ).toThemeData();

      expect(
        theme.scaffoldBackgroundColor.toARGB32(),
        0xFF07090C,
        reason: 'a dark theme was handed the light canvas',
      );
    });

    test('an explicit background color still wins', () {
      // The existing key is the consumer saying it outright, so the alias must
      // not override it.
      final ThemeData theme = WindThemeData(
        aliases: aliases,
        colors: {
          'background': const MaterialColor(0xFF123456, <int, Color>{
            500: Color(0xFF123456),
          }),
        },
      ).toThemeData();

      expect(theme.scaffoldBackgroundColor.toARGB32(), 0xFF123456);
    });

    test('no alias keeps the shipped defaults', () {
      expect(
        WindThemeData().toThemeData().scaffoldBackgroundColor.toARGB32(),
        0xFFFFFFFF,
      );
      expect(
        WindThemeData(brightness: Brightness.dark)
            .toThemeData()
            .scaffoldBackgroundColor
            .toARGB32(),
        0xFF111827,
      );
    });

    test('an alias naming a palette colour is left alone', () {
      // Only a literal `bg-[#hex]` is readable as text. Anything else would
      // need the parser, which cannot run while the theme it reads is being
      // built, so the default stands rather than a guess.
      final ThemeData theme = WindThemeData(
        aliases: const {'bg-surface': 'bg-gray-50 dark:bg-gray-900'},
      ).toThemeData();

      expect(theme.scaffoldBackgroundColor.toARGB32(), 0xFFFFFFFF);
    });

    test('a dark theme with no dark: pair keeps the dark default', () {
      // Falling back to the light token here would hand a dark app a white
      // canvas, which is worse than the default it already had.
      final ThemeData theme = WindThemeData(
        aliases: const {'bg-surface': 'bg-[#F9FAFB]'},
        brightness: Brightness.dark,
      ).toThemeData();

      expect(theme.scaffoldBackgroundColor.toARGB32(), 0xFF111827);
    });

    test('an eight-digit token carries its own alpha', () {
      final ThemeData theme = WindThemeData(
        aliases: const {'bg-surface': 'bg-[#80F9FAFB]'},
      ).toThemeData();

      expect(theme.scaffoldBackgroundColor.toARGB32(), 0x80F9FAFB);
    });

    test('a three-digit shorthand resolves like the parser resolves it', () {
      // `hexToColor` expands `#fff` to `#FFFFFF`, so a theme written that way
      // has to reach the same colour here: the whole point of this field is
      // that Material paints what the className paints.
      final ThemeData theme = WindThemeData(
        aliases: const {'bg-surface': 'bg-[#fff] dark:bg-[#123]'},
      ).toThemeData();

      expect(theme.scaffoldBackgroundColor, const Color(0xFFFFFFFF));
    });

    test('a seven-digit typo is left alone rather than guessed at', () {
      // Neither six nor eight, so it names no colour anybody wrote. Answering
      // one would paint a canvas from a typo.
      final ThemeData theme = WindThemeData(
        aliases: const {'bg-surface': 'bg-[#F9FAFB1]'},
      ).toThemeData();

      expect(theme.scaffoldBackgroundColor, Colors.white);
    });
  });
}
