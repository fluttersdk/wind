import '../wind_style.dart';
import '../wind_context.dart';

/// Interface for Wind CSS parsers
/// Each parser must implement the parse method
/// that takes the current ParsedStyle, list of classes,
/// and WindContext, and returns an updated ParsedStyle
/// for the given classes and context.
///
/// Example:
/// class MyParser implements WindParserInterface {
///   @override
///   ParsedStyle parse(
///     ParsedStyle styles,
///     List<String>? classes,
///     WindContext context,
///   ) {
///     // Parse classes and update styles
///     return styles;
///   }
///
///   @override
///   bool canParse(String className) {
///     // Return true if this parser can handle the given className
///     return className.startsWith('my-prefix-');
///   }
/// }
abstract class WindParserInterface {
  // Parses the given classes and updates the ParsedStyle
  WindStyle parse(
    WindStyle styles,
    List<String>? classes,
    WindContext context,
  );

  // Determines if this parser can handle the given class name
  bool canParse(String className);
}
