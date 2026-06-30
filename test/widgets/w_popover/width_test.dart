import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

Widget wrapWithTheme(Widget child) => MaterialApp(
      home: WindTheme(
        data: WindThemeData(),
        child: Scaffold(body: Center(child: child)),
      ),
    );

WPopover _popover({double? width, double? maxWidth, String? className}) {
  return WPopover(
    width: width,
    maxWidth: maxWidth,
    className: className,
    triggerBuilder: (context, isOpen, isHovering) => const WDiv(
      className: 'px-4 py-2 bg-slate-100',
      child: WText('Trigger'),
    ),
    contentBuilder: (context, close) => const WDiv(
      className: 'flex flex-col',
      child: WText('PopoverBody'),
    ),
  );
}

/// The overlay [ConstrainedBox] is the one carrying the popover's maxHeight
/// (400); a `max-w-*` token on the content WDiv produces its own inner
/// ConstrainedBox (maxHeight infinity), so select by maxHeight to avoid it.
BoxConstraints _overlayConstraints(WidgetTester tester) {
  final box = tester
      .widgetList<ConstrainedBox>(
        find.ancestor(
          of: find.text('PopoverBody'),
          matching: find.byType(ConstrainedBox),
        ),
      )
      .firstWhere((b) => b.constraints.maxHeight == 400);
  return box.constraints;
}

void main() {
  setUp(WindParser.clearCache);

  Future<void> open(WidgetTester tester, WPopover popover) async {
    await tester.pumpWidget(wrapWithTheme(popover));
    await tester.tap(find.text('Trigger'));
    await tester.pumpAndSettle();
    expect(find.text('PopoverBody'), findsOneWidget);
  }

  group('WPopover width (issue #127)', () {
    testWidgets('defaults maxWidth to the screen width (no unbounded stretch)',
        (tester) async {
      await open(tester, _popover());
      // Default test surface is 800px wide.
      expect(_overlayConstraints(tester).maxWidth, 800);
    });

    testWidgets('honors an explicit maxWidth', (tester) async {
      await open(tester, _popover(maxWidth: 300));
      final c = _overlayConstraints(tester);
      expect(c.maxWidth, 300);
    });

    testWidgets('pins a fixed width via the width prop', (tester) async {
      await open(tester, _popover(width: 250));
      final c = _overlayConstraints(tester);
      expect(c.minWidth, 250);
      expect(c.maxWidth, 250);
    });

    testWidgets('a w-* token in className pins a fixed width', (tester) async {
      await open(
        tester,
        _popover(className: 'w-64 bg-white dark:bg-gray-800'),
      );
      final c = _overlayConstraints(tester);
      // w-64 -> 64 * 4 = 256
      expect(c.minWidth, 256);
      expect(c.maxWidth, 256);
    });

    testWidgets('a max-w-* token in className bounds the width',
        (tester) async {
      await open(
        tester,
        _popover(className: 'max-w-sm bg-white dark:bg-gray-800'),
      );
      // max-w-sm -> 384
      expect(_overlayConstraints(tester).maxWidth, 384);
    });

    testWidgets('the width prop overrides a className max-w-*', (tester) async {
      await open(
        tester,
        _popover(width: 200, className: 'max-w-sm bg-white dark:bg-gray-800'),
      );
      final c = _overlayConstraints(tester);
      expect(c.minWidth, 200);
      expect(c.maxWidth, 200);
    });
  });
}
