import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Pixel-exact characterization of spacing + sizing tokens.
///
/// Asserts the documented Tailwind v3 output (baseSpacingUnit 4.0): one spacing
/// step = 4 px, so `p-4` = 16, `p-2.5` = 10, `m-2` = 8, `gap-4` = 16. Sizing:
/// `w-10`/`h-10` = 40, `w-1/2` = half the parent, `max-w-prose` = 512.
///
/// Geometry is measured from the actually-rendered render tree via
/// [WidgetTester.getRect] / [WidgetTester.getSize] / [WidgetTester.getTopLeft]
/// with an epsilon of 0.5 px, not from the parsed [WindStyle]. This catches
/// composition-pipeline regressions a parser-level probe would miss.

/// Epsilon for pixel geometry comparisons (sub-pixel rounding tolerance).
const double _eps = 0.5;

Widget wrapWithTheme(Widget child) {
  return MaterialApp(
    home: WindTheme(
      data: WindThemeData(),
      child: Scaffold(body: child),
    ),
  );
}

void main() {
  setUp(WindParser.clearCache);

  group('Padding (4 px per step)', () {
    testWidgets('p-4 insets the child by 16 on every side', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          Align(
            alignment: Alignment.topLeft,
            child: WDiv(
              className: 'p-4',
              child: const SizedBox(
                key: ValueKey('marker'),
                width: 20,
                height: 20,
              ),
            ),
          ),
        ),
      );

      final outer = tester.getTopLeft(find.byType(WDiv));
      final marker = tester.getTopLeft(find.byKey(const ValueKey('marker')));

      expect(marker.dx - outer.dx, moreOrLessEquals(16.0, epsilon: _eps));
      expect(marker.dy - outer.dy, moreOrLessEquals(16.0, epsilon: _eps));
    });

    testWidgets('p-2.5 insets the child by 10 (half-step scale)', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          Align(
            alignment: Alignment.topLeft,
            child: WDiv(
              className: 'p-2.5',
              child: const SizedBox(
                key: ValueKey('marker'),
                width: 20,
                height: 20,
              ),
            ),
          ),
        ),
      );

      final outer = tester.getTopLeft(find.byType(WDiv));
      final marker = tester.getTopLeft(find.byKey(const ValueKey('marker')));

      expect(marker.dx - outer.dx, moreOrLessEquals(10.0, epsilon: _eps));
      expect(marker.dy - outer.dy, moreOrLessEquals(10.0, epsilon: _eps));
    });

    testWidgets('px-3 insets horizontally by 12, vertically by 0 (#61)', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          Align(
            alignment: Alignment.topLeft,
            child: WDiv(
              className: 'px-3',
              child: const SizedBox(
                key: ValueKey('marker'),
                width: 20,
                height: 20,
              ),
            ),
          ),
        ),
      );

      final outer = tester.getTopLeft(find.byType(WDiv));
      final marker = tester.getTopLeft(find.byKey(const ValueKey('marker')));

      // #61: px-3 = 12 px horizontal padding, zero vertical.
      expect(marker.dx - outer.dx, moreOrLessEquals(12.0, epsilon: _eps));
      expect(marker.dy - outer.dy, moreOrLessEquals(0.0, epsilon: _eps));
    });
  });

  group('Margin (4 px per step)', () {
    testWidgets('m-2 offsets the child by 8 on every side', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          Align(
            alignment: Alignment.topLeft,
            child: WDiv(
              className: 'm-2',
              child: const SizedBox(
                key: ValueKey('marker'),
                width: 20,
                height: 20,
              ),
            ),
          ),
        ),
      );

      final outer = tester.getTopLeft(find.byType(WDiv));
      final marker = tester.getTopLeft(find.byKey(const ValueKey('marker')));

      expect(marker.dx - outer.dx, moreOrLessEquals(8.0, epsilon: _eps));
      expect(marker.dy - outer.dy, moreOrLessEquals(8.0, epsilon: _eps));
    });
  });

  group('Gap (4 px per step)', () {
    testWidgets('gap-4 puts 16 between flex children', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          Align(
            alignment: Alignment.topLeft,
            child: WDiv(
              className: 'flex flex-row gap-4',
              children: const [
                SizedBox(key: ValueKey('a'), width: 20, height: 20),
                SizedBox(key: ValueKey('b'), width: 20, height: 20),
              ],
            ),
          ),
        ),
      );

      final a = tester.getRect(find.byKey(const ValueKey('a')));
      final b = tester.getTopLeft(find.byKey(const ValueKey('b')));

      // b.left - a.right == gap.
      expect(b.dx - a.right, moreOrLessEquals(16.0, epsilon: _eps));
    });
  });

  group('Sizing (4 px per step)', () {
    testWidgets('w-10 / h-10 render a 40x40 box', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          Align(
            alignment: Alignment.topLeft,
            child: WDiv(
              key: const ValueKey('sized'),
              className: 'w-10 h-10',
            ),
          ),
        ),
      );

      final size = tester.getSize(find.byKey(const ValueKey('sized')));
      expect(size.width, moreOrLessEquals(40.0, epsilon: _eps));
      expect(size.height, moreOrLessEquals(40.0, epsilon: _eps));
    });

    testWidgets('w-1/2 renders half the parent width', (tester) async {
      // Size the viewport so the bounded parent has a known width.
      tester.view.physicalSize = const Size(600, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        wrapWithTheme(
          SizedBox(
            width: 400,
            child: WDiv(
              key: const ValueKey('half'),
              className: 'w-1/2',
              // A full-width marker so its rendered width equals the
              // FractionallySizedBox's resolved content width.
              child: const SizedBox(
                key: ValueKey('marker'),
                width: double.infinity,
                height: 20,
              ),
            ),
          ),
        ),
      );

      // w-1/2 wraps in FractionallySizedBox(widthFactor: 0.5). Scope the finder
      // to the WDiv under test (via its `half` key) so an unrelated
      // FractionallySizedBox in the app shell cannot make this assertion fail.
      final fractionalFinder = find.descendant(
        of: find.byKey(const ValueKey('half')),
        matching: find.byType(FractionallySizedBox),
      );
      expect(fractionalFinder, findsOneWidget);
      final fsb = tester.widget<FractionallySizedBox>(fractionalFinder);
      expect(fsb.widthFactor, 0.5);

      // The child is laid out at half of the 400 px bounded parent.
      final size = tester.getSize(find.byKey(const ValueKey('marker')));
      expect(size.width, moreOrLessEquals(200.0, epsilon: _eps));
    });

    testWidgets('max-w-prose caps width at 512', (tester) async {
      // Viewport wider than 512 so the cap is the binding constraint. The WDiv
      // sits under loose (Align) width constraints: a max-only constraint binds
      // only when the parent does not force a tight width, mirroring CSS
      // max-width on a block element.
      tester.view.physicalSize = const Size(900, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        wrapWithTheme(
          Align(
            alignment: Alignment.topLeft,
            child: WDiv(
              className: 'max-w-prose',
              // A full-width child reaches for the cap; its rendered width is
              // the effective max-width.
              child: const SizedBox(
                key: ValueKey('marker'),
                width: double.infinity,
                height: 20,
              ),
            ),
          ),
        ),
      );

      // max-w-prose = 512 px (Wind's fixed value, not Tailwind's 65ch).
      final size = tester.getSize(find.byKey(const ValueKey('marker')));
      expect(size.width, moreOrLessEquals(512.0, epsilon: _eps));
    });
  });
}
