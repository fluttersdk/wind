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
        final styles = parser.parse(
            WindStyle(),
            [
              'gap-x-4',
              'gap-y-2',
            ],
            context);
        expect(styles.gapX, 16.0); // Assuming theme spacing of 4 = 16.0
        expect(styles.gapY, 8.0); // Assuming theme spacing of 2 = 8.0
      });

      test('applies last class wins rule', () {
        final styles = parser.parse(
            WindStyle(),
            [
              'flex',
              'grid',
              'flex',
            ],
            context);
        expect(styles.displayType, WindDisplayType.flex);
      });

      test('returns unchanged styles if no relevant classes', () {
        final initialStyles = WindStyle();
        final styles = parser.parse(
            initialStyles,
            [
              'text-center',
              'bg-red-500',
            ],
            context);
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
        final styles = parser.parse(
            WindStyle(),
            [
              'flex',
              'flex-col',
              'justify-center',
              'items-end',
              'gap-2',
            ],
            context);
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
        final styles = parser.parse(
            WindStyle(),
            [
              'align-self-center',
            ],
            context);
        expect(styles.alignment, Alignment.center);
      });

      test('parses container alignment classes', () {
        var styles = parser.parse(WindStyle(), ['align-top-left'], context);
        // Container alignment classes are removed/reverted.
        // If they map to nothing now, expect null.
        // Or if I removed the map entirely, they should be ignored.
        // I removed the logic. So they should be ignored.
        // Wait, if I removed `_containerAlignmentMap`, 'align-top-left' is unknown.
        // So alignment should be null.
        expect(styles.alignment, isNull);
      });

      test('parses flexFit class', () {
        final styles = parser.parse(WindStyle(), ['flex-auto'], context);
        expect(styles.flexFit, FlexFit.loose);
      });

      test('parses shrink class', () {
        final styles = parser.parse(WindStyle(), ['shrink'], context);
        expect(styles.flexFit, FlexFit.loose);
      });

      test('parses shrink-0 class', () {
        final styles = parser.parse(WindStyle(), ['shrink-0'], context);
        expect(styles.flexFit, FlexFit.tight);
      });

      test('parses items-baseline class', () {
        final styles = parser.parse(WindStyle(), ['items-baseline'], context);
        expect(styles.crossAxisAlignment, CrossAxisAlignment.baseline);
        expect(styles.textBaseline, TextBaseline.alphabetic);
      });

      test('applies last-class-wins for shrink', () {
        final styles =
            parser.parse(WindStyle(), ['shrink', 'shrink-0'], context);
        expect(styles.flexFit, FlexFit.tight);
      });

      test('returns unchanged styles when classes is null', () {
        final initialStyles = WindStyle();
        final styles = parser.parse(initialStyles, null, context);
        expect(styles, initialStyles);
      });
    });

    group('Flex Shrink & Baseline', () {
      test('shrink -> FlexFit.loose', () {
        final styles = parser.parse(WindStyle(), ['shrink'], context);
        expect(styles.flexFit, FlexFit.loose);
      });

      test('shrink-0 -> FlexFit.tight', () {
        final styles = parser.parse(WindStyle(), ['shrink-0'], context);
        expect(styles.flexFit, FlexFit.tight);
      });

      test(
          'items-baseline -> CrossAxisAlignment.baseline and TextBaseline.alphabetic',
          () {
        final styles = parser.parse(WindStyle(), ['items-baseline'], context);
        expect(styles.crossAxisAlignment, CrossAxisAlignment.baseline);
        expect(styles.textBaseline, TextBaseline.alphabetic);
      });

      test('last-class-wins override logic', () {
        // Flex shrink overrides
        expect(
          parser.parse(WindStyle(), ['shrink', 'shrink-0'], context).flexFit,
          FlexFit.tight,
        );
        expect(
          parser.parse(WindStyle(), ['shrink-0', 'shrink'], context).flexFit,
          FlexFit.loose,
        );

        // Baseline overrides
        final baselineStyles = parser.parse(
          WindStyle(),
          ['items-center', 'items-baseline'],
          context,
        );
        expect(baselineStyles.crossAxisAlignment, CrossAxisAlignment.baseline);
        expect(baselineStyles.textBaseline, TextBaseline.alphabetic);

        final centerStyles = parser.parse(
          WindStyle(),
          ['items-baseline', 'items-center'],
          context,
        );
        expect(centerStyles.crossAxisAlignment, CrossAxisAlignment.center);
        expect(centerStyles.textBaseline, isNull);
      });
    });

    group('canParse', () {
      test('returns true for flex related classes', () {
        expect(parser.canParse('flex'), isTrue);
        expect(parser.canParse('flex-row'), isTrue);
        expect(parser.canParse('justify-center'), isTrue);
        expect(parser.canParse('items-start'), isTrue);
        expect(parser.canParse('items-baseline'), isTrue);
        expect(parser.canParse('shrink'), isTrue);
        expect(parser.canParse('shrink-0'), isTrue);
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
