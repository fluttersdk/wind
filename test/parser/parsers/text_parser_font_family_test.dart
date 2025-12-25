import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

WindContext createTestContext({Map<String, String>? fontFamilies}) {
  return WindContext(
    theme: WindThemeData(fontFamilies: fontFamilies),
    activeBreakpoint: 'base',
    platform: 'macos',
    isMobile: false,
    isHovering: false,
    isFocused: false,
    isDisabled: false,
    screenWidth: 1024,
    screenHeight: 768,
  );
}

void main() {
  group('TextParser Font Family Tests', () {
    group('canParse', () {
      test('returns true for font-sans', () {
        expect(const TextParser().canParse('font-sans'), isTrue);
      });

      test('returns true for font-serif', () {
        expect(const TextParser().canParse('font-serif'), isTrue);
      });

      test('returns true for font-mono', () {
        expect(const TextParser().canParse('font-mono'), isTrue);
      });

      test('returns true for font-[CustomFont]', () {
        expect(const TextParser().canParse('font-[Roboto]'), isTrue);
      });
    });

    group('parse', () {
      test('parses font-sans from theme', () {
        final style = const TextParser().parse(const WindStyle(), [
          'font-sans',
        ], createTestContext());

        expect(style.fontFamily, isNotNull);
        expect(style.fontFamily, contains('sans-serif'));
      });

      test('parses font-serif from theme', () {
        final style = const TextParser().parse(const WindStyle(), [
          'font-serif',
        ], createTestContext());

        expect(style.fontFamily, isNotNull);
        expect(style.fontFamily, contains('serif'));
      });

      test('parses font-mono from theme', () {
        final style = const TextParser().parse(const WindStyle(), [
          'font-mono',
        ], createTestContext());

        expect(style.fontFamily, isNotNull);
        expect(style.fontFamily, contains('monospace'));
      });

      test('parses arbitrary font-[Roboto]', () {
        final style = const TextParser().parse(const WindStyle(), [
          'font-[Roboto]',
        ], createTestContext());

        expect(style.fontFamily, 'Roboto');
      });

      test('parses font-[Inter, sans-serif]', () {
        final style = const TextParser().parse(const WindStyle(), [
          'font-[Inter, sans-serif]',
        ], createTestContext());

        expect(style.fontFamily, 'Inter, sans-serif');
      });

      test('custom theme fonts are used', () {
        final style = const TextParser().parse(
          const WindStyle(),
          ['font-display'],
          createTestContext(fontFamilies: {'display': 'Poppins, sans-serif'}),
        );

        expect(style.fontFamily, 'Poppins, sans-serif');
      });

      test('last class wins', () {
        final style = const TextParser().parse(const WindStyle(), [
          'font-sans',
          'font-mono',
        ], createTestContext());

        expect(style.fontFamily, contains('monospace'));
      });
    });
  });
}
