import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Pixel-exact characterization of border-radius, ring, and border widths.
///
/// Radius presets (Tailwind v3): `rounded-lg` = 8, `rounded-2xl` = 16. Border
/// widths: `border` (DEFAULT) = 1, `border-2` = 2, `border-4` = 4. Ring widths:
/// `ring` (DEFAULT) = 3, `ring-2` = 2, rendered as a spread-only [BoxShadow].
///
/// Each value is read from the actually-rendered [RenderDecoratedBox.decoration]
/// (the render layer the plan mandates for exact decoration), not from the
/// parsed [WindStyle]. The first `RenderDecoratedBox` under the WDiv is the
/// Container's decoration box.

Widget wrapWithTheme(Widget child) {
  return MaterialApp(
    home: WindTheme(
      data: WindThemeData(),
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

  group('Border radius (px presets)', () {
    testWidgets('rounded-lg = 8 px on every corner', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const WDiv(className: 'rounded-lg bg-white')),
      );

      final radius = _decorationOf(tester).borderRadius as BorderRadius;
      expect(radius, BorderRadius.circular(8.0));
    });

    testWidgets('rounded-2xl = 16 px on every corner', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const WDiv(className: 'rounded-2xl bg-white')),
      );

      final radius = _decorationOf(tester).borderRadius as BorderRadius;
      expect(radius, BorderRadius.circular(16.0));
    });
  });

  group('Border widths (px)', () {
    testWidgets('border (DEFAULT) = 1 px', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const WDiv(className: 'border border-gray-300')),
      );

      final border = _decorationOf(tester).border as Border;
      expect(border.top.width, 1.0);
      expect(border.bottom.width, 1.0);
      expect(border.left.width, 1.0);
      expect(border.right.width, 1.0);
    });

    testWidgets('border-2 = 2 px', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const WDiv(className: 'border-2 border-gray-300')),
      );

      final border = _decorationOf(tester).border as Border;
      expect(border.top.width, 2.0);
    });

    testWidgets('border-4 = 4 px', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const WDiv(className: 'border-4 border-gray-300')),
      );

      final border = _decorationOf(tester).border as Border;
      expect(border.top.width, 4.0);
    });
  });

  group('Ring widths (spread-only BoxShadow)', () {
    testWidgets('ring (DEFAULT) = 3 px spread', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const WDiv(className: 'ring ring-blue-500')),
      );

      final shadows = _decorationOf(tester).boxShadow!;
      expect(shadows, isNotEmpty);
      // Spread radius carries the ring width; offset 0, no offset shadow here.
      expect(shadows.last.spreadRadius, 3.0);
      expect(shadows.last.blurRadius, 0.0);
    });

    testWidgets('ring-2 = 2 px spread', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const WDiv(className: 'ring-2 ring-blue-500')),
      );

      final shadows = _decorationOf(tester).boxShadow!;
      expect(shadows.last.spreadRadius, 2.0);
      expect(shadows.last.blurRadius, 0.0);
    });
  });
}
