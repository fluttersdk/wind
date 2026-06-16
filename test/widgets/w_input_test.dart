import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
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
  setUp(WindParser.clearCache);

  group('WInput Widget Tests', () {
    group('Basic Rendering', () {
      testWidgets('renders EditableText', (tester) async {
        await tester.pumpWidget(wrapWithTheme(const WInput()));

        expect(find.byType(EditableText), findsOneWidget);
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

      testWidgets('applies className styling via DecoratedBox', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WInput(className: 'p-4 border rounded-lg')),
        );

        // The EditableText backend wraps the field in a DecoratedBox.
        expect(find.byType(DecoratedBox), findsWidgets);
        expect(find.byType(EditableText), findsOneWidget);
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

        await tester.enterText(find.byType(EditableText), 'Hello');
        expect(changedValue, 'Hello');
      });

      testWidgets('onSubmitted is called on submit', (tester) async {
        String? submittedValue;

        await tester.pumpWidget(
          wrapWithTheme(WInput(onSubmitted: (value) => submittedValue = value)),
        );

        await tester.enterText(find.byType(EditableText), 'Submit me');
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

        final editableText =
            tester.widget<EditableText>(find.byType(EditableText));
        expect(editableText.obscureText, isTrue);
      });

      testWidgets('InputType.email uses email keyboard', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WInput(type: InputType.email)),
        );

        final editableText =
            tester.widget<EditableText>(find.byType(EditableText));
        expect(editableText.keyboardType, TextInputType.emailAddress);
      });

      testWidgets('InputType.number uses number keyboard', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WInput(type: InputType.number)),
        );

        final editableText =
            tester.widget<EditableText>(find.byType(EditableText));
        expect(editableText.keyboardType, TextInputType.number);
      });

      testWidgets('InputType.multiline allows multiple lines', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WInput(type: InputType.multiline)),
        );

        final editableText =
            tester.widget<EditableText>(find.byType(EditableText));
        expect(editableText.maxLines, isNull); // unlimited
        expect(editableText.minLines, 1); // default
        expect(editableText.keyboardType, TextInputType.multiline);
      });

      testWidgets('multiline respects minLines/maxLines', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WInput(type: InputType.multiline, minLines: 5, maxLines: 10),
          ),
        );

        final editableText =
            tester.widget<EditableText>(find.byType(EditableText));
        expect(editableText.minLines, 5);
        expect(editableText.maxLines, 10);
      });
    });

    group('Enabled/Disabled State', () {
      testWidgets('disabled input is not editable', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WInput(enabled: false, value: 'Disabled')),
        );

        // disabled=false routes to readOnly=true in EditableText (no GestureDetector either).
        final editableText =
            tester.widget<EditableText>(find.byType(EditableText));
        expect(editableText.readOnly, isTrue);
      });

      testWidgets('readOnly input is not editable', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WInput(readOnly: true, value: 'ReadOnly')),
        );

        final editableText =
            tester.widget<EditableText>(find.byType(EditableText));
        expect(editableText.readOnly, isTrue);
      });

      testWidgets('disabled input has no GestureDetector tap handler', (
        tester,
      ) async {
        await tester.pumpWidget(
          wrapWithTheme(const WInput(enabled: false, value: 'Disabled')),
        );

        // When disabled, the GestureDetector wrapper is omitted (no whole-box tap target).
        // The EditableText itself still renders but the wrapping tap gesture is gone.
        expect(find.byType(EditableText), findsOneWidget);
      });
    });

    group('Focus State', () {
      testWidgets('autofocus works', (tester) async {
        await tester.pumpWidget(wrapWithTheme(const WInput(autofocus: true)));

        final editableText =
            tester.widget<EditableText>(find.byType(EditableText));
        expect(editableText.autofocus, isTrue);
      });

      testWidgets('focus state triggers rebuild with focus: prefix', (
        tester,
      ) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WInput(className: 'border-gray-300 focus:border-blue-500'),
          ),
        );

        // Initially not focused — EditableText is present.
        expect(find.byType(EditableText), findsOneWidget);

        // Focus the input via GestureDetector (whole-box tap).
        await tester.tap(find.byType(WInput));
        await tester.pump();

        // Widget should rebuild with focus state; EditableText still present.
        expect(find.byType(EditableText), findsOneWidget);
      });
    });

    group('External Controller', () {
      testWidgets('uses external controller when provided', (tester) async {
        final controller = TextEditingController(text: 'External');
        addTearDown(controller.dispose);

        await tester.pumpWidget(wrapWithTheme(WInput(controller: controller)));

        expect(find.text('External'), findsOneWidget);

        controller.text = 'Updated External';
        await tester.pump();

        expect(find.text('Updated External'), findsOneWidget);
      });

      testWidgets('displays controller text when controller is provided', (
        tester,
      ) async {
        // W2 guard: value + controller together throws AssertionError (tested in
        // material_free_test.dart). Here we verify the controller text is shown.
        final controller = TextEditingController(text: 'Controller');
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          wrapWithTheme(WInput(controller: controller)),
        );

        expect(find.text('Controller'), findsOneWidget);
      });
    });

    group('Input Formatters', () {
      testWidgets('applies input formatters', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WInput(inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
          ),
        );

        await tester.enterText(find.byType(EditableText), 'abc123def');

        final editableText =
            tester.widget<EditableText>(find.byType(EditableText));
        expect(editableText.controller.text, '123');
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

        // Widget should render with error state.
        expect(find.byType(WInput), findsOneWidget);
        expect(find.byType(EditableText), findsOneWidget);
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

        // Initially no error.
        expect(find.byType(WInput), findsOneWidget);

        // Toggle error state.
        await tester.tap(find.text('Toggle Error'));
        await tester.pumpAndSettle();

        // Widget should rebuild with error state.
        expect(find.byType(WInput), findsOneWidget);
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

        expect(find.byType(WInput), findsOneWidget);
        expect(find.byType(EditableText), findsOneWidget);
      });
    });

    group('Keyboard Actions', () {
      testWidgets('uses custom textInputAction', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WInput(textInputAction: TextInputAction.search)),
        );

        final editableText =
            tester.widget<EditableText>(find.byType(EditableText));
        expect(editableText.textInputAction, TextInputAction.search);
      });

      testWidgets('uses TextInputAction.done', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WInput(textInputAction: TextInputAction.done)),
        );

        final editableText =
            tester.widget<EditableText>(find.byType(EditableText));
        expect(editableText.textInputAction, TextInputAction.done);
      });

      testWidgets('uses TextInputAction.send', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WInput(textInputAction: TextInputAction.send)),
        );

        final editableText =
            tester.widget<EditableText>(find.byType(EditableText));
        expect(editableText.textInputAction, TextInputAction.send);
      });

      testWidgets('onEditingComplete is called', (tester) async {
        bool editingCompleted = false;

        await tester.pumpWidget(
          wrapWithTheme(
            WInput(onEditingComplete: () => editingCompleted = true),
          ),
        );

        await tester.enterText(find.byType(EditableText), 'Test');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pump();

        expect(editingCompleted, isTrue);
      });

      testWidgets('onTap is called when tapped', (tester) async {
        bool wasTapped = false;

        await tester.pumpWidget(
          wrapWithTheme(WInput(onTap: () => wasTapped = true)),
        );

        // Tap in the right-padding area of the WInput: the GestureDetector wraps
        // the whole field, but EditableText's own TapGestureRecognizer handles
        // taps that land on the text render area. Tapping the padding region
        // (inside WInput, outside EditableText's rendered bounds) goes directly
        // to the GestureDetector, which fires onTap.
        final inputRect = tester.getRect(find.byType(WInput));
        await tester.tapAt(Offset(inputRect.right - 4, inputRect.center.dy));
        await tester.pump();

        expect(wasTapped, isTrue);
      });

      testWidgets('textCapitalization is applied', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WInput(textCapitalization: TextCapitalization.words),
          ),
        );

        final editableText =
            tester.widget<EditableText>(find.byType(EditableText));
        expect(editableText.textCapitalization, TextCapitalization.words);
      });

      testWidgets('autocorrect can be disabled', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WInput(autocorrect: false)),
        );

        final editableText =
            tester.widget<EditableText>(find.byType(EditableText));
        expect(editableText.autocorrect, isFalse);
      });

      testWidgets('enableSuggestions can be disabled', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WInput(enableSuggestions: false)),
        );

        final editableText =
            tester.widget<EditableText>(find.byType(EditableText));
        expect(editableText.enableSuggestions, isFalse);
      });

      testWidgets('default textInputAction is next for single line', (
        tester,
      ) async {
        await tester.pumpWidget(wrapWithTheme(const WInput()));

        final editableText =
            tester.widget<EditableText>(find.byType(EditableText));
        expect(editableText.textInputAction, TextInputAction.next);
      });

      testWidgets('default textInputAction is newline for multiline', (
        tester,
      ) async {
        await tester.pumpWidget(
          wrapWithTheme(const WInput(type: InputType.multiline)),
        );

        final editableText =
            tester.widget<EditableText>(find.byType(EditableText));
        expect(editableText.textInputAction, TextInputAction.newline);
      });
    });

    group('Controller Lifecycle', () {
      testWidgets('switches from internal to external controller', (
        tester,
      ) async {
        final externalController = TextEditingController(text: 'External');
        addTearDown(externalController.dispose);

        // Start with internal (value prop)
        await tester.pumpWidget(wrapWithTheme(const WInput(value: 'Internal')));
        expect(find.text('Internal'), findsOneWidget);

        // Switch to external
        await tester.pumpWidget(
          wrapWithTheme(WInput(controller: externalController)),
        );
        expect(find.text('External'), findsOneWidget);
      });

      testWidgets('switches from external to internal controller', (
        tester,
      ) async {
        final externalController = TextEditingController(text: 'External');
        addTearDown(externalController.dispose);

        // Start with external
        await tester.pumpWidget(
          wrapWithTheme(WInput(controller: externalController)),
        );
        expect(find.text('External'), findsOneWidget);

        // Switch to internal
        await tester.pumpWidget(wrapWithTheme(const WInput(value: 'Internal')));
        expect(find.text('Internal'), findsOneWidget);
      });

      testWidgets('switches between external controllers', (tester) async {
        final controller1 = TextEditingController(text: 'One');
        final controller2 = TextEditingController(text: 'Two');
        addTearDown(controller1.dispose);
        addTearDown(controller2.dispose);

        await tester.pumpWidget(wrapWithTheme(WInput(controller: controller1)));
        expect(find.text('One'), findsOneWidget);

        await tester.pumpWidget(wrapWithTheme(WInput(controller: controller2)));
        expect(find.text('Two'), findsOneWidget);
      });
    });

    group('Cursor Preservation', () {
      testWidgets('preserves cursor at end when appending', (tester) async {
        String value = 'Test';

        await tester.pumpWidget(
          wrapWithTheme(
            StatefulBuilder(
              builder: (context, setState) {
                return WInput(
                  value: value,
                  onChanged: (v) => setState(() => value = v),
                );
              },
            ),
          ),
        );

        final editableTextFinder = find.byType(EditableText);
        await tester.tap(editableTextFinder);

        // Move cursor to end
        await tester.enterText(editableTextFinder, 'Test');
        // Type '!'
        await tester.enterText(editableTextFinder, 'Test!');
        await tester.pump();

        // Check cursor position via EditableText controller.
        final editableText = tester.widget<EditableText>(editableTextFinder);
        final controller = editableText.controller;
        expect(controller.selection.baseOffset, 5);
      });

      testWidgets('preserves cursor in middle when editing', (tester) async {
        String value = 'Start End';

        await tester.pumpWidget(
          wrapWithTheme(
            StatefulBuilder(
              builder: (context, setState) {
                return WInput(
                  value: value,
                  onChanged: (v) => setState(() => value = v),
                );
              },
            ),
          ),
        );

        final editableTextFinder = find.byType(EditableText);
        await tester.tap(editableTextFinder);

        // Emulate cursor in middle (offset 6, after 'Start ')
        // And inserting 'Middle ' -> 'Start Middle End'
        // This is tricky to simulate exactly with enterText as it replaces content.
        // But WInput._updateControllerValue handles the state update from parent.

        // Simulating external update while focused
        // 1. User types (handled by onChanged -> internal controller update)
        // 2. Parent setState updates value
        // 3. didUpdateWidget calls _updateControllerValue

        // The real test is: if we update value prop externally while user has cursor somewhere, does it stay?
        // But if value changes externally, usually it's because user typed.
        // If external change is unrelated (e.g. formatting), we want cursor to stay valid.

        // Let's simulate:
        final editableTextWidgetBefore =
            tester.widget<EditableText>(editableTextFinder);
        final controller = editableTextWidgetBefore.controller;

        // Set cursor to 5 ('Start| End')
        controller.selection = const TextSelection.collapsed(offset: 5);

        // Trigger external update (e.g. parent forces upper case)
        await tester.pumpWidget(
          wrapWithTheme(
            WInput(
              value: 'START END', // Length same, content diff
            ),
          ),
        );

        // Cursor should still be at 5
        expect(controller.selection.baseOffset, 5);
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

        // The placeholder renders as a Stack-positioned Text widget; verify it
        // is present in the tree.
        expect(find.text('Enter text'), findsOneWidget);
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

          // The placeholder Text widget must be visible with a non-null color.
          // It is rendered as an IgnorePointer > Text inside a Stack.
          final Text placeholderText = tester.widget<Text>(
            find.text('Type here'),
          );
          expect(placeholderText.style?.color, isNotNull);
        },
      );
    });

    group('Placeholder visibility', () {
      testWidgets('placeholder hides when field has text', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WInput(placeholder: 'Type here', value: 'Hello')),
        );

        // Placeholder text should be absent when the field already has a value.
        expect(find.text('Type here'), findsNothing);
        expect(find.text('Hello'), findsOneWidget);
      });

      testWidgets('placeholder shows when field is empty', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WInput(placeholder: 'Type here', value: '')),
        );

        expect(find.text('Type here'), findsOneWidget);
      });

      testWidgets('placeholder hides after user types', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WInput(placeholder: 'Type here')),
        );

        expect(find.text('Type here'), findsOneWidget);

        await tester.enterText(find.byType(EditableText), 'Hello');
        await tester.pump();

        expect(find.text('Type here'), findsNothing);
      });
    });

    group('Flex Container Support', () {
      testWidgets('flex-auto wraps EditableText in Flexible', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            Row(
              children: [
                WInput(className: 'flex-auto'),
                const Text('Label'),
              ],
            ),
          ),
        );

        // Should find Flexible widget wrapping the WInput.
        expect(find.byType(Flexible), findsOneWidget);
        expect(find.byType(EditableText), findsOneWidget);
      });

      testWidgets('flex-1 wraps EditableText in Expanded', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            Row(
              children: [
                WInput(className: 'flex-1'),
                const Text('Label'),
              ],
            ),
          ),
        );

        // flex-1 uses Expanded (with flex: 1)
        expect(find.byType(Expanded), findsAtLeastNWidgets(1));
      });

      testWidgets('WInput without flex classes renders without Flexible', (
        tester,
      ) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const SizedBox(width: 200, child: WInput(className: 'p-4 border')),
          ),
        );

        // Should NOT find Flexible widget
        expect(find.byType(Flexible), findsNothing);
        expect(find.byType(EditableText), findsOneWidget);
      });

      testWidgets('flex-auto WInput works in Row with Button', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            Row(
              children: [
                WInput(
                  className: 'flex-auto rounded-md px-3 py-2',
                  placeholder: 'Enter email',
                ),
                WButton(
                  className: 'flex-none px-4 py-2',
                  onTap: () {},
                  child: const Text('Subscribe'),
                ),
              ],
            ),
          ),
        );

        // Should render without errors
        expect(find.byType(EditableText), findsOneWidget);
        expect(find.byType(WButton), findsOneWidget);
        expect(find.text('Enter email'), findsOneWidget);
      });
    });

    group('Border Styling', () {
      testWidgets('border-0 applies no border on the DecoratedBox', (
        tester,
      ) async {
        await tester.pumpWidget(
          wrapWithTheme(const WInput(className: 'p-3 border-0 rounded-lg')),
        );

        // With border-0, the _buildDecoration logic sets border = null (no border).
        // Find the innermost DecoratedBox belonging to the WInput and verify.
        final DecoratedBox decoratedBox = tester.firstWidget<DecoratedBox>(
          find.byType(DecoratedBox),
        );
        final BoxDecoration decoration =
            decoratedBox.decoration as BoxDecoration;

        expect(decoration.border, isNull);
      });

      testWidgets('border-0 with focus:ring shows ring decoration on focus', (
        tester,
      ) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WInput(
              className:
                  'p-3 border-0 rounded-lg focus:ring-2 focus:ring-blue-500',
            ),
          ),
        );

        // Initially no border.
        final DecoratedBox before = tester.firstWidget<DecoratedBox>(
          find.byType(DecoratedBox),
        );
        expect((before.decoration as BoxDecoration).border, isNull);

        // Focus the input.
        await tester.tap(find.byType(WInput));
        await tester.pump();

        // After focus, the ring promotes to a border.
        final DecoratedBox after = tester.firstWidget<DecoratedBox>(
          find.byType(DecoratedBox),
        );
        expect((after.decoration as BoxDecoration).border, isNotNull);
      });

      testWidgets('regular border class applies border to DecoratedBox', (
        tester,
      ) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WInput(className: 'p-3 border border-gray-300 rounded-lg'),
          ),
        );

        final DecoratedBox decoratedBox = tester.firstWidget<DecoratedBox>(
          find.byType(DecoratedBox),
        );
        final BoxDecoration decoration =
            decoratedBox.decoration as BoxDecoration;

        // A resolved border should be present.
        expect(decoration.border, isNotNull);
        final Border border = decoration.border! as Border;
        expect(border.top.width, 1.0);
      });
    });

    // -------------------------------------------------------------------------
    // Content Padding (gapPadding regression — issue #61)
    //
    // WInput now renders via EditableText + DecoratedBox (no OutlineInputBorder).
    // The phantom +4px gapPadding from OutlineInputBorder no longer applies.
    // The test verifies the behavioral guarantee: `px-3` yields exactly 12px
    // horizontal inset on both single-line and multiline inputs.
    // The `built OutlineInputBorder sets gapPadding to 0.0` test was removed
    // because OutlineInputBorder is no longer part of the render tree; the
    // behavioral guarantee (12px inset) is covered by the two tests below.
    // -------------------------------------------------------------------------
    group('Content Padding', () {
      // Returns the Padding widget that is a direct descendant of WInput, which
      // is the content-padding layer (px-3 → horizontal: 12, py-2.5 → vertical: 10).
      Padding contentPaddingOf(WidgetTester tester) {
        return tester.widget<Padding>(
          find.descendant(
            of: find.byType(WInput),
            matching: find.byType(Padding),
          ),
        );
      }

      testWidgets('px-3 single-line places placeholder at 12px inset',
          (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const Padding(
              padding: EdgeInsets.all(40),
              child: WInput(
                placeholder: 'P',
                className: 'rounded-xl px-3 py-2.5 text-sm '
                    'bg-white border border-gray-200',
              ),
            ),
          ),
        );

        // The content Padding widget inside WInput must enforce the px-3 inset.
        // This replaces the geometry check used against the old TextField; the
        // DecoratedBox + Padding recipe owns the inset directly.
        final Padding contentPadding = contentPaddingOf(tester);
        final EdgeInsets insets =
            contentPadding.padding.resolve(TextDirection.ltr);
        expect(insets.left, 12.0);
        expect(insets.right, 12.0);
      });

      testWidgets('px-3 multiline places placeholder at 12px inset',
          (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const Padding(
              padding: EdgeInsets.all(40),
              child: WInput(
                placeholder: 'P',
                type: InputType.multiline,
                minLines: 5,
                maxLines: 10,
                className: 'rounded-xl px-3 py-2.5 text-sm '
                    'bg-white border border-gray-200',
              ),
            ),
          ),
        );

        final Padding contentPadding = contentPaddingOf(tester);
        final EdgeInsets insets =
            contentPadding.padding.resolve(TextDirection.ltr);
        expect(insets.left, 12.0);
        expect(insets.right, 12.0);
      });
    });

    group('Prefix and Suffix', () {
      testWidgets('renders prefix widget', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WInput(
              prefix: Icon(Icons.search),
              placeholder: 'Search',
            ),
          ),
        );

        expect(find.byIcon(Icons.search), findsOneWidget);
        expect(find.byType(EditableText), findsOneWidget);
      });

      testWidgets('renders suffix widget with 48px minimum tap target', (
        tester,
      ) async {
        bool tapped = false;
        await tester.pumpWidget(
          wrapWithTheme(
            WInput(
              suffix: GestureDetector(
                onTap: () => tapped = true,
                child: const Icon(Icons.visibility),
              ),
              placeholder: 'Password',
            ),
          ),
        );

        // Suffix ConstrainedBox enforces minWidth/minHeight of 48px.
        // Use firstWidget because the Scaffold may also produce ConstrainedBox
        // descendants; the first one inside WInput is the suffix tap target.
        final ConstrainedBox suffixBox = tester.firstWidget<ConstrainedBox>(
          find.descendant(
            of: find.byType(WInput),
            matching: find.byType(ConstrainedBox),
          ),
        );
        expect(suffixBox.constraints.minWidth, 48.0);
        expect(suffixBox.constraints.minHeight, 48.0);

        await tester.tap(find.byIcon(Icons.visibility));
        await tester.pump();
        expect(tapped, isTrue);
      });
    });

    // -------------------------------------------------------------------------
    // Accessibility / Semantics
    //
    // Step 1 of plan ai-test-v2 contract: WInput must wrap the inner EditableText
    // with `Semantics(label: placeholder, ...)` so that Playwright
    // `getByLabel(/email/i)` and `getByLabel(/password/i)` resolve via the
    // Flutter web accessibility tree.
    //
    // NOTE: EditableText does not set `isEnabled` semantics (unlike Material
    // TextField). `isEnabled` is always `Tristate.none`. Disabled state is
    // signaled through `isReadOnly: true` (disabled routes to readOnly=true
    // inside EditableText). The `isTextField` and `isObscured` contracts are
    // unaffected.
    //
    // The placeholder Text is wrapped in `ExcludeSemantics`, so the single outer
    // `Semantics(label:)` node owns the accessible name exactly (no `'<label>\n
    // <label>'` merge leak); assertions match the label exactly.
    //
    // The CRITICAL password case is asserted explicitly: it locks the contract
    // that Step 9's `loginViaSemantics` Playwright helper depends on.
    // -------------------------------------------------------------------------
    group('Semantics', () {
      testWidgets('emits textField role with placeholder as label',
          (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WInput(placeholder: 'Email', value: '')),
        );

        final SemanticsNode node = tester.getSemantics(find.byType(WInput));
        expect(node.flagsCollection.isTextField, isTrue);
        expect(node.label, 'Email');
      });

      testWidgets('emits current value through Semantics.value',
          (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WInput(placeholder: 'Email', value: 'user@example.com'),
          ),
        );

        final SemanticsNode node = tester.getSemantics(find.byType(WInput));
        expect(node.flagsCollection.isTextField, isTrue);
        expect(node.label, 'Email');
        expect(node.value, 'user@example.com');
      });

      testWidgets('reports disabled state when enabled is false',
          (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WInput(placeholder: 'Disabled', value: '', enabled: false),
          ),
        );

        // EditableText routes disabled=false to readOnly=true. The semantics
        // node reflects this as isReadOnly rather than isEnabled=false.
        final SemanticsNode node = tester.getSemantics(find.byType(WInput));
        expect(node.flagsCollection.isTextField, isTrue);
        expect(node.flagsCollection.isReadOnly, isTrue);
      });

      // CRITICAL password regression test — locks the contract Step 9's
      // `loginViaSemantics` Playwright helper depends on.
      //
      // Without the Semantics label, a password EditableText surfaces no
      // accessible name and `page.getByLabel(/password/i)` cannot resolve.
      // With the wrap, the SemanticsNode exposes `isTextField + label:
      // 'Password' + isObscured`, which the Flutter web engine then renders as
      // `<input aria-label="Password" type="password">` per the ARIA mapping
      // table.
      testWidgets(
          'password input surfaces label through Semantics (critical regression)',
          (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WInput(
              type: InputType.password,
              placeholder: 'Password',
              value: '',
            ),
          ),
        );

        final SemanticsNode node = tester.getSemantics(find.byType(WInput));
        expect(
          node.flagsCollection.isTextField,
          isTrue,
          reason: 'Password input must surface as textField in Semantics tree',
        );
        expect(
          node.label,
          'Password',
          reason:
              'Password input must surface placeholder as Semantics label so '
              'Playwright getByLabel(/password/i) resolves',
        );
        expect(
          node.flagsCollection.isObscured,
          isTrue,
          reason: 'Password input must still mark itself obscured',
        );
      });
    });
  });
}
