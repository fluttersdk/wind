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

  group('WSelect options change', () {
    testWidgets('drops a page that lands after the caller swapped options', (
      tester,
    ) async {
      // The third place the widget replaces its own list, and the one the
      // reopen epoch did not cover. A caller refreshing `options` while a page
      // is in flight gets that page stitched onto the refreshed list, which is
      // the same symptom the reopen case has: rows from a list the reader is
      // no longer looking at.
      final completer = Completer<List<SelectOption<String>>>();
      int asked = 0;
      final first = List<SelectOption<String>>.generate(
        30,
        (i) => SelectOption(value: 'a$i', label: 'A$i'),
      );
      final refreshed = List<SelectOption<String>>.generate(
        30,
        (i) => SelectOption(value: 'c$i', label: 'C$i'),
      );

      late StateSetter setOuter;
      List<SelectOption<String>> options = first;

      await tester.pumpWidget(
        wrapWithTheme(
          StatefulBuilder(
            builder: (context, setState) {
              setOuter = setState;
              return WSelect<String>(
                options: options,
                hasMore: true,
                onLoadMore: () {
                  asked++;
                  return asked == 1
                      ? completer.future
                      : Future.value(const <SelectOption<String>>[]);
                },
                className: 'w-64',
              );
            },
          ),
        ),
      );

      await tester.tap(find.byType(WSelect<String>));
      await tester.pumpAndSettle();

      await tester.drag(find.byType(Scrollable).last, const Offset(0, -2000));
      await tester.pump();
      expect(asked, 1, reason: 'the scroll has to be what asks for the page');

      // The caller swaps the list under the open menu. Counted pumps, not a
      // settle: the load-more spinner is up and a spinner never settles.
      setOuter(() => options = refreshed);
      await tester.pump();
      await tester.pump();

      completer.complete(
        List<SelectOption<String>>.generate(
          10,
          (i) => SelectOption(value: 'b$i', label: 'B$i'),
        ),
      );
      await tester.pump();
      await tester.pump();

      // Walk to the end of the refreshed list, for the same reason the reopen
      // case does: a row stitched onto the end of a lazy list is never built.
      for (var i = 0; i < 6; i++) {
        await tester.drag(find.byType(Scrollable).last, const Offset(0, -600));
        await tester.pump();
      }

      expect(
        find.text('B9'),
        findsNothing,
        reason: 'the stale page appended onto the refreshed list',
      );
      expect(
        find.text('C29'),
        findsOneWidget,
        reason: 'the refreshed list still ends where the caller left it',
      );
    });
    testWidgets('does not strand the menu on a spinner after the swap', (
      tester,
    ) async {
      // The other half of the same bump, and the half that reopened a bug the
      // epoch had just closed. Dropping a stale response is right; dropping it
      // through the ONLY path that lowers the in-flight flag is not. The reset
      // has to lower it, exactly as the open branch does, because after the
      // reset nobody else owns it.
      //
      // The empty query is what makes this reachable: `didUpdateWidget`
      // re-runs the search only when the query is non-empty, so a search for
      // `''` in flight at the swap has nothing behind it to raise and lower
      // the flag again.
      final cleared = Completer<List<SelectOption<String>>>();
      final typed = Completer<List<SelectOption<String>>>();

      late StateSetter setOuter;
      List<SelectOption<String>> options = const [
        SelectOption(value: 'a', label: 'A'),
      ];

      await tester.pumpWidget(
        wrapWithTheme(
          StatefulBuilder(
            builder: (context, setState) {
              setOuter = setState;
              return WSelect<String>(
                options: options,
                searchable: true,
                onSearch: (query) =>
                    query.isEmpty ? cleared.future : typed.future,
                className: 'w-64',
              );
            },
          ),
        ),
      );

      await tester.tap(find.byType(WSelect<String>));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(EditableText), 'p');
      await tester.pump();
      await tester.enterText(find.byType(EditableText), '');
      await tester.pump();

      // The caller refreshes the list while that search is still out, which is
      // the ordinary shape: its own search handler writing results to state.
      setOuter(() => options = const [SelectOption(value: 'c', label: 'C')]);
      await tester.pump();
      await tester.pump();

      expect(
        find.byType(CircularProgressIndicator),
        findsNothing,
        reason: 'the refreshed list is here, so nothing is still loading',
      );
      expect(find.text('C'), findsOneWidget);

      // And the late response must not put the spinner back or overwrite it.
      typed.complete(const [SelectOption(value: 'p', label: 'P')]);
      cleared.complete(const [SelectOption(value: 'b', label: 'B')]);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('C'), findsOneWidget);
      expect(find.text('B'), findsNothing);
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

    testWidgets('drops an EMPTY-query search that lands after it', (
      tester,
    ) async {
      // The query string cannot tell a stale response from a current one when
      // the query is empty, because the reset sets `_searchQuery` to exactly
      // that. Type, delete back to empty (which fires a fresh remote search
      // rather than local filtering whenever `onSearch` is set), close and
      // reopen before it lands: the response passes a query-equality guard and
      // overwrites the list the reopen restored.
      final typed = Completer<List<SelectOption<String>>>();
      final cleared = Completer<List<SelectOption<String>>>();

      await tester.pumpWidget(
        wrapWithTheme(
          WSelect<String>(
            options: const [SelectOption(value: 'a', label: 'A')],
            searchable: true,
            onSearch: (query) => query.isEmpty ? cleared.future : typed.future,
            className: 'w-64',
          ),
        ),
      );

      await tester.tap(find.byType(WSelect<String>));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(EditableText), 'p');
      await tester.pump();
      await tester.enterText(find.byType(EditableText), '');
      await tester.pump();

      await tester.tap(find.byType(WSelect<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(WSelect<String>));
      await tester.pump();
      await tester.pump();

      typed.complete(const [SelectOption(value: 'p', label: 'P')]);
      cleared.complete(const [SelectOption(value: 'b', label: 'B')]);
      await tester.pump();

      expect(find.text('A'), findsOneWidget);
      expect(
        find.text('B'),
        findsNothing,
        reason: 'the stale empty-query response wrote over the restored list',
      );
    });

    testWidgets('drops a page that lands after it', (tester) async {
      // Same shape on the other async path: a page asked for before the close
      // appends onto the list the reopen restored, so the reader sees page two
      // stitched under a page one they never scrolled past.
      final completer = Completer<List<SelectOption<String>>>();
      int asked = 0;
      final page = List<SelectOption<String>>.generate(
        30,
        (i) => SelectOption(value: 'a$i', label: 'A$i'),
      );

      await tester.pumpWidget(
        wrapWithTheme(
          WSelect<String>(
            options: page,
            hasMore: true,
            onLoadMore: () {
              asked++;
              // Only the first ask is the one held open across the reopen. The
              // walk to the end below asks again, and answering it with an
              // empty page keeps the assertion about the stale page alone.
              return asked == 1
                  ? completer.future
                  : Future.value(const <SelectOption<String>>[]);
            },
            className: 'w-64',
          ),
        ),
      );

      await tester.tap(find.byType(WSelect<String>));
      await tester.pumpAndSettle();

      // Scroll the menu to its end, which is what asks for the next page.
      await tester.drag(find.byType(Scrollable).last, const Offset(0, -2000));
      await tester.pump();

      expect(asked, 1, reason: 'the scroll has to be what asks for the page');

      await tester.tap(find.byType(WSelect<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(WSelect<String>));
      await tester.pump();
      await tester.pump();

      completer.complete(
        List<SelectOption<String>>.generate(
          10,
          (i) => SelectOption(value: 'b$i', label: 'B$i'),
        ),
      );
      await tester.pump();
      await tester.pump();

      // Walk to the end of the reopened list and look there. A `find.text`
      // without the walk is vacuous: the menu is a lazy `ListView`, so a row
      // stitched onto the end is never built and the finder answers
      // `findsNothing` whether or not the append happened. Scroll extent is no
      // better, because the reopen recomputes whether the menu opens upward
      // and the viewport height moves with it.
      for (var i = 0; i < 6; i++) {
        await tester.drag(find.byType(Scrollable).last, const Offset(0, -600));
        await tester.pump();
      }

      expect(
        find.text('B9'),
        findsNothing,
        reason: 'the stale page appended onto the restored list',
      );
      expect(
        find.text('A29'),
        findsOneWidget,
        reason: 'the restored list still ends where the reader left it',
      );
    });
  });
}
