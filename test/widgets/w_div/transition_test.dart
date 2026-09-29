import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

void main() {
  group('WDiv Transition Tests', () {
    testWidgets('uses AnimatedContainer when duration is set', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            child: Scaffold(
              body: WDiv(
                className: 'bg-blue-500 duration-300',
                child: const Text('Test'),
              ),
            ),
          ),
        ),
      );

      // Find AnimatedContainer in the widget tree
      expect(find.byType(AnimatedContainer), findsOneWidget);
    });

    testWidgets('uses a static box when no duration', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            child: Scaffold(
              body: WDiv(className: 'bg-blue-500', child: const Text('Test')),
            ),
          ),
        ),
      );

      // A static DecoratedBox, not AnimatedContainer. WDiv builds the static
      // box from primitives, so there is no Container to find.
      expect(find.byType(DecoratedBox), findsWidgets);
      expect(find.byType(AnimatedContainer), findsNothing);
    });

    testWidgets(
      'uses a static box when only ease is present without duration',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: WindTheme(
              child: Scaffold(
                body: WDiv(
                  className: 'bg-blue-500 ease-in-out',
                  child: const Text('Test'),
                ),
              ),
            ),
          ),
        );

        // A static DecoratedBox, not AnimatedContainer: duration is missing.
        expect(find.byType(DecoratedBox), findsWidgets);
        expect(find.byType(AnimatedContainer), findsNothing);
      },
    );

    testWidgets('AnimatedContainer has correct duration', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            child: Scaffold(
              body: WDiv(
                className: 'bg-blue-500 duration-500',
                child: const Text('Test'),
              ),
            ),
          ),
        ),
      );

      final animatedContainer = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      expect(animatedContainer.duration, const Duration(milliseconds: 500));
    });

    testWidgets('AnimatedContainer has correct curve', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            child: Scaffold(
              body: WDiv(
                className: 'bg-blue-500 duration-300 ease-in-out',
                child: const Text('Test'),
              ),
            ),
          ),
        ),
      );

      final animatedContainer = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      expect(animatedContainer.curve, Curves.easeInOut);
    });

    testWidgets('AnimatedContainer defaults to linear curve', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            child: Scaffold(
              body: WDiv(
                className: 'bg-blue-500 duration-300',
                child: const Text('Test'),
              ),
            ),
          ),
        ),
      );

      final animatedContainer = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      expect(animatedContainer.curve, Curves.linear);
    });

    testWidgets('arbitrary duration works', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            child: Scaffold(
              body: WDiv(
                className: 'bg-blue-500 duration-[250ms]',
                child: const Text('Test'),
              ),
            ),
          ),
        ),
      );

      final animatedContainer = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      expect(animatedContainer.duration, const Duration(milliseconds: 250));
    });

    testWidgets('transition animates on style change', (tester) async {
      bool isHovered = false;

      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            child: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return GestureDetector(
                    onTap: () => setState(() => isHovered = !isHovered),
                    child: WDiv(
                      className: isHovered
                          ? 'bg-red-500 duration-300'
                          : 'bg-blue-500 duration-300',
                      child: const Text('Toggle'),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Initial state
      expect(find.byType(AnimatedContainer), findsOneWidget);

      // Tap to trigger state change
      await tester.tap(find.byType(GestureDetector));
      await tester.pump();

      // Animation should be in progress
      await tester.pump(const Duration(milliseconds: 150));

      // Animation should complete
      await tester.pumpAndSettle();

      expect(find.byType(AnimatedContainer), findsOneWidget);
    });
  });
}
