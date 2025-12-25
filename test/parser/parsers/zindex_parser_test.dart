import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

void main() {
  group('ZIndexParser Tests', () {
    test('parses z-0', () {
      final parser = const ZIndexParser();
      final style = parser.parse(
        const WindStyle(),
        ['z-0'],
        WindContext(
          theme: WindThemeData(),
          activeBreakpoint: 'base',
          platform: 'macos',
          isMobile: false,
          isHovering: false,
          isFocused: false,
          isDisabled: false,
          screenWidth: 1024,
          screenHeight: 768,
        ),
      );

      expect(style.zIndex, 0);
    });

    test('parses z-10', () {
      final parser = const ZIndexParser();
      final style = parser.parse(
        const WindStyle(),
        ['z-10'],
        WindContext(
          theme: WindThemeData(),
          activeBreakpoint: 'base',
          platform: 'macos',
          isMobile: false,
          isHovering: false,
          isFocused: false,
          isDisabled: false,
          screenWidth: 1024,
          screenHeight: 768,
        ),
      );

      expect(style.zIndex, 10);
    });

    test('parses z-50', () {
      final parser = const ZIndexParser();
      final style = parser.parse(
        const WindStyle(),
        ['z-50'],
        WindContext(
          theme: WindThemeData(),
          activeBreakpoint: 'base',
          platform: 'macos',
          isMobile: false,
          isHovering: false,
          isFocused: false,
          isDisabled: false,
          screenWidth: 1024,
          screenHeight: 768,
        ),
      );

      expect(style.zIndex, 50);
    });

    test('parses arbitrary z-[100]', () {
      final parser = const ZIndexParser();
      final style = parser.parse(
        const WindStyle(),
        ['z-[100]'],
        WindContext(
          theme: WindThemeData(),
          activeBreakpoint: 'base',
          platform: 'macos',
          isMobile: false,
          isHovering: false,
          isFocused: false,
          isDisabled: false,
          screenWidth: 1024,
          screenHeight: 768,
        ),
      );

      expect(style.zIndex, 100);
    });

    test('parses negative z-[-5]', () {
      final parser = const ZIndexParser();
      final style = parser.parse(
        const WindStyle(),
        ['z-[-5]'],
        WindContext(
          theme: WindThemeData(),
          activeBreakpoint: 'base',
          platform: 'macos',
          isMobile: false,
          isHovering: false,
          isFocused: false,
          isDisabled: false,
          screenWidth: 1024,
          screenHeight: 768,
        ),
      );

      expect(style.zIndex, -5);
    });

    test('z-auto returns null', () {
      final parser = const ZIndexParser();
      final style = parser.parse(
        const WindStyle(),
        ['z-auto'],
        WindContext(
          theme: WindThemeData(),
          activeBreakpoint: 'base',
          platform: 'macos',
          isMobile: false,
          isHovering: false,
          isFocused: false,
          isDisabled: false,
          screenWidth: 1024,
          screenHeight: 768,
        ),
      );

      expect(style.zIndex, isNull);
    });

    test('last class wins', () {
      final parser = const ZIndexParser();
      final style = parser.parse(
        const WindStyle(),
        ['z-10', 'z-30'],
        WindContext(
          theme: WindThemeData(),
          activeBreakpoint: 'base',
          platform: 'macos',
          isMobile: false,
          isHovering: false,
          isFocused: false,
          isDisabled: false,
          screenWidth: 1024,
          screenHeight: 768,
        ),
      );

      expect(style.zIndex, 30);
    });
  });
}
