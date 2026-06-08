import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Tests for CSS flexbox flex-shrink:1 behavior in WDiv.
///
/// In CSS flexbox, `flex-shrink: 1` is the default, meaning flex items
/// will shrink to fit their container when there isn't enough space.
/// Flutter's Row doesn't have this behavior by default - children render
/// at their natural size and overflow.
///
/// WDiv applies Flexible wrapping when:
/// - overflow-hidden is set (clips content, needs shrink)
/// - justify-between/space-around/space-evenly is used (needs space distribution)
///
/// For other cases, developers should use `overflow-hidden` explicitly.
void main() {
  group('WDiv Flex Shrink Behavior', () {
    testWidgets(
      'flex-row with overflow-hidden wraps children with Flexible',
      (tester) async {
        // overflow-hidden triggers Flexible wrapping to prevent overflow

        await tester.pumpWidget(
          MaterialApp(
            home: WindTheme(
              data: WindThemeData(),
              child: SizedBox(
                width: 100, // Constrained to 100px
                child: const WDiv(
                  className: 'flex flex-row items-center gap-2 overflow-hidden',
                  children: [
                    // Two texts that together exceed 100px
                    WText('Label', className: 'text-sm'),
                    WText('Very Long Value Text', className: 'text-sm'),
                  ],
                ),
              ),
            ),
          ),
        );

        // Should render without overflow errors
        expect(tester.takeException(), isNull);

        // Verify Row exists
        expect(find.byType(Row), findsOneWidget);

        // Verify children are wrapped with Flexible (for shrink behavior)
        final row = tester.widget<Row>(find.byType(Row));

        // Count Flexible wrappers (excluding SizedBox gaps)
        final flexibleCount = row.children
            .where((child) => child is Flexible && child is! Expanded)
            .length;

        // We expect 2 Flexible wrappers (one for each WText)
        expect(
          flexibleCount,
          2,
          reason:
              'overflow-hidden flex-row children should be wrapped with Flexible',
        );
      },
    );

    testWidgets(
      'flex-row WITHOUT overflow-hidden does NOT wrap children',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: WindTheme(
              data: WindThemeData(),
              child: SizedBox(
                width: 300, // Wide enough to not overflow
                child: const WDiv(
                  className: 'flex flex-row',
                  children: [
                    WText('Item 1'),
                    WText('Item 2'),
                  ],
                ),
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);

        final row = tester.widget<Row>(find.byType(Row));
        final flexibleCount = row.children
            .where((child) => child is Flexible && child is! Expanded)
            .length;

        // Without overflow-hidden, children are NOT wrapped
        expect(flexibleCount, 0);
      },
    );

    testWidgets(
      'flex-row with justify-between should wrap children with Flexible',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: WindTheme(
              data: WindThemeData(),
              child: SizedBox(
                width: 200,
                child: const WDiv(
                  className: 'flex flex-row justify-between',
                  children: [
                    WText('Left'),
                    WText('Right'),
                  ],
                ),
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);

        final row = tester.widget<Row>(find.byType(Row));
        final flexibleCount = row.children
            .where((child) => child is Flexible && child is! Expanded)
            .length;

        expect(flexibleCount, 2);
      },
    );

    testWidgets(
      'flex-row with overflow-hidden skips Expanded/Flexible children',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: WindTheme(
              data: WindThemeData(),
              child: SizedBox(
                width: 200,
                child: const WDiv(
                  className: 'flex flex-row overflow-hidden',
                  children: [
                    WDiv(
                      className: 'flex-1',
                      child: WText('Expanded'),
                    ),
                    WText('Normal'),
                  ],
                ),
              ),
            ),
          ),
        );

        // Should not throw
        expect(tester.takeException(), isNull);

        final row = tester.widget<Row>(find.byType(Row));

        // WDiv children are not yet built, so we check the types at Row level
        // With overflow-hidden: WText gets Flexible, WDiv stays as is
        final flexibleCount = row.children
            .where((child) => child is Flexible && child is! Expanded)
            .length;

        // Only WText should be wrapped (WDiv with flex-1 is not wrapped)
        expect(flexibleCount, 1, reason: 'Only non-flex children get Flexible');
      },
    );

    testWidgets(
      'flex-row with overflow-hidden preserves SizedBox gaps',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: WindTheme(
              data: WindThemeData(),
              child: SizedBox(
                width: 200,
                child: const WDiv(
                  className: 'flex flex-row gap-4 overflow-hidden',
                  children: [
                    WText('A'),
                    WText('B'),
                  ],
                ),
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);

        final row = tester.widget<Row>(find.byType(Row));

        // With gap-4, we expect: [Flexible(WText), SizedBox(gap), Flexible(WText)]
        // SizedBox should NOT be wrapped
        final sizedBoxCount = row.children.whereType<SizedBox>().length;
        expect(sizedBoxCount, 1, reason: 'Gap SizedBox should not be wrapped');

        // And we should have 2 Flexible wrappers for the texts
        final flexibleCount = row.children
            .where((child) => child is Flexible && child is! Expanded)
            .length;
        expect(flexibleCount, 2);
      },
    );

    testWidgets(
      'flex-row with overflow-hidden inside Wrap prevents overflow',
      (tester) async {
        // This replicates the fix for monitor_show_view.dart
        // where adding overflow-hidden prevents overflow on constrained items

        await tester.pumpWidget(
          MaterialApp(
            home: WindTheme(
              data: WindThemeData(),
              child: SizedBox(
                width: 300,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    // Simulate metric badges with overflow-hidden
                    for (var i = 0; i < 3; i++)
                      const WDiv(
                        className:
                            'flex flex-row items-center gap-1.5 px-2.5 py-1 overflow-hidden',
                        children: [
                          WText('Label', className: 'text-xs truncate'),
                          WText('12345.67 units',
                              className: 'text-xs truncate'),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        );

        // The key assertion: no overflow errors should occur
        expect(tester.takeException(), isNull);

        // All three badges should render
        expect(find.byType(Row), findsNWidgets(3));
      },
    );

    testWidgets(
      'flex-row justify-between with flex-1 child should not wrap shrink-0 child with Flexible',
      (tester) async {
        // Bug: when needsSpaceDistribution is true, ALL non-flex children
        // get wrapped with Flexible — including shrink-0 children that should
        // keep their intrinsic size. The shrink-0 child must NOT be Flexible.

        await tester.pumpWidget(
          MaterialApp(
            home: WindTheme(
              data: WindThemeData(),
              child: SizedBox(
                width: 300,
                child: const WDiv(
                  className: 'flex flex-row justify-between',
                  children: [
                    WDiv(
                      className: 'flex-1',
                      child: WText('Grows to fill space'),
                    ),
                    WDiv(
                      className: 'shrink-0',
                      child: WText('Fixed size'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);

        final row = tester.widget<Row>(find.byType(Row).first);

        // The shrink-0 child should NOT be wrapped with Flexible.
        // Only non-flex, non-shrink-0 children may receive Flexible wrapping.
        // Count Flexible wrappers that are NOT Expanded (i.e. flex:1 children).
        final flexibleCount = row.children
            .where((child) => child is Flexible && child is! Expanded)
            .length;

        expect(
          flexibleCount,
          0,
          reason:
              'shrink-0 child must not be wrapped with Flexible when justify-between is used',
        );
      },
    );

    testWidgets(
      'flex-row justify-between with flex-1 child preserves non-flex child intrinsic size',
      (tester) async {
        // Bug: the shrink-0 child gets wrapped in Flexible, which forces
        // Flutter to give it a flex allocation instead of its natural size.
        // After the fix, the non-flex child must render at its intrinsic width.

        const fixedText = 'Badge';

        await tester.pumpWidget(
          MaterialApp(
            home: WindTheme(
              data: WindThemeData(),
              child: SizedBox(
                width: 400,
                child: const WDiv(
                  className: 'flex flex-row justify-between',
                  children: [
                    WDiv(
                      className: 'flex-1',
                      child: WText('Title that grows'),
                    ),
                    WDiv(
                      className: 'shrink-0 px-2',
                      child: WText(fixedText),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);

        // Verify the shrink-0 child is not forced into equal flex allocation.
        // If it were wrapped in Flexible(flex: 1) alongside Expanded(flex: 1),
        // both children would split the 400px container equally → 200px each.
        // The shrink-0 child should retain its intrinsic width instead.
        final badgeFinder = find.text(fixedText);
        expect(badgeFinder, findsOneWidget);

        final badgeRenderBox = tester.renderObject<RenderBox>(badgeFinder);
        final badgeWidth = badgeRenderBox.size.width;

        expect(badgeWidth, greaterThan(0));
        // Must not equal the 50% split that Flexible(flex:1) would produce
        expect(
          badgeWidth,
          isNot(equals(200.0)),
          reason:
              'shrink-0 child must retain intrinsic size — not equal-flex split',
        );
        // Must not fill the entire container
        expect(
          badgeWidth,
          lessThan(400),
          reason:
              'shrink-0 child must not expand to fill entire container width',
        );
      },
    );

    testWidgets(
      'flex-col should NOT auto-wrap children with Flexible',
      (tester) async {
        // Column direction doesn't need shrink behavior the same way
        // because vertical space is typically scrollable

        await tester.pumpWidget(
          MaterialApp(
            home: WindTheme(
              data: WindThemeData(),
              child: SizedBox(
                height: 100,
                child: const WDiv(
                  className: 'flex flex-col',
                  children: [
                    WText('Item 1'),
                    WText('Item 2'),
                  ],
                ),
              ),
            ),
          ),
        );

        expect(find.byType(Column), findsOneWidget);

        final column = tester.widget<Column>(find.byType(Column));

        // Column children should NOT be wrapped with Flexible by default
        final flexibleCount = column.children.whereType<Flexible>().length;
        expect(flexibleCount, 0);
      },
    );
  });

  group('shrink-0 does not force-fill or assert (regression)', () {
    setUp(WindParser.clearCache);

    testWidgets(
      'standalone shrink-0 WDiv builds with no Flexible self-wrap',
      (tester) async {
        // Regression: shrink-0 must NOT set flexFit. A non-null flexFit would
        // self-wrap the WDiv in Flexible(fit: tight), forcing a fill and
        // asserting outside a Flex.
        await tester.pumpWidget(
          MaterialApp(
            home: WindTheme(
              data: WindThemeData(),
              child: Scaffold(
                body: WDiv(
                  className: 'shrink-0 w-16 h-16 bg-gray-200',
                  child: SizedBox(),
                ),
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
        expect(find.byType(Flexible), findsNothing);
      },
    );

    testWidgets(
      'shrink-0 child in a Row keeps its intrinsic width',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: WindTheme(
              data: WindThemeData(),
              child: Scaffold(
                body: WDiv(
                  className: 'flex flex-row',
                  children: [
                    WDiv(
                      className: 'shrink-0 w-16 h-16 bg-gray-200',
                      child: SizedBox(),
                    ),
                    WDiv(
                      className: 'flex-1 h-16 bg-blue-200',
                      child: SizedBox(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
        // w-16 = 16 * 4px = 64px; the sidebar holds its width, not forced fill.
        expect(tester.getSize(find.byType(WDiv).at(1)).width, 64);
      },
    );
  });
}
