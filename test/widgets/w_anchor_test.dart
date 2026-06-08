import 'dart:ui' show Tristate;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Helper to wrap widget in MaterialApp with WindTheme
Widget wrapWithTheme(Widget child) {
  return MaterialApp(
    home: WindTheme(
      data: WindThemeData(),
      child: Scaffold(
        body: Center(
          child: child,
        ),
      ),
    ),
  );
}

/// A consumer widget to verify WindAnchorState without relying on styling
class AnchorStateReader extends StatelessWidget {
  final Widget Function(BuildContext context, WindAnchorState? state) builder;

  const AnchorStateReader({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    final state = WindAnchorStateProvider.of(context);
    return builder(context, state);
  }
}

void main() {
  group('WAnchor Widget Tests', () {
    // -------------------------------------------------------------------------
    // 1. Rendering & Structure
    // -------------------------------------------------------------------------
    group('Rendering & Structure', () {
      testWidgets('renders child content', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WAnchor(child: const Text('Anchor Content')),
          ),
        );
        expect(find.text('Anchor Content'), findsOneWidget);
      });

      testWidgets('includes Focus widget internally', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WAnchor(
              key: const Key('anchor'),
              child: const Text('Content'),
            ),
          ),
        );

        // WAnchor structure: Provider -> MouseRegion -> (GestureDetector) -> Focus -> Child
        // We look for a Focus widget that is a descendant of the specific WAnchor
        final focusFinder = find
            .descendant(
              of: find.byKey(const Key('anchor')),
              matching: find.byType(Focus),
            )
            .first;

        expect(focusFinder, findsOneWidget);
      });

      testWidgets('includes GestureDetector ONLY when callbacks provided',
          (tester) async {
        // Case A: No callbacks -> No GestureDetector
        await tester.pumpWidget(
          wrapWithTheme(
            WAnchor(child: const Text('No Gesture')),
          ),
        );

        // Look for GestureDetector wrapping the specific text
        final gestureFinder = find.ancestor(
            of: find.text('No Gesture'),
            matching: find.byType(GestureDetector));
        expect(gestureFinder, findsNothing);

        // Case B: With callback -> Has GestureDetector
        await tester.pumpWidget(
          wrapWithTheme(
            WAnchor(
              onTap: () {},
              child: const Text('Has Gesture'),
            ),
          ),
        );
        final gestureFinder2 = find.ancestor(
            of: find.text('Has Gesture'),
            matching: find.byType(GestureDetector));
        expect(gestureFinder2, findsOneWidget);
      });
    });

    // -------------------------------------------------------------------------
    // 2. State Logic (Provider Verification)
    // -------------------------------------------------------------------------
    group('State Logic', () {
      testWidgets('hover state updates provider', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WAnchor(
              child: AnchorStateReader(
                builder: (context, state) =>
                    Text('Hover: ${state?.isHovering}'),
              ),
            ),
          ),
        );

        expect(find.text('Hover: false'), findsOneWidget);

        // Simulate Mouse Enter
        final gesture =
            await tester.createGesture(kind: PointerDeviceKind.mouse);
        await gesture.addPointer(location: Offset.zero);
        addTearDown(gesture.removePointer);
        await gesture.moveTo(tester.getCenter(find.text('Hover: false')));

        // Critical: Pump once for event
        await tester.pump();

        expect(find.text('Hover: true'), findsOneWidget);
      });

      testWidgets('focus state updates provider', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WAnchor(
              child: AnchorStateReader(
                builder: (context, state) => Text('Focus: ${state?.isFocused}'),
              ),
            ),
          ),
        );

        expect(find.text('Focus: false'), findsOneWidget);

        // Find the internal Focus widget created by WAnchor
        // We look up from the text widget
        final focusFinder = find
            .ancestor(
                of: find.text('Focus: false'), matching: find.byType(Focus))
            .first;

        final focusWidget = tester.widget<Focus>(focusFinder);

        // WAnchor passes its node to the Focus widget
        if (focusWidget.focusNode != null) {
          focusWidget.focusNode!.requestFocus();
          await tester.pumpAndSettle();
        }

        expect(find.text('Focus: true'), findsOneWidget);
      });

      testWidgets('custom states propagate to provider', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WAnchor(
              states: {'active', 'selected'},
              child: AnchorStateReader(
                builder: (context, state) {
                  final states = state?.customStates?.join(',') ?? '';
                  return Text('States: $states');
                },
              ),
            ),
          ),
        );

        expect(find.textContaining('active'), findsOneWidget);
        expect(find.textContaining('selected'), findsOneWidget);
      });
    });

    // -------------------------------------------------------------------------
    // 3. Interactions
    // -------------------------------------------------------------------------
    group('Interactions', () {
      testWidgets('onTap callback fires', (tester) async {
        bool tapped = false;
        await tester.pumpWidget(
          wrapWithTheme(
            WAnchor(
              onTap: () => tapped = true,
              child: Container(
                width: 100,
                height: 100,
                color: Colors.green, // Ensure hit-testable
                child: const Text('Tap Me'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Tap Me'));
        await tester.pump();
        expect(tapped, isTrue);
      });

      testWidgets('onLongPress callback fires', (tester) async {
        bool pressed = false;
        await tester.pumpWidget(
          wrapWithTheme(
            WAnchor(
              onLongPress: () => pressed = true,
              child: Container(
                width: 100,
                height: 100,
                color: Colors.green,
                child: const Text('Press Me'),
              ),
            ),
          ),
        );

        await tester.longPress(find.text('Press Me'));
        await tester.pump();
        expect(pressed, isTrue);
      });

      testWidgets('onDoubleTap callback fires', (tester) async {
        bool doubleTapped = false;
        await tester.pumpWidget(
          wrapWithTheme(
            WAnchor(
              onDoubleTap: () => doubleTapped = true,
              child: Container(
                width: 100,
                height: 100,
                color: Colors.green,
                child: const Text('Double Tap Me'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Double Tap Me'));
        await tester.pump(const Duration(milliseconds: 50));
        await tester.tap(find.text('Double Tap Me'));
        await tester.pumpAndSettle();

        expect(doubleTapped, isTrue);
      });
    });

    // -------------------------------------------------------------------------
    // 4. Disabled State
    // -------------------------------------------------------------------------
    group('Disabled State', () {
      testWidgets('prevents hover state update', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WAnchor(
              isDisabled: true,
              child: AnchorStateReader(
                builder: (context, state) =>
                    Text('Hover: ${state?.isHovering}'),
              ),
            ),
          ),
        );

        final gesture =
            await tester.createGesture(kind: PointerDeviceKind.mouse);
        await gesture.addPointer(location: Offset.zero);
        addTearDown(gesture.removePointer);
        await gesture.moveTo(tester.getCenter(find.text('Hover: false')));

        await tester.pump();

        // Should NOT change
        expect(find.text('Hover: false'), findsOneWidget);
      });

      testWidgets('blocks onTap callback', (tester) async {
        bool tapped = false;
        await tester.pumpWidget(
          wrapWithTheme(
            WAnchor(
              isDisabled: true,
              onTap: () => tapped = true,
              child: Container(
                width: 100,
                height: 100,
                color: Colors.red,
                child: const Text('Disabled'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Disabled'));
        await tester.pump();
        expect(tapped, isFalse);
      });

      testWidgets('shows basic cursor', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WAnchor(
              isDisabled: true,
              onTap: () {}, // Interactive if not disabled
              child: const SizedBox(width: 100, height: 100),
            ),
          ),
        );

        // Find MouseRegion ancestor of the SizedBox
        final mouseRegion = tester.widget<MouseRegion>(find
            .ancestor(
                of: find.byType(SizedBox), matching: find.byType(MouseRegion))
            .first);
        expect(mouseRegion.cursor, equals(SystemMouseCursors.basic));
      });
    });

    // -------------------------------------------------------------------------
    // 5. Cursor Behavior
    // -------------------------------------------------------------------------
    group('Cursor Behavior', () {
      testWidgets('shows click cursor when interactive', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WAnchor(
              onTap: () {},
              child: const SizedBox(width: 100, height: 100),
            ),
          ),
        );

        final mouseRegion = tester.widget<MouseRegion>(find
            .ancestor(
                of: find.byType(SizedBox), matching: find.byType(MouseRegion))
            .first);
        expect(mouseRegion.cursor, equals(SystemMouseCursors.click));
      });

      testWidgets('shows basic cursor when non-interactive', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WAnchor(
              child: const SizedBox(width: 100, height: 100),
            ),
          ),
        );

        final mouseRegion = tester.widget<MouseRegion>(find
            .ancestor(
                of: find.byType(SizedBox), matching: find.byType(MouseRegion))
            .first);
        expect(mouseRegion.cursor, equals(SystemMouseCursors.basic));
      });
    });

    // -------------------------------------------------------------------------
    // 6. Nesting
    // -------------------------------------------------------------------------
    group('Nesting', () {
      testWidgets('nested anchors function independently', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WAnchor(
              key: const Key('parent'),
              child: SizedBox(
                width: 300,
                height: 300,
                child: Center(
                  child: WAnchor(
                    key: const Key('child'),
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: AnchorStateReader(
                        builder: (context, state) =>
                            Text('ChildHover: ${state?.isHovering}'),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

        final gesture =
            await tester.createGesture(kind: PointerDeviceKind.mouse);
        await gesture.addPointer(location: Offset.zero);
        addTearDown(gesture.removePointer);

        // Move to Child
        await gesture.moveTo(tester.getCenter(find.text('ChildHover: false')));
        await tester.pump();

        // Child should hover
        expect(find.text('ChildHover: true'), findsOneWidget);
      });
    });

    // -------------------------------------------------------------------------
    // 7. Regression Tests
    // -------------------------------------------------------------------------
    group('Regression Tests', () {
      testWidgets(
          'updates hover state synchronously without post-frame callback',
          (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WAnchor(
              child: AnchorStateReader(
                builder: (context, state) =>
                    Text('Hover: ${state?.isHovering}'),
              ),
            ),
          ),
        );

        final gesture =
            await tester.createGesture(kind: PointerDeviceKind.mouse);
        await gesture.addPointer(location: Offset.zero);
        addTearDown(gesture.removePointer);

        await gesture.moveTo(tester.getCenter(find.text('Hover: false')));

        // Sync update - pump() should be enough
        await tester.pump();
        expect(find.text('Hover: true'), findsOneWidget);
      });

      testWidgets('rapid enter-exit does not get stuck (race condition fix)',
          (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WAnchor(
              child: AnchorStateReader(
                builder: (context, state) =>
                    Text('Hover: ${state?.isHovering}'),
              ),
            ),
          ),
        );

        final gesture =
            await tester.createGesture(kind: PointerDeviceKind.mouse);
        await gesture.addPointer(location: Offset.zero);
        addTearDown(gesture.removePointer);

        // Enter
        await gesture.moveTo(tester.getCenter(find.text('Hover: false')));
        // Exit immediately (simulate rapid movement)
        await gesture.moveTo(Offset.zero);

        await tester.pump();

        expect(find.text('Hover: false'), findsOneWidget);
      });
    });

    // -------------------------------------------------------------------------
    // 4. Accessibility / Semantics
    //
    // These tests lock the contract that Step 1 of plan ai-test-v2 introduces:
    // WAnchor must emit a `Semantics(button: true, label: <child text>, ...)`
    // node so Playwright `getByRole('button', { name: ... })` resolves on the
    // Flutter web semantics tree. The contract is asserted at the Flutter
    // SemanticsNode level; the Flutter engine deterministically maps that to
    // `<flt-semantics role="button">label</flt-semantics>` in the DOM (see
    // `.ac/plans/ai-test-v2/research/librarian-semantics-deep-dive.md` ARIA
    // mapping table).
    // -------------------------------------------------------------------------
    group('Semantics', () {
      setUp(() {
        WindParser.clearCache();
      });

      testWidgets('semanticLabel does not double the label when child has text',
          (tester) async {
        // Branch: semanticLabel != null with a visible Text child. The label
        // must be the explicit semanticLabel exactly once, never the doubled
        // "Save\nSave" produced by merging the explicit label with the child
        // text. Activation must still fire because onTap is lifted onto the
        // Semantics node alongside excludeSemantics: true.
        var tapped = false;
        await tester.pumpWidget(
          wrapWithTheme(
            WAnchor(
              onTap: () => tapped = true,
              semanticLabel: 'Save',
              child: const Text('Save'),
            ),
          ),
        );

        final SemanticsNode node = tester.getSemantics(find.byType(WAnchor));
        expect(node.flagsCollection.isButton, isTrue);
        expect(node.flagsCollection.isEnabled, Tristate.isTrue);
        expect(node.label, 'Save');
        expect(
          node.getSemanticsData().hasAction(SemanticsAction.tap),
          isTrue,
        );

        await tester.tap(find.byType(WAnchor));
        await tester.pump();
        expect(tapped, isTrue);
      });

      testWidgets(
          'disabled anchor with semanticLabel announces disabled and has no tap action',
          (tester) async {
        // Branch: semanticLabel != null AND isDisabled. The node keeps the
        // explicit label but must announce as disabled and expose no tap
        // SemanticsAction, since onTap is null-gated when disabled.
        await tester.pumpWidget(
          wrapWithTheme(
            const WAnchor(
              isDisabled: true,
              onTap: null,
              semanticLabel: 'Save',
              child: Text('Save'),
            ),
          ),
        );

        final SemanticsNode node = tester.getSemantics(find.byType(WAnchor));
        expect(node.flagsCollection.isButton, isTrue);
        expect(node.flagsCollection.isEnabled, Tristate.isFalse);
        expect(node.label, 'Save');
        expect(
          node.getSemanticsData().hasAction(SemanticsAction.tap),
          isFalse,
        );
      });

      testWidgets('label resolves from child text when semanticLabel is null',
          (tester) async {
        // Branch: semanticLabel == null keeps the MergeSemantics path so the
        // descendant Text merges in as the accessible name.
        await tester.pumpWidget(
          wrapWithTheme(
            WAnchor(
              onTap: () {},
              child: const Text('Continue'),
            ),
          ),
        );

        final SemanticsNode node = tester.getSemantics(find.byType(WAnchor));
        expect(node.flagsCollection.isButton, isTrue);
        expect(node.label, 'Continue');
      });

      testWidgets('emits button role with label resolved from child text',
          (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WAnchor(
              onTap: () {},
              child: const Text('Sign in'),
            ),
          ),
        );

        final SemanticsNode node = tester.getSemantics(find.byType(WAnchor));
        expect(node.flagsCollection.isButton, isTrue);
        expect(node.flagsCollection.isEnabled, Tristate.isTrue);
        expect(node.label, 'Sign in');
      });

      testWidgets('reports disabled state when isDisabled is true',
          (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WAnchor(
              onTap: () {},
              isDisabled: true,
              child: const Text('Submit'),
            ),
          ),
        );

        final SemanticsNode node = tester.getSemantics(find.byType(WAnchor));
        expect(node.flagsCollection.isButton, isTrue);
        expect(node.flagsCollection.isEnabled, Tristate.isFalse);
        expect(node.label, 'Submit');
      });

      testWidgets(
          'concatenates multiple Text descendants into single-line label',
          (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WAnchor(
              onTap: () {},
              child: const Row(
                children: [
                  Text('Save'),
                  Text(' '),
                  Text('Changes'),
                ],
              ),
            ),
          ),
        );

        final SemanticsNode node = tester.getSemantics(find.byType(WAnchor));
        expect(node.label, contains('Save'));
        expect(node.label, contains('Changes'));
      });

      testWidgets(
          'emits button without label when child has no Text descendants',
          (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WAnchor(
              onTap: () {},
              child: const Icon(Icons.close),
            ),
          ),
        );

        final SemanticsNode node = tester.getSemantics(find.byType(WAnchor));
        expect(node.flagsCollection.isButton, isTrue);
      });
    });
  });
}
