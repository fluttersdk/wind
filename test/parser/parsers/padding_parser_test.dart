import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/src/parser/parsers/padding_parser.dart';
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
    activeBreakpoint: activeBreakpoint,
    platform: platform,
    isMobile: isMobile,
    screenWidth: 400,
    screenHeight: 800,
    activeStates: {
      if (isHovering) 'hover',
      if (isFocused) 'focus',
      if (isDisabled) 'disabled',
    },
  );
}

void main() {
  group('PaddingParser', () {
    late PaddingParser parser;
    late WindContext context;

    setUp(() {
      parser = const PaddingParser();
      context = createTestContext();
    });

    group('parse', () {
      test('parses theme-based padding classes', () {
        final styles = WindStyle();
        final classes = ['p-4', 'pt-8', 'px-2'];
        final updatedStyles = parser.parse(styles, classes, context);

        expect(
          updatedStyles.padding,
          EdgeInsets.only(
            top: 32.0, // pt-8
            bottom: 16.0, // p-4
            left: 8.0, // px-2
            right: 8.0, // px-2
          ),
        );
      });

      test('parses arbitrary padding classes', () {
        final styles = WindStyle();
        final classes = ['p-[10px]', 'pt-[20px]', 'px-[5px]'];
        final updatedStyles = parser.parse(styles, classes, context);

        expect(
          updatedStyles.padding,
          EdgeInsets.only(
            top: 20.0, // pt-[20px]
            bottom: 10.0, // p-[10px]
            left: 5.0, // px-[5px]
            right: 5.0, // px-[5px]
          ),
        );
      });

      test('last class wins for conflicting padding classes', () {
        final styles = WindStyle();
        final classes = ['p-4', 'pt-8', 'p-2'];
        final updatedStyles = parser.parse(styles, classes, context);

        expect(
          updatedStyles.padding,
          EdgeInsets.only(
            top: 8.0, // p-2
            bottom: 8.0, // p-2
            left: 8.0, // p-2
            right: 8.0, // p-2
          ),
        );
      });

      test('returns original styles if no padding classes found', () {
        final styles = WindStyle();
        final classes = ['text-red-500', 'bg-blue-200'];
        final updatedStyles = parser.parse(styles, classes, context);

        expect(updatedStyles, styles);
      });

      test('handles null classes gracefully', () {
        final styles = WindStyle();
        final updatedStyles = parser.parse(styles, null, context);

        expect(updatedStyles, styles);
      });
    });

    group('canParse', () {
      test('returns true for padding-related classes', () {
        expect(parser.canParse('p-4'), isTrue);
        expect(parser.canParse('pt-2'), isTrue);
        expect(parser.canParse('pb-6'), isTrue);
        expect(parser.canParse('pl-3'), isTrue);
        expect(parser.canParse('pr-5'), isTrue);
        expect(parser.canParse('px-1/2'), isTrue);
        expect(parser.canParse('py-8'), isTrue);
        expect(parser.canParse('p-[10px]'), isTrue);
        expect(parser.canParse('pt-[5px]'), isTrue);
      });

      test('returns false for non-padding classes', () {
        expect(parser.canParse('m-4'), isFalse);
        expect(parser.canParse('bg-red-500'), isFalse);
        expect(parser.canParse('text-lg'), isFalse);
        expect(parser.canParse('flex'), isFalse);
      });

      test('returns false for empty string', () {
        expect(parser.canParse(''), isFalse);
      });
    });
  });
}
