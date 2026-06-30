import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/src/parser/parsers/sizing_parser.dart';
import 'package:fluttersdk_wind/src/parser/wind_context.dart';
import 'package:fluttersdk_wind/src/parser/wind_parser.dart';
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
  group('SizingParser', () {
    late SizingParser parser;
    late WindContext context;

    setUp(() {
      WindParser.clearCache();
      parser = const SizingParser();
      context = createTestContext();
    });

    group('parse', () {
      test('parses width classes correctly', () {
        final styles = WindStyle();
        final classes = ['w-100', 'w-[50%]'];
        final updatedStyles = parser.parse(styles, classes, context);
        expect(updatedStyles.width, 400);
        expect(updatedStyles.widthFactor, 0.5);
      });

      test('parses height classes correctly', () {
        final styles = WindStyle();
        final classes = ['h-200', 'h-[25%]'];
        final updatedStyles = parser.parse(styles, classes, context);
        expect(updatedStyles.height, 800);
        expect(updatedStyles.heightFactor, 0.25);
      });

      test('parses size-N as both width and height (theme spacing)', () {
        final styles = parser.parse(WindStyle(), ['size-2'], context);
        expect(styles.width, 8);
        expect(styles.height, 8);
      });

      test('parses size-full as both width and height factors', () {
        final styles = parser.parse(WindStyle(), ['size-full'], context);
        expect(styles.widthFactor, 1.0);
        expect(styles.heightFactor, 1.0);
      });

      test('parses size fraction as both factors', () {
        final styles = parser.parse(WindStyle(), ['size-1/2'], context);
        expect(styles.widthFactor, 0.5);
        expect(styles.heightFactor, 0.5);
      });

      test('parses arbitrary size px and percent', () {
        final px = parser.parse(WindStyle(), ['size-[20px]'], context);
        expect(px.width, 20);
        expect(px.height, 20);

        final pct = parser.parse(WindStyle(), ['size-[50%]'], context);
        expect(pct.widthFactor, 0.5);
        expect(pct.heightFactor, 0.5);
      });

      test('parses size-screen as viewport dimensions', () {
        final styles = parser.parse(WindStyle(), ['size-screen'], context);
        expect(styles.width, context.screenWidth);
        expect(styles.height, context.screenHeight);
      });

      test('a later w-* overrides the width set by size-*', () {
        // Reverse-iteration last-wins: w-10 (after size-2) wins on width,
        // size-2 still supplies height.
        final styles = parser.parse(WindStyle(), ['size-2', 'w-10'], context);
        expect(styles.width, 40);
        expect(styles.height, 8);
      });

      test('parses max-width classes correctly', () {
        final styles = WindStyle();
        final classes = ['max-w-300', 'max-w-screen'];
        final updatedStyles = parser.parse(styles, classes, context);
        expect(updatedStyles.constraints?.maxWidth, context.screenWidth);
      });

      test('parses named max-width sizes (xs, sm, md, lg, etc.)', () {
        // xs = 320px
        final stylesXs = parser.parse(WindStyle(), ['max-w-xs'], context);
        expect(stylesXs.constraints?.maxWidth, 320);

        // sm = 384px
        final stylesSm = parser.parse(WindStyle(), ['max-w-sm'], context);
        expect(stylesSm.constraints?.maxWidth, 384);

        // md = 448px
        final stylesMd = parser.parse(WindStyle(), ['max-w-md'], context);
        expect(stylesMd.constraints?.maxWidth, 448);

        // lg = 512px
        final stylesLg = parser.parse(WindStyle(), ['max-w-lg'], context);
        expect(stylesLg.constraints?.maxWidth, 512);

        // xl = 576px
        final stylesXl = parser.parse(WindStyle(), ['max-w-xl'], context);
        expect(stylesXl.constraints?.maxWidth, 576);

        // 2xl = 672px
        final styles2xl = parser.parse(WindStyle(), ['max-w-2xl'], context);
        expect(styles2xl.constraints?.maxWidth, 672);
      });

      test(
          'max-w-prose resolves to 512px fixed, not Tailwind font-relative 65ch',
          () {
        // Deliberate fixed-px divergence from Tailwind: 512px matches max-w-lg
        // and avoids font-size dependency; Tailwind's 65ch ≈ 1040px at 16px/ch.
        final styles = parser.parse(WindStyle(), ['max-w-prose'], context);
        expect(styles.constraints?.maxWidth, 512);
      });

      test('parses min-height classes correctly', () {
        final styles = WindStyle();
        final classes = ['min-h-150', 'min-h-[10%]'];
        final updatedStyles = parser.parse(styles, classes, context);
        expect(updatedStyles.constraints?.minHeight, 600);
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

      test('returns true for size classes', () {
        expect(parser.canParse('size-2'), isTrue);
        expect(parser.canParse('size-full'), isTrue);
        expect(parser.canParse('size-[20px]'), isTrue);
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
