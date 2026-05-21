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
  group('WindAnimationWrapper', () {
    testWidgets('spin renders RotationTransition', (tester) async {
      const wrapperKey = ValueKey('wrapper');
      await tester.pumpWidget(
        wrapWithTheme(
          WindAnimationWrapper(
            key: wrapperKey,
            animationType: WindAnimationType.spin,
            child: Container(),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 16));

      expect(
        find.descendant(
          of: find.byKey(wrapperKey),
          matching: find.byType(RotationTransition),
        ),
        findsOneWidget,
      );
    });

    testWidgets('ping renders AnimatedBuilder', (tester) async {
      const wrapperKey = ValueKey('wrapper');
      await tester.pumpWidget(
        wrapWithTheme(
          WindAnimationWrapper(
            key: wrapperKey,
            animationType: WindAnimationType.ping,
            child: Container(),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 16));

      expect(
        find.descendant(
          of: find.byKey(wrapperKey),
          matching: find.byType(AnimatedBuilder),
        ),
        findsOneWidget,
      );
    });

    testWidgets('pulse renders FadeTransition', (tester) async {
      const wrapperKey = ValueKey('wrapper');
      await tester.pumpWidget(
        wrapWithTheme(
          WindAnimationWrapper(
            key: wrapperKey,
            animationType: WindAnimationType.pulse,
            child: Container(),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 16));

      expect(
        find.descendant(
          of: find.byKey(wrapperKey),
          matching: find.byType(FadeTransition),
        ),
        findsOneWidget,
      );
    });

    testWidgets('bounce renders AnimatedBuilder', (tester) async {
      const wrapperKey = ValueKey('wrapper');
      await tester.pumpWidget(
        wrapWithTheme(
          WindAnimationWrapper(
            key: wrapperKey,
            animationType: WindAnimationType.bounce,
            child: Container(),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 16));

      expect(
        find.descendant(
          of: find.byKey(wrapperKey),
          matching: find.byType(AnimatedBuilder),
        ),
        findsOneWidget,
      );
    });

    testWidgets('none renders child directly without animation widgets',
        (tester) async {
      const childKey = ValueKey('child');
      const wrapperKey = ValueKey('wrapper');

      await tester.pumpWidget(
        wrapWithTheme(
          WindAnimationWrapper(
            key: wrapperKey,
            animationType: WindAnimationType.none,
            child: Container(key: childKey),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 16));

      expect(find.byKey(childKey), findsOneWidget);
      expect(
        find.descendant(
          of: find.byKey(wrapperKey),
          matching: find.byType(RotationTransition),
        ),
        findsNothing,
      );
      expect(
        find.descendant(
          of: find.byKey(wrapperKey),
          matching: find.byType(FadeTransition),
        ),
        findsNothing,
      );
    });

    testWidgets('didUpdateWidget swaps spin to pulse', (tester) async {
      const wrapperKey = ValueKey('wrapper');
      WindAnimationType currentType = WindAnimationType.spin;

      await tester.pumpWidget(
        wrapWithTheme(
          StatefulBuilder(
            builder: (context, setState) {
              return Column(
                children: [
                  ElevatedButton(
                    onPressed: () => setState(() {
                      currentType = WindAnimationType.pulse;
                    }),
                    child: const Text('Switch'),
                  ),
                  WindAnimationWrapper(
                    key: wrapperKey,
                    animationType: currentType,
                    child: Container(),
                  ),
                ],
              );
            },
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 16));

      expect(
        find.descendant(
          of: find.byKey(wrapperKey),
          matching: find.byType(RotationTransition),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byKey(wrapperKey),
          matching: find.byType(FadeTransition),
        ),
        findsNothing,
      );

      await tester.tap(find.text('Switch'));
      await tester.pump(const Duration(milliseconds: 16));

      expect(
        find.descendant(
          of: find.byKey(wrapperKey),
          matching: find.byType(RotationTransition),
        ),
        findsNothing,
      );
      expect(
        find.descendant(
          of: find.byKey(wrapperKey),
          matching: find.byType(FadeTransition),
        ),
        findsOneWidget,
      );
    });

    testWidgets('didUpdateWidget duration change does not throw',
        (tester) async {
      const wrapperKey = ValueKey('wrapper');
      Duration currentDuration = const Duration(seconds: 1);

      await tester.pumpWidget(
        wrapWithTheme(
          StatefulBuilder(
            builder: (context, setState) {
              return Column(
                children: [
                  ElevatedButton(
                    onPressed: () => setState(() {
                      currentDuration = const Duration(milliseconds: 500);
                    }),
                    child: const Text('Change Duration'),
                  ),
                  WindAnimationWrapper(
                    key: wrapperKey,
                    animationType: WindAnimationType.spin,
                    duration: currentDuration,
                    child: Container(),
                  ),
                ],
              );
            },
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 16));

      await tester.tap(find.text('Change Duration'));
      await tester.pump(const Duration(milliseconds: 16));

      // No exception thrown — the animation controller adapted to the new duration.
      expect(
        find.descendant(
          of: find.byKey(wrapperKey),
          matching: find.byType(RotationTransition),
        ),
        findsOneWidget,
      );
    });

    testWidgets('dispose cleans up without exception', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          WindAnimationWrapper(
            animationType: WindAnimationType.spin,
            child: Container(),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 16));

      // Unmount the widget.
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 16));

      // Reaching here without exceptions confirms the controller was disposed correctly.
      expect(find.byType(WindAnimationWrapper), findsNothing);
    });

    group('wrapWithAnimation helper', () {
      test('returns child unmodified when animationType is null', () {
        final child = Container();
        final result = wrapWithAnimation(animationType: null, child: child);

        expect(result, same(child));
      });

      test('returns child unmodified when animationType is none', () {
        final child = Container();
        final result = wrapWithAnimation(
          animationType: WindAnimationType.none,
          child: child,
        );

        expect(result, same(child));
      });

      test('returns WindAnimationWrapper when animationType is spin', () {
        final child = Container();
        final result = wrapWithAnimation(
          animationType: WindAnimationType.spin,
          child: child,
        );

        expect(result, isA<WindAnimationWrapper>());
      });
    });
  });
}
