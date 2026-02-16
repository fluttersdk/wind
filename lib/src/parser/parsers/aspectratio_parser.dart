import '../wind_context.dart';
import '../wind_style.dart';
import 'wind_parser_interface.dart';

/// **Aspect Ratio Parser**
///
/// Handles `aspect-*` utility classes to control the aspect ratio of an element.
///
/// ### Supported Utility Classes:
/// - **Presets:**
///   - `aspect-auto`: No aspect ratio constraint.
///   - `aspect-square`: 1/1 aspect ratio.
///   - `aspect-video`: 16/9 aspect ratio.
/// - **Arbitrary Values:**
///   - `aspect-[{width}/{height}]`: Define custom ratios (e.g., `aspect-[4/3]`, `aspect-[21/9]`).
///
/// ### Prefixes:
/// Prefixes like `md:`, `hover:`, `dark:`, and `ios:` are resolved by [WindParser]
/// before classes reach this parser.
///
/// Returns a [WindStyle] with the `aspectRatio` property set.
class AspectRatioParser implements WindParserInterface {
  const AspectRatioParser();

  /// Standard Tailwind aspect ratio values
  static const Map<String, double?> _aspectRatioValues = {
    'auto': null, // No aspect ratio constraint
    'square': 1.0, // 1:1
    'video': 16 / 9, // 16:9
  };

  static final RegExp _arbitraryAspectRatioRegExp = RegExp(
    r'^aspect-\[(?<width>\d+)/(?<height>\d+)\]$',
  );

  @override
  bool canParse(String className) {
    if (!className.startsWith('aspect-')) return false;

    final value = className.replaceFirst('aspect-', '');
    if (_aspectRatioValues.containsKey(value)) return true;
    if (_arbitraryAspectRatioRegExp.hasMatch(className)) return true;

    return false;
  }

  @override
  WindStyle parse(WindStyle style, List<String>? classes, WindContext context) {
    if (classes == null) return style;

    double? aspectRatio;

    for (var i = classes.length - 1; i >= 0; i--) {
      final className = classes[i];

      // Handle standard aspect ratio values
      final value = className.replaceFirst('aspect-', '');
      if (_aspectRatioValues.containsKey(value)) {
        aspectRatio = _aspectRatioValues[value];
        break;
      }

      // Handle arbitrary aspect ratios e.g., aspect-[4/3]
      final arbitraryMatch = _arbitraryAspectRatioRegExp.firstMatch(className);
      if (arbitraryMatch != null) {
        final width = double.tryParse(arbitraryMatch.namedGroup('width')!);
        final height = double.tryParse(arbitraryMatch.namedGroup('height')!);
        if (width != null && height != null && height > 0) {
          aspectRatio = width / height;
          break;
        }
      }
    }

    return style.copyWith(aspectRatio: aspectRatio);
  }
}
