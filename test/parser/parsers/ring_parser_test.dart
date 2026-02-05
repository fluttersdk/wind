import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Helper function to create a test WindContext
WindContext createTestContext({Color? ringColor}) {
  return WindContext(
    theme: WindThemeData(ringColor: ringColor ?? const Color(0xFF3B82F6)),
    activeBreakpoint: 'base',
    platform: 'macos',
    isMobile: false,
    screenWidth: 1024,
    screenHeight: 768,
  );
}

void main() {
  group('RingParser Tests', () {
    group('canParse', () {
      test('returns true for ring', () {
        expect(const RingParser().canParse('ring'), isTrue);
      });

      test('returns true for ring-2', () {
        expect(const RingParser().canParse('ring-2'), isTrue);
      });

      test('returns true for ring-blue-500', () {
        expect(const RingParser().canParse('ring-blue-500'), isTrue);
      });

      test('returns true for ring-offset-2', () {
        expect(const RingParser().canParse('ring-offset-2'), isTrue);
      });

      test('returns true for ring-inset', () {
        expect(const RingParser().canParse('ring-inset'), isTrue);
      });

      test('returns false for non-ring classes', () {
        expect(const RingParser().canParse('bg-red-500'), isFalse);
        expect(const RingParser().canParse('border-2'), isFalse);
      });
    });

    group('parse', () {
      test('parses basic ring class', () {
        final parser = const RingParser();
        final style = parser.parse(
            const WindStyle(),
            [
              'ring',
            ],
            createTestContext());

        expect(style.ringWidth, 3.0);
        expect(style.ringShadow, isNotNull);
        expect(style.ringShadow!.length, 1);
      });

      test('parses ring-2', () {
        final parser = const RingParser();
        final style = parser.parse(
            const WindStyle(),
            [
              'ring-2',
            ],
            createTestContext());

        expect(style.ringWidth, 2.0);
      });

      test('parses ring-0 (no ring)', () {
        final parser = const RingParser();
        final style = parser.parse(
            const WindStyle(),
            [
              'ring-0',
            ],
            createTestContext());

        expect(style.ringWidth, 0.0);
      });

      test('parses ring color', () {
        final parser = const RingParser();
        final style = parser.parse(
            const WindStyle(),
            [
              'ring-2',
              'ring-red-500',
            ],
            createTestContext());

        expect(style.ringColor, isNotNull);
        expect(style.ringColor!.r, closeTo(0.937, 0.01)); // red-500
      });

      test('parses arbitrary ring color', () {
        final parser = const RingParser();
        final style = parser.parse(
            const WindStyle(),
            [
              'ring-2',
              'ring-[#FF0000]',
            ],
            createTestContext());

        expect(style.ringColor, isNotNull);
        expect(style.ringColor!.r, closeTo(1.0, 0.01));
        expect(style.ringColor!.g, closeTo(0.0, 0.01));
      });

      test('parses ring with opacity', () {
        final parser = const RingParser();
        final style = parser.parse(
            const WindStyle(),
            [
              'ring-2',
              'ring-blue-500/50',
            ],
            createTestContext());

        expect(style.ringColor, isNotNull);
        expect(style.ringColor!.a, closeTo(0.5, 0.01));
      });

      test('parses ring-offset', () {
        final parser = const RingParser();
        final style = parser.parse(
            const WindStyle(),
            [
              'ring-2',
              'ring-offset-2',
            ],
            createTestContext());

        expect(style.ringOffset, 2.0);
      });

      test('parses ring-inset', () {
        final parser = const RingParser();
        final style = parser.parse(
            const WindStyle(),
            [
              'ring-2',
              'ring-inset',
            ],
            createTestContext());

        expect(style.ringInset, isTrue);
      });

      test('uses theme ringColor as default', () {
        final customRingColor = Colors.purple;
        final parser = const RingParser();
        final style = parser.parse(
            const WindStyle(),
            [
              'ring-2',
            ],
            createTestContext(ringColor: customRingColor));

        expect(style.ringColor, customRingColor);
      });

      test('last class wins for ring width', () {
        final parser = const RingParser();
        final style = parser.parse(
            const WindStyle(),
            [
              'ring-4',
              'ring-2',
            ],
            createTestContext());

        expect(style.ringWidth, 2.0);
      });

      test('returns original style when classes is null', () {
        final parser = const RingParser();
        const originalStyle = WindStyle();
        final style = parser.parse(originalStyle, null, createTestContext());

        expect(style, originalStyle);
      });

      test('returns original style when no ring classes', () {
        final parser = const RingParser();
        const originalStyle = WindStyle();
        final style = parser.parse(
            originalStyle,
            [
              'bg-red-500',
            ],
            createTestContext());

        expect(style.ringShadow, isNull);
      });
      test('parses custom ring width from theme', () {
        final parser = const RingParser();
        final theme = WindThemeData(ringWidths: {'custom': 10.0});
        final context = WindContext(
          theme: theme,
          activeBreakpoint: 'base',
          platform: 'macos',
          isMobile: false,
          screenWidth: 1024,
          screenHeight: 768,
        );

        final style = parser.parse(const WindStyle(), ['ring-custom'], context);

        expect(style.ringWidth, 10.0);
      });

      test('parses custom ring offset from theme', () {
        final parser = const RingParser();
        final theme = WindThemeData(ringOffsets: {'custom': 5.0});
        final context = WindContext(
          theme: theme,
          activeBreakpoint: 'base',
          platform: 'macos',
          isMobile: false,
          screenWidth: 1024,
          screenHeight: 768,
        );

        final style = parser.parse(
            const WindStyle(),
            [
              'ring-2',
              'ring-offset-custom',
            ],
            context);

        expect(style.ringOffset, 5.0);
      });
    });
  });
}
