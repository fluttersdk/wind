import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Tests for the flex child tokens `grow`, `grow-0`, `basis-*`, and the
/// corrected `flex-none` (CSS `flex: 0 0 auto` — no grow AND no shrink).
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

  group('grow / grow-0', () {
    testWidgets('grow makes a Row child expand to fill (flex: 1)',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const SizedBox(
            width: 300,
            child: WDiv(
              className: 'flex flex-row',
              children: [
                WDiv(className: 'grow h-10 bg-red-500', child: SizedBox()),
                WDiv(className: 'w-16 h-10 bg-blue-500', child: SizedBox()),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      // grow -> Expanded(flex: 1): takes the remaining 300 - 64 = 236px.
      expect(tester.getSize(find.byType(WDiv).at(1)).width, 236);
      expect(find.byType(Expanded), findsOneWidget);
    });

    testWidgets('grow-0 child keeps intrinsic width (no Expanded)',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const SizedBox(
            width: 300,
            child: WDiv(
              className: 'flex flex-row',
              children: [
                WDiv(
                  className: 'grow-0 w-16 h-10 bg-red-500',
                  child: SizedBox(),
                ),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(Expanded), findsNothing);
      expect(tester.getSize(find.byType(WDiv).at(1)).width, 64);
    });
  });

  group('basis-*', () {
    testWidgets('basis-1/2 in a row sets child main-size to half',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const SizedBox(
            width: 400,
            child: WDiv(
              className: 'flex flex-row',
              children: [
                WDiv(
                  className: 'basis-1/2 h-10 bg-red-500',
                  child: SizedBox(),
                ),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      // basis-1/2 -> half of the 400px main axis.
      expect(tester.getSize(find.byType(WDiv).at(1)).width, 200);
    });

    testWidgets('basis-[120px] in a row sets a fixed main-size',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const SizedBox(
            width: 400,
            child: WDiv(
              className: 'flex flex-row',
              children: [
                WDiv(
                  className: 'basis-[120px] h-10 bg-red-500',
                  child: SizedBox(),
                ),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(WDiv).at(1)).width, 120);
    });

    testWidgets('basis-1/2 in a column sets child main-size (height) to half',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const SizedBox(
            height: 400,
            child: WDiv(
              className: 'flex flex-col',
              children: [
                WDiv(
                  className: 'basis-1/2 w-10 bg-red-500',
                  child: SizedBox(),
                ),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(WDiv).at(1)).height, 200);
    });
  });

  group('flex-none (CSS flex: 0 0 auto)', () {
    testWidgets('flex-none child in a justify-between Row does NOT shrink',
        (tester) async {
      const fixedText = 'Subscribe';

      await tester.pumpWidget(
        wrapWithTheme(
          const SizedBox(
            width: 400,
            child: WDiv(
              className: 'flex flex-row justify-between',
              children: [
                WDiv(
                  className: 'flex-1',
                  child: WText('Title that grows'),
                ),
                WDiv(
                  className: 'flex-none px-2',
                  child: WText(fixedText),
                ),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);

      // flex-none must not be wrapped in Flexible (which would let it shrink).
      final row = tester.widget<Row>(find.byType(Row).first);
      final flexibleCount = row.children
          .where((child) => child is Flexible && child is! Expanded)
          .length;
      expect(
        flexibleCount,
        0,
        reason: 'flex-none child must not be wrapped with Flexible',
      );

      // It must keep its intrinsic width (not the 200px equal-flex split).
      final badgeWidth = tester.getSize(find.text(fixedText)).width;
      expect(badgeWidth, greaterThan(0));
      expect(badgeWidth, isNot(equals(200.0)));
      expect(badgeWidth, lessThan(400));
    });

    testWidgets('standalone flex-none WDiv builds with no Flexible self-wrap',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const WDiv(
            className: 'flex-none w-16 h-16 bg-gray-200',
            child: SizedBox(),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(Flexible), findsNothing);
    });
  });
}
