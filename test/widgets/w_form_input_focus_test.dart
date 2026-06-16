import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

void main() {
  setUp(WindParser.clearCache);

  group('WFormInput FocusNode', () {
    testWidgets('passes focusNode to underlying EditableText', (tester) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            child: Scaffold(
              body: Form(
                child: WFormInput(
                  focusNode: focusNode,
                  label: 'Test Input',
                ),
              ),
            ),
          ),
        ),
      );

      // Find EditableText and verify it has the focusNode
      final editableText =
          tester.widget<EditableText>(find.byType(EditableText));
      expect(editableText.focusNode, equals(focusNode));
    });

    testWidgets('creates internal focusNode when not provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            child: Scaffold(
              body: Form(
                child: WFormInput(label: 'Test Input'),
              ),
            ),
          ),
        ),
      );

      // Find EditableText and verify it has a focusNode (internally created)
      final editableText =
          tester.widget<EditableText>(find.byType(EditableText));
      expect(editableText.focusNode, isNotNull);
    });

    testWidgets('focusNode receives focus when requested', (tester) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            child: Scaffold(
              body: Form(
                child: WFormInput(
                  focusNode: focusNode,
                  label: 'Test Input',
                ),
              ),
            ),
          ),
        ),
      );

      // Initially not focused
      expect(focusNode.hasFocus, isFalse);

      // Request focus
      focusNode.requestFocus();
      await tester.pump();

      // Now should have focus
      expect(focusNode.hasFocus, isTrue);
    });
  });
}
