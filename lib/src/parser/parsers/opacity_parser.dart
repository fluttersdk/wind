import '../wind_context.dart';
import '../wind_style.dart';
import 'wind_parser_interface.dart';

/// **Opacity Parser**
///
/// Handles `opacity-*` utility classes.
///
/// ### Supported Utility Classes:
/// - **Steps:** `opacity-0`, `opacity-50`, `opacity-100` (maps to 0.0, 0.5, 1.0)
/// - **Arbitrary:** `opacity-[0.35]`
///
/// Returns a [WindStyle] with `opacity` (double).
class OpacityParser implements WindParserInterface {
  const OpacityParser();

  /// Standard Tailwind opacity values (percentage to decimal)

  static final RegExp _arbitraryOpacityRegExp = RegExp(
    r'^opacity-\[(?<value>[0-9]*\.?[0-9]+)\]$',
  );

  @override
  bool canParse(String className) {
    return className.startsWith('opacity-');
  }

  @override
  WindStyle parse(WindStyle style, List<String>? classes, WindContext context) {
    if (classes == null) return style;

    double? opacity;

    for (var i = classes.length - 1; i >= 0; i--) {
      final className = classes[i];

      // Handle standard opacity values e.g., opacity-50
      final value = className.replaceFirst('opacity-', '');
      if (context.theme.opacities.containsKey(value)) {
        opacity ??= context.theme.opacities[value];
        continue;
      }

      // Handle arbitrary opacity values e.g., opacity-[0.35]
      final arbitraryMatch = _arbitraryOpacityRegExp.firstMatch(className);
      if (arbitraryMatch != null) {
        if (opacity == null) {
          final val = double.tryParse(arbitraryMatch.namedGroup('value')!);
          if (val != null) {
            opacity = val.clamp(0.0, 1.0);
          }
        }
        continue;
      }
    }

    return style.copyWith(opacity: opacity);
  }
}
