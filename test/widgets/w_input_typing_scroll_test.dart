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
      // Reset BEFORE setting, not only after: a preceding test in this file
      // leaves view state that moves this one by 400 pixels, and it passes in
      // isolation either way. Ordering dependence is the thing being removed
      // here, not a symptom of the widget.
      tester.view.reset();
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
