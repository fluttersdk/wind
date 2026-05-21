import 'dart:ui' show CheckedState;

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

void main() {
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
    });
  });
}
