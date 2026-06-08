import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Regression suite for self-wrapping flex children.
///
/// A child whose className resolves to `styles.flex` or `styles.flexFit`
/// self-wraps in `Expanded`/`Flexible` inside its own build. If a PARENT then
/// wraps it again (a stretch `SizedBox(width: infinity)` in a Column, a
/// `Flexible` in a space-distributing Row), Flutter throws "Incorrect use of
/// ParentDataWidget". These tests pin that the smart-stretch and Row-flexible
/// paths recognize every self-wrapping token (`grow`, `flex-grow`, `flex-auto`,
/// `flex-initial`, `shrink`, `flex-shrink`, `flex-N`), including prefixed
/// variants, and skip re-wrapping them.
///
/// They also pin the "last class wins" reset behavior of the no-grow/no-shrink
/// tokens (`grow-0`, `shrink-0`, `flex-none`).

Widget wrap(Widget child) => MaterialApp(
      home: WindTheme(
        data: WindThemeData(),
        child: Scaffold(body: child),
      ),
    );

void main() {
  setUp(WindParser.clearCache);

  group('Column smart-stretch does not re-wrap self-wrapping children', () {
    for (final token in const [
      'grow',
      'flex-grow',
      'flex-auto',
      'flex-initial',
      'shrink',
      'flex-shrink',
      'flex-1',
      'flex-3',
    ]) {
      testWidgets('column with a "$token" child renders without asserting', (
        tester,
      ) async {
        await tester.pumpWidget(
          wrap(
            WDiv(
              className: 'flex flex-col',
              children: [
                WDiv(className: token, child: const Text('a')),
                const WDiv(className: 'bg-white', child: Text('b')),
              ],
            ),
          ),
        );

        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('prefixed "md:grow" child is recognized and not re-wrapped', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          WDiv(
            className: 'flex flex-col',
            children: [
              WDiv(className: 'md:grow', child: const Text('a')),
              const WDiv(className: 'bg-white', child: Text('b')),
            ],
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('no-shrink "flex-none" child still stretches cross-axis', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(600, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        wrap(
          SizedBox(
            width: 400,
            child: WDiv(
              className: 'flex flex-col',
              children: [
                WDiv(
                  key: const ValueKey('none'),
                  className: 'flex-none bg-white',
                  child: const Text('a'),
                ),
                const WDiv(className: 'bg-gray-100', child: Text('b')),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      // flex-none keeps its main (vertical) size but stretches to the column's
      // 400 px cross width, matching CSS align-items: stretch.
      final width = tester.getSize(find.byKey(const ValueKey('none'))).width;
      expect(width, moreOrLessEquals(400.0, epsilon: 0.5));
    });
  });

  group('Row space-distribution does not re-wrap self-wrapping children', () {
    for (final token in const ['grow', 'flex-auto', 'flex-1']) {
      testWidgets('justify-between row with a "$token" child does not assert', (
        tester,
      ) async {
        await tester.pumpWidget(
          wrap(
            WDiv(
              className: 'flex flex-row justify-between',
              children: [
                WDiv(className: token, child: const Text('a')),
                const WDiv(className: 'bg-white', child: Text('b')),
              ],
            ),
          ),
        );

        expect(tester.takeException(), isNull);
      });
    }
  });

  group('No-grow / no-shrink tokens win last-class-wins', () {
    late BuildContext ctx;

    Future<void> pumpCtx(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: Builder(
              builder: (context) {
                ctx = context;
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    }

    testWidgets('grow-0 after grow cancels the grow (flex stays null)', (
      tester,
    ) async {
      await pumpCtx(tester);
      expect(WindParser.parse('grow grow-0', ctx).flex, isNull);
    });

    testWidgets('flex-none after flex-auto cancels the fit (flexFit null)', (
      tester,
    ) async {
      await pumpCtx(tester);
      expect(WindParser.parse('flex-auto flex-none', ctx).flexFit, isNull);
    });

    testWidgets('shrink-0 after shrink cancels the fit (flexFit null)', (
      tester,
    ) async {
      await pumpCtx(tester);
      expect(WindParser.parse('shrink shrink-0', ctx).flexFit, isNull);
    });

    testWidgets('grow after grow-0 wins (rightmost grow re-enables flex)', (
      tester,
    ) async {
      await pumpCtx(tester);
      expect(WindParser.parse('grow-0 grow', ctx).flex, 1);
    });

    testWidgets('flex-none cancels both grow and shrink in one token', (
      tester,
    ) async {
      await pumpCtx(tester);
      final styles = WindParser.parse('grow shrink flex-none', ctx);
      expect(styles.flex, isNull);
      expect(styles.flexFit, isNull);
    });
  });
}
