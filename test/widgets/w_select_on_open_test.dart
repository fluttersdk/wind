import 'dart:async';

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

    testWidgets('reaches a WFormMultiSelect too', (tester) async {
      // A multi-select stays open while the reader picks, so a paginating
      // caller reaches the reset more often here than on a single select. The
      // prop was documented for this widget before it was forwarded, which is
      // the reverse of useful: an agent reading the skill wrote it and got a
      // compile error.
      int opened = 0;

      await tester.pumpWidget(
        wrapWithTheme(
          Form(
            child: WFormMultiSelect<String>(
              options: const [SelectOption(value: 'a', label: 'A')],
              onOpen: () => opened++,
              className: 'w-64',
            ),
          ),
        ),
      );

      await tester.tap(find.byType(WSelect<String>));
      await tester.pumpAndSettle();

      expect(opened, 1);
    });

    testWidgets('reaches a WFormSelect too', (tester) async {
      int opened = 0;

      await tester.pumpWidget(
        wrapWithTheme(
          Form(
            child: WFormSelect<String>(
              options: const [SelectOption(value: 'a', label: 'A')],
              onOpen: () => opened++,
              className: 'w-64',
            ),
          ),
        ),
      );

      await tester.tap(find.byType(WSelect<String>));
      await tester.pumpAndSettle();

      expect(opened, 1);
    });
  });

  group('WSelect reopen', () {
    testWidgets('clears a search that was still in flight when it closed', (
      tester,
    ) async {
      // Opening restores `options` and blanks the query, but the in-flight
      // flag survived it, and the resolve path only clears that flag when the
      // query it answers is still the one on screen. So a search closed before
      // its response landed left the reopened menu on a spinner: the reader
      // sees no rows, the response arrives for a query the widget has already
      // discarded, and nothing lowers the flag until another keystroke. A
      // debounced caller makes this ordinary rather than exotic, because the
      // window is the debounce, not the network.
      final completer = Completer<List<SelectOption<String>>>();

      await tester.pumpWidget(
        wrapWithTheme(
          WSelect<String>(
            options: const [SelectOption(value: 'a', label: 'A')],
            searchable: true,
            onSearch: (query) => completer.future,
            className: 'w-64',
          ),
        ),
      );

      await tester.tap(find.byType(WSelect<String>));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(EditableText), 'pacif');
      await tester.pump();

      expect(
        find.byType(CircularProgressIndicator),
        findsOneWidget,
        reason: 'the search is in flight, so the menu is loading',
      );

      // A spinner never stops animating, so every pump past this point is an
      // explicit frame count rather than a settle.
      await tester.tap(find.byType(WSelect<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(WSelect<String>));
      await tester.pump();
      await tester.pump();

      expect(
        find.byType(CircularProgressIndicator),
        findsNothing,
        reason: 'the reopened menu shows the restored options, not a spinner',
      );
      expect(find.text('A'), findsOneWidget);

      // The late response must not resurrect the spinner or overwrite the list
      // the reopen just restored.
      completer.complete(const [SelectOption(value: 'b', label: 'B')]);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsNothing);
    });
  });
}
