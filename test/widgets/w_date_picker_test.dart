import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

void main() {
  group('WDatePicker', () {
    Widget buildTestWidget({
      DateTime? value,
      DateTimeRange? range,
      ValueChanged<DateTime>? onChanged,
      ValueChanged<DateTimeRange>? onRangeChanged,
      bool isRange = false,
      String? placeholder,
      String? className,
      DateTime? minDate,
      DateTime? maxDate,
      bool disabled = false,
    }) {
      return MaterialApp(
        home: WindTheme(
          data: WindThemeData(),
          child: Scaffold(
            body: Center(
              child: WDatePicker(
                value: value,
                range: range,
                onChanged: onChanged,
                onRangeChanged: onRangeChanged,
                isRange: isRange,
                placeholder: placeholder,
                className: className,
                minDate: minDate,
                maxDate: maxDate,
                disabled: disabled,
              ),
            ),
          ),
        ),
      );
    }

    group('trigger display', () {
      testWidgets('renders trigger with placeholder when no value',
          (tester) async {
        await tester.pumpWidget(buildTestWidget(
          placeholder: 'Select date',
        ));

        expect(find.text('Select date'), findsOneWidget);
      });

      testWidgets('renders trigger with formatted date when value set',
          (tester) async {
        await tester.pumpWidget(buildTestWidget(
          value: DateTime(2026, 2, 15),
        ));

        // Should display formatted date
        expect(find.text('Feb 15, 2026'), findsOneWidget);
      });

      testWidgets('renders calendar icon', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        expect(find.byIcon(Icons.calendar_today), findsOneWidget);
      });
    });

    group('popup behavior', () {
      testWidgets('opens popup on tap', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          placeholder: 'Select date',
        ));

        // Tap trigger
        await tester.tap(find.text('Select date'));
        await tester.pumpAndSettle();

        // Calendar should be visible
        expect(find.text('Su'), findsOneWidget); // Weekday header
        expect(find.text('Mo'), findsOneWidget);
      });

      testWidgets('closes popup on outside tap', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          placeholder: 'Select date',
        ));

        // Open popup
        await tester.tap(find.text('Select date'));
        await tester.pumpAndSettle();

        // Verify popup is open
        expect(find.text('Su'), findsOneWidget);

        // Tap outside (on scaffold background)
        await tester.tapAt(const Offset(10, 10));
        await tester.pumpAndSettle();

        // Popup should be closed
        expect(find.text('Su'), findsNothing);
      });
    });

    group('single date selection', () {
      testWidgets('selecting date calls onChanged', (tester) async {
        DateTime? selectedDate;

        await tester.pumpWidget(buildTestWidget(
          placeholder: 'Select date',
          onChanged: (date) => selectedDate = date,
        ));

        // Open popup
        await tester.tap(find.text('Select date'));
        await tester.pumpAndSettle();

        // Tap on day 15
        await tester.tap(find.text('15').first);
        await tester.pumpAndSettle();

        expect(selectedDate, isNotNull);
        expect(selectedDate!.day, 15);
      });

      testWidgets('selecting date closes popup', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          placeholder: 'Select date',
          onChanged: (_) {},
        ));

        // Open popup
        await tester.tap(find.text('Select date'));
        await tester.pumpAndSettle();

        // Tap on day 15
        await tester.tap(find.text('15').first);
        await tester.pumpAndSettle();

        // Popup should be closed
        expect(find.text('Su'), findsNothing);
      });
    });

    group('disabled state', () {
      testWidgets('disabled state prevents interaction', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          placeholder: 'Select date',
          disabled: true,
        ));

        // Try to tap trigger
        await tester.tap(find.text('Select date'));
        await tester.pumpAndSettle();

        // Popup should not open
        expect(find.text('Su'), findsNothing);
      });
    });

    group('month navigation', () {
      testWidgets('can navigate to previous month', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          value: DateTime(2026, 2, 15),
        ));

        // Open popup
        await tester.tap(find.text('Feb 15, 2026'));
        await tester.pumpAndSettle();

        // Verify current month
        expect(find.text('February 2026'), findsOneWidget);

        // Navigate to previous month
        await tester.tap(find.byIcon(Icons.chevron_left));
        await tester.pumpAndSettle();

        // Should show January
        expect(find.text('January 2026'), findsOneWidget);
      });

      testWidgets('can navigate to next month', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          value: DateTime(2026, 2, 15),
        ));

        // Open popup
        await tester.tap(find.text('Feb 15, 2026'));
        await tester.pumpAndSettle();

        // Navigate to next month
        await tester.tap(find.byIcon(Icons.chevron_right));
        await tester.pumpAndSettle();

        // Should show March
        expect(find.text('March 2026'), findsOneWidget);
      });
    });

    group('date constraints', () {
      testWidgets('respects minDate constraint', (tester) async {
        DateTime? selectedDate;

        await tester.pumpWidget(buildTestWidget(
          value: DateTime(2026, 2, 15),
          minDate: DateTime(2026, 2, 10),
          onChanged: (date) => selectedDate = date,
        ));

        // Open popup
        await tester.tap(find.text('Feb 15, 2026'));
        await tester.pumpAndSettle();

        // Try to tap on day 5 (before minDate)
        await tester.tap(find.text('5').first);
        await tester.pumpAndSettle();

        // Should not select
        expect(selectedDate, isNull);
      });

      testWidgets('respects maxDate constraint', (tester) async {
        DateTime? selectedDate;

        await tester.pumpWidget(buildTestWidget(
          value: DateTime(2026, 2, 15),
          maxDate: DateTime(2026, 2, 20),
          onChanged: (date) => selectedDate = date,
        ));

        // Open popup
        await tester.tap(find.text('Feb 15, 2026'));
        await tester.pumpAndSettle();

        // Try to tap on day 25 (after maxDate)
        await tester.tap(find.text('25').first);
        await tester.pumpAndSettle();

        // Should not select
        expect(selectedDate, isNull);
      });
    });

    group('styling', () {
      testWidgets('applies custom className to trigger', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          className: 'bg-gray-100 p-4 rounded-lg',
          placeholder: 'Select date',
        ));

        expect(find.byType(WDatePicker), findsOneWidget);
      });
    });

    group('date range selection', () {
      testWidgets('isRange=true shows two-month view', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          isRange: true,
          placeholder: 'Select range',
        ));

        // Open popup
        await tester.tap(find.text('Select range'));
        await tester.pumpAndSettle();

        // Should show two month headers (current and next month)
        final now = DateTime.now();
        final currentMonth = _monthName(now.month);
        final nextMonthNum = now.month == 12 ? 1 : now.month + 1;
        final nextMonth = _monthName(nextMonthNum);

        expect(find.textContaining(currentMonth), findsWidgets);
        expect(find.textContaining(nextMonth), findsWidgets);
      });

      testWidgets('displays range in trigger when set', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          isRange: true,
          range: DateTimeRange(
            start: DateTime(2026, 2, 10),
            end: DateTime(2026, 2, 20),
          ),
        ));

        // Should display formatted range
        expect(find.text('Feb 10, 2026 - Feb 20, 2026'), findsOneWidget);
      });

      testWidgets('selecting two dates creates range', (tester) async {
        DateTimeRange? selectedRange;

        await tester.pumpWidget(buildTestWidget(
          isRange: true,
          range: DateTimeRange(
            start: DateTime(2026, 2, 1),
            end: DateTime(2026, 2, 1),
          ),
          onRangeChanged: (range) => selectedRange = range,
        ));

        // Open popup
        await tester.tap(find.text('Feb 1, 2026 - Feb 1, 2026'));
        await tester.pumpAndSettle();

        // Select first date (start)
        await tester.tap(find.text('10').first);
        await tester.pumpAndSettle();

        // Select second date (end)
        await tester.tap(find.text('15').first);
        await tester.pumpAndSettle();

        expect(selectedRange, isNotNull);
      });
    });
  });
}

String _monthName(int month) {
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  return months[month - 1];
}
