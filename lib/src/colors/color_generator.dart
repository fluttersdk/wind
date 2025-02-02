import 'package:flutter/material.dart';

class ColorGenerator {
  static final Map<int, double> palette = {
    50: 0.9,
    100: 0.8,
    200: 0.7,
    300: 0.6,
    400: 0.5,
    500: 0.4,
    600: 0.3,
    700: 0.2,
    800: 0.1,
    900: 0.0,
  };

  static MaterialColor toMaterialColor(Color color) {
    final int red = color.red;
    final int green = color.green;
    final int blue = color.blue;

    final Map<int, Color> colorPalette = {
      for (final entry in palette.entries)
        entry.key: Color.fromRGBO(red, green, blue, entry.value),
    };

    return MaterialColor(color.value, colorPalette);
  }

  static Color darken(Color color, {double amount = .1}) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  static Color lighten(Color color, {double amount = .1}) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
