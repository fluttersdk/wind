import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Tests that a `justify-between` row honors an explicit `flex-1` child.
///
/// In CSS, `justify-content: space-between` does NOT make items flexible: the
/// free space is distributed BETWEEN them and each item keeps its content
/// size (`flex: 0 1 auto`, shrinking only on overflow). A child that declares
/// `flex: 1` absorbs the free space; its siblings stay at their content width.
///
/// Wind approximates the shrink half of that default by wrapping children in
/// `Flexible`, which is fine on its own but gives every child an equal flex
/// share. That share starves a sibling that asked for the space explicitly, so
/// a row with a `flex-1` column and a small icon column splits 50/50 and the
/// column that should have grown is capped at half the row.
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
    'justify-between gives a flex-1 child the whole free space',
    (tester) async {
      await pumpAt(
        tester,
        400,
        const WDiv(
          className: 'flex flex-row items-center justify-between',
          children: [
            WDiv(
              key: Key('grower'),
              className: 'flex-1',
              child: SizedBox(height: 20),
            ),
            WDiv(
              key: Key('icon'),
              child: SizedBox(width: 24, height: 24),
            ),
          ],
        ),
      );

      expect(tester.getSize(find.byKey(const Key('icon'))).width, 24);
      expect(
        tester.getSize(find.byKey(const Key('grower'))).width,
        400 - 24,
        reason: 'the sibling keeps its content width, so everything left over '
            'belongs to the child that asked for it',
      );
    },
  );

  testWidgets(
    'justify-between gives a bare w-full child the whole free space',
    (tester) async {
      // The Row composer turns a bare `w-full` child into an `Expanded`, and
      // `doc/layout/flexbox.md` documents it as filling the row "exactly like
      // flex-1". Without w-full counted as a grow claim the two diverge here:
      // the flex-1 case above measures 376 and this one measured 200.
      await pumpAt(
        tester,
        400,
        const WDiv(
          className: 'flex flex-row items-center justify-between',
          children: [
            WDiv(
              key: Key('grower'),
              className: 'w-full',
              child: SizedBox(height: 20),
            ),
            WDiv(
              key: Key('icon'),
              child: SizedBox(width: 24, height: 24),
            ),
          ],
        ),
      );

      expect(tester.getSize(find.byKey(const Key('icon'))).width, 24);
      expect(tester.getSize(find.byKey(const Key('grower'))).width, 400 - 24);
    },
  );

  testWidgets(
    'an inactive prefixed grow token does not speak for the row',
    (tester) async {
      // A prefixed token is conditional, so it cannot be resolved from the
      // class string alone. Counting it strips the shrink wrap off every
      // sibling at a breakpoint or state where nothing actually grows: with
      // `hover:flex-1` claiming the row while the hover state was inactive,
      // this text laid out at 504 in a 100pt row and Flutter reported
      // "A RenderFlex overflowed by 424 pixels on the right".
      await pumpAt(
        tester,
        100,
        const WDiv(
          className: 'flex flex-row items-center justify-between',
          children: [
            WDiv(
              key: Key('conditional'),
              className: 'hover:flex-1',
              child: SizedBox(width: 20, height: 20),
            ),
            WText(
              key: Key('long'),
              'Very Long Value Text That Cannot Fit',
              className: 'text-sm',
            ),
          ],
        ),
      );

      expect(
        tester.getSize(find.byKey(const Key('long'))).width,
        100 - 20,
        reason: 'the shrink wrap stays on while the hover variant is inactive, '
            'so the text shrinks into the row instead of overflowing it',
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'justify-between still shrinks siblings when nobody claims flex',
    (tester) async {
      await pumpAt(
        tester,
        100,
        const WDiv(
          className: 'flex flex-row items-center justify-between',
          children: [
            WText('Label', className: 'text-sm'),
            WText('Very Long Value Text', className: 'text-sm'),
          ],
        ),
      );

      expect(tester.takeException(), isNull);
    },
  );
}
