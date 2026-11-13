import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:wind_kit/src/widgets/w_text_selection.dart';

/// Minimal Material-free root: [WidgetsApp] supplies Directionality,
/// MediaQuery and the widgets localizations, nothing from Material or
/// Cupertino.
Widget _widgetsRoot(Widget child) {
  return WidgetsApp(
    color: const Color(0xFF000000),
    builder: (context, _) => child,
  );
}

/// The toolbar with the light palette and two buttons, the shape
/// `WInput._buildContextMenu` builds.
WindTextSelectionToolbar _toolbar({
  Offset anchorAbove = const Offset(200, 300),
  Offset anchorBelow = const Offset(200, 340),
  VoidCallback? onCopy,
  VoidCallback? onPaste,
}) {
  return WindTextSelectionToolbar(
    anchorAbove: anchorAbove,
    anchorBelow: anchorBelow,
    backgroundColor: const Color(0xFFFFFFFF),
    foregroundColor: const Color(0xFF111827),
    dividerColor: const Color(0xFFE5E7EB),
    buttons: [
      WindTextSelectionToolbarButton(label: 'Copy', onPressed: onCopy),
      WindTextSelectionToolbarButton(label: 'Paste', onPressed: onPaste),
    ],
  );
}

void main() {
  group('WindTextSelectionHandleControls', () {
    final WindTextSelectionHandleControls controls =
        WindTextSelectionHandleControls();

    test('returns finite sizes and anchors inside the handle for every '
        'handle type', () {
      for (final double lineHeight in [0.0, 14.0, 20.0, 48.0]) {
        final Size size = controls.getHandleSize(lineHeight);
        expect(size.width.isFinite, isTrue);
        expect(size.height.isFinite, isTrue);
        expect(size.width, greaterThan(0));
        expect(size.height, greaterThan(lineHeight));

        for (final TextSelectionHandleType type
            in TextSelectionHandleType.values) {
          final Offset anchor = controls.getHandleAnchor(type, lineHeight);
          expect(anchor.dx.isFinite, isTrue, reason: '$type dx');
          expect(anchor.dy.isFinite, isTrue, reason: '$type dy');
          expect(anchor.dx, size.width / 2, reason: '$type is centred');
          expect(anchor.dy, inInclusiveRange(0, size.height), reason: '$type');
        }
      }
    });

    test('anchors the left handle at its stem tip and the right one at its '
        'stem root', () {
      const double lineHeight = 20;
      final Size size = controls.getHandleSize(lineHeight);

      // The left handle has its knob on top, so the stem tip (the bottom of
      // the selected line) is the bottom edge of the handle.
      expect(
        controls.getHandleAnchor(TextSelectionHandleType.left, lineHeight).dy,
        size.height,
      );
      // The right handle is flipped: its stem starts at the top of the line,
      // so the anchor sits one line height above the knob.
      expect(
        controls.getHandleAnchor(TextSelectionHandleType.right, lineHeight).dy,
        lessThan(size.height),
      );
    });

    test('suppresses the legacy buildToolbar path', () {
      expect(controls, isA<TextSelectionHandleControls>());
    });

    testWidgets('paints a lollipop for the left and right handles and an '
        'invisible hit box for the collapsed one', (tester) async {
      const double lineHeight = 20;
      final Size size = controls.getHandleSize(lineHeight);

      for (final TextSelectionHandleType type
          in TextSelectionHandleType.values) {
        await tester.pumpWidget(
          _widgetsRoot(
            Center(
              child: Builder(
                builder: (context) =>
                    controls.buildHandle(context, type, lineHeight),
              ),
            ),
          ),
        );

        final Finder paint = find.byWidgetPredicate(
          (widget) => widget is CustomPaint && widget.painter != null,
        );
        if (type == TextSelectionHandleType.collapsed) {
          expect(paint, findsNothing, reason: 'collapsed draws nothing');
          expect(tester.getSize(find.byType(SizedBox).last), size);
        } else {
          expect(paint, findsOneWidget, reason: '$type draws a lollipop');
          expect(tester.getSize(paint), size);
        }
        expect(tester.takeException(), isNull);
      }

      // Only the right handle is flipped upside down.
      await tester.pumpWidget(
        _widgetsRoot(
          Center(
            child: Builder(
              builder: (context) => controls.buildHandle(
                context,
                TextSelectionHandleType.right,
                lineHeight,
              ),
            ),
          ),
        ),
      );
      expect(find.byType(Transform), findsOneWidget);
    });

    testWidgets('paints the handle in the ambient cursor colour, with a blue '
        'fallback', (tester) async {
      Future<Color> paintedColor({Color? cursorColor}) async {
        await tester.pumpWidget(
          _widgetsRoot(
            DefaultSelectionStyle(
              cursorColor: cursorColor,
              child: Center(
                child: Builder(
                  builder: (context) => controls.buildHandle(
                    context,
                    TextSelectionHandleType.left,
                    20,
                  ),
                ),
              ),
            ),
          ),
        );

        final CustomPaint paint = tester.widget<CustomPaint>(
          find.byWidgetPredicate(
            (widget) => widget is CustomPaint && widget.painter != null,
          ),
        );
        return (paint.painter! as WindTextSelectionHandlePainter).color;
      }

      expect(await paintedColor(), const Color(0xFF3B82F6));
      expect(
        await paintedColor(cursorColor: const Color(0xFFEF4444)),
        const Color(0xFFEF4444),
      );
      // A colour change repaints; the same colour does not.
      const WindTextSelectionHandlePainter red = WindTextSelectionHandlePainter(
        Color(0xFFEF4444),
      );
      expect(
        red.shouldRepaint(
          const WindTextSelectionHandlePainter(Color(0xFF3B82F6)),
        ),
        isTrue,
      );
      expect(
        red.shouldRepaint(
          const WindTextSelectionHandlePainter(Color(0xFFEF4444)),
        ),
        isFalse,
      );
    });
  });

  group('WindTextSelectionToolbar', () {
    testWidgets('renders its buttons under a bare WidgetsApp root', (
      tester,
    ) async {
      await tester.pumpWidget(_widgetsRoot(Stack(children: [_toolbar()])));

      expect(find.text('Copy'), findsOneWidget);
      expect(find.text('Paste'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders its buttons under a MaterialApp root', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: Stack(children: [_toolbar()])),
        ),
      );

      expect(find.text('Copy'), findsOneWidget);
      expect(find.text('Paste'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('fires the tapped button only', (tester) async {
      int copies = 0;
      int pastes = 0;
      await tester.pumpWidget(
        _widgetsRoot(
          Stack(
            children: [
              _toolbar(onCopy: () => copies++, onPaste: () => pastes++),
            ],
          ),
        ),
      );

      await tester.tap(find.text('Copy'));
      await tester.pump();

      expect(copies, 1);
      expect(pastes, 0);
    });

    testWidgets('paints the given colours, a shadow and a divider between '
        'buttons', (tester) async {
      await tester.pumpWidget(_widgetsRoot(Stack(children: [_toolbar()])));

      final DecoratedBox surface = tester.widget<DecoratedBox>(
        find.descendant(
          of: find.byType(WindTextSelectionToolbar),
          matching: find.byType(DecoratedBox),
        ),
      );
      final BoxDecoration decoration = surface.decoration as BoxDecoration;
      expect(decoration.color, const Color(0xFFFFFFFF));
      expect(decoration.borderRadius, isNotNull);
      expect(decoration.boxShadow, isNotEmpty);

      final Text copy = tester.widget<Text>(find.text('Copy'));
      final DefaultTextStyle inherited = tester.widget<DefaultTextStyle>(
        find
            .ancestor(
              of: find.byWidget(copy),
              matching: find.byType(DefaultTextStyle),
            )
            .first,
      );
      expect(inherited.style.color, const Color(0xFF111827));
      expect(inherited.style.fontSize, 14);

      // Two buttons, one divider between them.
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is ColoredBox && widget.color == const Color(0xFFE5E7EB),
        ),
        findsOneWidget,
      );
    });

    testWidgets('sits above the anchor when it fits, below it otherwise', (
      tester,
    ) async {
      await tester.pumpWidget(_widgetsRoot(Stack(children: [_toolbar()])));
      final Rect above = tester.getRect(find.byType(DecoratedBox).last);
      expect(above.bottom, lessThanOrEqualTo(300));

      await tester.pumpWidget(
        _widgetsRoot(
          Stack(
            children: [
              _toolbar(
                anchorAbove: const Offset(200, 4),
                anchorBelow: const Offset(200, 40),
              ),
            ],
          ),
        ),
      );
      final Rect below = tester.getRect(find.byType(DecoratedBox).last);
      expect(below.top, greaterThanOrEqualTo(40));
    });

    testWidgets('exposes each button as an enabled semantic button', (
      tester,
    ) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      try {
        await tester.pumpWidget(
          _widgetsRoot(Stack(children: [_toolbar(onCopy: () {})])),
        );

        expect(
          tester.getSemantics(find.text('Copy')),
          matchesSemantics(
            label: 'Copy',
            isButton: true,
            hasEnabledState: true,
            isEnabled: true,
            hasTapAction: true,
          ),
        );
        expect(
          tester.getSemantics(find.text('Paste')),
          matchesSemantics(
            label: 'Paste',
            isButton: true,
            hasEnabledState: true,
          ),
        );
      } finally {
        handle.dispose();
      }
    });
  });
}
