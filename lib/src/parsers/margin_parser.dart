import 'package:flutter/material.dart';

import '../helpers.dart';
import '../theme/wind_theme.dart';
import 'screens_parser.dart';

/// Parses margin classes and returns EdgeInsetsGeometry
/// Example: m-4, ml-2, mr-4, mb-4, mt-4, mx-4, my-4
/// Example: m-[4], ml-[2], mr-[4], mb-[4], mt-[4], mx-[4], my-[4]
class MarginParser {
  static final RegExp _marginRegExp = RegExp(r'^(?:[a-zA-Z0-9]+:)?m-(?<size>[\[\]0-9.]+)$');
  static final RegExp _marginLeftRegExp = RegExp(r'^(?:[a-zA-Z0-9]+:)?ml-(?<size>[\[\]0-9.]+)$');
  static final RegExp _marginRightRegExp = RegExp(r'^(?:[a-zA-Z0-9]+:)?mr-(?<size>[\[\]0-9.]+)$');
  static final RegExp _marginBottomRegExp = RegExp(r'^(?:[a-zA-Z0-9]+:)?mb-(?<size>[\[\]0-9.]+)$');
  static final RegExp _marginTopRegExp = RegExp(r'^(?:[a-zA-Z0-9]+:)?mt-(?<size>[\[\]0-9.]+)$');
  static final RegExp _marginHorizontalRegExp = RegExp(r'^(?:[a-zA-Z0-9]+:)?mx-(?<size>[\[\]0-9.]+)$');
  static final RegExp _marginVerticalRegExp = RegExp(r'^(?:[a-zA-Z0-9]+:)?my-(?<size>[\[\]0-9.]+)$');

  static EdgeInsetsGeometry? applyGeometry(BuildContext context, String className) {
    EdgeInsetsGeometry? margin;

    for (var name in className.split(' ')) {
      margin = _parseMargin(context, name, margin);
    }

    if (hasDebugClassName(className)) {
      print('MarginParser - Margin: $margin for className: $className');
    }

    return margin;
  }

  static EdgeInsetsGeometry? _parseMargin(BuildContext context, String name, EdgeInsetsGeometry? margin) {
    final matchers = {
      _marginRegExp: (size) => EdgeInsets.all(size),
      _marginLeftRegExp: (size) => EdgeInsets.only(left: size),
      _marginRightRegExp: (size) => EdgeInsets.only(right: size),
      _marginBottomRegExp: (size) => EdgeInsets.only(bottom: size),
      _marginTopRegExp: (size) => EdgeInsets.only(top: size),
      _marginHorizontalRegExp: (size) => EdgeInsets.symmetric(horizontal: size),
      _marginVerticalRegExp: (size) => EdgeInsets.symmetric(vertical: size),
    };

    for (var entry in matchers.entries) {
      final match = entry.key.firstMatch(name);
      if (match != null && ScreensParser.canApply(context, name)) {
        final matchedSize = match.namedGroup('size')!;

        // if size value is wrapped in square brackets, it is a dynamic value
        if (matchedSize.startsWith('[') && matchedSize.endsWith(']')) {
          final size = double.parse(matchedSize.substring(1, matchedSize.length - 1));
          margin = margin == null ? entry.value(size) : margin.add(entry.value(size));
        } else {
          final size = double.parse(matchedSize) * WindTheme.getPixelFactor();
          margin = margin == null ? entry.value(size) : margin.add(entry.value(size));
        }
      }
    }

    return margin;
  }
}