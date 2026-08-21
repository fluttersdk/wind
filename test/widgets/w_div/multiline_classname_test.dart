import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// The composition helpers scan a child's raw `className` for tokens, and this
/// project's own convention writes any className with 3+ concerns as a
/// triple-quoted string with one concern per line (`.claude/rules/widgets.md`).
///
/// A scan that splits on a single space therefore sees `flex-1\n` rather than
/// `flex-1` for every token that ends a line, and misses it. Each helper fails
/// differently when that happens, so each gets its own case here: the wrap is
/// applied twice, or applied where it should not be, or skipped where it should
/// not be.
void main() {
  setUp(() {
    WindParser.clearCache();
  });

  /// Pumps [child] inside a fixed-width Wind surface.
  Future<void> pumpAt(WidgetTester tester, double width, Widget child) {
    return tester.pumpWidget(
      MaterialApp(
        home: WindTheme(
          data: WindThemeData(),
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(width: width, child: child),
          ),
        ),
      ),
    );
  }

  testWidgets(
    'a multi-line flex-1 child is not wrapped a second time',
    (tester) async {
      // `_selfWrapsInFlex` guards against exactly this: the child already
      // carries its own Expanded, so a parent Flexible on top of it throws
      // "Incorrect use of ParentDataWidget". `overflow-hidden` wraps
      // unconditionally, which is the shortest route to the double wrap.
      await pumpAt(
        tester,
        400,
        const WDiv(
          className: 'flex flex-row items-center overflow-hidden',
          children: [
            WDiv(
              className: '''
                flex-1
                bg-white dark:bg-gray-800
              ''',
              child: SizedBox(height: 20),
            ),
            WDiv(child: SizedBox(width: 24, height: 24)),
          ],
        ),
      );

      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'a multi-line shrink-0 child keeps its intrinsic width',
    (tester) async {
      // `shrink-0` is the caller saying "never shrink me". Missing the token
      // wraps the child in a Flexible, whose share in a crowded row is smaller
      // than the width it asked for.
      await pumpAt(
        tester,
        100,
        const WDiv(
          className: 'flex flex-row items-center overflow-hidden',
          children: [
            WDiv(
              key: Key('fixed'),
              className: '''
                w-24 shrink-0
                bg-white dark:bg-gray-800
              ''',
              child: SizedBox(height: 20),
            ),
            WText('Very Long Value Text That Cannot Fit', className: 'text-sm'),
          ],
        ),
      );

      expect(tester.getSize(find.byKey(const Key('fixed'))).width, 96);
    },
  );
}
