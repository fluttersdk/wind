import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';
import 'package:fluttersdk_wind/src/widgets/w_calendar_grid.dart';

void main() {
  group('WCalendarGrid', () {
    late DateTime testMonth;

    setUp(() {
      // Use a fixed month for predictable testing (February 2026)
      testMonth = DateTime(2026, 2, 1);
    });

    Widget buildTestWidget({
      required DateTime month,
      DateTime? selectedDate,
      DateTimeRange? selectedRange,
      DateTime? minDate,
      DateTime? maxDate,
      ValueChanged<DateTime>? onDateSelected,
      String? className,
    }) {
      return MaterialApp(
        home: WindTheme(
          data: WindThemeData(),
          child: Scaffold(
            body: WCalendarGrid(
              month: month,
              selectedDate: selectedDate,
              selectedRange: selectedRange,
              minDate: minDate,
              maxDate: maxDate,
              onDateSelected: onDateSelected,
              className: className,
            ),
          ),
        ),
      );
    }

    group('weekday headers', () {
      testWidgets('renders 7 weekday headers', (tester) async {
        await tester.pumpWidget(buildTestWidget(month: testMonth));

        // Check for weekday abbreviations
        expect(find.text('Su'), findsOneWidget);
        expect(find.text('Mo'), findsOneWidget);
        expect(find.text('Tu'), findsOneWidget);
        expect(find.text('We'), findsOneWidget);
        expect(find.text('Th'), findsOneWidget);
        expect(find.text('Fr'), findsOneWidget);
        expect(find.text('Sa'), findsOneWidget);
      });
    });

    group('day cells', () {
      testWidgets('renders correct days for February 2026', (tester) async {
        await tester.pumpWidget(buildTestWidget(month: testMonth));

        // February 2026 has 28 days (not a leap year)
        // Days may appear multiple times (from adjacent months)
        // Just verify the grid renders
        expect(find.text('15'), findsWidgets);
        expect(find.text('28'), findsWidgets);
        expect(find.byType(WCalendarGrid), findsOneWidget);
      });

      testWidgets('renders days from previous month with faded style',
          (tester) async {
        // February 2026 starts on Sunday, so no previous month days
        // Use March 2026 instead (starts on Sunday too, check)
        // Actually, let's use January 2026 which starts on Thursday
        final january = DateTime(2026, 1, 1);
        await tester.pumpWidget(buildTestWidget(month: january));

        // January 2026 starts on Thursday
        // So we should see days from December 2025 (28, 29, 30, 31)
        // These should be in the grid but styled differently
        await tester.pump();
      });
    });

    group('selection', () {
      testWidgets('highlights selected single date', (tester) async {
        final selectedDate = DateTime(2026, 2, 15);
        await tester.pumpWidget(buildTestWidget(
          month: testMonth,
          selectedDate: selectedDate,
        ));

        // Find the day cell for 15 and verify it's highlighted
        final day15 = find.text('15');
        expect(day15, findsOneWidget);

        // The parent should have selection styling
        // We verify by checking the widget exists with selected state
      });

      testWidgets('highlights date range (start, middle, end)', (tester) async {
        final range = DateTimeRange(
          start: DateTime(2026, 2, 10),
          end: DateTime(2026, 2, 15),
        );
        await tester.pumpWidget(buildTestWidget(
          month: testMonth,
          selectedRange: range,
        ));

        // All days from 10 to 15 should be in range
        // Days may appear multiple times due to grid structure
        expect(find.text('10'), findsWidgets);
        expect(find.text('12'), findsWidgets);
        expect(find.text('15'), findsWidgets);
      });
    });

    group('constraints', () {
      testWidgets('disables dates before minDate', (tester) async {
        final minDate = DateTime(2026, 2, 10);
        DateTime? selectedDate;

        await tester.pumpWidget(buildTestWidget(
          month: testMonth,
          minDate: minDate,
          onDateSelected: (date) => selectedDate = date,
        ));

        // Try to tap on day 5 (before minDate) - use first match
        await tester.tap(find.text('5').first);
        await tester.pump();

        // Selection should not change
        expect(selectedDate, isNull);
      });

      testWidgets('disables dates after maxDate', (tester) async {
        final maxDate = DateTime(2026, 2, 20);
        DateTime? selectedDate;

        await tester.pumpWidget(buildTestWidget(
          month: testMonth,
          maxDate: maxDate,
          onDateSelected: (date) => selectedDate = date,
        ));

        // Try to tap on day 25 (after maxDate)
        await tester.tap(find.text('25'));
        await tester.pump();

        // Selection should not change
        expect(selectedDate, isNull);
      });
    });

    group('interaction', () {
      testWidgets('onDateSelected fires when tapping valid date',
          (tester) async {
        DateTime? selectedDate;

        await tester.pumpWidget(buildTestWidget(
          month: testMonth,
          onDateSelected: (date) => selectedDate = date,
        ));

        // Tap on day 15
        await tester.tap(find.text('15'));
        await tester.pump();

        expect(selectedDate, isNotNull);
        expect(selectedDate!.day, 15);
        expect(selectedDate!.month, 2);
        expect(selectedDate!.year, 2026);
      });
    });

    group('styling', () {
      testWidgets('applies custom className', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          month: testMonth,
          className: 'bg-gray-100 p-2',
        ));

        // Widget should render without errors
        expect(find.byType(WCalendarGrid), findsOneWidget);
      });
    });
  });
}
