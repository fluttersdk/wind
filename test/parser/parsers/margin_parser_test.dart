import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/src/parser/parsers/margin_parser.dart';
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
  group('MarginParser', () {
    late MarginParser parser;
    late WindContext context;

    setUp(() {
      parser = const MarginParser();
      context = createTestContext();
    });

    group('parse', () {
      test('parses theme-based margin classes', () {
        final styles = WindStyle();
        final classes = ['m-4', 'mt-8', 'mx-2'];
        final updatedStyles = parser.parse(styles, classes, context);

        expect(
          updatedStyles.margin,
          EdgeInsets.only(
            top: 32.0, // mt-8
            bottom: 16.0, // m-4
            left: 8.0, // mx-2
            right: 8.0, // mx-2
          ),
        );
      });

      test('parses arbitrary margin classes', () {
        final styles = WindStyle();
        final classes = ['m-[10px]', 'mt-[20px]', 'mx-[5px]'];
        final updatedStyles = parser.parse(styles, classes, context);

        expect(
          updatedStyles.margin,
          EdgeInsets.only(
            top: 20.0, // mt-[20px]
            bottom: 10.0, // m-[10px]
            left: 5.0, // mx-[5px]
            right: 5.0, // mx-[5px]
          ),
        );
      });

      test('last class wins for conflicting margin classes', () {
        final styles = WindStyle();
        final classes = ['m-4', 'mt-8', 'm-2'];
        final updatedStyles = parser.parse(styles, classes, context);

        expect(
          updatedStyles.margin,
          EdgeInsets.only(
            top: 8.0, // m-2
            bottom: 8.0, // m-2
            left: 8.0, // m-2
            right: 8.0, // m-2
          ),
        );
      });

      test('returns original styles if no margin classes found', () {
        final styles = WindStyle(margin: EdgeInsets.all(12.0));
        final classes = ['p-4', 'bg-red-500'];
        final updatedStyles = parser.parse(styles, classes, context);

        expect(updatedStyles.margin, styles.margin);
      });

      test(
        'returns null margin if no margin classes and original margin is null',
        () {
          final styles = WindStyle();
          final classes = ['p-4', 'bg-red-500'];
          final updatedStyles = parser.parse(styles, classes, context);

          expect(updatedStyles.margin, isNull);
        },
      );

      test('handles null classes gracefully', () {
        final styles = WindStyle(margin: EdgeInsets.all(12.0));
        final updatedStyles = parser.parse(styles, null, context);

        expect(updatedStyles.margin, styles.margin);
      });
    });

    group('canParse', () {
      test('returns true for margin-related classes', () {
        expect(parser.canParse('m-4'), isTrue);
        expect(parser.canParse('mt-2'), isTrue);
        expect(parser.canParse('mb-6'), isTrue);
        expect(parser.canParse('ml-3'), isTrue);
        expect(parser.canParse('mr-5'), isTrue);
        expect(parser.canParse('mx-1/2'), isTrue);
        expect(parser.canParse('my-8'), isTrue);
        expect(parser.canParse('m-[10px]'), isTrue);
        expect(parser.canParse('mt-[5px]'), isTrue);
      });

      test('returns false for non-margin classes', () {
        expect(parser.canParse('p-4'), isFalse);
        expect(parser.canParse('bg-red-500'), isFalse);
        expect(parser.canParse('text-lg'), isFalse);
        expect(parser.canParse('flex'), isFalse);
      });

      test('returns false for empty string', () {
        expect(parser.canParse(''), isFalse);
      });
    });

    group('unknown theme tokens', () {
      test('drops m-<unknown-token> silently instead of throwing', () {
        final styles = WindStyle();
        final classes = ['m-primary', 'mx-foo', 'my-bar'];

        expect(
          () => parser.parse(styles, classes, context),
          returnsNormally,
        );
        expect(parser.parse(styles, classes, context).margin, isNull);
      });
    });
  });
}
