import 'package:flutter/material.dart';
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
  setUp(WindParser.clearCache);

  group('WSelect.onOpen', () {
    // Opening resets the widget's own visible list, and a caller paginating
    // through `onLoadMore` keeps its cursor across that reset unless something
    // tells it. Reported against a searchable timezone select: open, scroll
    // once to pull page two, close, reopen, and page two's rows were
    // unreachable without searching for them, because the next scroll asked
    // for page three.
    testWidgets('fires when the menu opens', (tester) async {
      int opened = 0;

      await tester.pumpWidget(
        wrapWithTheme(
          WSelect<String>(
            options: const [SelectOption(value: 'a', label: 'A')],
            onOpen: () => opened++,
            className: 'w-64',
          ),
        ),
      );

      expect(opened, 0, reason: 'nothing has opened yet');

      await tester.tap(find.byType(WSelect<String>));
      await tester.pumpAndSettle();

      expect(opened, 1);
    });

    testWidgets('fires again on a reopen, which is the case it exists for', (
      tester,
    ) async {
      int opened = 0;

      await tester.pumpWidget(
        wrapWithTheme(
          WSelect<String>(
            options: const [SelectOption(value: 'a', label: 'A')],
            onOpen: () => opened++,
            className: 'w-64',
          ),
        ),
      );

      for (var i = 0; i < 2; i++) {
        await tester.tap(find.byType(WSelect<String>));
        await tester.pumpAndSettle();
        await tester.tap(find.byType(WSelect<String>));
        await tester.pumpAndSettle();
      }

      expect(opened, 2, reason: 'once per open, never on a close');
    });

    testWidgets('a select without the callback still opens', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const WSelect<String>(
            options: [SelectOption(value: 'a', label: 'A')],
            className: 'w-64',
          ),
        ),
      );

      await tester.tap(find.byType(WSelect<String>));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
