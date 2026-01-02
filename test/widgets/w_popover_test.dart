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
  group('WPopover Widget Tests', () {
    group('Basic Rendering', () {
      testWidgets('renders trigger widget', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WPopover(
              triggerBuilder: (context, isOpen, isHovering) =>
                  const Text('Open Menu'),
              contentBuilder: (context, close) => const Text('Content'),
            ),
          ),
        );

        expect(find.text('Open Menu'), findsOneWidget);
      });

      testWidgets('receives isOpen state in trigger builder', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WPopover(
              triggerBuilder: (context, isOpen, isHovering) =>
                  Text(isOpen ? 'Close' : 'Open'),
              contentBuilder: (context, close) => const Text('Content'),
            ),
          ),
        );

        expect(find.text('Open'), findsOneWidget);

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('Close'), findsOneWidget);
      });

      testWidgets('receives isHovering state in trigger builder', (
        tester,
      ) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WPopover(
              triggerBuilder: (context, isOpen, isHovering) =>
                  Text(isHovering ? 'Hovering' : 'Not Hovering'),
              contentBuilder: (context, close) => const Text('Content'),
            ),
          ),
        );

        expect(find.text('Not Hovering'), findsOneWidget);
      });
    });

    group('Open/Close Behavior', () {
      testWidgets('opens popover on tap', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WPopover(
              triggerBuilder: (context, isOpen, isHovering) =>
                  const Text('Trigger'),
              contentBuilder: (context, close) =>
                  const SizedBox(height: 100, child: Text('Popover Content')),
            ),
          ),
        );

        // Initially closed
        expect(find.text('Popover Content'), findsNothing);

        // Tap to open
        await tester.tap(find.text('Trigger'));
        await tester.pumpAndSettle();

        // Now visible
        expect(find.text('Popover Content'), findsOneWidget);
      });

      testWidgets('closes popover on second tap', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WPopover(
              triggerBuilder: (context, isOpen, isHovering) =>
                  const Text('Trigger'),
              contentBuilder: (context, close) =>
                  const SizedBox(height: 100, child: Text('Content')),
            ),
          ),
        );

        // Open
        await tester.tap(find.text('Trigger'));
        await tester.pumpAndSettle();
        expect(find.text('Content'), findsOneWidget);

        // Close
        await tester.tap(find.text('Trigger'));
        await tester.pumpAndSettle();
        expect(find.text('Content'), findsNothing);
      });

      testWidgets('closes popover on tap outside', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            Center(
              child: WPopover(
                triggerBuilder: (context, isOpen, isHovering) =>
                    const Text('Trigger'),
                contentBuilder: (context, close) =>
                    const SizedBox(height: 100, child: Text('Content')),
              ),
            ),
          ),
        );

        // Open
        await tester.tap(find.text('Trigger'));
        await tester.pumpAndSettle();
        expect(find.text('Content'), findsOneWidget);

        // Tap outside (top-left corner of screen)
        await tester.tapAt(const Offset(10, 10));
        await tester.pumpAndSettle();

        expect(find.text('Content'), findsNothing);
      });

      testWidgets('close callback works from content', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WPopover(
              triggerBuilder: (context, isOpen, isHovering) =>
                  const Text('Trigger'),
              contentBuilder: (context, close) => GestureDetector(
                onTap: close,
                child: const SizedBox(height: 100, child: Text('Close Me')),
              ),
            ),
          ),
        );

        // Open
        await tester.tap(find.text('Trigger'));
        await tester.pumpAndSettle();
        expect(find.text('Close Me'), findsOneWidget);

        // Close via content
        await tester.tap(find.text('Close Me'));
        await tester.pumpAndSettle();
        expect(find.text('Close Me'), findsNothing);
      });
    });

    group('Disabled State', () {
      testWidgets('does not open when disabled', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WPopover(
              disabled: true,
              triggerBuilder: (context, isOpen, isHovering) =>
                  const Text('Trigger'),
              contentBuilder: (context, close) => const Text('Content'),
            ),
          ),
        );

        await tester.tap(find.text('Trigger'));
        await tester.pumpAndSettle();

        expect(find.text('Content'), findsNothing);
      });
    });

    group('closeOnContentTap', () {
      testWidgets('closes on content tap when enabled', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WPopover(
              closeOnContentTap: true,
              triggerBuilder: (context, isOpen, isHovering) =>
                  const Text('Trigger'),
              contentBuilder: (context, close) => const SizedBox(
                width: 100,
                height: 100,
                child: Text('Content'),
              ),
            ),
          ),
        );

        // Open
        await tester.tap(find.text('Trigger'));
        await tester.pumpAndSettle();
        expect(find.text('Content'), findsOneWidget);

        // Tap on content
        await tester.tap(find.text('Content'));
        await tester.pumpAndSettle();

        expect(find.text('Content'), findsNothing);
      });
    });

    group('Styling', () {
      testWidgets('applies className to popover container', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WPopover(
              className: 'w-64 bg-blue-500 rounded-lg p-4',
              triggerBuilder: (context, isOpen, isHovering) =>
                  const Text('Trigger'),
              contentBuilder: (context, close) =>
                  const SizedBox(height: 50, child: Text('Styled')),
            ),
          ),
        );

        await tester.tap(find.text('Trigger'));
        await tester.pumpAndSettle();

        // Widget renders with styling
        expect(find.text('Styled'), findsOneWidget);
        expect(find.byType(WDiv), findsWidgets);
      });

      testWidgets('uses default styling when no className', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WPopover(
              triggerBuilder: (context, isOpen, isHovering) =>
                  const Text('Trigger'),
              contentBuilder: (context, close) =>
                  const SizedBox(height: 50, child: Text('Default')),
            ),
          ),
        );

        await tester.tap(find.text('Trigger'));
        await tester.pumpAndSettle();

        expect(find.text('Default'), findsOneWidget);
      });
    });

    group('Alignment', () {
      testWidgets('popover renders with bottomLeft alignment', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            Center(
              child: WPopover(
                alignment: PopoverAlignment.bottomLeft,
                triggerBuilder: (context, isOpen, isHovering) => Container(
                  width: 100,
                  height: 50,
                  color: Colors.grey,
                  child: const Text('Trigger'),
                ),
                contentBuilder: (context, close) =>
                    const SizedBox(height: 100, child: Text('Bottom Left')),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Trigger'));
        await tester.pumpAndSettle();

        expect(find.text('Bottom Left'), findsOneWidget);
      });

      testWidgets('popover renders with topCenter alignment', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            Center(
              child: WPopover(
                alignment: PopoverAlignment.topCenter,
                triggerBuilder: (context, isOpen, isHovering) => Container(
                  width: 100,
                  height: 50,
                  color: Colors.grey,
                  child: const Text('Trigger'),
                ),
                contentBuilder: (context, close) =>
                    const SizedBox(height: 100, child: Text('Top Center')),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Trigger'));
        await tester.pumpAndSettle();

        expect(find.text('Top Center'), findsOneWidget);
      });
    });

    group('maxHeight', () {
      testWidgets('respects maxHeight constraint', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WPopover(
              maxHeight: 100,
              triggerBuilder: (context, isOpen, isHovering) =>
                  const Text('Trigger'),
              contentBuilder: (context, close) => const SingleChildScrollView(
                child: SizedBox(height: 500, child: Text('Tall Content')),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Trigger'));
        await tester.pumpAndSettle();

        expect(find.text('Tall Content'), findsOneWidget);

        // Find ConstrainedBox with maxHeight
        final constrainedBox = tester.widget<ConstrainedBox>(
          find
              .ancestor(
                of: find.byType(WDiv),
                matching: find.byType(ConstrainedBox),
              )
              .first,
        );
        expect(constrainedBox.constraints.maxHeight, 100);
      });
    });

    group('offset', () {
      testWidgets('applies custom offset', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WPopover(
              offset: const Offset(10, 20),
              triggerBuilder: (context, isOpen, isHovering) =>
                  const Text('Trigger'),
              contentBuilder: (context, close) =>
                  const SizedBox(height: 50, child: Text('Offset Content')),
            ),
          ),
        );

        await tester.tap(find.text('Trigger'));
        await tester.pumpAndSettle();

        expect(find.text('Offset Content'), findsOneWidget);
      });
    });
  });

  group('PopoverAlignment enum', () {
    test('has all expected values', () {
      expect(PopoverAlignment.values.length, 6);
      expect(PopoverAlignment.values, contains(PopoverAlignment.bottomLeft));
      expect(PopoverAlignment.values, contains(PopoverAlignment.bottomRight));
      expect(PopoverAlignment.values, contains(PopoverAlignment.bottomCenter));
      expect(PopoverAlignment.values, contains(PopoverAlignment.topLeft));
      expect(PopoverAlignment.values, contains(PopoverAlignment.topRight));
      expect(PopoverAlignment.values, contains(PopoverAlignment.topCenter));
    });
  });
}
