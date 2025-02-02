import 'package:flutter/material.dart';
import '../components/wgap.dart';
import '../theme/wind_theme.dart';
import 'screens_parser.dart';

/// Parses the flex properties from a class name
/// Example: flex-row or flex-col
/// Example: justify-center or justify-start
/// Example: items-start or items-center
/// Example: axis-max or axis-min
/// Example: gap-4 or gap-[4]
class FlexParser {
  static final Map<String, Axis> directions = {
    'flex-row': Axis.horizontal,
    'flex-col': Axis.vertical,
  };

  static final Map<String, MainAxisAlignment> justifyContents = {
    'justify-center': MainAxisAlignment.center,
    'justify-start': MainAxisAlignment.start,
    'justify-end': MainAxisAlignment.end,
    'justify-between': MainAxisAlignment.spaceBetween,
    'justify-around': MainAxisAlignment.spaceAround,
    'justify-evenly': MainAxisAlignment.spaceEvenly,
  };

  static final Map<String, CrossAxisAlignment> alignItems = {
    'items-start': CrossAxisAlignment.start,
    'items-end': CrossAxisAlignment.end,
    'items-center': CrossAxisAlignment.center,
    'items-baseline': CrossAxisAlignment.baseline,
    'items-stretch': CrossAxisAlignment.stretch,
  };

  static final Map<String, MainAxisSize> axisSizes = {
    'axis-max': MainAxisSize.max,
    'axis-min': MainAxisSize.min,
  };

  static final RegExp regExp =
      RegExp(r'^(?:[a-zA-Z0-9]+:)?gap-(?<size>[a-zA-Z0-9]+)$');
  static final RegExp regExpDynamic =
      RegExp(r'^(?:[a-zA-Z0-9]+:)?gap-\[(?<size>[0-9]+)\]$');

  static const String overflowScroll = 'overflow-scroll';

  static const List<String> flexFitClasses = [
    'flex-grow',
    'flex-auto',
  ];

  static final RegExp flexRegExp =
      RegExp(r'^(?:[a-zA-Z0-9]+:)?flex-(?<size>[0-9]+)$');

  static Axis applyDirection(BuildContext context, String className) {
    return _applyProperty(context, className, directions, Axis.horizontal);
  }

  static MainAxisAlignment applyJustifyContent(
      BuildContext context, String className) {
    return _applyProperty(
        context, className, justifyContents, MainAxisAlignment.start);
  }

  static CrossAxisAlignment applyAlignItems(
      BuildContext context, String className) {
    return _applyProperty(
        context, className, alignItems, CrossAxisAlignment.center);
  }

  static MainAxisSize applyMainAxisSize(
      BuildContext context, String className) {
    return _applyProperty(context, className, axisSizes, MainAxisSize.max);
  }

  static double? applyGap(BuildContext context, String className) {
    for (var name in className.split(' ')) {
      final match = regExp.firstMatch(name);
      if (match != null && ScreensParser.canApply(context, name)) {
        return double.parse(match.namedGroup('size')!) *
            WindTheme.getPixelFactor();
      } else {
        final match = regExpDynamic.firstMatch(name);
        if (match != null && ScreensParser.canApply(context, name)) {
          String size = match.namedGroup('size')!;

          if (double.tryParse(size) != null) {
            return double.parse(size);
          }
        }
      }
    }
    return null;
  }

  static List<Widget> applyGapToChildren(
      BuildContext context, String className, List<Widget> children) {
    final gap = applyGap(context, className);
    if (gap == null) return children;

    final axis = applyDirection(context, className);
    final gapWidget = WGap(gap: gap, axis: axis);
    var newChildren = [
      for (int i = 0; i < children.length; i++) ...[
        if (i != 0) gapWidget,
        children[i],
      ]
    ];

    return newChildren;
  }

  static T _applyProperty<T>(BuildContext context, String className,
      Map<String, T> properties, T defaultValue) {
    for (var name in className.split(' ')) {
      if (ScreensParser.canApply(context, name) &&
          properties.containsKey(ScreensParser.without(name))) {
        return properties[name]!;
      }
    }
    return defaultValue;
  }

  static Widget applyOverflow(
      BuildContext context, String className, Widget child) {
    Widget newChild = child;

    for (var name in className.split(' ')) {
      if (ScreensParser.canApply(context, name) && name == ScreensParser.without(overflowScroll)) {
        newChild = SingleChildScrollView(
          child: newChild,
        );
      }
    }

    return newChild;
  }

  static Alignment applyAlignment(BuildContext context, String className) {
    MainAxisAlignment mainAxisAlignment =
        applyJustifyContent(context, className);
    CrossAxisAlignment crossAxisAlignment = applyAlignItems(context, className);

    return Alignment(
      mainAxisAlignment == MainAxisAlignment.start
          ? -1.0
          : mainAxisAlignment == MainAxisAlignment.end
              ? 1.0
              : 0.0,
      crossAxisAlignment == CrossAxisAlignment.start
          ? -1.0
          : crossAxisAlignment == CrossAxisAlignment.end
              ? 1.0
              : 0.0,
    );
  }

  static Widget applyFlexible(
      BuildContext context, String className, Widget child) {
    final flexFit = applyFlexFit(context, className);
    final flex = applyFlex(context, className);

    if (flexFit == null && flex == null) {
      return child;
    }

    return Flexible(
      flex: flex ?? 1,
      fit: flexFit ?? FlexFit.loose,
      child: child,
    );
  }

  static FlexFit? applyFlexFit(BuildContext context, String className) {
    for (var name in className.split(' ')) {
      if (ScreensParser.canApply(context, name) &&
          flexFitClasses.contains(ScreensParser.without(name))) {
        return ScreensParser.without(name) == 'flex-grow'
            ? FlexFit.tight
            : FlexFit.loose;
      }
    }
    return null;
  }

  static int? applyFlex(BuildContext context, String className) {
    for (var name in className.split(' ')) {
      final match = flexRegExp.firstMatch(name);
      if (match != null && ScreensParser.canApply(context, name)) {
        return int.parse(match.namedGroup('size')!);
      }
    }
    return null;
  }
}
