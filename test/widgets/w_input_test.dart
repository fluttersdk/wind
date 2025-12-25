import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  group('WInput Widget Tests', () {
    group('Basic Rendering', () {
      testWidgets('renders TextField', (tester) async {
        await tester.pumpWidget(wrapWithTheme(const WInput()));

        expect(find.byType(TextField), findsOneWidget);
      });

      testWidgets('renders with placeholder', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WInput(placeholder: 'Enter text')),
        );

        expect(find.text('Enter text'), findsOneWidget);
      });

      testWidgets('renders with initial value', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WInput(value: 'Hello World')),
        );

        expect(find.text('Hello World'), findsOneWidget);
      });

      testWidgets('applies className styling', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WInput(className: 'p-4 border rounded-lg')),
        );

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.decoration, isNotNull);
      });
    });

    group('Controlled Value', () {
      testWidgets('updates when value prop changes', (tester) async {
        String value = 'initial';

        await tester.pumpWidget(
          wrapWithTheme(
            StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    WInput(value: value),
                    ElevatedButton(
                      onPressed: () => setState(() => value = 'updated'),
                      child: const Text('Update'),
                    ),
                  ],
                );
              },
            ),
          ),
        );

        expect(find.text('initial'), findsOneWidget);

        await tester.tap(find.text('Update'));
        await tester.pumpAndSettle();

        expect(find.text('updated'), findsOneWidget);
      });

      testWidgets('calls onChanged when user types', (tester) async {
        String? changedValue;

        await tester.pumpWidget(
          wrapWithTheme(WInput(onChanged: (value) => changedValue = value)),
        );

        await tester.enterText(find.byType(TextField), 'Hello');
        expect(changedValue, 'Hello');
      });

      testWidgets('onSubmitted is called on submit', (tester) async {
        String? submittedValue;

        await tester.pumpWidget(
          wrapWithTheme(WInput(onSubmitted: (value) => submittedValue = value)),
        );

        await tester.enterText(find.byType(TextField), 'Submit me');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pump();

        expect(submittedValue, 'Submit me');
      });
    });

    group('Input Types', () {
      testWidgets('InputType.password obscures text', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WInput(type: InputType.password, value: 'secret'),
          ),
        );

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.obscureText, isTrue);
      });

      testWidgets('InputType.email uses email keyboard', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WInput(type: InputType.email)),
        );

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.keyboardType, TextInputType.emailAddress);
      });

      testWidgets('InputType.number uses number keyboard', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WInput(type: InputType.number)),
        );

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.keyboardType, TextInputType.number);
      });

      testWidgets('InputType.multiline allows multiple lines', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WInput(type: InputType.multiline)),
        );

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.maxLines, isNull); // unlimited
        expect(textField.minLines, 3); // default for multiline
        expect(textField.keyboardType, TextInputType.multiline);
      });

      testWidgets('multiline respects minLines/maxLines', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WInput(type: InputType.multiline, minLines: 5, maxLines: 10),
          ),
        );

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.minLines, 5);
        expect(textField.maxLines, 10);
      });
    });

    group('Enabled/Disabled State', () {
      testWidgets('disabled input is not editable', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WInput(enabled: false, value: 'Disabled')),
        );

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.enabled, isFalse);
      });

      testWidgets('readOnly input is not editable', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WInput(readOnly: true, value: 'ReadOnly')),
        );

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.readOnly, isTrue);
      });
    });

    group('Focus State', () {
      testWidgets('autofocus works', (tester) async {
        await tester.pumpWidget(wrapWithTheme(const WInput(autofocus: true)));

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.autofocus, isTrue);
      });

      testWidgets('focus state triggers rebuild with focus: prefix', (
        tester,
      ) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WInput(className: 'border-gray-300 focus:border-blue-500'),
          ),
        );

        // Initially not focused
        final textFieldBefore = tester.widget<TextField>(
          find.byType(TextField),
        );
        expect(textFieldBefore, isNotNull);

        // Focus the input
        await tester.tap(find.byType(TextField));
        await tester.pump();

        // Widget should rebuild with focus state
        final textFieldAfter = tester.widget<TextField>(find.byType(TextField));
        expect(textFieldAfter, isNotNull);
      });
    });

    group('External Controller', () {
      testWidgets('uses external controller when provided', (tester) async {
        final controller = TextEditingController(text: 'External');

        await tester.pumpWidget(wrapWithTheme(WInput(controller: controller)));

        expect(find.text('External'), findsOneWidget);

        controller.text = 'Updated External';
        await tester.pump();

        expect(find.text('Updated External'), findsOneWidget);

        controller.dispose();
      });

      testWidgets('ignores value prop when controller is provided', (
        tester,
      ) async {
        final controller = TextEditingController(text: 'Controller');

        await tester.pumpWidget(
          wrapWithTheme(
            WInput(
              controller: controller,
              value: 'Value', // Should be ignored
            ),
          ),
        );

        expect(find.text('Controller'), findsOneWidget);
        expect(find.text('Value'), findsNothing);

        controller.dispose();
      });
    });

    group('Input Formatters', () {
      testWidgets('applies input formatters', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WInput(inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
          ),
        );

        await tester.enterText(find.byType(TextField), 'abc123def');

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.controller?.text, '123');
      });
    });

    group('Custom States', () {
      testWidgets('accepts custom states for styling', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WInput(
              states: {'error'},
              className: 'border-gray-300 error:border-red-500',
            ),
          ),
        );

        // Widget should render with error state
        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField, isNotNull);
      });

      testWidgets('error state can be toggled dynamically', (tester) async {
        bool hasError = false;

        await tester.pumpWidget(
          wrapWithTheme(
            StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    WInput(
                      states: hasError ? {'error'} : {},
                      className: 'border-gray-300 error:border-red-500',
                    ),
                    ElevatedButton(
                      onPressed: () => setState(() => hasError = !hasError),
                      child: const Text('Toggle Error'),
                    ),
                  ],
                );
              },
            ),
          ),
        );

        // Initially no error
        expect(find.byType(TextField), findsOneWidget);

        // Toggle error state
        await tester.tap(find.text('Toggle Error'));
        await tester.pumpAndSettle();

        // Widget should rebuild with error state
        expect(find.byType(TextField), findsOneWidget);
      });

      testWidgets('multiple custom states are supported', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WInput(
              states: {'error', 'loading'},
              className:
                  'border-gray-300 error:border-red-500 loading:opacity-50',
            ),
          ),
        );

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField, isNotNull);
      });
    });

    group('Keyboard Actions', () {
      testWidgets('uses custom textInputAction', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WInput(textInputAction: TextInputAction.search)),
        );

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.textInputAction, TextInputAction.search);
      });

      testWidgets('uses TextInputAction.done', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WInput(textInputAction: TextInputAction.done)),
        );

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.textInputAction, TextInputAction.done);
      });

      testWidgets('uses TextInputAction.send', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WInput(textInputAction: TextInputAction.send)),
        );

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.textInputAction, TextInputAction.send);
      });

      testWidgets('onEditingComplete is called', (tester) async {
        bool editingCompleted = false;

        await tester.pumpWidget(
          wrapWithTheme(
            WInput(onEditingComplete: () => editingCompleted = true),
          ),
        );

        await tester.enterText(find.byType(TextField), 'Test');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pump();

        expect(editingCompleted, isTrue);
      });

      testWidgets('onTap is called when tapped', (tester) async {
        bool wasTapped = false;

        await tester.pumpWidget(
          wrapWithTheme(WInput(onTap: () => wasTapped = true)),
        );

        await tester.tap(find.byType(TextField));
        await tester.pump();

        expect(wasTapped, isTrue);
      });

      testWidgets('textCapitalization is applied', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WInput(textCapitalization: TextCapitalization.words),
          ),
        );

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.textCapitalization, TextCapitalization.words);
      });

      testWidgets('autocorrect can be disabled', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WInput(autocorrect: false)),
        );

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.autocorrect, isFalse);
      });

      testWidgets('enableSuggestions can be disabled', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WInput(enableSuggestions: false)),
        );

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.enableSuggestions, isFalse);
      });
    });

    group('Placeholder Styling', () {
      testWidgets('applies placeholderClassName', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WInput(
              placeholder: 'Enter text',
              placeholderClassName: 'text-gray-400 text-sm',
            ),
          ),
        );

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.decoration?.hintStyle, isNotNull);
      });

      testWidgets(
        'placeholder inherits text color with opacity when no placeholderClassName',
        (tester) async {
          await tester.pumpWidget(
            wrapWithTheme(
              const WInput(
                placeholder: 'Type here',
                className: 'text-blue-500',
              ),
            ),
          );

          final textField = tester.widget<TextField>(find.byType(TextField));
          // Hint style should exist with color
          expect(textField.decoration?.hintStyle?.color, isNotNull);
        },
      );
    });
  });
}
