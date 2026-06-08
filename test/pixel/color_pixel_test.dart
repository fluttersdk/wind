import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Pixel-exact characterization of background colors, incl. dark-mode resolution.
///
/// `bg-blue-500` = #3B82F6 (Tailwind v3). A `dark:bg-*` token resolves only
/// when the theme brightness is dark; per documented divergence F05 a
/// declarative `brightness: Brightness.dark` is overridden by `syncWithSystem`
/// unless `syncWithSystem: false` is set, so the dark cases pin
/// `syncWithSystem: false`.
///
/// Color is read from the actually-rendered [RenderDecoratedBox.decoration]
/// (the render layer the plan mandates for exact color), not from the parsed
/// [WindStyle].

Widget wrapWithTheme(Widget child) {
  return MaterialApp(
    home: WindTheme(
      data: WindThemeData(),
      child: Scaffold(body: child),
    ),
  );
}

/// Wraps [child] under a dark theme with system sync disabled, so a declarative
/// `brightness: Brightness.dark` actually drives `dark:` resolution (F05).
Widget wrapWithDarkTheme(Widget child) {
  return MaterialApp(
    home: WindTheme(
      data: WindThemeData(
        brightness: Brightness.dark,
        syncWithSystem: false,
      ),
      child: Scaffold(body: child),
    ),
  );
}

/// Reads the `BoxDecoration` from the first `RenderDecoratedBox` the WDiv emits.
BoxDecoration _decorationOf(WidgetTester tester) {
  final render = tester.renderObject<RenderDecoratedBox>(
    find.byType(DecoratedBox).first,
  );
  return render.decoration as BoxDecoration;
}

void main() {
  setUp(WindParser.clearCache);

  group('Background color (exact hex)', () {
    testWidgets('bg-blue-500 resolves to #3B82F6', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const WDiv(className: 'bg-blue-500')),
      );

      expect(_decorationOf(tester).color, const Color(0xFF3B82F6));
    });

    testWidgets('bg-white resolves to opaque white', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const WDiv(className: 'bg-white')),
      );

      expect(_decorationOf(tester).color, const Color(0xFFFFFFFF));
    });
  });

  group('Dark-mode color resolution (F05: syncWithSystem false)', () {
    testWidgets(
      'light theme keeps the base bg, ignores dark: peer',
      (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDiv(className: 'bg-white dark:bg-blue-500'),
          ),
        );

        // Light brightness: the dark: peer stays inert.
        expect(_decorationOf(tester).color, const Color(0xFFFFFFFF));
      },
    );

    testWidgets(
      'dark theme applies dark:bg-blue-500 = #3B82F6',
      (tester) async {
        await tester.pumpWidget(
          wrapWithDarkTheme(
            const WDiv(className: 'bg-white dark:bg-blue-500'),
          ),
        );

        // Dark brightness with syncWithSystem:false: dark: peer wins.
        expect(_decorationOf(tester).color, const Color(0xFF3B82F6));
      },
    );
  });
}
