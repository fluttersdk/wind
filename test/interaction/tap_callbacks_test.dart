import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Wraps [child] in a MaterialApp + WindTheme + Scaffold so className-styled
/// widgets resolve their styling context.
Widget wrapWithTheme(Widget child) {
  return MaterialApp(
    home: WindTheme(
      data: WindThemeData(),
      child: Scaffold(body: child),
    ),
  );
}

void main() {
  // Parser cache persists between tests; clearing avoids false-positive passes.
  setUp(WindParser.clearCache);

  group('TAP interaction characterization', () {
    testWidgets('WButton fires onTap when tapped', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        wrapWithTheme(
          WButton(
            onTap: () => tapped = true,
            className: 'bg-blue-500 text-white px-4 py-2 rounded',
            child: const Text('Press'),
          ),
        ),
      );

      await tester.tap(find.text('Press'));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('WButton does NOT fire onTap when disabled', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        wrapWithTheme(
          WButton(
            onTap: () => tapped = true,
            disabled: true,
            className: 'bg-blue-500 text-white px-4 py-2 rounded',
            child: const Text('Press'),
          ),
        ),
      );

      await tester.tap(find.text('Press'), warnIfMissed: false);
      await tester.pump();

      expect(tapped, isFalse);
    });

    testWidgets('WButton does NOT fire onTap while loading', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        wrapWithTheme(
          WButton(
            onTap: () => tapped = true,
            isLoading: true,
            className: 'bg-blue-500 text-white px-4 py-2 rounded',
            child: const Text('Press'),
          ),
        ),
      );

      // Loading renders a spinner instead of the label; tap the button surface.
      await tester.tap(find.byType(WButton), warnIfMissed: false);
      await tester.pump();

      expect(tapped, isFalse);
    });

    testWidgets('WAnchor fires onTap when tapped', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        wrapWithTheme(
          WAnchor(
            onTap: () => tapped = true,
            child: const WDiv(
              className: 'p-4 bg-white',
              child: Text('Anchor'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Anchor'));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('WAnchor does NOT fire onTap when disabled', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        wrapWithTheme(
          WAnchor(
            onTap: () => tapped = true,
            isDisabled: true,
            child: const WDiv(
              className: 'p-4 bg-white',
              child: Text('Anchor'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Anchor'), warnIfMissed: false);
      await tester.pump();

      expect(tapped, isFalse);
    });

    testWidgets('WCheckbox fires onChanged with toggled value', (tester) async {
      bool? received;

      await tester.pumpWidget(
        wrapWithTheme(
          WCheckbox(
            value: false,
            onChanged: (v) => received = v,
            className: 'w-5 h-5 rounded border',
          ),
        ),
      );

      await tester.tap(find.byType(WCheckbox));
      await tester.pump();

      expect(received, isTrue);
    });

    testWidgets('WCheckbox does NOT fire onChanged when disabled',
        (tester) async {
      bool? received;

      await tester.pumpWidget(
        wrapWithTheme(
          WCheckbox(
            value: false,
            disabled: true,
            onChanged: (v) => received = v,
            className: 'w-5 h-5 rounded border',
          ),
        ),
      );

      await tester.tap(find.byType(WCheckbox), warnIfMissed: false);
      await tester.pump();

      expect(received, isNull);
    });

    testWidgets('WSelect fires onChange when an option is tapped',
        (tester) async {
      String? selected;

      await tester.pumpWidget(
        wrapWithTheme(
          WSelect<String>(
            value: null,
            placeholder: 'Pick one',
            options: const [
              SelectOption(value: 'a', label: 'Apple'),
              SelectOption(value: 'b', label: 'Banana'),
            ],
            onChange: (v) => selected = v,
          ),
        ),
      );

      // Open the dropdown. The overlay mount is deferred one frame, so settle
      // rather than single-pump before the option list is present.
      await tester.tap(find.text('Pick one'));
      await tester.pumpAndSettle();

      // Tap an option inside the overlay.
      await tester.tap(find.text('Banana').last);
      await tester.pumpAndSettle();

      expect(selected, 'b');
    });

    testWidgets('WDatePicker fires onChanged when a day is tapped',
        (tester) async {
      DateTime? picked;
      final DateTime anchor = DateTime(2024, 6, 15);

      await tester.pumpWidget(
        wrapWithTheme(
          WDatePicker(
            value: anchor,
            placeholder: 'Select date',
            onChanged: (d) => picked = d,
            className: 'p-3 border rounded',
          ),
        ),
      );

      // The trigger shows the formatted selected date (value is set), so the
      // placeholder text is not rendered. Tap the trigger surface to open.
      await tester.tap(find.byType(WDatePicker), warnIfMissed: false);
      await tester.pumpAndSettle();

      // Tap a concrete day cell (10) inside the open calendar.
      await tester.tap(find.text('10').last);
      await tester.pump();

      expect(picked, isNotNull);
      expect(picked!.day, 10);
    });
  });
}
