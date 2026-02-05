import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

void main() {
  group('WKeyboardActions', () {
    testWidgets('wraps child with KeyboardActions widget', (tester) async {
      final focusNode = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            child: Scaffold(
              body: WKeyboardActions(
                focusNodes: [focusNode],
                child: TextField(focusNode: focusNode),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(KeyboardActions), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);

      focusNode.dispose();
    });

    testWidgets('configures platform targeting to iOS', (tester) async {
      final focusNode = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            child: Scaffold(
              body: WKeyboardActions(
                focusNodes: [focusNode],
                platform: 'ios',
                child: TextField(focusNode: focusNode),
              ),
            ),
          ),
        ),
      );

      final keyboardActions = tester.widget<KeyboardActions>(
        find.byType(KeyboardActions),
      );
      expect(
        keyboardActions.config.keyboardActionsPlatform,
        equals(KeyboardActionsPlatform.IOS),
      );

      focusNode.dispose();
    });

    testWidgets('configures platform targeting to Android', (tester) async {
      final focusNode = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            child: Scaffold(
              body: WKeyboardActions(
                focusNodes: [focusNode],
                platform: 'android',
                child: TextField(focusNode: focusNode),
              ),
            ),
          ),
        ),
      );

      final keyboardActions = tester.widget<KeyboardActions>(
        find.byType(KeyboardActions),
      );
      expect(
        keyboardActions.config.keyboardActionsPlatform,
        equals(KeyboardActionsPlatform.ANDROID),
      );

      focusNode.dispose();
    });

    testWidgets('defaults to all platforms', (tester) async {
      final focusNode = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            child: Scaffold(
              body: WKeyboardActions(
                focusNodes: [focusNode],
                child: TextField(focusNode: focusNode),
              ),
            ),
          ),
        ),
      );

      final keyboardActions = tester.widget<KeyboardActions>(
        find.byType(KeyboardActions),
      );
      expect(
        keyboardActions.config.keyboardActionsPlatform,
        equals(KeyboardActionsPlatform.ALL),
      );

      focusNode.dispose();
    });

    testWidgets('enables nextFocus navigation by default', (tester) async {
      final node1 = FocusNode();
      final node2 = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            child: Scaffold(
              body: WKeyboardActions(
                focusNodes: [node1, node2],
                child: Column(
                  children: [
                    TextField(focusNode: node1),
                    TextField(focusNode: node2),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      final keyboardActions = tester.widget<KeyboardActions>(
        find.byType(KeyboardActions),
      );
      expect(keyboardActions.config.nextFocus, isTrue);

      node1.dispose();
      node2.dispose();
    });

    testWidgets('disables nextFocus when set to false', (tester) async {
      final focusNode = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            child: Scaffold(
              body: WKeyboardActions(
                focusNodes: [focusNode],
                nextFocus: false,
                child: TextField(focusNode: focusNode),
              ),
            ),
          ),
        ),
      );

      final keyboardActions = tester.widget<KeyboardActions>(
        find.byType(KeyboardActions),
      );
      expect(keyboardActions.config.nextFocus, isFalse);

      focusNode.dispose();
    });

    testWidgets('creates KeyboardActionsItem for each focusNode',
        (tester) async {
      final node1 = FocusNode();
      final node2 = FocusNode();
      final node3 = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            child: Scaffold(
              body: WKeyboardActions(
                focusNodes: [node1, node2, node3],
                child: Column(
                  children: [
                    TextField(focusNode: node1),
                    TextField(focusNode: node2),
                    TextField(focusNode: node3),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      final keyboardActions = tester.widget<KeyboardActions>(
        find.byType(KeyboardActions),
      );
      expect(keyboardActions.config.actions?.length, equals(3));

      node1.dispose();
      node2.dispose();
      node3.dispose();
    });

    testWidgets('applies toolbar color from className', (tester) async {
      final focusNode = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            child: Scaffold(
              body: WKeyboardActions(
                focusNodes: [focusNode],
                toolbarClassName: 'bg-gray-100',
                child: TextField(focusNode: focusNode),
              ),
            ),
          ),
        ),
      );

      final keyboardActions = tester.widget<KeyboardActions>(
        find.byType(KeyboardActions),
      );
      // Verify toolbar color is parsed from Wind className
      expect(keyboardActions.config.keyboardBarColor, isNotNull);

      focusNode.dispose();
    });
  });
}
