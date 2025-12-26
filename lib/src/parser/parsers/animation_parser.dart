import '../wind_context.dart';
import '../wind_style.dart';
import 'wind_parser_interface.dart';

/// Parser for animation classes.
///
/// Supports Tailwind-style animation classes:
/// - `animate-spin` - Continuous rotation (loading spinner)
/// - `animate-ping` - Scale and fade out (notification badge)
/// - `animate-pulse` - Opacity pulse (skeleton loader)
/// - `animate-bounce` - Vertical bounce (scroll indicator)
/// - `animate-none` - Remove animation
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
