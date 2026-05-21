import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Helper to wrap widget in MaterialApp with WindTheme.
Widget wrapWithTheme(Widget child) {
  return MaterialApp(
    home: WindTheme(
      data: WindThemeData(),
      child: Scaffold(body: child),
    ),
  );
}

void main() {
  group('WKeyboardActions', () {
    testWidgets('wraps child with WKeyboardActions widget', (tester) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);

      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      try {
        await tester.pumpWidget(
          wrapWithTheme(
            WKeyboardActions(
              focusNodes: [focusNode],
              child: TextField(focusNode: focusNode),
            ),
          ),
        );

        expect(find.byType(WKeyboardActions), findsOneWidget);
        expect(find.byType(TextField), findsOneWidget);

        // The inline implementation is a StatefulWidget — when a focus node is
        // focused, it inserts a toolbar OverlayEntry above the keyboard.
        focusNode.requestFocus();
        await tester.pump(const Duration(milliseconds: 16));

        // The toolbar Done button (TextButton) must be present in the overlay.
        expect(
          find.descendant(
            of: find.byType(Overlay),
            matching: find.byType(TextButton),
          ),
          findsOneWidget,
        );
      } finally {
        debugDefaultTargetPlatformOverride = null;
      }
    });

    testWidgets('configures platform targeting to iOS', (tester) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);

      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      try {
        await tester.pumpWidget(
          wrapWithTheme(
            WKeyboardActions(
              focusNodes: [focusNode],
              platform: 'ios',
              child: TextField(focusNode: focusNode),
            ),
          ),
        );

        // Focus the field on iOS — toolbar should appear.
        focusNode.requestFocus();
        await tester.pump(const Duration(milliseconds: 16));

        expect(
          find.descendant(
            of: find.byType(Overlay),
            matching: find.byType(TextButton),
          ),
          findsOneWidget,
        );

        // Switch to Android — toolbar must disappear for an iOS-only config.
        debugDefaultTargetPlatformOverride = TargetPlatform.android;
        focusNode.unfocus();
        focusNode.requestFocus();
        await tester.pump(const Duration(milliseconds: 16));

        // The WKeyboardActions toolbar should NOT render on Android when
        // platform is 'ios' — assert no Done TextButton in the overlay.
        expect(
          find.descendant(
            of: find.byType(Overlay),
            matching: find.byType(TextButton),
          ),
          findsNothing,
        );
      } finally {
        debugDefaultTargetPlatformOverride = null;
      }
    });

    testWidgets('configures platform targeting to Android', (tester) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);

      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      try {
        await tester.pumpWidget(
          wrapWithTheme(
            WKeyboardActions(
              focusNodes: [focusNode],
              platform: 'android',
              child: TextField(focusNode: focusNode),
            ),
          ),
        );

        // Focus on Android — toolbar should appear.
        focusNode.requestFocus();
        await tester.pump(const Duration(milliseconds: 16));

        expect(
          find.descendant(
            of: find.byType(Overlay),
            matching: find.byType(TextButton),
          ),
          findsOneWidget,
        );

        // Switch to iOS — toolbar must disappear for an Android-only config.
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        focusNode.unfocus();
        focusNode.requestFocus();
        await tester.pump(const Duration(milliseconds: 16));

        // The WKeyboardActions toolbar should NOT render on iOS when
        // platform is 'android' — assert no Done TextButton in the overlay.
        expect(
          find.descendant(
            of: find.byType(Overlay),
            matching: find.byType(TextButton),
          ),
          findsNothing,
        );
      } finally {
        debugDefaultTargetPlatformOverride = null;
      }
    });

    testWidgets('defaults to all platforms', (tester) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);

      try {
        await tester.pumpWidget(
          wrapWithTheme(
            WKeyboardActions(
              focusNodes: [focusNode],
              child: TextField(focusNode: focusNode),
            ),
          ),
        );

        // iOS: toolbar appears.
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        focusNode.requestFocus();
        await tester.pump(const Duration(milliseconds: 16));

        expect(
          find.descendant(
            of: find.byType(Overlay),
            matching: find.byType(TextButton),
          ),
          findsOneWidget,
        );

        // Android: toolbar also appears.
        focusNode.unfocus();
        debugDefaultTargetPlatformOverride = TargetPlatform.android;
        focusNode.requestFocus();
        await tester.pump(const Duration(milliseconds: 16));

        expect(
          find.descendant(
            of: find.byType(Overlay),
            matching: find.byType(TextButton),
          ),
          findsOneWidget,
        );
      } finally {
        debugDefaultTargetPlatformOverride = null;
      }
    });

    testWidgets('enables nextFocus navigation by default', (tester) async {
      final node1 = FocusNode();
      final node2 = FocusNode();
      addTearDown(node1.dispose);
      addTearDown(node2.dispose);

      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      try {
        await tester.pumpWidget(
          wrapWithTheme(
            WKeyboardActions(
              focusNodes: [node1, node2],
              child: Column(
                children: [
                  TextField(focusNode: node1),
                  TextField(focusNode: node2),
                ],
              ),
            ),
          ),
        );

        // Focus the first node — it has a next neighbor but no prev neighbor.
        node1.requestFocus();
        await tester.pump(const Duration(milliseconds: 16));

        // The toolbar must contain at least one IconButton (next navigation).
        expect(
          find.descendant(
            of: find.byType(Overlay),
            matching: find.byType(IconButton),
          ),
          findsWidgets,
        );

        // The prev IconButton callback is null (disabled) because node1 is first.
        final prevButton = tester
            .widgetList<IconButton>(
              find.descendant(
                of: find.byType(Overlay),
                matching: find.byType(IconButton),
              ),
            )
            .first;
        expect(prevButton.onPressed, isNull);

        // The inline implementation uses TextButton (not InkWell) for Done.
        expect(
          find.descendant(
            of: find.byType(Overlay),
            matching: find.byType(TextButton),
          ),
          findsOneWidget,
        );
      } finally {
        debugDefaultTargetPlatformOverride = null;
      }
    });

    testWidgets('disables nextFocus when set to false', (tester) async {
      final node1 = FocusNode();
      final node2 = FocusNode();
      addTearDown(node1.dispose);
      addTearDown(node2.dispose);

      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      try {
        await tester.pumpWidget(
          wrapWithTheme(
            WKeyboardActions(
              focusNodes: [node1, node2],
              nextFocus: false,
              child: Column(
                children: [
                  TextField(focusNode: node1),
                  TextField(focusNode: node2),
                ],
              ),
            ),
          ),
        );

        node1.requestFocus();
        await tester.pump(const Duration(milliseconds: 16));

        // When nextFocus is false, no prev/next IconButton should render in the
        // toolbar overlay.
        expect(
          find.descendant(
            of: find.byType(Overlay),
            matching: find.byType(IconButton),
          ),
          findsNothing,
        );

        // The Done TextButton must still appear even when navigation is off.
        expect(
          find.descendant(
            of: find.byType(Overlay),
            matching: find.byType(TextButton),
          ),
          findsOneWidget,
        );
      } finally {
        debugDefaultTargetPlatformOverride = null;
      }
    });

    testWidgets('creates one toolbar entry per focusNode', (tester) async {
      final node1 = FocusNode();
      final node2 = FocusNode();
      final node3 = FocusNode();
      addTearDown(node1.dispose);
      addTearDown(node2.dispose);
      addTearDown(node3.dispose);

      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      try {
        await tester.pumpWidget(
          wrapWithTheme(
            WKeyboardActions(
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
        );

        // Focus the middle node — it has both prev and next neighbors.
        node2.requestFocus();
        await tester.pump(const Duration(milliseconds: 16));

        final buttons = tester
            .widgetList<IconButton>(
              find.descendant(
                of: find.byType(Overlay),
                matching: find.byType(IconButton),
              ),
            )
            .toList();

        // Both the prev and next IconButtons must be present and enabled.
        expect(buttons.length, greaterThanOrEqualTo(2));
        expect(buttons[0].onPressed, isNotNull); // prev
        expect(buttons[1].onPressed, isNotNull); // next

        // The inline implementation uses TextButton (not InkWell) for Done.
        expect(
          find.descendant(
            of: find.byType(Overlay),
            matching: find.byType(TextButton),
          ),
          findsOneWidget,
        );
      } finally {
        debugDefaultTargetPlatformOverride = null;
      }
    });

    testWidgets('applies toolbar color from className', (tester) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);

      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      try {
        await tester.pumpWidget(
          wrapWithTheme(
            WKeyboardActions(
              focusNodes: [focusNode],
              toolbarClassName: 'bg-gray-100',
              child: TextField(focusNode: focusNode),
            ),
          ),
        );

        focusNode.requestFocus();
        await tester.pump(const Duration(milliseconds: 16));

        // Find the toolbar Material inside the Overlay and verify its color is
        // set to the Wind-resolved gray (non-null).
        final toolbarMaterial = tester.widget<Material>(
          find
              .descendant(
                of: find.byType(Overlay),
                matching: find.byType(Material),
              )
              .first,
        );
        expect(toolbarMaterial.color, isNotNull);

        // The inline implementation uses TextButton (not InkWell) for Done,
        // confirming the toolbar is from the new self-contained implementation.
        expect(
          find.descendant(
            of: find.byType(Overlay),
            matching: find.byType(TextButton),
          ),
          findsOneWidget,
        );
      } finally {
        debugDefaultTargetPlatformOverride = null;
      }
    });
  });
}
