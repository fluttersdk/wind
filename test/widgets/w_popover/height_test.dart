import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// The trigger sits [top] pixels down an 800x600 surface, the shape of a
/// player's control band a third of the way down a small desktop window.
Widget _host({required double top, required WPopover popover}) => MaterialApp(
      home: WindTheme(
        data: WindThemeData(),
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              Positioned(left: 40, top: top, child: popover),
            ],
          ),
        ),
      ),
    );

WPopover _popover({double maxHeight = 480, bool autoFlip = true}) {
  return WPopover(
    maxHeight: maxHeight,
    autoFlip: autoFlip,
    className: 'overflow-y-auto',
    triggerBuilder: (context, isOpen, isHovering) =>
        const SizedBox(width: 40, height: 40, child: WText('Trigger')),
    contentBuilder: (context, close) => const SingleChildScrollView(
      child: SizedBox(height: 900, child: WText('PopoverBody')),
    ),
  );
}

void main() {
  setUp(WindParser.clearCache);

  Future<Rect> openAndMeasure(WidgetTester tester, WPopover popover,
      {required double top}) async {
    tester.view.physicalSize = const Size(800, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_host(top: top, popover: popover));
    await tester.tap(find.text('Trigger'));
    await tester.pumpAndSettle();

    return tester.getRect(
      find
          .ancestor(
            of: find.text('PopoverBody'),
            matching: find.byType(ConstrainedBox),
          )
          .first,
    );
  }

  group('computeAvailableHeight', () {
    test('below a trigger it is the space down to the bottom margin', () {
      // 600 - (216 + 40 + 4) - 8 = 332
      expect(
        computeAvailableHeight(
          alignment: PopoverAlignment.bottomLeft,
          triggerPosition: const Offset(40, 216),
          triggerSize: const Size(40, 40),
          screenSize: const Size(800, 600),
          offset: const Offset(0, 4),
        ),
        332,
      );
    });

    test('above a trigger it is the space up to the top margin', () {
      // 216 - 4 - 8 = 204
      expect(
        computeAvailableHeight(
          alignment: PopoverAlignment.topRight,
          triggerPosition: const Offset(40, 216),
          triggerSize: const Size(40, 40),
          screenSize: const Size(800, 600),
          offset: const Offset(0, 4),
        ),
        204,
      );
    });

    test('never negative', () {
      expect(
        computeAvailableHeight(
          alignment: PopoverAlignment.bottomCenter,
          triggerPosition: const Offset(40, 590),
          triggerSize: const Size(40, 40),
          screenSize: const Size(800, 600),
          offset: Offset.zero,
        ),
        0,
      );
    });
  });

  group('WPopover height within the viewport', () {
    testWidgets(
        'a popover taller than the space on both sides stays on screen and '
        'scrolls', (tester) async {
      // 480 tall, 304 above and 296 below: neither side fits, so it stays
      // below, and the panel must end inside the 600 pixel window.
      final Rect panel = await openAndMeasure(tester, _popover(), top: 260);

      expect(panel.bottom, lessThanOrEqualTo(600));
      expect(panel.height, lessThan(480));
    });

    testWidgets('a popover that fits keeps its own maxHeight', (tester) async {
      final Rect panel =
          await openAndMeasure(tester, _popover(maxHeight: 200), top: 60);

      expect(panel.height, 200);
    });

    testWidgets('autoFlip false leaves the height alone', (tester) async {
      final Rect panel = await openAndMeasure(
        tester,
        _popover(autoFlip: false),
        top: 260,
      );

      expect(panel.height, 480);
    });
  });
}
