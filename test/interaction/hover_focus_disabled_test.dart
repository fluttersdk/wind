import 'package:flutter/gestures.dart';
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

/// Reads the resolved background color from the first [DecoratedBox] beneath
/// [finder]. WDiv emits a Container (a DecoratedBox under the hood) when a
/// background color is resolved.
Color? resolvedBackgroundColor(WidgetTester tester, Finder finder) {
  final decoratedBoxes = tester.widgetList<DecoratedBox>(
    find.descendant(of: finder, matching: find.byType(DecoratedBox)),
  );
  for (final box in decoratedBoxes) {
    final decoration = box.decoration;
    if (decoration is BoxDecoration && decoration.color != null) {
      return decoration.color;
    }
  }
  return null;
}

void main() {
  // Parser cache persists between tests; clearing avoids false-positive passes.
  setUp(WindParser.clearCache);

  group('HOVER characterization', () {
    testWidgets('hover:bg-* flips the resolved background color',
        (tester) async {
      const targetKey = ValueKey('hover-target');

      await tester.pumpWidget(
        wrapWithTheme(
          WAnchor(
            onTap: () {},
            child: const WDiv(
              key: targetKey,
              className: 'p-4 bg-white hover:bg-gray-100',
              child: Text('Hover me'),
            ),
          ),
        ),
      );

      // Base state: bg-white resolves.
      final Color? before = resolvedBackgroundColor(
        tester,
        find.byKey(targetKey),
      );
      expect(before, const Color(0xFFFFFFFF));

      // Move a mouse pointer over the target.
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await gesture.moveTo(tester.getCenter(find.byKey(targetKey)));

      // Double-pump: hover state propagates through setState + rebuild.
      await tester.pump();
      await tester.pump();

      final Color? after = resolvedBackgroundColor(
        tester,
        find.byKey(targetKey),
      );
      expect(after, const Color(0xfff3f4f6)); // gray-100
      expect(after, isNot(before));
    });
  });

  group('FOCUS characterization', () {
    testWidgets('focus:bg-* applies when the anchor gains focus',
        (tester) async {
      const targetKey = ValueKey('focus-target');

      await tester.pumpWidget(
        wrapWithTheme(
          WAnchor(
            onTap: () {},
            child: const WDiv(
              key: targetKey,
              className: 'p-4 bg-white focus:bg-gray-100',
              child: Text('Focus me'),
            ),
          ),
        ),
      );

      expect(
        resolvedBackgroundColor(tester, find.byKey(targetKey)),
        const Color(0xFFFFFFFF),
      );

      // Request focus on the Focus node WAnchor installs around its child.
      final focusFinder = find
          .ancestor(of: find.text('Focus me'), matching: find.byType(Focus))
          .first;
      final focusWidget = tester.widget<Focus>(focusFinder);
      focusWidget.focusNode!.requestFocus();
      await tester.pumpAndSettle();

      expect(
        resolvedBackgroundColor(tester, find.byKey(targetKey)),
        const Color(0xfff3f4f6), // gray-100
      );
    });
  });

  group('DISABLED characterization', () {
    testWidgets('disabled:bg-* applies and tap is suppressed', (tester) async {
      const targetKey = ValueKey('disabled-target');
      bool tapped = false;

      await tester.pumpWidget(
        wrapWithTheme(
          WAnchor(
            onTap: () => tapped = true,
            isDisabled: true,
            child: const WDiv(
              key: targetKey,
              className: 'p-4 bg-white disabled:bg-gray-100',
              child: Text('Disabled'),
            ),
          ),
        ),
      );

      // disabled: prefix resolves because WAnchor propagates isDisabled.
      expect(
        resolvedBackgroundColor(tester, find.byKey(targetKey)),
        const Color(0xfff3f4f6), // gray-100
      );

      await tester.tap(find.byKey(targetKey), warnIfMissed: false);
      await tester.pump();
      expect(tapped, isFalse);
    });

    testWidgets('disabled WButton suppresses hover state', (tester) async {
      // WButton wraps its content in a single (disabled) WAnchor; no inner
      // re-wrap occurs, so the disabled boundary owns the hover gating. This is
      // the realistic disabled-suppresses-hover contract (a single anchor).
      bool tapped = false;

      await tester.pumpWidget(
        wrapWithTheme(
          WButton(
            onTap: () => tapped = true,
            disabled: true,
            className: 'bg-white hover:bg-gray-100 px-4 py-2',
            child: const Text('Disabled hover'),
          ),
        ),
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await gesture.moveTo(tester.getCenter(find.byType(WButton)));
      await tester.pump();
      await tester.pump();

      // Hover is suppressed on a disabled anchor, so bg stays white.
      expect(
        resolvedBackgroundColor(tester, find.byType(WButton)),
        const Color(0xFFFFFFFF),
      );
      expect(tapped, isFalse);
    });
  });

  group('RESERVED active: prefix', () {
    testWidgets('active: resolves when the state is passed manually',
        (tester) async {
      const targetKey = ValueKey('active-target');

      // `active:` is reserved-not-wired: WAnchor does not auto-populate the
      // 'active' state. Passing it manually verifies the prefix resolves.
      await tester.pumpWidget(
        wrapWithTheme(
          const WDiv(
            key: targetKey,
            className: 'p-4 bg-white active:bg-gray-100',
            states: {'active'},
            child: Text('Active'),
          ),
        ),
      );

      expect(
        resolvedBackgroundColor(tester, find.byKey(targetKey)),
        const Color(0xfff3f4f6), // gray-100, active: applied
      );
    });
  });
}
