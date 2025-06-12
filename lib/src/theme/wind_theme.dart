import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:platform_info/platform_info.dart';

import '../colors/wind_colors.dart';

class WindTheme {
  /// Static colors
  static final Map<String, MaterialColor> _colors = {
    'slate': WindColors.slate,
    'gray': WindColors.gray,
    'zinc': WindColors.zinc,
    'neutral': WindColors.neutral,
    'stone': WindColors.stone,
    'red': WindColors.red,
    'orange': WindColors.orange,
    'amber': WindColors.amber,
    'yellow': WindColors.yellow,
    'lime': WindColors.lime,
    'green': WindColors.green,
    'emerald': WindColors.emerald,
    'teal': WindColors.teal,
    'cyan': WindColors.cyan,
    'sky': WindColors.sky,
    'blue': WindColors.blue,
    'indigo': WindColors.indigo,
    'violet': WindColors.violet,
    'purple': WindColors.purple,
    'fuchsia': WindColors.fuchsia,
    'pink': WindColors.pink,
    'black': WindColors.black,
    'realBlack': WindColors.realBlack,
    'white': WindColors.white,
    'realWhite': WindColors.realBlack,
    'primary': WindColors.indigo,
    'secondary': WindColors.slate,
  };

  /// Original colors
  static final Map<String, MaterialColor> _originalColors = {};

  /// Darken colors
  static final Map<String, MaterialColor> _darkenColors = {};

  /// Static colors that should not be darkened
  static final List<String> _nonDarkenColors = [
    'realBlack'
        'realWhite',
  ];

  /// Static screen sizes
  static final Map<String, int> _screens = {
    'sm': 640,
    'md': 768,
    'lg': 1024,
    'xl': 1280,
    '2xl': 1536,
  };

  /// Static rounded sizes
  static final Map<String, double> _roundedSizes = {
    'none': 0, // rounded-none
    'default': 0.25, // rounded-default
    'sm': 0.125, // rounded-sm
    'md': 0.375, // rounded-md
    'lg': 0.5, // rounded-lg
    'xl': 0.75, // rounded-xl
    '2xl': 1, // rounded-2xl = 1 * 4 (pixel factor) * 4 (rem factor) = 16px
    '3xl': 1.5, // rounded-3xl
    'full': 9999, // rounded-full
  };

  /// Static shadow sizes
  static final Map<String, double> _shadowSizes = {
    'none': 0,
    'sm': 1,
    'default': 2,
    'md': 4,
    'lg': 8,
    'xl': 12,
    '2xl': 16,
    '3xl': 24,
    'inner': 1,
  };

  /// Static font weights
  static final Map<String, FontWeight> _fontWeights = {
    'thin': FontWeight.w100,
    'extralight': FontWeight.w200,
    'light': FontWeight.w300,
    'normal': FontWeight.w400,
    'medium': FontWeight.w500,
    'semibold': FontWeight.w600,
    'bold': FontWeight.w700,
    'extrabold': FontWeight.w800,
    'black': FontWeight.w900,
  };

  /// Static font sizes
  static final Map<String, double> _fontSizes = {
    'xs': 0.75,
    'sm': 0.875,
    'base': 1,
    'lg': 1.125,
    'xl': 1.25,
    '2xl': 1.5,
    '3xl': 1.875,
    '4xl': 2.25,
    '5xl': 3,
    '6xl': 4,
  };

  /// Static letter spacings
  static final Map<String, double> _letterSpacings = {
    'tighter': -0.05,
    'tight': -0.025,
    'normal': 0,
    'wide': 0.025,
    'wider': 0.05,
    'widest': 0.1,
  };

  /// Static line heights
  static final Map<String, double> _lineHeights = {
    '3': 0.75,
    '4': 1,
    '5': 1.25,
    '6': 1.5,
    '7': 1.75,
    '8': 2,
    '9': 2.25,
    '10': 2.5,
    'none': 1,
    'tight': 1.25,
    'snug': 1.375,
    'normal': 1.5,
    'relaxed': 1.625,
    'loose': 2,
  };

  /// Static operating systems
  static final List<String> _operatingSystems = [
    'ios',
    'android',
    'fuchsia',
    'linux',
    'macos',
    'windows',
    'web',
  ];

  /// Static pixel factor
  static double _pixelFactor = 4.0;

  /// Theme brightness type
  static Brightness _type = Brightness.light;

  /// Body font string
  static String _bodyFontString = 'Inter';

  /// Display font string
  static String? _displayFontString;

  /// Helper function to check if a color is dark
  static bool _darkColorsGenerated = false;

  static void generateDarkenColors() {
    if (WindTheme.getType() == Brightness.light && _darkColorsGenerated) {
      _darkColorsGenerated = false;
      for (String color in _colors.keys) {
        addColor(
            color,
            _originalColors.containsKey(color)
                ? _originalColors[color]!
                : _colors[color]!);
      }
    }

    if (WindTheme.getType() == Brightness.dark && !_darkColorsGenerated) {
      _darkColorsGenerated = true;

      for (String color in _colors.keys) {
        if (_darkenColors.containsKey(color)) {
          addOriginalColor(color, _colors[color]!);
          addColor(color, _darkenColors[color]!);
        } else if (color == 'black') {
          // Nightwind benzeri şekilde ters çevirme
          addOriginalColor(color, WindColors.black);
          addColor(color, WindColors.white);
        } else if (color == 'white') {
          addOriginalColor(color, WindColors.white);
          addColor(color, WindColors.whiteDark);
        } else {
          // **Nightwind gibi renk skalası dönüşümü**
          addOriginalColor(color, _colors[color]!);
          addColor(color, invertMaterialColor(_colors[color]!));
        }
      }
    }
  }

  /// **📌 Nightwind'e benzer bir şekilde MaterialColor'ı tersine çevirme**
  static MaterialColor invertMaterialColor(MaterialColor color) {
    return MaterialColor(color.toARGB32(), <int, Color>{
      50: color.shade900,
      100: color.shade800,
      200: color.shade700,
      300: color.shade600,
      400: color.shade500,
      500: color.shade400,
      600: color.shade300,
      700: color.shade200,
      800: color.shade100,
      900: color.shade50,
    });
  }

  static void addDarkenColor(String name, MaterialColor color) {
    _darkenColors[name] = color;
  }

  static bool hasLineHeight(String height) {
    return _lineHeights.containsKey(height);
  }

  static double getLineHeight(String height) {
    return _lineHeights[height]!;
  }

  static void setLineHeight(String height, double value) {
    _lineHeights[height] = value;
  }

  static void removeLineHeight(String height) {
    _lineHeights.remove(height);
  }

  static bool hasLetterSpacing(String spacing) {
    return _letterSpacings.containsKey(spacing);
  }

  static double getLetterSpacing(String spacing) {
    return _letterSpacings[spacing]!;
  }

  static void setLetterSpacing(String spacing, double value) {
    _letterSpacings[spacing] = value;
  }

  static void removeLetterSpacing(String spacing) {
    _letterSpacings.remove(spacing);
  }

  static bool hasFontSize(String size) {
    return _fontSizes.containsKey(size);
  }

  static double getFontSize(String size) {
    return _fontSizes[size]!;
  }

  static void setFontSize(String size, double value) {
    _fontSizes[size] = value;
  }

  static void removeFontSize(String size) {
    _fontSizes.remove(size);
  }

  static bool hasFontWeight(String weight) {
    return _fontWeights.containsKey(weight);
  }

  static FontWeight getFontWeight(String weight) {
    return _fontWeights[weight]!;
  }

  static void setFontWeight(String weight, FontWeight value) {
    _fontWeights[weight] = value;
  }

  static void removeFontWeight(String weight) {
    _fontWeights.remove(weight);
  }

  static bool hasShadowSize(String size) {
    return _shadowSizes.containsKey(size);
  }

  static double getShadowSize(String size) {
    return _shadowSizes[size]!;
  }

  static void setShadowSize(String size, double value) {
    _shadowSizes[size] = value;
  }

  static void removeShadowSize(String size) {
    _shadowSizes.remove(size);
  }

  static bool hasRoundedSize(String size) {
    return _roundedSizes.containsKey(size);
  }

  static double getRoundedSize(String size) {
    return _roundedSizes[size]!;
  }

  static void setRoundedSize(String size, double value) {
    _roundedSizes[size] = value;
  }

  static void removeRoundedSize(String size) {
    _roundedSizes.remove(size);
  }

  static double getPixelFactor() {
    return _pixelFactor;
  }

  static double getRemFactor() {
    return _pixelFactor * 4;
  }

  static bool hasOperatingSystem(String name) {
    return _operatingSystems.contains(name);
  }

  static bool checkOperatingSystem(String name) {

    switch (name) {
      case 'ios':
        return Platform.instance.iOS;
      case 'android':
        return Platform.instance.android;
      case 'fuchsia':
        return Platform.instance.fuchsia;
      case 'linux':
        return Platform.instance.linux;
      case 'macos':
        return Platform.instance.macOS;
      case 'windows':
        return Platform.instance.windows;
      case 'web':
        return Platform.instance.js;
    }

    return false;
  }

  static void setPixelFactor(double factor) {
    _pixelFactor = factor;
  }

  static bool hasScreen(String key) {
    return _screens.containsKey(key);
  }

  static bool hasScreenOrModeOrOperatingSystem(String key) {
    return _screens.containsKey(key) ||
        key == 'dark' ||
        key == 'light' ||
        _operatingSystems.contains(key);
  }

  static List<String> getScreenKeys() {
    return _screens.keys.toList();
  }

  static int getScreenValue(String key, {bool next = false}) {
    if (next) {
      int current = _screens[key]!;
      int smallest = 0;

      _screens.forEach((String key, int value) {
        if (value > current) {
          if (smallest == 0 || value < smallest) {
            smallest = value;
          }
        }
      });

      return smallest;
    }

    return _screens[key]!;
  }

  static int getSmallestScreen(String key) {
    int smallest = 0;
    int current = _screens[key]!;

    _screens.forEach((String key, int value) {
      if (value < current) {
        smallest = value;
      }
    });

    return smallest;
  }

  static Map<String, int> getScreens() {
    return _screens;
  }

  static void addScreen(String name, int value) {
    _screens[name] = value;
  }

  static void removeScreen(String name) {
    _screens.remove(name);
  }

  static void updateScreen(String name, int value) {
    _screens[name] = value;
  }

  static void addColor(String name, MaterialColor color) {
    _colors[name] = color;
  }

  static void addOriginalColor(String name, MaterialColor color) {
    _originalColors[name] = color;
  }

  static void addStaticColor(String name) {
    _nonDarkenColors.add(name);
  }

  static void removeStaticColor(String name) {
    _nonDarkenColors.remove(name);
  }

  static MaterialColor getMaterialColor(String name) {
    return _colors[name]!;
  }

  static Color getColor(String name, {int shade = 500}) {
    return _colors[name]![shade == 0 ? 500 : shade]!;
  }

  static bool isValidColor(String name) {
    return _colors.containsKey(name);
  }

  static Map<String, MaterialColor> getColors() {
    return _colors;
  }

  static List<String> getStaticColors() {
    return _nonDarkenColors;
  }

  static void setType(Brightness type) {
    _type = type;

    generateDarkenColors();
  }

  static void setTypeFromContext(BuildContext context) {
    setType(Theme.of(context).brightness);
  }

  static Brightness getType() {
    return _type;
  }

  static void setBodyFontString(String bodyFontString) {
    _bodyFontString = bodyFontString;
  }

  static String getBodyFontString() {
    return _bodyFontString;
  }

  static void setDisplayFontString(String displayFontString) {
    _displayFontString = displayFontString;
  }

  static String getDisplayFontString() {
    return _displayFontString ?? _bodyFontString;
  }

  static Color hexToColor(String code) {
    if (code.length == 4) {
      code = '#' + code[1] * 2 + code[2] * 2 + code[3] * 2;
    }

    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  static ThemeData toThemeData({
    TextTheme? textTheme,
    String? bodyFontString,
    String? displayFontString,
    MaterialColor? primarySwatch,
    Color? accentColor,
    Color? cardColor,
    Color? backgroundColor,
    Color? errorColor,
    Brightness? brightness,
  }) {
    TextTheme baseTextTheme =
        textTheme ?? Typography.material2021().englishLike;
    TextTheme bodyTextTheme = GoogleFonts.getTextTheme(
        bodyFontString ?? getBodyFontString(), baseTextTheme);
    TextTheme displayTextTheme = GoogleFonts.getTextTheme(
        displayFontString ?? getDisplayFontString(), baseTextTheme);

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: primarySwatch ?? getMaterialColor('primary'),
        accentColor: accentColor ?? getColor('secondary'),
        cardColor: cardColor ?? getColor('white'),
        backgroundColor: backgroundColor ?? getColor('gray', shade: 50),
        errorColor: errorColor ?? getColor('red'),
        brightness: brightness ?? _type,
      ),
      scaffoldBackgroundColor: getColor('gray', shade: 50),
      textTheme: displayTextTheme.copyWith(
        bodyLarge: bodyTextTheme.bodyLarge,
        bodyMedium: bodyTextTheme.bodyMedium,
        bodySmall: bodyTextTheme.bodySmall,
        labelLarge: bodyTextTheme.labelLarge,
        labelMedium: bodyTextTheme.labelMedium,
        labelSmall: bodyTextTheme.labelSmall,
      ),
    );
  }

  static ThemeData toThemeCallback(
    BuildContext context, {
    TextTheme? textTheme,
    String? bodyFontString,
    String? displayFontString,
    MaterialColor? primarySwatch,
    Color? accentColor,
    Color? cardColor,
    Color? backgroundColor,
    Color? errorColor,
    Brightness? brightness,
  }) {
    if (brightness != null) {
      WindTheme.setType(brightness);
    } else {
      setTypeFromContext(context);
    }

    return toThemeData(
      textTheme: textTheme ?? Theme.of(context).textTheme,
      bodyFontString: bodyFontString,
      displayFontString: displayFontString,
      primarySwatch: primarySwatch,
      accentColor: accentColor,
      cardColor: cardColor,
      backgroundColor: backgroundColor,
      errorColor: errorColor,
      brightness: brightness ?? _type,
    );
  }
}
