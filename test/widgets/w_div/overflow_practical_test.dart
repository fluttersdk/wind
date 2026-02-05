import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Practical overflow tests - matching real-world usage patterns
void main() {
  group('Practical Overflow Scenarios', () {
    testWidgets('overflow-y-auto with max-h creates scrollable container', (
      tester,
    ) async {
      // This is the Tailwind pattern: overflow-y-auto + max-h-* creates scrollable area
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const Scaffold(
              body: WDiv(
                className: 'overflow-y-auto max-h-32',
                children: [
                  // Content taller than 32 (128px)
                  WDiv(className: 'h-64', child: Text('Tall content')),
                ],
              ),
            ),
          ),
        ),
      );

      // Should have SingleChildScrollView
      expect(find.byType(SingleChildScrollView), findsOneWidget);

      // Should be vertical scroll
      final scrollView = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView),
      );
      expect(scrollView.scrollDirection, Axis.vertical);

      // Should be scrollable (content exceeds container)
      expect(tester.getSize(find.byType(WDiv).first).height, lessThan(200));
    });

    testWidgets('overflow-x-auto with max-w creates horizontal scroll', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const Scaffold(
              body: WDiv(
                className: 'overflow-x-auto max-w-32',
                children: [
                  // Content wider than 32 (128px)
                  WDiv(className: 'w-64', child: Text('Wide content')),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(SingleChildScrollView), findsOneWidget);
      final scrollView = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView),
      );
      expect(scrollView.scrollDirection, Axis.horizontal);
    });

    testWidgets(
      'overflow-y-auto without height constraint - parent provides bounds',
      (tester) async {
        // When parent provides constraints, overflow-y-auto should work
        await tester.pumpWidget(
          MaterialApp(
            home: WindTheme(
              data: WindThemeData(),
              child: Scaffold(
                body: SizedBox(
                  height: 200,
                  child: const WDiv(
                    className: 'overflow-y-auto',
                    children: [
                      // Content taller than parent
                      WDiv(className: 'h-96', child: Text('Tall content')),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );

        expect(find.byType(SingleChildScrollView), findsOneWidget);
      },
    );

    testWidgets('can scroll content in overflow-y-auto container', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const Scaffold(
              body: WDiv(
                className: 'overflow-y-auto h-32',
                children: [
                  WText('Item 1'),
                  WText('Item 2'),
                  WText('Item 3'),
                  WText('Item 4'),
                  WText('Item 5'),
                  WText('Item 6'),
                  WText('Item 7'),
                  WText('Item 8'),
                  WText('Item 9'),
                  WText('Item 10'),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify scroll view exists
      expect(find.byType(SingleChildScrollView), findsOneWidget);

      // Try to scroll
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -100),
      );
      await tester.pump();

      // If we got here without error, scrolling works
    });

    testWidgets('nested scrollable: inner overflow-y-auto in Column', (
      tester,
    ) async {
      // Common pattern: list inside a column with other fixed content
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: Scaffold(
              body: Column(
                children: [
                  const WText('Fixed Header'),
                  Expanded(
                    child: WDiv(
                      className: 'overflow-y-auto',
                      children: List.generate(
                        20,
                        (i) => WText('Item $i'),
                      ),
                    ),
                  ),
                  const WText('Fixed Footer'),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('overflow-hidden clips content that exceeds bounds', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const Scaffold(
              body: WDiv(
                className: 'overflow-hidden h-16 w-16',
                children: [
                  // Content larger than container
                  WDiv(
                    className: 'h-32 w-32 bg-red-500',
                    child: Text('Clipped'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets('max-h-[300px] arbitrary value with overflow-y-auto', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const Scaffold(
              body: WDiv(
                className: 'overflow-y-auto max-h-[300px]',
                children: [
                  WDiv(className: 'h-[500px]', child: Text('Tall')),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });
}
