import '../wind_context.dart';
import '../wind_style.dart';
import 'wind_parser_interface.dart';

/// Parser for display related classes
///
/// Example classes:
/// - hidden
/// - block
/// - flex
/// - grid
class DisplayParser implements WindParserInterface {
  const DisplayParser();

  /// Parses display related classes and returns updated WindStyle
  ///
  /// Example:
  /// ```dart
  /// final parser = DisplayParser();
  /// final classes = ['hidden', 'block', 'flex', 'grid'];
  /// final style = parser.parse(WindStyle(), classes, context);
  /// ```
  @override
  WindStyle parse(
    WindStyle styles,
    List<String>? classes,
    WindContext context,
  ) {
    if (classes == null) return styles;

    bool? isHidden = null;
    WindDisplayType? type = null;

    for (var i = classes.length - 1; i >= 0; i--) {
      final className = classes[i];

      if (isHidden == null) {
        if (className == 'hidden') {
          isHidden = true;
        } else if (className == 'block' ||
            className == 'flex' ||
            className == 'grid') {
          isHidden = false;
        }
      }

      if (type == null) {
        if (className == 'block') {
          type = WindDisplayType.block;
        } else if (className == 'flex') {
          type = WindDisplayType.flex;
        } else if (className == 'grid') {
          type = WindDisplayType.grid;
        }
      }

      if (isHidden != null && type != null) {
        break;
      }
    }

    return styles.copyWith(
      isHidden: isHidden,
      displayType: type,
    );
  }

  /// Checks if the parser can parse the given class name
  ///
  /// Example: hidden, block, flex, grid
  @override
  bool canParse(String className) {
    return className == 'hidden' ||
        className == 'block' ||
        className == 'flex' ||
        className == 'grid';
  }
}
