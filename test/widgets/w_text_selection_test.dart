import 'package:flutter/foundation.dart';
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

    test('pins the handle size and the anchor of each handle type', () {
      // Radius 6, overlap 1.5: height = 10 + 12 - 1.5 = 20.5, the same
      // formulas as the Cupertino reference.
      const double lineHeight = 10;
      expect(controls.getHandleSize(lineHeight), const Size(12, 20.5));

      // Left: knob on top, the stem tip is the handle's bottom edge.
      expect(
        controls.getHandleAnchor(TextSelectionHandleType.left, lineHeight),
        const Offset(6, 20.5),
      );
      // Right: flipped, anchored one knob (minus the overlap) above the
      // bottom: 20.5 - 12 + 1.5.
      expect(
        controls.getHandleAnchor(TextSelectionHandleType.right, lineHeight),
        const Offset(6, 10),
      );
      // Collapsed: centred on the line bottom: 10 + (20.5 - 10) / 2.
      expect(
        controls.getHandleAnchor(TextSelectionHandleType.collapsed, lineHeight),
        const Offset(6, 15.25),
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
      // Rotated by pi about its centre: x and y both flip, nothing else moves.
      final Transform flip = tester.widget<Transform>(find.byType(Transform));
      expect(flip.alignment, Alignment.center);
      expect(flip.transform.entry(0, 0), closeTo(-1, 1e-9));
      expect(flip.transform.entry(1, 1), closeTo(-1, 1e-9));
      expect(flip.transform.entry(0, 1), closeTo(0, 1e-9));
      expect(flip.transform.entry(1, 0), closeTo(0, 1e-9));
      expect(flip.transform.entry(0, 3), 0);
      expect(flip.transform.entry(1, 3), 0);
      final CustomPaint rightPaint = tester.widget<CustomPaint>(
        find.descendant(
          of: find.byWidget(flip),
          matching: find.byType(CustomPaint),
        ),
      );
      expect(
        (rightPaint.painter! as WindTextSelectionHandlePainter).color,
        const Color(0xFF3B82F6),
      );
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

    group('more buttons than fit', () {
      const List<String> iosLabels = [
        'Cut',
        'Copy',
        'Paste',
        'Select All',
        'Look Up',
        'Search Web',
        'Share',
      ];
      const List<String> germanLabels = [
        'Ausschneiden',
        'Kopieren',
        'Einfügen',
        'Alles auswählen',
        'Nachschlagen',
        'Im Web suchen',
        'Teilen',
      ];

      for (final (String name, List<String> labels) in [
        ('seven iOS actions', iosLabels),
        ('German-length labels', germanLabels),
      ]) {
        testWidgets('scrolls $name into reach on a 320px screen', (
          tester,
        ) async {
          tester.view.physicalSize = const Size(320, 640);
          tester.view.devicePixelRatio = 1;
          addTearDown(() {
            tester.view.resetPhysicalSize();
            tester.view.resetDevicePixelRatio();
          });
          debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
          try {
            int lastTaps = 0;
            await tester.pumpWidget(
              _widgetsRoot(
                Stack(
                  children: [
                    WindTextSelectionToolbar(
                      anchorAbove: const Offset(160, 300),
                      anchorBelow: const Offset(160, 340),
                      backgroundColor: const Color(0xFFFFFFFF),
                      foregroundColor: const Color(0xFF111827),
                      dividerColor: const Color(0xFFE5E7EB),
                      buttons: [
                        for (final String label in labels)
                          WindTextSelectionToolbarButton(
                            label: label,
                            onPressed: label == labels.last
                                ? () => lastTaps++
                                : () {},
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            );
            expect(tester.takeException(), isNull, reason: 'no overflow');
            expect(
              tester.getRect(find.text(labels.last)).left,
              greaterThan(320),
              reason: 'the last action starts off screen',
            );

            // Further than the row is wide; the clamped physics stop at the
            // end, which leaves the last action on screen.
            await tester.drag(find.text(labels.first), const Offset(-2000, 0));
            await tester.pumpAndSettle();

            final Rect last = tester.getRect(find.text(labels.last));
            expect(last.right, lessThanOrEqualTo(320));
            expect(last.left, greaterThanOrEqualTo(0));

            await tester.tap(find.text(labels.last));
            await tester.pump();
            expect(lastTaps, 1);
            expect(tester.takeException(), isNull);
          } finally {
            debugDefaultTargetPlatformOverride = null;
          }
        });
      }
    });
  });

  group('windContextMenuLabel', () {
    const WidgetsLocalizations localizations = DefaultWidgetsLocalizations();

    String? labelOf(ContextMenuButtonType type, {String? label}) {
      return windContextMenuLabel(
        ContextMenuButtonItem(type: type, label: label, onPressed: () {}),
        localizations,
      );
    }

    test('reads every standard action from WidgetsLocalizations', () {
      expect(labelOf(ContextMenuButtonType.cut), 'Cut');
      expect(labelOf(ContextMenuButtonType.copy), 'Copy');
      expect(labelOf(ContextMenuButtonType.paste), 'Paste');
      expect(labelOf(ContextMenuButtonType.selectAll), 'Select all');
      expect(labelOf(ContextMenuButtonType.lookUp), 'Look Up');
      expect(labelOf(ContextMenuButtonType.searchWeb), 'Search Web');
      expect(labelOf(ContextMenuButtonType.share), 'Share');
    });

    test('uses the item label for the rest, and none when it has none', () {
      expect(labelOf(ContextMenuButtonType.custom, label: 'Bold'), 'Bold');
      expect(labelOf(ContextMenuButtonType.delete, label: 'Delete'), 'Delete');
      expect(
        labelOf(ContextMenuButtonType.liveTextInput, label: 'Scan'),
        'Scan',
      );
      expect(labelOf(ContextMenuButtonType.custom), isNull);
      expect(labelOf(ContextMenuButtonType.liveTextInput), isNull);
    });
  });
}
