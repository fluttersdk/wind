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
      await tester.pumpWidget(
        wrap(
          WDiv(
            className: 'flex flex-row justify-end gap-3',
            children: [
              WDiv(className: 'w-full', child: const Text('Submit')),
            ],
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Submit'), findsOneWidget);
      // The w-full child is wrapped in Expanded, so the inner WDiv fills the
      // row (full surface width, 800 on the default test viewport).
      final inner = find.ancestor(
        of: find.text('Submit'),
        matching: find.byType(WDiv),
      );
      expect(tester.getSize(inner.first).width, 800);
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
      await tester.pumpWidget(
        wrap(
          WDiv(
            className: 'flex flex-row',
            children: [
              WDiv(
                className: 'w-32',
                child: WDiv(className: 'w-full', child: const Text('Nested')),
              ),
            ],
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      // w-32 -> 128px bounds the nested w-full.
      final outer = find
          .ancestor(of: find.text('Nested'), matching: find.byType(WDiv))
          .last;
      expect(tester.getSize(outer).width, 128);
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
