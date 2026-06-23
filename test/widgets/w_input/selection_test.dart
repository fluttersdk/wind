import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/src/parser/wind_parser.dart';
import 'package:fluttersdk_wind/src/theme/wind_theme.dart';
import 'package:fluttersdk_wind/src/theme/wind_theme_data.dart';
import 'package:fluttersdk_wind/src/widgets/w_input.dart';

/// Bare harness mirroring [material_free_test.dart]: [Directionality] >
/// [WindTheme] > child, with NO Material ancestor. Selection that needs an
/// Overlay wraps with [_overlayHarness] instead; this one is for assertions
/// that must hold under a Material-free root.
Widget _bareHarness(Widget child) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: WindTheme(
      data: WindThemeData(),
      child: child,
    ),
  );
}

/// Bare harness that DOES provide an [Overlay] (so interactive selection is
/// enabled) but still no Material/Cupertino app. Built on the minimal
/// [WidgetsApp] surface that selection drag/handles need, kept Material-free so
/// the `*HandleControls` mixin path (which suppresses `buildToolbar` and the
/// `MaterialLocalizations` assert) is what is exercised.
Widget _overlayHarness(Widget child) {
  return WidgetsApp(
    color: const Color(0xFF000000),
    // WidgetsApp supplies Directionality + DefaultWidgetsLocalizations +
    // MediaQuery (Material-free). The explicit Overlay hosts the selection
    // handles/toolbar that interactive selection reaches for, so the field's
    // `selectionEnabled` gate (Overlay.maybeOf != null) is satisfied.
    builder: (context, _) => Overlay(
      initialEntries: [
        OverlayEntry(
          builder: (context) => WindTheme(
            data: WindThemeData(),
            child: child,
          ),
        ),
      ],
    ),
  );
}

void main() {
  setUp(WindParser.clearCache);

  group('WInput native selection', () {
    // QA (1): mouse drag across "hello" produces a non-collapsed selection.
    group('mouse drag selection', () {
      testWidgets(
        'dragging the mouse across "hello" selects it',
        (tester) async {
          final controller = TextEditingController();
          addTearDown(controller.dispose);

          await tester.pumpWidget(
            _overlayHarness(
              WInput(
                controller: controller,
                className: 'text-base',
              ),
            ),
          );

          await tester.enterText(find.byType(EditableText), 'hello world');
          await tester.pump();

          // Anchor at the very start of the text, drag to just past "hello".
          final RenderEditable renderEditable = _findRenderEditable(
              tester.renderObject(find.byType(EditableText)));
          final Offset startGlyph = renderEditable.localToGlobal(
            renderEditable
                .getLocalRectForCaret(const TextPosition(offset: 0))
                .center,
          );
          final Offset endOfHello = renderEditable.localToGlobal(
            renderEditable
                .getLocalRectForCaret(const TextPosition(offset: 5))
                .center,
          );

          final TestGesture gesture =
              await tester.createGesture(kind: PointerDeviceKind.mouse);
          addTearDown(gesture.removePointer);
          await gesture.addPointer(location: startGlyph);
          await gesture.down(startGlyph);
          await tester.pump();
          await gesture.moveTo(endOfHello);
          await tester.pump();
          await gesture.up();
          await tester.pump();

          expect(
            controller.selection.isCollapsed,
            isFalse,
            reason: 'A mouse drag must produce a non-collapsed selection.',
          );
          expect(
            controller.text.substring(
              controller.selection.start,
              controller.selection.end,
            ),
            'hello',
            reason: 'The drag must cover exactly the dragged-over "hello".',
          );
        },
      );
    });

    // QA (2): double-tap selects the tapped word.
    group('double tap', () {
      testWidgets('double-tapping a word selects that word', (tester) async {
        final controller = TextEditingController();
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          _overlayHarness(
            WInput(controller: controller),
          ),
        );

        await tester.enterText(find.byType(EditableText), 'hello world');
        await tester.pump();

        final RenderEditable renderEditable =
            _findRenderEditable(tester.renderObject(find.byType(EditableText)));
        // Center of the first word "hello" (offset 2 sits inside it).
        final Offset insideHello = renderEditable.localToGlobal(
          renderEditable
              .getLocalRectForCaret(const TextPosition(offset: 2))
              .center,
        );

        await tester.tapAt(insideHello);
        await tester.pump(const Duration(milliseconds: 50));
        await tester.tapAt(insideHello);
        await tester.pump();

        expect(
          controller.text.substring(
            controller.selection.start,
            controller.selection.end,
          ),
          'hello',
          reason: 'A double tap must select the word under the pointer.',
        );
      });
    });

    // QA (3): tapping empty box area focuses the field and fires onTap.
    group('whole-box tap', () {
      testWidgets('tapping the empty box focuses and fires onTap', (
        tester,
      ) async {
        final controller = TextEditingController();
        addTearDown(controller.dispose);
        final focusNode = FocusNode();
        addTearDown(focusNode.dispose);
        bool tapped = false;

        await tester.pumpWidget(
          _overlayHarness(
            WInput(
              controller: controller,
              focusNode: focusNode,
              onTap: () => tapped = true,
              // Wide box so the right padding area is far from the glyphs.
              className: 'w-full p-4',
            ),
          ),
        );

        // Tap the far-right padding region (inside WInput, outside the glyphs).
        final Rect rect = tester.getRect(find.byType(WInput));
        await tester.tapAt(Offset(rect.right - 4, rect.center.dy));
        await tester.pump();

        expect(
          focusNode.hasFocus,
          isTrue,
          reason: 'A whole-box tap must focus the field via the builder.',
        );
        expect(
          tapped,
          isTrue,
          reason: 'onTap fires from the builder onUserTap override.',
        );
      });
    });

    // QA (4): disabled field is fully inert (IgnorePointer).
    group('disabled', () {
      testWidgets('disabled field ignores taps (no focus, no onTap)', (
        tester,
      ) async {
        final controller = TextEditingController();
        addTearDown(controller.dispose);
        final focusNode = FocusNode();
        addTearDown(focusNode.dispose);
        bool tapped = false;

        await tester.pumpWidget(
          _overlayHarness(
            WInput(
              controller: controller,
              focusNode: focusNode,
              enabled: false,
              onTap: () => tapped = true,
              className: 'w-full p-4',
            ),
          ),
        );

        final Rect rect = tester.getRect(find.byType(WInput));
        await tester.tapAt(Offset(rect.right - 4, rect.center.dy));
        await tester.pump();

        // IgnorePointer swallows the tap: the field neither focuses nor fires
        // onTap. (No text-entry assertion here: tester.enterText focuses via
        // the test binding and would bypass IgnorePointer, so it proves
        // nothing about pointer suppression.)
        expect(focusNode.hasFocus, isFalse);
        expect(tapped, isFalse);
      });
    });

    // QA (5): read-only field stays selectable.
    group('read-only', () {
      testWidgets('read-only field is still selectable by drag', (
        tester,
      ) async {
        final controller = TextEditingController(text: 'hello world');
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          _overlayHarness(
            WInput(
              controller: controller,
              readOnly: true,
            ),
          ),
        );
        await tester.pump();

        final RenderEditable renderEditable =
            _findRenderEditable(tester.renderObject(find.byType(EditableText)));
        final Offset startGlyph = renderEditable.localToGlobal(
          renderEditable
              .getLocalRectForCaret(const TextPosition(offset: 0))
              .center,
        );
        final Offset endOfHello = renderEditable.localToGlobal(
          renderEditable
              .getLocalRectForCaret(const TextPosition(offset: 5))
              .center,
        );

        final TestGesture gesture =
            await tester.createGesture(kind: PointerDeviceKind.mouse);
        addTearDown(gesture.removePointer);
        await gesture.addPointer(location: startGlyph);
        await gesture.down(startGlyph);
        await tester.pump();
        await gesture.moveTo(endOfHello);
        await tester.pump();
        await gesture.up();
        await tester.pump();

        expect(
          controller.selection.isCollapsed,
          isFalse,
          reason:
              'A read-only field must remain selectable so text can be copied.',
        );
      });
    });

    // QA (6): no Overlay ancestor — typing works, long-press does not crash.
    group('no Overlay ancestor', () {
      testWidgets('typing works and long-press does not crash', (
        tester,
      ) async {
        final controller = TextEditingController();
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          _bareHarness(
            WInput(controller: controller, placeholder: 'Type here'),
          ),
        );

        await tester.enterText(find.byType(EditableText), 'hello');
        await tester.pump();
        expect(controller.text, 'hello');

        // A long-press must degrade gracefully (selection UI suppressed), not
        // throw on the missing Overlay.
        final Offset center = tester.getCenter(find.byType(EditableText));
        final TestGesture gesture = await tester.startGesture(center);
        await tester.pump(const Duration(milliseconds: 600));
        await gesture.up();
        await tester.pump();

        expect(tester.takeException(), isNull);
      });
    });

    // QA (7): WInput wires Cupertino handle controls on EVERY platform (it stays
    // cupertino-only / no package:flutter/material.dart import), and the bare
    // harness never trips debugCheckHasMaterialLocalizations on any platform.
    group('cupertino-only handle controls', () {
      for (final TargetPlatform platform in TargetPlatform.values) {
        testWidgets('wires Cupertino handle controls on $platform',
            (tester) async {
          debugDefaultTargetPlatformOverride = platform;
          try {
            final controller = TextEditingController(text: 'sample');
            addTearDown(controller.dispose);

            // Bare harness + Overlay: the *HandleControls mixin must keep the
            // toolbar off the buildToolbar path so MaterialLocalizations is
            // never required under this Material-free root.
            await tester.pumpWidget(
              _overlayHarness(
                WInput(controller: controller),
              ),
            );

            final EditableText editable =
                tester.widget<EditableText>(find.byType(EditableText));
            expect(
              editable.selectionControls.runtimeType,
              cupertinoTextSelectionHandleControls.runtimeType,
              reason: 'WInput must wire Cupertino handle controls on every '
                  'platform (cupertino-only, no material.dart import).',
            );
            expect(tester.takeException(), isNull);
          } finally {
            debugDefaultTargetPlatformOverride = null;
          }
        });
      }
    });
  });
}

/// Walks down from [object] to the first [RenderEditable] (the EditableText's
/// own render box sits a couple of layers below its element).
RenderEditable _findRenderEditable(RenderObject object) {
  if (object is RenderEditable) {
    return object;
  }
  RenderEditable? found;
  object.visitChildren((child) {
    found ??= _findRenderEditable(child);
  });
  if (found == null) {
    throw StateError('No RenderEditable found in the subtree.');
  }
  return found!;
}
