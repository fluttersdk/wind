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

    group('Smart Flip - prefer direction with more space', () {
      test(
          'bottomLeft stays when bottom overflows but top has LESS space (iPhone SE regression)',
          () {
        // iPhone SE: 375×667, trigger at y=300, height=48
        // spaceBelow = 667 - 300 - 48 - 4 = 315
        // spaceAbove = 300 - 4 = 296
        // bottomEdge = 300 + 48 + 4 + 400 = 752 > 667 (overflows)
        // spaceAbove (296) < spaceBelow (315) → DO NOT flip
        final result = computeEffectiveAlignment(
          requested: PopoverAlignment.bottomLeft,
          triggerPosition: const Offset(20, 300),
          triggerSize: const Size(335, 48),
          popoverSize: const Size(320, 400),
          screenSize: const Size(375, 667),
          offset: const Offset(0, 4),
        );

        expect(result, PopoverAlignment.bottomLeft);
      });

      test('topLeft stays when top overflows but bottom has LESS space', () {
        // Trigger at y=350 on 667 screen, triggerHeight=48
        // spaceAbove = 350 - 4 = 346
        // spaceBelow = 667 - 350 - 48 - 4 = 265
        // topEdge = 350 - 4 - 400 = -54 < 0 (overflows)
        // spaceBelow (265) < spaceAbove (346) → DO NOT flip
        final result = computeEffectiveAlignment(
          requested: PopoverAlignment.topLeft,
          triggerPosition: const Offset(20, 350),
          triggerSize: const Size(335, 48),
          popoverSize: const Size(320, 400),
          screenSize: const Size(375, 667),
          offset: const Offset(0, 4),
        );

        expect(result, PopoverAlignment.topLeft);
      });

      test('bottomCenter stays when bottom overflows but top has less space',
          () {
        // trigger at y=180, height=40, screen height=500
        // spaceBelow = 500 - 180 - 40 - 4 = 276
        // spaceAbove = 180 - 4 = 176
        // bottomEdge = 180 + 40 + 4 + 300 = 524 > 500 (overflows)
        // spaceAbove (176) < spaceBelow (276) → DO NOT flip
        final result = computeEffectiveAlignment(
          requested: PopoverAlignment.bottomCenter,
          triggerPosition: const Offset(100, 180),
          triggerSize: const Size(200, 40),
          popoverSize: const Size(250, 300),
          screenSize: const Size(400, 500),
          offset: const Offset(0, 4),
        );

        expect(result, PopoverAlignment.bottomCenter);
      });

      test(
          'bottomLeft DOES flip to topLeft when bottom overflows and top has MORE space',
          () {
        // Trigger near bottom: y=500, height=40, screen=600
        // spaceBelow = 600 - 500 - 40 - 4 = 56
        // spaceAbove = 500 - 4 = 496
        // bottomEdge = 500 + 40 + 4 + 300 = 844 > 600 (overflows)
        // spaceAbove (496) > spaceBelow (56) → FLIP
        final result = computeEffectiveAlignment(
          requested: PopoverAlignment.bottomLeft,
          triggerPosition: const Offset(50, 500),
          triggerSize: const Size(100, 40),
          popoverSize: const Size(200, 300),
          screenSize: const Size(400, 600),
          offset: const Offset(0, 4),
        );

        expect(result, PopoverAlignment.topLeft);
      });

      test(
          'topCenter DOES flip to bottomCenter when top overflows and bottom has MORE space',
          () {
        // Trigger near top: y=30, height=40, screen=600
        // spaceAbove = 30 - 4 = 26
        // spaceBelow = 600 - 30 - 40 - 4 = 526
        // topEdge = 30 - 4 - 200 = -174 < 0 (overflows)
        // spaceBelow (526) > spaceAbove (26) → FLIP
        final result = computeEffectiveAlignment(
          requested: PopoverAlignment.topCenter,
          triggerPosition: const Offset(100, 30),
          triggerSize: const Size(200, 40),
          popoverSize: const Size(250, 200),
          screenSize: const Size(400, 600),
          offset: const Offset(0, 4),
        );

        expect(result, PopoverAlignment.bottomCenter);
      });

      test(
          'bottomLeft stays when both directions overflow with exactly equal space',
          () {
        // Trigger exactly at center: y=280, height=40, screen=600
        // spaceBelow = 600 - 280 - 40 - 4 = 276
        // spaceAbove = 280 - 4 = 276
        // bottomEdge = 280 + 40 + 4 + 400 = 724 > 600 (overflows)
        // spaceAbove (276) == spaceBelow (276), NOT > → DO NOT flip
        final result = computeEffectiveAlignment(
          requested: PopoverAlignment.bottomLeft,
          triggerPosition: const Offset(50, 280),
          triggerSize: const Size(100, 40),
          popoverSize: const Size(200, 400),
          screenSize: const Size(400, 600),
          offset: const Offset(0, 4),
        );

        expect(result, PopoverAlignment.bottomLeft);
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

      testWidgets(
          'autoFlip respects fixed width in className (Regression Test)',
          (tester) async {
        // Screen width 400.
        // Trigger at x=300 (near right edge).
        // Trigger width 40.
        // Popover width 300 (via className).
        // If it doesn't flip, right edge = 300 + 300 = 600 (> 400).
        // It SHOULD flip to bottomRight.
        tester.view.physicalSize = const Size(400, 300);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          wrapWithTheme(
            Stack(
              children: [
                Positioned(
                  left: 300,
                  top: 100,
                  child: WPopover(
                    alignment: PopoverAlignment.bottomLeft,
                    className: 'w-[300px]',
                    triggerBuilder: (context, isOpen, isHovering) => Container(
                      width: 40,
                      height: 40,
                      color: Colors.blue,
                      child: const Text('Trigger'),
                    ),
                    contentBuilder: (context, close) =>
                        const Text('Wide Popover'),
                  ),
                ),
              ],
            ),
          ),
        );

        await tester.tap(find.text('Trigger'));
        await tester.pumpAndSettle();

        final renderBox =
            tester.renderObject<RenderBox>(find.text('Wide Popover'));
        final Offset topLeft = renderBox.localToGlobal(Offset.zero);
        final Offset bottomRight =
            renderBox.localToGlobal(renderBox.size.bottomRight(Offset.zero));

        // It should have flipped to bottomRight to fit.
        // bottomRight alignment means popover right edge aligns with trigger right edge.
        // Trigger right edge is at 340. Popover width 300. Popover left should be 40.
        expect(bottomRight.dx, lessThanOrEqualTo(400));
        expect(topLeft.dx, greaterThanOrEqualTo(0));
        expect(find.text('Wide Popover'), findsOneWidget);
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

    group('autoFlip parameter', () {
      testWidgets('autoFlip defaults to true and flips when near bottom',
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
                // autoFlip defaults to true
                alignment: PopoverAlignment.bottomLeft,
                maxHeight: 200,
                triggerBuilder: (context, isOpen, isHovering) => Container(
                  width: 100,
                  height: 40,
                  color: Colors.blue,
                  child: const Text('Trigger'),
                ),
                contentBuilder: (context, close) => const SizedBox(
                  height: 150,
                  child: Text('Popover'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Trigger'));
        await tester.pumpAndSettle();

        // Should flip to top since there's not enough space below
        final popoverBox = tester.renderObject<RenderBox>(find.text('Popover'));
        final triggerBox = tester.renderObject<RenderBox>(find.text('Trigger'));
        final popoverPos = popoverBox.localToGlobal(Offset.zero);
        final triggerPos = triggerBox.localToGlobal(Offset.zero);

        // Popover should be ABOVE the trigger (popover bottom < trigger top)
        expect(popoverPos.dy + popoverBox.size.height,
            lessThanOrEqualTo(triggerPos.dy + 10)); // Allow small offset
      });

      testWidgets('autoFlip: false disables automatic flipping',
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
                autoFlip: false,
                alignment: PopoverAlignment.bottomLeft,
                maxHeight: 200,
                triggerBuilder: (context, isOpen, isHovering) => Container(
                  width: 100,
                  height: 40,
                  color: Colors.blue,
                  child: const Text('Trigger'),
                ),
                contentBuilder: (context, close) => const SizedBox(
                  height: 150,
                  child: Text('Popover'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Trigger'));
        await tester.pumpAndSettle();

        // With autoFlip: false, popover should stay below trigger even if clipped
        final popoverBox = tester.renderObject<RenderBox>(find.text('Popover'));
        final triggerBox = tester.renderObject<RenderBox>(find.text('Trigger'));
        final popoverPos = popoverBox.localToGlobal(Offset.zero);
        final triggerPos = triggerBox.localToGlobal(Offset.zero);

        // Popover should be BELOW the trigger (popover top > trigger bottom)
        expect(popoverPos.dy,
            greaterThanOrEqualTo(triggerPos.dy + triggerBox.size.height - 10));
      });

      testWidgets('stays bottom when trigger is near top of screen',
          (tester) async {
        tester.view.physicalSize = const Size(400, 400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          wrapWithTheme(
            Align(
              alignment: Alignment.topCenter,
              child: WPopover(
                alignment: PopoverAlignment.bottomLeft,
                maxHeight: 100,
                triggerBuilder: (context, isOpen, isHovering) => Container(
                  width: 100,
                  height: 40,
                  color: Colors.green,
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

        // Should stay at bottom since there's plenty of space
        final popoverBox = tester.renderObject<RenderBox>(find.text('Popover'));
        final triggerBox = tester.renderObject<RenderBox>(find.text('Trigger'));
        final popoverPos = popoverBox.localToGlobal(Offset.zero);
        final triggerPos = triggerBox.localToGlobal(Offset.zero);

        // Popover should be BELOW the trigger
        expect(popoverPos.dy,
            greaterThanOrEqualTo(triggerPos.dy + triggerBox.size.height - 10));
      });

      testWidgets('calculates direction before opening (pre-open calculation)',
          (tester) async {
        tester.view.physicalSize = const Size(400, 300);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        bool? wasOpenCallbackInvoked;
        PopoverAlignment? alignmentOnOpen;

        await tester.pumpWidget(
          wrapWithTheme(
            Align(
              alignment: Alignment.bottomCenter,
              child: WPopover(
                alignment: PopoverAlignment.bottomLeft,
                maxHeight: 200,
                onOpen: () {
                  wasOpenCallbackInvoked = true;
                },
                triggerBuilder: (context, isOpen, isHovering) => Container(
                  width: 100,
                  height: 40,
                  color: Colors.blue,
                  child: const Text('Trigger'),
                ),
                contentBuilder: (context, close) => const SizedBox(
                  height: 150,
                  child: Text('Popover'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Trigger'));
        await tester.pumpAndSettle();

        expect(wasOpenCallbackInvoked, isTrue);
        // Verify popover is positioned correctly on first frame
        expect(find.text('Popover'), findsOneWidget);

        final popoverBox = tester.renderObject<RenderBox>(find.text('Popover'));
        final popoverPos = popoverBox.localToGlobal(Offset.zero);

        // Should be on screen (not clipped off bottom)
        expect(popoverPos.dy, greaterThanOrEqualTo(0));
        expect(popoverPos.dy + popoverBox.size.height, lessThanOrEqualTo(300));
      });

      group('Desktop Resolution Auto-Flip (1440×900)', () {
        testWidgets(
            'should flip bottomLeft to topLeft when trigger near bottom edge at 1440×900',
            (tester) async {
          tester.view.physicalSize = const Size(1440, 900);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(() {
            tester.view.resetPhysicalSize();
            tester.view.resetDevicePixelRatio();
          });

          await tester.pumpWidget(
            wrapWithTheme(
              Stack(
                children: [
                  Positioned(
                    left: 100,
                    top: 850,
                    child: WPopover(
                      alignment: PopoverAlignment.bottomLeft,
                      maxHeight: 400,
                      triggerBuilder: (context, isOpen, isHovering) =>
                          Container(
                        width: 100,
                        height: 40,
                        color: Colors.blue,
                        child: const Text('Trigger'),
                      ),
                      contentBuilder: (context, close) => const SizedBox(
                        height: 350,
                        child: Text('Popover Content'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );

          await tester.tap(find.text('Trigger'));
          await tester.pumpAndSettle();

          final popoverBox =
              tester.renderObject<RenderBox>(find.text('Popover Content'));
          final triggerBox =
              tester.renderObject<RenderBox>(find.text('Trigger'));
          final popoverPos = popoverBox.localToGlobal(Offset.zero);
          final triggerPos = triggerBox.localToGlobal(Offset.zero);

          // Popover should be ABOVE trigger
          expect(popoverPos.dy + popoverBox.size.height,
              lessThanOrEqualTo(triggerPos.dy + 1));
          expect(popoverPos.dy, greaterThanOrEqualTo(0));
        });

        testWidgets(
            'should flip bottomLeft to bottomRight when trigger near right edge at 1440×900',
            (tester) async {
          tester.view.physicalSize = const Size(1440, 900);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(() {
            tester.view.resetPhysicalSize();
            tester.view.resetDevicePixelRatio();
          });

          await tester.pumpWidget(
            wrapWithTheme(
              Stack(
                children: [
                  Positioned(
                    left: 1200,
                    top: 100,
                    child: WPopover(
                      alignment: PopoverAlignment.bottomLeft,
                      className: 'w-[320px]',
                      triggerBuilder: (context, isOpen, isHovering) =>
                          Container(
                        width: 100,
                        height: 40,
                        color: Colors.blue,
                        child: const Text('Trigger'),
                      ),
                      contentBuilder: (context, close) =>
                          const Text('Popover Content'),
                    ),
                  ),
                ],
              ),
            ),
          );

          await tester.tap(find.text('Trigger'));
          await tester.pumpAndSettle();

          final popoverBox =
              tester.renderObject<RenderBox>(find.text('Popover Content'));
          final popoverPos = popoverBox.localToGlobal(Offset.zero);

          // Popover right edge (popoverPos.dx + 320) should be within 1440
          expect(popoverPos.dx + 320, lessThanOrEqualTo(1440));
          // Should have flipped to bottomRight (right alignment)
          expect(popoverPos.dx, lessThanOrEqualTo(1200 + 100 - 320 + 1));
        });

        testWidgets('popover never exceeds screen edges at bottom-right corner',
            (tester) async {
          tester.view.physicalSize = const Size(1440, 900);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(() {
            tester.view.resetPhysicalSize();
            tester.view.resetDevicePixelRatio();
          });

          await tester.pumpWidget(
            wrapWithTheme(
              Stack(
                children: [
                  Positioned(
                    left: 1100,
                    top: 850,
                    child: WPopover(
                      alignment: PopoverAlignment.bottomLeft,
                      className: 'w-[400px]',
                      maxHeight: 400,
                      triggerBuilder: (context, isOpen, isHovering) =>
                          Container(
                        width: 100,
                        height: 40,
                        color: Colors.blue,
                        child: const Text('Trigger'),
                      ),
                      contentBuilder: (context, close) => const SizedBox(
                        height: 300,
                        child: Text('Popover Content'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );

          await tester.tap(find.text('Trigger'));
          await tester.pumpAndSettle();

          final popoverBox =
              tester.renderObject<RenderBox>(find.text('Popover Content'));
          final popoverPos = popoverBox.localToGlobal(Offset.zero);
          final popoverSize = popoverBox.size;

          expect(popoverPos.dx, greaterThanOrEqualTo(0));
          expect(popoverPos.dy, greaterThanOrEqualTo(0));
          expect(popoverPos.dx + popoverSize.width, lessThanOrEqualTo(1440));
          expect(popoverPos.dy + popoverSize.height, lessThanOrEqualTo(900));
        });

        testWidgets(
            'center trigger stays bottomLeft (no flip needed) at 1440×900',
            (tester) async {
          tester.view.physicalSize = const Size(1440, 900);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(() {
            tester.view.resetPhysicalSize();
            tester.view.resetDevicePixelRatio();
          });

          await tester.pumpWidget(
            wrapWithTheme(
              Stack(
                children: [
                  Positioned(
                    left: 720,
                    top: 450,
                    child: WPopover(
                      alignment: PopoverAlignment.bottomLeft,
                      className: 'w-[200px]',
                      maxHeight: 200,
                      triggerBuilder: (context, isOpen, isHovering) =>
                          Container(
                        width: 100,
                        height: 40,
                        color: Colors.blue,
                        child: const Text('Trigger'),
                      ),
                      contentBuilder: (context, close) => const SizedBox(
                        height: 100,
                        child: Text('Popover Content'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );

          await tester.tap(find.text('Trigger'));
          await tester.pumpAndSettle();

          final popoverBox =
              tester.renderObject<RenderBox>(find.text('Popover Content'));
          final triggerBox =
              tester.renderObject<RenderBox>(find.text('Trigger'));
          final popoverPos = popoverBox.localToGlobal(Offset.zero);
          final triggerPos = triggerBox.localToGlobal(Offset.zero);

          // Popover should be BELOW trigger (bottomLeft)
          expect(popoverPos.dy,
              greaterThanOrEqualTo(triggerPos.dy + triggerBox.size.height - 1));
          expect(popoverPos.dx, closeTo(triggerPos.dx, 0.1));
        });
      });
    });
  });
}
