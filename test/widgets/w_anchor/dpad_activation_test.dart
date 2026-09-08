import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// What a keyboard and a television remote can reach.
///
/// Both arrive through the same door. `WidgetsApp` binds `enter`, `space`,
/// `numpadEnter`, `gameButtonA` and `select` to `ActivateIntent`, and `select`
/// is the D-pad centre key on Android TV, so an anchor that answers
/// `ActivateIntent` answers every one of them at once.
///
/// The second group is the half that is easy to miss. Activation is worth
/// nothing if the focus ring and the gesture live on different nodes, and
/// before this change they did: `WDiv` auto-wraps itself in a gestureless
/// `WAnchor` whenever its className carries `focus:`, so the ring belonged to a
/// descendant of the tappable node and lit only when the tappable node did not.
void main() {
  setUp(WindParser.clearCache);

  /// Pumps [child] under a real app, which is load-bearing here rather than
  /// boilerplate.
  ///
  /// `WidgetsApp` is what installs `defaultShortcuts`, the table that turns a
  /// key press into an [ActivateIntent]. Under a bare `Directionality` the key
  /// never becomes an intent and every activation assertion below fails while
  /// the implementation is correct.
  Future<void> pump(WidgetTester tester, Widget child) {
    return tester.pumpWidget(
      MaterialApp(
        home: WindTheme(
          data: WindThemeData(),
          child: Scaffold(body: Center(child: child)),
        ),
      ),
    );
  }

  /// Every focus node in the tree that traversal would stop on.
  List<FocusNode> traversalStops(WidgetTester tester) {
    return tester
        .widgetList<Focus>(find.byType(Focus))
        .map((Focus f) => f.focusNode)
        .whereType<FocusNode>()
        .where((FocusNode n) => n.canRequestFocus && !n.skipTraversal)
        .toList();
  }

  group('activation', () {
    for (final (String name, LogicalKeyboardKey key)
        in <(String, LogicalKeyboardKey)>[
      ('the D-pad centre', LogicalKeyboardKey.select),
      ('Enter', LogicalKeyboardKey.enter),
      ('the numeric keypad Enter', LogicalKeyboardKey.numpadEnter),
      ('Space', LogicalKeyboardKey.space),
      ('the gamepad A button', LogicalKeyboardKey.gameButtonA),
    ]) {
      testWidgets('$name activates a focused anchor', (tester) async {
        int taps = 0;

        await pump(
          tester,
          WAnchor(onTap: () => taps++, child: const WText('Play')),
        );

        traversalStops(tester).single.requestFocus();
        await tester.pump();

        await tester.sendKeyEvent(key);
        await tester.pump();

        expect(taps, 1);
      });
    }

    testWidgets('a disabled anchor stays inert', (tester) async {
      int taps = 0;

      await pump(
        tester,
        WAnchor(
          onTap: () => taps++,
          isDisabled: true,
          child: const WText('Play'),
        ),
      );

      // It is not a traversal stop either: `canRequestFocus` is already gated
      // on `isDisabled`. Force focus onto its node anyway, so the assertion
      // below is about the action map rather than about reachability.
      final FocusNode node = tester
          .widget<Focus>(
            find
                .descendant(
                  of: find.byType(WAnchor),
                  matching: find.byType(Focus),
                )
                .first,
          )
          .focusNode!;
      node.requestFocus();
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.select);
      await tester.pump();

      expect(taps, 0);
    });

    testWidgets('an anchor with no gesture swallows nothing', (tester) async {
      // The key has to keep travelling, or a styling-only wrapper around a real
      // control would eat that control's activation.
      int taps = 0;

      await pump(
        tester,
        WAnchor(
          onTap: () => taps++,
          child: const WDiv(
            className: 'p-2 focus:ring-2 focus:ring-blue-500',
            child: WText('Clear'),
          ),
        ),
      );

      traversalStops(tester).single.requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.select);
      await tester.pump();

      expect(taps, 1);
    });

    testWidgets('a long press has no key, and gains none', (tester) async {
      // `ActivateIntent` means "the primary action". There is no second key for
      // a secondary one, and inventing a binding here would diverge from every
      // Flutter button.
      int longPresses = 0;

      await pump(
        tester,
        WAnchor(
          onLongPress: () => longPresses++,
          child: const WText('Options'),
        ),
      );

      traversalStops(tester).single.requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.select);
      await tester.pump();

      expect(longPresses, 0);
    });
  });

  group('one control, one traversal stop', () {
    testWidgets('a ring-styled div inside an anchor adds no second stop', (
      tester,
    ) async {
      await pump(
        tester,
        WAnchor(
          onTap: () {},
          child: const WDiv(
            className: 'p-2 focus:ring-2 focus:ring-blue-500',
            child: WText('Clear'),
          ),
        ),
      );

      expect(traversalStops(tester).length, 1);
    });

    testWidgets('and the ring lights on the stop that activates', (
      tester,
    ) async {
      await pump(
        tester,
        WAnchor(
          onTap: () {},
          child: const WDiv(
            className: 'p-2 focus:ring-2 focus:ring-blue-500',
            child: WText('Clear'),
          ),
        ),
      );

      final FocusNode stop = traversalStops(tester).single;
      stop.requestFocus();
      await tester.pump();

      // Read through the state the styling layer actually consumes rather than
      // through a rendered colour: `WDiv` resolves `focus:` from the nearest
      // `WindAnchorStateProvider`, so that is where the answer has to be right.
      final BuildContext inner = tester.element(find.byType(WText));
      expect(WindAnchorStateProvider.of(inner)?.isFocused, isTrue);
    });

    testWidgets('a bare ring-styled div is still focusable on its own', (
      tester,
    ) async {
      // Nothing above it to inherit from, so it keeps the node it always had.
      // A div carrying `focus:` outside any anchor is how a consumer styles a
      // custom control, and removing its stop would make that control
      // unreachable.
      await pump(
        tester,
        const WDiv(
          className: 'p-2 focus:ring-2 focus:ring-blue-500',
          child: WText('Standalone'),
        ),
      );

      expect(traversalStops(tester).length, 1);
    });

    testWidgets('a focusable descendant still reports up through the wrapper', (
      tester,
    ) async {
      // The search-field shape: a ring-styled div wrapping a text input. This
      // one was never broken and must stay that way. `FocusNode.hasFocus`
      // covers descendants, so the wrapper reports focus while the input holds
      // it, and the ring is drawn around the field the user is typing in.
      await pump(
        tester,
        const WDiv(
          className: 'p-2 focus:ring-2 focus:ring-blue-500',
          child: WInput(placeholder: 'Search'),
        ),
      );

      await tester.tap(find.byType(WInput));
      await tester.pump();

      final BuildContext inner = tester.element(find.byType(WInput));
      expect(WindAnchorStateProvider.of(inner)?.isFocused, isTrue);
    });

    testWidgets('nested hover stays local to the div that is hovered', (
      tester,
    ) async {
      // Focus is inherited, hover is not, and the asymmetry is deliberate.
      // Focus has one holder in the whole tree; hover is a pointer position and
      // two siblings inside one anchor legitimately highlight independently.
      await pump(
        tester,
        WAnchor(
          onTap: () {},
          child: const WDiv(
            className: 'flex flex-row',
            children: <Widget>[
              WDiv(className: 'p-2 hover:bg-red-500', child: WText('Left')),
              WDiv(className: 'p-2 hover:bg-blue-500', child: WText('Right')),
            ],
          ),
        ),
      );

      final TestPointer pointer = TestPointer(1, PointerDeviceKind.mouse);
      await tester.sendEventToBinding(
        pointer.hover(tester.getCenter(find.text('Left'))),
      );
      await tester.pump();

      final BuildContext left = tester.element(find.text('Left'));
      final BuildContext right = tester.element(find.text('Right'));

      expect(WindAnchorStateProvider.of(left)?.isHovering, isTrue);
      expect(WindAnchorStateProvider.of(right)?.isHovering, isFalse);
    });

    testWidgets('a disabled anchor disables the div that styles it', (
      tester,
    ) async {
      // The same shadowing bug in a third state, fixed by the same inheritance.
      // Before this change the gestureless wrapper published `isDisabled:
      // false` over a disabled ancestor, so `disabled:` never fired on the
      // element carrying it.
      await pump(
        tester,
        WAnchor(
          onTap: () {},
          isDisabled: true,
          child: const WDiv(
            className: 'p-2 disabled:opacity-50 focus:ring-2',
            child: WText('Clear'),
          ),
        ),
      );

      final BuildContext inner = tester.element(find.byType(WText));
      expect(WindAnchorStateProvider.of(inner)?.isDisabled, isTrue);
    });
  });
}
