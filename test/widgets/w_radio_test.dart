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
  setUp(() {
    WindParser.clearCache();
  });

  group('WRadio Widget Tests', () {
    group('Construction', () {
      test('creates with required props', () {
        final widget = WRadio<String>(
          value: 'a',
          groupValue: null,
          onChanged: null,
        );
        expect(widget.value, 'a');
        expect(widget.groupValue, isNull);
        expect(widget.disabled, isFalse);
      });

      test('reports selected when value equals groupValue', () {
        final widget = WRadio<String>(
          value: 'a',
          groupValue: 'a',
          onChanged: null,
        );
        expect(widget.value == widget.groupValue, isTrue);
      });

      test('stores className', () {
        final widget = WRadio<int>(
          value: 1,
          groupValue: null,
          onChanged: null,
          className: 'w-5 h-5 selected:ring-2',
        );
        expect(widget.className, 'w-5 h-5 selected:ring-2');
      });
    });

    group('Rendering', () {
      testWidgets('renders unselected radio', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WRadio<String>(
              value: 'a',
              groupValue: 'b',
              onChanged: (_) {},
            ),
          ),
        );
        await tester.pump();

        expect(find.byType(WRadio<String>), findsOneWidget);
        expect(find.byType(WDiv), findsWidgets);
      });

      testWidgets('renders selected radio', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WRadio<String>(
              value: 'a',
              groupValue: 'a',
              onChanged: (_) {},
            ),
          ),
        );
        await tester.pump();

        expect(find.byType(WRadio<String>), findsOneWidget);
      });

      testWidgets('calls onChanged with value when tapped', (tester) async {
        String? received;

        await tester.pumpWidget(
          wrapWithTheme(
            WRadio<String>(
              value: 'choice',
              groupValue: null,
              onChanged: (val) => received = val,
            ),
          ),
        );
        await tester.pump();

        await tester.tap(find.byType(WRadio<String>));
        await tester.pump();

        expect(received, 'choice');
      });

      testWidgets('does not call onChanged when disabled', (tester) async {
        String? received;

        await tester.pumpWidget(
          wrapWithTheme(
            WRadio<String>(
              value: 'choice',
              groupValue: null,
              disabled: true,
              onChanged: (val) => received = val,
            ),
          ),
        );
        await tester.pump();

        await tester.tap(find.byType(WRadio<String>));
        await tester.pump();

        expect(received, isNull);
      });

      testWidgets('does not call onChanged when already selected', (
        tester,
      ) async {
        String? received;

        await tester.pumpWidget(
          wrapWithTheme(
            WRadio<String>(
              value: 'a',
              groupValue: 'a',
              onChanged: (val) => received = val,
            ),
          ),
        );
        await tester.pump();

        await tester.tap(find.byType(WRadio<String>));
        await tester.pump();

        // onChanged should not fire when already selected.
        expect(received, isNull);
      });
    });

    group('State Styling', () {
      testWidgets('passes selected state to inner WDiv when selected', (
        tester,
      ) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WRadio<String>(
              value: 'a',
              groupValue: 'a',
              onChanged: null,
              className: 'w-5 h-5 selected:bg-blue-500',
            ),
          ),
        );
        await tester.pump();

        // The outer WDiv (the radio shell) carries the states.
        final divs = tester.widgetList<WDiv>(find.byType(WDiv)).toList();
        expect(
            divs.any((d) => d.states?.contains('selected') ?? false), isTrue);
      });

      testWidgets('does not include selected state when not selected', (
        tester,
      ) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WRadio<String>(
              value: 'a',
              groupValue: 'b',
              onChanged: null,
              className: 'w-5 h-5 selected:bg-blue-500',
            ),
          ),
        );
        await tester.pump();

        final divs = tester.widgetList<WDiv>(find.byType(WDiv)).toList();
        final anyHasSelected = divs.any(
          (d) => d.states?.contains('selected') ?? false,
        );
        expect(anyHasSelected, isFalse);
      });

      testWidgets('passes disabled state when disabled', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WRadio<String>(
              value: 'a',
              groupValue: null,
              onChanged: null,
              disabled: true,
              className: 'w-5 h-5 disabled:opacity-50',
            ),
          ),
        );
        await tester.pump();

        final divs = tester.widgetList<WDiv>(find.byType(WDiv)).toList();
        expect(
          divs.any((d) => d.states?.contains('disabled') ?? false),
          isTrue,
        );
      });
    });

    group('Group Semantics', () {
      testWidgets('selects one radio in a group via onChanged', (tester) async {
        String groupValue = 'a';

        Widget buildGroup(StateSetter setState) {
          return Column(
            children: [
              WRadio<String>(
                value: 'a',
                groupValue: groupValue,
                onChanged: (val) => setState(() => groupValue = val),
              ),
              WRadio<String>(
                value: 'b',
                groupValue: groupValue,
                onChanged: (val) => setState(() => groupValue = val),
              ),
            ],
          );
        }

        await tester.pumpWidget(
          MaterialApp(
            home: WindTheme(
              data: WindThemeData(),
              child: Scaffold(
                body: StatefulBuilder(
                  builder: (context, setState) => buildGroup(setState),
                ),
              ),
            ),
          ),
        );
        await tester.pump();

        // Tap the second radio ('b').
        final radios = find.byType(WRadio<String>);
        await tester.tap(radios.at(1));
        await tester.pump();

        expect(groupValue, 'b');
      });
    });

    group('Accessibility', () {
      testWidgets('emits checked semantics when selected', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WRadio<String>(
              value: 'a',
              groupValue: 'a',
              onChanged: (_) {},
            ),
          ),
        );
        await tester.pump();

        final SemanticsNode node = tester.getSemantics(
          find.byType(WRadio<String>),
        );
        expect(node.flagsCollection.isChecked, CheckedState.isTrue);
      });

      testWidgets('emits unchecked semantics when not selected', (
        tester,
      ) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WRadio<String>(
              value: 'a',
              groupValue: 'b',
              onChanged: (_) {},
            ),
          ),
        );
        await tester.pump();

        final SemanticsNode node = tester.getSemantics(
          find.byType(WRadio<String>),
        );
        expect(node.flagsCollection.isChecked, CheckedState.isFalse);
      });
    });
  });
}
