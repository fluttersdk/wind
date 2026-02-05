import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Tests for scrollPrimary parameter on WDiv
///
/// When scrollPrimary is true and overflow-y-auto/scroll is used:
/// - The SingleChildScrollView should have primary: true
/// - This enables iOS status bar tap-to-top and desktop scrollbar integration
void main() {
  group('WDiv scrollPrimary', () {
    testWidgets('scrollPrimary defaults to false', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const Scaffold(
              body: WDiv(
                className: 'overflow-y-auto h-64',
                children: [
                  WDiv(className: 'h-[500px]', child: Text('Tall')),
                ],
              ),
            ),
          ),
        ),
      );

      final scrollView = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView),
      );

      // Default should be false (non-primary)
      expect(scrollView.primary, isFalse);
    });

    testWidgets('scrollPrimary: true sets primary on vertical scroll', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const Scaffold(
              body: WDiv(
                className: 'overflow-y-auto h-64',
                scrollPrimary: true,
                children: [
                  WDiv(className: 'h-[500px]', child: Text('Tall')),
                ],
              ),
            ),
          ),
        ),
      );

      final scrollView = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView),
      );

      // Should have primary: true
      expect(scrollView.primary, isTrue);
    });

    testWidgets('scrollPrimary: true with overflow-scroll (both directions)', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const Scaffold(
              body: WDiv(
                className: 'overflow-scroll h-64 w-64',
                scrollPrimary: true,
                children: [
                  WDiv(className: 'h-[500px] w-[500px]', child: Text('Big')),
                ],
              ),
            ),
          ),
        ),
      );

      // Should have two scroll views (nested)
      final scrollViews = tester.widgetList<SingleChildScrollView>(
        find.byType(SingleChildScrollView),
      );

      expect(scrollViews.length, 2);

      // The outer (vertical) should be primary
      final outerScrollView = scrollViews.first;
      expect(outerScrollView.primary, isTrue);

      // The inner (horizontal) should NOT be primary
      final innerScrollView = scrollViews.last;
      expect(innerScrollView.primary, isFalse);
    });

    testWidgets('scrollPrimary: false explicitly disables primary', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const Scaffold(
              body: WDiv(
                className: 'overflow-y-auto h-64',
                scrollPrimary: false,
                children: [
                  WDiv(className: 'h-[500px]', child: Text('Tall')),
                ],
              ),
            ),
          ),
        ),
      );

      final scrollView = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView),
      );

      expect(scrollView.primary, isFalse);
    });

    testWidgets('scrollPrimary only affects scroll containers', (tester) async {
      // Without overflow classes, scrollPrimary should have no effect
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const Scaffold(
              body: WDiv(
                className: 'h-64 bg-gray-100',
                scrollPrimary: true, // Should be ignored
                children: [
                  Text('Not scrollable'),
                ],
              ),
            ),
          ),
        ),
      );

      // Should not have any scroll views
      expect(find.byType(SingleChildScrollView), findsNothing);
    });

    testWidgets('scrollPrimary works with overflow-x-auto (horizontal)', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const Scaffold(
              body: WDiv(
                className: 'overflow-x-auto h-32 w-64',
                scrollPrimary: true,
                children: [
                  WDiv(className: 'w-[500px]', child: Text('Wide')),
                ],
              ),
            ),
          ),
        ),
      );

      final scrollView = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView),
      );

      // Horizontal scroll with primary
      expect(scrollView.scrollDirection, Axis.horizontal);
      expect(scrollView.primary, isTrue);
    });

    testWidgets('scrollPrimary can be used in Scaffold context', (
      tester,
    ) async {
      // Real-world use case: main page scroll
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: Scaffold(
              body: WDiv(
                className: 'overflow-y-auto',
                scrollPrimary: true,
                children: List.generate(
                  50,
                  (i) => WText('Item $i'),
                ),
              ),
            ),
          ),
        ),
      );

      final scrollView = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView),
      );

      expect(scrollView.primary, isTrue);

      // Verify scrollable
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -500),
      );
      await tester.pump();
    });
  });
}
