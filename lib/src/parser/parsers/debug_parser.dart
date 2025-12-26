import '../wind_style.dart';
import '../wind_context.dart';
import 'wind_parser_interface.dart';

/// **Debug Parser**
///
/// Handles the `debug` utility class.
///
/// ### Supported Utility Classes:
/// - `debug`: Draws a colorful border around the widget for layout inspection.
///
/// Returns a [WindStyle] with `debug: true`.
class DebugParser implements WindParserInterface {
  const DebugParser();

  @override
  bool canParse(String className) {
    return className == 'debug';
  }

  @override
  WindStyle parse(WindStyle style, List<String>? classes, WindContext context) {
    return style.copyWith(debug: true);
  }
}
