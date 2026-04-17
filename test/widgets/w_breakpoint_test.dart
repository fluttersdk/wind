import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

Widget wrapWithTheme({
  required Size size,
  WindThemeData? theme,
  required Widget child,
}) {
  return MediaQuery(
    data: MediaQueryData(size: size),
    child: MaterialApp(
      home: WindTheme(
        data: theme ?? WindThemeData(),
        child: Scaffold(body: child),
      ),
    ),
  );
}

void main() {
  setUp(() {
    WindParser.clearCache();
  });

  group('WBreakpoint resolution', () {
    testWidgets('falls back to base when no higher builder matches',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          size: const Size(320, 800),
          child: WBreakpoint(
            base: (_) => const Text('BASE'),
            md: (_) => const Text('MD'),
          ),
        ),
      );

      expect(find.text('BASE'), findsOneWidget);
      expect(find.text('MD'), findsNothing);
    });

    testWidgets('resolves sm builder at sm width', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          size: const Size(700, 800),
          child: WBreakpoint(
            base: (_) => const Text('BASE'),
            sm: (_) => const Text('SM'),
          ),
        ),
      );

      expect(find.text('SM'), findsOneWidget);
    });

    testWidgets('picks highest defined builder ≤ active breakpoint',
        (tester) async {
      // lg width (>=1024), but only sm and md defined → md wins
      await tester.pumpWidget(
        wrapWithTheme(
          size: const Size(1200, 800),
          child: WBreakpoint(
            base: (_) => const Text('BASE'),
            sm: (_) => const Text('SM'),
            md: (_) => const Text('MD'),
          ),
        ),
      );

      expect(find.text('MD'), findsOneWidget);
    });

    testWidgets('xl width with all built-ins picks xl', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          size: const Size(1400, 800),
          child: WBreakpoint(
            base: (_) => const Text('BASE'),
            sm: (_) => const Text('SM'),
            md: (_) => const Text('MD'),
            lg: (_) => const Text('LG'),
            xl: (_) => const Text('XL'),
            xxl: (_) => const Text('2XL'),
          ),
        ),
      );

      expect(find.text('XL'), findsOneWidget);
    });

    testWidgets('2xl width picks xxl builder', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          size: const Size(1600, 800),
          child: WBreakpoint(
            base: (_) => const Text('BASE'),
            xxl: (_) => const Text('2XL'),
          ),
        ),
      );

      expect(find.text('2XL'), findsOneWidget);
    });

    testWidgets('custom breakpoint from WindThemeData.screens resolves',
        (tester) async {
      final theme = WindThemeData().copyWith(
        screens: const {
          'sm': 640,
          'md': 768,
          'tablet': 900,
          'lg': 1024,
          'xl': 1280,
          '2xl': 1536,
        },
      );

      await tester.pumpWidget(
        wrapWithTheme(
          size: const Size(950, 800),
          theme: theme,
          child: WBreakpoint(
            base: (_) => const Text('BASE'),
            md: (_) => const Text('MD'),
            custom: {'tablet': (_) => const Text('TABLET')},
          ),
        ),
      );

      expect(find.text('TABLET'), findsOneWidget);
    });

    testWidgets('custom key falls through to lower built-in when undefined',
        (tester) async {
      final theme = WindThemeData().copyWith(
        screens: const {
          'sm': 640,
          'md': 768,
          'tablet': 900,
          'lg': 1024,
          'xl': 1280,
          '2xl': 1536,
        },
      );

      // At tablet width, but only md defined → md resolves.
      await tester.pumpWidget(
        wrapWithTheme(
          size: const Size(950, 800),
          theme: theme,
          child: WBreakpoint(
            base: (_) => const Text('BASE'),
            md: (_) => const Text('MD'),
          ),
        ),
      );

      expect(find.text('MD'), findsOneWidget);
    });

    testWidgets('no builders besides base returns base', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          size: const Size(1200, 800),
          child: WBreakpoint(base: (_) => const Text('BASE')),
        ),
      );

      expect(find.text('BASE'), findsOneWidget);
    });

    testWidgets('rebuilds when size crosses breakpoint', (tester) async {
      Widget app(Size size) => wrapWithTheme(
            size: size,
            child: WBreakpoint(
              base: (_) => const Text('BASE'),
              md: (_) => const Text('MD'),
            ),
          );

      await tester.pumpWidget(app(const Size(400, 800)));
      expect(find.text('BASE'), findsOneWidget);

      await tester.pumpWidget(app(const Size(900, 800)));
      expect(find.text('MD'), findsOneWidget);
    });

    testWidgets('respects nested WindTheme override', (tester) async {
      final innerTheme = WindThemeData().copyWith(
        screens: const {
          'sm': 100,
          'md': 200,
          'lg': 300,
          'xl': 400,
          '2xl': 500,
        },
      );

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(250, 800)),
          child: MaterialApp(
            home: WindTheme(
              data: WindThemeData(),
              child: WindTheme(
                data: innerTheme,
                child: Scaffold(
                  body: WBreakpoint(
                    base: (_) => const Text('BASE'),
                    md: (_) => const Text('MD'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // At 250px with inner screens, md (200) matches.
      expect(find.text('MD'), findsOneWidget);
    });

    testWidgets('asserts when custom key is missing from theme screens',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          size: const Size(800, 800),
          child: WBreakpoint(
            base: (_) => const Text('BASE'),
            custom: {'unregistered': (_) => const Text('CUSTOM')},
          ),
        ),
      );

      expect(tester.takeException(), isA<FlutterError>());
    });
  });
}
