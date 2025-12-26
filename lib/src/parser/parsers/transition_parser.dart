import 'package:flutter/animation.dart';

import '../wind_context.dart';
import '../wind_style.dart';
import 'wind_parser_interface.dart';

/// **Transition Parser**
///
/// Handles animation duration and easing curves.
///
/// ### Supported Utility Classes:
/// - **Duration:** `duration-300`, `duration-700`, `duration-[500ms]`
/// - **Easing:** `ease-in`, `ease-out`, `ease-linear`, `ease-in-out`
///
/// Returns a [WindStyle] with `transitionDuration` and `transitionCurve`.
class TransitionParser implements WindParserInterface {
  const TransitionParser();

  /// Regex for duration classes: duration-300, duration-[500ms]
  static final RegExp _durationRegex = RegExp(
    r'^duration-(?:(?<preset>75|100|150|200|300|500|700|1000)|\[(?<arbitrary>\d+)(?:ms)?\])$',
  );

  /// Regex for ease/curve classes: ease-in, ease-out, ease-in-out, ease-linear
  static final RegExp _easeRegex = RegExp(
    r'^ease-(?<curve>linear|in|out|in-out)$',
  );

  @override
  bool canParse(String className) {
    return className.startsWith('duration-') || className.startsWith('ease-');
  }

  @override
  WindStyle parse(
    WindStyle styles,
    List<String>? classes,
    WindContext context,
  ) {
    if (classes == null) return styles;

    Duration? duration;
    Curve? curve;

    // Reverse iteration for "last class wins"
    for (var i = classes.length - 1; i >= 0; i--) {
      final className = classes[i];

      // Parse duration
      if (duration == null) {
        final durationMatch = _durationRegex.firstMatch(className);
        if (durationMatch != null) {
          if (durationMatch.namedGroup('preset') != null) {
            final preset = durationMatch.namedGroup('preset')!;
            if (context.theme.transitionDurations.containsKey(preset)) {
              duration = context.theme.transitionDurations[preset];
            }
          } else if (durationMatch.namedGroup('arbitrary') != null) {
            final ms = int.tryParse(durationMatch.namedGroup('arbitrary')!);
            if (ms != null) {
              duration = Duration(milliseconds: ms);
            }
          }
        }
      }

      // Parse curve
      if (curve == null) {
        final easeMatch = _easeRegex.firstMatch(className);
        if (easeMatch != null) {
          final curveName = easeMatch.namedGroup('curve')!;
          if (context.theme.transitionCurves.containsKey(curveName)) {
            curve = context.theme.transitionCurves[curveName];
          }
        }
      }
    }

    if (duration == null && curve == null) {
      return styles;
    }

    return styles.copyWith(
      transitionDuration: duration,
      transitionCurve: curve,
    );
  }
}
