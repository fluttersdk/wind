import 'package:flutter/material.dart';
import '../helpers.dart';
import '../theme/wind_theme.dart';
import 'screens_parser.dart';

enum SizeType { width, height }

/// Parses the size from a class name
/// Example: w-10, h-20, max-w-30, max-h-40, min-w-50, min-h-60
/// Example: w-[10], h-[20], max-w-[30], max-h-[40], min-w-[50], min-h-[60]
class SizeParser {
  static final RegExp widthRegExp =
      RegExp(r'^(?:[a-zA-Z0-9]+:)?w-(?<size>[\[\]a-zA-Z0-9/]+)$');
  static final RegExp maxWidthRegExp =
      RegExp(r'^(?:[a-zA-Z0-9]+:)?max-w-(?<size>[\[\]a-zA-Z0-9/]+)$');
  static final RegExp minWidthRegExp =
      RegExp(r'^(?:[a-zA-Z0-9]+:)?min-w-(?<size>[\[\]a-zA-Z0-9/]+)$');
  static final RegExp heightRegExp =
      RegExp(r'^(?:[a-zA-Z0-9]+:)?h-(?<size>[\[\]a-zA-Z0-9/]+)$');
  static final RegExp maxHeightRegExp =
      RegExp(r'^(?:[a-zA-Z0-9]+:)?max-h-(?<size>[\[\]a-zA-Z0-9/]+)$');
  static final RegExp minHeightRegExp =
      RegExp(r'^(?:[a-zA-Z0-9]+:)?min-h-(?<size>[\[\]a-zA-Z0-9/]+)$');
  static final RegExp vwRegExp = RegExp(r'^(?<value>[0-9]+)vw$');
  static final RegExp vhRegExp = RegExp(r'^(?<value>[0-9]+)vh$');
  static final RegExp percentRegExp = RegExp(r'^(?<x>[0-9]+)/(?<y>[0-9]+)$');

  static bool hasAnyValid(String className) {
    return className.split(' ').any(isValid);
  }

  static bool isValid(String className) {
    return widthRegExp.hasMatch(className) || heightRegExp.hasMatch(className);
  }

  static double? applyWidth(BuildContext context, String className) {
    return _applySize(context, className, widthRegExp, SizeType.width);
  }

  static double? applyHeight(BuildContext context, String className) {
    return _applySize(context, className, heightRegExp, SizeType.height);
  }

  static double? applyMaxWidth(BuildContext context, String className) {
    return _applySize(context, className, maxWidthRegExp, SizeType.width);
  }

  static double? applyMaxHeight(BuildContext context, String className) {
    return _applySize(context, className, maxHeightRegExp, SizeType.height);
  }

  static double? applyMinWidth(BuildContext context, String className) {
    return _applySize(context, className, minWidthRegExp, SizeType.width);
  }

  static double? applyMinHeight(BuildContext context, String className) {
    return _applySize(context, className, minHeightRegExp, SizeType.height);
  }

  static BoxConstraints applyBoxConstraints(
      BuildContext context, String className) {
    final width = applyWidth(context, className);
    final height = applyHeight(context, className);
    final maxWidth = applyMaxWidth(context, className) ?? width;
    final maxHeight = applyMaxHeight(context, className) ?? height;
    final minWidth = applyMinWidth(context, className) ?? width;
    final minHeight = applyMinHeight(context, className) ?? height;

    if (hasDebugClassName(className)) {
      print(
          'BoxConstraints: width: $width, height: $height, maxWidth: $maxWidth, maxHeight: $maxHeight, minWidth: $minWidth, minHeight: $minHeight');
    }

    return BoxConstraints(
      minWidth: minWidth ?? 0.0,
      minHeight: minHeight ?? 0.0,
      maxWidth: maxWidth ?? double.infinity,
      maxHeight: maxHeight ?? double.infinity,
    );
  }

  static double calculateHeight(BuildContext context, String className,
      {double defaultHeight = 16.0}) {
    final height = applyHeight(context, className);
    final maxHeight = applyMaxHeight(context, className) ?? height;
    final minHeight = applyMinHeight(context, className) ?? height;

    if (hasDebugClassName(className)) {
      print(
          'calculateHeight: height: $height, maxHeight: $maxHeight, minHeight: $minHeight');
    }

    if (height != null) {
      return height;
    }

    if (maxHeight != null) {
      return maxHeight;
    }

    if (minHeight != null) {
      return minHeight;
    }

    return defaultHeight;
  }

  static double calculateWidth(BuildContext context, String className,
      {double defaultWidth = 16.0}) {
    final width = applyWidth(context, className);
    final maxWidth = applyMaxWidth(context, className) ?? width;
    final minWidth = applyMinWidth(context, className) ?? width;

    if (hasDebugClassName(className)) {
      print(
          'calculateWidth: width: $width, maxWidth: $maxWidth, minWidth: $minWidth');
    }

    if (width != null) {
      return width;
    }

    if (maxWidth != null) {
      return maxWidth;
    }

    if (minWidth != null) {
      return minWidth;
    }

    return defaultWidth;
  }

  static double? _applySize(
      BuildContext context, String className, RegExp regExp, SizeType type) {
    List<String> matchedClasses = [];
    for (var name in className.split(' ')) {
      final match = regExp.firstMatch(name);
      if (match != null) {
        matchedClasses.add(name);
      }
    }

    if (matchedClasses.length > 1) {
      String lastClassName = matchedClasses.first;
      for (var name in matchedClasses) {
        if (ScreensParser.canApply(context, name)) {
          lastClassName = name;
        }
      }

      if (hasDebugClassName(className)) {
        print('SizeParser: lastClassName: $lastClassName');
      }

      return calculate(
          context, regExp.firstMatch(lastClassName)!.namedGroup('size')!,
          type: type);
    }

    for (var name in className.split(' ')) {
      final match = regExp.firstMatch(name);
      if (match != null && ScreensParser.canApply(context, name)) {
        if (hasDebugClassName(className)) {
          print('SizeParser: className: $name');
        }

        return calculate(context, match.namedGroup('size')!, type: type);
      }
    }
    return null;
  }

  static double calculate(BuildContext context, String size,
      {SizeType type = SizeType.width}) {
    if (size == 'max' || size == 'full') {
      return double.infinity;
    }

    if (size == 'min') {
      return 0.0;
    }

    if (size == 'screen') {
      return type == SizeType.height
          ? MediaQuery.of(context).size.height
          : MediaQuery.of(context).size.width;
    }

    if (WindTheme.hasScreen(size)) {
      return WindTheme.getScreenValue(size).toDouble();
    }

    final vwMatch = vwRegExp.firstMatch(size);
    if (vwMatch != null) {
      return MediaQuery.of(context).size.width *
          double.parse(vwMatch.namedGroup('value')!) /
          100;
    }

    final vhMatch = vhRegExp.firstMatch(size);
    if (vhMatch != null) {
      return MediaQuery.of(context).size.height *
          double.parse(vhMatch.namedGroup('value')!) /
          100;
    }

    final percentMatch = percentRegExp.firstMatch(size);
    if (percentMatch != null) {
      return double.parse(percentMatch.namedGroup('x')!) /
          double.parse(percentMatch.namedGroup('y')!) *
          (type == SizeType.height
              ? MediaQuery.of(context).size.height
              : MediaQuery.of(context).size.width);
    }

    if (size.startsWith('[') && size.endsWith(']')) {
      final value = double.tryParse(size.substring(1, size.length - 1));
      return value != null ? value : 0.0;
    }

    final value = double.tryParse(size);
    return value != null ? value * WindTheme.getPixelFactor() : 0.0;
  }
}
