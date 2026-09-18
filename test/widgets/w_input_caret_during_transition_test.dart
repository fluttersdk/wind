import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// A focused field pushed in under a route transition.
///
/// WHAT THIS DOES NOT DO, said first because it matters more than what it does:
/// it does not reproduce the crash it was written for. Two shapes were tried, a
/// hand-driven `SlideTransition` and a real `Navigator.push` with an
/// autofocusing field, and both pass with the defect in place. On a device the
/// focus change and the transition's insertion land in the SAME frame; in a
/// widget test autofocus fires a frame later, by which time the ancestor has
/// been laid out and the unsafe read succeeds.
///
/// The crash is real and was measured on an iPhone on 2026-09-18, in a release
/// build: `StateError: Bad state: RenderBox was not laid out:
/// RenderFractionalTranslation`, thrown from `_clearanceBelowCaret` during
/// `build`. `RenderEditable.getLocalRectForCaret` ends in `_snapToPhysicalPixel`
/// → `localToGlobal` → every ancestor's `applyPaintTransform`, and
/// `RenderFractionalTranslation.applyPaintTransform` reads `size` with no layout
/// guard while `RenderBox.size` throws rather than asserting. A slide route
/// transition builds exactly that object.
///
/// So what holds the fix is the stack trace and the API contract
/// (`getEndpointsForSelection` reads `_textPainter` and `_paintOffset` and never
/// leaves the box), plus the seven pixel assertions in
/// `w_input_scroll_into_view_test.dart`, which are unchanged by it.
///
/// What THIS test is, honestly: a regression guard on the shape, so that a
/// future edit reintroducing a build-time ancestor walk has one place that at
/// least exercises a focused field across a push.
void main() {
  setUp(WindParser.clearCache);

  testWidgets('clearing a focused field renders and does not throw', (
    tester,
  ) async {
    // NAMED FOR WHAT IT ASSERTS. Review asked for the scroll-padding number
    // here, on the reasoning that `_controller.text = ''` forces
    // `TextSelection.collapsed(offset: -1)` and `_updateControllerValue`
    // restores a valid selection only when the new value is non-empty, so the
    // invalid selection would reach `_clearanceBelowCaret` and over-reserve.
    //
    // I instrumented the getter rather than trusting the reasoning, and it
    // never sees an invalid selection. Clearing a focused field through the
    // `value` prop prints, on every frame including the first:
    //
    //   isValid=true sel=TextSelection.collapsed(offset: 0) text=""
    //
    // Something normalises the -1 to 0 before `build` reads the clearance, so
    // the framework already does what the offset-0 fallback does, and
    // `scrollPadding.bottom` measures 36.0 before the clear, one pump after it
    // and at settle, identically with the fallback and with the old
    // `return _measuredHeight` bailout restored. A padding assertion here
    // would pass against the defect, which is the thing review was right to
    // object to in the first version of this test.
    //
    // The fallback still ships: offset 0 is the caret of an empty field and
    // costs nothing, so it is the right answer if any path does arrive
    // invalid. It has no test because I could not construct that path, and a
    // test that cannot fail is worse than a stated gap.
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(390, 900);
    addTearDown(tester.view.reset);

    final FocusNode focusNode = FocusNode();
    addTearDown(focusNode.dispose);

    String value = 'something';
    late StateSetter setOuter;

    await tester.pumpWidget(
      WindTheme(
        data: WindThemeData(),
        child: MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                setOuter = setState;

                return WInput(focusNode: focusNode, value: value, minLines: 1);
              },
            ),
          ),
        ),
      ),
    );

    focusNode.requestFocus();
    await tester.pumpAndSettle();

    setOuter(() => value = '');
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(WInput), findsOneWidget);
  });

  testWidgets('a field pushed in under a transition renders and does not throw',
      (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(390, 900);
    addTearDown(tester.view.reset);

    final GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();

    await tester.pumpWidget(
      WindTheme(
        data: WindThemeData(),
        child: MaterialApp(
          navigatorKey: navigator,
          home: const Scaffold(body: SizedBox()),
        ),
      ),
    );

    navigator.currentState!.push(
      MaterialPageRoute<void>(
        builder: (_) =>
            const Scaffold(body: WInput(autofocus: true, minLines: 1)),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 16));

    expect(tester.takeException(), isNull);

    await tester.pumpAndSettle();
    expect(find.byType(WInput), findsOneWidget);
  });
}
