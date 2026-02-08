import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

void main() {
  group('Sizing Parsing Tests', () {
    testWidgets('Parsing width/height numeric values correctly (using theme)', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(), // base: 4.0
            child: const WDiv(className: 'w-10 h-20', children: [Text('Test')]),
          ),
        ),
      );

      // w-10 -> 10 * 4 = 40.0
      // h-20 -> 20 * 4 = 80.0

      final containerFinder = find.byType(Container);
      expect(containerFinder, findsOneWidget);
      final Container container = tester.widget(containerFinder);
      expect(container.constraints!.minWidth, 40.0);
      expect(container.constraints!.maxWidth, 40.0);
      expect(container.constraints!.minHeight, 80.0);
      expect(container.constraints!.maxHeight, 80.0);
    });

    testWidgets('Parsing fractions', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'w-1/2 h-full',
              children: [Text('Test')],
            ),
          ),
        ),
      );

      expect(find.byType(FractionallySizedBox), findsOneWidget);
      final FractionallySizedBox box = tester.widget(
        find.byType(FractionallySizedBox),
      );
      expect(box.widthFactor, 0.5);
      expect(box.heightFactor, 1.0);
    });

    group('Sizing Optimization Tests', () {
      testWidgets('Optimization: w-full uses SizedBox, avoids LayoutBuilder', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: WindTheme(
              data: WindThemeData(),
              child: const WDiv(className: 'w-full', child: Text('Test')),
            ),
          ),
        );

        final wDivFinder = find.byType(WDiv);

        // Crucial: w-full should NOT use LayoutBuilder (optimization)
        expect(
          find.descendant(of: wDivFinder, matching: find.byType(LayoutBuilder)),
          findsNothing,
          reason: 'w-full should be optimized to avoid LayoutBuilder',
        );

        // Should use SizedBox(width: double.infinity)
        final sizedBoxFinder = find.descendant(
          of: wDivFinder,
          matching: find.byType(SizedBox),
        );

        bool foundInfiniteWidth = false;
        tester.widgetList<SizedBox>(sizedBoxFinder).forEach((box) {
          if (box.width == double.infinity) foundInfiniteWidth = true;
        });
        expect(
          foundInfiniteWidth,
          isTrue,
          reason: 'w-full should use SizedBox with infinite width',
        );
      });

      testWidgets('Optimization: w-1/2 uses FractionallySizedBox', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: WindTheme(
              data: WindThemeData(),
              child: const WDiv(className: 'w-1/2', child: Text('Test')),
            ),
          ),
        );

        final wDivFinder = find.byType(WDiv);

        // Should use FractionallySizedBox
        expect(
          find.descendant(
            of: wDivFinder,
            matching: find.byType(FractionallySizedBox),
          ),
          findsOneWidget,
        );

        // Should NOT use LayoutBuilder
        expect(
          find.descendant(of: wDivFinder, matching: find.byType(LayoutBuilder)),
          findsNothing,
        );
      });

      testWidgets('Conflict: h-full uses LayoutBuilder in unbounded constraint',
          (
        tester,
      ) async {
        // Place WDiv in a Column to provide unbounded vertical constraints
        await tester.pumpWidget(
          MaterialApp(
            home: WindTheme(
              data: WindThemeData(),
              child: Column(
                children: [
                  // h-full needs to resolve against something.
                  // In an unbounded column, it triggers the LayoutBuilder check
                  // to potentially fallback to screen height or similar strategies if implemented,
                  // or just to safely handle the constraints.
                  const WDiv(className: 'h-full', child: Text('Test')),
                ],
              ),
            ),
          ),
        );

        final wDivFinder = find.byType(WDiv);
        expect(
          find.descendant(of: wDivFinder, matching: find.byType(LayoutBuilder)),
          findsOneWidget,
          reason:
              'h-full in unbounded parent requires LayoutBuilder to check constraints',
        );
      });
    });
  });
}
