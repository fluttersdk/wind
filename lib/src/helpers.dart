import 'package:flutter/material.dart';

import 'painting/wtext_style.dart';
import 'theme/wind_theme.dart';

String classNameParser(dynamic className, {List<String> states = const []}) {
  String parsedClassName = toClassName(className);

  parsedClassName = classNameState(parsedClassName, states: states);

  // Remove class names with "$x:` syntax
  for (var name in parsedClassName.split(' ')) {
    var split = name.split(':');
    if (split.length > 1 &&
        !WindTheme.hasScreenOrModeOrOperatingSystem(split[0])) {
      parsedClassName = parsedClassName.replaceAll(name, '');
    }
  }

  if (hasDebugClassName(className)) {
    print(
        'Parsed class name: $parsedClassName with states: $states from: $className');
  }

  return parsedClassName.replaceAll(RegExp(r'\s{2,}'), ' ');
}

bool hasClassName(dynamic className, String name) {
  List<String> parsedClassNames = toClassName(className).split(' ');
  return parsedClassNames.contains(name);
}

bool hasDebugClassName(dynamic className) {
  return hasClassName(className, 'debug');
}

bool hasDebugWidgetClassName(dynamic className) {
  return hasClassName(className, 'log-widget');
}

String classNameState(String className, {List<String> states = const []}) {
  String parsedClassName = className;

  if (states.isNotEmpty) {
    for (var state in states) {
      parsedClassName = parsedClassName.replaceAll('$state:', '');
    }
  }

  return parsedClassName;
}

String toClassName(dynamic className) {
  if (className is String) {
    return className;
  }

  if (className is Map) {
    return className.entries
        .where((entry) => !!entry.value)
        .map((entry) => entry.key)
        .join(' ');
  }

  if (className is List) {
    return className.join(' ');
  }

  return '';
}

TextStyle wTextStyle(BuildContext context, dynamic className,
    {TextStyle? textStyle}) {
  return const WTextStyle().className(context, className).merge(textStyle);
}

Color wColor(String name,
    {int shade = 500, String? darkName = null, int? darkShade = null}) {
  if (WindTheme.getType() == Brightness.dark) {
    name = darkName ?? name;
    shade = darkShade ?? shade;
  }

  final match = RegExp(r'^(?<color>[^-]+)-(?<shade>[0-9]+)').firstMatch(name);
  if (match != null) {
    name = match.namedGroup('color')!;
    shade = int.parse(match.namedGroup('shade')!);
  }

  return WindTheme.getColor(name, shade: shade);
}

bool wScreen(BuildContext context, String screen) {
  final Size deviceSize = MediaQuery.of(context).size;
  final int screenSize = WindTheme.getScreenValue(screen);

  return deviceSize.width >= screenSize;
}

bool wScreenOnly(BuildContext context, String screen) {
  final Size deviceSize = MediaQuery.of(context).size;
  final int screenSize = screen == 'sm' ? 0 : WindTheme.getScreenValue(screen);
  final int nextScreenSize = WindTheme.getScreenValue(screen, next: true);

  return deviceSize.width >= screenSize && deviceSize.width < nextScreenSize;
}

bool wAnyScreenOnly(BuildContext context, List<String> screens) {
  for (var screen in screens) {
    if (wScreenOnly(context, screen)) {
      return true;
    }
  }

  return false;
}
