import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/src/parser/parsers/border_parser.dart';
import 'package:fluttersdk_wind/src/parser/wind_context.dart';
import 'package:fluttersdk_wind/src/parser/wind_style.dart';
import 'package:fluttersdk_wind/src/theme/wind_theme_data.dart';

void main() {
  late BorderParser parser;
  late WindContext context;

  setUp(() {
    parser = const BorderParser();
    context = WindContext(
      theme: WindThemeData(),
      screenWidth: 800,
      screenHeight: 600,
      activeBreakpoint: 'md',
      platform: 'web',
      isMobile: false,
      isHovering: false,
      isFocused: false,
      isDisabled: false,
    );
  });

  group('BorderParser', () {
    group('canParse', () {
      test('returns true for border classes', () {
        expect(parser.canParse('border'), isTrue);
        expect(parser.canParse('border-2'), isTrue);
        expect(parser.canParse('border-t'), isTrue);
        expect(parser.canParse('border-red-500'), isTrue);
      });

      test('returns true for rounded classes', () {
        expect(parser.canParse('rounded'), isTrue);
        expect(parser.canParse('rounded-lg'), isTrue);
        expect(parser.canParse('rounded-full'), isTrue);
        expect(parser.canParse('rounded-tl'), isTrue);
      });

      test('returns false for non-border classes', () {
        expect(parser.canParse('bg-red-500'), isFalse);
        expect(parser.canParse('text-lg'), isFalse);
        expect(parser.canParse('p-4'), isFalse);
      });
    });

    group('border width', () {
      test('parses uniform border width', () {
        final result = parser.parse(const WindStyle(), ['border'], context);

        expect(result.decoration?.border, isNotNull);
        final border = result.decoration!.border as Border;
        expect(border.top.width, 1.0);
      });

      test('parses border-2', () {
        final result = parser.parse(const WindStyle(), ['border-2'], context);

        final border = result.decoration!.border as Border;
        expect(border.top.width, 2.0);
      });

      test('parses border-4', () {
        final result = parser.parse(const WindStyle(), ['border-4'], context);

        final border = result.decoration!.border as Border;
        expect(border.top.width, 4.0);
      });

      test('parses border-0 (no border)', () {
        final result = parser.parse(const WindStyle(), ['border-0'], context);

        // border-0 should result in no visible border
        expect(result.decoration?.border, isNull);
      });
    });

    group('directional borders', () {
      test('parses border-t', () {
        final result = parser.parse(const WindStyle(), ['border-t'], context);

        final border = result.decoration!.border as Border;
        expect(border.top.width, 1.0);
        expect(border.right, BorderSide.none);
        expect(border.bottom, BorderSide.none);
        expect(border.left, BorderSide.none);
      });

      test('parses border-b-2', () {
        final result = parser.parse(const WindStyle(), ['border-b-2'], context);

        final border = result.decoration!.border as Border;
        expect(border.bottom.width, 2.0);
        expect(border.top, BorderSide.none);
      });
    });

    group('border color', () {
      test('parses theme color', () {
        final result = parser.parse(const WindStyle(), [
          'border',
          'border-red-500',
        ], context);

        final border = result.decoration!.border as Border;
        expect(border.top.color, context.theme.getColor('red', 500));
      });

      test('parses arbitrary hex color', () {
        final result = parser.parse(const WindStyle(), [
          'border',
          'border-[#FF5733]',
        ], context);

        final border = result.decoration!.border as Border;
        expect(border.top.color, const Color(0xFFFF5733));
      });
    });

    group('border radius', () {
      test('parses rounded', () {
        final result = parser.parse(const WindStyle(), ['rounded'], context);

        expect(result.decoration?.borderRadius, isNotNull);
        expect(result.decoration!.borderRadius, BorderRadius.circular(4.0));
      });

      test('parses rounded-lg', () {
        final result = parser.parse(const WindStyle(), ['rounded-lg'], context);

        expect(result.decoration!.borderRadius, BorderRadius.circular(8.0));
      });

      test('parses rounded-full', () {
        final result = parser.parse(const WindStyle(), [
          'rounded-full',
        ], context);

        expect(result.decoration!.borderRadius, BorderRadius.circular(9999.0));
      });

      test('parses rounded-none', () {
        final result = parser.parse(const WindStyle(), [
          'rounded-none',
        ], context);

        expect(result.decoration!.borderRadius, BorderRadius.circular(0.0));
      });
    });

    group('directional radius', () {
      test('parses rounded-t', () {
        final result = parser.parse(const WindStyle(), ['rounded-t'], context);

        expect(
          result.decoration!.borderRadius,
          const BorderRadius.only(
            topLeft: Radius.circular(4.0),
            topRight: Radius.circular(4.0),
          ),
        );
      });

      test('parses rounded-tl-lg', () {
        final result = parser.parse(const WindStyle(), [
          'rounded-tl-lg',
        ], context);

        expect(
          result.decoration!.borderRadius,
          const BorderRadius.only(topLeft: Radius.circular(8.0)),
        );
      });
    });

    group('last class wins', () {
      test('later border width overrides earlier', () {
        final result = parser.parse(const WindStyle(), [
          'border-2',
          'border-4',
        ], context);

        final border = result.decoration!.border as Border;
        expect(border.top.width, 4.0);
      });

      test('later radius overrides earlier', () {
        final result = parser.parse(const WindStyle(), [
          'rounded-sm',
          'rounded-xl',
        ], context);

        expect(result.decoration!.borderRadius, BorderRadius.circular(12.0));
      });
    });

    group('integration with background', () {
      test('preserves existing background color', () {
        final existingStyle = const WindStyle().copyWith(
          decoration: const BoxDecoration(color: Colors.blue),
        );

        final result = parser.parse(existingStyle, [
          'border-2',
          'rounded-lg',
        ], context);

        expect(result.decoration!.color, Colors.blue);
        expect(result.decoration!.border, isNotNull);
        expect(result.decoration!.borderRadius, isNotNull);
      });
    });
  });
}
