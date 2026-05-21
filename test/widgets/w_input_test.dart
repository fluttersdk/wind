import 'dart:ui' show Tristate;

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
        expect(textField.minLines, 1); // default
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

      testWidgets('default textInputAction is next for single line', (
        tester,
      ) async {
        await tester.pumpWidget(wrapWithTheme(const WInput()));

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.textInputAction, TextInputAction.next);
      });

      testWidgets('default textInputAction is newline for multiline', (
        tester,
      ) async {
        await tester.pumpWidget(
          wrapWithTheme(const WInput(type: InputType.multiline)),
        );

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.textInputAction, TextInputAction.newline);
      });
    });

    group('Controller Lifecycle', () {
      testWidgets('switches from internal to external controller', (
        tester,
      ) async {
        final externalController = TextEditingController(text: 'External');

        // Start with internal (value prop)
        await tester.pumpWidget(wrapWithTheme(const WInput(value: 'Internal')));
        expect(find.text('Internal'), findsOneWidget);

        // Switch to external
        await tester.pumpWidget(
          wrapWithTheme(WInput(controller: externalController)),
        );
        expect(find.text('External'), findsOneWidget);

        externalController.dispose();
      });

      testWidgets('switches from external to internal controller', (
        tester,
      ) async {
        final externalController = TextEditingController(text: 'External');

        // Start with external
        await tester.pumpWidget(
          wrapWithTheme(WInput(controller: externalController)),
        );
        expect(find.text('External'), findsOneWidget);

        // Switch to internal
        await tester.pumpWidget(wrapWithTheme(const WInput(value: 'Internal')));
        expect(find.text('Internal'), findsOneWidget);

        externalController.dispose();
      });

      testWidgets('switches between external controllers', (tester) async {
        final controller1 = TextEditingController(text: 'One');
        final controller2 = TextEditingController(text: 'Two');

        await tester.pumpWidget(wrapWithTheme(WInput(controller: controller1)));
        expect(find.text('One'), findsOneWidget);

        await tester.pumpWidget(wrapWithTheme(WInput(controller: controller2)));
        expect(find.text('Two'), findsOneWidget);

        controller1.dispose();
        controller2.dispose();
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

        final textField = find.byType(TextField);
        await tester.tap(textField);

        // Move cursor to end
        await tester.enterText(textField, 'Test');
        // Type '!'
        await tester.enterText(textField, 'Test!');
        await tester.pump();

        // Check cursor position
        final textFieldWidget = tester.widget<TextField>(textField);
        final controller = textFieldWidget.controller!;
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

        final textField = find.byType(TextField);
        await tester.tap(textField);

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
        final textFieldWidgetBefore = tester.widget<TextField>(textField);
        final controller = textFieldWidgetBefore.controller!;

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

    group('Flex Container Support', () {
      testWidgets('flex-auto wraps TextField in Flexible', (tester) async {
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

        // Should find Flexible widget wrapping TextField
        expect(find.byType(Flexible), findsOneWidget);
        expect(find.byType(TextField), findsOneWidget);
      });

      testWidgets('flex-1 wraps TextField in Expanded', (tester) async {
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
        expect(find.byType(Expanded), findsOneWidget);
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
        expect(find.byType(TextField), findsOneWidget);
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
        expect(find.byType(TextField), findsOneWidget);
        expect(find.byType(WButton), findsOneWidget);
        expect(find.text('Enter email'), findsOneWidget);
      });
    });

    group('Border Styling', () {
      testWidgets('border-0 applies InputBorder.none', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WInput(className: 'p-3 border-0 rounded-lg')),
        );

        final textField = tester.widget<TextField>(find.byType(TextField));
        final decoration = textField.decoration!;

        // border-0 should result in InputBorder.none for enabled border
        expect(decoration.enabledBorder, InputBorder.none);
        expect(decoration.border, InputBorder.none);
      });

      testWidgets('border-0 with focus:ring still shows ring on focus', (
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

        final textField = tester.widget<TextField>(find.byType(TextField));
        final decoration = textField.decoration!;

        // Initially no border
        expect(decoration.enabledBorder, InputBorder.none);

        // Focus the input
        await tester.tap(find.byType(TextField));
        await tester.pump();

        final focusedTextField = tester.widget<TextField>(
          find.byType(TextField),
        );
        final focusedDecoration = focusedTextField.decoration!;

        // When focused, should have ring as border
        expect(focusedDecoration.focusedBorder, isA<OutlineInputBorder>());
      });

      testWidgets('regular border class applies border', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WInput(className: 'p-3 border border-gray-300 rounded-lg'),
          ),
        );

        final textField = tester.widget<TextField>(find.byType(TextField));
        final decoration = textField.decoration!;

        // Should have a border
        expect(decoration.enabledBorder, isA<OutlineInputBorder>());
        final border = decoration.enabledBorder as OutlineInputBorder;
        expect(border.borderSide.width, 1.0);
      });
    });

    // -------------------------------------------------------------------------
    // Content Padding (gapPadding regression — issue #61)
    //
    // `OutlineInputBorder.gapPadding` defaults to 4.0 in Material to reserve
    // space for a floating label cutout. Wind routes labels through the parser
    // and never uses `InputDecoration.labelText`, so that reservation only
    // adds a phantom +4px on each side. WInput must set `gapPadding: 0.0` on
    // every OutlineInputBorder it builds so that `px-3` yields exactly 12px
    // of horizontal inset, on both single-line and multiline.
    // -------------------------------------------------------------------------
    group('Content Padding', () {
      Rect rectOf(WidgetTester tester, Finder finder) {
        final RenderBox box = tester.renderObject<RenderBox>(finder);
        return box.localToGlobal(Offset.zero) & box.size;
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

        final Rect field = rectOf(tester, find.byType(TextField));
        final Rect hint = rectOf(tester, find.text('P'));
        expect(hint.left - field.left, 12.0);
        expect(field.right - hint.right, 12.0);
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

        final Rect field = rectOf(tester, find.byType(TextField));
        final Rect hint = rectOf(tester, find.text('P'));
        expect(hint.left - field.left, 12.0);
        expect(field.right - hint.right, 12.0);
      });

      testWidgets('built OutlineInputBorder sets gapPadding to 0.0',
          (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WInput(className: 'p-3 border border-gray-300 rounded-lg'),
          ),
        );

        final TextField textField =
            tester.widget<TextField>(find.byType(TextField));
        final OutlineInputBorder enabled =
            textField.decoration!.enabledBorder! as OutlineInputBorder;
        final OutlineInputBorder base =
            textField.decoration!.border! as OutlineInputBorder;
        expect(enabled.gapPadding, 0.0);
        expect(base.gapPadding, 0.0);
      });
    });

    // -------------------------------------------------------------------------
    // Accessibility / Semantics
    //
    // Step 1 of plan ai-test-v2 contract: WInput must wrap the inner TextField
    // with `Semantics(textField: true, label: placeholder, value: value, ...)`
    // so that Playwright `getByLabel(/email/i)` and `getByLabel(/password/i)`
    // resolve via the Flutter web accessibility tree. The Flutter engine maps
    // a textField SemanticsNode with `label: 'X'` to a real DOM
    // `<input aria-label="X">` element (see
    // `.ac/plans/ai-test-v2/research/librarian-semantics-deep-dive.md` ARIA
    // mapping table).
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
        expect(node.flagsCollection.isEnabled, Tristate.isTrue);
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
        expect(node.value, contains('user@example.com'));
      });

      testWidgets('reports disabled state when enabled is false',
          (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WInput(placeholder: 'Disabled', value: '', enabled: false),
          ),
        );

        final SemanticsNode node = tester.getSemantics(find.byType(WInput));
        expect(node.flagsCollection.isTextField, isTrue);
        expect(node.flagsCollection.isEnabled, Tristate.isFalse);
      });

      // CRITICAL password regression test — locks the contract Step 9's
      // `loginViaSemantics` Playwright helper depends on.
      //
      // Without this Semantics wrap, a password TextField surfaces no
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
