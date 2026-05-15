import 'package:flutter/material.dart' hide DatePickerMode;
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

// Helper to wrap widget in MaterialApp with WindTheme
Widget wrapWithTheme(Widget child) {
  return MaterialApp(
    home: WindTheme(
      data: WindThemeData(),
      child: Scaffold(
        body: Align(
          alignment: Alignment.topLeft,
          child: Padding(padding: const EdgeInsets.all(16), child: child),
        ),
      ),
    ),
  );
}

void main() {
  // Fixed date for consistent testing: Jan 15, 2025
  final DateTime testDate = DateTime(2025, 1, 15);
  group('WDatePicker', () {
    group('Construction & Defaults', () {
      testWidgets('renders with default placeholder', (tester) async {
        await tester.pumpWidget(wrapWithTheme(
          const WDatePicker(),
        ));

        expect(find.text('Select date'), findsOneWidget);
        expect(find.byIcon(Icons.calendar_today), findsOneWidget);
      });

      testWidgets('renders with custom placeholder', (tester) async {
        await tester.pumpWidget(wrapWithTheme(
          const WDatePicker(placeholder: 'Pick a birthday'),
        ));

        expect(find.text('Pick a birthday'), findsOneWidget);
      });

      testWidgets('applies className to trigger', (tester) async {
        await tester.pumpWidget(wrapWithTheme(
          const WDatePicker(className: 'bg-red-500 p-4'),
        ));

        // Find the trigger container
        final triggerFinder = find.descendant(
          of: find.byType(WDatePicker),
          matching: find.byType(WDiv).first,
        );

        final div = tester.widget<WDiv>(triggerFinder);
        expect(div.className, contains('bg-red-500'));
      });
    });

    group('Single Date Selection', () {
      testWidgets('displays selected value', (tester) async {
        await tester.pumpWidget(wrapWithTheme(
          WDatePicker(value: testDate),
        ));

        // Default format: Jan 15, 2025
        expect(find.text('Jan 15, 2025'), findsOneWidget);
      });

      testWidgets('opens popover on tap', (tester) async {
        await tester.pumpWidget(wrapWithTheme(
          WDatePicker(value: testDate),
        ));

        await tester.tap(find.byType(WDatePicker));
        await tester.pumpAndSettle();

        // Should see calendar header
        expect(find.text('January 2025'), findsOneWidget);
        // Should see days
        expect(find.text('15'), findsOneWidget);
      });

      testWidgets('selects a date and calls onChanged', (tester) async {
        DateTime? selected;
        await tester.pumpWidget(wrapWithTheme(
          WDatePicker(
            value: testDate,
            onChanged: (v) => selected = v,
          ),
        ));

        // Open popover
        await tester.tap(find.text('Jan 15, 2025'));
        await tester.pumpAndSettle();

        // Tap Jan 20
        await tester.tap(find.text('20'));
        await tester.pumpAndSettle();

        expect(selected, isNotNull);
        expect(selected!.day, 20);
        expect(selected!.month, 1);
        expect(selected!.year, 2025);

        // Popover should close
        expect(find.text('January 2025'), findsNothing);
      });
    });

    group('Month Navigation', () {
      testWidgets('navigates to next/prev month', (tester) async {
        await tester.pumpWidget(wrapWithTheme(
          WDatePicker(value: testDate),
        ));

        await tester.tap(find.byType(WDatePicker));
        await tester.pumpAndSettle();

        expect(find.text('January 2025'), findsOneWidget);

        // Next month
        await tester.tap(find.byIcon(Icons.chevron_right));
        await tester.pumpAndSettle();
        expect(find.text('February 2025'), findsOneWidget);

        // Prev month (back to Jan)
        await tester.tap(find.byIcon(Icons.chevron_left));
        await tester.pumpAndSettle();
        expect(find.text('January 2025'), findsOneWidget);

        // Prev month (Dec 2024)
        await tester.tap(find.byIcon(Icons.chevron_left));
        await tester.pumpAndSettle();
        expect(find.text('December 2024'), findsOneWidget);
      });
    });

    group('Date Range Selection', () {
      testWidgets('displays range placeholder', (tester) async {
        await tester.pumpWidget(wrapWithTheme(
          const WDatePicker(
            mode: DatePickerMode.range,
            placeholder: 'Select range',
          ),
        ));

        expect(find.text('Select range'), findsOneWidget);
      });

      testWidgets('displays selected range', (tester) async {
        final range = DateRange(
          start: DateTime(2025, 1, 10),
          end: DateTime(2025, 1, 15),
        );

        await tester.pumpWidget(wrapWithTheme(
          WDatePicker(
            mode: DatePickerMode.range,
            range: range,
          ),
        ));

        expect(find.text('Jan 10, 2025 - Jan 15, 2025'), findsOneWidget);
      });

      testWidgets('displays partial range', (tester) async {
        final range = DateRange(
          start: DateTime(2025, 1, 10),
        );

        await tester.pumpWidget(wrapWithTheme(
          WDatePicker(
            mode: DatePickerMode.range,
            range: range,
          ),
        ));

        expect(find.text('Jan 10, 2025 - ...'), findsOneWidget);
      });

      testWidgets('selects range (start then end)', (tester) async {
        DateRange? selectedRange;

        await tester.pumpWidget(wrapWithTheme(
          StatefulBuilder(
            builder: (context, setState) {
              return WDatePicker(
                mode: DatePickerMode.range,
                value: testDate, // Initial focus month
                onRangeChanged: (r) {
                  selectedRange = r;
                  setState(() {});
                },
              );
            },
          ),
        ));

        // Open popover (defaults to now, so we need to ensure we see correct month)
        // Since we didn't pass range or value (it uses value for focus in single mode,
        // range.start for focus in range mode, or now), we might need to nav to Jan 2025 if 'now' is not Jan 2025.
        // But let's pass an initial range to set focus, or just navigate.
        // Actually, let's use a widget that sets focus based on a prop or just rely on navigation.
        // Easier: Provide a range with just start to focus the month, but we want to test fresh selection.
        // The widget code says: `_initFocusedMonth` uses range.start if available, else now.
        // We'll mock 'now' implicitly by passing a range start for focus, OR we navigate.

        // Let's restart with a pre-set single start date to force focus on Jan 2025
        await tester.pumpWidget(wrapWithTheme(
          StatefulBuilder(
            builder: (context, setState) {
              return WDatePicker(
                mode: DatePickerMode.range,
                range: DateRange(start: testDate), // Focuses Jan 2025
                onRangeChanged: (r) => selectedRange = r,
              );
            },
          ),
        ));

        await tester.tap(find.byType(WDatePicker));
        await tester.pumpAndSettle();

        expect(find.text('January 2025'), findsOneWidget);

        // Tap 10th (Start) - Logic: if range is complete or null, reset.
        // Here we provided start, so it might think it's in progress?
        // Code: `if (widget.range?.isComplete == true) { _rangeStart = null; }`
        // We passed `DateRange(start: testDate, end: null)`. So it is NOT complete.
        // So `_rangeStart` logic in `_onDateSelected`:
        // If `_rangeStart == null`: sets start.
        // Wait, `_rangeStart` is internal state initialized to null.
        // But `didUpdateWidget` doesn't sync `_rangeStart` from `widget.range`.
        // `_CalendarGrid` uses `rangeStart: _rangeStart`.
        // `_rangeStart` is ONLY set on tap.
        // So even if we pass a partial range, the internal interaction state `_rangeStart` starts null.
        // First tap -> `_rangeStart` = date. `onRangeChanged` called with start.

        // Tap 10
        await tester.tap(find.text('10'));
        await tester.pumpAndSettle();

        expect(selectedRange?.start.day, 10);
        expect(selectedRange?.end, isNull);

        // Tap 20 (End)
        await tester.tap(find.text('20'));
        await tester.pumpAndSettle();

        expect(selectedRange?.start.day, 10);
        expect(selectedRange?.end?.day, 20);

        // Popover should close
        expect(find.text('January 2025'), findsNothing);
      });
    });

    group('Constraints & Formatting', () {
      testWidgets('respects minDate and maxDate', (tester) async {
        await tester.pumpWidget(wrapWithTheme(
          WDatePicker(
            value: testDate,
            minDate: DateTime(2025, 1, 10),
            maxDate: DateTime(2025, 1, 20),
          ),
        ));

        await tester.tap(find.byType(WDatePicker));
        await tester.pumpAndSettle();

        // 5th should be disabled (text color check or tap check)
        // Note: There might be two '5's (Jan 5 and Feb 5). Jan 5 is first.
        await tester.tap(find.text('5').first);
        await tester.pumpAndSettle();
        expect(find.text('January 2025'), findsOneWidget); // Still open

        // 25th should be disabled
        await tester.tap(find.text('25'));
        await tester.pumpAndSettle();
        expect(find.text('January 2025'), findsOneWidget); // Still open

        // 15th should be enabled
        await tester.tap(find.text('15'));
        await tester.pumpAndSettle();
        expect(find.text('January 2025'), findsNothing); // Closed
      });

      testWidgets('uses custom displayFormat', (tester) async {
        await tester.pumpWidget(wrapWithTheme(
          WDatePicker(
            value: testDate,
            displayFormat: (date) =>
                'Y${date.year}-M${date.month}-D${date.day}',
          ),
        ));

        expect(find.text('Y2025-M1-D15'), findsOneWidget);
      });
    });

    group('Popover Integration', () {
      testWidgets('closes when tapping outside', (tester) async {
        await tester.pumpWidget(wrapWithTheme(
          Column(
            children: [
              WDatePicker(value: testDate),
              const SizedBox(height: 100),
              const Text('Outside'),
            ],
          ),
        ));

        await tester.tap(find.byType(WDatePicker));
        await tester.pumpAndSettle();
        expect(find.text('January 2025'), findsOneWidget);

        await tester.tap(find.text('Outside'));
        await tester.pumpAndSettle();
        expect(find.text('January 2025'), findsNothing);
      });
    });

    // -----------------------------------------------------------------------
    // Accessibility / Semantics
    //
    // Step 1 of plan ai-test-v2 contract: WDatePicker must surface a
    // textField SemanticsNode labelled with its `placeholder`, with the
    // current ISO-formatted value as the Semantics value. Playwright
    // `getByLabel(/select date/i)` resolves the trigger on the closed
    // popover.
    // -----------------------------------------------------------------------
    group('Semantics', () {
      testWidgets('emits textField role with placeholder as label',
          (tester) async {
        await tester.pumpWidget(wrapWithTheme(
          const WDatePicker(placeholder: 'Pick a date'),
        ));

        final SemanticsNode node = tester.getSemantics(
          find.byType(WDatePicker),
        );
        expect(node.flagsCollection.isTextField, isTrue);
        expect(node.label, 'Pick a date');
      });

      testWidgets('emits ISO-formatted value when a date is selected',
          (tester) async {
        await tester.pumpWidget(wrapWithTheme(
          WDatePicker(value: testDate, placeholder: 'Pick a date'),
        ));

        final SemanticsNode node = tester.getSemantics(
          find.byType(WDatePicker),
        );
        expect(node.flagsCollection.isTextField, isTrue);
        expect(node.value, contains(testDate.toIso8601String()));
      });
    });
  });
}
