import 'package:flutter/material.dart';

import 'screens_parser.dart';

/// Parses the text alignment from a class name
/// Example: text-left, text-center, text-right, text-justify, text-start, text-end
class TextAlignParser {
  static final Map<String, TextAlign> alignments = {
    'text-left': TextAlign.left,
    'text-center': TextAlign.center,
    'text-right': TextAlign.right,
    'text-justify': TextAlign.justify,
    'text-start': TextAlign.start,
    'text-end': TextAlign.end,
  };

  static TextAlign? toAlignment(String className) {
    TextAlign? alignment;
    for (var name in className.split(' ')) {
      if (alignments.containsKey(name)) {
        alignment = alignments[name];
      }
    }
    return alignment;
  }

  static TextAlign? applyAlignment(BuildContext context, String className) {
    TextAlign? alignment;
    for (var name in className.split(' ')) {
      if (alignments.containsKey(name) && ScreensParser.canApply(context, name)) {
        alignment = alignments[name];
      }
    }
    return alignment;
  }
}