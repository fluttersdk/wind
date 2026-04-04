import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

void main() {
  setUp(() {
    WindParser.clearCache();
  });

  group('WDiv Position — Stack/Positioned rendering', () {
    testWidgets(
      'relative parent with children renders Stack widget in tree',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: WindTheme(
              data: WindThemeData(),
              child: const WDiv(
                className: 'relative',
                children: [
                  WText('Child 1'),
                  WText('Child 2'),
                ],
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
        expect(find.byType(Stack), findsOneWidget);
      },
    );

    testWidgets(
      'absolute child inside relative parent renders Positioned widget',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: WindTheme(
              data: WindThemeData(),
              child: const WDiv(
                className: 'relative',
                children: [
                  WText('Normal child'),
                  WDiv(
                    className: 'absolute',
                    child: WText('Absolute child'),
                  ),
                ],
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
        expect(find.byType(Stack), findsOneWidget);
        expect(find.byType(Positioned), findsOneWidget);
      },
    );

    testWidgets(
      'mixed layout: relative flex parent with normal + absolute children',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: WindTheme(
              data: WindThemeData(),
              child: SizedBox(
                width: 400,
                height: 400,
                child: const WDiv(
                  className: 'relative flex flex-row',
                  children: [
                    WText('Normal 1'),
                    WText('Normal 2'),
                    WDiv(
                      className: 'absolute bottom-4 right-4',
                      child: WText('Absolute'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);

        // Stack wraps everything
        expect(find.byType(Stack), findsOneWidget);

        // Normal children rendered in a Row (flex-row)
        expect(find.byType(Row), findsOneWidget);

        // Absolute child wrapped in Positioned
        final positionedFinder = find.byType(Positioned);
        expect(positionedFinder, findsOneWidget);

        final positioned = tester.widget<Positioned>(positionedFinder);
        expect(positioned.bottom, 16.0); // bottom-4 = 4 * 4 = 16
        expect(positioned.right, 16.0); // right-4 = 4 * 4 = 16
      },
    );

    testWidgets(
      'absolute inset-0 renders Positioned with all 4 sides = 0',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: WindTheme(
              data: WindThemeData(),
              child: const WDiv(
                className: 'relative',
                children: [
                  WText('Background'),
                  WDiv(
                    className: 'absolute inset-0',
                    child: WText('Overlay'),
                  ),
                ],
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);

        final positionedFinder = find.byType(Positioned);
        expect(positionedFinder, findsOneWidget);

        final positioned = tester.widget<Positioned>(positionedFinder);
        expect(positioned.top, 0.0);
        expect(positioned.right, 0.0);
        expect(positioned.bottom, 0.0);
        expect(positioned.left, 0.0);
      },
    );

    testWidgets(
      'absolute child skips Expanded/Flexible wrapping',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: WindTheme(
              data: WindThemeData(),
              child: const WDiv(
                className: 'relative',
                children: [
                  WDiv(
                    className: 'absolute top-4 left-2',
                    child: WText('Positioned'),
                  ),
                ],
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);

        // Should have Positioned, NOT Expanded or Flexible
        expect(find.byType(Positioned), findsOneWidget);
        expect(find.byType(Expanded), findsNothing);
        expect(find.byType(Flexible), findsNothing);

        final positioned = tester.widget<Positioned>(
          find.byType(Positioned),
        );
        expect(positioned.top, 16.0); // top-4 = 16
        expect(positioned.left, 8.0); // left-2 = 8
      },
    );

    testWidgets(
      'single child with relative wraps in Stack',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: WindTheme(
              data: WindThemeData(),
              child: const WDiv(
                className: 'relative',
                child: WText('Single child'),
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
        expect(find.byType(Stack), findsOneWidget);
      },
    );

    testWidgets(
      'relative without any absolute children still renders Stack',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: WindTheme(
              data: WindThemeData(),
              child: const WDiv(
                className: 'relative',
                children: [
                  WText('Normal 1'),
                  WText('Normal 2'),
                ],
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
        expect(find.byType(Stack), findsOneWidget);
        expect(find.byType(Positioned), findsNothing);
      },
    );

    testWidgets(
      'negative offset: absolute -top-2 renders Positioned(top: -8.0)',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: WindTheme(
              data: WindThemeData(),
              child: const WDiv(
                className: 'relative',
                children: [
                  WText('Content'),
                  WDiv(
                    className: 'absolute -top-2',
                    child: WText('Negative offset'),
                  ),
                ],
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);

        final positionedFinder = find.byType(Positioned);
        expect(positionedFinder, findsOneWidget);

        final positioned = tester.widget<Positioned>(positionedFinder);
        expect(positioned.top, -8.0); // -top-2 = -(2 * 4) = -8
      },
    );
  });
}
