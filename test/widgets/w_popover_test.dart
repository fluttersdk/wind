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
    // Ensure overlay state is cleaned up between tests
    tearDown(() async {
      // Reset any lingering overlay state
      await Future<void>.delayed(Duration.zero);
    });

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

  group('Auto-Flip Boundary Detection', () {
    group('computeEffectiveAlignment', () {
      test('bottomLeft with plenty of space returns bottomLeft unchanged', () {
        final result = computeEffectiveAlignment(
          requested: PopoverAlignment.bottomLeft,
          triggerPosition: const Offset(50, 50),
          triggerSize: const Size(50, 30),
          popoverSize: const Size(100, 80),
          screenSize: const Size(400, 300),
          offset: const Offset(0, 4),
        );

        expect(result, PopoverAlignment.bottomLeft);
      });

      test('bottomRight where popover overflows left edge returns bottomLeft',
          () {
        final result = computeEffectiveAlignment(
          requested: PopoverAlignment.bottomRight,
          triggerPosition: const Offset(5, 50),
          triggerSize: const Size(20, 30),
          popoverSize: const Size(60, 80),
          screenSize: const Size(400, 300),
          offset: const Offset(0, 4),
        );

        expect(result, PopoverAlignment.bottomLeft);
      });

      test('bottomLeft where popover overflows bottom returns topLeft', () {
        final result = computeEffectiveAlignment(
          requested: PopoverAlignment.bottomLeft,
          triggerPosition: const Offset(50, 200),
          triggerSize: const Size(50, 30),
          popoverSize: const Size(100, 80),
          screenSize: const Size(400, 250),
          offset: const Offset(0, 4),
        );

        expect(result, PopoverAlignment.topLeft);
      });

      test(
          'bottomRight where popover overflows left and bottom returns topLeft',
          () {
        final result = computeEffectiveAlignment(
          requested: PopoverAlignment.bottomRight,
          triggerPosition: const Offset(0, 210),
          triggerSize: const Size(20, 30),
          popoverSize: const Size(80, 80),
          screenSize: const Size(200, 250),
          offset: const Offset(0, 4),
        );

        expect(result, PopoverAlignment.topLeft);
      });

      test('topLeft where popover overflows above returns bottomLeft', () {
        final result = computeEffectiveAlignment(
          requested: PopoverAlignment.topLeft,
          triggerPosition: const Offset(50, 10),
          triggerSize: const Size(50, 30),
          popoverSize: const Size(100, 40),
          screenSize: const Size(400, 300),
          offset: const Offset(0, 4),
        );

        expect(result, PopoverAlignment.bottomLeft);
      });

      test('topRight with plenty of space returns topRight unchanged', () {
        final result = computeEffectiveAlignment(
          requested: PopoverAlignment.topRight,
          triggerPosition: const Offset(200, 150),
          triggerSize: const Size(40, 30),
          popoverSize: const Size(80, 60),
          screenSize: const Size(400, 300),
          offset: const Offset(0, 4),
        );

        expect(result, PopoverAlignment.topRight);
      });

      test('bottomCenter where popover overflows below returns topCenter', () {
        final result = computeEffectiveAlignment(
          requested: PopoverAlignment.bottomCenter,
          triggerPosition: const Offset(150, 220),
          triggerSize: const Size(50, 30),
          popoverSize: const Size(120, 80),
          screenSize: const Size(400, 300),
          offset: const Offset(0, 4),
        );

        expect(result, PopoverAlignment.topCenter);
      });

      test('topCenter where popover overflows above returns bottomCenter', () {
        final result = computeEffectiveAlignment(
          requested: PopoverAlignment.topCenter,
          triggerPosition: const Offset(150, 10),
          triggerSize: const Size(50, 30),
          popoverSize: const Size(120, 60),
          screenSize: const Size(400, 300),
          offset: const Offset(0, 4),
        );

        expect(result, PopoverAlignment.bottomCenter);
      });

      test('bottomLeft with offset pushing off right edge flips to bottomRight',
          () {
        final result = computeEffectiveAlignment(
          requested: PopoverAlignment.bottomLeft,
          triggerPosition: const Offset(220, 100),
          triggerSize: const Size(40, 30),
          popoverSize: const Size(80, 60),
          screenSize: const Size(300, 300),
          offset: const Offset(20, 4),
        );

        expect(result, PopoverAlignment.bottomRight);
      });

      test('trigger at center of large screen returns requested unchanged', () {
        final result = computeEffectiveAlignment(
          requested: PopoverAlignment.bottomRight,
          triggerPosition: const Offset(500, 400),
          triggerSize: const Size(60, 40),
          popoverSize: const Size(200, 120),
          screenSize: const Size(1200, 800),
          offset: const Offset(0, 4),
        );

        expect(result, PopoverAlignment.bottomRight);
      });
    });

    group('Auto-Flip Widget Integration', () {
      testWidgets('right edge trigger with bottomRight and w-56 stays visible',
          (tester) async {
        tester.view.physicalSize = const Size(400, 300);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          wrapWithTheme(
            Align(
              alignment: Alignment.centerRight,
              child: WPopover(
                alignment: PopoverAlignment.bottomRight,
                className: 'w-56',
                triggerBuilder: (context, isOpen, isHovering) => Container(
                  width: 40,
                  height: 40,
                  color: Colors.blue,
                  child: const Text('Trigger'),
                ),
                contentBuilder: (context, close) => const Text('Popover'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Trigger'));
        await tester.pumpAndSettle();

        final renderBox = tester.renderObject<RenderBox>(find.text('Popover'));
        final Offset topLeft = renderBox.localToGlobal(Offset.zero);
        final Offset bottomRight =
            renderBox.localToGlobal(renderBox.size.bottomRight(Offset.zero));
        expect(topLeft.dy, greaterThanOrEqualTo(0));
        expect(bottomRight.dy, lessThanOrEqualTo(300));
      });

      testWidgets('bottom edge trigger with bottomCenter flips to topCenter',
          (tester) async {
        tester.view.physicalSize = const Size(400, 300);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          wrapWithTheme(
            Align(
              alignment: Alignment.bottomCenter,
              child: WPopover(
                alignment: PopoverAlignment.bottomCenter,
                className: 'w-48',
                triggerBuilder: (context, isOpen, isHovering) => Container(
                  width: 60,
                  height: 40,
                  color: Colors.green,
                  child: const Text('Trigger'),
                ),
                contentBuilder: (context, close) => const SizedBox(
                  height: 160,
                  child: Text('Popover'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Trigger'));
        await tester.pumpAndSettle();

        final renderBox = tester.renderObject<RenderBox>(find.text('Popover'));
        final Offset topLeft = renderBox.localToGlobal(Offset.zero);
        final Offset bottomRight =
            renderBox.localToGlobal(renderBox.size.bottomRight(Offset.zero));

        // Verify it flipped to top (above trigger which is at bottomCenter)
        expect(topLeft.dy, greaterThanOrEqualTo(0));
        expect(bottomRight.dy, lessThanOrEqualTo(300));

        // Verify horizontal centering is preserved after flip
        final popoverCenter = tester.getCenter(find.text('Popover'));
        final triggerCenter = tester.getCenter(find.text('Trigger'));
        expect(popoverCenter.dx, closeTo(triggerCenter.dx, 0.1));
      });

      testWidgets('bottom edge trigger with bottomLeft flips to top',
          (tester) async {
        tester.view.physicalSize = const Size(400, 300);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          wrapWithTheme(
            Align(
              alignment: Alignment.bottomCenter,
              child: WPopover(
                alignment: PopoverAlignment.bottomLeft,
                className: 'w-48',
                triggerBuilder: (context, isOpen, isHovering) => Container(
                  width: 60,
                  height: 40,
                  color: Colors.green,
                  child: const Text('Trigger'),
                ),
                contentBuilder: (context, close) => const SizedBox(
                  height: 160,
                  child: Text('Popover'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Trigger'));
        await tester.pumpAndSettle();

        final renderBox = tester.renderObject<RenderBox>(find.text('Popover'));
        final Offset topLeft = renderBox.localToGlobal(Offset.zero);
        final Offset bottomRight =
            renderBox.localToGlobal(renderBox.size.bottomRight(Offset.zero));
        expect(topLeft.dy, greaterThanOrEqualTo(0));
        expect(bottomRight.dy, lessThanOrEqualTo(300));
      });

      testWidgets('top-left trigger with topLeft flips to bottom',
          (tester) async {
        tester.view.physicalSize = const Size(400, 300);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          wrapWithTheme(
            Align(
              alignment: Alignment.topLeft,
              child: WPopover(
                alignment: PopoverAlignment.topLeft,
                className: 'w-48',
                triggerBuilder: (context, isOpen, isHovering) => Container(
                  width: 60,
                  height: 40,
                  color: Colors.orange,
                  child: const Text('Trigger'),
                ),
                contentBuilder: (context, close) => const SizedBox(
                  height: 120,
                  child: Text('Popover'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Trigger'));
        await tester.pumpAndSettle();

        final renderBox = tester.renderObject<RenderBox>(find.text('Popover'));
        final Offset topLeft = renderBox.localToGlobal(Offset.zero);
        final Offset bottomRight =
            renderBox.localToGlobal(renderBox.size.bottomRight(Offset.zero));
        expect(topLeft.dy, greaterThanOrEqualTo(0));
        expect(bottomRight.dy, lessThanOrEqualTo(300));
      });

      testWidgets('center trigger with bottomLeft stays visible',
          (tester) async {
        tester.view.physicalSize = const Size(400, 300);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          wrapWithTheme(
            Align(
              alignment: Alignment.center,
              child: WPopover(
                alignment: PopoverAlignment.bottomLeft,
                className: 'w-40',
                triggerBuilder: (context, isOpen, isHovering) => Container(
                  width: 60,
                  height: 40,
                  color: Colors.purple,
                  child: const Text('Trigger'),
                ),
                contentBuilder: (context, close) => const SizedBox(
                  height: 80,
                  child: Text('Popover'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Trigger'));
        await tester.pumpAndSettle();

        final renderBox = tester.renderObject<RenderBox>(find.text('Popover'));
        final Offset topLeft = renderBox.localToGlobal(Offset.zero);
        final Offset bottomRight =
            renderBox.localToGlobal(renderBox.size.bottomRight(Offset.zero));
        expect(topLeft.dx, greaterThanOrEqualTo(0));
        expect(topLeft.dy, greaterThanOrEqualTo(0));
        expect(bottomRight.dx, lessThanOrEqualTo(400));
        expect(bottomRight.dy, lessThanOrEqualTo(300));
      });

      testWidgets('open/close cycle works after flip', (tester) async {
        tester.view.physicalSize = const Size(400, 300);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          wrapWithTheme(
            Align(
              alignment: Alignment.bottomRight,
              child: WPopover(
                alignment: PopoverAlignment.bottomRight,
                className: 'w-56',
                triggerBuilder: (context, isOpen, isHovering) => Container(
                  width: 40,
                  height: 40,
                  color: Colors.red,
                  child: const Text('Trigger'),
                ),
                contentBuilder: (context, close) => const Text('Popover'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Trigger'));
        await tester.pumpAndSettle();
        expect(find.text('Popover'), findsOneWidget);

        await tester.tap(find.text('Trigger'));
        await tester.pumpAndSettle();
        expect(find.text('Popover'), findsNothing);
      });
    });
  });
}
