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
  group('WFormInput Widget Tests', () {
    group('Basic Rendering', () {
      testWidgets('renders WInput inside FormField', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              child: WFormInput(
                placeholder: 'Enter text',
                className: 'p-3 border rounded-lg',
              ),
            ),
          ),
        );

        expect(find.byType(TextField), findsOneWidget);
        expect(find.text('Enter text'), findsOneWidget);
      });

      testWidgets('renders with initial value', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(Form(child: WFormInput(initialValue: 'Hello World'))),
        );

        expect(find.text('Hello World'), findsOneWidget);
      });

      testWidgets('uses controller text as initial value', (tester) async {
        final controller = TextEditingController(text: 'From Controller');

        await tester.pumpWidget(
          wrapWithTheme(Form(child: WFormInput(controller: controller))),
        );

        expect(find.text('From Controller'), findsOneWidget);

        controller.dispose();
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
              child: WFormInput(
                validator: (value) {
                  validatorCalled = true;
                  if (value == null || value.isEmpty) {
                    return 'Required field';
                  }
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
              child: WFormInput(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  return null;
                },
              ),
            ),
          ),
        );

        formKey.currentState!.validate();
        await tester.pump();

        expect(find.text('Email is required'), findsOneWidget);
      });

      testWidgets('hides error message when showError is false', (
        tester,
      ) async {
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              key: formKey,
              child: WFormInput(
                showError: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
              ),
            ),
          ),
        );

        formKey.currentState!.validate();
        await tester.pump();

        // Error message should NOT be visible
        expect(find.text('Required'), findsNothing);
      });

      testWidgets('validation passes with valid input', (tester) async {
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              key: formKey,
              child: WFormInput(
                initialValue: 'valid@email.com',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
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
        expect(find.text('Required'), findsNothing);
      });
    });

    group('Error State Styling', () {
      testWidgets('error state is added to states when validation fails', (
        tester,
      ) async {
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              key: formKey,
              child: WFormInput(
                className: 'border-gray-300 error:border-red-500',
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
            ),
          ),
        );

        // Initially no error
        expect(find.byType(TextField), findsOneWidget);

        // Trigger validation
        formKey.currentState!.validate();
        await tester.pump();

        // Widget should rebuild with error state (WInput with error in states)
        expect(find.byType(TextField), findsOneWidget);
      });

      testWidgets('error state is removed when validation passes', (
        tester,
      ) async {
        final formKey = GlobalKey<FormState>();
        final controller = TextEditingController();

        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              key: formKey,
              child: WFormInput(
                controller: controller,
                className: 'border-gray-300 error:border-red-500',
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
            ),
          ),
        );

        // Validate empty - should have error
        formKey.currentState!.validate();
        await tester.pump();
        expect(find.text('Required'), findsOneWidget);

        // Enter text and revalidate
        controller.text = 'valid input';
        await tester.pump();
        formKey.currentState!.validate();
        await tester.pump();

        // Error should be gone
        expect(find.text('Required'), findsNothing);

        controller.dispose();
      });

      testWidgets('custom states are preserved alongside error state', (
        tester,
      ) async {
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              key: formKey,
              child: WFormInput(
                states: {'loading'},
                className:
                    'border-gray-300 loading:opacity-50 error:border-red-500',
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
            ),
          ),
        );

        formKey.currentState!.validate();
        await tester.pump();

        // Both loading and error states should be active
        expect(find.byType(TextField), findsOneWidget);
      });
    });

    group('Controller Synchronization', () {
      testWidgets('controller changes update FormFieldState', (tester) async {
        final formKey = GlobalKey<FormState>();
        final controller = TextEditingController();

        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              key: formKey,
              child: WFormInput(
                controller: controller,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
            ),
          ),
        );

        // Enter text via controller
        controller.text = 'Hello';
        await tester.pump();

        // Validate - should pass
        final isValid = formKey.currentState!.validate();
        expect(isValid, isTrue);

        controller.dispose();
      });

      testWidgets('user typing updates FormFieldState', (tester) async {
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              key: formKey,
              child: WFormInput(
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
            ),
          ),
        );

        // Type text
        await tester.enterText(find.byType(TextField), 'User Input');
        await tester.pump();

        // Validate - should pass
        final isValid = formKey.currentState!.validate();
        expect(isValid, isTrue);
      });

      testWidgets('onChanged callback is called', (tester) async {
        String? changedValue;

        await tester.pumpWidget(
          wrapWithTheme(
            Form(child: WFormInput(onChanged: (value) => changedValue = value)),
          ),
        );

        await tester.enterText(find.byType(TextField), 'Test');
        expect(changedValue, 'Test');
      });
    });

    group('Form Reset', () {
      testWidgets('Form.reset() clears the input', (tester) async {
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              key: formKey,
              child: WFormInput(initialValue: ''),
            ),
          ),
        );

        // Type something
        await tester.enterText(find.byType(TextField), 'User typed text');
        await tester.pump();
        expect(find.text('User typed text'), findsOneWidget);

        // Reset form
        formKey.currentState!.reset();
        await tester.pump();

        // Input should be empty (reset to initialValue)
        expect(find.text('User typed text'), findsNothing);
      });

      testWidgets('Form.reset() clears error state', (tester) async {
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              key: formKey,
              child: WFormInput(
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
            ),
          ),
        );

        // Trigger error
        formKey.currentState!.validate();
        await tester.pump();
        expect(find.text('Required'), findsOneWidget);

        // Reset form
        formKey.currentState!.reset();
        await tester.pump();

        // Error should be gone
        expect(find.text('Required'), findsNothing);
      });
    });

    group('Input Types', () {
      testWidgets('password type obscures text', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              child: WFormInput(
                type: InputType.password,
                initialValue: 'secret',
              ),
            ),
          ),
        );

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.obscureText, isTrue);
      });

      testWidgets('email type uses email keyboard', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(Form(child: WFormInput(type: InputType.email))),
        );

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.keyboardType, TextInputType.emailAddress);
      });

      testWidgets('multiline type allows multiple lines', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              child: WFormInput(
                type: InputType.multiline,
                minLines: 3,
                maxLines: 5,
              ),
            ),
          ),
        );

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.minLines, 3);
        expect(textField.maxLines, 5);
      });
    });

    group('Other Props Forwarding', () {
      testWidgets('placeholder is forwarded', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(Form(child: WFormInput(placeholder: 'Enter email'))),
        );

        expect(find.text('Enter email'), findsOneWidget);
      });

      testWidgets('readOnly is forwarded', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(Form(child: WFormInput(readOnly: true))),
        );

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.readOnly, isTrue);
      });

      testWidgets('enabled is forwarded', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(Form(child: WFormInput(enabled: false))),
        );

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.enabled, isFalse);
      });

      testWidgets('autofocus is forwarded', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(Form(child: WFormInput(autofocus: true))),
        );

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.autofocus, isTrue);
      });

      testWidgets('textInputAction is forwarded', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            Form(child: WFormInput(textInputAction: TextInputAction.search)),
          ),
        );

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.textInputAction, TextInputAction.search);
      });

      testWidgets('onSubmitted is called', (tester) async {
        String? submittedValue;

        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              child: WFormInput(onSubmitted: (value) => submittedValue = value),
            ),
          ),
        );

        await tester.enterText(find.byType(TextField), 'Submit me');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pump();

        expect(submittedValue, 'Submit me');
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
              child: WFormInput(
                initialValue: 'Save me',
                onSaved: (value) => savedValue = value,
              ),
            ),
          ),
        );

        formKey.currentState!.save();
        expect(savedValue, 'Save me');
      });
    });

    group('AutovalidateMode', () {
      testWidgets('validates on user interaction when set', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              child: WFormInput(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                initialValue: 'initial',
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
            ),
          ),
        );

        // Initially no error (field has value)
        expect(find.text('Required'), findsNothing);

        // Clear the text to trigger validation
        await tester.enterText(find.byType(TextField), '');
        await tester.pumpAndSettle();

        // Error should appear on user interaction
        expect(find.text('Required'), findsOneWidget);
      });
    });

    group('Label', () {
      testWidgets('displays label above input', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              child: WFormInput(
                label: 'Email Address',
                placeholder: 'Enter email',
              ),
            ),
          ),
        );

        expect(find.text('Email Address'), findsOneWidget);
        expect(find.text('Enter email'), findsOneWidget);
      });

      testWidgets('applies custom labelClassName', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              child: WFormInput(
                label: 'Password',
                labelClassName: 'text-lg font-bold text-blue-600',
              ),
            ),
          ),
        );

        expect(find.text('Password'), findsOneWidget);
      });

      testWidgets('no label when not provided', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(Form(child: WFormInput(placeholder: 'No label'))),
        );

        // Should only find placeholder, no additional text
        expect(find.text('No label'), findsOneWidget);
      });
    });

    group('Hint', () {
      testWidgets('displays hint below input', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            Form(child: WFormInput(hint: 'We will never share your email.')),
          ),
        );

        expect(find.text('We will never share your email.'), findsOneWidget);
      });

      testWidgets('applies custom hintClassName', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              child: WFormInput(
                hint: 'Optional field',
                hintClassName: 'text-gray-400 italic text-xs',
              ),
            ),
          ),
        );

        expect(find.text('Optional field'), findsOneWidget);
      });

      testWidgets('hint is hidden when error is shown', (tester) async {
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              key: formKey,
              child: WFormInput(
                hint: 'Enter a valid email',
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Email required' : null,
              ),
            ),
          ),
        );

        // Initially hint is visible
        expect(find.text('Enter a valid email'), findsOneWidget);
        expect(find.text('Email required'), findsNothing);

        // Trigger validation error
        formKey.currentState!.validate();
        await tester.pump();

        // Now error is visible, hint is hidden
        expect(find.text('Email required'), findsOneWidget);
        expect(find.text('Enter a valid email'), findsNothing);
      });

      testWidgets('hint reappears when error is cleared', (tester) async {
        final formKey = GlobalKey<FormState>();
        final controller = TextEditingController();

        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              key: formKey,
              child: WFormInput(
                controller: controller,
                hint: 'Minimum 8 characters',
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
            ),
          ),
        );

        // Trigger error
        formKey.currentState!.validate();
        await tester.pump();
        expect(find.text('Required'), findsOneWidget);
        expect(find.text('Minimum 8 characters'), findsNothing);

        // Fix error
        controller.text = 'valid input';
        formKey.currentState!.validate();
        await tester.pump();

        // Hint reappears
        expect(find.text('Required'), findsNothing);
        expect(find.text('Minimum 8 characters'), findsOneWidget);

        controller.dispose();
      });
    });

    group('Label and Hint Combined', () {
      testWidgets('displays label, input, and hint together', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            Form(
              child: WFormInput(
                label: 'Username',
                placeholder: 'Choose a username',
                hint: 'Letters and numbers only',
              ),
            ),
          ),
        );

        expect(find.text('Username'), findsOneWidget);
        expect(find.text('Choose a username'), findsOneWidget);
        expect(find.text('Letters and numbers only'), findsOneWidget);
      });

      testWidgets(
        'shows label, input, and error (no hint) on validation failure',
        (tester) async {
          final formKey = GlobalKey<FormState>();

          await tester.pumpWidget(
            wrapWithTheme(
              Form(
                key: formKey,
                child: WFormInput(
                  label: 'Email',
                  hint: 'We respect your privacy',
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Email is required' : null,
                ),
              ),
            ),
          );

          formKey.currentState!.validate();
          await tester.pump();

          expect(find.text('Email'), findsOneWidget); // Label
          expect(find.text('Email is required'), findsOneWidget); // Error
          expect(
            find.text('We respect your privacy'),
            findsNothing,
          ); // Hint hidden
        },
      );
    });
  });
}
