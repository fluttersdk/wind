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

/// Sets the logical viewport width and pairs the reset via [addTearDown].
void setViewportWidth(WidgetTester tester, double width) {
  tester.view.physicalSize = Size(width, 900);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}

void main() {
  // Parser cache persists between tests; clearing avoids false-positive passes.
  setUp(WindParser.clearCache);

  group('RESPONSIVE breakpoint characterization', () {
    // Default screens: sm=640, md=768, lg=1024, xl=1280, 2xl=1536.

    testWidgets('md:flex hides below md and shows at/above md', (tester) async {
      // Below md (500 -> base): hidden md:flex => not visible.
      setViewportWidth(tester, 500);

      await tester.pumpWidget(
        wrapWithTheme(
          const WDiv(
            className: 'hidden md:flex',
            children: [Text('Responsive Item')],
          ),
        ),
      );

      expect(find.text('Responsive Item'), findsNothing);

      // At md (800 -> md): becomes visible and lays out as a Row.
      tester.view.physicalSize = const Size(800, 900);
      await tester.pumpAndSettle();

      expect(find.text('Responsive Item'), findsOneWidget);
      expect(find.byType(Row), findsOneWidget);
    });

    testWidgets('lg: prefix gates a style above the lg breakpoint',
        (tester) async {
      const targetKey = ValueKey('lg-target');

      // 800 -> md (below lg): lg:bg-gray-100 must NOT apply, base bg-white wins.
      setViewportWidth(tester, 800);

      await tester.pumpWidget(
        wrapWithTheme(
          const WDiv(
            key: targetKey,
            className: 'p-4 bg-white lg:bg-gray-100',
            child: Text('LG gate'),
          ),
        ),
      );

      expect(
        _bgColor(tester, find.byKey(targetKey)),
        const Color(0xFFFFFFFF),
      );

      // 1100 -> lg: lg:bg-gray-100 applies.
      tester.view.physicalSize = const Size(1100, 900);
      await tester.pumpAndSettle();

      expect(
        _bgColor(tester, find.byKey(targetKey)),
        const Color(0xfff3f4f6), // gray-100
      );
    });

    testWidgets('breakpoint ladder resolves base/md/lg/xl/2xl in WindContext',
        (tester) async {
      // Assert the computed activeBreakpoint at each bracketed width using the
      // public WindContext.build resolver, which is the single source of truth
      // the parser consumes for responsive gating.
      final cases = <double, String>{
        500: 'base',
        800: 'md',
        1100: 'lg',
        1300: 'xl',
        1600: '2xl',
      };

      for (final entry in cases.entries) {
        setViewportWidth(tester, entry.key);
        late String resolved;

        await tester.pumpWidget(
          wrapWithTheme(
            Builder(
              builder: (context) {
                resolved = WindContext.build(context).activeBreakpoint;
                return const SizedBox.shrink();
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(
          resolved,
          entry.value,
          reason: 'width ${entry.key} should resolve to ${entry.value}',
        );
      }
    });
  });
}

/// Reads the resolved background color from the first [DecoratedBox] beneath
/// [finder].
Color? _bgColor(WidgetTester tester, Finder finder) {
  final boxes = tester.widgetList<DecoratedBox>(
    find.descendant(of: finder, matching: find.byType(DecoratedBox)),
  );
  for (final box in boxes) {
    final decoration = box.decoration;
    if (decoration is BoxDecoration && decoration.color != null) {
      return decoration.color;
    }
  }
  return null;
}
