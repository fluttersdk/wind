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

    test('a differing letterSpacingUnit breaks equality', () {
      const px = WindStyle(letterSpacing: 1);
      const em = WindStyle(
        letterSpacing: 1,
        letterSpacingUnit: WindLetterSpacingUnit.em,
      );

      expect(px == em, isFalse);
      expect(em.toString(), contains('letterSpacingUnit'));
    });
  });

  group('WindStyle letter spacing resolution', () {
    test('passes px letter spacing through unchanged', () {
      const style = WindStyle(fontSize: 30, letterSpacing: 1.5);

      expect(style.toTextStyle().letterSpacing, 1.5);
      expect(style.needsInheritedFontSize, isFalse);
    });

    test('resolves em letter spacing against its own font size', () {
      const style = WindStyle(
        fontSize: 14,
        letterSpacing: -0.025,
        letterSpacingUnit: WindLetterSpacingUnit.em,
      );

      expect(
        style.toTextStyle(inheritedFontSize: 40).letterSpacing,
        closeTo(-0.35, 1e-9),
      );
      expect(style.needsInheritedFontSize, isFalse);
    });

    test('resolves em letter spacing against the inherited font size', () {
      const style = WindStyle(
        letterSpacing: 0.025,
        letterSpacingUnit: WindLetterSpacingUnit.em,
      );

      expect(
        style.toTextStyle(inheritedFontSize: 20).letterSpacing,
        closeTo(0.5, 1e-9),
      );
      expect(style.needsInheritedFontSize, isTrue);
    });

    test('resolves em against kDefaultFontSize when no size is known', () {
      const style = WindStyle(
        letterSpacing: 0.1,
        letterSpacingUnit: WindLetterSpacingUnit.em,
      );

      expect(
        style.toTextStyle().letterSpacing,
        closeTo(0.1 * kDefaultFontSize, 1e-9),
      );
    });

    test('copyWith carries the letter spacing unit through', () {
      const base = WindStyle(letterSpacing: 2);
      final updated = base.copyWith(
        letterSpacing: 0.05,
        letterSpacingUnit: WindLetterSpacingUnit.em,
      );

      expect(updated.letterSpacing, 0.05);
      expect(updated.letterSpacingUnit, WindLetterSpacingUnit.em);
      expect(
          base.copyWith(width: 1).letterSpacingUnit, WindLetterSpacingUnit.px);
    });
  });
}
