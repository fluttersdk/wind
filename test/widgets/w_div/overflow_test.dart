import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

Widget wrapWithTheme(Widget child) {
  return MaterialApp(
    home: WindTheme(
      data: WindThemeData(),
      child: Scaffold(body: child),
    ),
  );
}

void main() {
  setUp(() {
    WindParser.clearCache();
  });

  group('WDiv Overflow Feature Tests', () {
    testWidgets('overflow-hidden uses ClipRRect', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'overflow-hidden w-32 h-32',
              children: [Text('Content')],
            ),
          ),
        ),
      );

      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets('a rounded overflow clip is anti-aliased', (tester) async {
      // `Clip.hardEdge` cuts along whole pixels, so on a curve it saws the
      // clip path into a staircase. This holds for the clip inside a border
      // as much as for the outer one on a borderless box.
      await tester.pumpWidget(
        wrapWithTheme(
          const WDiv(
            className:
                'overflow-hidden rounded-2xl border border-gray-300 w-32 h-32',
            children: [Text('Content')],
          ),
        ),
      );

      final ClipRRect clip = tester.widget<ClipRRect>(find.byType(ClipRRect));

      expect(clip.clipBehavior, Clip.antiAlias);
      expect(clip.borderRadius, isNot(BorderRadius.zero));
    });

    testWidgets('a rounded overflow clip keeps a child off the border curve', (
      tester,
    ) async {
      // CSS clips `overflow: hidden` at the padding box, whose corners are
      // the border radius minus the border width. Clipping at the OUTER
      // border edge instead leaves the child's square corners painting over
      // the curved stroke, because the child is only inset by the border's
      // straight widths. The straight runs stay intact and the curve takes
      // the child's colour, so the border seems to vanish at every corner.
      final GlobalKey boundary = GlobalKey();
      await tester.pumpWidget(
        wrapWithTheme(
          Center(
            child: RepaintBoundary(
              key: boundary,
              child: const WDiv(
                className: 'overflow-hidden rounded-2xl border-4 '
                    'border-blue-500 bg-white w-32 h-32',
                child: WDiv(className: 'w-full h-full bg-red-500'),
              ),
            ),
          ),
        ),
      );

      final BoxDecoration decoration = tester
          .widgetList<DecoratedBox>(find.byType(DecoratedBox))
          .map((box) => box.decoration)
          .whereType<BoxDecoration>()
          .firstWhere((d) => d.border != null);
      final double radius =
          (decoration.borderRadius! as BorderRadius).topLeft.x;

      // The midpoint of the 4px stroke on the top-left corner's diagonal.
      final double inset = radius - (radius - 2) / 1.4142135623730951;
      final RenderRepaintBoundary render = boundary.currentContext!
          .findRenderObject()! as RenderRepaintBoundary;

      final ByteData bytes = (await tester.runAsync<ByteData?>(() async {
        final image = await render.toImage();
        return image.toByteData();
      }))!;
      final int offset = (inset.round() * render.size.width.round() +
              inset.round()) *
          4;
      final int red = bytes.getUint8(offset);
      final int blue = bytes.getUint8(offset + 2);

      expect(
        blue,
        greaterThan(red),
        reason: 'the corner stroke pixel is rgb($red, ?, $blue); the child '
            'painted over the border instead of being clipped inside it',
      );
    });

    testWidgets('a square overflow clip stays hard-edged', (tester) async {
      // Anti-aliasing a straight edge buys nothing and `antiAlias` carries a
      // documented bleeding-edge artifact, so the square case keeps the
      // cheaper behaviour. Pinning it is what scopes the change above to the
      // shape that needed it.
      await tester.pumpWidget(
        wrapWithTheme(
          const WDiv(
            className: 'overflow-hidden border border-gray-300 w-32 h-32',
            children: [Text('Content')],
          ),
        ),
      );

      final ClipRRect clip = tester.widget<ClipRRect>(find.byType(ClipRRect));

      expect(clip.clipBehavior, Clip.hardEdge);
      expect(clip.borderRadius, BorderRadius.zero);
    });

    testWidgets('overflow-visible does not use ClipRect', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'overflow-visible w-32 h-32',
              children: [Text('Content')],
            ),
          ),
        ),
      );

      expect(find.byType(ClipRect), findsNothing);
    });

    testWidgets('overflow-scroll uses nested SingleChildScrollViews', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'overflow-scroll w-32 h-32',
              children: [Text('Content')],
            ),
          ),
        ),
      );

      // Nested ScrollViews for both-direction scroll
      expect(find.byType(SingleChildScrollView), findsNWidgets(2));
    });

    testWidgets('overflow-auto uses nested SingleChildScrollViews', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'overflow-auto w-32 h-32',
              children: [Text('Content')],
            ),
          ),
        ),
      );

      // Nested ScrollViews for both-direction scroll
      expect(find.byType(SingleChildScrollView), findsNWidgets(2));
    });

    testWidgets('overflow-x-scroll wraps with horizontal ScrollView', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'overflow-x-scroll w-32 h-32',
              children: [Text('Content')],
            ),
          ),
        ),
      );

      final scrollView = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView),
      );
      expect(scrollView.scrollDirection, Axis.horizontal);
    });

    testWidgets('overflow-x-auto wraps with horizontal ScrollView', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'overflow-x-auto w-32 h-32',
              children: [Text('Content')],
            ),
          ),
        ),
      );

      final scrollView = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView),
      );
      expect(scrollView.scrollDirection, Axis.horizontal);
    });

    testWidgets('overflow-y-scroll wraps with vertical ScrollView', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'overflow-y-scroll w-32 h-32',
              children: [Text('Content')],
            ),
          ),
        ),
      );

      final scrollView = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView),
      );
      expect(scrollView.scrollDirection, Axis.vertical);
    });

    testWidgets('overflow-y-auto wraps with vertical ScrollView', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'overflow-y-auto w-32 h-32',
              children: [Text('Content')],
            ),
          ),
        ),
      );

      final scrollView = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView),
      );
      expect(scrollView.scrollDirection, Axis.vertical);
    });

    testWidgets('overflow-x-hidden uses ClipRRect', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'overflow-x-hidden w-32 h-32',
              children: [Text('Content')],
            ),
          ),
        ),
      );

      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets('overflow-y-hidden uses ClipRRect', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'overflow-y-hidden w-32 h-32',
              children: [Text('Content')],
            ),
          ),
        ),
      );

      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets(
      'flex-1 children inside overflow-x-auto row do not assert',
      (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDiv(
              className: 'flex flex-row overflow-x-auto',
              children: [
                WDiv(className: 'flex-1', child: Text('a')),
                WDiv(className: 'flex-1', child: Text('b')),
              ],
            ),
          ),
        );

        expect(tester.takeException(), isNull);
        expect(find.byType(Expanded), findsNothing);
        expect(find.text('a'), findsOneWidget);
        expect(find.text('b'), findsOneWidget);
      },
    );

    testWidgets(
      'flex-1 children inside overflow-y-auto column do not assert',
      (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDiv(
              className: 'flex flex-col overflow-y-auto',
              children: [
                WDiv(className: 'flex-1', child: Text('a')),
                WDiv(className: 'flex-1', child: Text('b')),
              ],
            ),
          ),
        );

        expect(tester.takeException(), isNull);
        expect(find.byType(Expanded), findsNothing);
      },
    );

    testWidgets(
      'flex-1 in non-scrolling row still wraps with Expanded',
      (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDiv(
              className: 'flex flex-row',
              children: [
                WDiv(className: 'flex-1', child: Text('a')),
                WDiv(className: 'flex-1', child: Text('b')),
              ],
            ),
          ),
        );

        expect(tester.takeException(), isNull);
        expect(find.byType(Expanded), findsNWidgets(2));
      },
    );

    testWidgets(
      'nested non-scrolling flex subtree re-enables Expanded under scroll',
      (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDiv(
              className: 'flex flex-row overflow-x-auto',
              children: [
                WDiv(
                  className: 'flex flex-row w-96',
                  children: [
                    WDiv(className: 'flex-1', child: Text('inner')),
                  ],
                ),
              ],
            ),
          ),
        );

        expect(tester.takeException(), isNull);
        expect(find.byType(Expanded), findsOneWidget);
      },
    );

    testWidgets(
      'flex-1 children inside overflow-auto (both axes) do not assert',
      (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDiv(
              className: 'flex flex-row overflow-auto',
              children: [
                WDiv(className: 'flex-1', child: Text('a')),
                WDiv(className: 'flex-1', child: Text('b')),
              ],
            ),
          ),
        );

        expect(tester.takeException(), isNull);
        expect(find.byType(Expanded), findsNothing);
      },
    );

    testWidgets('no overflow class does not add ClipRect', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'w-32 h-32 bg-gray-100',
              children: [Text('Content')],
            ),
          ),
        ),
      );

      expect(find.byType(ClipRect), findsNothing);
      expect(find.byType(OverflowBox), findsNothing);
    });
  });
}
