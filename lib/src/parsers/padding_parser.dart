import 'package:flutter/material.dart';

import '../helpers.dart';
import '../theme/wind_theme.dart';
import 'screens_parser.dart';

class PaddingParser {
  static final RegExp _paddingRegExp = RegExp(r'^(?:[a-zA-Z0-9]+:)?p-(?<size>[\[\]0-9.]+)$');
  static final RegExp _paddingLeftRegExp = RegExp(r'^(?:[a-zA-Z0-9]+:)?pl-(?<size>[\[\]0-9.]+)$');
  static final RegExp _paddingRightRegExp = RegExp(r'^(?:[a-zA-Z0-9]+:)?pr-(?<size>[\[\]0-9.]+)$');
  static final RegExp _paddingBottomRegExp = RegExp(r'^(?:[a-zA-Z0-9]+:)?pb-(?<size>[\[\]0-9.]+)$');
  static final RegExp _paddingTopRegExp = RegExp(r'^(?:[a-zA-Z0-9]+:)?pt-(?<size>[\[\]0-9.]+)$');
  static final RegExp _paddingHorizontalRegExp = RegExp(r'^(?:[a-zA-Z0-9]+:)?px-(?<size>[\[\]0-9.]+)$');
  static final RegExp _paddingVerticalRegExp = RegExp(r'^(?:[a-zA-Z0-9]+:)?py-(?<size>[\[\]0-9.]+)$');

  static Widget apply(BuildContext context, String className, Widget child) {
    final padding = applyGeometry(context, className);
    return padding == null ? child : Padding(padding: padding, child: child);
  }

  static EdgeInsetsGeometry? applyGeometry(BuildContext context, String className) {
    Map<String, double> paddingValues = {
      "left": 0.0,
      "right": 0.0,
      "top": 0.0,
      "bottom": 0.0
    };

    for (var name in className.split(' ')) {
      _parsePadding(context, name, paddingValues);
    }

    if (hasDebugClassName(className)) {
      print('PaddingParser - Padding: $paddingValues for className: $className');
    }

    return EdgeInsets.only(
      left: paddingValues["left"]!,
      right: paddingValues["right"]!,
      top: paddingValues["top"]!,
      bottom: paddingValues["bottom"]!,
    );
  }

  static void _parsePadding(BuildContext context, String name, Map<String, double> paddingValues) {
    final matchers = {
      _paddingRegExp: (size) {
        paddingValues["left"] = size;
        paddingValues["right"] = size;
        paddingValues["top"] = size;
        paddingValues["bottom"] = size;
      },
      _paddingLeftRegExp: (size) => paddingValues["left"] = size,
      _paddingRightRegExp: (size) => paddingValues["right"] = size,
      _paddingBottomRegExp: (size) => paddingValues["bottom"] = size,
      _paddingTopRegExp: (size) => paddingValues["top"] = size,
      _paddingHorizontalRegExp: (size) {
        paddingValues["left"] = size;
        paddingValues["right"] = size;
      },
      _paddingVerticalRegExp: (size) {
        paddingValues["top"] = size;
        paddingValues["bottom"] = size;
      },
    };

    for (var entry in matchers.entries) {
      final match = entry.key.firstMatch(name);
      if (match != null && ScreensParser.canApply(context, name)) {
        final matchedSize = match.namedGroup('size')!;

        double size = matchedSize.startsWith('[') && matchedSize.endsWith(']')
            ? double.parse(matchedSize.substring(1, matchedSize.length - 1))
            : double.parse(matchedSize) * WindTheme.getPixelFactor();

        entry.value(size);
      }
    }
  }
}
