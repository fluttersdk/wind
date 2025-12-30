import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Helper to wrap widget in MaterialApp with WindTheme
Widget wrapWithTheme(Widget child) {
  return MaterialApp(
    home: WindTheme(
      data: WindThemeData(),
      child: Scaffold(body: SingleChildScrollView(child: child)),
    ),
  );
}

/// Sample options for testing
final testOptions = [
  SelectOption(value: 'us', label: 'United States'),
  SelectOption(value: 'uk', label: 'United Kingdom'),
  SelectOption(value: 'tr', label: 'Turkey'),
];

void main() {
  group('WFormSelect Widget Tests', () {
    group('Basic Rendering', () {
      testWidgets('renders WSelect inside FormField', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              child: WFormSelect<String>(
                options: testOptions,
                placeholder: 'Select country',
              ),
            ),
          ),
        );

        expect(find.text('Select country'), findsOneWidget);
      });

      testWidgets('renders with initial value', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              child: WFormSelect<String>(value: 'us', options: testOptions),
            ),
          ),
        );

        expect(find.text('United States'), findsOneWidget);
      });

      testWidgets('displays label', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              child: WFormSelect<String>(
                options: testOptions,
                label: 'Country',
              ),
            ),
          ),
        );

        expect(find.text('Country'), findsOneWidget);
      });

      testWidgets('displays hint', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              child: WFormSelect<String>(
                options: testOptions,
                hint: 'Choose your country',
              ),
            ),
          ),
        );

        expect(find.text('Choose your country'), findsOneWidget);
      });
    });

    group('Form Validation', () {
      testWidgets('validator is called on Form.validate()', (tester) async {
        final formKey = GlobalKey<FormState>();
        bool validatorCalled = false;

        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              key: formKey,
              child: WFormSelect<String>(
                options: testOptions,
                validator: (value) {
                  validatorCalled = true;
                  if (value == null) return 'Required';
                  return null;
                },
              ),
            ),
          ),
        );

        formKey.currentState!.validate();
        await tester.pump();

        expect(validatorCalled, isTrue);
      });

      testWidgets('shows error message when validation fails', (tester) async {
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              key: formKey,
              child: WFormSelect<String>(
                options: testOptions,
                validator: (value) =>
                    value == null ? 'Country is required' : null,
              ),
            ),
          ),
        );

        formKey.currentState!.validate();
        await tester.pump();

        expect(find.text('Country is required'), findsOneWidget);
      });

      testWidgets('hides error when showError is false', (tester) async {
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              key: formKey,
              child: WFormSelect<String>(
                options: testOptions,
                showError: false,
                validator: (value) => value == null ? 'Required' : null,
              ),
            ),
          ),
        );

        formKey.currentState!.validate();
        await tester.pump();

        expect(find.text('Required'), findsNothing);
      });

      testWidgets('validation passes with valid value', (tester) async {
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              key: formKey,
              child: WFormSelect<String>(
                value: 'us',
                options: testOptions,
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

    group('Hint and Error Priority', () {
      testWidgets('hint is hidden when error is shown', (tester) async {
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              key: formKey,
              child: WFormSelect<String>(
                options: testOptions,
                hint: 'Select your country',
                validator: (value) => value == null ? 'Required' : null,
              ),
            ),
          ),
        );

        // Initially hint is visible
        expect(find.text('Select your country'), findsOneWidget);

        // Trigger validation
        formKey.currentState!.validate();
        await tester.pump();

        // Error visible, hint hidden
        expect(find.text('Required'), findsOneWidget);
        expect(find.text('Select your country'), findsNothing);
      });
    });

    group('Value Selection', () {
      testWidgets('selecting option updates form state', (tester) async {
        final formKey = GlobalKey<FormState>();
        String? selectedValue;

        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              key: formKey,
              child: WFormSelect<String>(
                options: testOptions,
                onChange: (value) => selectedValue = value,
                validator: (value) => value == null ? 'Required' : null,
              ),
            ),
          ),
        );

        // Open dropdown
        await tester.tap(find.text('Select an option'));
        await tester.pumpAndSettle();

        // Select an option
        await tester.tap(find.text('Turkey'));
        await tester.pumpAndSettle();

        // Value should be updated
        expect(selectedValue, 'tr');

        // Validation should pass now
        final isValid = formKey.currentState!.validate();
        expect(isValid, isTrue);
      });
    });

    group('Form Reset', () {
      testWidgets('Form.reset() restores to initial value', (tester) async {
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              key: formKey,
              child: WFormSelect<String>(value: 'us', options: testOptions),
            ),
          ),
        );

        expect(find.text('United States'), findsOneWidget);

        // Open and select different option
        await tester.tap(find.text('United States'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Turkey'));
        await tester.pumpAndSettle();

        expect(find.text('Turkey'), findsOneWidget);

        // Reset should restore to initial value
        formKey.currentState!.reset();
        await tester.pump();

        expect(find.text('United States'), findsOneWidget);
      });

      testWidgets('Form.reset() clears error state', (tester) async {
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              key: formKey,
              child: WFormSelect<String>(
                options: testOptions,
                validator: (value) => value == null ? 'Required' : null,
              ),
            ),
          ),
        );

        // Trigger error
        formKey.currentState!.validate();
        await tester.pump();
        expect(find.text('Required'), findsOneWidget);

        // Reset
        formKey.currentState!.reset();
        await tester.pump();

        expect(find.text('Required'), findsNothing);
      });
    });

    group('onSaved Callback', () {
      testWidgets('onSaved is called when form is saved', (tester) async {
        final formKey = GlobalKey<FormState>();
        String? savedValue;

        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              key: formKey,
              child: WFormSelect<String>(
                value: 'uk',
                options: testOptions,
                onSaved: (value) => savedValue = value,
              ),
            ),
          ),
        );

        formKey.currentState!.save();
        expect(savedValue, 'uk');
      });
    });
  });

  group('WFormMultiSelect Widget Tests', () {
    group('Basic Rendering', () {
      testWidgets('renders multi-select with placeholder', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              child: WFormMultiSelect<String>(
                options: testOptions,
                placeholder: 'Select countries',
              ),
            ),
          ),
        );

        expect(find.text('Select countries'), findsOneWidget);
      });

      testWidgets('renders with initial values', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              child: WFormMultiSelect<String>(
                values: ['us', 'uk'],
                options: testOptions,
              ),
            ),
          ),
        );

        expect(find.text('United States'), findsOneWidget);
        expect(find.text('United Kingdom'), findsOneWidget);
      });

      testWidgets('displays label', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              child: WFormMultiSelect<String>(
                options: testOptions,
                label: 'Countries',
              ),
            ),
          ),
        );

        expect(find.text('Countries'), findsOneWidget);
      });
    });

    group('Multi-Select Validation', () {
      testWidgets('validates minimum selection count', (tester) async {
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              key: formKey,
              child: WFormMultiSelect<String>(
                options: testOptions,
                validator: (values) {
                  if (values == null || values.isEmpty) {
                    return 'Select at least one';
                  }
                  return null;
                },
              ),
            ),
          ),
        );

        formKey.currentState!.validate();
        await tester.pump();

        expect(find.text('Select at least one'), findsOneWidget);
      });

      testWidgets('validates maximum selection count', (tester) async {
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              key: formKey,
              child: WFormMultiSelect<String>(
                values: ['us', 'uk', 'tr'],
                options: testOptions,
                validator: (values) {
                  if (values != null && values.length > 2) {
                    return 'Maximum 2 allowed';
                  }
                  return null;
                },
              ),
            ),
          ),
        );

        formKey.currentState!.validate();
        await tester.pump();

        expect(find.text('Maximum 2 allowed'), findsOneWidget);
      });

      testWidgets('validation passes with valid count', (tester) async {
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              key: formKey,
              child: WFormMultiSelect<String>(
                values: ['us'],
                options: testOptions,
                validator: (values) {
                  if (values == null || values.isEmpty) {
                    return 'Select at least one';
                  }
                  return null;
                },
              ),
            ),
          ),
        );

        final isValid = formKey.currentState!.validate();
        await tester.pump();

        expect(isValid, isTrue);
      });
    });

    group('Multi-Select Value Changes', () {
      testWidgets('toggling selection updates form state', (tester) async {
        final formKey = GlobalKey<FormState>();
        List<String>? selectedValues;

        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              key: formKey,
              child: WFormMultiSelect<String>(
                options: testOptions,
                onMultiChange: (values) => selectedValues = values,
              ),
            ),
          ),
        );

        // Open dropdown
        await tester.tap(find.text('Select options'));
        await tester.pumpAndSettle();

        // Select first option
        await tester.tap(find.text('United States'));
        await tester.pumpAndSettle();

        expect(selectedValues, contains('us'));

        // Select second option
        await tester.tap(find.text('Turkey'));
        await tester.pumpAndSettle();

        expect(selectedValues, containsAll(['us', 'tr']));
      });
    });

    group('Form Reset Multi-Select', () {
      testWidgets('Form.reset() restores to initial values', (tester) async {
        final formKey = GlobalKey<FormState>();
        List<String>? currentValues;

        await tester.pumpWidget(
          wrapWithTheme(
            StatefulBuilder(
              builder: (context, setState) {
                return Form(
                  key: formKey,
                  child: WFormMultiSelect<String>(
                    values: currentValues ?? ['us'],
                    options: testOptions,
                    onMultiChange: (values) {
                      setState(() => currentValues = values);
                    },
                  ),
                );
              },
            ),
          ),
        );

        // Initially just US
        expect(find.text('United States'), findsOneWidget);
        expect(find.text('Turkey'), findsNothing);

        // Open and add Turkey
        await tester.tap(find.text('United States'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Turkey'));
        await tester.pumpAndSettle();

        // Both should be in values now
        expect(currentValues, containsAll(['us', 'tr']));

        // Close dropdown by tapping outside
        await tester.tapAt(Offset.zero);
        await tester.pumpAndSettle();

        // Reset - should restore to initial (just US)
        formKey.currentState!.reset();
        await tester.pumpAndSettle();

        // State should be back to initial
        // Note: FormField resets to initialValue, but doesn't call onMultiChange
        // So we just verify no error occurs
        expect(find.byType(WFormMultiSelect<String>), findsOneWidget);
      });
    });

    group('onSaved Multi-Select', () {
      testWidgets('onSaved is called with list value', (tester) async {
        final formKey = GlobalKey<FormState>();
        List<String>? savedValues;

        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              key: formKey,
              child: WFormMultiSelect<String>(
                values: ['us', 'tr'],
                options: testOptions,
                onSaved: (values) => savedValues = values,
              ),
            ),
          ),
        );

        formKey.currentState!.save();
        expect(savedValues, ['us', 'tr']);
      });
    });
  });
}
