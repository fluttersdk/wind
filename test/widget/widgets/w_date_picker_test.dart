import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

void main() {
  group('WDatePicker', () {
    Widget buildTestWidget({
      DateTime? value,
      DateTimeRange? range,
      bool isRange = false,
      ValueChanged<DateTime>? onChanged,
      ValueChanged<DateTimeRange>? onRangeChanged,
      String? placeholder,
      bool disabled = false,
    }) {
      return MaterialApp(
        home: WindTheme(
          data: WindThemeData(),
          child: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                child: WDatePicker(
                  value: value,
                  range: range,
                  isRange: isRange,
                  onChanged: onChanged,
                  onRangeChanged: onRangeChanged,
                  placeholder: placeholder,
                  disabled: disabled,
                ),
              ),
            ),
          ),
        ),
      );
    }

    group('Trigger rendering', () {
      testWidgets('renders placeholder when no value', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          placeholder: 'Select date',
        ));

        expect(find.text('Select date'), findsOneWidget);
      });

      testWidgets('renders formatted date when value is set', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          value: DateTime(2026, 2, 15),
        ));

        expect(find.text('Feb 15, 2026'), findsOneWidget);
      });

      testWidgets('renders date range when range is set', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          isRange: true,
          range: DateTimeRange(
            start: DateTime(2026, 2, 10),
            end: DateTime(2026, 2, 20),
          ),
        ));

        expect(find.text('Feb 10, 2026 - Feb 20, 2026'), findsOneWidget);
      });

      testWidgets('shows calendar icon', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        expect(find.byIcon(Icons.calendar_today), findsOneWidget);
      });

      testWidgets('shows dropdown arrow', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
      });
    });

    group('Popup behavior', () {
      testWidgets('opens popup on tap', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        // Tap trigger
        await tester.tap(find.byType(WDatePicker));
        await tester.pumpAndSettle();

        // Should show calendar grid (weekday headers)
        expect(find.text('Su'), findsOneWidget);
        expect(find.text('Mo'), findsOneWidget);
      });

      testWidgets('shows arrow up when open', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        await tester.tap(find.byType(WDatePicker));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);
      });

      testWidgets('disabled picker does not open popup', (tester) async {
        await tester.pumpWidget(buildTestWidget(disabled: true));

        await tester.tap(find.byType(WDatePicker));
        await tester.pumpAndSettle();

        // Should NOT show calendar
        expect(find.text('Su'), findsNothing);
      });
    });

    group('Single date selection', () {
      testWidgets('selecting date calls onChanged', (tester) async {
        DateTime? selectedDate;

        await tester.pumpWidget(buildTestWidget(
          onChanged: (date) => selectedDate = date,
        ));

        // Open popup
        await tester.tap(find.byType(WDatePicker));
        await tester.pumpAndSettle();

        // Find and tap day 15
        final day15 = find.text('15').first;
        await tester.tap(day15);
        await tester.pumpAndSettle();

        // Should have selected a date with day 15
        expect(selectedDate?.day, equals(15));
      });

      testWidgets('selecting date closes popup', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          onChanged: (_) {},
        ));

        // Open popup
        await tester.tap(find.byType(WDatePicker));
        await tester.pumpAndSettle();

        expect(find.text('Su'), findsOneWidget);

        // Tap a day
        final day15 = find.text('15').first;
        await tester.tap(day15);
        await tester.pumpAndSettle();

        // Popup should be closed
        expect(find.text('Su'), findsNothing);
      });
    });

    group('Range selection', () {
      testWidgets('shows two calendars in range mode', (tester) async {
        await tester.pumpWidget(buildTestWidget(isRange: true));

        await tester.tap(find.byType(WDatePicker));
        await tester.pumpAndSettle();

        // Should find weekday headers twice (2 calendars)
        expect(find.text('Su'), findsNWidgets(2));
      });

      testWidgets('selecting two dates calls onRangeChanged', (tester) async {
        DateTimeRange? selectedRange;

        await tester.pumpWidget(buildTestWidget(
          isRange: true,
          onRangeChanged: (range) => selectedRange = range,
        ));

        // Open popup
        await tester.tap(find.byType(WDatePicker));
        await tester.pumpAndSettle();

        // Tap first date (day 10)
        final day10 = find.text('10').first;
        await tester.tap(day10);
        await tester.pumpAndSettle();

        // Popup should still be open (selecting end date)
        expect(find.text('Su'), findsNWidgets(2));

        // Tap second date (day 20)
        final day20 = find.text('20').first;
        await tester.tap(day20);
        await tester.pumpAndSettle();

        // Range should be selected
        expect(selectedRange, isNotNull);
        expect(selectedRange!.start.day, equals(10));
        expect(selectedRange!.end.day, equals(20));
      });
    });

    group('Month navigation', () {
      testWidgets('can navigate to previous month', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          value: DateTime(2026, 2, 15),
        ));

        await tester.tap(find.byType(WDatePicker));
        await tester.pumpAndSettle();

        // Should show February
        expect(find.text('February 2026'), findsOneWidget);

        // Tap previous month button
        await tester.tap(find.byIcon(Icons.chevron_left));
        await tester.pumpAndSettle();

        // Should show January
        expect(find.text('January 2026'), findsOneWidget);
      });

      testWidgets('can navigate to next month', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          value: DateTime(2026, 2, 15),
        ));

        await tester.tap(find.byType(WDatePicker));
        await tester.pumpAndSettle();

        // Should show February
        expect(find.text('February 2026'), findsOneWidget);

        // Tap next month button
        await tester.tap(find.byIcon(Icons.chevron_right));
        await tester.pumpAndSettle();

        // Should show March
        expect(find.text('March 2026'), findsOneWidget);
      });
    });
  });
}
