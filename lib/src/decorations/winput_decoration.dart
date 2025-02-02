import 'package:flutter/material.dart';

import '../helpers.dart';
import '../parsers/background_color_parser.dart';
import '../parsers/border_parser.dart';
import '../parsers/padding_parser.dart';

class WInputDecoration extends InputDecoration {
  const WInputDecoration({
    super.icon,
    super.iconColor,
    super.label,
    super.labelText,
    super.labelStyle,
    super.floatingLabelStyle,
    super.helper,
    super.helperText,
    super.helperStyle,
    super.helperMaxLines,
    super.hintText,
    super.hintStyle,
    super.hintTextDirection,
    super.hintMaxLines,
    super.hintFadeDuration,
    super.error,
    super.errorText,
    super.errorStyle,
    super.errorMaxLines,
    super.floatingLabelBehavior,
    super.floatingLabelAlignment,
    super.isCollapsed,
    super.isDense,
    super.contentPadding,
    super.prefixIcon,
    super.prefixIconConstraints,
    super.prefix,
    super.prefixText,
    super.prefixStyle,
    super.prefixIconColor,
    super.suffixIcon,
    super.suffix,
    super.suffixText,
    super.suffixStyle,
    super.suffixIconColor,
    super.suffixIconConstraints,
    super.counter,
    super.counterText,
    super.counterStyle,
    super.filled,
    super.fillColor,
    super.focusColor,
    super.hoverColor,
    super.errorBorder,
    super.focusedBorder,
    super.focusedErrorBorder,
    super.disabledBorder,
    super.enabledBorder,
    super.border,
    super.enabled = true,
    super.semanticCounterText,
    super.alignLabelWithHint,
    super.constraints,
  });

  InputDecoration className(BuildContext context, dynamic className) {
    final parsedClassName = classNameParser(className);
    final color = BackgroundColorParser.applyColor(context, parsedClassName);
    final InputBorder? inputBorder = BorderParser.applyInputBorder(context, parsedClassName);

    return super.copyWith(
      fillColor: color ?? super.fillColor,
      filled: color != null ? true : super.filled,
      contentPadding: PaddingParser.applyGeometry(context, parsedClassName),
      enabledBorder: BorderParser.applyInputBorder(context, classNameParser(className, states: ['enabled'])) ?? super.enabledBorder,
      focusedBorder: BorderParser.applyInputBorder(context, classNameParser(className, states: ['focused'])) ?? super.focusedBorder,
      errorBorder: BorderParser.applyInputBorder(context, classNameParser(className, states: ['error'])) ?? super.errorBorder,
      disabledBorder: BorderParser.applyInputBorder(context, classNameParser(className, states: ['disabled'])) ?? super.disabledBorder,
      border: inputBorder ?? super.border,
      hintStyle: wTextStyle(context, classNameParser(className, states: ['hint'])).merge(super.hintStyle),
      errorStyle: wTextStyle(context, classNameParser(className, states: ['error'])).merge(super.errorStyle),
      helperStyle: wTextStyle(context, classNameParser(className, states: ['helper'])).merge(super.helperStyle),
      labelStyle: wTextStyle(context, classNameParser(className, states: ['label'])).merge(super.labelStyle),
    );
  }
}