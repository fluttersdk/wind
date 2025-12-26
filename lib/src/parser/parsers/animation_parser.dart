import '../wind_context.dart';
import '../wind_style.dart';
import 'wind_parser_interface.dart';

/// **Animation Parser**
///
/// Handles indeterminate animations.
///
/// ### Supported Utility Classes:
/// - `animate-spin`: Rotates 360 degrees (loading).
/// - `animate-pulse`: Fades opacity (skeletons).
/// - `animate-bounce`: Bounces vertically (alerts).
/// - `animate-ping`: Scales and fades (notifications).
/// - `animate-none`: Disables animation.
///
/// Returns a [WindStyle] with `animationType`.
class AnimationParser implements WindParserInterface {
  const AnimationParser();

  @override
  bool canParse(String className) {
    return className.startsWith('animate-');
  }

  @override
  WindStyle parse(
    WindStyle styles,
    List<String>? classes,
    WindContext context,
  ) {
    if (classes == null || classes.isEmpty) return styles;

    WindAnimationType? animationType;

    // Reverse iteration for "last class wins"
    for (var i = classes.length - 1; i >= 0; i--) {
      final className = classes[i];

      if (animationType == null &&
          context.theme.animations.containsKey(className)) {
        animationType = context.theme.animations[className];
        break;
      }
    }

    if (animationType == null) return styles;

    return styles.copyWith(animationType: animationType);
  }
}
