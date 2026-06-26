import 'dart:ui' show Tristate;

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
  setUp(() {
    WindParser.clearCache();
  });

  group('WSwitch Widget Tests', () {
    group('Construction', () {
      test('creates with required value and onChanged', () {
        final widget = WSwitch(value: false, onChanged: (_) {});
        expect(widget.value, isFalse);
        expect(widget.disabled, isFalse);
      });

      test('creates with checked value', () {
        final widget = WSwitch(value: true, onChanged: (_) {});
        expect(widget.value, isTrue);
      });

      test('stores className', () {
        final widget = WSwitch(
          value: false,
          onChanged: (_) {},
          className: 'w-12 h-6 checked:bg-blue-500',
        );
        expect(widget.className, 'w-12 h-6 checked:bg-blue-500');
      });

      test('stores disabled', () {
        final widget = WSwitch(
          value: false,
          onChanged: (_) {},
          disabled: true,
        );
        expect(widget.disabled, isTrue);
      });
    });

    group('Rendering', () {
      testWidgets('renders track and thumb WDivs', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(WSwitch(value: false, onChanged: (_) {})),
        );
        await tester.pump();

        expect(find.byType(WSwitch), findsOneWidget);
        // track + thumb are both WDivs inside
        expect(find.byType(WDiv), findsWidgets);
      });

      testWidgets('wraps in WAnchor for interaction', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(WSwitch(value: false, onChanged: (_) {})),
        );
        await tester.pump();

        expect(find.byType(WAnchor), findsOneWidget);
      });

      testWidgets(
        'checked track is a flex Row honoring justify-end, not a relative Stack',
        (tester) async {
          // Regression: WSwitch must NOT inject `relative` into the track. A
          // single-child WDiv with `relative` renders as a Stack (thumb pinned
          // top-left) before the flex branch runs, which kills `justify-*`.
          await tester.pumpWidget(
            wrapWithTheme(
              WSwitch(
                value: true,
                onChanged: (_) {},
                className:
                    'w-11 h-6 flex items-center justify-start checked:justify-end',
                thumbClassName: 'w-5 h-5',
              ),
            ),
          );
          await tester.pump();

          final Finder trackRows = find.descendant(
            of: find.byType(WAnchor),
            matching: find.byType(Row),
          );
          expect(trackRows, findsWidgets);
          final Iterable<Row> rows = tester.widgetList<Row>(trackRows);
          expect(
            rows.any((Row r) => r.mainAxisAlignment == MainAxisAlignment.end),
            isTrue,
            reason: 'checked track must seat the thumb with justify-end',
          );
        },
      );
    });

    group('Interaction', () {
      testWidgets('calls onChanged with true when tapped while off', (
        tester,
      ) async {
        bool? received;

        await tester.pumpWidget(
          wrapWithTheme(
            WSwitch(
              value: false,
              onChanged: (val) => received = val,
              // Provide dimensions so the widget has a hit-testable area.
              className: 'w-11 h-6 rounded-full',
            ),
          ),
        );
        await tester.pump();

        await tester.tap(find.byType(WAnchor));
        await tester.pump();

        expect(received, isTrue);
      });

      testWidgets('calls onChanged with false when tapped while on', (
        tester,
      ) async {
        bool? received;

        await tester.pumpWidget(
          wrapWithTheme(
            WSwitch(
              value: true,
              onChanged: (val) => received = val,
              className: 'w-11 h-6 rounded-full',
            ),
          ),
        );
        await tester.pump();

        await tester.tap(find.byType(WAnchor));
        await tester.pump();

        expect(received, isFalse);
      });

      testWidgets('does not call onChanged when disabled', (tester) async {
        bool? received;

        await tester.pumpWidget(
          wrapWithTheme(
            WSwitch(
              value: false,
              disabled: true,
              onChanged: (val) => received = val,
              className: 'w-11 h-6 rounded-full',
            ),
          ),
        );
        await tester.pump();

        await tester.tap(find.byType(WAnchor));
        await tester.pump();

        expect(received, isNull);
      });

      testWidgets(
        'a null onChanged makes the switch non-interactive (no gesture, '
        'disabled state)',
        (tester) async {
          await tester.pumpWidget(
            wrapWithTheme(
              const WSwitch(
                value: false,
                onChanged: null,
                className: 'w-11 h-6 rounded-full checked:bg-blue-500',
              ),
            ),
          );
          await tester.pump();

          // No gesture handler is attached when onChanged is null.
          final anchor = tester.widget<WAnchor>(find.byType(WAnchor));
          expect(anchor.onTap, isNull);
          expect(anchor.isDisabled, isTrue);

          // The disabled: prefix activates on the track WDiv.
          final trackDiv = tester.widgetList<WDiv>(find.byType(WDiv)).first;
          expect(trackDiv.states, contains('disabled'));
        },
      );
    });

    group('State Styling', () {
      testWidgets('passes checked state to track WDiv when value is true', (
        tester,
      ) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WSwitch(
              value: true,
              onChanged: (_) {},
              className: 'checked:bg-blue-500',
            ),
          ),
        );
        await tester.pump();

        // The track WDiv is the first WDiv child of WAnchor.
        final trackDiv = tester.widgetList<WDiv>(find.byType(WDiv)).first;
        expect(trackDiv.states, contains('checked'));
      });

      testWidgets('does not include checked state in track when value is false',
          (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WSwitch(
              value: false,
              onChanged: (_) {},
              className: 'checked:bg-blue-500',
            ),
          ),
        );
        await tester.pump();

        final trackDiv = tester.widgetList<WDiv>(find.byType(WDiv)).first;
        expect(trackDiv.states?.contains('checked') ?? false, isFalse);
      });

      testWidgets('passes disabled state to track WDiv', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WSwitch(
              value: false,
              disabled: true,
              onChanged: (_) {},
            ),
          ),
        );
        await tester.pump();

        final trackDiv = tester.widgetList<WDiv>(find.byType(WDiv)).first;
        expect(trackDiv.states, contains('disabled'));
      });
    });

    group('Semantics', () {
      testWidgets('emits toggled flag when value is true', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(WSwitch(value: true, onChanged: (_) {})),
        );
        await tester.pump();

        // Semantics node for the switch should report toggled state.
        final SemanticsNode node = tester.getSemantics(find.byType(WSwitch));
        expect(node.flagsCollection.isToggled, Tristate.isTrue);
      });

      testWidgets('emits untoggled flag when value is false', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(WSwitch(value: false, onChanged: (_) {})),
        );
        await tester.pump();

        final SemanticsNode node = tester.getSemantics(find.byType(WSwitch));
        expect(node.flagsCollection.isToggled, Tristate.isFalse);
      });

      testWidgets('reports not-enabled when onChanged is null', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WSwitch(value: false, onChanged: null)),
        );
        await tester.pump();

        final SemanticsNode node = tester.getSemantics(find.byType(WSwitch));
        expect(node.flagsCollection.isEnabled, Tristate.isFalse);
      });
    });
  });
}
