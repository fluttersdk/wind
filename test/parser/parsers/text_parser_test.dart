import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/src/parser/parsers/text_parser.dart';
import 'package:fluttersdk_wind/src/parser/wind_context.dart';
import 'package:fluttersdk_wind/src/parser/wind_style.dart';
import 'package:fluttersdk_wind/src/theme/wind_theme_data.dart';
import 'package:fluttersdk_wind/src/utils/color_utils.dart';

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
  group('TextParser', () {
    late TextParser parser;
    late WindContext context;

    setUp(() {
      parser = const TextParser();
      context = createTestContext();
    });

    group('parse', () {
      test('parses theme-based text color classes', () {
        final styles = WindStyle();
        final classes = ['text-red-500'];
        final updatedStyles = parser.parse(styles, classes, context);

        expect(updatedStyles.color, context.theme.getColor('red', 500));
      });

      test('parses custom hex text color classes', () {
        final styles = WindStyle();
        final classes = ['text-[#123456]'];
        final updatedStyles = parser.parse(styles, classes, context);

        expect(updatedStyles.color, const Color(0xFF123456));
      });

      test('parses text color with opacity', () {
        final styles = WindStyle();
        final classes = ['text-red-500/50'];
        final updatedStyles = parser.parse(styles, classes, context);

        final expectedColor = applyOpacity(
          context.theme.getColor('red', 500)!,
          50,
        );
        expect(updatedStyles.color!.toARGB32(), expectedColor.toARGB32());
      });

      test('last class wins for conflicting text color classes', () {
        final styles = WindStyle();
        final classes = ['text-red-500', 'text-blue-500'];
        final updatedStyles = parser.parse(styles, classes, context);

        expect(updatedStyles.color, context.theme.getColor('blue', 500));
      });

      test('parses text alignment classes', () {
        final styles = WindStyle();
        final classes = ['text-center'];
        final updatedStyles = parser.parse(styles, classes, context);

        expect(updatedStyles.textAlign, TextAlign.center);
      });

      test('parses font size classes', () {
        final styles = WindStyle();
        final classes = ['text-lg'];
        final updatedStyles = parser.parse(styles, classes, context);

        expect(updatedStyles.fontSize, context.theme.fontSizes['lg']);
      });

      test('parses arbitrary font size classes', () {
        final styles = WindStyle();
        final classes = ['text-[20px]'];
        final updatedStyles = parser.parse(styles, classes, context);

        expect(updatedStyles.fontSize, 20.0);
      });

      test('parses rem arbitrary font size classes', () {
        final styles = WindStyle();
        final classes = ['text-[1.5rem]'];
        final updatedStyles = parser.parse(styles, classes, context);

        expect(updatedStyles.fontSize, 1.5);
      });

      test('parses fractional font size classes', () {
        final styles = WindStyle();
        final classes = ['text-sm/6'];
        final updatedStyles = parser.parse(styles, classes, context);

        expect(updatedStyles.fontSize, context.theme.fontSizes['sm']);
        expect(updatedStyles.heightLine, context.theme.getSpacing('6'));
      });

      test('parses rem fractional font size classes', () {
        final styles = WindStyle();
        final classes = ['text-sm/[2rem]'];
        final updatedStyles = parser.parse(styles, classes, context);

        expect(updatedStyles.fontSize, context.theme.fontSizes['sm']);
        expect(updatedStyles.heightLine, 2.0);
      });

      test('last class wins for conflicting font size classes', () {
        final styles = WindStyle();
        final classes = ['text-sm', 'text-lg'];
        final updatedStyles = parser.parse(styles, classes, context);

        expect(updatedStyles.fontSize, context.theme.fontSizes['lg']);
      });

      test('parses font weight classes', () {
        final styles = WindStyle();
        final classes = ['font-bold'];
        final updatedStyles = parser.parse(styles, classes, context);

        expect(updatedStyles.fontWeight, context.theme.fontWeights['bold']);
      });

      test('parses arbitrary font weight classes', () {
        final styles = WindStyle();
        final classes = ['font-[700]'];
        final updatedStyles = parser.parse(styles, classes, context);

        expect(updatedStyles.fontWeight, FontWeight.w700);
      });

      test('last class wins for conflicting font weight classes', () {
        final styles = WindStyle();
        final classes = ['font-light', 'font-bold'];
        final updatedStyles = parser.parse(styles, classes, context);

        expect(updatedStyles.fontWeight, context.theme.fontWeights['bold']);
      });

      test('parses italic font style class', () {
        final styles = WindStyle();
        final classes = ['italic'];
        final updatedStyles = parser.parse(styles, classes, context);

        expect(updatedStyles.fontStyle, FontStyle.italic);
      });

      test('parses not-italic font style class', () {
        final styles = WindStyle();
        final classes = ['not-italic'];
        final updatedStyles = parser.parse(styles, classes, context);

        expect(updatedStyles.fontStyle, FontStyle.normal);
      });

      test('last class wins for conflicting font style classes', () {
        final styles = WindStyle();
        final classes = ['italic', 'not-italic'];
        final updatedStyles = parser.parse(styles, classes, context);

        expect(updatedStyles.fontStyle, FontStyle.normal);
      });

      test('parses underline text decoration class', () {
        final styles = WindStyle();
        final classes = ['underline'];
        final updatedStyles = parser.parse(styles, classes, context);

        expect(updatedStyles.textDecoration, TextDecoration.underline);
      });

      test('parses line-through text decoration class', () {
        final styles = WindStyle();
        final classes = ['line-through'];
        final updatedStyles = parser.parse(styles, classes, context);

        expect(updatedStyles.textDecoration, TextDecoration.lineThrough);
      });

      test('last class wins for conflicting text decoration classes', () {
        final styles = WindStyle();
        final classes = ['underline', 'line-through'];
        final updatedStyles = parser.parse(styles, classes, context);

        expect(updatedStyles.textDecoration, TextDecoration.lineThrough);
      });

      test('parses decoration color classes', () {
        final styles = WindStyle();
        final classes = ['decoration-blue-500'];
        final updatedStyles = parser.parse(styles, classes, context);

        expect(
          updatedStyles.textDecorationColor,
          context.theme.getColor('blue', 500),
        );
      });

      test('parses custom hex decoration color classes', () {
        final styles = WindStyle();
        final classes = ['decoration-[#654321]'];
        final updatedStyles = parser.parse(styles, classes, context);

        expect(updatedStyles.textDecorationColor, const Color(0xFF654321));
      });

      test('last class wins for conflicting decoration color classes', () {
        final styles = WindStyle();
        final classes = ['decoration-red-500', 'decoration-green-500'];
        final updatedStyles = parser.parse(styles, classes, context);

        expect(
          updatedStyles.textDecorationColor,
          context.theme.getColor('green', 500),
        );
      });

      test('parses decoration style classes', () {
        final styles = WindStyle();
        final classes = ['decoration-dashed'];
        final updatedStyles = parser.parse(styles, classes, context);

        expect(updatedStyles.textDecorationStyle, TextDecorationStyle.dashed);
      });

      test('last class wins for conflicting decoration style classes', () {
        final styles = WindStyle();
        final classes = ['decoration-solid', 'decoration-dotted'];
        final updatedStyles = parser.parse(styles, classes, context);

        expect(updatedStyles.textDecorationStyle, TextDecorationStyle.dotted);
      });

      test('parses decoration thickness classes', () {
        final styles = WindStyle();
        final classes = ['decoration-2'];
        final updatedStyles = parser.parse(styles, classes, context);

        expect(updatedStyles.textDecorationThickness, 2.0);
      });

      test('parses arbitrary decoration thickness classes', () {
        final styles = WindStyle();
        final classes = ['decoration-[3px]'];
        final updatedStyles = parser.parse(styles, classes, context);

        expect(updatedStyles.textDecorationThickness, 3.0);
      });

      test('last class wins for conflicting decoration thickness classes', () {
        final styles = WindStyle();
        final classes = ['decoration-1', 'decoration-4'];
        final updatedStyles = parser.parse(styles, classes, context);

        expect(updatedStyles.textDecorationThickness, 4.0);
      });

      test('parses text transform classes', () {
        final styles = WindStyle();
        final classes = ['uppercase'];
        final updatedStyles = parser.parse(styles, classes, context);

        expect(updatedStyles.textTransform, WindTextTransform.uppercase);
      });

      test('last class wins for conflicting text transform classes', () {
        final styles = WindStyle();
        final classes = ['lowercase', 'uppercase'];
        final updatedStyles = parser.parse(styles, classes, context);

        expect(updatedStyles.textTransform, WindTextTransform.uppercase);
      });

      test('parses tracking classes', () {
        final styles = WindStyle();
        final classes = ['tracking-wide'];
        final updatedStyles = parser.parse(styles, classes, context);

        expect(updatedStyles.letterSpacing, context.theme.tracking['wide']);
      });

      test('parses arbitrary tracking classes', () {
        final styles = WindStyle();
        final classes = ['tracking-[0.1em]'];
        final updatedStyles = parser.parse(styles, classes, context);

        expect(updatedStyles.letterSpacing, 0.1);
      });

      test('last class wins for conflicting tracking classes', () {
        final styles = WindStyle();
        final classes = ['tracking-tight', 'tracking-wide'];
        final updatedStyles = parser.parse(styles, classes, context);

        expect(updatedStyles.letterSpacing, context.theme.tracking['wide']);
      });

      test('parses leading classes', () {
        final styles = WindStyle();
        final classes = ['leading-loose'];
        final updatedStyles = parser.parse(styles, classes, context);

        expect(updatedStyles.heightLineFactor, context.theme.leading['loose']);
      });

      test('parses arbitrary leading classes', () {
        final styles = WindStyle();
        final classes = ['leading-[24px]'];
        final updatedStyles = parser.parse(styles, classes, context);

        expect(updatedStyles.heightLine, 24.0);
      });

      test('parses numeric leading classes', () {
        final styles = WindStyle();
        final classes = ['leading-7'];
        final updatedStyles = parser.parse(styles, classes, context);

        expect(updatedStyles.heightLine, context.theme.getSpacing('7'));
      });

      test('last class wins for conflicting leading classes', () {
        final styles = WindStyle();
        final classes = ['leading-tight', 'leading-loose'];
        final updatedStyles = parser.parse(styles, classes, context);

        expect(updatedStyles.heightLineFactor, context.theme.leading['loose']);
      });

      test('parses truncate class', () {
        final styles = WindStyle();
        final classes = ['truncate'];
        final updatedStyles = parser.parse(styles, classes, context);

        expect(updatedStyles.textOverflow, TextOverflow.ellipsis);
        expect(updatedStyles.maxLines, 1);
        expect(updatedStyles.softWrap, false);
      });

      test('parses text-ellipsis class', () {
        final styles = WindStyle();
        final classes = ['text-ellipsis'];
        final updatedStyles = parser.parse(styles, classes, context);

        expect(updatedStyles.textOverflow, TextOverflow.ellipsis);
      });

      test('parses line-clamp classes', () {
        final styles = WindStyle();
        final classes = ['line-clamp-3'];
        final updatedStyles = parser.parse(styles, classes, context);

        expect(updatedStyles.maxLines, 3);
        expect(updatedStyles.textOverflow, TextOverflow.ellipsis);
      });

      test('parses whitespace-nowrap class', () {
        final styles = WindStyle();
        final classes = ['whitespace-nowrap'];
        final updatedStyles = parser.parse(styles, classes, context);

        expect(updatedStyles.softWrap, false);
      });

      test('parses text-wrap class', () {
        final styles = WindStyle();
        final classes = ['text-wrap'];
        final updatedStyles = parser.parse(styles, classes, context);

        expect(updatedStyles.softWrap, true);
      });

      test('last class wins for conflicting text wrap classes', () {
        final styles = WindStyle();
        final classes = ['whitespace-nowrap', 'text-wrap'];
        final updatedStyles = parser.parse(styles, classes, context);

        expect(updatedStyles.softWrap, true);
      });
    });

    group('canParse', () {
      test('returns true for valid text-related classes', () {
        final validClasses = [
          'text-red-500',
          'text-[#123456]',
          'text-center',
          'text-lg',
          'font-bold',
          'font-[700]',
          'italic',
          'not-italic',
          'underline',
          'line-through',
          'decoration-blue-500',
          'decoration-[#654321]',
          'decoration-dashed',
          'decoration-2',
          'decoration-[3px]',
          'uppercase',
          'tracking-wide',
          'tracking-[0.1em]',
          'leading-loose',
          'leading-[24px]',
          'truncate',
          'text-ellipsis',
          'line-clamp-3',
          'whitespace-nowrap',
          'text-wrap',
        ];

        for (var className in validClasses) {
          expect(parser.canParse(className), isTrue, reason: className);
        }
      });

      test('returns false for non-text-related classes', () {
        final invalidClasses = [
          'bg-red-500',
          'p-4',
          'm-2',
          'border',
          'flex',
          'grid-cols-3',
        ];

        for (var className in invalidClasses) {
          expect(parser.canParse(className), isFalse, reason: className);
        }
      });

      test('returns false for empty or null classes', () {
        expect(parser.canParse(''), isFalse);
        expect(parser.canParse('   '), isFalse);
      });
    });
  });
}
