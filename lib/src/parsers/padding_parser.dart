import 'package:flutter/material.dart';
import '../theme/wind_theme.dart';

/// Parses padding classes and returns EdgeInsetsGeometry
/// Example: p-4, pl-2, pr-4, pb-4, pt-4, px-4, py-4
/// Example: p-[4], pl-[2], pr-[4], pb-[4], pt-[4], px-[4], py-[4]
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

  static Padding? applyPadding(BuildContext context, String className) {
    final padding = applyGeometry(context, className);
    return padding == null ? null : Padding(padding: padding);
  }

  static EdgeInsetsGeometry? applyGeometry(BuildContext context, String className) {
    EdgeInsetsGeometry? padding;

    for (var name in className.split(' ')) {
      padding = _parsePadding(context, name, padding);
    }

    return padding;
  }

  static EdgeInsetsGeometry? _parsePadding(BuildContext context, String name, EdgeInsetsGeometry? padding) {
    final matchers = {
      _paddingRegExp: (size) => EdgeInsets.all(size),
      _paddingLeftRegExp: (size) => EdgeInsets.only(left: size),
      _paddingRightRegExp: (size) => EdgeInsets.only(right: size),
      _paddingBottomRegExp: (size) => EdgeInsets.only(bottom: size),
      _paddingTopRegExp: (size) => EdgeInsets.only(top: size),
      _paddingHorizontalRegExp: (size) => EdgeInsets.symmetric(horizontal: size),
      _paddingVerticalRegExp: (size) => EdgeInsets.symmetric(vertical: size),
    };

    for (var entry in matchers.entries) {
      final match = entry.key.firstMatch(name);
      if (match != null) {
        final matchedSize = match.namedGroup('size')!;

        // if size value is wrapped in square brackets, it is a dynamic value
        if (matchedSize.startsWith('[') && matchedSize.endsWith(']')) {
          final size = double.parse(matchedSize.substring(1, matchedSize.length - 1));
          padding = padding == null ? entry.value(size) : padding.add(entry.value(size));
        } else {
          final size = double.parse(matchedSize) * WindTheme.getPixelFactor();
          padding = padding == null ? entry.value(size) : padding.add(entry.value(size));
        }
      }
    }

    return padding;
  }
}