import '../wind_context.dart';
import '../wind_style.dart';
import 'wind_parser_interface.dart';

/// Parser for opacity utility classes
///
/// Example classes:
/// - opacity-0
/// - opacity-50
/// - opacity-100
/// - opacity-[0.35]
class OpacityParser implements WindParserInterface {
  const OpacityParser();

  /// Standard Tailwind opacity values (percentage to decimal)
  static const Map<String, double> _opacityValues = {
    '0': 0.0,
    '5': 0.05,
    '10': 0.10,
    '20': 0.20,
    '25': 0.25,
    '30': 0.30,
    '40': 0.40,
    '50': 0.50,
    '60': 0.60,
    '70': 0.70,
    '75': 0.75,
    '80': 0.80,
    '90': 0.90,
    '95': 0.95,
    '100': 1.0,
  };

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
      if (_opacityValues.containsKey(value)) {
        opacity ??= _opacityValues[value];
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
