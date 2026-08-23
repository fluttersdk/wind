import 'dart:ui' show CheckedState, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

Widget wrapWithTheme(Widget child) {
  return MaterialApp(
    home: WindTheme(
      data: WindThemeData(),
      child: Scaffold(body: child),
    ),
  );
}

Widget wrapWithPrimary(Widget child, MaterialColor primary) {
  return MaterialApp(
    home: WindTheme(
      data: WindThemeData(colors: {'primary': primary}),
      child: Scaffold(body: child),
    ),
  );
}

/// Returns the first non-null `BoxDecoration` background color under [of].
Color? firstDecorationColor(WidgetTester tester, Finder of) {
  final containers = tester.widgetList<Container>(
    find.descendant(of: of, matching: find.byType(Container)),
  );

  for (final container in containers) {
    final decoration = container.decoration;
    if (decoration is BoxDecoration && decoration.color != null) {
      return decoration.color;
    }
  }

  return null;
}

void main() {
  setUp(() {
    WindParser.clearCache();
  });

  group('WCheckbox Widget Tests', () {
    group('Construction', () {
      test('creates with required value', () {
        const widget = WCheckbox(value: false);
        expect(widget.value, isFalse);
        expect(widget.disabled, isFalse);
      });

      test('creates with checked value', () {
        const widget = WCheckbox(value: true);
        expect(widget.value, isTrue);
      });

      test('stores className', () {
        const widget = WCheckbox(
          value: false,
          className: 'w-5 h-5 checked:bg-blue-500',
        );
        expect(widget.className, 'w-5 h-5 checked:bg-blue-500');
      });

      test('stores disabled', () {
        const widget = WCheckbox(value: false, disabled: true);
        expect(widget.disabled, isTrue);
      });
    });

    group('Rendering', () {
      testWidgets('renders unchecked checkbox', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(WCheckbox(value: false, onChanged: (_) {})),
        );
        await tester.pump();

        expect(find.byType(WCheckbox), findsOneWidget);
        expect(find.byType(WDiv), findsOneWidget);
        expect(find.byType(WIcon), findsNothing);
      });

      testWidgets('renders checked checkbox with icon', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(WCheckbox(value: true, onChanged: (_) {})),
        );
        await tester.pump();

        expect(find.byType(WCheckbox), findsOneWidget);
        expect(find.byType(WIcon), findsOneWidget);
      });

      testWidgets('calls onChanged when tapped', (tester) async {
        bool? newValue;

        await tester.pumpWidget(
          wrapWithTheme(
            WCheckbox(value: false, onChanged: (val) => newValue = val),
          ),
        );
        await tester.pump();

        await tester.tap(find.byType(WCheckbox));
        await tester.pump();

        expect(newValue, isTrue);
      });

      testWidgets('does not call onChanged when disabled', (tester) async {
        bool? newValue;

        await tester.pumpWidget(
          wrapWithTheme(
            WCheckbox(
              value: false,
              disabled: true,
              onChanged: (val) => newValue = val,
            ),
          ),
        );
        await tester.pump();

        await tester.tap(find.byType(WCheckbox));
        await tester.pump();

        expect(newValue, isNull);
      });

      testWidgets(
        'a null onChanged makes the checkbox non-interactive (no gesture, '
        'disabled state)',
        (tester) async {
          await tester.pumpWidget(
            wrapWithTheme(
              const WCheckbox(
                value: false,
                onChanged: null,
                className: 'w-5 h-5 border disabled:opacity-50',
              ),
            ),
          );
          await tester.pump();

          // No gesture handler is attached when onChanged is null.
          final anchor = tester.widget<WAnchor>(find.byType(WAnchor));
          expect(anchor.onTap, isNull);
          expect(anchor.isDisabled, isTrue);

          // The disabled: prefix activates on the box WDiv, which is what
          // WRadio and WSwitch already do for the same input.
          final wDiv = tester.widget<WDiv>(find.byType(WDiv));
          expect(wDiv.states, contains('disabled'));
        },
      );
    });

    group('State Styling', () {
      testWidgets('passes checked state to WDiv', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WCheckbox(
              value: true,
              className: 'w-5 h-5 border checked:bg-blue-500',
            ),
          ),
        );
        await tester.pump();

        // Find the WDiv and verify it has states
        final wDiv = tester.widget<WDiv>(find.byType(WDiv));
        expect(wDiv.states, contains('checked'));
      });

      testWidgets('does not include checked state when unchecked', (
        tester,
      ) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WCheckbox(
              value: false,
              className: 'w-5 h-5 border checked:bg-blue-500',
            ),
          ),
        );
        await tester.pump();

        final wDiv = tester.widget<WDiv>(find.byType(WDiv));
        expect(wDiv.states?.contains('checked') ?? false, isFalse);
      });

      testWidgets('passes disabled state to WDiv', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WCheckbox(
              value: false,
              disabled: true,
              className: 'w-5 h-5 border disabled:bg-gray-100',
            ),
          ),
        );
        await tester.pump();

        final wDiv = tester.widget<WDiv>(find.byType(WDiv));
        expect(wDiv.states, contains('disabled'));
      });
    });

    group('Theme-driven selection color (WIND-3)', () {
      testWidgets(
          'checked background uses the default primary (blue) when '
          'the theme is unchanged', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WCheckbox(value: true)),
        );
        await tester.pump();

        expect(
          firstDecorationColor(tester, find.byType(WCheckbox))?.toARGB32(),
          const Color(0xFF3B82F6).toARGB32(),
        );
      });

      testWidgets('checked background follows a custom theme primary', (
        tester,
      ) async {
        await tester.pumpWidget(
          wrapWithPrimary(const WCheckbox(value: true), Colors.red),
        );
        await tester.pump();

        expect(
          firstDecorationColor(tester, find.byType(WCheckbox))?.toARGB32(),
          Colors.red.shade500.toARGB32(),
        );
      });
    });

    // -------------------------------------------------------------------------
    // Accessibility / Semantics
    //
    // Step 1 of plan ai-test-v2 contract: WCheckbox must wrap its tree with
    // `Semantics(checked: value, label: <resolved from child>)` so Playwright
    // `getByRole('checkbox', { name: ... })` resolves. WCheckbox today renders
    // its check glyph as the only child; the SemanticsNode label often stays
    // empty unless the host widget passes a labelling child or sibling Text.
    // -------------------------------------------------------------------------
    group('Semantics', () {
      testWidgets('emits checked state when value is true', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(WCheckbox(value: true, onChanged: (_) {})),
        );
        await tester.pump();

        final SemanticsNode node = tester.getSemantics(
          find.byType(WCheckbox),
        );
        expect(node.flagsCollection.isChecked, CheckedState.isTrue);
      });

      testWidgets('emits unchecked state when value is false', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(WCheckbox(value: false, onChanged: (_) {})),
        );
        await tester.pump();

        final SemanticsNode node = tester.getSemantics(
          find.byType(WCheckbox),
        );
        expect(node.flagsCollection.isChecked, CheckedState.isFalse);
      });

      testWidgets('a null onChanged publishes no tap action', (tester) async {
        // `onChanged: null` is how a caller renders a display-only checkbox: a
        // read-only summary row, or a tile whose own tap drives the toggle. The
        // anchor's callback was gated on `disabled` alone, so such a checkbox
        // still installed `() => onChanged?.call(!value)`, which announces a
        // pressable control whose activation runs a no-op. Measured in a
        // consumer's region picker: a 16x16 nameless node with a tap action
        // inside a tile that was doing the work itself.
        await tester.pumpWidget(
          wrapWithTheme(const WCheckbox(value: false)),
        );
        await tester.pump();

        // The tap lives on the inner anchor's node, not on the outer
        // `Semantics(container: true)` one that `getSemantics` resolves, so the
        // question is whether ANY node in the checkbox's subtree offers it.
        expect(_subtreeOffersTap(tester), isFalse);
        // The state is still reported; only the false affordance is gone.
        final SemanticsNode node = tester.getSemantics(
          find.byType(WCheckbox),
        );
        expect(node.flagsCollection.isChecked, CheckedState.isFalse);
      });

      testWidgets('a non-null onChanged still publishes a tap action',
          (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(WCheckbox(value: false, onChanged: (_) {})),
        );
        await tester.pump();

        expect(_subtreeOffersTap(tester), isTrue);
      });

      testWidgets('reports not-enabled when onChanged is null', (tester) async {
        // A control with no callback is unavailable, and assistive technology
        // needs to hear that rather than reading it as an enabled checkbox
        // that happens to do nothing.
        await tester.pumpWidget(
          wrapWithTheme(const WCheckbox(value: false)),
        );
        await tester.pump();

        final SemanticsNode node = tester.getSemantics(
          find.byType(WCheckbox),
        );
        expect(node.flagsCollection.isEnabled, Tristate.isFalse);
      });

      testWidgets('MergeSemantics folds a sibling label into the checkbox node',
          (tester) async {
        // WCheckbox renders its check glyph as the only child, so it has no
        // name of its own. This is the composition the doc recommends for a
        // labelled checkbox: the label and the box become one node carrying
        // both the text and the checked state.
        await tester.pumpWidget(
          wrapWithTheme(
            MergeSemantics(
              child: WDiv(
                className: 'flex flex-row items-center gap-3',
                children: [
                  WCheckbox(value: true, onChanged: (_) {}),
                  const WText('Accept terms'),
                ],
              ),
            ),
          ),
        );
        await tester.pump();

        // `.first` is the wrapper above: WCheckbox carries a MergeSemantics of
        // its own, so a bare byType finder matches two.
        final SemanticsNode node = tester.getSemantics(
          find.byType(MergeSemantics).first,
        );
        expect(node.label, contains('Accept terms'));
        // The checkbox's own node is merged INTO this one, so the flag lives in
        // the merged data rather than on the wrapper's own flags.
        expect(
          node.getSemanticsData().flagsCollection.isChecked,
          CheckedState.isTrue,
        );
      });

      testWidgets('reports enabled when onChanged is non-null', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(WCheckbox(value: false, onChanged: (_) {})),
        );
        await tester.pump();

        final SemanticsNode node = tester.getSemantics(
          find.byType(WCheckbox),
        );
        expect(node.flagsCollection.isEnabled, Tristate.isTrue);
      });
    });
  });
}

/// Whether any node in the rendered checkbox's semantics subtree offers a tap.
bool _subtreeOffersTap(WidgetTester tester) {
  bool found = false;

  void walk(SemanticsNode node) {
    if (node.getSemanticsData().hasAction(SemanticsAction.tap)) {
      found = true;
    }
    node.visitChildren((SemanticsNode child) {
      walk(child);
      return true;
    });
  }

  walk(tester.getSemantics(find.byType(WCheckbox)));

  return found;
}
