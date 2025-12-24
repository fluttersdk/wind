import '../wind_style.dart';
import '../wind_context.dart';
import 'wind_parser_interface.dart';

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
