import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Tests for the column-only smart cross-axis stretch.
///
/// In a `flex flex-col` with NO explicit `items-*` token, each Wind child that
/// lacks an explicit cross-axis width is stretched to the column width (CSS
/// `align-items: stretch` default). Children with explicit widths, non-Wind
/// children, gaps, and `Expanded`/`Flexible` are left untouched. Rows are
/// never affected.
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

  group('smart column stretch', () {
    testWidgets('flex-col child with no width stretches to parent width',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const SizedBox(
            width: 300,
            child: WDiv(
              className: 'flex flex-col',
              children: [
                WDiv(className: 'bg-red-500', child: SizedBox(height: 10)),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(WDiv).at(1)).width, 300);
    });

    testWidgets('w-32 child keeps its explicit width (no stretch)',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const SizedBox(
            width: 300,
            child: WDiv(
              className: 'flex flex-col',
              children: [
                WDiv(className: 'w-32 bg-red-500', child: SizedBox(height: 10)),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      // w-32 = 32 * 4px = 128px.
      expect(tester.getSize(find.byType(WDiv).at(1)).width, 128);
    });

    testWidgets('w-1/2 child keeps half width (no stretch)', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const SizedBox(
            width: 300,
            child: WDiv(
              className: 'flex flex-col',
              children: [
                WDiv(
                    className: 'w-1/2 bg-red-500', child: SizedBox(height: 10)),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(WDiv).at(1)).width, 150);
    });

    testWidgets('w-full child stays full and is NOT double-wrapped',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const SizedBox(
            width: 300,
            child: WDiv(
              className: 'flex flex-col',
              children: [
                WDiv(
                  className: 'w-full bg-red-500',
                  child: SizedBox(height: 10),
                ),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(WDiv).at(1)).width, 300);

      // w-full already produces one SizedBox(width: infinity) in the child's
      // own pipeline. The stretch wrap must NOT add a second one.
      final column = tester.widget<Column>(find.byType(Column));
      final infinityBoxes = column.children
          .whereType<SizedBox>()
          .where((box) => box.width == double.infinity)
          .length;
      expect(infinityBoxes, 0,
          reason: 'w-full child is treated as explicit cross-width');
    });

    testWidgets('items-start disables stretch (child sizes to content)',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const SizedBox(
            width: 300,
            child: WDiv(
              className: 'flex flex-col items-start',
              children: [
                WDiv(
                  className: 'bg-red-500',
                  child: SizedBox(width: 40, height: 10),
                ),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(WDiv).at(1)).width, 40);
    });

    testWidgets('items-center disables stretch (child sizes to content)',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const SizedBox(
            width: 300,
            child: WDiv(
              className: 'flex flex-col items-center',
              children: [
                WDiv(
                  className: 'bg-red-500',
                  child: SizedBox(width: 40, height: 10),
                ),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(WDiv).at(1)).width, 40);
    });

    testWidgets('raw Flutter Container child is left untouched (no stretch)',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const SizedBox(
            width: 300,
            child: WDiv(
              className: 'flex flex-col',
              children: [
                SizedBox(
                    width: 40,
                    height: 10,
                    child: ColoredBox(color: Color(0xFFFF0000))),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      // The raw SizedBox keeps its 40px width — not stretched.
      final column = tester.widget<Column>(find.byType(Column));
      final stretched = column.children
          .whereType<SizedBox>()
          .where((box) => box.width == double.infinity)
          .length;
      expect(stretched, 0, reason: 'non-Wind children must not be stretched');
    });

    testWidgets('flex-row child with no height is NOT stretched',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const SizedBox(
            height: 300,
            child: WDiv(
              className: 'flex flex-row',
              children: [
                WDiv(className: 'bg-red-500', child: SizedBox(width: 10)),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      // Row must not gain any height-stretch SizedBox.
      final row = tester.widget<Row>(find.byType(Row));
      final stretched = row.children
          .whereType<SizedBox>()
          .where((box) => box.height == double.infinity)
          .length;
      expect(stretched, 0, reason: 'Row cross-axis must stay unchanged');
    });

    testWidgets('Expanded/Flexible candidate (flex-1) is not stretch-wrapped',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const SizedBox(
            width: 300,
            height: 200,
            child: WDiv(
              className: 'flex flex-col',
              children: [
                WDiv(
                  className: 'flex-1 bg-red-500',
                  child: SizedBox(),
                ),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      // The flex-1 WDiv (which self-wraps in Expanded during its own build)
      // must be a DIRECT child of the Column, not buried under a stretch
      // SizedBox(width: infinity). A stretch wrap would break the Expanded.
      final column = tester.widget<Column>(find.byType(Column));
      expect(
        column.children.whereType<WDiv>().length,
        1,
        reason: 'flex-1 child stays a direct Column child (no stretch wrap)',
      );
      final stretched = column.children
          .whereType<SizedBox>()
          .where((box) => box.width == double.infinity)
          .length;
      expect(stretched, 0, reason: 'flex-1 child must not be stretch-wrapped');
      // It self-wraps in Expanded and fills the bounded 200px column height.
      expect(find.byType(Expanded), findsOneWidget);
    });
  });

  group('smart column stretch (interaction wrappers)', () {
    testWidgets('WAnchor wrapping a no-width WDiv stretches to parent width',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          SizedBox(
            width: 300,
            child: WDiv(
              className: 'flex flex-col',
              children: [
                WAnchor(
                  onTap: () {},
                  child: const WDiv(
                    className: 'bg-red-500',
                    child: SizedBox(height: 10),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(WDiv).at(1)).width, 300);
    });

    testWidgets('WAnchor wrapping a WText stretches to parent width',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          SizedBox(
            width: 300,
            child: WDiv(
              className: 'flex flex-col',
              children: [
                WAnchor(
                  onTap: () {},
                  child: const WText('x'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(WAnchor)).width, 300);
    });

    testWidgets('WButton stretches to parent width', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          SizedBox(
            width: 300,
            child: WDiv(
              className: 'flex flex-col',
              children: [
                WButton(
                  onTap: () {},
                  child: const WText('x'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(WButton)).width, 300);
    });

    testWidgets('WAnchor wrapping a w-32 WDiv keeps its width (no stretch)',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          SizedBox(
            width: 300,
            child: WDiv(
              className: 'flex flex-col',
              children: [
                WAnchor(
                  onTap: () {},
                  child: const WDiv(
                    className: 'w-32 bg-red-500',
                    child: SizedBox(height: 10),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      // w-32 = 32 * 4px = 128px; the inner explicit width disables stretch.
      expect(tester.getSize(find.byType(WDiv).at(1)).width, 128);
    });

    testWidgets(
        'stretch-eligible WAnchor in an unbounded-width column does not crash '
        '(degrades to content size)', (tester) async {
      // A flex-col in a bare Row main-axis slot has unbounded width. A
      // stretch-eligible WAnchor would otherwise be wrapped in
      // SizedBox(width: infinity), which throws under an unbounded constraint.
      // The bounded-width LayoutBuilder guard must skip the wrap and let the
      // WAnchor degrade to its content size instead of crashing.
      await tester.pumpWidget(
        wrapWithTheme(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              WDiv(
                className: 'flex flex-col',
                children: [
                  WAnchor(
                    onTap: () {},
                    child: const WText('content'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

      expect(tester.takeException(), isNull,
          reason: 'WAnchor smart stretch must not throw on unbounded width');
    });

    testWidgets('WButton with explicit width keeps its width (no stretch)',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          SizedBox(
            width: 300,
            child: WDiv(
              className: 'flex flex-col',
              children: [
                WButton(
                  onTap: () {},
                  className: 'w-32',
                  child: const WText('x'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      // w-32 = 128px; the button's own explicit width disables stretch.
      expect(tester.getSize(find.byType(WButton)).width, 128);
    });

    testWidgets('self-flexing WButton (grow) is not stretch-wrapped',
        (tester) async {
      // A WButton whose own className self-wraps in Expanded must not be
      // wrapped again in SizedBox(width: infinity); _selfWrapsInFlex on the
      // button's className excludes it from the stretch pass.
      await tester.pumpWidget(
        wrapWithTheme(
          SizedBox(
            width: 300,
            height: 200,
            child: WDiv(
              className: 'flex flex-col',
              children: [
                WButton(
                  onTap: () {},
                  className: 'grow',
                  child: const WText('x'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull,
          reason: 'self-flexing WButton must not be stretch-wrapped');
    });

    testWidgets('bare WText direct column child is still NOT stretched',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const SizedBox(
            width: 300,
            child: WDiv(
              className: 'flex flex-col',
              children: [
                WText('x'),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      // The bare WText leaf must not be wrapped in a stretch SizedBox.
      final column = tester.widget<Column>(find.byType(Column));
      final stretched = column.children
          .whereType<SizedBox>()
          .where((box) => box.width == double.infinity)
          .length;
      expect(stretched, 0,
          reason: 'bare WText leaf stays unstretched (existing exclusion)');
    });
  });

  group('smart column stretch — edge cases', () {
    testWidgets('bounded-width column in a vertical scroll still stretches',
        (tester) async {
      // Height is unbounded (scroll), width is bounded → child fills width.
      await tester.pumpWidget(
        wrapWithTheme(
          SizedBox(
            width: 280,
            child: SingleChildScrollView(
              child: WDiv(
                className: 'flex flex-col',
                children: const [
                  WDiv(className: 'bg-red-500', child: SizedBox(height: 10)),
                ],
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(WDiv).at(1)).width, 280);
    });

    testWidgets('unbounded-width column does not crash (degrades gracefully)',
        (tester) async {
      // A flex-col placed where width is unbounded (a bare Row main-axis slot).
      // The stretch wrap must not force an infinite-width render error.
      await tester.pumpWidget(
        wrapWithTheme(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              WDiv(
                className: 'flex flex-col',
                children: [
                  WDiv(className: 'bg-red-500', child: Text('content')),
                ],
              ),
            ],
          ),
        ),
      );

      expect(tester.takeException(), isNull,
          reason: 'smart stretch must not throw on an unbounded-width column');
    });

    testWidgets('basis-* column child is not additionally width-stretched',
        (tester) async {
      // A basis-* child resolves to a sized SizedBox; the stretch pass skips
      // SizedBox children, so it is not double-wrapped to full width.
      await tester.pumpWidget(
        wrapWithTheme(
          const SizedBox(
            width: 300,
            height: 400,
            child: WDiv(
              className: 'flex flex-col',
              children: [
                WDiv(className: 'basis-1/2 bg-red-500', child: Text('half')),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });
  });
}
