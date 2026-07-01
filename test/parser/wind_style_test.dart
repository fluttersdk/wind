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

  group('WindStyle equality and hashCode', () {
    test('two equal styles compare equal and share a hashCode', () {
      const a = WindStyle(mouseCursor: SystemMouseCursors.click);
      const b = WindStyle(mouseCursor: SystemMouseCursors.click);
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('a differing mouseCursor breaks equality', () {
      const a = WindStyle(mouseCursor: SystemMouseCursors.click);
      const c = WindStyle(mouseCursor: SystemMouseCursors.text);
      expect(a == c, isFalse);
    });

    test('copyWith carries mouseCursor through', () {
      const base = WindStyle();
      final updated = base.copyWith(mouseCursor: SystemMouseCursors.forbidden);
      expect(updated.mouseCursor, SystemMouseCursors.forbidden);
      expect(updated.toString(), contains('mouseCursor'));
    });
  });
}
