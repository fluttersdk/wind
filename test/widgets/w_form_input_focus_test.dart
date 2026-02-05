import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

void main() {
  group('WFormInput FocusNode', () {
    testWidgets('passes focusNode to underlying TextField', (tester) async {
      final focusNode = FocusNode();

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

      // Find TextField and verify it has the focusNode
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.focusNode, equals(focusNode));

      focusNode.dispose();
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

      // Find TextField and verify it has a focusNode (internally created)
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.focusNode, isNotNull);
    });

    testWidgets('focusNode receives focus when requested', (tester) async {
      final focusNode = FocusNode();

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

      focusNode.dispose();
    });
  });
}
