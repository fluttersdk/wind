import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// What a `ring-*` actually paints, read back as pixels.
///
/// Tailwind draws a ring as a box-shadow, and a browser clips a box-shadow to
/// the outside of its element, so a ring is an outline. A Flutter [BoxShadow]
/// is not clipped: on an element with no background the whole box filled with
/// the ring colour. A host app's rail drew every keyboard-focused icon button
/// as a solid blue block with its glyph lost inside it.

const Color _page = Color(0xFFFFFFFF);
const Color _ring = Color(0xFF3B82F6); // blue-500

Widget _frame(GlobalKey key, String className) {
  return MaterialApp(
    home: WindTheme(
      data: WindThemeData(),
      child: Center(
        child: RepaintBoundary(
          key: key,
          child: ColoredBox(
            color: _page,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: WDiv(className: className),
            ),
          ),
        ),
      ),
    ),
  );
}

/// The colour at ([x], [y]) of the boundary under [key], in logical pixels
/// from its top left (device pixel ratio 1 in the test view).
Future<Color> _pixel(WidgetTester tester, GlobalKey key, int x, int y) async {
  final RenderRepaintBoundary boundary =
      key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  final ui.Image image = (await tester.runAsync(boundary.toImage))!;
  final ByteData bytes = (await tester.runAsync<ByteData?>(
    () => image.toByteData(format: ui.ImageByteFormat.rawRgba),
  ))!;
  final int offset = (y * image.width + x) * 4;

  return Color.fromARGB(
    bytes.getUint8(offset + 3),
    bytes.getUint8(offset),
    bytes.getUint8(offset + 1),
    bytes.getUint8(offset + 2),
  );
}

void main() {
  setUp(WindParser.clearCache);

  setUp(() {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.views.first.devicePixelRatio = 1;
  });

  group('A ring is an outline', () {
    testWidgets('leaves an element with no background unfilled', (
      tester,
    ) async {
      final GlobalKey key = GlobalKey();
      await tester.pumpWidget(_frame(key, 'w-10 h-10 ring-2 ring-blue-500'));

      // The box spans 10..50 inside the boundary; its centre is 30,30.
      expect(await _pixel(tester, key, 30, 30), _page);
      // One pixel outside its left edge is the 2px ring.
      expect(await _pixel(tester, key, 9, 30), _ring);
      // Three pixels out is past the ring.
      expect(await _pixel(tester, key, 7, 30), _page);
    });

    testWidgets('keeps a background and draws the ring around it', (
      tester,
    ) async {
      final GlobalKey key = GlobalKey();
      await tester.pumpWidget(
        _frame(key, 'w-10 h-10 bg-black ring-2 ring-blue-500'),
      );

      expect(await _pixel(tester, key, 30, 30), const Color(0xFF000000));
      expect(await _pixel(tester, key, 9, 30), _ring);
    });

    testWidgets('leaves a gap the size of ring-offset', (tester) async {
      final GlobalKey key = GlobalKey();
      await tester.pumpWidget(
        _frame(key, 'w-10 h-10 bg-black ring-2 ring-offset-2 ring-blue-500'),
      );

      // 1 and 2 px out are the offset gap; 3 and 4 px out are the ring.
      expect(await _pixel(tester, key, 9, 30), _page);
      expect(await _pixel(tester, key, 8, 30), _page);
      expect(await _pixel(tester, key, 7, 30), _ring);
      expect(await _pixel(tester, key, 6, 30), _ring);
      expect(await _pixel(tester, key, 5, 30), _page);
    });

    testWidgets('ring-inset draws inside the edge, over the background', (
      tester,
    ) async {
      final GlobalKey key = GlobalKey();
      await tester.pumpWidget(
        _frame(key, 'w-10 h-10 bg-black ring-2 ring-inset ring-blue-500'),
      );

      expect(await _pixel(tester, key, 9, 30), _page);
      expect(await _pixel(tester, key, 10, 30), _ring);
      expect(await _pixel(tester, key, 11, 30), _ring);
      expect(await _pixel(tester, key, 30, 30), const Color(0xFF000000));
    });
  });
}
