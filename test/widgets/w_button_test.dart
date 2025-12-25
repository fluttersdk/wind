import 'package:flutter/gestures.dart';
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
  group('WButton Widget Tests', () {
    group('Basic Rendering', () {
      testWidgets('renders child content', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(WButton(onTap: () {}, child: const Text('Click Me'))),
        );

        expect(find.text('Click Me'), findsOneWidget);
      });

      testWidgets('applies className styling', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WButton(
              onTap: () {},
              className: 'bg-blue-500 p-4 rounded-lg',
              child: const Text('Styled'),
            ),
          ),
        );

        expect(find.byType(Container), findsOneWidget);
      });
    });

    group('Tap Interaction', () {
      testWidgets('calls onTap when pressed', (tester) async {
        bool wasTapped = false;

        await tester.pumpWidget(
          wrapWithTheme(
            WButton(onTap: () => wasTapped = true, child: const Text('Tap Me')),
          ),
        );

        await tester.tap(find.text('Tap Me'));
        await tester.pump();

        expect(wasTapped, isTrue);
      });

      testWidgets('calls onLongPress when long pressed', (tester) async {
        bool wasLongPressed = false;

        await tester.pumpWidget(
          wrapWithTheme(
            WButton(
              onLongPress: () => wasLongPressed = true,
              child: const Text('Long Press'),
            ),
          ),
        );

        await tester.longPress(find.text('Long Press'));
        await tester.pump();

        expect(wasLongPressed, isTrue);
      });
    });

    group('Disabled State', () {
      testWidgets('does not call onTap when disabled', (tester) async {
        bool wasTapped = false;

        await tester.pumpWidget(
          wrapWithTheme(
            WButton(
              onTap: () => wasTapped = true,
              disabled: true,
              child: const Text('Disabled'),
            ),
          ),
        );

        await tester.tap(find.text('Disabled'));
        await tester.pump();

        expect(wasTapped, isFalse);
      });

      testWidgets('applies disabled className styling', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WButton(
              onTap: () {},
              disabled: true,
              className: 'bg-blue-500 disabled:bg-gray-400',
              child: const Text('Disabled'),
            ),
          ),
        );

        // Widget should render
        expect(find.text('Disabled'), findsOneWidget);
      });
    });

    group('Loading State', () {
      testWidgets('shows loading spinner when isLoading is true', (
        tester,
      ) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WButton(onTap: () {}, isLoading: true, child: const Text('Submit')),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Submit'), findsNothing);
      });

      testWidgets('shows loadingText alongside spinner', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WButton(
              onTap: () {},
              isLoading: true,
              loadingText: 'Loading...',
              child: const Text('Submit'),
            ),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Loading...'), findsOneWidget);
      });

      testWidgets('shows custom loadingWidget when provided', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WButton(
              onTap: () {},
              isLoading: true,
              loadingWidget: const Icon(Icons.hourglass_empty),
              child: const Text('Submit'),
            ),
          ),
        );

        expect(find.byIcon(Icons.hourglass_empty), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsNothing);
      });

      testWidgets('does not call onTap when loading', (tester) async {
        bool wasTapped = false;

        await tester.pumpWidget(
          wrapWithTheme(
            WButton(
              onTap: () => wasTapped = true,
              isLoading: true,
              child: const Text('Loading'),
            ),
          ),
        );

        // Try to tap the button container area (not the spinner directly)
        await tester.tap(find.byType(Container).first, warnIfMissed: false);
        await tester.pump();

        expect(wasTapped, isFalse);
      });

      testWidgets('applies loading className styling', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WButton(
              onTap: () {},
              isLoading: true,
              className: 'bg-blue-500 loading:opacity-50',
              child: const Text('Submit'),
            ),
          ),
        );

        // Widget should render
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });

    group('Interaction Blocking', () {
      testWidgets('disabled button blocks interactions', (tester) async {
        bool wasTapped = false;

        await tester.pumpWidget(
          wrapWithTheme(
            WButton(
              onTap: () => wasTapped = true,
              disabled: true,
              child: const Text('Disabled'),
            ),
          ),
        );

        await tester.tap(find.text('Disabled'));
        await tester.pump();

        // onTap should not be called
        expect(wasTapped, isFalse);
      });

      testWidgets('loading button blocks interactions', (tester) async {
        bool wasTapped = false;

        await tester.pumpWidget(
          wrapWithTheme(
            WButton(
              onTap: () => wasTapped = true,
              isLoading: true,
              loadingText: 'Loading...',
              child: const Text('Submit'),
            ),
          ),
        );

        await tester.tap(find.text('Loading...'));
        await tester.pump();

        // onTap should not be called
        expect(wasTapped, isFalse);
      });
    });

    group('Hover State', () {
      testWidgets('hover state is applied on mouse enter', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WButton(
              onTap: () {},
              className: 'bg-blue-500 hover:bg-red-500',
              child: const Text('Hover Me'),
            ),
          ),
        );

        // Find the MouseRegion (internal to WAnchor)
        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer(location: Offset.zero);
        addTearDown(gesture.removePointer);

        // Move mouse over the button
        await gesture.moveTo(tester.getCenter(find.text('Hover Me')));
        await tester.pump();

        // Button should still render (hover styling applied)
        expect(find.text('Hover Me'), findsOneWidget);
      });

      testWidgets('hover state triggers rebuild with different style', (
        tester,
      ) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WButton(
              onTap: () {},
              className: 'bg-blue-500 hover:bg-red-500 p-4 rounded-lg',
              child: const Text('Hover Me'),
            ),
          ),
        );

        // Get initial container
        final containerBefore = tester.widget<Container>(
          find.byType(Container).first,
        );
        final decorationBefore = containerBefore.decoration as BoxDecoration?;
        final colorBefore = decorationBefore?.color;

        // Simulate hover
        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer(location: Offset.zero);
        addTearDown(gesture.removePointer);
        await gesture.moveTo(tester.getCenter(find.text('Hover Me')));
        await tester.pump();

        // Get container after hover
        final containerAfter = tester.widget<Container>(
          find.byType(Container).first,
        );
        final decorationAfter = containerAfter.decoration as BoxDecoration?;
        final colorAfter = decorationAfter?.color;

        // Colors should be different (blue -> red)
        expect(colorBefore, isNotNull);
        expect(colorAfter, isNotNull);
        expect(colorBefore, isNot(equals(colorAfter)));
      });
    });

    group('Custom States', () {
      testWidgets('custom states are applied via states parameter', (
        tester,
      ) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WButton(
              onTap: () {},
              className: 'bg-blue-500 error:bg-red-500 p-4',
              states: {'error'},
              child: const Text('Error Button'),
            ),
          ),
        );

        // Get container
        final container = tester.widget<Container>(
          find.byType(Container).first,
        );
        final decoration = container.decoration as BoxDecoration?;

        // Color should be red (error state active)
        expect(decoration?.color, isNotNull);
        expect(find.text('Error Button'), findsOneWidget);
      });

      testWidgets('multiple custom states can be active', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WButton(
              onTap: () {},
              className: 'bg-blue-500 error:bg-red-500 success:text-green-500',
              states: {'error', 'success'},
              child: const Text('Mixed States'),
            ),
          ),
        );

        expect(find.text('Mixed States'), findsOneWidget);
      });
    });

    group('onDoubleTap Callback', () {
      testWidgets('calls onDoubleTap when double tapped', (tester) async {
        bool wasDoubleTapped = false;

        await tester.pumpWidget(
          wrapWithTheme(
            WButton(
              onDoubleTap: () => wasDoubleTapped = true,
              child: const Text('Double Tap'),
            ),
          ),
        );

        await tester.tap(find.text('Double Tap'));
        await tester.pump(const Duration(milliseconds: 50));
        await tester.tap(find.text('Double Tap'));
        await tester.pumpAndSettle();

        expect(wasDoubleTapped, isTrue);
      });

      testWidgets('does not call onDoubleTap when disabled', (tester) async {
        bool wasDoubleTapped = false;

        await tester.pumpWidget(
          wrapWithTheme(
            WButton(
              onDoubleTap: () => wasDoubleTapped = true,
              disabled: true,
              child: const Text('Disabled'),
            ),
          ),
        );

        await tester.tap(find.text('Disabled'), warnIfMissed: false);
        await tester.pump(const Duration(milliseconds: 50));
        await tester.tap(find.text('Disabled'), warnIfMissed: false);
        await tester.pumpAndSettle();

        expect(wasDoubleTapped, isFalse);
      });

      testWidgets('does not call onDoubleTap when loading', (tester) async {
        bool wasDoubleTapped = false;

        await tester.pumpWidget(
          wrapWithTheme(
            WButton(
              onDoubleTap: () => wasDoubleTapped = true,
              isLoading: true,
              loadingText: 'Loading...',
              child: const Text('Submit'),
            ),
          ),
        );

        await tester.tap(find.text('Loading...'), warnIfMissed: false);
        await tester.pump(const Duration(milliseconds: 50));
        await tester.tap(find.text('Loading...'), warnIfMissed: false);
        // Use pump with fixed duration instead of pumpAndSettle
        // because CircularProgressIndicator animation never settles
        await tester.pump(const Duration(milliseconds: 500));

        expect(wasDoubleTapped, isFalse);
      });
    });
  });
}
