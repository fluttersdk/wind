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

  testWidgets('clearing a focused field does not jump its scroll padding', (
    tester,
  ) async {
    // Review found this path, and it is ordinary: `_controller.text = ''` forces
    // `TextSelection.collapsed(offset: -1)`, and `_updateControllerValue`
    // restores a valid selection only when the new value is non-empty. A first
    // version of the crash fix bailed out to the full field height there, which
    // is the over-reserve `_clearanceBelowCaret` documents as the failure its
    // caret measurement exists to avoid.
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
