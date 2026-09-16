import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride, TargetPlatform;
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// A host that shrinks its child by the keyboard inset.
///
/// What `Scaffold.resizeToAvoidBottomInset` does, written out because the field
/// under test has to sit in a viewport that genuinely shrinks: with a viewport
/// that stays full height the keyboard covers the field without the scrollable
/// ever knowing, and nothing can be asserted about scrolling.
class _ResizingHost extends StatelessWidget {
  const _ResizingHost({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: child,
    );
  }
}

void main() {
  setUp(WindParser.clearCache);

  /// Drives the reported sequence and answers where the field ended up.
  ///
  /// The keyboard is raised AFTER the tap on purpose. That is the real order,
  /// and it is the whole difficulty: at the moment focus lands the viewport is
  /// still full height and a field near the bottom is genuinely visible, so a
  /// scroll computed then correctly does nothing.
  Future<Rect> tapAndRaiseKeyboard(
    WidgetTester tester, {
    required int minLines,
  }) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(390, 900);
    tester.view.viewInsets = FakeViewPadding.zero;
    addTearDown(tester.view.reset);

    final ScrollController controller = ScrollController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: WindTheme(
          data: WindThemeData(),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: _ResizingHost(
              child: SingleChildScrollView(
                controller: controller,
                child: Column(
                  children: [
                    const SizedBox(height: 1500),
                    WInput(
                      type: minLines > 1 ? InputType.multiline : InputType.text,
                      minLines: minLines,
                      maxLines: minLines > 1 ? 6 : 1,
                      placeholder: 'field',
                    ),
                    // 900 below the field rather than a few pixels. With the
                    // field at the page bottom every scroll ends at
                    // `maxScrollExtent` and an assertion about where the field
                    // landed passes on the page running out instead: measured
                    // 584 at every field height, `pixels == maxScrollExtent`
                    // each time, so the harness could not tell a working
                    // alignment from a broken one.
                    const SizedBox(height: 900),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Put the field just above the fold, which is where a reader is standing
    // when they tap the last field on a long page. Dragging to the END of the
    // page instead scrolls PAST it and measures a different situation.
    final double fieldBottom = tester.getRect(find.byType(WInput)).bottom;
    controller.jumpTo(controller.offset + fieldBottom - 880);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(EditableText));
    await tester.pump();

    // No `handleMetricsChanged()`: `TestFlutterView.viewInsets`'s setter
    // already calls `platformDispatcher.onMetricsChanged`
    // (`flutter_test/lib/src/window.dart:1207`). Firing it a second time hands
    // this widget two post-frame callbacks to `EditableText`'s one, since
    // `EditableText` de-dupes its own, and that is what made an earlier
    // `ensureVisible` look like it was doing the work.
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    await tester.pumpAndSettle();

    return tester.getRect(find.byType(EditableText));
  }

  group('WInput scroll into view', () {
    testWidgets('a multiline field clears the keyboard entirely', (
      tester,
    ) async {
      // `EditableText` already scrolls on focus and on every metrics change,
      // but it scrolls the CARET with its `scrollPadding` around it. On one
      // line the two are the same box. On several they are not: the caret sits
      // on the first line, so the first line clears the keyboard and every line
      // below it stays under it. Reported against a three-line incident-update
      // composer, where tapping the field left most of it behind the keyboard
      // and the reader scrolled by hand. Measured before the fix: the field ran
      // to 608 against a keyboard starting at 600.
      final Rect field = await tapAndRaiseKeyboard(tester, minLines: 3);

      // An EXACT value, not `lessThanOrEqualTo(600)`. The loose form passes
      // for any scroll that went far enough, including one that overshot the
      // field off the top of the screen, and it passed throughout the version
      // of this fix that did exactly that.
      expect(
        field.bottom,
        564.0,
        reason: 'the whole field has to clear the keyboard, not just line one',
      );
    });

    testWidgets('a single-line field clears it too', (tester) async {
      // The case `EditableText` already handled, pinned so the new scroll
      // cannot overshoot it into the opposite failure.
      final Rect field = await tapAndRaiseKeyboard(tester, minLines: 1);

      expect(field.bottom, 564.0);
      expect(
        field.top,
        greaterThanOrEqualTo(0.0),
        reason: 'and it must not be yanked off the top of the viewport',
      );
    });

    testWidgets('a field already in view is left where it is', (tester) async {
      // `keepVisibleAtEnd` rather than a plain `ensureVisible`, so a field the
      // reader can already see does not jump to an edge under them the moment
      // the keyboard opens.
      tester.view.devicePixelRatio = 1.0;
      tester.view.physicalSize = const Size(390, 900);
      tester.view.viewInsets = FakeViewPadding.zero;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: _ResizingHost(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      WInput(placeholder: 'near the top'),
                      const SizedBox(height: 1500),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final Rect before = tester.getRect(find.byType(EditableText));

      await tester.tap(find.byType(EditableText));
      await tester.pump();
      // No `handleMetricsChanged()` here: `TestFlutterView.viewInsets`'s setter
      // already calls `platformDispatcher.onMetricsChanged`
      // (`flutter_test/lib/src/window.dart:1207`). Firing it a second time gave
      // this widget two post-frame callbacks to `EditableText`'s one, because
      // `EditableText` de-dupes its own and this one did not, and that is what
      // made an earlier `ensureVisible` look like it was working.
      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      await tester.pumpAndSettle();

      expect(tester.getRect(find.byType(EditableText)), before);
    });
  });

  testWidgets('the caret padding grows with the field', (tester) async {
    // The second half of the fix, and the one that does not depend on this
    // widget winning a race. `EditableText` scrolls its CARET into view on
    // every metrics frame with `scrollPadding` around it, so widening that
    // padding below by the field's own height aims Flutter's own mechanism
    // at the same place `ensureVisible` aims at. Whichever runs last on a
    // given device then produces the same result.
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(390, 900);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: WindTheme(
          data: WindThemeData(),
          child: Scaffold(
            body: Column(
              children: [
                WInput(
                  type: InputType.multiline,
                  minLines: 6,
                  maxLines: 6,
                  placeholder: 'tall',
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final double height = tester.getRect(find.byType(WInput)).height;

    await tester.tap(find.byType(EditableText));
    await tester.pumpAndSettle();

    final EditableText editable = tester.widget<EditableText>(
      find.byType(EditableText),
    );

    expect(
      editable.scrollPadding.bottom,
      greaterThanOrEqualTo(height),
      reason: 'the caret has to clear the lines below it, not just itself',
    );
  });

  group('the iOS keyboard toolbar', () {
    testWidgets('is published, and the field asks to clear it as well', (
      tester,
    ) async {
      // The occlusion nothing reports. `WKeyboardActions` draws its bar in an
      // overlay at `bottom: viewInsets.bottom`, so it sits ON TOP of the
      // keyboard and the engine knows nothing about it: a field that cleared
      // `viewInsets` alone came out from under the keyboard and straight under
      // the toolbar. It is also why this never reproduced in a test before,
      // since the bar is iOS-gated and widget tests run as Android.
      //
      // Asserted on the published height and the padding that consumes it,
      // in one run. The two comparisons that look more natural are both
      // confounded: before-and-after on one focus grows either way, because
      // focusing also measures the field's own height into the padding, and
      // running the same widget twice in one test body carries state between
      // the runs (measured 78 then 126, in the wrong direction).
      //
      // Reset inside the BODY, not through `addTearDown`: the framework's
      // foundation-vars invariant runs before tear-downs and fails the test
      // with "a foundation debug variable was changed by the test". In a
      // `finally`, so a throw in any pump below cannot leak iOS into every
      // later test in the process.
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      try {
        tester.view.devicePixelRatio = 1.0;
        tester.view.physicalSize = const Size(390, 900);
        addTearDown(tester.view.reset);

        final FocusNode node = FocusNode();
        addTearDown(node.dispose);

        double published = -1;

        await tester.pumpWidget(
          MaterialApp(
            home: WindTheme(
              data: WindThemeData(),
              child: Scaffold(
                body: WKeyboardActions(
                  focusNodes: [node],
                  platform: 'ios',
                  child: Builder(
                    builder: (BuildContext context) {
                      published = WKeyboardToolbarInset.of(context);
                      return WInput(
                        focusNode: node,
                        type: InputType.multiline,
                        minLines: 3,
                        maxLines: 3,
                        placeholder: 'composer',
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pump();

        expect(published, 0, reason: 'nothing is focused, so no bar is up');

        node.requestFocus();
        // Counted pumps, never a settle: an active toolbar schedules a frame per
        // frame and `pumpAndSettle` on a focused textarea never returns.
        // Several: the overlay is inserted on the focus frame, its Material has
        // no size until the frame after, the measurement retries until it does,
        // and the publish defers one more so setState is legal.
        for (var i = 0; i < 6; i++) {
          await tester.pump();
        }

        final double toolbar = published;
        final double padding = tester
            .widget<EditableText>(find.byType(EditableText))
            .scrollPadding
            .bottom;

        expect(
          toolbar,
          greaterThan(0),
          reason: 'the bar is up, so its height has to reach the subtree',
        );

        expect(
          padding,
          greaterThanOrEqualTo(toolbar),
          reason: 'the field clears the keyboard, the bar, and its own lines',
        );
        // And back to zero when the bar goes. A published height that outlived
        // its toolbar would have every field below reserving room for a bar
        // that is not on screen.
        node.unfocus();
        for (var i = 0; i < 4; i++) {
          await tester.pump();
        }

        expect(
          published,
          0,
          reason: 'the bar is down, so nothing should still be reserved',
        );
      } finally {
        debugDefaultTargetPlatformOverride = null;
      }
    });
  });

  group('the caret', () {
    testWidgets('a field taller than the viewport keeps its top on screen', (
      tester,
    ) async {
      // The failure the earlier `ensureVisible` version had, and the one a
      // padding term of the FULL field height would have reintroduced:
      // `EditableText` inflates the CARET rect, not the field's, so once the
      // reader types down to the last line a full-height term reserves a second
      // field below the caret and scrolls the whole thing away.
      //
      // Asserted on the BOTTOM, not the top. With the caret on the last line
      // the caret sits at the field's bottom, so a field taller than the
      // visible area cannot both show its caret and keep its top on screen:
      // overflowing upward is the correct degradation, and an earlier version
      // of this test demanded the impossible and only passed because the
      // padding was wrong in a way that happened to hide it. Measured at 10,
      // 25 and 40 lines: bottoms 572, 572, 572, tops 416, 206 and -4.
      tester.view.devicePixelRatio = 1.0;
      tester.view.physicalSize = const Size(390, 900);
      addTearDown(tester.view.reset);

      for (final int lines in <int>[10, 25, 40]) {
        tester.view.reset();
        tester.view.devicePixelRatio = 1.0;
        tester.view.physicalSize = const Size(390, 900);
        tester.view.viewInsets = FakeViewPadding.zero;

        final ScrollController controller = ScrollController();
        final TextEditingController text = TextEditingController(
          text: List<String>.filled(lines, 'x').join('\n'),
        );
        addTearDown(controller.dispose);
        addTearDown(text.dispose);

        await tester.pumpWidget(
          MaterialApp(
            home: WindTheme(
              data: WindThemeData(),
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                body: _ResizingHost(
                  child: SingleChildScrollView(
                    controller: controller,
                    child: Column(
                      children: [
                        const SizedBox(height: 1500),
                        WInput(
                          controller: text,
                          type: InputType.multiline,
                          minLines: lines,
                          maxLines: lines,
                          placeholder: 'composer',
                        ),
                        const SizedBox(height: 900),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        controller.jumpTo(
          controller.offset + tester.getRect(find.byType(WInput)).bottom - 880,
        );
        await tester.pumpAndSettle();

        // Where the caret sits after typing, which is the case the full-height
        // term got wrong.
        text.selection = TextSelection.collapsed(offset: text.text.length);
        await tester.tap(find.byType(EditableText));
        await tester.pump();
        tester.view.viewInsets = const FakeViewPadding(bottom: 300);
        await tester.pumpAndSettle();

        expect(
          tester.getRect(find.byType(WInput)).bottom,
          572.0,
          reason: 'the caret on the last line has to clear the keyboard',
        );
      }
    });
  });

  group('typing after the keyboard is up', () {
    testWidgets('a field that fits stays on screen as the caret descends', (
      tester,
    ) async {
      // The clearance is read during `build`, and typing does not rebuild this
      // widget: `EditableText` owns the text, and the only controller listener
      // here drives the placeholder, whose subtree collapses the moment the
      // field is not empty. So without a listener of its own the padding stays
      // the one computed at focus, with the caret on line one, while
      // `EditableText` re-reveals the descending caret against it.
      //
      // Tapped BEFORE the text is entered, which is the order that matters:
      // setting the selection first, as the test above does, hands the single
      // build that counts a caret already at the end and hides this entirely.
      // Reset BEFORE setting, not only after. The tall-field test above loops
      // over three heights on one tester, and until it reset the view per
      // iteration it left state that moved this test by 400 pixels while it
      // passed in isolation. That is fixed at the source now; the reset here
      // is what keeps the next loop from doing it again.
      tester.view.devicePixelRatio = 1.0;
      tester.view.physicalSize = const Size(390, 900);
      tester.view.viewInsets = FakeViewPadding.zero;
      addTearDown(tester.view.reset);

      final ScrollController controller = ScrollController();
      final TextEditingController text = TextEditingController();
      addTearDown(controller.dispose);
      addTearDown(text.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: _ResizingHost(
                child: SingleChildScrollView(
                  controller: controller,
                  child: Column(
                    children: [
                      const SizedBox(height: 1500),
                      WInput(
                        controller: text,
                        type: InputType.multiline,
                        minLines: 6,
                        maxLines: 6,
                        placeholder: 'composer',
                      ),
                      const SizedBox(height: 900),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      controller.jumpTo(
        controller.offset + tester.getRect(find.byType(WInput)).bottom - 880,
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(EditableText));
      await tester.pump();
      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(EditableText),
        List<String>.filled(6, 'x').join('\n'),
      );
      await tester.pumpAndSettle();

      final Rect field = tester.getRect(find.byType(WInput));

      expect(
        field.top,
        greaterThanOrEqualTo(0.0),
        reason: 'typing walked the field off the top of the screen',
      );
      expect(
        field.bottom,
        lessThanOrEqualTo(600.0),
        reason: 'and it still has to clear the keyboard',
      );

      // The assertion that actually pins the listener. Geometry alone does not:
      // a 6-line field is small enough that it stays on screen either way, and
      // this test passed with the listener removed. What changes is the
      // reserve itself, which is frozen at its focus-time value without one.
      // Measured: 582 at focus with the caret on line one, 36 once the caret
      // has reached the last line, and 582 throughout with no listener.
      expect(
        tester
            .widget<EditableText>(find.byType(EditableText))
            .scrollPadding
            .bottom,
        lessThan(100),
        reason: 'the reserve is still the one computed at focus',
      );
    });
  });
}
