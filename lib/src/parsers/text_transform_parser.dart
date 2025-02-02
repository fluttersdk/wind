import 'package:flutter/material.dart';

import 'screens_parser.dart';

/// Parses text transform classes and returns transformed text
/// Example: uppercase, lowercase, capitalize, none
class TextTransformParser {
  static final List<String> transforms = [
    'uppercase',
    'lowercase',
    'capitalize',
    'none',
  ];

  static String toTransform(String text, String className) {
    if (text.isNotEmpty) {
      switch (className) {
        case 'uppercase':
          return text.toUpperCase();
        case 'lowercase':
          return text.toLowerCase();
        case 'capitalize':
          return text[0].toUpperCase() + text.substring(1).toLowerCase();
        case 'none':
          return text;
      }
    }

    return text;
  }

  static String applyTransform(
      BuildContext context, String text, String className) {
    String transformedText = text;

    for (var name in className.split(' ')) {
      if (transforms.contains(name) && ScreensParser.canApply(context, name)) {
        transformedText = toTransform(text, name);
      }
    }

    return transformedText;
  }
}
