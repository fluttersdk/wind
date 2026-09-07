import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

void main() {
  setUp(WindParser.clearCache);

  group('Childless sizing (issue #123)', () {
    testWidgets('a childless WDiv honors size-* (renders a square box)',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const Center(
              child: WDiv(className: 'size-2 rounded-full bg-red-500'),
            ),
          ),
        ),
      );

      // size-2 -> 2 * 4 = 8 logical px on both axes.
      expect(tester.getSize(find.byType(WDiv)), const Size(8, 8));
    });

    testWidgets('a childless WDiv honors w-*/h-* without a child',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const Center(
              child: WDiv(className: 'w-10 h-10 bg-red-500'),
            ),
          ),
        ),
      );

      expect(tester.getSize(find.byType(WDiv)), const Size(40, 40));
    });

    testWidgets('a childless size-* dot keeps its box inside a flex row',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const Center(
              child: WDiv(
                className: 'flex flex-row items-center gap-2',
                children: [
                  WDiv(className: 'size-2 rounded-full bg-green-500'),
                  Text('Active'),
                ],
              ),
            ),
          ),
        ),
      );

      final dot = find.byType(WDiv).last;
      expect(tester.getSize(dot), const Size(8, 8));
    });
  });

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

      // Asserted on the resulting SIZE rather than on the widget that
      // produced it. The previous version looked for a `FractionallySizedBox`
      // carrying the two factors, which pinned one composition rather than the
      // behaviour: `h-full` now resolves through `WindFullHeightBox` and the
      // element sizes identically. A white-box assertion here fails on a change
      // that a user cannot see, and passes on one they can.
      final Size size = tester.getSize(find.text('Test'));
      final Size screen =
          tester.view.physicalSize / tester.view.devicePixelRatio;

      expect(size.width, screen.width / 2);
      expect(size.height, screen.height);
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

        // The height it RESOLVED TO, not the widget it used to get there.
        // This asserted a `LayoutBuilder` descendant, which is the thing the
        // render-layer rewrite removed on purpose: `h-full` in an unbounded
        // column still falls back to the screen height, and that fallback is
        // the behaviour worth pinning.
        final double screenHeight =
            tester.view.physicalSize.height / tester.view.devicePixelRatio;
        expect(tester.getSize(find.text('Test')).height, screenHeight);

        // Deliberately no assertion about WHICH widget produced that height.
        // The old one named `LayoutBuilder`, and naming its replacement would
        // repeat the mistake: the next rewrite would fail this test without
        // changing anything a user can observe.
        expect(
          find.byType(WDiv),
          findsOneWidget,
          reason:
              'h-full in unbounded parent requires LayoutBuilder to check constraints',
        );
      });
    });
  });
}
