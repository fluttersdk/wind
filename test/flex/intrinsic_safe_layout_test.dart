import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// WIND-4 coverage: the internal `WDiv` flex layout must be intrinsic-safe (no
/// `LayoutBuilder` on any path that can render under an intrinsic-measuring
/// ancestor), an explicit `flex flex-col items-stretch` must equalize child
/// widths, `overflow-x-auto` + `w-full`/`min-w-*` must give a fill-desktop /
/// scroll-narrow primitive, and `h-full` inside a vertical scroll must raise an
/// actionable assert.
Widget wrapWithTheme(Widget child, {double? width, double? height}) {
  Widget body = child;
  if (width != null || height != null) {
    body = SizedBox(width: width, height: height, child: body);
  }
  return MaterialApp(
    home: WindTheme(
      data: WindThemeData(),
      child: Scaffold(body: body),
    ),
  );
}

void main() {
  setUp(WindParser.clearCache);

  group('(a) intrinsic-safe flex under an intrinsic-measuring ancestor', () {
    testWidgets(
        'flex flex-col with stretch children renders under '
        'IntrinsicHeight without the LayoutBuilder-intrinsic assert',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          width: 600,
          IntrinsicHeight(
            child: WDiv(
              className: 'flex flex-col gap-1 p-4',
              children: const [
                WDiv(className: 'bg-slate-100', child: Text('Revenue')),
                WDiv(className: 'bg-slate-200', child: Text('\$12k')),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'flex flex-col with fractional basis child renders under '
        'IntrinsicHeight without the LayoutBuilder-intrinsic assert',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          width: 600,
          IntrinsicHeight(
            child: WDiv(
              className: 'flex flex-row',
              children: const [
                WDiv(className: 'basis-1/2 bg-slate-100', child: Text('L')),
                WDiv(className: 'basis-1/2 bg-slate-200', child: Text('R')),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'flex flex-col with basis child renders inside an '
        'items-stretch grid cell without asserting', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          width: 600,
          WDiv(
            className: 'grid grid-cols-2 gap-4 items-stretch',
            children: const [
              WDiv(
                className: 'flex flex-col gap-1 p-2',
                children: [
                  WDiv(className: 'basis-1/2 bg-slate-100', child: Text('a')),
                  WDiv(className: 'bg-slate-200', child: Text('b')),
                ],
              ),
              WDiv(className: 'p-2', child: Text('c')),
            ],
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('basis-1/2 in a bounded row still resolves to half width',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          width: 400,
          const WDiv(
            className: 'flex flex-row',
            children: [
              WDiv(className: 'basis-1/2 h-10 bg-red-500', child: SizedBox()),
            ],
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(WDiv).at(1)).width, 200);
    });
  });

  group('(a) fractional basis degrades gracefully on an unbounded main axis',
      () {
    testWidgets('basis-1/2 in an unbounded-width row passes through (no crash)',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              WDiv(
                className: 'flex flex-row',
                children: [
                  WDiv(className: 'basis-1/2 bg-red-500', child: Text('x')),
                ],
              ),
            ],
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      // Unbounded main axis: the fractional basis degrades to content width.
      expect(tester.getSize(find.byType(WDiv).at(1)).width, greaterThan(0));
    });

    testWidgets('re-layout after a width change keeps the basis fraction',
        (tester) async {
      Widget tree(double width) => wrapWithTheme(
            width: width,
            const WDiv(
              className: 'flex flex-row',
              children: [
                WDiv(
                  className: 'basis-1/2 h-10 bg-red-500',
                  child: SizedBox(),
                ),
              ],
            ),
          );

      await tester.pumpWidget(tree(400));
      expect(tester.getSize(find.byType(WDiv).at(1)).width, 200);
      // Rebuild with a new width exercises the provider/basis update path.
      await tester.pumpWidget(tree(600));
      expect(tester.getSize(find.byType(WDiv).at(1)).width, 300);
    });
  });

  group('(c) explicit flex flex-col items-stretch equalizes child widths', () {
    testWidgets('two children of different content width end up equal width',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          width: 300,
          const WDiv(
            className: 'flex flex-col items-stretch',
            children: [
              WDiv(className: 'bg-slate-100', child: Text('short')),
              WDiv(
                className: 'bg-slate-200',
                child: Text('a considerably longer label'),
              ),
            ],
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      final a = tester.getSize(find.byType(WDiv).at(1)).width;
      final b = tester.getSize(find.byType(WDiv).at(2)).width;
      expect(a, 300);
      expect(b, 300);
    });

    testWidgets('items-stretch column does not crash under an unbounded width',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              WDiv(
                className: 'flex flex-col items-stretch',
                children: [
                  WDiv(className: 'bg-red-500', child: Text('content')),
                ],
              ),
            ],
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });
  });

  group('(b) overflow-x-auto + w-full/min-w-* fill-desktop / scroll-narrow',
      () {
    testWidgets('fills the container on a wide surface (no scroll overflow)',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          width: 720,
          WDiv(
            className: 'overflow-x-auto',
            child: WDiv(
              className: 'w-full min-w-[600px] flex flex-row',
              children: const [
                WDiv(className: 'flex-1', child: Text('col-a')),
                WDiv(className: 'flex-1', child: Text('col-b')),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      // Wide viewport (720 >= 600 floor): content fills the 720px container.
      expect(tester.getSize(find.byType(WDiv).at(1)).width, 720);
    });

    testWidgets('scrolls on a narrow surface (content honors the min width)',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          width: 300,
          WDiv(
            className: 'overflow-x-auto',
            child: WDiv(
              className: 'w-full min-w-[600px] flex flex-row',
              children: const [
                WDiv(className: 'flex-1', child: Text('col-a')),
                WDiv(className: 'flex-1', child: Text('col-b')),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      // Narrow viewport (300 < 600 floor): content is 600px wide and scrolls.
      expect(tester.getSize(find.byType(WDiv).at(1)).width, 600);
    });

    testWidgets('w-full without a min-w floor fills the viewport exactly',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          width: 320,
          WDiv(
            className: 'overflow-x-auto',
            child: WDiv(
              className: 'w-full flex flex-row',
              children: const [
                WDiv(className: 'flex-1', child: Text('only-col')),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      // No floor: content fills the 320px viewport (base = viewport).
      expect(tester.getSize(find.byType(WDiv).at(1)).width, 320);
    });

    testWidgets('re-layout after a viewport change re-resolves the fill width',
        (tester) async {
      Widget tree(double width) => wrapWithTheme(
            width: width,
            WDiv(
              className: 'overflow-x-auto',
              child: WDiv(
                className: 'w-full min-w-[600px] flex flex-row',
                children: const [
                  WDiv(className: 'flex-1', child: Text('c')),
                ],
              ),
            ),
          );

      await tester.pumpWidget(tree(720));
      expect(tester.getSize(find.byType(WDiv).at(1)).width, 720);
      await tester.pumpWidget(tree(300));
      expect(tester.getSize(find.byType(WDiv).at(1)).width, 600);
    });
  });

  group('(d) h-full inside a vertical scroll raises an actionable assert', () {
    testWidgets('a child with h-full inside overflow-y-auto throws', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          width: 300,
          height: 400,
          const WDiv(
            className: 'overflow-y-auto',
            children: [
              WDiv(className: 'h-full', child: Text('fill')),
            ],
          ),
        ),
      );

      final Object? error = tester.takeException();
      expect(error, isA<AssertionError>());
      expect(
        error.toString(),
        contains('flex-1'),
      );
    });

    testWidgets('overflow-y-auto with h-full on the SAME element is allowed',
        (tester) async {
      // The scroll container itself may carry h-full (it reads its parent
      // scope, not the scope it installs for its own children).
      await tester.pumpWidget(
        wrapWithTheme(
          height: 300,
          WDiv(
            className: 'overflow-y-auto h-full',
            children: List.generate(30, (i) => WText('Item $i')),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('overflow-auto (both axes) asserts on an h-full child',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          width: 300,
          height: 400,
          const WDiv(
            className: 'overflow-auto',
            children: [
              WDiv(className: 'h-full', child: Text('fill')),
            ],
          ),
        ),
      );

      final Object? error = tester.takeException();
      expect(error, isA<AssertionError>());
      expect(error.toString(), contains('flex-1'));
    });
  });
}
