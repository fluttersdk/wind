import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

Widget wrap(Widget child, {double width = 600}) => MaterialApp(
      home: WindTheme(
        data: WindThemeData(),
        child: Scaffold(body: SizedBox(width: width, child: child)),
      ),
    );

Size cellOf(WidgetTester tester, String text) => tester.getSize(
      find.ancestor(of: find.text(text), matching: find.byType(WDiv)).first,
    );

void main() {
  setUp(WindParser.clearCache);

  group('grid items-stretch equal-height (issue #126)', () {
    testWidgets('cells in a row stretch to the tallest', (tester) async {
      await tester.pumpWidget(
        wrap(
          WDiv(
            className: 'grid grid-cols-2 gap-4 items-stretch',
            children: [
              WDiv(
                className: 'bg-blue-100 dark:bg-blue-900',
                child: const SizedBox(height: 40, child: Text('short')),
              ),
              WDiv(
                className: 'bg-red-100 dark:bg-red-900',
                child: const SizedBox(height: 120, child: Text('tall')),
              ),
            ],
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(cellOf(tester, 'short').height, 120);
      expect(cellOf(tester, 'tall').height, 120);
    });

    testWidgets('cells divide the row width evenly (minus the gap)',
        (tester) async {
      await tester.pumpWidget(
        wrap(
          WDiv(
            className: 'grid grid-cols-2 gap-4 items-stretch',
            children: [
              WDiv(child: const Text('a')),
              WDiv(child: const Text('b')),
            ],
          ),
        ),
      );

      // (600 - 16 gap) / 2 = 292
      expect(cellOf(tester, 'a').width, 292);
      expect(cellOf(tester, 'b').width, 292);
    });

    testWidgets('a ragged final row does not crash and keeps columns aligned',
        (tester) async {
      await tester.pumpWidget(
        wrap(
          WDiv(
            className: 'grid grid-cols-2 gap-4 items-stretch',
            children: [
              WDiv(child: const Text('c1')),
              WDiv(child: const Text('c2')),
              WDiv(child: const Text('c3')),
            ],
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      // c3 sits in its own row, still a single column-width Expanded slot.
      expect(cellOf(tester, 'c3').width, 292);
    });

    testWidgets('default grid (no items-stretch) keeps intrinsic heights',
        (tester) async {
      await tester.pumpWidget(
        wrap(
          WDiv(
            className: 'grid grid-cols-2 gap-4',
            children: [
              WDiv(
                className: 'bg-blue-100 dark:bg-blue-900',
                child: const SizedBox(height: 40, child: Text('ds')),
              ),
              WDiv(
                className: 'bg-red-100 dark:bg-red-900',
                child: const SizedBox(height: 120, child: Text('dt')),
              ),
            ],
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      // Wrap path: the short cell stays at its own intrinsic height.
      expect(cellOf(tester, 'ds').height, 40);
    });
  });
}
