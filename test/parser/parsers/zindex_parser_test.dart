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
  group('ZIndexParser Tests', () {
    group('canParse', () {
      test('returns true for z-0', () {
        expect(const ZIndexParser().canParse('z-0'), isTrue);
      });

      test('returns true for z-10', () {
        expect(const ZIndexParser().canParse('z-10'), isTrue);
      });

      test('returns true for z-auto', () {
        expect(const ZIndexParser().canParse('z-auto'), isTrue);
      });

      test('returns true for z-[100]', () {
        expect(const ZIndexParser().canParse('z-[100]'), isTrue);
      });

      test('returns false for non-z-index classes', () {
        expect(const ZIndexParser().canParse('bg-red-500'), isFalse);
        expect(const ZIndexParser().canParse('text-lg'), isFalse);
        expect(const ZIndexParser().canParse('p-4'), isFalse);
        expect(const ZIndexParser().canParse('flex'), isFalse);
      });
    });

    group('parse', () {
      test('parses z-0', () {
        final parser = const ZIndexParser();
        final style = parser.parse(const WindStyle(), [
          'z-0',
        ], createTestContext());

        expect(style.zIndex, 0);
      });

      test('parses z-10', () {
        final parser = const ZIndexParser();
        final style = parser.parse(const WindStyle(), [
          'z-10',
        ], createTestContext());

        expect(style.zIndex, 10);
      });

      test('parses z-50', () {
        final parser = const ZIndexParser();
        final style = parser.parse(const WindStyle(), [
          'z-50',
        ], createTestContext());

        expect(style.zIndex, 50);
      });

      test('parses arbitrary z-[100]', () {
        final parser = const ZIndexParser();
        final style = parser.parse(const WindStyle(), [
          'z-[100]',
        ], createTestContext());

        expect(style.zIndex, 100);
      });

      test('parses negative z-[-5]', () {
        final parser = const ZIndexParser();
        final style = parser.parse(const WindStyle(), [
          'z-[-5]',
        ], createTestContext());

        expect(style.zIndex, -5);
      });

      test('z-auto returns null', () {
        final parser = const ZIndexParser();
        final style = parser.parse(const WindStyle(), [
          'z-auto',
        ], createTestContext());

        expect(style.zIndex, isNull);
      });

      test('z-auto overrides previous z-index', () {
        final parser = const ZIndexParser();
        final style = parser.parse(const WindStyle(), [
          'z-10',
          'z-auto',
        ], createTestContext());

        expect(style.zIndex, isNull);
      });

      test('last class wins', () {
        final parser = const ZIndexParser();
        final style = parser.parse(const WindStyle(), [
          'z-10',
          'z-30',
        ], createTestContext());

        expect(style.zIndex, 30);
      });

      test('returns original style when classes is null', () {
        final parser = const ZIndexParser();
        const originalStyle = WindStyle();
        final style = parser.parse(originalStyle, null, createTestContext());

        expect(style, originalStyle);
      });

      test('returns original style unchanged for non-z-index classes', () {
        final parser = const ZIndexParser();
        final style = parser.parse(const WindStyle(), [
          'bg-red-500',
          'text-lg',
        ], createTestContext());

        expect(style.zIndex, isNull);
      });

      test('ignores invalid arbitrary values like z-[abc]', () {
        final parser = const ZIndexParser();
        final style = parser.parse(const WindStyle(), [
          'z-[abc]',
        ], createTestContext());

        expect(style.zIndex, isNull);
      });
    });
  });
}
