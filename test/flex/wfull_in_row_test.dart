import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

Widget wrap(Widget child) => MaterialApp(
      home: WindTheme(
        data: WindThemeData(),
        child: Scaffold(body: child),
      ),
    );

void main() {
  setUp(WindParser.clearCache);

  group('w-full inside a flex-row (issue #122)', () {
    testWidgets('a w-full child does not assert and fills the row',
        (tester) async {
      const fillKey = Key('wfull-fill');
      await tester.pumpWidget(
        wrap(
          // Bound the row to a known width so the assertion is not tied to the
          // default test viewport.
          SizedBox(
            width: 500,
            child: WDiv(
              className: 'flex flex-row justify-end gap-3',
              children: const [
                WDiv(key: fillKey, className: 'w-full', child: Text('Submit')),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Submit'), findsOneWidget);
      // The keyed w-full child is wrapped in Expanded, so it fills the 500px row.
      expect(tester.getSize(find.byKey(fillKey)).width, 500);
    });

    testWidgets('the w-full child is wrapped in an Expanded', (tester) async {
      await tester.pumpWidget(
        wrap(
          WDiv(
            className: 'flex flex-row',
            children: [
              WDiv(className: 'w-full', child: const Text('Fill')),
            ],
          ),
        ),
      );

      expect(
        find.ancestor(of: find.text('Fill'), matching: find.byType(Expanded)),
        findsOneWidget,
      );
    });

    testWidgets('w-full coexists with a fixed-width sibling without crashing',
        (tester) async {
      await tester.pumpWidget(
        wrap(
          WDiv(
            className: 'flex flex-row gap-2',
            children: [
              WDiv(className: 'w-20', child: const Text('Fixed')),
              WDiv(className: 'w-full', child: const Text('Grow')),
            ],
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Fixed'), findsOneWidget);
      expect(find.text('Grow'), findsOneWidget);
    });

    testWidgets('a nested w-full inside a fixed-width child stays bounded',
        (tester) async {
      // Regression guard: the inner w-full is NOT a direct row child, so it must
      // keep its SizedBox(infinity) behavior bounded by the w-32 parent, not be
      // turned into an Expanded (which would assert outside a Flex).
      const outerKey = Key('w32-outer');
      const nestedKey = Key('wfull-nested');
      await tester.pumpWidget(
        wrap(
          WDiv(
            className: 'flex flex-row',
            children: const [
              WDiv(
                key: outerKey,
                className: 'w-32',
                child: WDiv(
                  key: nestedKey,
                  className: 'w-full',
                  child: Text('Nested'),
                ),
              ),
            ],
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      // w-32 -> 128px bounds the nested w-full.
      expect(tester.getSize(find.byKey(outerKey)).width, 128);
      // The nested w-full must NOT be wrapped in an Expanded (it is not a direct
      // row child); doing so would assert outside a Flex.
      expect(
        find.ancestor(
            of: find.byKey(nestedKey), matching: find.byType(Expanded)),
        findsNothing,
      );
    });

    testWidgets('w-full combined with flex-1 does not double-wrap',
        (tester) async {
      // flex-1 self-wraps in Expanded; the w-full path must defer to it.
      await tester.pumpWidget(
        wrap(
          WDiv(
            className: 'flex flex-row',
            children: [
              WDiv(className: 'flex-1 w-full', child: const Text('Both')),
            ],
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(
        find.ancestor(of: find.text('Both'), matching: find.byType(Expanded)),
        findsOneWidget,
      );
    });

    testWidgets('a non-WDiv Wind child (WButton) with w-full also expands',
        (tester) async {
      // WButton (and WInput etc.) also turn w-full into an infinite width, so
      // the Row expand must key off the className of any Wind widget, not just
      // WDiv.
      await tester.pumpWidget(
        wrap(
          WDiv(
            className: 'flex flex-row',
            children: [
              WButton(
                className: 'w-full',
                onTap: () {},
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Save'), findsOneWidget);
      expect(
        find.ancestor(
            of: find.byType(WButton), matching: find.byType(Expanded)),
        findsOneWidget,
      );
    });

    testWidgets('w-full inside a column is unaffected (no crash)',
        (tester) async {
      await tester.pumpWidget(
        wrap(
          WDiv(
            className: 'flex flex-col',
            children: [
              WDiv(className: 'w-full', child: const Text('ColChild')),
            ],
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('ColChild'), findsOneWidget);
    });
  });
}
