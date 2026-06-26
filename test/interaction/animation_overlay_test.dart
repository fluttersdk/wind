import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Wraps [child] in a MaterialApp + WindTheme + Scaffold so className-styled
/// widgets resolve their styling context.
Widget wrapWithTheme(Widget child) {
  return MaterialApp(
    home: WindTheme(
      data: WindThemeData(),
      child: Scaffold(body: child),
    ),
  );
}

void main() {
  // Parser cache persists between tests; clearing avoids false-positive passes.
  setUp(WindParser.clearCache);

  group('ANIMATION characterization', () {
    // NEVER pumpAndSettle here: animate-* loops forever and would hang.

    testWidgets('animate-spin renders a RotationTransition', (tester) async {
      const key = ValueKey('spin');
      await tester.pumpWidget(
        wrapWithTheme(
          const WDiv(
            key: key,
            className: 'animate-spin w-8 h-8 bg-blue-500',
            child: Text('S'),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 16));

      expect(
        find.descendant(
          of: find.byKey(key),
          matching: find.byType(RotationTransition),
        ),
        findsOneWidget,
      );
    });

    testWidgets('animate-pulse renders a FadeTransition', (tester) async {
      const key = ValueKey('pulse');
      await tester.pumpWidget(
        wrapWithTheme(
          const WDiv(
            key: key,
            className: 'animate-pulse w-8 h-8 bg-blue-500',
            child: Text('P'),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 16));

      expect(
        find.descendant(
          of: find.byKey(key),
          matching: find.byType(FadeTransition),
        ),
        findsOneWidget,
      );
    });

    testWidgets('animate-ping renders an AnimatedBuilder (Transform path)',
        (tester) async {
      const key = ValueKey('ping');
      await tester.pumpWidget(
        wrapWithTheme(
          const WDiv(
            key: key,
            className: 'animate-ping w-8 h-8 bg-blue-500',
            child: Text('I'),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 16));

      // ping animates scale + opacity via an AnimatedBuilder that emits a
      // Transform every frame.
      expect(
        find.descendant(
          of: find.byKey(key),
          matching: find.byType(AnimatedBuilder),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byKey(key),
          matching: find.byType(Transform),
        ),
        findsWidgets,
      );
    });

    testWidgets('animate-bounce renders an AnimatedBuilder (Transform path)',
        (tester) async {
      const key = ValueKey('bounce');
      await tester.pumpWidget(
        wrapWithTheme(
          const WDiv(
            key: key,
            className: 'animate-bounce w-8 h-8 bg-blue-500',
            child: Text('B'),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 16));

      expect(
        find.descendant(
          of: find.byKey(key),
          matching: find.byType(AnimatedBuilder),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byKey(key),
          matching: find.byType(Transform),
        ),
        findsWidgets,
      );
    });
  });

  group('OVERLAY characterization', () {
    testWidgets('WPopover opens content and closes on the close callback',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          WPopover(
            className: 'w-48 bg-white rounded-lg',
            triggerBuilder: (context, isOpen, isHovering) =>
                const Text('Open menu'),
            contentBuilder: (context, close) => WButton(
              onTap: close,
              child: const Text('Close menu'),
            ),
          ),
        ),
      );

      // Closed: content is not present.
      expect(find.text('Close menu'), findsNothing);

      // Open via the trigger.
      await tester.tap(find.text('Open menu'));
      await tester.pumpAndSettle();
      expect(find.text('Close menu'), findsOneWidget);

      // Close via the content button's close callback.
      await tester.tap(find.text('Close menu'));
      await tester.pumpAndSettle();
      expect(find.text('Close menu'), findsNothing);
    });

    testWidgets('WPopover closes on outside tap', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          Column(
            children: [
              WPopover(
                className: 'w-48 bg-white rounded-lg',
                triggerBuilder: (context, isOpen, isHovering) =>
                    const Text('Open popover'),
                contentBuilder: (context, close) => const Text('Panel body'),
              ),
              const SizedBox(height: 200, child: Text('Outside area')),
            ],
          ),
        ),
      );

      await tester.tap(find.text('Open popover'));
      await tester.pumpAndSettle();
      expect(find.text('Panel body'), findsOneWidget);

      // Tap outside the overlay; TapRegion.onTapOutside closes it.
      await tester.tapAt(tester.getCenter(find.text('Outside area')));
      await tester.pumpAndSettle();
      expect(find.text('Panel body'), findsNothing);
    });

    testWidgets('WSelect opens the option list and closes after selecting',
        (tester) async {
      String? selected;

      await tester.pumpWidget(
        wrapWithTheme(
          WSelect<String>(
            value: null,
            placeholder: 'Choose',
            options: const [
              SelectOption(value: 'x', label: 'Xenon'),
              SelectOption(value: 'y', label: 'Yttrium'),
            ],
            onChange: (v) => selected = v,
          ),
        ),
      );

      // Closed: options not shown.
      expect(find.text('Yttrium'), findsNothing);

      // Open. The overlay mount is deferred one frame (so the opening tap's
      // pointer-up cannot self-close it), so settle rather than single-pump.
      await tester.tap(find.text('Choose'));
      await tester.pumpAndSettle();
      expect(find.text('Yttrium'), findsOneWidget);

      // Select an option -> single-select closes the menu.
      await tester.tap(find.text('Yttrium'));
      await tester.pumpAndSettle();

      expect(selected, 'y');
      expect(find.text('Yttrium'), findsNothing);
    });
  });
}
