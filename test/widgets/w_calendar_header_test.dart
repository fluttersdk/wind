import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

void main() {
  group('WCalendarHeader', () {
    late DateTime testMonth;

    setUp(() {
      testMonth = DateTime(2026, 2, 1);
    });

    Widget buildTestWidget({
      required DateTime month,
      ValueChanged<DateTime>? onMonthChanged,
      String? className,
      DateTime? minDate,
      DateTime? maxDate,
    }) {
      return MaterialApp(
        home: WindTheme(
          data: WindThemeData(),
          child: Scaffold(
            body: WCalendarHeader(
              month: month,
              onMonthChanged: onMonthChanged,
              className: className,
              minDate: minDate,
              maxDate: maxDate,
            ),
          ),
        ),
      );
    }

    group('display', () {
      testWidgets('displays current month and year', (tester) async {
        await tester.pumpWidget(buildTestWidget(month: testMonth));

        // Should display "February 2026"
        expect(find.text('February 2026'), findsOneWidget);
      });

      testWidgets('displays different months correctly', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          month: DateTime(2026, 12, 1),
        ));

        expect(find.text('December 2026'), findsOneWidget);
      });
    });

    group('navigation', () {
      testWidgets('previous month button navigates correctly', (tester) async {
        DateTime? newMonth;

        await tester.pumpWidget(buildTestWidget(
          month: testMonth,
          onMonthChanged: (month) => newMonth = month,
        ));

        // Find and tap the previous button (left arrow)
        final prevButton = find.byIcon(Icons.chevron_left);
        expect(prevButton, findsOneWidget);

        await tester.tap(prevButton);
        await tester.pump();

        expect(newMonth, isNotNull);
        expect(newMonth!.month, 1); // January
        expect(newMonth!.year, 2026);
      });

      testWidgets('next month button navigates correctly', (tester) async {
        DateTime? newMonth;

        await tester.pumpWidget(buildTestWidget(
          month: testMonth,
          onMonthChanged: (month) => newMonth = month,
        ));

        // Find and tap the next button (right arrow)
        final nextButton = find.byIcon(Icons.chevron_right);
        expect(nextButton, findsOneWidget);

        await tester.tap(nextButton);
        await tester.pump();

        expect(newMonth, isNotNull);
        expect(newMonth!.month, 3); // March
        expect(newMonth!.year, 2026);
      });

      testWidgets('navigates across year boundary (Dec -> Jan)',
          (tester) async {
        DateTime? newMonth;

        await tester.pumpWidget(buildTestWidget(
          month: DateTime(2026, 1, 1), // January
          onMonthChanged: (month) => newMonth = month,
        ));

        // Go to previous month (December 2025)
        await tester.tap(find.byIcon(Icons.chevron_left));
        await tester.pump();

        expect(newMonth!.month, 12);
        expect(newMonth!.year, 2025);
      });

      testWidgets('navigates across year boundary (Jan -> Dec)',
          (tester) async {
        DateTime? newMonth;

        await tester.pumpWidget(buildTestWidget(
          month: DateTime(2025, 12, 1), // December
          onMonthChanged: (month) => newMonth = month,
        ));

        // Go to next month (January 2026)
        await tester.tap(find.byIcon(Icons.chevron_right));
        await tester.pump();

        expect(newMonth!.month, 1);
        expect(newMonth!.year, 2026);
      });
    });

    group('constraints', () {
      testWidgets('disables previous button when at minDate month',
          (tester) async {
        DateTime? newMonth;
        final minDate = DateTime(2026, 2, 1);

        await tester.pumpWidget(buildTestWidget(
          month: testMonth, // February 2026
          minDate: minDate,
          onMonthChanged: (month) => newMonth = month,
        ));

        // Tap previous button
        await tester.tap(find.byIcon(Icons.chevron_left));
        await tester.pump();

        // Should not navigate since we're at minDate month
        expect(newMonth, isNull);
      });

      testWidgets('disables next button when at maxDate month', (tester) async {
        DateTime? newMonth;
        final maxDate = DateTime(2026, 2, 28);

        await tester.pumpWidget(buildTestWidget(
          month: testMonth, // February 2026
          maxDate: maxDate,
          onMonthChanged: (month) => newMonth = month,
        ));

        // Tap next button
        await tester.tap(find.byIcon(Icons.chevron_right));
        await tester.pump();

        // Should not navigate since we're at maxDate month
        expect(newMonth, isNull);
      });
    });

    group('styling', () {
      testWidgets('applies custom className', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          month: testMonth,
          className: 'bg-gray-100 p-4',
        ));

        expect(find.byType(WCalendarHeader), findsOneWidget);
      });
    });
  });
}
