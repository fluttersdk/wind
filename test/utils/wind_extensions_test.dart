import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

void main() {
  group('WindContextExtension', () {
    Widget createTestApp(Widget child) {
      return MaterialApp(
        home: WindTheme(
          data: WindThemeData(),
          child: Builder(builder: (context) => child),
        ),
      );
    }

    group('Theme Access', () {
      testWidgets('windTheme returns WindThemeController', (tester) async {
        WindThemeController? result;
        await tester.pumpWidget(
          createTestApp(
            Builder(
              builder: (context) {
                result = context.windTheme;
                return const SizedBox();
              },
            ),
          ),
        );

        expect(result, isNotNull);
        expect(result, isA<WindThemeController>());
      });

      testWidgets('windThemeData returns WindThemeData', (tester) async {
        WindThemeData? result;
        await tester.pumpWidget(
          createTestApp(
            Builder(
              builder: (context) {
                result = context.windThemeData;
                return const SizedBox();
              },
            ),
          ),
        );

        expect(result, isNotNull);
        expect(result, isA<WindThemeData>());
      });

      testWidgets('windColors returns colors map', (tester) async {
        Map<String, MaterialColor>? result;
        await tester.pumpWidget(
          createTestApp(
            Builder(
              builder: (context) {
                result = context.windColors;
                return const SizedBox();
              },
            ),
          ),
        );

        expect(result, isNotNull);
        expect(result?.containsKey('red'), isTrue);
        expect(result?.containsKey('blue'), isTrue);
      });

      testWidgets('windScreens returns screens map', (tester) async {
        Map<String, int>? result;
        await tester.pumpWidget(
          createTestApp(
            Builder(
              builder: (context) {
                result = context.windScreens;
                return const SizedBox();
              },
            ),
          ),
        );

        expect(result, isNotNull);
        expect(result?.containsKey('md'), isTrue);
        expect(result?.containsKey('lg'), isTrue);
      });

      testWidgets('windBrightness returns brightness', (tester) async {
        Brightness? result;
        await tester.pumpWidget(
          createTestApp(
            Builder(
              builder: (context) {
                result = context.windBrightness;
                return const SizedBox();
              },
            ),
          ),
        );

        expect(result, isNotNull);
        expect(result, Brightness.light);
      });

      testWidgets('windIsDark returns false for light theme', (tester) async {
        bool? result;
        await tester.pumpWidget(
          createTestApp(
            Builder(
              builder: (context) {
                result = context.windIsDark;
                return const SizedBox();
              },
            ),
          ),
        );

        expect(result, isFalse);
      });
    });

    group('Helper Shortcuts', () {
      testWidgets('wColorExt returns color', (tester) async {
        Color? result;
        await tester.pumpWidget(
          createTestApp(
            Builder(
              builder: (context) {
                result = context.wColorExt('blue', shade: 500);
                return const SizedBox();
              },
            ),
          ),
        );

        expect(result, isNotNull);
      });

      testWidgets('wSpacingExt returns spacing', (tester) async {
        double? result;
        await tester.pumpWidget(
          createTestApp(
            Builder(
              builder: (context) {
                result = context.wSpacingExt(4);
                return const SizedBox();
              },
            ),
          ),
        );

        expect(result, 16.0);
      });

      testWidgets('wIsMobile/wIsTablet/wIsDesktop work', (tester) async {
        bool? mobile, tablet, desktop;
        await tester.pumpWidget(
          createTestApp(
            Builder(
              builder: (context) {
                mobile = context.wIsMobile;
                tablet = context.wIsTablet;
                desktop = context.wIsDesktop;
                return const SizedBox();
              },
            ),
          ),
        );

        expect(mobile, isNotNull);
        expect(tablet, isNotNull);
        expect(desktop, isNotNull);
      });

      testWidgets('wActiveBreakpoint returns string', (tester) async {
        String? result;
        await tester.pumpWidget(
          createTestApp(
            Builder(
              builder: (context) {
                result = context.wActiveBreakpoint;
                return const SizedBox();
              },
            ),
          ),
        );

        expect(result, isNotNull);
        expect(result, isA<String>());
      });

      testWidgets('wFontSizeExt returns size', (tester) async {
        double? result;
        await tester.pumpWidget(
          createTestApp(
            Builder(
              builder: (context) {
                result = context.wFontSizeExt('lg');
                return const SizedBox();
              },
            ),
          ),
        );

        expect(result, 18.0);
      });

      testWidgets('wFontWeightExt returns weight', (tester) async {
        FontWeight? result;
        await tester.pumpWidget(
          createTestApp(
            Builder(
              builder: (context) {
                result = context.wFontWeightExt('bold');
                return const SizedBox();
              },
            ),
          ),
        );

        expect(result, FontWeight.w700);
      });

      testWidgets('wScreenIsExt checks breakpoint', (tester) async {
        bool? result;
        await tester.pumpWidget(
          createTestApp(
            Builder(
              builder: (context) {
                result = context.wScreenIsExt('sm');
                return const SizedBox();
              },
            ),
          ),
        );

        expect(result, isNotNull);
      });

      testWidgets('wStyleExt parses class string', (tester) async {
        WindStyle? result;
        await tester.pumpWidget(
          createTestApp(
            Builder(
              builder: (context) {
                result = context.wStyleExt('p-4 bg-blue-500');
                return const SizedBox();
              },
            ),
          ),
        );

        expect(result, isNotNull);
        expect(result!.padding, isNotNull);
      });
    });
  });

  group('wWindowClassOf', () {
    Future<WindowSizeClass> classify(
      WidgetTester tester,
      double width, {
      Map<String, int>? screens,
    }) async {
      late WindowSizeClass result;
      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData(size: Size(width, 800)),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: WindTheme(
              data: WindThemeData(screens: screens),
              child: Builder(
                builder: (context) {
                  result = wWindowClassOf(context);
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );

      return result;
    }

    testWidgets('is compact below md', (tester) async {
      expect(await classify(tester, 390), WindowSizeClass.compact);
      expect(await classify(tester, 767.9), WindowSizeClass.compact);
    });

    testWidgets('is medium from md up to below lg', (tester) async {
      expect(await classify(tester, 768), WindowSizeClass.medium);
      expect(await classify(tester, 834), WindowSizeClass.medium);
      expect(await classify(tester, 1023.9), WindowSizeClass.medium);
    });

    testWidgets('is expanded from lg up', (tester) async {
      expect(await classify(tester, 1024), WindowSizeClass.expanded);
      expect(await classify(tester, 1366), WindowSizeClass.expanded);
    });

    testWidgets('reads md and lg from a custom screens table', (tester) async {
      const screens = {'md': 600, 'lg': 900};

      expect(
        await classify(tester, 599, screens: screens),
        WindowSizeClass.compact,
      );
      expect(
        await classify(tester, 600, screens: screens),
        WindowSizeClass.medium,
      );
      expect(
        await classify(tester, 899, screens: screens),
        WindowSizeClass.medium,
      );
      expect(
        await classify(tester, 900, screens: screens),
        WindowSizeClass.expanded,
      );
    });

    testWidgets('agrees with wIsTablet only in the medium band', (
      tester,
    ) async {
      late bool tablet;
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(1366, 1024)),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: WindTheme(
              data: WindThemeData(),
              child: Builder(
                builder: (context) {
                  tablet = context.wIsTablet;
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );

      expect(tablet, isFalse);
      expect(await classify(tester, 1366), WindowSizeClass.expanded);
    });
  });
}
