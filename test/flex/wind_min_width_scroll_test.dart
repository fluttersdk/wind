import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/src/widgets/wind_min_width_scroll.dart';

/// WIND-4 min-width-stretch scroll: `WindMinWidthBox` sizes a `w-full` child to
/// `max(viewportWidth, min-w-*)` when the scroll viewport width is known, and
/// must degrade to the child's content width (honoring the `min-w-*` floor)
/// rather than collapsing to 0 when the viewport is unknown or unbounded.
Widget host(Widget child) => Directionality(
      textDirection: TextDirection.ltr,
      child: Align(alignment: Alignment.topLeft, child: child),
    );

void main() {
  testWidgets('fills a finite published viewport width', (tester) async {
    final port = WindViewportWidthPort()..value = 400;
    await tester.pumpWidget(
      host(
        WindMinWidthBox(
          port: port,
          floorMinWidth: 0,
          child: const SizedBox(width: 50, height: 20),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    // Viewport 400 wins over the 50px content: the child fills the viewport.
    expect(tester.getSize(find.byType(WindMinWidthBox)).width, 400);
  });

  testWidgets('honors the min-w floor over a narrower viewport',
      (tester) async {
    final port = WindViewportWidthPort()..value = 120;
    await tester.pumpWidget(
      host(
        WindMinWidthBox(
          port: port,
          floorMinWidth: 300,
          child: const SizedBox(width: 50, height: 20),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    // Floor 300 > viewport 120: the child takes the floor (so the scroll scrolls).
    expect(tester.getSize(find.byType(WindMinWidthBox)).width, 300);
  });

  testWidgets(
      'degrades to content width (not 0) when the viewport is unpublished',
      (tester) async {
    // Regression: a null viewport with no floor used to force a tight 0 width,
    // collapsing the content. It must degrade to the child's content width.
    final port = WindViewportWidthPort(); // value == null
    await tester.pumpWidget(
      host(
        WindMinWidthBox(
          port: port,
          floorMinWidth: 0,
          child: const SizedBox(width: 120, height: 20),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(WindMinWidthBox)).width, 120);
  });

  testWidgets(
      'degrades to the floor when the viewport is infinite (unbounded scroll)',
      (tester) async {
    final port = WindViewportWidthPort()..value = double.infinity;
    await tester.pumpWidget(
      host(
        WindMinWidthBox(
          port: port,
          floorMinWidth: 200,
          child: const SizedBox(width: 120, height: 20),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    // Infinite viewport: no fill target, so the child takes its content width
    // clamped up to the min-w floor (200), never a tight 0.
    expect(tester.getSize(find.byType(WindMinWidthBox)).width, 200);
  });

  testWidgets('respects a finite parent width instead of violating constraints',
      (tester) async {
    // If the box is ever laid out under a finite width (outside a scroll, or
    // before a finite viewport is published), it must not size past the
    // incoming constraint even when the child wants more.
    final port = WindViewportWidthPort(); // value == null
    await tester.pumpWidget(
      host(
        SizedBox(
          width: 300,
          child: WindMinWidthBox(
            port: port,
            floorMinWidth: 0,
            child: const SizedBox(width: 500, height: 20),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    // Child wants 500 but the parent only allows 300: the box stays at 300.
    expect(tester.getSize(find.byType(WindMinWidthBox)).width, 300);
  });
}
