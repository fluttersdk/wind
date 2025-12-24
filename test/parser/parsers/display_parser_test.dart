import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/src/parser/parsers/display_parser.dart';
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
  group('DisplayParser', () {
    late DisplayParser parser;
    late WindContext context;

    setUp(() {
      parser = const DisplayParser();
      context = createTestContext();
    });

    group('parse', () {
      test('parses hidden class', () {
        final classes = ['hidden'];
        final style = parser.parse(WindStyle(), classes, context);
        expect(style.isHidden, isTrue);
      });

      test('parses block class', () {
        final classes = ['block'];
        final style = parser.parse(WindStyle(), classes, context);
        expect(style.isHidden, isFalse);
        expect(style.displayType, WindDisplayType.block);
      });

      test('parses flex class', () {
        final classes = ['flex'];
        final style = parser.parse(WindStyle(), classes, context);
        expect(style.isHidden, isFalse);
        expect(style.displayType, WindDisplayType.flex);
      });

      test('parses grid class', () {
        final classes = ['grid'];
        final style = parser.parse(WindStyle(), classes, context);
        expect(style.isHidden, isFalse);
        expect(style.displayType, WindDisplayType.grid);
      });

      test('handles multiple display classes', () {
        final classes = ['hidden', 'flex', 'block'];
        final style = parser.parse(WindStyle(), classes, context);
        expect(style.isHidden, isFalse);
        expect(style.displayType, WindDisplayType.block);
      });
    });

    group('canParse', () {
      test('returns true for display classes', () {
        expect(parser.canParse('hidden'), isTrue);
        expect(parser.canParse('block'), isTrue);
        expect(parser.canParse('flex'), isTrue);
        expect(parser.canParse('grid'), isTrue);
      });

      test('returns false for non-display classes', () {
        expect(parser.canParse('w-10'), isFalse);
        expect(parser.canParse('h-20'), isFalse);
        expect(parser.canParse('text-red-500'), isFalse);
      });
    });
  });
}

