import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
                    const SizedBox(height: 1500),
                    WInput(
                      type: minLines > 1 ? InputType.multiline : InputType.text,
                      minLines: minLines,
                      maxLines: minLines > 1 ? 6 : 1,
                      placeholder: 'field',
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Dragged from a POINT rather than from a `Scrollable` finder: a finder can
    // land on a scrollable that is not the content one, and a drag on that
    // silently moves nothing, which reads as a page that would not scroll.
    for (var i = 0; i < 4; i++) {
      await tester.dragFrom(const Offset(195, 400), const Offset(0, -600));
      await tester.pumpAndSettle();
    }

    await tester.tap(find.byType(EditableText));
    await tester.pump();

    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    tester.binding.handleMetricsChanged();
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

      expect(
        field.bottom,
        lessThanOrEqualTo(600.0),
        reason: 'the whole field has to clear the keyboard, not just line one',
      );
    });

    testWidgets('a single-line field clears it too', (tester) async {
      // The case `EditableText` already handled, pinned so the new scroll
      // cannot overshoot it into the opposite failure.
      final Rect field = await tapAndRaiseKeyboard(tester, minLines: 1);

      expect(field.bottom, lessThanOrEqualTo(600.0));
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
      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      tester.binding.handleMetricsChanged();
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
}
