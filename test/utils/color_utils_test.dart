import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/src/utils/color_utils.dart';

void main() {
  group('ColorUtils', () {
    group('invertMaterialColor', () {
      test('should correctly invert a MaterialColor', () {
        const MaterialColor blue = Colors.blue;
        final invertedBlue = invertMaterialColor(blue);

        expect(invertedBlue.value, blue.value);
        expect(invertedBlue.shade50, blue.shade900);
        expect(invertedBlue.shade100, blue.shade800);
        expect(invertedBlue.shade200, blue.shade700);
        expect(invertedBlue.shade300, blue.shade600);
        expect(invertedBlue.shade400, blue.shade500);
        expect(invertedBlue.shade500, blue.shade400);
        expect(invertedBlue.shade600, blue.shade300);
        expect(invertedBlue.shade700, blue.shade200);
        expect(invertedBlue.shade800, blue.shade100);
        expect(invertedBlue.shade900, blue.shade50);
      });
    });

    group('hexToColor', () {
      test('should handle #RRGGBB format', () {
        expect(hexToColor('#FF5733'), const Color(0xFFFF5733));
      });

      test('should handle #AARRGGBB format', () {
        expect(hexToColor('#80FF5733'), const Color(0x80FF5733));
      });

      test('should handle #RGB format', () {
        expect(hexToColor('#F53'), const Color(0xFFFF5533));
      });

      test('should handle #ARGB format', () {
        expect(hexToColor('#8F53'), const Color(0x88FF5533));
      });

      test('should handle RRGGBB format without #', () {
        expect(hexToColor('FF5733'), const Color(0xFFFF5733));
      });

      test('should handle AARRGGBB format without #', () {
        expect(hexToColor('80FF5733'), const Color(0x80FF5733));
      });

      test('should handle RGB format without #', () {
        expect(hexToColor('F53'), const Color(0xFFFF5533));
      });

      test('should handle ARGB format without #', () {
        expect(hexToColor('8F53'), const Color(0x88FF5533));
      });
    });
  });
}

