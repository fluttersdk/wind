import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

void main() {
  setUp(WindParser.clearCache);

  group('CursorParser', () {
    Future<WindStyle> parse(WidgetTester tester, String className) async {
      late WindStyle style;
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: Builder(
              builder: (context) {
                style = WindParser.parse(className, context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
      return style;
    }

    testWidgets('maps cursor-pointer to click', (tester) async {
      final style = await parse(tester, 'cursor-pointer');
      expect(style.mouseCursor, SystemMouseCursors.click);
    });

    testWidgets('maps cursor-not-allowed to forbidden', (tester) async {
      final style = await parse(tester, 'cursor-not-allowed');
      expect(style.mouseCursor, SystemMouseCursors.forbidden);
    });

    testWidgets('maps cursor-default and cursor-auto to basic', (tester) async {
      expect((await parse(tester, 'cursor-default')).mouseCursor,
          SystemMouseCursors.basic);
      expect((await parse(tester, 'cursor-auto')).mouseCursor,
          SystemMouseCursors.basic);
    });

    testWidgets('maps representative cursors', (tester) async {
      expect((await parse(tester, 'cursor-text')).mouseCursor,
          SystemMouseCursors.text);
      expect((await parse(tester, 'cursor-wait')).mouseCursor,
          SystemMouseCursors.wait);
      expect((await parse(tester, 'cursor-grab')).mouseCursor,
          SystemMouseCursors.grab);
      expect((await parse(tester, 'cursor-grabbing')).mouseCursor,
          SystemMouseCursors.grabbing);
      expect((await parse(tester, 'cursor-zoom-in')).mouseCursor,
          SystemMouseCursors.zoomIn);
      expect((await parse(tester, 'cursor-col-resize')).mouseCursor,
          SystemMouseCursors.resizeColumn);
      expect((await parse(tester, 'cursor-ew-resize')).mouseCursor,
          SystemMouseCursors.resizeLeftRight);
      expect((await parse(tester, 'cursor-none')).mouseCursor,
          SystemMouseCursors.none);
    });

    testWidgets('last cursor token wins', (tester) async {
      final style = await parse(tester, 'cursor-pointer cursor-text');
      expect(style.mouseCursor, SystemMouseCursors.text);
    });

    testWidgets('unknown cursor token is a silent no-op', (tester) async {
      final style = await parse(tester, 'cursor-banana');
      expect(style.mouseCursor, isNull);
    });

    testWidgets('no cursor token leaves mouseCursor null', (tester) async {
      final style = await parse(tester, 'p-4 bg-blue-500');
      expect(style.mouseCursor, isNull);
    });
  });

  group('WDiv cursor integration', () {
    testWidgets('WDiv with cursor-pointer wraps in a MouseRegion with click',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'cursor-pointer',
              child: Text('Click me'),
            ),
          ),
        ),
      );

      final regions = tester.widgetList<MouseRegion>(
        find.descendant(
          of: find.byType(WDiv),
          matching: find.byType(MouseRegion),
        ),
      );
      expect(
        regions.any((r) => r.cursor == SystemMouseCursors.click),
        isTrue,
      );
    });

    testWidgets('cursor wins on an interactive (hover:) WDiv', (tester) async {
      // Use cursor-text, NOT cursor-pointer: the auto-wrapped WAnchor's own
      // MouseRegion resolves to click/basic, so a click cursor could not prove
      // the cursor-* wrapper applied. `text` is distinct from both, so finding
      // it confirms the inner cursor MouseRegion is present and wins.
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'cursor-text hover:bg-gray-100 dark:hover:bg-gray-800',
              child: Text('Row'),
            ),
          ),
        ),
      );

      final regions = tester.widgetList<MouseRegion>(
        find.descendant(
          of: find.byType(WDiv),
          matching: find.byType(MouseRegion),
        ),
      );
      expect(
        regions.any((r) => r.cursor == SystemMouseCursors.text),
        isTrue,
        reason: 'the cursor-text MouseRegion must be present and distinct from '
            "the WAnchor's own click/basic cursor",
      );
    });

    testWidgets('WDiv without a cursor token adds no cursor MouseRegion',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'p-4 bg-blue-500',
              child: Text('Plain'),
            ),
          ),
        ),
      );

      final regions = tester.widgetList<MouseRegion>(
        find.descendant(
          of: find.byType(WDiv),
          matching: find.byType(MouseRegion),
        ),
      );
      // A non-interactive, cursor-less WDiv introduces no MouseRegion of its own.
      expect(regions, isEmpty);
    });
  });
}
