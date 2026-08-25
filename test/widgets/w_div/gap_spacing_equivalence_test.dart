import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// `gap-*` used to be built by injecting a `SizedBox` between every pair of
/// children, which makes the gaps real flex children. Flutter's own
/// `Flex.spacing` (available since 3.27, which is this package's floor) does
/// the same job at the render layer with no widget at all, and `SizedBox` was
/// the single most numerous wrapper measured against a real app: 1250 across a
/// four-route tour, 1.14 per `WDiv` built.
///
/// The swap is only free where the two agree, and they do not agree
/// everywhere: injected gaps are children, so a `space-around` or
/// `space-evenly` distribution counts them and lands the real children in
/// different places. This file pins the positions under EVERY alignment so the
/// optimisation cannot quietly move a layout, and so the two alignments that
/// keep the old path are recorded as a deliberate exclusion rather than an
/// oversight.
Widget wrapWithTheme(Widget child) {
  return MaterialApp(
    home: WindTheme(
      data: WindThemeData(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: child,
      ),
    ),
  );
}

void main() {
  // The parser cache is static and survives between tests, so a neighbour
  // priming it can make this file pass on logic that regressed. See
  // `.claude/rules/tests.md`.
  setUp(WindParser.clearCache);

  /// Left edge of each lettered box, in order.
  List<double> childLefts(WidgetTester tester) {
    return <String>['a', 'b', 'c']
        .map((String key) =>
            tester.getTopLeft(find.byKey(ValueKey<String>(key))).dx)
        .toList();
  }

  Future<void> pumpRow(WidgetTester tester, String justify) async {
    await tester.pumpWidget(
      wrapWithTheme(
        Center(
          child: SizedBox(
            width: 400,
            child: WDiv(
              className: 'flex flex-row w-full gap-4 $justify',
              children: const <Widget>[
                SizedBox(key: ValueKey<String>('a'), width: 40, height: 10),
                SizedBox(key: ValueKey<String>('b'), width: 40, height: 10),
                SizedBox(key: ValueKey<String>('c'), width: 40, height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  group('gap-* keeps its layout when spacing moves to the render layer', () {
    // 400 wide, three 40px children, `gap-4`. Wind's spacing scale is 4
    // logical px per step, so `gap-4` is 16px and a packed pair sits 56 apart.
    // Every assertion is a DISTANCE between children rather than an absolute
    // x, so the test does not encode the surface width or the centring.
    testWidgets('justify-start packs left with one gap between each pair',
        (WidgetTester tester) async {
      await pumpRow(tester, 'justify-start');
      final List<double> x = childLefts(tester);
      expect(x[1] - x[0], 56.0,
          reason: '40 wide plus a gap-4 of 16 logical px');
      expect(x[2] - x[1], 56.0);
    });

    testWidgets('justify-center keeps the pair distance', (tester) async {
      await pumpRow(tester, 'justify-center');
      final List<double> x = childLefts(tester);
      expect(x[1] - x[0], 56.0);
      expect(x[2] - x[1], 56.0);
    });

    testWidgets('justify-end keeps the pair distance', (tester) async {
      await pumpRow(tester, 'justify-end');
      final List<double> x = childLefts(tester);
      expect(x[1] - x[0], 56.0);
      expect(x[2] - x[1], 56.0);
    });

    testWidgets('justify-between spreads to the edges and stays symmetric',
        (WidgetTester tester) async {
      await pumpRow(tester, 'justify-between');
      final List<double> x = childLefts(tester);
      // Whatever the free space works out to, the two inner distances match
      // and the row still spans the full width.
      expect(x[1] - x[0], closeTo(x[2] - x[1], 0.01));
      expect(x[2] + 40 - x[0], 400.0);
    });

    testWidgets('justify-evenly keeps the distribution it has always had',
        (WidgetTester tester) async {
      // The excluded case. With injected gaps the row has FIVE children, so
      // `spaceEvenly` divides the free space into six slots and the real
      // children land 138.67 apart. Handing the gap to `Flex.spacing` would
      // leave three children and four slots, putting them 118 apart.
      //
      // The distance is the assertion precisely because a symmetry check is
      // not one: both mechanisms space children evenly, so `x1 - x0 == x2 -
      // x1` holds either way and would pass on the regression it is supposed
      // to catch.
      await pumpRow(tester, 'justify-evenly');
      final List<double> x = childLefts(tester);
      expect(x[1] - x[0], closeTo(138.667, 0.01));
      expect(x[2] - x[1], closeTo(138.667, 0.01));
    });

    testWidgets('justify-around keeps the distribution it has always had',
        (WidgetTester tester) async {
      // Same exclusion, same reason: `spaceAround` gives each of the five
      // children its own half-share on both sides, which lands the real ones
      // 155.2 apart. A distance, not a symmetry check, for the reason above.
      await pumpRow(tester, 'justify-around');
      final List<double> x = childLefts(tester);
      expect(x[1] - x[0], closeTo(155.2, 0.01));
      expect(x[2] - x[1], closeTo(155.2, 0.01));
    });

    testWidgets('an excluded alignment keeps the old path on a COLUMN too',
        (WidgetTester tester) async {
      // The exclusion is expressed once, for both axes, but every other case
      // here pumps a row. This is the vertical half: `SizedBox(height: gap)`
      // rather than `SizedBox(width: gap)`, and nothing exercised it.
      await tester.pumpWidget(
        wrapWithTheme(
          Center(
            child: SizedBox(
              height: 400,
              child: WDiv(
                className: 'flex flex-col h-full gap-4 justify-evenly',
                children: const <Widget>[
                  SizedBox(key: ValueKey<String>('a'), width: 10, height: 40),
                  SizedBox(key: ValueKey<String>('b'), width: 10, height: 40),
                  SizedBox(key: ValueKey<String>('c'), width: 10, height: 40),
                ],
              ),
            ),
          ),
        ),
      );

      double topOf(String k) =>
          tester.getTopLeft(find.byKey(ValueKey<String>(k))).dy;

      // Same arithmetic as the row case, on the other axis: five children
      // (three plus two gaps) share the free space, so the real ones sit
      // 138.67 apart. Handing the gap to `Flex.spacing` would leave three
      // children and put them 118 apart.
      expect(topOf('b') - topOf('a'), closeTo(138.667, 0.01));
      expect(topOf('c') - topOf('b'), closeTo(138.667, 0.01));
    });

    testWidgets('a column gap spaces on the vertical axis', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          Center(
            child: SizedBox(
              height: 400,
              child: WDiv(
                className: 'flex flex-col gap-4',
                children: const <Widget>[
                  SizedBox(key: ValueKey<String>('a'), width: 10, height: 40),
                  SizedBox(key: ValueKey<String>('b'), width: 10, height: 40),
                ],
              ),
            ),
          ),
        ),
      );

      final double ay =
          tester.getTopLeft(find.byKey(const ValueKey<String>('a'))).dy;
      final double by =
          tester.getTopLeft(find.byKey(const ValueKey<String>('b'))).dy;
      expect(by - ay, 56.0);
    });

    testWidgets('gap-0 and no gap emit no spacing at all', (tester) async {
      await pumpRow(tester, 'justify-start');
      final List<double> withGap = childLefts(tester);

      await tester.pumpWidget(
        wrapWithTheme(
          Center(
            child: SizedBox(
              width: 400,
              child: WDiv(
                className: 'flex flex-row w-full justify-start',
                children: const <Widget>[
                  SizedBox(key: ValueKey<String>('a'), width: 40, height: 10),
                  SizedBox(key: ValueKey<String>('b'), width: 40, height: 10),
                  SizedBox(key: ValueKey<String>('c'), width: 40, height: 10),
                ],
              ),
            ),
          ),
        ),
      );
      final List<double> noGap = childLefts(tester);

      expect(withGap[1] - withGap[0], 56.0);
      expect(noGap[1] - noGap[0], 40.0);
    });
  });
}
