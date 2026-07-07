import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';
import 'package:fluttersdk_wind/src/widgets/wind_equal_height_row.dart';

/// WIND-4 render-object coverage: the intrinsic-free `WindCrossStretch`
/// (cross-axis stretch) and the `WindMainExtentProvider` / `WindFractionBasis`
/// pair (fractional `basis-*` resolved against the flex's own extent) exercised
/// directly and through a `flex flex-col` so both the bounded/unbounded stretch
/// branches and the column (vertical main-axis) basis path are covered.
Widget host(Widget child) => Directionality(
      textDirection: TextDirection.ltr,
      child: Align(alignment: Alignment.topLeft, child: child),
    );

Widget wrapWind(Widget child, {double? width, double? height}) => MaterialApp(
      home: WindTheme(
        data: WindThemeData(),
        child: Scaffold(
          body: SizedBox(width: width, height: height, child: child),
        ),
      ),
    );

void main() {
  setUp(WindParser.clearCache);

  group('WindCrossStretch', () {
    testWidgets('stretches the child to a bounded incoming width',
        (tester) async {
      await tester.pumpWidget(
        host(
          const SizedBox(
            width: 300,
            child: WindCrossStretch(child: SizedBox(width: 20, height: 10)),
          ),
        ),
      );

      expect(tester.getSize(find.byType(WindCrossStretch)).width, 300);
    });

    testWidgets('passes the child through at content width when unbounded',
        (tester) async {
      await tester.pumpWidget(
        host(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              WindCrossStretch(child: SizedBox(width: 42, height: 10)),
            ],
          ),
        ),
      );

      expect(tester.getSize(find.byType(WindCrossStretch)).width, 42);
    });
  });

  group('column fractional basis (WindMainExtentProvider / WindFractionBasis)',
      () {
    testWidgets('basis-1/2 resolves against the column height', (tester) async {
      await tester.pumpWidget(
        wrapWind(
          height: 400,
          const WDiv(
            className: 'flex flex-col',
            children: [
              WDiv(className: 'basis-1/2 w-10 bg-red-500', child: SizedBox()),
            ],
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      // Half of a 400px-tall column.
      expect(tester.getSize(find.byType(WDiv).at(1)).height, 200);
    });

    testWidgets('rebuilding with a new basis factor re-lays the child',
        (tester) async {
      Widget tree(String basis) => wrapWind(
            height: 400,
            WDiv(
              className: 'flex flex-col',
              children: [
                WDiv(
                  className: '$basis w-10 bg-red-500',
                  child: const SizedBox(),
                ),
              ],
            ),
          );

      await tester.pumpWidget(tree('basis-1/2'));
      expect(tester.getSize(find.byType(WDiv).at(1)).height, 200);
      // Same widget position, new factor: exercises the render-object update
      // path (factor/port setters) rather than a fresh create.
      await tester.pumpWidget(tree('basis-1/4'));
      expect(tester.getSize(find.byType(WDiv).at(1)).height, 100);
    });

    testWidgets('flipping the flex direction re-lays the basis child',
        (tester) async {
      Widget tree(String direction) => wrapWind(
            width: 400,
            height: 400,
            WDiv(
              className: 'flex $direction',
              children: [
                WDiv(
                  className: 'basis-1/2 bg-red-500',
                  child: const SizedBox(width: 10, height: 10),
                ),
              ],
            ),
          );

      // Column: basis sizes height. Flipping to row (same widget position)
      // exercises the isColumn setters on the extent provider and fraction box.
      await tester.pumpWidget(tree('flex-col'));
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(tree('flex-row'));
      expect(tester.takeException(), isNull);
    });
  });
}
