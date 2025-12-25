import 'package:flutter/widgets.dart';
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
  group('OverflowParser Tests', () {
    group('canParse', () {
      test('returns true for overflow-hidden', () {
        expect(const OverflowParser().canParse('overflow-hidden'), isTrue);
      });

      test('returns true for overflow-visible', () {
        expect(const OverflowParser().canParse('overflow-visible'), isTrue);
      });

      test('returns true for overflow-x-scroll', () {
        expect(const OverflowParser().canParse('overflow-x-scroll'), isTrue);
      });

      test('returns true for overflow-y-hidden', () {
        expect(const OverflowParser().canParse('overflow-y-hidden'), isTrue);
      });

      test('returns false for non-overflow classes', () {
        expect(const OverflowParser().canParse('bg-red-500'), isFalse);
        expect(const OverflowParser().canParse('text-lg'), isFalse);
        expect(const OverflowParser().canParse('z-10'), isFalse);
      });
    });

    group('parse', () {
      test('parses overflow-hidden', () {
        final parser = const OverflowParser();
        final style = parser.parse(const WindStyle(), [
          'overflow-hidden',
        ], createTestContext());

        expect(style.overflow, WindOverflow.hidden);
        expect(style.clipBehavior, Clip.hardEdge);
      });

      test('parses overflow-visible', () {
        final parser = const OverflowParser();
        final style = parser.parse(const WindStyle(), [
          'overflow-visible',
        ], createTestContext());

        expect(style.overflow, WindOverflow.visible);
        expect(style.clipBehavior, Clip.none);
      });

      test('parses overflow-scroll', () {
        final parser = const OverflowParser();
        final style = parser.parse(const WindStyle(), [
          'overflow-scroll',
        ], createTestContext());

        expect(style.overflow, WindOverflow.scroll);
      });

      test('parses overflow-auto', () {
        final parser = const OverflowParser();
        final style = parser.parse(const WindStyle(), [
          'overflow-auto',
        ], createTestContext());

        expect(style.overflow, WindOverflow.auto);
      });

      test('parses overflow-x-scroll', () {
        final parser = const OverflowParser();
        final style = parser.parse(const WindStyle(), [
          'overflow-x-scroll',
        ], createTestContext());

        expect(style.overflowX, WindOverflow.scroll);
      });

      test('parses overflow-y-hidden', () {
        final parser = const OverflowParser();
        final style = parser.parse(const WindStyle(), [
          'overflow-y-hidden',
        ], createTestContext());

        expect(style.overflowY, WindOverflow.hidden);
        expect(style.clipBehavior, Clip.hardEdge);
      });

      test('last class wins', () {
        final parser = const OverflowParser();
        final style = parser.parse(const WindStyle(), [
          'overflow-hidden',
          'overflow-scroll',
        ], createTestContext());

        expect(style.overflow, WindOverflow.scroll);
      });

      test('returns original style when classes is null', () {
        final parser = const OverflowParser();
        const originalStyle = WindStyle();
        final style = parser.parse(originalStyle, null, createTestContext());

        expect(style, originalStyle);
      });
    });
  });
}
