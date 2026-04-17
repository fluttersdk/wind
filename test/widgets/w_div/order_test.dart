import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

List<String> visibleTextsInOrder(WidgetTester tester,
    {bool horizontal = true}) {
  final texts = tester.widgetList<Text>(find.byType(Text)).toList();
  final entries = <({double pos, String text})>[];
  for (final t in texts) {
    final finder = find.byWidget(t);
    if (finder.evaluate().isEmpty) continue;
    final box = tester.getTopLeft(finder);
    entries.add((pos: horizontal ? box.dx : box.dy, text: t.data ?? ''));
  }
  entries.sort((a, b) => a.pos.compareTo(b.pos));
  return entries.map((e) => e.text).toList();
}

void main() {
  setUp(() {
    WindParser.clearCache();
  });

  group('WDiv order-* reordering', () {
    testWidgets('reorders children by order-* value', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'flex flex-row',
              children: [
                WDiv(className: 'order-3', child: Text('A')),
                WDiv(className: 'order-1', child: Text('B')),
                WDiv(className: 'order-2', child: Text('C')),
              ],
            ),
          ),
        ),
      );

      expect(visibleTextsInOrder(tester), ['B', 'C', 'A']);
    });

    testWidgets('order-first places child first', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'flex',
              children: [
                WDiv(child: Text('A')),
                WDiv(child: Text('B')),
                WDiv(className: 'order-first', child: Text('C')),
              ],
            ),
          ),
        ),
      );

      expect(visibleTextsInOrder(tester), ['C', 'A', 'B']);
    });

    testWidgets('order-last places child last', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'flex',
              children: [
                WDiv(className: 'order-last', child: Text('A')),
                WDiv(child: Text('B')),
                WDiv(child: Text('C')),
              ],
            ),
          ),
        ),
      );

      expect(visibleTextsInOrder(tester), ['B', 'C', 'A']);
    });

    testWidgets('children without order-* default to 0 (stable)',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'flex',
              children: [
                WDiv(child: Text('A')),
                WDiv(className: 'order-1', child: Text('B')),
                WDiv(child: Text('C')),
              ],
            ),
          ),
        ),
      );

      expect(visibleTextsInOrder(tester), ['A', 'C', 'B']);
    });

    testWidgets('no order-* keeps original order (no sort)', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'flex',
              children: [
                WDiv(child: Text('A')),
                WDiv(child: Text('B')),
                WDiv(child: Text('C')),
              ],
            ),
          ),
        ),
      );

      expect(visibleTextsInOrder(tester), ['A', 'B', 'C']);
    });

    testWidgets('mixed Wind and non-Wind children reorder correctly',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'flex',
              children: [
                WDiv(className: 'order-2', child: Text('A')),
                Text('B'),
                WDiv(className: 'order-first', child: Text('C')),
              ],
            ),
          ),
        ),
      );

      expect(visibleTextsInOrder(tester), ['C', 'B', 'A']);
    });
  });

  group('WDiv flex-*-reverse', () {
    testWidgets('flex-row-reverse reverses final order', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'flex flex-row-reverse',
              children: [
                WDiv(child: Text('A')),
                WDiv(child: Text('B')),
                WDiv(child: Text('C')),
              ],
            ),
          ),
        ),
      );

      expect(visibleTextsInOrder(tester), ['C', 'B', 'A']);
    });

    testWidgets('flex-col-reverse reverses final order', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'flex flex-col-reverse',
              children: [
                WDiv(child: Text('A')),
                WDiv(child: Text('B')),
                WDiv(child: Text('C')),
              ],
            ),
          ),
        ),
      );

      expect(visibleTextsInOrder(tester, horizontal: false), ['C', 'B', 'A']);
      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('order-* applies before flex-row-reverse', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(
              className: 'flex flex-row-reverse',
              children: [
                WDiv(className: 'order-3', child: Text('A')),
                WDiv(className: 'order-1', child: Text('B')),
                WDiv(className: 'order-2', child: Text('C')),
              ],
            ),
          ),
        ),
      );

      // sorted: B, C, A; then reversed: A, C, B
      expect(visibleTextsInOrder(tester), ['A', 'C', 'B']);
    });
  });
}
