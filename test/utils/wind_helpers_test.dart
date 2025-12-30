import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

void main() {
  group('Wind Helper Functions', () {
    // Create a test widget wrapper with WindTheme
    Widget createTestApp(Widget child) {
      return MaterialApp(
        home: WindTheme(
          data: WindThemeData(),
          child: Builder(builder: (context) => child),
        ),
      );
    }

    group('wColor', () {
      testWidgets('returns color by name and shade', (tester) async {
        Color? result;
        await tester.pumpWidget(
          createTestApp(
            Builder(
              builder: (context) {
                result = wColor(context, 'red', shade: 500);
                return const SizedBox();
              },
            ),
          ),
        );

        expect(result, isNotNull);
        expect(result, isA<Color>());
      });

      testWidgets('returns hex color', (tester) async {
        Color? result;
        await tester.pumpWidget(
          createTestApp(
            Builder(
              builder: (context) {
                result = wColor(context, '#FF5733');
                return const SizedBox();
              },
            ),
          ),
        );

        expect(result, isNotNull);
      });

      testWidgets('parses color-shade format', (tester) async {
        Color? result;
        await tester.pumpWidget(
          createTestApp(
            Builder(
              builder: (context) {
                result = wColor(context, 'blue-600');
                return const SizedBox();
              },
            ),
          ),
        );

        expect(result, isNotNull);
      });

      testWidgets('returns null for invalid color', (tester) async {
        Color? result;
        await tester.pumpWidget(
          createTestApp(
            Builder(
              builder: (context) {
                result = wColor(context, 'invalidcolor', shade: 500);
                return const SizedBox();
              },
            ),
          ),
        );

        expect(result, isNull);
      });
    });

    group('wSpacing', () {
      testWidgets('returns spacing for multiplier', (tester) async {
        double? result;
        await tester.pumpWidget(
          createTestApp(
            Builder(
              builder: (context) {
                result = wSpacing(context, 4);
                return const SizedBox();
              },
            ),
          ),
        );

        expect(result, 16.0); // 4 * 4.0 (default baseSpacingUnit)
      });

      testWidgets('supports decimal multipliers', (tester) async {
        double? result;
        await tester.pumpWidget(
          createTestApp(
            Builder(
              builder: (context) {
                result = wSpacing(context, 2.5);
                return const SizedBox();
              },
            ),
          ),
        );

        expect(result, 10.0); // 2.5 * 4.0
      });
    });

    group('wFontSize', () {
      testWidgets('returns font size by name', (tester) async {
        double? result;
        await tester.pumpWidget(
          createTestApp(
            Builder(
              builder: (context) {
                result = wFontSize(context, 'lg');
                return const SizedBox();
              },
            ),
          ),
        );

        expect(result, isNotNull);
        expect(result, greaterThan(0));
      });

      testWidgets('returns null for invalid size name', (tester) async {
        double? result;
        await tester.pumpWidget(
          createTestApp(
            Builder(
              builder: (context) {
                result = wFontSize(context, 'invalid');
                return const SizedBox();
              },
            ),
          ),
        );

        expect(result, isNull);
      });
    });

    group('wFontWeight', () {
      testWidgets('returns font weight by name', (tester) async {
        FontWeight? result;
        await tester.pumpWidget(
          createTestApp(
            Builder(
              builder: (context) {
                result = wFontWeight(context, 'bold');
                return const SizedBox();
              },
            ),
          ),
        );

        expect(result, FontWeight.w700);
      });

      testWidgets('returns semibold weight', (tester) async {
        FontWeight? result;
        await tester.pumpWidget(
          createTestApp(
            Builder(
              builder: (context) {
                result = wFontWeight(context, 'semibold');
                return const SizedBox();
              },
            ),
          ),
        );

        expect(result, FontWeight.w600);
      });
    });

    group('wScreen', () {
      testWidgets('returns breakpoint value', (tester) async {
        int? result;
        await tester.pumpWidget(
          createTestApp(
            Builder(
              builder: (context) {
                result = wScreen(context, 'md');
                return const SizedBox();
              },
            ),
          ),
        );

        expect(result, isNotNull);
        expect(result, greaterThan(0));
      });

      testWidgets('returns null for invalid breakpoint', (tester) async {
        int? result;
        await tester.pumpWidget(
          createTestApp(
            Builder(
              builder: (context) {
                result = wScreen(context, 'invalid');
                return const SizedBox();
              },
            ),
          ),
        );

        expect(result, isNull);
      });
    });

    group('wScreenIs', () {
      testWidgets('checks if screen is at breakpoint', (tester) async {
        bool? result;
        await tester.pumpWidget(
          createTestApp(
            Builder(
              builder: (context) {
                result = wScreenIs(context, 'sm');
                return const SizedBox();
              },
            ),
          ),
        );

        expect(result, isNotNull);
      });
    });

    group('wScreenCurrent', () {
      testWidgets('returns current breakpoint name', (tester) async {
        String? result;
        await tester.pumpWidget(
          createTestApp(
            Builder(
              builder: (context) {
                result = wScreenCurrent(context);
                return const SizedBox();
              },
            ),
          ),
        );

        expect(result, isNotNull);
        expect(result, isA<String>());
      });
    });

    group('wStyle', () {
      testWidgets('parses class string into WindStyle', (tester) async {
        WindStyle? result;
        await tester.pumpWidget(
          createTestApp(
            Builder(
              builder: (context) {
                result = wStyle(context, 'bg-red-500 p-4');
                return const SizedBox();
              },
            ),
          ),
        );

        expect(result, isNotNull);
        expect(result?.decoration?.color, isNotNull);
        expect(result?.padding, isNotNull);
      });
    });
  });
}
