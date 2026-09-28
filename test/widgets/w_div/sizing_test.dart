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

  // Pinned against the geometry `Container` produced before the box model was
  // rebuilt from primitives. Each case exercises one of the three behaviours
  // that rebuild has to reproduce: a childless box expanding through
  // `LimitedBox`, padding inset by the border widths, and `width`/`height`
  // tightening the constraints.
  group('Box model geometry', () {
    Future<void> pumpInColumn(WidgetTester tester, Widget child) {
      return tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: Scaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[child],
              ),
            ),
          ),
        ),
      );
    }

    Future<void> pumpCentered(WidgetTester tester, Widget child) {
      return tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: Center(child: child),
          ),
        ),
      );
    }

    testWidgets('an empty divider fills the cross axis of a start column', (
      tester,
    ) async {
      await pumpInColumn(
        tester,
        const WDiv(className: 'h-[1px] bg-gray-200'),
      );

      expect(tester.getSize(find.byType(WDiv)), const Size(800, 1));
    });

    testWidgets('an empty box with no height collapses in a start column', (
      tester,
    ) async {
      // `h-px` is not a sizing token, so no height reaches the box. The
      // childless box then expands across the bounded width and collapses on
      // the unbounded height through `LimitedBox`.
      await pumpInColumn(
        tester,
        const WDiv(className: 'h-px bg-gray-200'),
      );

      expect(tester.getSize(find.byType(WDiv)), const Size(800, 0));
    });

    testWidgets('padding sits inside the border of a rounded box', (
      tester,
    ) async {
      const Key childKey = ValueKey<String>('child');
      await pumpCentered(
        tester,
        const WDiv(
          className: 'border-2 rounded-lg p-4 bg-white',
          child: SizedBox(key: childKey, width: 20, height: 10),
        ),
      );

      final Finder box = find.byType(WDiv);
      expect(tester.getSize(box), const Size(56, 46));
      expect(
        tester.getTopLeft(find.byKey(childKey)) - tester.getTopLeft(box),
        const Offset(18, 18),
      );
    });

    testWidgets('w-full stretches a decorated box across the column', (
      tester,
    ) async {
      await pumpInColumn(
        tester,
        const WDiv(
          className: 'w-full bg-white p-2',
          child: SizedBox(width: 10, height: 10),
        ),
      );

      expect(tester.getSize(find.byType(WDiv)), const Size(800, 26));
    });

    testWidgets('w-full is clamped by max-w-* when tightened', (tester) async {
      await pumpInColumn(
        tester,
        const WDiv(
          className: 'w-full max-w-sm bg-white',
          child: SizedBox(width: 10, height: 10),
        ),
      );

      expect(tester.getSize(find.byType(WDiv)), const Size(384, 10));
    });

    testWidgets('an aligned box positions its child inside a fixed size', (
      tester,
    ) async {
      const Key childKey = ValueKey<String>('child');
      await pumpCentered(
        tester,
        const WDiv(
          className: 'self-center w-40 h-20 bg-white',
          child: SizedBox(key: childKey, width: 10, height: 10),
        ),
      );

      // The outer `Align` for `self-center` fills the screen; the decorated
      // box inside it keeps its fixed size and centres the child.
      final Finder decorated = find
          .descendant(
            of: find.byType(WDiv),
            matching: find.byType(DecoratedBox),
          )
          .first;
      expect(tester.getSize(find.byType(WDiv)), const Size(800, 600));
      expect(tester.getSize(decorated), const Size(160, 80));
      expect(tester.getTopLeft(decorated), const Offset(320, 260));
      expect(tester.getTopLeft(find.byKey(childKey)), const Offset(395, 295));
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

      // The box carries its constraints on a ConstrainedBox since it was
      // rebuilt from primitives; there is no Container to read them from.
      final boxFinder = find.descendant(
        of: find.byType(WDiv),
        matching: find.byType(ConstrainedBox),
      );
      expect(boxFinder, findsOneWidget);
      final ConstrainedBox box = tester.widget(boxFinder);
      expect(box.constraints.minWidth, 40.0);
      expect(box.constraints.maxWidth, 40.0);
      expect(box.constraints.minHeight, 80.0);
      expect(box.constraints.maxHeight, 80.0);
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
              'h-full in an unbounded parent falls back to the screen height',
        );
      });
    });
  });
}
