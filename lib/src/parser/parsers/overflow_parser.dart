import 'package:flutter/widgets.dart';
import '../wind_context.dart';
import '../wind_style.dart';
import 'wind_parser_interface.dart';

/// **Overflow Parser**
///
/// Handles content overflow behavior.
///
/// ### Supported Utility Classes:
/// - **General:** `overflow-hidden`, `overflow-visible`, `overflow-scroll`
/// - **Axis Specific:** `overflow-x-hidden`, `overflow-y-scroll`
///
/// Returns a [WindStyle] with `overflow`, `overflowX`, `overflowY`.
/// Also sets helper `clipBehavior` based on the overflow mode.
class OverflowParser implements WindParserInterface {
  const OverflowParser();

  @override
  bool canParse(String className) {
    // Only accept fully valid overflow utility classes to avoid
    // confusing behavior where canParse returns true but parsing
    // produces null because the value is unsupported.
    return RegExp(
          r'^overflow-(hidden|visible|scroll|auto)$',
        ).hasMatch(className) ||
        RegExp(
          r'^overflow-x-(hidden|visible|scroll|auto)$',
        ).hasMatch(className) ||
        RegExp(
          r'^overflow-y-(hidden|visible|scroll|auto)$',
        ).hasMatch(className);
  }

  @override
  WindStyle parse(WindStyle style, List<String>? classes, WindContext context) {
    if (classes == null) return style;

    WindOverflow? overflow;
    WindOverflow? overflowX;
    WindOverflow? overflowY;
    Clip? clipBehavior;

    for (var i = classes.length - 1; i >= 0; i--) {
      final className = classes[i];

      // Handle directional overflow-x-*
      if (className.startsWith('overflow-x-')) {
        if (overflowX == null) {
          final value = className.replaceFirst('overflow-x-', '');
          overflowX = _parseOverflowValue(value);
        }
        continue;
      }

      // Handle directional overflow-y-*
      if (className.startsWith('overflow-y-')) {
        if (overflowY == null) {
          final value = className.replaceFirst('overflow-y-', '');
          overflowY = _parseOverflowValue(value);
        }
        continue;
      }

      // Handle general overflow-*
      if (className.startsWith('overflow-')) {
        if (overflow == null) {
          final value = className.replaceFirst('overflow-', '');
          overflow = _parseOverflowValue(value);
        }
        continue;
      }
    }

    // Determine clipBehavior based on overflow settings
    if (overflow == WindOverflow.hidden ||
        overflowX == WindOverflow.hidden ||
        overflowY == WindOverflow.hidden) {
      clipBehavior = Clip.hardEdge;
    } else if (overflow == WindOverflow.visible ||
        overflowX == WindOverflow.visible ||
        overflowY == WindOverflow.visible) {
      clipBehavior = Clip.none;
    }

    return style.copyWith(
      overflow: overflow,
      overflowX: overflowX,
      overflowY: overflowY,
      clipBehavior: clipBehavior,
    );
  }

  WindOverflow? _parseOverflowValue(String value) {
    switch (value) {
      case 'hidden':
        return WindOverflow.hidden;
      case 'visible':
        return WindOverflow.visible;
      case 'scroll':
        return WindOverflow.scroll;
      case 'auto':
        return WindOverflow.auto;
      default:
        return null;
    }
  }
}
