import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/src/parser/parsers/position_parser.dart';
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
  group('PositionParser', () {
    late PositionParser parser;
    late WindContext context;

    setUp(() {
      WindParser.clearCache();
      parser = const PositionParser();
      context = createTestContext();
    });

    group('canParse', () {
      test('returns true for position type tokens', () {
        expect(parser.canParse('relative'), isTrue);
        expect(parser.canParse('absolute'), isTrue);
        expect(parser.canParse('fixed'), isTrue);
        expect(parser.canParse('sticky'), isTrue);
      });

      test('returns true for directional offset tokens', () {
        expect(parser.canParse('top-4'), isTrue);
        expect(parser.canParse('bottom-0'), isTrue);
        expect(parser.canParse('left-2'), isTrue);
        expect(parser.canParse('right-8'), isTrue);
      });

      test('returns true for inset tokens', () {
        expect(parser.canParse('inset-0'), isTrue);
        expect(parser.canParse('inset-x-4'), isTrue);
        expect(parser.canParse('inset-y-2'), isTrue);
      });

      test('returns true for negative offset tokens', () {
        expect(parser.canParse('-top-4'), isTrue);
        expect(parser.canParse('-bottom-2'), isTrue);
        expect(parser.canParse('-left-8'), isTrue);
        expect(parser.canParse('-right-1'), isTrue);
        expect(parser.canParse('-inset-2'), isTrue);
        expect(parser.canParse('-inset-x-4'), isTrue);
        expect(parser.canParse('-inset-y-2'), isTrue);
      });

      test('returns true for arbitrary value tokens', () {
        expect(parser.canParse('top-[24px]'), isTrue);
        expect(parser.canParse('left-[50%]'), isTrue);
        expect(parser.canParse('-top-[10px]'), isTrue);
      });

      test('returns false for unrelated classes', () {
        expect(parser.canParse('p-4'), isFalse);
        expect(parser.canParse('flex'), isFalse);
        expect(parser.canParse('bg-red-500'), isFalse);
        expect(parser.canParse('text-lg'), isFalse);
        expect(parser.canParse('m-4'), isFalse);
      });

      test('returns false for empty string', () {
        expect(parser.canParse(''), isFalse);
      });
    });

    group('parse', () {
      group('position type', () {
        test('relative sets positionType to relative', () {
          final styles = WindStyle();
          final result = parser.parse(styles, ['relative'], context);

          expect(result.positionType, WindPositionType.relative);
        });

        test('absolute sets positionType to absolute', () {
          final styles = WindStyle();
          final result = parser.parse(styles, ['absolute'], context);

          expect(result.positionType, WindPositionType.absolute);
        });
      });

      group('fixed and sticky are claimed but ignored', () {
        test('fixed does not set positionType', () {
          final styles = WindStyle();
          final result = parser.parse(styles, ['fixed'], context);

          expect(result.positionType, isNull);
        });

        test('sticky does not set positionType', () {
          final styles = WindStyle();
          final result = parser.parse(styles, ['sticky'], context);

          expect(result.positionType, isNull);
        });
      });

      group('theme scale offsets', () {
        test('top-4 resolves to 16.0', () {
          final styles = WindStyle();
          final result = parser.parse(styles, ['top-4'], context);

          expect(result.positionTop, 16.0);
        });

        test('bottom-0 resolves to 0.0', () {
          final styles = WindStyle();
          final result = parser.parse(styles, ['bottom-0'], context);

          expect(result.positionBottom, 0.0);
        });

        test('left-8 resolves to 32.0', () {
          final styles = WindStyle();
          final result = parser.parse(styles, ['left-8'], context);

          expect(result.positionLeft, 32.0);
        });

        test('right-2 resolves to 8.0', () {
          final styles = WindStyle();
          final result = parser.parse(styles, ['right-2'], context);

          expect(result.positionRight, 8.0);
        });
      });

      group('inset shortcuts', () {
        test('inset-4 sets all four sides to 16.0', () {
          final styles = WindStyle();
          final result = parser.parse(styles, ['inset-4'], context);

          expect(result.positionTop, 16.0);
          expect(result.positionRight, 16.0);
          expect(result.positionBottom, 16.0);
          expect(result.positionLeft, 16.0);
        });

        test('inset-x-2 sets left and right to 8.0', () {
          final styles = WindStyle();
          final result = parser.parse(styles, ['inset-x-2'], context);

          expect(result.positionLeft, 8.0);
          expect(result.positionRight, 8.0);
          expect(result.positionTop, isNull);
          expect(result.positionBottom, isNull);
        });

        test('inset-y-3 sets top and bottom to 12.0', () {
          final styles = WindStyle();
          final result = parser.parse(styles, ['inset-y-3'], context);

          expect(result.positionTop, 12.0);
          expect(result.positionBottom, 12.0);
          expect(result.positionLeft, isNull);
          expect(result.positionRight, isNull);
        });
      });

      group('arbitrary values', () {
        test('top-[24px] resolves to 24.0', () {
          final styles = WindStyle();
          final result = parser.parse(styles, ['top-[24px]'], context);

          expect(result.positionTop, 24.0);
        });

        test('left-[50%] resolves to 50.0', () {
          final styles = WindStyle();
          final result = parser.parse(styles, ['left-[50%]'], context);

          expect(result.positionLeft, 50.0);
        });
      });

      group('negative offsets', () {
        test('-top-4 resolves to -16.0', () {
          final styles = WindStyle();
          final result = parser.parse(styles, ['-top-4'], context);

          expect(result.positionTop, -16.0);
        });

        test('-inset-2 sets all four sides to -8.0', () {
          final styles = WindStyle();
          final result = parser.parse(styles, ['-inset-2'], context);

          expect(result.positionTop, -8.0);
          expect(result.positionRight, -8.0);
          expect(result.positionBottom, -8.0);
          expect(result.positionLeft, -8.0);
        });
      });

      group('last class wins', () {
        test('top-4 top-8 resolves to 32.0 (last wins)', () {
          final styles = WindStyle();
          final result = parser.parse(styles, ['top-4', 'top-8'], context);

          expect(result.positionTop, 32.0);
        });
      });

      group('edge cases', () {
        test('null classes returns styles unchanged', () {
          final styles = WindStyle();
          final result = parser.parse(styles, null, context);

          expect(result, styles);
        });

        test('empty classes list returns styles unchanged', () {
          final styles = WindStyle();
          final result = parser.parse(styles, [], context);

          expect(result, styles);
        });
      });

      group('mixed tokens', () {
        test('absolute top-4 right-2 sets type and offsets', () {
          final styles = WindStyle();
          final result = parser.parse(
            styles,
            ['absolute', 'top-4', 'right-2'],
            context,
          );

          expect(result.positionType, WindPositionType.absolute);
          expect(result.positionTop, 16.0);
          expect(result.positionRight, 8.0);
        });
      });
    });
  });
}
