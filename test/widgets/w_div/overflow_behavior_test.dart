import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Deep dive tests for overflow behavior comparison with Tailwind CSS/HTML
void main() {
  group('Overflow Behavior Analysis', () {
    group('Padding Behavior', () {
      testWidgets('padding with overflow-y-auto - where is padding applied?', (
        tester,
      ) async {
        // In Tailwind CSS: padding is INSIDE the scrollable area
        // So scrolling should scroll the padding too
        await tester.pumpWidget(
          MaterialApp(
            home: WindTheme(
              data: WindThemeData(),
              child: const Scaffold(
                body: SizedBox(
                  height: 200,
                  child: WDiv(
                    className: 'overflow-y-auto p-8 bg-gray-100',
                    children: [
                      WDiv(
                        className: 'h-[500px] bg-blue-500',
                        child: Text('Tall content'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );

        // Find padding location
        bool paddingInsideScroll = false;

        // Walk the widget tree to understand structure
        final scrollView = tester.widget<SingleChildScrollView>(
          find.byType(SingleChildScrollView),
        );

        // Check if Container with padding is inside ScrollView
        final scrollViewElement = tester.element(
          find.byType(SingleChildScrollView),
        );

        void visitChildren(Element element) {
          if (element.widget is Container) {
            final container = element.widget as Container;
            if (container.padding != null &&
                container.padding != EdgeInsets.zero) {
              paddingInsideScroll = true;
            }
          }
          element.visitChildren(visitChildren);
        }

        scrollViewElement.visitChildren(visitChildren);

        // Document current behavior
        debugPrint('Padding inside scroll: $paddingInsideScroll');
        debugPrint('Scroll view child: ${scrollView.child.runtimeType}');

        // This test documents the current behavior - adjust expectations based on findings
        expect(find.byType(SingleChildScrollView), findsOneWidget);
      });

      testWidgets('compare: SingleChildScrollView padding parameter', (
        tester,
      ) async {
        // Flutter's SingleChildScrollView has a dedicated padding parameter
        // that applies padding INSIDE the scroll area
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                height: 200,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32),
                  child: Container(
                    height: 500,
                    color: Colors.blue,
                    child: const Text('Tall content'),
                  ),
                ),
              ),
            ),
          ),
        );

        final scrollView = tester.widget<SingleChildScrollView>(
          find.byType(SingleChildScrollView),
        );
        expect(scrollView.padding, const EdgeInsets.all(32));
      });
    });

    group('Scroll Physics', () {
      testWidgets('Wind UI default scroll physics', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: WindTheme(
              data: WindThemeData(),
              child: const Scaffold(
                body: SizedBox(
                  height: 200,
                  child: WDiv(
                    className: 'overflow-y-auto',
                    children: [
                      WDiv(className: 'h-[500px]', child: Text('Tall')),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );

        final scrollView = tester.widget<SingleChildScrollView>(
          find.byType(SingleChildScrollView),
        );

        // Document default physics
        debugPrint('Default physics: ${scrollView.physics}');

        // Default should be null (platform default) or platform-specific
        // This is fine - matches native behavior
      });
    });

    group('Scroll Controller', () {
      testWidgets('Wind UI does not support scroll controller', (tester) async {
        // WDiv doesn't have scrollController parameter
        // This could be a limitation for programmatic scrolling
        await tester.pumpWidget(
          MaterialApp(
            home: WindTheme(
              data: WindThemeData(),
              child: const Scaffold(
                body: SizedBox(
                  height: 200,
                  child: WDiv(
                    className: 'overflow-y-auto',
                    // No way to pass scrollController
                    children: [
                      WDiv(className: 'h-[500px]', child: Text('Tall')),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );

        expect(find.byType(SingleChildScrollView), findsOneWidget);
        // Cannot test scroll controller because it's not supported
      });
    });

    group('Overflow + Flex Interaction', () {
      testWidgets('overflow-y-auto inside flex-1 (Expanded)', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: WindTheme(
              data: WindThemeData(),
              child: Scaffold(
                body: Column(
                  children: [
                    Container(height: 50, color: Colors.red),
                    Expanded(
                      child: WDiv(
                        className: 'overflow-y-auto',
                        children: List.generate(
                          30,
                          (i) => WText('Item $i'),
                        ),
                      ),
                    ),
                    Container(height: 50, color: Colors.red),
                  ],
                ),
              ),
            ),
          ),
        );

        expect(find.byType(SingleChildScrollView), findsOneWidget);

        // Should be scrollable
        await tester.drag(
          find.byType(SingleChildScrollView),
          const Offset(0, -200),
        );
        await tester.pump();

        // Items should still be visible after scroll
        expect(find.byType(WText), findsWidgets);
      });

      testWidgets('overflow-y-auto with h-full in bounded parent', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: WindTheme(
              data: WindThemeData(),
              child: Scaffold(
                body: SizedBox(
                  height: 300,
                  child: WDiv(
                    className: 'overflow-y-auto h-full',
                    children: List.generate(
                      30,
                      (i) => WText('Item $i'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

        expect(find.byType(SingleChildScrollView), findsOneWidget);
      });
    });

    group('Combined Overflow Scenarios', () {
      testWidgets('overflow-y-auto with max-h constraint', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: WindTheme(
              data: WindThemeData(),
              child: Scaffold(
                body: Center(
                  child: WDiv(
                    className: 'overflow-y-auto max-h-64 w-64 bg-gray-100',
                    children: List.generate(
                      20,
                      (i) => WDiv(
                        className: 'p-2 border-b border-gray-200',
                        child: WText('Item $i'),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

        expect(find.byType(SingleChildScrollView), findsOneWidget);

        // Check the container is constrained
        final wdivSize = tester.getSize(find.byType(WDiv).first);
        expect(wdivSize.height, lessThanOrEqualTo(256)); // max-h-64 = 256px
      });

      testWidgets('nested scrollable containers', (tester) async {
        // Inner and outer scroll - should both work
        await tester.pumpWidget(
          MaterialApp(
            home: WindTheme(
              data: WindThemeData(),
              child: Scaffold(
                body: WDiv(
                  className: 'overflow-y-auto h-full',
                  children: [
                    WText('Outer header'),
                    WDiv(
                      className: 'overflow-y-auto max-h-32 bg-gray-100',
                      children: List.generate(
                        10,
                        (i) => WText('Inner item $i'),
                      ),
                    ),
                    WText('Outer middle'),
                    WDiv(
                      className: 'overflow-y-auto max-h-32 bg-gray-200',
                      children: List.generate(
                        10,
                        (i) => WText('Inner item $i'),
                      ),
                    ),
                    WText('Outer footer'),
                  ],
                ),
              ),
            ),
          ),
        );

        // Should have 3 scroll views (1 outer + 2 inner)
        expect(find.byType(SingleChildScrollView), findsNWidgets(3));
      });
    });

    group('Edge Cases', () {
      testWidgets('overflow-y-auto with empty children', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: WindTheme(
              data: WindThemeData(),
              child: const Scaffold(
                body: WDiv(
                  className: 'overflow-y-auto h-64',
                  children: [],
                ),
              ),
            ),
          ),
        );

        // Should not crash with empty children
        expect(find.byType(SingleChildScrollView), findsOneWidget);
      });

      testWidgets('overflow-y-auto without height constraint in Column', (
        tester,
      ) async {
        // This can cause issues in Flutter
        await tester.pumpWidget(
          MaterialApp(
            home: WindTheme(
              data: WindThemeData(),
              child: Scaffold(
                body: Column(
                  children: [
                    // Without Expanded, this could cause infinite height
                    // Wind UI should handle this gracefully
                    WDiv(
                      className: 'overflow-y-auto',
                      children: [
                        WText('Content'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        // Document behavior - this might fail or succeed depending on implementation
      });
    });
  });
}
