import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';
import 'package:fluttersdk_wind/src/utils/color_utils.dart';

void main() {
  group('ColorUtils', () {
    group('invertMaterialColor', () {
      test('should correctly invert a MaterialColor', () {
        const MaterialColor blue = Colors.blue;
        final invertedBlue = invertMaterialColor(blue);

        // Check primary color equality
        expect(invertedBlue.r, blue.r);
        expect(invertedBlue.g, blue.g);
        expect(invertedBlue.b, blue.b);
        expect(invertedBlue.a, blue.a);
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

    group('contrastRatio', () {
      test('white against black is 21.0, the WCAG maximum', () {
        expect(
          contrastRatio(const Color(0xFFFFFFFF), const Color(0xFF000000)),
          closeTo(21.0, 0.01),
        );
      });

      test('a colour against itself is 1.0, the WCAG minimum', () {
        const Color grey = Color(0xFF767676);
        expect(contrastRatio(grey, grey), closeTo(1.0, 0.01));
      });

      test('is symmetric: the argument order does not change the ratio', () {
        const Color a = Color(0xFF767676);
        const Color b = Color(0xFF07090C);
        expect(contrastRatio(a, b), contrastRatio(b, a));
      });
    });

    group('contrastForeground', () {
      test(
        'picks white over the app near-black at a mid-grey background, '
        'where the 0.179 luminance threshold would pick the worse candidate',
        () {
          // 4.54:1 (white) beats 4.39:1 (near-black); the shortcut threshold
          // would choose the near-black candidate here, the worse of the two.
          const Color midGrey = Color(0xFF767676);
          const Color nearBlack = Color(0xFF07090C);

          expect(
            contrastForeground(midGrey, dark: nearBlack),
            const Color(0xFFFFFFFF),
          );
        },
      );

      test('picks black on a light brand colour', () {
        expect(
          contrastForeground(const Color(0xFFFFEB3B)),
          const Color(0xFF000000),
        );
      });

      test('picks white on a dark navy brand colour', () {
        expect(
          contrastForeground(const Color(0xFF001F3F)),
          const Color(0xFFFFFFFF),
        );
      });
    });
  });
}
