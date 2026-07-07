import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/src/parser/wind_context.dart';
import 'package:fluttersdk_wind/src/parser/wind_parser.dart';
import 'package:fluttersdk_wind/src/theme/wind_theme_data.dart';

// Mock WindThemeData for testing purposes
final testTheme = WindThemeData(
  screens: {'sm': 640, 'md': 768, 'lg': 1024, 'xl': 1280},
);

// Helper function to create a WindContext for testing
WindContext createTestContext({
  bool isHovering = false,
  bool isFocused = false,
  bool isDisabled = false,
  String activeBreakpoint = 'base',
  Brightness brightness = Brightness.light,
  String platform = 'unknown',
  bool isMobile = false,
  Set<String>? customStates,
}) {
  return WindContext(
    theme: testTheme.copyWith(brightness: brightness),
    activeBreakpoint: activeBreakpoint,
    platform: platform,
    isMobile: isMobile,
    screenWidth: 400,
    screenHeight: 800,
    activeStates: {
      if (isHovering) 'hover',
      if (isFocused) 'focus',
      if (isDisabled) 'disabled',
      ...?customStates,
    },
  );
}

void main() {
  group('WindParser.findAndGroupClasses', () {
    test('should group classes by parser', () {
      final className = "bg-red-500 text-lg md:bg-blue-500";
      final context = createTestContext(activeBreakpoint: 'md');
      final result = WindParser.findAndGroupClasses(className, context);
      expect(result, {
        "background": ["bg-red-500", "bg-blue-500"],
        "text": ["text-lg"],
      });
    });

    test('should handle multiline class strings with newlines', () {
      final className = '''
        w-10
        h-10
        bg-red-500
      ''';
      final context = createTestContext();
      final result = WindParser.findAndGroupClasses(className, context);
      // Sizing parser creates Sizing style, so 'w-10' should be in 'sizing' group if implemented
      // But verify grouping logic first. SizingParser must support w-10. Assuming it does.
      // Or just check split result. findAndGroupClasses keys depend on parser readiness.
      // SizingParser is registered.
      expect(result['sizing'], containsAll(['w-10', 'h-10']));
      expect(result['background'], containsAll(['bg-red-500']));
    });

    test('should handle classes with state prefixes', () {
      final className = "hover:bg-red-500 focus:text-lg";
      final context = createTestContext(isHovering: true, isFocused: true);
      final result = WindParser.findAndGroupClasses(className, context);
      expect(result, {
        "background": ["bg-red-500"],
        "text": ["text-lg"],
      });
    });

    test('should ignore classes with non-matching state prefixes', () {
      final className = "hover:bg-red-500 focus:text-lg";
      final context = createTestContext(isHovering: false, isFocused: false);
      final result = WindParser.findAndGroupClasses(className, context);
      expect(result, {});
    });

    test('should return empty map for null or empty input', () {
      final context = createTestContext();
      expect(WindParser.findAndGroupClasses(null, context), isEmpty);
      expect(WindParser.findAndGroupClasses('', context), isEmpty);
    });

    test('should not change order of classes in each group', () {
      final className = "text-sm text-lg bg-red-500 bg-blue-500";
      final context = createTestContext();
      final result = WindParser.findAndGroupClasses(className, context);
      expect(result, {
        "text": ["text-sm", "text-lg"],
        "background": ["bg-red-500", "bg-blue-500"],
      });
    });

    test('drops a className no parser recognizes', () {
      // The unclaimed token emits the one-time kDebugMode hint; silence it so
      // the suite output stays quiet (kDebugMode is true under flutter test).
      final original = debugPrint;
      addTearDown(() => debugPrint = original);
      debugPrint = (message, {wrapWidth}) {};

      final className = "bg-red-500 not-a-real-token";
      final context = createTestContext();
      final result = WindParser.findAndGroupClasses(className, context);
      expect(result, {
        "background": ["bg-red-500"],
      });
      expect(
        result.values.expand((classes) => classes),
        isNot(contains('not-a-real-token')),
      );
    });
  });

  group('WindParser unknown-token debug diagnostics', () {
    setUp(WindParser.clearCache);

    test('warns exactly once per unique unknown token this session', () {
      final logs = <String>[];
      final original = debugPrint;
      debugPrint = (message, {wrapWidth}) => logs.add(message ?? '');

      try {
        final context = createTestContext();
        WindParser.findAndGroupClasses(
          'bg-red-500 not-a-real-token',
          context,
        );
        // Re-parsing the same unknown token must not print a second time.
        WindParser.findAndGroupClasses('not-a-real-token', context);
      } finally {
        debugPrint = original;
      }

      expect(
        logs.where((l) => l.contains("'not-a-real-token'")),
        hasLength(1),
      );
    });

    test(
      'does not warn on valid tokens handled outside the parser map '
      '(widget-consumed object-fit + inert compat tokens)',
      () {
        final logs = <String>[];
        final original = debugPrint;
        debugPrint = (message, {wrapWidth}) => logs.add(message ?? '');

        try {
          final context = createTestContext();
          // object-cover is consumed by WImage; transition-colors is emitted by
          // Wind's own widget docstrings; tabular-nums is in the consumer
          // contract; antialiased / sr-only are inert. None is a typo, so none
          // may warn.
          WindParser.findAndGroupClasses(
            'object-cover transition-colors tabular-nums antialiased sr-only '
            'inline-flex inline-block',
            context,
          );
        } finally {
          debugPrint = original;
        }

        expect(logs.where((l) => l.contains('unknown className')), isEmpty);
      },
    );
  });

  group('WindParser.resolveClasses', () {
    test('should return all classes if no prefixes are used', () {
      final context = createTestContext();
      final classes = ['bg-red-500', 'text-lg', 'p-4'];
      final result = WindParser.resolveClasses(classes, context);
      expect(result, equals(['bg-red-500', 'text-lg', 'p-4']));
    });

    test('should return empty list for null or empty input', () {
      final context = createTestContext();
      expect(WindParser.resolveClasses(null, context), isEmpty);
      expect(WindParser.resolveClasses([], context), isEmpty);
    });

    group('Breakpoint Filtering', () {
      test('should include base and "md" classes on a medium screen', () {
        final context = createTestContext(activeBreakpoint: 'md');
        final classes = ['bg-red-500', 'md:bg-blue-500', 'lg:bg-green-500'];
        final result = WindParser.resolveClasses(classes, context);
        expect(result, containsAll(['bg-red-500', 'bg-blue-500']));
        expect(result, isNot(contains('bg-green-500')));
      });

      test('should include all up to "lg" on a large screen', () {
        final context = createTestContext(activeBreakpoint: 'lg');
        final classes = [
          'bg-red-500',
          'md:bg-blue-500',
          'lg:bg-green-500',
          'xl:bg-yellow-500',
        ];
        final result = WindParser.resolveClasses(classes, context);
        expect(
          result,
          containsAll(['bg-red-500', 'bg-blue-500', 'bg-green-500']),
        );
        expect(result, isNot(contains('bg-yellow-500')));
      });

      test('should only include base classes on a small screen', () {
        final context = createTestContext(activeBreakpoint: 'sm');
        final classes = ['p-4', 'md:p-6', 'lg:p-8'];
        final result = WindParser.resolveClasses(classes, context);
        expect(result, equals(['p-4']));
      });
    });

    group('State Filtering', () {
      test('should apply "hover" class when hovering', () {
        final context = createTestContext(isHovering: true);
        final classes = ['text-black', 'hover:text-white'];
        final result = WindParser.resolveClasses(classes, context);
        expect(result, containsAll(['text-black', 'text-white']));
      });

      test('should not apply "hover" class when not hovering', () {
        final context = createTestContext(isHovering: false);
        final classes = ['text-black', 'hover:text-white'];
        final result = WindParser.resolveClasses(classes, context);
        expect(result, equals(['text-black']));
      });

      test('should apply "focus" class when focused', () {
        final context = createTestContext(isFocused: true);
        final classes = ['border-gray-300', 'focus:border-blue-500'];
        final result = WindParser.resolveClasses(classes, context);
        expect(result, containsAll(['border-gray-300', 'border-blue-500']));
      });

      test('should apply "dark" class in dark mode', () {
        final context = createTestContext(brightness: Brightness.dark);
        final classes = ['bg-white', 'dark:bg-black'];
        final result = WindParser.resolveClasses(classes, context);
        expect(result, containsAll(['bg-white', 'bg-black']));
      });

      test('should not apply "dark" class in light mode', () {
        final context = createTestContext(brightness: Brightness.light);
        final classes = ['bg-white', 'dark:bg-black'];
        final result = WindParser.resolveClasses(classes, context);
        expect(result, equals(['bg-white']));
      });
    });

    group('Platform Filtering', () {
      test('should apply "ios" class on iOS platform', () {
        final context = createTestContext(platform: 'ios');
        final classes = ['p-4', 'ios:p-2', 'android:p-6'];
        final result = WindParser.resolveClasses(classes, context);
        expect(result, containsAll(['p-4', 'p-2']));
        expect(result, isNot(contains('p-6')));
      });

      test('should apply "mobile" class when isMobile is true', () {
        final context = createTestContext(isMobile: true);
        final classes = ['text-base', 'mobile:text-sm'];
        final result = WindParser.resolveClasses(classes, context);
        expect(result, containsAll(['text-base', 'text-sm']));
      });
    });

    group('Complex Scenarios', () {
      test(
        'should handle combined state and breakpoint prefixes correctly',
        () {
          // Scenario: On a medium screen and hovering
          final context = createTestContext(
            activeBreakpoint: 'md',
            isHovering: true,
          );
          final classes = [
            'bg-gray-200', // base
            'hover:bg-gray-300', // hover only
            'md:bg-blue-200', // md only
            'md:hover:bg-blue-300', // md and hover
            'lg:hover:bg-green-300', // lg and hover (should not apply)
          ];
          final result = WindParser.resolveClasses(classes, context);
          expect(result, hasLength(4));
          expect(
            result,
            containsAll([
              'bg-gray-200',
              'bg-gray-300',
              'bg-blue-200',
              'bg-blue-300',
            ]),
          );
          expect(result, isNot(contains('bg-green-300')));
        },
      );

      test('should handle dark mode, breakpoint, and state prefixes', () {
        // Scenario: Dark mode, large screen, focused
        final context = createTestContext(
          brightness: Brightness.dark,
          activeBreakpoint: 'lg',
          isFocused: true,
        );
        final classes = [
          'text-black', // base
          'dark:text-white', // dark only
          'lg:text-xl', // lg only
          'dark:focus:text-yellow-400', // dark and focus
          'lg:focus:text-2xl', // lg and focus
          'dark:lg:focus:text-amber-400', // all three
          'md:hover:text-red-500', // should not apply
        ];
        final result = WindParser.resolveClasses(classes, context);
        expect(result, hasLength(6));
        expect(
          result,
          containsAll([
            'text-black',
            'text-white',
            'text-xl',
            'text-yellow-400',
            'text-2xl',
            'text-amber-400',
          ]),
        );
        expect(result, isNot(contains('text-red-500')));
      });

      test('should ignore classes with unknown prefixes', () {
        final context = createTestContext();
        final classes = ['p-4', 'foobar:p-8'];
        final result = WindParser.resolveClasses(classes, context);
        expect(result, equals(['p-4']));
      });
    });
  });
}
