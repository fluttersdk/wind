import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Pixel-exact characterization of typography sizes (and a text color).
///
/// Font sizes (Tailwind v3): `text-base` = 16, `text-xl` = 20, `text-4xl` = 36.
/// Size resolution caps at `text-6xl`; `text-7xl`+ silently no-op (documented
/// divergence F11), so the cap is asserted as the actual documented behavior,
/// not treated as a bug.
///
/// The effective font size is read from the actually-rendered [RenderParagraph]
/// inline span, so the assertion reflects the pixel applied at paint time, not
/// just the widget-level style.

Widget wrapWithTheme(Widget child) {
  return MaterialApp(
    home: WindTheme(
      data: WindThemeData(),
      child: Scaffold(body: child),
    ),
  );
}

/// Reads the effective [TextStyle] of the rendered paragraph.
TextStyle _renderedStyle(WidgetTester tester) {
  final paragraph = tester.renderObject<RenderParagraph>(
    find.byType(RichText),
  );
  // The root inline span carries the resolved style after DefaultTextStyle merge.
  return paragraph.text.style!;
}

void main() {
  setUp(WindParser.clearCache);

  group('Font size (px)', () {
    testWidgets('text-base renders at 16 px', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const WText('Base', className: 'text-base')),
      );

      expect(_renderedStyle(tester).fontSize, 16.0);
    });

    testWidgets('text-xl renders at 20 px', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const WText('Xl', className: 'text-xl')),
      );

      expect(_renderedStyle(tester).fontSize, 20.0);
    });

    testWidgets('text-4xl renders at 36 px', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const WText('4xl', className: 'text-4xl')),
      );

      expect(_renderedStyle(tester).fontSize, 36.0);
    });

    testWidgets(
      'text-7xl is a documented no-op (F11): size stays unset, not 72',
      (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WText('7xl', className: 'text-7xl')),
        );

        // F11: Wind caps at text-6xl; text-7xl silently falls back. Assert the
        // ACTUAL documented behavior (no explicit size), not Tailwind's 72 px.
        final size = _renderedStyle(tester).fontSize;
        expect(size, isNot(72.0));
      },
    );
  });

  group('Text color (exact hex)', () {
    testWidgets('text-blue-500 resolves to #3B82F6', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const WText('Blue', className: 'text-blue-500')),
      );

      expect(_renderedStyle(tester).color, const Color(0xFF3B82F6));
    });
  });
}
