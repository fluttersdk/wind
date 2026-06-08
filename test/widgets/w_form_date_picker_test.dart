import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Helper to wrap widget in MaterialApp with WindTheme
Widget wrapWithTheme(Widget child) {
  return MaterialApp(
    home: WindTheme(
      data: WindThemeData(),
      child: Scaffold(body: child),
    ),
  );
}

void main() {
  group('WFormDatePicker Widget Tests', () {
    group('Construction & Layout', () {
      testWidgets('renders WDatePicker inside FormField', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              child: WFormDatePicker(
                placeholder: 'Select date',
                className: 'p-3 border rounded-lg',
              ),
            ),
          ),
        );

        expect(find.byType(WDatePicker), findsOneWidget);
        expect(find.text('Select date'), findsOneWidget);
      });

      testWidgets('renders label and hint', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              child: WFormDatePicker(
                label: 'Birth Date',
                hint: 'Choose your birthday',
              ),
            ),
          ),
        );

        expect(find.text('Birth Date'), findsOneWidget);
        expect(find.text('Choose your birthday'), findsOneWidget);
      });

      testWidgets('renders with initial value', (tester) async {
        final date = DateTime(2024, 1, 1);
        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              child: WFormDatePicker(
                initialValue: date,
              ),
            ),
          ),
        );

        // Date format default is typically MM/DD/YYYY or similar,
        // WDatePicker handles the display. We check the value prop.
        final picker = tester.widget<WDatePicker>(find.byType(WDatePicker));
        expect(picker.value, equals(date));
      });
    });

    group('Form Validation', () {
      testWidgets('shows error message when validation fails', (tester) async {
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              key: formKey,
              child: WFormDatePicker(
                validator: (value) => value == null ? 'Date is required' : null,
              ),
            ),
          ),
        );

        formKey.currentState!.validate();
        await tester.pump();

        expect(find.text('Date is required'), findsOneWidget);

        // Check if error state is propagated to WDatePicker
        final picker = tester.widget<WDatePicker>(find.byType(WDatePicker));
        expect(picker.states, contains('error'));
      });

      testWidgets('hides hint when error is shown', (tester) async {
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              key: formKey,
              child: WFormDatePicker(
                hint: 'Please select a date',
                validator: (value) => value == null ? 'Required' : null,
              ),
            ),
          ),
        );

        expect(find.text('Please select a date'), findsOneWidget);

        formKey.currentState!.validate();
        await tester.pump();

        expect(find.text('Required'), findsOneWidget);
        expect(find.text('Please select a date'), findsNothing);
      });

      testWidgets('validation passes with valid input', (tester) async {
        final formKey = GlobalKey<FormState>();
        final date = DateTime(2024, 1, 1);

        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              key: formKey,
              child: WFormDatePicker(
                initialValue: date,
                validator: (value) => value == null ? 'Required' : null,
              ),
            ),
          ),
        );

        final isValid = formKey.currentState!.validate();
        await tester.pump();

        expect(isValid, isTrue);
        expect(find.text('Required'), findsNothing);
      });
    });

    group('Form Integration', () {
      testWidgets('onSaved is called when form is saved', (tester) async {
        final formKey = GlobalKey<FormState>();
        DateTime? savedValue;
        final date = DateTime(2024, 1, 1);

        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              key: formKey,
              child: WFormDatePicker(
                initialValue: date,
                onSaved: (value) => savedValue = value,
              ),
            ),
          ),
        );

        formKey.currentState!.save();
        expect(savedValue, equals(date));
      });

      testWidgets('Form.reset() clears the selection', (tester) async {
        final formKey = GlobalKey<FormState>();
        final date = DateTime(2024, 1, 1);

        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              key: formKey,
              child: WFormDatePicker(
                initialValue: null,
              ),
            ),
          ),
        );

        // Simulate date selection via internal state update (since we don't open picker)
        final state = tester
            .state<FormFieldState<DateTime>>(find.byType(WFormDatePicker));
        state.didChange(date);
        await tester.pump();

        expect(tester.widget<WDatePicker>(find.byType(WDatePicker)).value,
            equals(date));

        formKey.currentState!.reset();
        await tester.pump();

        expect(
            tester.widget<WDatePicker>(find.byType(WDatePicker)).value, isNull);
      });

      testWidgets('onChanged callback is called and syncs with form',
          (tester) async {
        DateTime? changedValue;
        final date = DateTime(2024, 5, 20);

        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              child: WFormDatePicker(
                onChanged: (value) => changedValue = value,
              ),
            ),
          ),
        );

        // Find inner WDatePicker and trigger onChanged
        final picker = tester.widget<WDatePicker>(find.byType(WDatePicker));
        picker.onChanged?.call(date);
        await tester.pump();

        expect(changedValue, equals(date));

        // Verify FormFieldState also updated
        final state = tester
            .state<FormFieldState<DateTime>>(find.byType(WFormDatePicker));
        expect(state.value, equals(date));
      });
    });

    group('Range Mode', () {
      testWidgets('range mode syncs start date to form state for validation',
          (tester) async {
        final formKey = GlobalKey<FormState>();
        final range = DateRange(
          start: DateTime(2024, 1, 1),
          end: DateTime(2024, 1, 10),
        );

        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              key: formKey,
              child: WFormDatePicker(
                mode: WDatePickerMode.range,
                validator: (value) => value == null ? 'Required' : null,
              ),
            ),
          ),
        );

        // Initial validation fails
        formKey.currentState!.validate();
        await tester.pump();
        expect(find.text('Required'), findsOneWidget);

        // Trigger range change
        final picker = tester.widget<WDatePicker>(find.byType(WDatePicker));
        picker.onRangeChanged?.call(range);
        await tester.pump();

        // Validation should now pass (because start date is synced)
        final isValid = formKey.currentState!.validate();
        await tester.pump();
        expect(isValid, isTrue);
        expect(find.text('Required'), findsNothing);
      });

      testWidgets('onRangeChanged callback is called', (tester) async {
        DateRange? changedRange;
        final range = DateRange(
          start: DateTime(2024, 1, 1),
          end: DateTime(2024, 1, 10),
        );

        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              child: WFormDatePicker(
                mode: WDatePickerMode.range,
                onRangeChanged: (r) => changedRange = r,
              ),
            ),
          ),
        );

        final picker = tester.widget<WDatePicker>(find.byType(WDatePicker));
        picker.onRangeChanged?.call(range);
        await tester.pump();

        expect(changedRange, equals(range));
      });
    });

    group('State Syncing', () {
      testWidgets('syncs range state when form is reset', (tester) async {
        final formKey = GlobalKey<FormState>();
        final range = DateRange(
          start: DateTime(2024, 1, 1),
          end: DateTime(2024, 1, 10),
        );

        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              key: formKey,
              child: WFormDatePicker(
                mode: WDatePickerMode.range,
              ),
            ),
          ),
        );

        // Set range
        final picker = tester.widget<WDatePicker>(find.byType(WDatePicker));
        picker.onRangeChanged?.call(range);
        await tester.pump();

        expect(tester.widget<WDatePicker>(find.byType(WDatePicker)).range,
            equals(range));

        // Reset form
        formKey.currentState!.reset();
        await tester.pump();

        // Range should be cleared
        expect(
            tester.widget<WDatePicker>(find.byType(WDatePicker)).range, isNull);
      });
    });

    group('Disabled State', () {
      testWidgets('enabled=false propagates to WDatePicker', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              child: WFormDatePicker(
                enabled: false,
              ),
            ),
          ),
        );

        final picker = tester.widget<WDatePicker>(find.byType(WDatePicker));
        expect(picker.disabled, isTrue);
      });
    });
  });
}
