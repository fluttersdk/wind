import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/src/parser/parsers/sizing_parser.dart';
import 'package:fluttersdk_wind/src/parser/wind_context.dart';
import 'package:fluttersdk_wind/src/parser/wind_style.dart';
import 'package:fluttersdk_wind/src/theme/wind_theme_data.dart';

// Helper function to create a WindContext for testing
WindContext createTestContext({
  bool isHovering = false,
  bool isFocused = false,
  bool isDisabled = false,
  String activeBreakpoint = 'base',
  Brightness brightness = Brightness.light,
  String platform = 'unknown',
  bool isMobile = false,
}) {
  return WindContext(
    theme: WindThemeData().copyWith(brightness: brightness),
    isHovering: isHovering,
    isFocused: isFocused,
    isDisabled: isDisabled,
    activeBreakpoint: activeBreakpoint,
    platform: platform,
    isMobile: isMobile,
    screenWidth: 400,
    screenHeight: 800,
  );
}

void main() {
  group('SizingParser', () {
    late SizingParser parser;
    late WindContext context;

    setUp(() {
      parser = const SizingParser();
      context = createTestContext();
    });

    group('parse', () {
      test('parses width classes correctly', () {
        final styles = WindStyle();
        final classes = ['w-100', 'w-[50%]'];
        final updatedStyles = parser.parse(styles, classes, context);
        expect(updatedStyles.width, 100);
        expect(updatedStyles.widthFactor, 0.5);
      });

      test('parses height classes correctly', () {
        final styles = WindStyle();
        final classes = ['h-200', 'h-[25%]'];
        final updatedStyles = parser.parse(styles, classes, context);
        expect(updatedStyles.height, 200);
        expect(updatedStyles.heightFactor, 0.25);
      });

      test('parses max-width classes correctly', () {
        final styles = WindStyle();
        final classes = ['max-w-300', 'max-w-screen'];
        final updatedStyles = parser.parse(styles, classes, context);
        expect(updatedStyles.constraints?.maxWidth, context.screenWidth);
      });

      test('parses min-height classes correctly', () {
        final styles = WindStyle();
        final classes = ['min-h-150', 'min-h-[10%]'];
        final updatedStyles = parser.parse(styles, classes, context);
        expect(updatedStyles.constraints?.minHeight, 150);
      });

      test('ignores non-sizing classes', () {
        final styles = WindStyle();
        final classes = ['text-red-500', 'bg-blue-200', 'p-4'];
        final updatedStyles = parser.parse(styles, classes, context);
        // Should control sizing properties only
        expect(updatedStyles.width, styles.width);
        expect(updatedStyles.height, styles.height);
        expect(updatedStyles.widthFactor, styles.widthFactor);
        expect(updatedStyles.heightFactor, styles.heightFactor);
        expect(updatedStyles.constraints, styles.constraints);
      });

      test('handles empty class list', () {
        final styles = WindStyle();
        final classes = <String>[];
        final updatedStyles = parser.parse(styles, classes, context);
        expect(updatedStyles, styles);
      });
    });

    group('canParse', () {
      test('returns true for width classes', () {
        expect(parser.canParse('w-10'), isTrue);
        expect(parser.canParse('w-full'), isTrue);
        expect(parser.canParse('w-1/2'), isTrue);
        expect(parser.canParse('w-[100]'), isTrue);
      });

      test('returns true for height classes', () {
        expect(parser.canParse('h-20'), isTrue);
        expect(parser.canParse('h-screen'), isTrue);
        expect(parser.canParse('h-3/4'), isTrue);
        expect(parser.canParse('h-[150]'), isTrue);
      });

      test('returns true for max-width classes', () {
        expect(parser.canParse('max-w-sm'), isTrue);
        expect(parser.canParse('max-w-full'), isTrue);
      });

      test('returns true for max-height classes', () {
        expect(parser.canParse('max-h-lg'), isTrue);
        expect(parser.canParse('max-h-screen'), isTrue);
      });

      test('returns true for min-width classes', () {
        expect(parser.canParse('min-w-0'), isTrue);
        expect(parser.canParse('min-w-full'), isTrue);
      });

      test('returns true for min-height classes', () {
        expect(parser.canParse('min-h-0'), isTrue);
        expect(parser.canParse('min-h-screen'), isTrue);
      });

      test('returns false for non-sizing classes', () {
        expect(parser.canParse('text-red-500'), isFalse);
        expect(parser.canParse('bg-blue-200'), isFalse);
        expect(parser.canParse('p-4'), isFalse);
        expect(parser.canParse(''), isFalse);
      });
    });
  });
}

