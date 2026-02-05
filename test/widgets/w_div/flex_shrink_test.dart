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
          reason: 'overflow-hidden flex-row children should be wrapped with Flexible',
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
        final sizedBoxCount =
            row.children.where((child) => child is SizedBox).length;
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
                          WText('12345.67 units', className: 'text-xs truncate'),
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
        final flexibleCount =
            column.children.where((child) => child is Flexible).length;
        expect(flexibleCount, 0);
      },
    );
  });
}
