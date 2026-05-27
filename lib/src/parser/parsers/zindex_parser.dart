import '../wind_context.dart';
import '../wind_style.dart';
import 'wind_parser_interface.dart';

/// **Z-Index Parser**
///
/// Controls the stack order of elements within a `Stack` widget.
///
/// ### Supported Utility Classes:
/// - **Presets:** `z-0`, `z-10`, `z-20`, `z-30`, `z-40`, `z-50`
/// - **Arbitrary:** `z-[{number}]`
/// - **Auto:** `z-auto` (resets to null)
///
/// Returns a [WindStyle] with a `zIndex` integer. Only effective inside `Stack` containers.
class ZIndexParser implements WindParserInterface {
  const ZIndexParser();

  static final RegExp _arbitraryZIndexRegExp = RegExp(
    r'^z-\[(?<value>-?[0-9]+)\]$',
  );

  // Only accept fully valid z-index utility classes to avoid confusing
  // behavior where canParse returns true but parsing produces no result.
  static final RegExp _canParseRegExp = RegExp(
    r'^z-(auto|\d+|\[-?[0-9]+\])$',
  );

  @override
  bool canParse(String className) {
    return _canParseRegExp.hasMatch(className);
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
      if (context.theme.zIndices.containsKey(value)) {
        zIndex ??= context.theme.zIndices[value];
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
