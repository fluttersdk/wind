import '../wind_context.dart';
import '../wind_style.dart';
import 'wind_parser_interface.dart';

/// Parser for aspect ratio utility classes
///
/// Example classes:
/// - aspect-auto
/// - aspect-square (1:1)
/// - aspect-video (16:9)
/// - aspect-[4/3]
/// - aspect-[16/9]
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
        if (value == 'auto') {
          aspectRatio = null;
          break;
        }
        aspectRatio ??= _aspectRatioValues[value];
        continue;
      }

      // Handle arbitrary aspect ratios e.g., aspect-[4/3]
      final arbitraryMatch = _arbitraryAspectRatioRegExp.firstMatch(className);
      if (arbitraryMatch != null) {
        if (aspectRatio == null) {
          final width = double.tryParse(arbitraryMatch.namedGroup('width')!);
          final height = double.tryParse(arbitraryMatch.namedGroup('height')!);
          if (width != null && height != null && height > 0) {
            aspectRatio = width / height;
          }
        }
        continue;
      }
    }

    return style.copyWith(aspectRatio: aspectRatio);
  }
}
