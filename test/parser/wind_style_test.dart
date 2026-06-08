import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/src/parser/wind_style.dart';

void main() {
  group('WindStyle.copyWith decoration handling', () {
    test('keeps decoration null when neither side sets one', () {
      // A padding/margin/text-only copyWith must not fabricate an empty
      // BoxDecoration; otherwise every such widget wraps a needless Container.
      const style = WindStyle();
      final updated = style.copyWith(padding: const EdgeInsets.all(16));

      expect(updated.padding, isNotNull);
      expect(updated.decoration, isNull);
    });

    test('preserves an existing decoration when copyWith omits it', () {
      const style = WindStyle(decoration: BoxDecoration(color: Colors.red));
      final updated = style.copyWith(width: 100);

      expect(updated.width, 100);
      expect(updated.decoration?.color, Colors.red);
    });

    test('merges an incoming decoration onto the existing one', () {
      const style = WindStyle(decoration: BoxDecoration(color: Colors.red));
      final updated = style.copyWith(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      );

      expect(updated.decoration?.color, Colors.red);
      expect(updated.decoration?.borderRadius,
          const BorderRadius.all(Radius.circular(8)));
    });
  });
}
