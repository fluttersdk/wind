import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

Widget wrapWithTheme(Widget child) {
  return MaterialApp(
    home: WindTheme(
      data: WindThemeData(),
      child: Scaffold(body: child),
    ),
  );
}

void main() {
  setUp(() {
    WindParser.clearCache();
  });

  group('WDiv Overflow Feature Tests', () {
    testWidgets('overflow-hidden uses ClipRRect', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'overflow-hidden w-32 h-32',
              children: [Text('Content')],
            ),
          ),
        ),
      );

      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets('overflow-visible does not use ClipRect', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'overflow-visible w-32 h-32',
              children: [Text('Content')],
            ),
          ),
        ),
      );

      expect(find.byType(ClipRect), findsNothing);
    });

    testWidgets('overflow-scroll uses nested SingleChildScrollViews', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'overflow-scroll w-32 h-32',
              children: [Text('Content')],
            ),
          ),
        ),
      );

      // Nested ScrollViews for both-direction scroll
      expect(find.byType(SingleChildScrollView), findsNWidgets(2));
    });

    testWidgets('overflow-auto uses nested SingleChildScrollViews', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'overflow-auto w-32 h-32',
              children: [Text('Content')],
            ),
          ),
        ),
      );

      // Nested ScrollViews for both-direction scroll
      expect(find.byType(SingleChildScrollView), findsNWidgets(2));
    });

    testWidgets('overflow-x-scroll wraps with horizontal ScrollView', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'overflow-x-scroll w-32 h-32',
              children: [Text('Content')],
            ),
          ),
        ),
      );

      final scrollView = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView),
      );
      expect(scrollView.scrollDirection, Axis.horizontal);
    });

    testWidgets('overflow-x-auto wraps with horizontal ScrollView', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'overflow-x-auto w-32 h-32',
              children: [Text('Content')],
            ),
          ),
        ),
      );

      final scrollView = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView),
      );
      expect(scrollView.scrollDirection, Axis.horizontal);
    });

    testWidgets('overflow-y-scroll wraps with vertical ScrollView', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'overflow-y-scroll w-32 h-32',
              children: [Text('Content')],
            ),
          ),
        ),
      );

      final scrollView = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView),
      );
      expect(scrollView.scrollDirection, Axis.vertical);
    });

    testWidgets('overflow-y-auto wraps with vertical ScrollView', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'overflow-y-auto w-32 h-32',
              children: [Text('Content')],
            ),
          ),
        ),
      );

      final scrollView = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView),
      );
      expect(scrollView.scrollDirection, Axis.vertical);
    });

    testWidgets('overflow-x-hidden uses ClipRRect', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'overflow-x-hidden w-32 h-32',
              children: [Text('Content')],
            ),
          ),
        ),
      );

      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets('overflow-y-hidden uses ClipRRect', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'overflow-y-hidden w-32 h-32',
              children: [Text('Content')],
            ),
          ),
        ),
      );

      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets(
      'flex-1 children inside overflow-x-auto row do not assert',
      (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDiv(
              className: 'flex flex-row overflow-x-auto',
              children: [
                WDiv(className: 'flex-1', child: Text('a')),
                WDiv(className: 'flex-1', child: Text('b')),
              ],
            ),
          ),
        );

        expect(tester.takeException(), isNull);
        expect(find.byType(Expanded), findsNothing);
        expect(find.text('a'), findsOneWidget);
        expect(find.text('b'), findsOneWidget);
      },
    );

    testWidgets(
      'flex-1 children inside overflow-y-auto column do not assert',
      (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDiv(
              className: 'flex flex-col overflow-y-auto',
              children: [
                WDiv(className: 'flex-1', child: Text('a')),
                WDiv(className: 'flex-1', child: Text('b')),
              ],
            ),
          ),
        );

        expect(tester.takeException(), isNull);
        expect(find.byType(Expanded), findsNothing);
      },
    );

    testWidgets(
      'flex-1 in non-scrolling row still wraps with Expanded',
      (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDiv(
              className: 'flex flex-row',
              children: [
                WDiv(className: 'flex-1', child: Text('a')),
                WDiv(className: 'flex-1', child: Text('b')),
              ],
            ),
          ),
        );

        expect(tester.takeException(), isNull);
        expect(find.byType(Expanded), findsNWidgets(2));
      },
    );

    testWidgets(
      'nested non-scrolling flex subtree re-enables Expanded under scroll',
      (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDiv(
              className: 'flex flex-row overflow-x-auto',
              children: [
                WDiv(
                  className: 'flex flex-row w-96',
                  children: [
                    WDiv(className: 'flex-1', child: Text('inner')),
                  ],
                ),
              ],
            ),
          ),
        );

        expect(tester.takeException(), isNull);
        expect(find.byType(Expanded), findsOneWidget);
      },
    );

    testWidgets(
      'flex-1 children inside overflow-auto (both axes) do not assert',
      (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDiv(
              className: 'flex flex-row overflow-auto',
              children: [
                WDiv(className: 'flex-1', child: Text('a')),
                WDiv(className: 'flex-1', child: Text('b')),
              ],
            ),
          ),
        );

        expect(tester.takeException(), isNull);
        expect(find.byType(Expanded), findsNothing);
      },
    );

    testWidgets('no overflow class does not add ClipRect', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'w-32 h-32 bg-gray-100',
              children: [Text('Content')],
            ),
          ),
        ),
      );

      expect(find.byType(ClipRect), findsNothing);
      expect(find.byType(OverflowBox), findsNothing);
    });
  });
}
