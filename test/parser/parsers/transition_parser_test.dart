import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';
import 'package:fluttersdk_wind/src/parser/parsers/transition_parser.dart';

WindContext createTestContext() {
  return WindContext(
    theme: WindThemeData(),
    activeBreakpoint: 'base',
    platform: 'macos',
    isMobile: false,
    screenWidth: 1024,
    screenHeight: 768,
  );
}

void main() {
  group('TransitionParser', () {
    group('canParse', () {
      test('returns true for duration classes', () {
        expect(const TransitionParser().canParse('duration-300'), isTrue);
        expect(const TransitionParser().canParse('duration-1000'), isTrue);
        expect(const TransitionParser().canParse('duration-[500ms]'), isTrue);
      });

      test('returns true for ease classes', () {
        expect(const TransitionParser().canParse('ease-in'), isTrue);
        expect(const TransitionParser().canParse('ease-out'), isTrue);
        expect(const TransitionParser().canParse('ease-in-out'), isTrue);
        expect(const TransitionParser().canParse('ease-linear'), isTrue);
      });

      test('returns false for unrelated classes', () {
        expect(const TransitionParser().canParse('bg-red-500'), isFalse);
        expect(const TransitionParser().canParse('text-lg'), isFalse);
      });
    });

    group('parse', () {
      test('parses duration-300', () {
        final style = const TransitionParser().parse(
            const WindStyle(),
            [
              'duration-300',
            ],
            createTestContext());
        expect(style.transitionDuration, const Duration(milliseconds: 300));
      });

      test('parses duration-1000', () {
        final style = const TransitionParser().parse(
            const WindStyle(),
            [
              'duration-1000',
            ],
            createTestContext());
        expect(style.transitionDuration, const Duration(milliseconds: 1000));
      });

      test('parses arbitrary duration-[500ms]', () {
        final style = const TransitionParser().parse(
            const WindStyle(),
            [
              'duration-[500ms]',
            ],
            createTestContext());
        expect(style.transitionDuration, const Duration(milliseconds: 500));
      });

      test('parses arbitrary duration-[250]', () {
        final style = const TransitionParser().parse(
            const WindStyle(),
            [
              'duration-[250]',
            ],
            createTestContext());
        expect(style.transitionDuration, const Duration(milliseconds: 250));
      });

      test('parses ease-in', () {
        final style = const TransitionParser().parse(
            const WindStyle(),
            [
              'ease-in',
            ],
            createTestContext());
        expect(style.transitionCurve, Curves.easeIn);
      });

      test('parses ease-out', () {
        final style = const TransitionParser().parse(
            const WindStyle(),
            [
              'ease-out',
            ],
            createTestContext());
        expect(style.transitionCurve, Curves.easeOut);
      });

      test('parses ease-in-out', () {
        final style = const TransitionParser().parse(
            const WindStyle(),
            [
              'ease-in-out',
            ],
            createTestContext());
        expect(style.transitionCurve, Curves.easeInOut);
      });

      test('parses ease-linear', () {
        final style = const TransitionParser().parse(
            const WindStyle(),
            [
              'ease-linear',
            ],
            createTestContext());
        expect(style.transitionCurve, Curves.linear);
      });

      test('parses duration and ease together', () {
        final style = const TransitionParser().parse(
            const WindStyle(),
            [
              'duration-300',
              'ease-in-out',
            ],
            createTestContext());
        expect(style.transitionDuration, const Duration(milliseconds: 300));
        expect(style.transitionCurve, Curves.easeInOut);
      });

      test('last class wins for duration', () {
        final style = const TransitionParser().parse(
            const WindStyle(),
            [
              'duration-100',
              'duration-500',
            ],
            createTestContext());
        expect(style.transitionDuration, const Duration(milliseconds: 500));
      });

      test('last class wins for ease', () {
        final style = const TransitionParser().parse(
            const WindStyle(),
            [
              'ease-in',
              'ease-out',
            ],
            createTestContext());
        expect(style.transitionCurve, Curves.easeOut);
      });
    });
  });
}
