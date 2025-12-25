import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Helper function to create a test WindContext
WindContext createTestContext() {
  return WindContext(
    theme: WindThemeData(),
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
  group('AspectRatioParser Tests', () {
    group('canParse', () {
      test('returns true for aspect-square', () {
        expect(const AspectRatioParser().canParse('aspect-square'), isTrue);
      });

      test('returns true for aspect-video', () {
        expect(const AspectRatioParser().canParse('aspect-video'), isTrue);
      });

      test('returns true for aspect-auto', () {
        expect(const AspectRatioParser().canParse('aspect-auto'), isTrue);
      });

      test('returns true for aspect-[4/3]', () {
        expect(const AspectRatioParser().canParse('aspect-[4/3]'), isTrue);
      });

      test('returns true for aspect-[16/9]', () {
        expect(const AspectRatioParser().canParse('aspect-[16/9]'), isTrue);
      });

      test('returns false for non-aspect classes', () {
        expect(const AspectRatioParser().canParse('bg-red-500'), isFalse);
        expect(const AspectRatioParser().canParse('text-lg'), isFalse);
        expect(const AspectRatioParser().canParse('aspect-invalid'), isFalse);
      });
    });

    group('parse', () {
      test('parses aspect-square', () {
        final parser = const AspectRatioParser();
        final style = parser.parse(const WindStyle(), [
          'aspect-square',
        ], createTestContext());

        expect(style.aspectRatio, 1.0);
      });

      test('parses aspect-video', () {
        final parser = const AspectRatioParser();
        final style = parser.parse(const WindStyle(), [
          'aspect-video',
        ], createTestContext());

        expect(style.aspectRatio, 16 / 9);
      });

      test('parses aspect-auto', () {
        final parser = const AspectRatioParser();
        final style = parser.parse(const WindStyle(), [
          'aspect-auto',
        ], createTestContext());

        expect(style.aspectRatio, isNull);
      });

      test('parses aspect-[4/3]', () {
        final parser = const AspectRatioParser();
        final style = parser.parse(const WindStyle(), [
          'aspect-[4/3]',
        ], createTestContext());

        expect(style.aspectRatio, 4 / 3);
      });

      test('parses aspect-[16/9]', () {
        final parser = const AspectRatioParser();
        final style = parser.parse(const WindStyle(), [
          'aspect-[16/9]',
        ], createTestContext());

        expect(style.aspectRatio, 16 / 9);
      });

      test('parses aspect-[21/9]', () {
        final parser = const AspectRatioParser();
        final style = parser.parse(const WindStyle(), [
          'aspect-[21/9]',
        ], createTestContext());

        expect(style.aspectRatio, 21 / 9);
      });

      test('last class wins', () {
        final parser = const AspectRatioParser();
        final style = parser.parse(const WindStyle(), [
          'aspect-square',
          'aspect-video',
        ], createTestContext());

        expect(style.aspectRatio, 16 / 9);
      });

      test('returns original style when classes is null', () {
        final parser = const AspectRatioParser();
        const originalStyle = WindStyle();
        final style = parser.parse(originalStyle, null, createTestContext());

        expect(style, originalStyle);
      });
    });
  });
}
