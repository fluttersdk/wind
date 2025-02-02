import 'package:flutter/material.dart';

import 'screens_parser.dart';

/// Parses the font style from a class name and returns FontStyle
/// Example: italic, not-italic
class FontStyleParser {
  static final Map<String, FontStyle> fontStyles = {
    'italic': FontStyle.italic,
    'not-italic	': FontStyle.normal,
  };

  static FontStyle? toFontStyle(String className) {
    FontStyle? style;
    for (var name in className.split(' ')) {
      if (fontStyles.containsKey(name)) {
        style = fontStyles[name];
      }
    }
    return style;
  }

  static FontStyle? applyFontStyle(BuildContext context, String className) {
    FontStyle? fontStyle;
    for (var name in className.split(' ')) {
      if (fontStyles.containsKey(name) && ScreensParser.canApply(context, name)) {
        fontStyle = fontStyles[name];
      }
    }
    return fontStyle;
  }
}