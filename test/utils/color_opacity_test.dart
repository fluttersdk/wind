import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/src/utils/color_utils.dart';

void main() {
  group('Color Opacity Utilities', () {
    group('parseColorOpacity', () {
      test('parses color without opacity', () {
        final result = parseColorOpacity('blue-500');
        expect(result.colorPart, 'blue-500');
        expect(result.opacity, isNull);
      });

      test('parses color with standard opacity', () {
        final result = parseColorOpacity('blue-500/50');
        expect(result.colorPart, 'blue-500');
        expect(result.opacity, 0.5);
      });

      test('parses color with 0% opacity', () {
        final result = parseColorOpacity('red-500/0');
        expect(result.colorPart, 'red-500');
        expect(result.opacity, 0.0);
      });

      test('parses color with 100% opacity', () {
        final result = parseColorOpacity('green-500/100');
        expect(result.colorPart, 'green-500');
        expect(result.opacity, 1.0);
      });

      test('parses arbitrary opacity with brackets', () {
        final result = parseColorOpacity('blue-500/[75]');
        expect(result.colorPart, 'blue-500');
        expect(result.opacity, 0.75);
      });

      test('handles arbitrary color with opacity', () {
        final result = parseColorOpacity('[#FF5733]/50');
        expect(result.colorPart, '[#FF5733]');
        expect(result.opacity, 0.5);
      });

      test('returns null opacity for invalid opacity value', () {
        final result = parseColorOpacity('blue-500/abc');
        expect(result.colorPart, 'blue-500');
        expect(result.opacity, isNull);
      });
    });

    group('applyOpacity', () {
      test('applies 50% opacity', () {
        const color = Color(0xFFFF0000);
        final result = applyOpacity(color, 0.5);
        expect(result.a, closeTo(0.5, 0.01));
        expect(result.r, closeTo(1.0, 0.01));
      });

      test('applies 0% opacity (fully transparent)', () {
        const color = Color(0xFFFF0000);
        final result = applyOpacity(color, 0.0);
        expect(result.a, 0.0);
      });

      test('applies 100% opacity (fully opaque)', () {
        const color = Color(0xFFFF0000);
        final result = applyOpacity(color, 1.0);
        expect(result.a, closeTo(1.0, 0.01));
      });

      test('applies 25% opacity', () {
        const color = Color(0xFF0000FF);
        final result = applyOpacity(color, 0.25);
        expect(result.a, closeTo(0.25, 0.01));
      });

      test('clamps opacity below 0', () {
        const color = Color(0xFFFF0000);
        final result = applyOpacity(color, -0.1);
        expect(result.a, 0.0);
      });

      test('clamps opacity above 100', () {
        const color = Color(0xFFFF0000);
        final result = applyOpacity(color, 1.5);
        expect(result.a, closeTo(1.0, 0.01));
      });
    });
  });
}
