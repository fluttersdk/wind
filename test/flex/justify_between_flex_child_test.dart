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
