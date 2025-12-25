import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

void main() {
  group('WDiv Overflow Feature Tests', () {
    testWidgets('overflow-hidden uses ClipRect and OverflowBox', (
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

      expect(find.byType(ClipRect), findsOneWidget);
      expect(find.byType(OverflowBox), findsOneWidget);
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

    testWidgets('overflow-x-hidden uses ClipRect', (tester) async {
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

      expect(find.byType(ClipRect), findsOneWidget);
    });

    testWidgets('overflow-y-hidden uses ClipRect', (tester) async {
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

      expect(find.byType(ClipRect), findsOneWidget);
    });

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
