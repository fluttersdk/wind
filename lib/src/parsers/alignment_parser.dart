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
    'alignment-left': Alignment.centerLeft,
    'alignment-right': Alignment.centerRight,
  };

  static final Map<String, Alignment> textAlignments = {
    'text-left': Alignment.centerLeft,
    'text-center': Alignment.center,
    'text-right': Alignment.centerRight,
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

  static Alignment? toTextAlignment(String className) {
    Alignment? alignment;

    for (final String cls in className.split(' ')) {
      if (textAlignments.containsKey(cls)) {
        alignment = textAlignments[cls];
      }
    }

    return alignment;
  }

  static Alignment? applyAlignment(BuildContext context, String className) {
    Alignment? alignment;

    for (final String name in className.split(' ')) {
      if (alignments.containsKey(name) &&
          ScreensParser.canApply(context, name)) {
        alignment = alignments[name];
      }
    }

    return alignment;
  }

  static Alignment? applyTextAlignment(BuildContext context, String className) {
    Alignment? alignment;

    for (final String name in className.split(' ')) {
      if (textAlignments.containsKey(name) &&
          ScreensParser.canApply(context, name)) {
        alignment = textAlignments[name];
      }
    }

    return alignment;
  }

  static Widget apply(BuildContext context, String className, Widget child,
      {bool isText = false}) {
    final alignment = applyAlignment(context, className);
    if (alignment != null) {
      return Align(
        alignment: alignment,
        child: child,
      );
    }

    if (isText == true) {
      final textAlignment = applyTextAlignment(context, className);
      if (textAlignment != null) {
        return Align(
          alignment: textAlignment,
          child: child,
        );
      }
    }

    return child;
  }
}
