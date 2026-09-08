import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';
// import 'package:fluttersdk_wind/src/state/wind_anchor_state_provider.dart';

class TestWidget extends StatelessWidget {
  const TestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final state = WindAnchorStateProvider.of(context);
    return Text(
      'isHovering: ${state?.isHovering}, isFocused: ${state?.isFocused}, isDisabled: ${state?.isDisabled}',
    );
  }
}

void main() {
  testWidgets(
    'WDiv inside WAnchor can access the isHovering and isFocused state',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: WAnchor(child: TestWidget())),
      );

      // Initial state
      expect(
        find.text('isHovering: false, isFocused: false, isDisabled: false'),
        findsOneWidget,
      );

      // Simulate hover
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      await gesture.moveTo(tester.getCenter(find.byType(TestWidget)));
      await tester.pumpAndSettle();

      expect(
        find.text('isHovering: true, isFocused: false, isDisabled: false'),
        findsOneWidget,
      );

      // Simulate focus
      final focusFinder = find.descendant(
        of: find.byType(WAnchor),
        matching: find.byType(Focus),
      );
      final focusNode = tester.widget<Focus>(focusFinder).focusNode!;
      focusNode.requestFocus();
      await tester.pumpAndSettle();

      expect(
        find.text('isHovering: true, isFocused: true, isDisabled: false'),
        findsOneWidget,
      );
    },
  );

  testWidgets('WDiv outside WAnchor cannot access the state', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: TestWidget()));

    expect(
      find.text('isHovering: null, isFocused: null, isDisabled: null'),
      findsOneWidget,
    );
  });

  testWidgets('WAnchor does not react to hover when disabled', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: WAnchor(isDisabled: true, child: TestWidget())),
    );

    // Initial state
    expect(
      find.text('isHovering: false, isFocused: false, isDisabled: true'),
      findsOneWidget,
    );

    // Simulate hover
    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
    await gesture.moveTo(tester.getCenter(find.byType(TestWidget)));
    await tester.pumpAndSettle();

    // State should not change
    expect(
      find.text('isHovering: false, isFocused: false, isDisabled: true'),
      findsOneWidget,
    );
  });

  testWidgets('WAnchor does not react to focus when disabled', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: WAnchor(isDisabled: true, child: TestWidget())),
    );

    // Initial state
    expect(
      find.text('isHovering: false, isFocused: false, isDisabled: true'),
      findsOneWidget,
    );

    // Try to focus
    final focusFinder = find.descendant(
      of: find.byType(WAnchor),
      matching: find.byType(Focus),
    );
    final focusNode = tester.widget<Focus>(focusFinder).focusNode!;
    focusNode.requestFocus();
    await tester.pumpAndSettle();

    // State should not change
    expect(
      find.text('isHovering: false, isFocused: false, isDisabled: true'),
      findsOneWidget,
    );
  });

  testWidgets('WAnchor callbacks are not called when disabled', (
    WidgetTester tester,
  ) async {
    bool tapped = false;
    bool longPressed = false;
    bool doubleTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: WAnchor(
          isDisabled: true,
          onTap: () => tapped = true,
          onLongPress: () => longPressed = true,
          onDoubleTap: () => doubleTapped = true,
          child: const TestWidget(),
        ),
      ),
    );

    await tester.tap(find.byType(TestWidget));
    await tester.longPress(find.byType(TestWidget));
    await tester.pump(const Duration(milliseconds: 300)); // for double tap
    await tester.tap(find.byType(TestWidget));
    await tester.pumpAndSettle();

    expect(tapped, isFalse);
    expect(longPressed, isFalse);
    expect(doubleTapped, isFalse);
  });
  group('WindAnchorState value semantics', () {
    test('hasPrimaryFocus takes part in equality and in the hash', () {
      // The `==` half is the load-bearing one.
      // `WindAnchorStateProvider.updateShouldNotify` compares two states with
      // `!=`, so a field left out of `==` means a change to it never reaches
      // the descendants that style on it.
      //
      // The hash assertion pins something narrower than it may look: that
      // `hasPrimaryFocus` reaches `hashCode` at all, since omitting it would
      // make exactly these two states hash equal. It does NOT say unequal
      // states never collide, and this `hashCode` cannot promise that: it XORs
      // four booleans, so any two states that differ by a permutation of their
      // true values hash the same. `==` is what keeps them apart; the hash only
      // decides how well they spread across buckets.
      const WindAnchorState within = WindAnchorState(
        isHovering: false,
        isFocused: true,
        isDisabled: false,
      );
      const WindAnchorState primary = WindAnchorState(
        isHovering: false,
        isFocused: true,
        hasPrimaryFocus: true,
        isDisabled: false,
      );

      expect(within, isNot(primary));
      expect(within.hashCode, isNot(primary.hashCode));
      expect(<WindAnchorState>{within, primary}.length, 2);
    });

    test('and defaults to false, so existing callers are unaffected', () {
      expect(WindAnchorState.none.hasPrimaryFocus, isFalse);
      expect(
        const WindAnchorState(
          isHovering: false,
          isFocused: false,
          isDisabled: false,
        ).hasPrimaryFocus,
        isFalse,
      );
    });
  });
}
