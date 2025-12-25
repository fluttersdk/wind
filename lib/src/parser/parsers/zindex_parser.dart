import '../wind_context.dart';
import '../wind_style.dart';
import 'wind_parser_interface.dart';

/// Parser for z-index utility classes
///
/// Example classes:
/// - z-0
/// - z-10
/// - z-20
/// - z-30
/// - z-40
/// - z-50
/// - z-auto
/// - z-[100]
///
/// Note: Flutter doesn't have CSS-like positioning (absolute, relative, fixed).
/// Z-index only works within Stack widgets where children are ordered by index.
class ZIndexParser implements WindParserInterface {
  const ZIndexParser();

  /// Standard Tailwind z-index values
  static const Map<String, int> _zIndexValues = {
    '0': 0,
    '10': 10,
    '20': 20,
    '30': 30,
    '40': 40,
    '50': 50,
  };

  static final RegExp _arbitraryZIndexRegExp = RegExp(
    r'^z-\[(?<value>-?[0-9]+)\]$',
  );

  @override
  bool canParse(String className) {
    return className.startsWith('z-');
  }

  @override
  WindStyle parse(WindStyle style, List<String>? classes, WindContext context) {
    if (classes == null) return style;

    int? zIndex;

    for (var i = classes.length - 1; i >= 0; i--) {
      final className = classes[i];

      // Handle z-auto (null/unset) - explicitly reset and stop
      if (className == 'z-auto') {
        zIndex = null;
        break;
      }

      // Handle standard z-index values e.g., z-10
      final value = className.replaceFirst('z-', '');
      if (_zIndexValues.containsKey(value)) {
        zIndex ??= _zIndexValues[value];
        continue;
      }

      // Handle arbitrary z-index values e.g., z-[100]
      final arbitraryMatch = _arbitraryZIndexRegExp.firstMatch(className);
      if (arbitraryMatch != null) {
        if (zIndex == null) {
          final val = int.tryParse(arbitraryMatch.namedGroup('value')!);
          if (val != null) {
            zIndex = val;
          }
        }
        continue;
      }
    }

    return style.copyWith(zIndex: zIndex);
  }
}
