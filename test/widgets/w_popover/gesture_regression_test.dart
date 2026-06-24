import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Wraps a widget in a [MaterialApp] + [WindTheme] for pumping.
Widget wrapWithTheme(Widget child) {
  return MaterialApp(
    home: WindTheme(
      data: WindThemeData(),
      child: Scaffold(body: child),
    ),
  );
}

/// Builds a WPopover whose trigger is an interactive [WButton] (the trigger
/// owns its own [onTap] and therefore competes in the gesture arena).
Widget _buttonTriggerPopover() {
  return WPopover(
    triggerBuilder: (context, isOpen, isHovering) => WButton(
      onTap: () {},
      className: 'bg-purple-600 text-white px-4 py-2 rounded-lg',
      child: const WText('Trigger', className: 'text-white'),
    ),
    contentBuilder: (context, close) => WDiv(
      className: 'flex flex-col',
      children: [
        WAnchor(
          onTap: () {},
          child: const SizedBox(height: 40, child: Text('Content Item')),
        ),
      ],
    ),
  );
}

/// Builds a WPopover whose trigger is a non-interactive [WDiv] (no own gesture
/// handler; the popover's own gesture must drive opening).
Widget _divTriggerPopover() {
  return WPopover(
    triggerBuilder: (context, isOpen, isHovering) => WDiv(
      className: 'px-4 py-2 rounded-lg bg-slate-100 cursor-pointer',
      child: const WText('Trigger', className: 'font-medium'),
    ),
    contentBuilder: (context, close) => WDiv(
      className: 'flex flex-col',
      children: [
        WAnchor(
          onTap: () {},
          child: const SizedBox(height: 40, child: Text('Content Item')),
        ),
      ],
    ),
  );
}

void main() {
  setUp(() {
    // Parser cache persists between tests; clearing avoids false positives.
    WindParser.clearCache();
  });

  /// The four-behavior regression set runs identically for every trigger type.
  void regressionSet(String label, Widget Function() build) {
    group('WPopover gesture regression ($label trigger)', () {
      testWidgets('tap opens the popover', (tester) async {
        await tester.pumpWidget(wrapWithTheme(Center(child: build())));

        expect(find.text('Content Item'), findsNothing);

        await tester.tap(find.text('Trigger'));
        await tester.pumpAndSettle();

        expect(find.text('Content Item'), findsOneWidget);
      });

      testWidgets('stays open while tapping a content item', (tester) async {
        await tester.pumpWidget(wrapWithTheme(Center(child: build())));

        await tester.tap(find.text('Trigger'));
        await tester.pumpAndSettle();
        expect(find.text('Content Item'), findsOneWidget);

        // Tapping inside the content must not dismiss the popover.
        await tester.tap(find.text('Content Item'));
        await tester.pumpAndSettle();

        expect(find.text('Content Item'), findsOneWidget);
      });

      testWidgets('genuine outside tap closes it', (tester) async {
        await tester.pumpWidget(wrapWithTheme(Center(child: build())));

        await tester.tap(find.text('Trigger'));
        await tester.pumpAndSettle();
        expect(find.text('Content Item'), findsOneWidget);

        // A separate, later tap far from the trigger and content dismisses.
        await tester.tapAt(const Offset(5, 5));
        await tester.pumpAndSettle();

        expect(find.text('Content Item'), findsNothing);
      });

      testWidgets('re-tapping the trigger while open toggles it closed',
          (tester) async {
        await tester.pumpWidget(wrapWithTheme(Center(child: build())));

        await tester.tap(find.text('Trigger'));
        await tester.pumpAndSettle();
        expect(find.text('Content Item'), findsOneWidget);

        await tester.tap(find.text('Trigger'));
        await tester.pumpAndSettle();

        expect(find.text('Content Item'), findsNothing);
      });
    });
  }

  regressionSet('WButton', _buttonTriggerPopover);
  regressionSet('WDiv', _divTriggerPopover);

  group('WPopover trigger onTap contract', () {
    // Pins the documented co-fire contract (see doc/widgets/w-popover.md
    // "Event Handling"): with enableTriggerOnTap true, an interactive trigger
    // that owns its own onTap fires BOTH its callback and the popover toggle on
    // the same tap. The popover opens on pointer-down (Listener), the trigger's
    // own onTap completes on pointer-up. A consumer that does not want the
    // co-fire uses a non-interactive WDiv trigger or an empty/null onTap.
    testWidgets('interactive trigger opens the popover AND co-fires its onTap',
        (tester) async {
      int triggerTaps = 0;
      await tester.pumpWidget(
        wrapWithTheme(
          Center(
            child: WPopover(
              triggerBuilder: (context, isOpen, isHovering) => WButton(
                onTap: () => triggerTaps++,
                className: 'bg-purple-600 text-white px-4 py-2 rounded-lg',
                child: const WText('Trigger', className: 'text-white'),
              ),
              contentBuilder: (context, close) => const SizedBox(
                height: 40,
                child: Text('Content Item'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Trigger'));
      await tester.pumpAndSettle();

      // The Defect A guarantee: an interactive trigger still opens the popover.
      expect(find.text('Content Item'), findsOneWidget);
      // The documented co-fire: the trigger's own onTap also ran exactly once.
      expect(triggerTaps, 1);
    });
  });

  group('WPopover controller-driven open', () {
    // Defect B guard must not eat a genuine outside tap on a controller-opened
    // popover. open() arms the one-shot suppress flag and disarms it one frame
    // later; a later, separate outside tap on a subsequent frame still closes.
    testWidgets('a later outside tap still closes a controller-opened popover',
        (tester) async {
      final controller = PopoverController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        wrapWithTheme(
          Center(
            child: WPopover(
              controller: controller,
              enableTriggerOnTap: false,
              triggerBuilder: (context, isOpen, isHovering) => const WDiv(
                className: 'px-4 py-2 rounded-lg bg-slate-100',
                child: WText('Trigger'),
              ),
              contentBuilder: (context, close) => const SizedBox(
                height: 40,
                child: Text('Content Item'),
              ),
            ),
          ),
        ),
      );

      controller.show();
      await tester.pumpAndSettle();
      expect(find.text('Content Item'), findsOneWidget);

      await tester.tapAt(const Offset(5, 5));
      await tester.pumpAndSettle();

      expect(find.text('Content Item'), findsNothing);
    });
  });

  group('WPopover trigger accessibility', () {
    // The trigger toggles on raw pointer events (to bypass the gesture arena),
    // which is invisible to assistive tech. A Semantics tap action must keep
    // the trigger reachable by screen readers and keyboard activation.
    testWidgets('semantic tap action opens the popover (assistive-tech path)',
        (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        wrapWithTheme(
          Center(
            child: WPopover(
              triggerBuilder: (context, isOpen, isHovering) => const WDiv(
                className: 'px-4 py-2 rounded-lg bg-slate-100',
                child: WText('Trigger'),
              ),
              contentBuilder: (context, close) => const SizedBox(
                height: 40,
                child: Text('Content Item'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Content Item'), findsNothing);

      final node = tester.getSemantics(find.text('Trigger'));
      expect(node.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);

      node.owner!.performAction(node.id, SemanticsAction.tap);
      await tester.pumpAndSettle();

      expect(find.text('Content Item'), findsOneWidget);
      handle.dispose();
    });

    // A secondary (right) button press must not toggle the popover; only the
    // primary button does.
    testWidgets('a secondary (right) button press does not open the popover',
        (tester) async {
      await tester
          .pumpWidget(wrapWithTheme(Center(child: _divTriggerPopover())));

      expect(find.text('Content Item'), findsNothing);

      final gesture = await tester.startGesture(
        tester.getCenter(find.text('Trigger')),
        buttons: kSecondaryButton,
        kind: PointerDeviceKind.mouse,
      );
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();

      expect(find.text('Content Item'), findsNothing);
    });
  });
}
