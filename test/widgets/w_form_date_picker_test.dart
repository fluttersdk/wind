import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

void main() {
  group('WFormDatePicker', () {
    Widget buildTestWidget({
      DateTime? initialValue,
      FormFieldValidator<DateTime>? validator,
      FormFieldSetter<DateTime>? onSaved,
      String? label,
      String? hint,
      String? placeholder,
      GlobalKey<FormState>? formKey,
    }) {
      final key = formKey ?? GlobalKey<FormState>();
      return MaterialApp(
        home: WindTheme(
          data: WindThemeData(),
          child: Scaffold(
            body: Form(
              key: key,
              child: WFormDatePicker(
                initialValue: initialValue,
                validator: validator,
                onSaved: onSaved,
                label: label,
                hint: hint,
                placeholder: placeholder,
              ),
            ),
          ),
        ),
      );
    }

    group('form integration', () {
      testWidgets('integrates with Form widget', (tester) async {
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(buildTestWidget(
          formKey: formKey,
          initialValue: DateTime(2026, 2, 15),
        ));

        expect(find.byType(WFormDatePicker), findsOneWidget);
        expect(formKey.currentState, isNotNull);
      });

      testWidgets('validator receives current value', (tester) async {
        DateTime? validatedValue;
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(buildTestWidget(
          formKey: formKey,
          initialValue: DateTime(2026, 2, 15),
          validator: (value) {
            validatedValue = value;
            return null;
          },
        ));

        formKey.currentState!.validate();
        await tester.pump();

        expect(validatedValue, isNotNull);
        expect(validatedValue!.day, 15);
      });

      testWidgets('onSaved receives value', (tester) async {
        DateTime? savedValue;
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(buildTestWidget(
          formKey: formKey,
          initialValue: DateTime(2026, 2, 15),
          onSaved: (value) => savedValue = value,
        ));

        formKey.currentState!.save();
        await tester.pump();

        expect(savedValue, isNotNull);
        expect(savedValue!.day, 15);
      });
    });

    group('validation', () {
      testWidgets('shows error message when validation fails', (tester) async {
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(buildTestWidget(
          formKey: formKey,
          validator: (value) => value == null ? 'Date is required' : null,
        ));

        formKey.currentState!.validate();
        await tester.pump();

        expect(find.text('Date is required'), findsOneWidget);
      });

      testWidgets('clears error when valid value selected', (tester) async {
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(buildTestWidget(
          formKey: formKey,
          initialValue: DateTime(2026, 2, 15),
          validator: (value) => value == null ? 'Date is required' : null,
        ));

        formKey.currentState!.validate();
        await tester.pump();

        // No error should be shown
        expect(find.text('Date is required'), findsNothing);
      });
    });

    group('labels and hints', () {
      testWidgets('renders label above picker', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          label: 'Start Date',
        ));

        expect(find.text('Start Date'), findsOneWidget);
      });

      testWidgets('renders hint when no error', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          hint: 'Select a start date',
        ));

        expect(find.text('Select a start date'), findsOneWidget);
      });
    });

    group('placeholder', () {
      testWidgets('shows placeholder when no value', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          placeholder: 'Choose date',
        ));

        expect(find.text('Choose date'), findsOneWidget);
      });
    });
  });
}
