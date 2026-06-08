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

      test('shrink-0 sets no flexFit (no-shrink is a widget-level concern)',
          () {
        // shrink-0 must NOT set flexFit: a non-null flexFit self-wraps the
        // widget in Flexible(fit: ...) and forces a fill (the opposite of
        // shrink-0), and asserts outside a Flex. WDiv._hasShrinkZero reads the
        // className and skips the wrap to keep the child at intrinsic size.
        final styles = parser.parse(WindStyle(), ['shrink-0'], context);
        expect(styles.flexFit, isNull);
      });

      test('parses items-baseline class', () {
        final styles = parser.parse(WindStyle(), ['items-baseline'], context);
        expect(styles.crossAxisAlignment, CrossAxisAlignment.baseline);
        expect(styles.textBaseline, TextBaseline.alphabetic);
      });

      test('shrink contributes FlexFit.loose; shrink-0 contributes none', () {
        // Only `shrink` maps to a flexFit; shrink-0 sets none, so the resolved
        // flexFit is loose. shrink-0's no-shrink effect lives in the widget.
        final styles =
            parser.parse(WindStyle(), ['shrink', 'shrink-0'], context);
        expect(styles.flexFit, FlexFit.loose);
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

      test('shrink-0 -> no flexFit (does not shrink via widget guard)', () {
        final styles = parser.parse(WindStyle(), ['shrink-0'], context);
        expect(styles.flexFit, isNull);
      });

      test(
          'items-baseline -> CrossAxisAlignment.baseline and TextBaseline.alphabetic',
          () {
        final styles = parser.parse(WindStyle(), ['items-baseline'], context);
        expect(styles.crossAxisAlignment, CrossAxisAlignment.baseline);
        expect(styles.textBaseline, TextBaseline.alphabetic);
      });

      test('shrink contributes FlexFit.loose regardless of shrink-0 position',
          () {
        // shrink-0 sets no flexFit; `shrink` is the only token that does, so
        // both orders resolve to FlexFit.loose at the parser level. The
        // no-shrink effect of shrink-0 is applied by WDiv._hasShrinkZero.
        expect(
          parser.parse(WindStyle(), ['shrink', 'shrink-0'], context).flexFit,
          FlexFit.loose,
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

    group('self-* align-self alias', () {
      test('self-start matches align-self-start', () {
        final selfStyles = parser.parse(WindStyle(), ['self-start'], context);
        final aliasStyles =
            parser.parse(WindStyle(), ['align-self-start'], context);
        expect(selfStyles.alignment, aliasStyles.alignment);
        expect(selfStyles.alignment, Alignment.topCenter);
      });

      test('self-end matches align-self-end', () {
        final selfStyles = parser.parse(WindStyle(), ['self-end'], context);
        final aliasStyles =
            parser.parse(WindStyle(), ['align-self-end'], context);
        expect(selfStyles.alignment, aliasStyles.alignment);
        expect(selfStyles.alignment, Alignment.bottomCenter);
      });

      test('self-center matches align-self-center', () {
        final selfStyles = parser.parse(WindStyle(), ['self-center'], context);
        final aliasStyles =
            parser.parse(WindStyle(), ['align-self-center'], context);
        expect(selfStyles.alignment, aliasStyles.alignment);
        expect(selfStyles.alignment, Alignment.center);
      });

      test('self-stretch matches align-self-stretch', () {
        final selfStyles = parser.parse(WindStyle(), ['self-stretch'], context);
        final aliasStyles =
            parser.parse(WindStyle(), ['align-self-stretch'], context);
        expect(selfStyles.alignment, aliasStyles.alignment);
        expect(selfStyles.alignment, Alignment.center);
      });

      test('self-auto matches align-self-auto', () {
        final selfStyles = parser.parse(WindStyle(), ['self-auto'], context);
        final aliasStyles =
            parser.parse(WindStyle(), ['align-self-auto'], context);
        expect(selfStyles.alignment, aliasStyles.alignment);
        expect(selfStyles.alignment, Alignment.center);
      });

      test('self-baseline matches align-self-baseline (both unmapped)', () {
        final selfStyles =
            parser.parse(WindStyle(), ['self-baseline'], context);
        final aliasStyles =
            parser.parse(WindStyle(), ['align-self-baseline'], context);
        expect(selfStyles.alignment, aliasStyles.alignment);
        expect(selfStyles.alignment, isNull);
      });

      test('self-* alias does not break align-self-*', () {
        final styles =
            parser.parse(WindStyle(), ['align-self-center'], context);
        expect(styles.alignment, Alignment.center);
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
        expect(parser.canParse('self-center'), isTrue);
        expect(parser.canParse('self-start'), isTrue);
        expect(parser.canParse('align-self-center'), isTrue);
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
