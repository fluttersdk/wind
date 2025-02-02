import 'package:flutter/material.dart';

import 'screens_parser.dart';

/// Parses the alignment from a class name
/// Example: alignment-top-left
class AlignmentParser {
  static final Map<String, Alignment> alignments = {
    'alignment-top-left': Alignment.topLeft,
    'alignment-top-center': Alignment.topCenter,
    'alignment-top-right': Alignment.topRight,
    'alignment-center-left': Alignment.centerLeft,
    'alignment-center': Alignment.center,
    'alignment-center-right': Alignment.centerRight,
    'alignment-bottom-left': Alignment.bottomLeft,
    'alignment-bottom-center': Alignment.bottomCenter,
    'alignment-bottom-right': Alignment.bottomRight,
  };

  static Alignment? toAlignment(String className) {
    Alignment? alignment;

    for (final String cls in className.split(' ')) {
      if (alignments.containsKey(cls)) {
        alignment = alignments[cls];
      }
    }

    return alignment;
  }

  static Alignment? applyAlignment(BuildContext context, String className) {
    Alignment? alignment;

    for (final String name in className.split(' ')) {
      if (alignments.containsKey(name) && ScreensParser.canApply(context, name)) {
        alignment = alignments[name];
      }
    }

    return alignment;
  }
}