import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/src/parser/parsers/flexbox_grid_parser.dart';
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
  group('FlexboxGridParser', () {
    late FlexboxGridParser parser;
    late WindContext context;

    setUp(() {
      parser = const FlexboxGridParser();
      context = createTestContext();
    });

    group('parse', () {
      test('parses flex display class', () {
        final styles = parser.parse(WindStyle(), ['flex'], context);
        expect(styles.displayType, WindDisplayType.flex);
      });

      test('parses grid-cols class', () {
        final styles = parser.parse(WindStyle(), ['grid-cols-3'], context);
        expect(styles.gridCols, 3);
      });

      test('parses gap-x and gap-y classes', () {
        final styles = parser.parse(WindStyle(), [
          'gap-x-4',
          'gap-y-2',
        ], context);
        expect(styles.gapX, 16.0); // Assuming theme spacing of 4 = 16.0
        expect(styles.gapY, 8.0); // Assuming theme spacing of 2 = 8.0
      });

      test('applies last class wins rule', () {
        final styles = parser.parse(WindStyle(), [
          'flex',
          'grid',
          'flex',
        ], context);
        expect(styles.displayType, WindDisplayType.flex);
      });

      test('returns unchanged styles if no relevant classes', () {
        final initialStyles = WindStyle();
        final styles = parser.parse(initialStyles, [
          'text-center',
          'bg-red-500',
        ], context);
        expect(styles, initialStyles);
      });

      test('parses arbitrary gap class', () {
        final styles = parser.parse(WindStyle(), ['gap-[10px]'], context);
        expect(styles.gapX, 10.0);
        expect(styles.gapY, 10.0);
      });

      test('parses flex value class', () {
        final styles = parser.parse(WindStyle(), ['flex-3'], context);
        expect(styles.flex, 3);
      });

      test('parses multiple classes correctly', () {
        final styles = parser.parse(WindStyle(), [
          'flex',
          'flex-col',
          'justify-center',
          'items-end',
          'gap-2',
        ], context);
        expect(styles.displayType, WindDisplayType.flex);
        expect(styles.flexDirection, Axis.vertical);
        expect(styles.mainAxisAlignment, MainAxisAlignment.center);
        expect(styles.crossAxisAlignment, CrossAxisAlignment.end);
        expect(styles.gapX, 8.0); // Assuming theme spacing of 2 = 8.0
        expect(styles.gapY, 8.0);
      });

      test('parses mainAxisSize class', () {
        final styles = parser.parse(WindStyle(), ['axis-min'], context);
        expect(styles.mainAxisSize, MainAxisSize.min);
      });

      test('parses align-self class', () {
        final styles = parser.parse(WindStyle(), [
          'align-self-center',
        ], context);
        expect(styles.alignment, Alignment.center);
      });

      test('parses flexFit class', () {
        final styles = parser.parse(WindStyle(), ['flex-auto'], context);
        expect(styles.flexFit, FlexFit.loose);
      });

      test('returns unchanged styles when classes is null', () {
        final initialStyles = WindStyle();
        final styles = parser.parse(initialStyles, null, context);
        expect(styles, initialStyles);
      });
    });

    group('canParse', () {
      test('returns true for flex related classes', () {
        expect(parser.canParse('flex'), isTrue);
        expect(parser.canParse('flex-row'), isTrue);
        expect(parser.canParse('justify-center'), isTrue);
        expect(parser.canParse('items-start'), isTrue);
        expect(parser.canParse('gap-4'), isTrue);
        expect(parser.canParse('axis-min'), isTrue);
      });

      test('returns true for grid related classes', () {
        expect(parser.canParse('grid'), isTrue);
        expect(parser.canParse('grid-cols-3'), isTrue);
      });

      test('returns false for unrelated classes', () {
        expect(parser.canParse('text-center'), isFalse);
        expect(parser.canParse('bg-red-500'), isFalse);
        expect(parser.canParse('p-4'), isFalse);
      });
    });
  });
}
