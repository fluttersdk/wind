import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Deep test for padding behavior in scrollable containers
void main() {
  group('Overflow Padding Deep Analysis', () {
    testWidgets('padding scrolls with content (Tailwind behavior)', (
      tester,
    ) async {
      // In Tailwind/HTML: when you scroll, the padding scrolls too
      // Top padding disappears as you scroll down
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: Scaffold(
              body: SizedBox(
                height: 200,
                child: WDiv(
                  className: 'overflow-y-auto p-8',
                  children: [
                    // Marker at top
                    WDiv(
                      key: const ValueKey('top-marker'),
                      className: 'h-4 bg-red-500',
                    ),
                    // Tall content
                    WDiv(className: 'h-[400px] bg-blue-500'),
                    // Marker at bottom
                    WDiv(
                      key: const ValueKey('bottom-marker'),
                      className: 'h-4 bg-green-500',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      // Get initial position of top marker
      final topMarkerInitial = tester.getTopLeft(
        find.byKey(const ValueKey('top-marker')),
      );
      debugPrint('Top marker initial Y: ${topMarkerInitial.dy}');

      // Scroll down
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -100),
      );
      await tester.pump();

      // Get new position of top marker
      final topMarkerAfter = tester.getTopLeft(
        find.byKey(const ValueKey('top-marker')),
      );
      debugPrint('Top marker after scroll Y: ${topMarkerAfter.dy}');

      // The top marker should have moved up (scrolled with content)
      expect(topMarkerAfter.dy, lessThan(topMarkerInitial.dy));

      // The difference should be approximately 100 (scroll amount)
      expect(
        topMarkerInitial.dy - topMarkerAfter.dy,
        closeTo(100, 10),
      );
    });

    testWidgets('scroll indicator starts at container edge not content', (
      tester,
    ) async {
      // The scroll should start at container edge
      // Padding should be inside scrollable area
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: Scaffold(
              body: Center(
                child: Container(
                  color: Colors.yellow, // Visual marker for container bounds
                  child: WDiv(
                    className: 'overflow-y-auto h-48 w-48 p-6 bg-gray-200',
                    children: [
                      WDiv(className: 'h-[400px] bg-blue-500'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // The scroll view should fill the container
      final scrollViewRect = tester.getRect(find.byType(SingleChildScrollView));
      debugPrint('ScrollView rect: $scrollViewRect');

      // Scroll view should be 192x192 (h-48 = 192px, w-48 = 192px)
      expect(scrollViewRect.width, closeTo(192, 5));
      expect(scrollViewRect.height, closeTo(192, 5));
    });

    testWidgets('compare with SingleChildScrollView.padding behavior', (
      tester,
    ) async {
      // Flutter's native approach: padding parameter on ScrollView
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 200,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Container(
                      key: const ValueKey('flutter-top-marker'),
                      height: 16,
                      color: Colors.red,
                    ),
                    Container(height: 400, color: Colors.blue),
                    Container(height: 16, color: Colors.green),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      // Get initial position
      final flutterTopMarkerInitial = tester.getTopLeft(
        find.byKey(const ValueKey('flutter-top-marker')),
      );
      debugPrint('Flutter marker initial Y: ${flutterTopMarkerInitial.dy}');

      // Scroll
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -100),
      );
      await tester.pump();

      final flutterTopMarkerAfter = tester.getTopLeft(
        find.byKey(const ValueKey('flutter-top-marker')),
      );
      debugPrint('Flutter marker after Y: ${flutterTopMarkerAfter.dy}');

      // Both should behave the same - padding scrolls with content
      expect(flutterTopMarkerAfter.dy, lessThan(flutterTopMarkerInitial.dy));
    });

    testWidgets('Wind padding vs Flutter ScrollView.padding equivalence', (
      tester,
    ) async {
      // Test that Wind's p-8 in overflow-y-auto behaves like ScrollView.padding

      // Wind approach
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: Scaffold(
              body: Row(
                children: [
                  // Wind approach
                  Expanded(
                    child: SizedBox(
                      height: 200,
                      child: WDiv(
                        className: 'overflow-y-auto p-8',
                        children: [
                          WDiv(
                            key: const ValueKey('wind-marker'),
                            className: 'h-4 bg-red-500',
                          ),
                          WDiv(className: 'h-[400px] bg-blue-500'),
                        ],
                      ),
                    ),
                  ),
                  // Flutter approach
                  Expanded(
                    child: SizedBox(
                      height: 200,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(32), // p-8 = 32px
                        child: Column(
                          children: [
                            Container(
                              key: const ValueKey('flutter-marker'),
                              height: 16,
                              color: Colors.red,
                            ),
                            Container(height: 400, color: Colors.blue),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Get positions of both markers
      final windMarkerPos = tester.getTopLeft(
        find.byKey(const ValueKey('wind-marker')),
      );
      final flutterMarkerPos = tester.getTopLeft(
        find.byKey(const ValueKey('flutter-marker')),
      );

      debugPrint('Wind marker Y: ${windMarkerPos.dy}');
      debugPrint('Flutter marker Y: ${flutterMarkerPos.dy}');

      // Both should have same vertical position (padding applied same way)
      expect(windMarkerPos.dy, closeTo(flutterMarkerPos.dy, 5));
    });
  });
}
