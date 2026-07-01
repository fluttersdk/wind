import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/src/widgets/wind_equal_height_row.dart';

Widget wrapWithTheme(Widget child, {double width = 600}) => MaterialApp(
      home: Scaffold(body: SizedBox(width: width, child: child)),
    );

void main() {
  group('WindEqualHeightRow', () {
    testWidgets('stretches every child to the tallest height', (tester) async {
      const shortKey = Key('short');
      const tallKey = Key('tall');
      await tester.pumpWidget(
        wrapWithTheme(
          const WindEqualHeightRow(
            children: [
              SizedBox(key: shortKey, height: 40, child: Text('s')),
              SizedBox(key: tallKey, height: 120, child: Text('t')),
            ],
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byKey(shortKey)).height, 120);
      expect(tester.getSize(find.byKey(tallKey)).height, 120);
    });

    testWidgets('divides the width equally minus the spacing', (tester) async {
      const aKey = Key('a');
      const bKey = Key('b');
      await tester.pumpWidget(
        wrapWithTheme(
          const WindEqualHeightRow(
            spacing: 20,
            children: [
              SizedBox(key: aKey, height: 10),
              SizedBox(key: bKey, height: 10),
            ],
          ),
        ),
      );

      // (600 - 20) / 2 = 290
      expect(tester.getSize(find.byKey(aKey)).width, 290);
      expect(tester.getSize(find.byKey(bKey)).width, 290);
    });

    testWidgets('updates layout when spacing changes (setter)', (tester) async {
      const aKey = Key('a');
      Widget build(double spacing) => wrapWithTheme(
            WindEqualHeightRow(
              spacing: spacing,
              children: const [
                SizedBox(key: aKey, height: 10),
                SizedBox(height: 10),
              ],
            ),
          );

      await tester.pumpWidget(build(0));
      expect(tester.getSize(find.byKey(aKey)).width, 300); // 600/2

      await tester.pumpWidget(build(40));
      expect(tester.getSize(find.byKey(aKey)).width, 280); // (600-40)/2
    });

    testWidgets('lays out a LayoutBuilder child without asserting',
        (tester) async {
      // The whole point: a child that cannot answer intrinsic queries still
      // lays out (real layout), so no "LayoutBuilder does not support returning
      // intrinsic dimensions" assert.
      await tester.pumpWidget(
        wrapWithTheme(
          WindEqualHeightRow(
            children: [
              const SizedBox(height: 80, child: Text('fixed')),
              LayoutBuilder(
                key: const Key('lb'),
                builder: (context, constraints) =>
                    const SizedBox(height: 30, child: Text('lb')),
              ),
            ],
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      // The LayoutBuilder cell was actually stretched to the 80px tall sibling
      // (its natural height is 30) — proving real layout, not an intrinsic query.
      expect(tester.getSize(find.byKey(const Key('lb'))).height, 80);
    });

    testWidgets('renders with no children (empty)', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const WindEqualHeightRow(children: [])),
      );
      expect(tester.takeException(), isNull);
      expect(find.byType(WindEqualHeightRow), findsOneWidget);
    });

    testWidgets('hit-tests through to a child', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        wrapWithTheme(
          WindEqualHeightRow(
            children: [
              GestureDetector(
                onTap: () => tapped = true,
                child: const SizedBox(height: 60, child: Text('tap me')),
              ),
              const SizedBox(height: 60, child: Text('other')),
            ],
          ),
        ),
      );

      await tester.tap(find.text('tap me'));
      expect(tapped, isTrue);
    });

    testWidgets('degrades safely under an unbounded width', (tester) async {
      // In an unbounded-width context there is no share to divide; the row must
      // not throw and simply sizes to its (zero-width) children.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Align(
              alignment: Alignment.topLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: const WindEqualHeightRow(
                  children: [
                    SizedBox(height: 40, child: Text('u1')),
                    SizedBox(height: 90, child: Text('u2')),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      // Height still equalizes to the tallest even with no width to divide.
      expect(tester.getSize(find.byType(WindEqualHeightRow)).height, 90);
    });
  });
}
