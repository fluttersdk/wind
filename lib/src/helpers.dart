import 'package:flutter/material.dart';

import 'decorations/winput_decoration.dart';
import 'painting/wtext_style.dart';
import 'theme/wind_theme.dart';

String classNameParser(dynamic className, { List<String> states = const [] }) {
  String parsedClassName = toClassName(className);

  parsedClassName = classNameState(parsedClassName, states: states);

  // Remove class names with "$x:` syntax
  for (var name in parsedClassName.split(' ')) {
    var split = name.split(':');
    if (split.length > 1 && !WindTheme.hasScreen(split[0])) {
      parsedClassName = parsedClassName.replaceAll(name, '');
    }
  }

  return parsedClassName;
}

String classNameState(String className, { List<String> states = const [] }) {
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

InputDecoration wInputDecoration(BuildContext context, dynamic className) {
  return const WInputDecoration().className(context, className);
}

Color wColor(String name, {int shade = 500}) {
  final match = RegExp(r'^(?<color>[^-]+)-(?<shade>[0-9]+)').firstMatch(name);
  if (match != null) {
    name = match.namedGroup('color')!;
    shade = int.parse(match.namedGroup('shade')!);
  }

  return WindTheme.getColor(name, shade: shade);
}
