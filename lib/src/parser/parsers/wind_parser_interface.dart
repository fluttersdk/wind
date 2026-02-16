import '../wind_style.dart';
import '../wind_context.dart';

/// Interface for specialized Wind CSS parsers.
///
/// In the Wind pipeline, a parser is a modular component responsible for translating
/// a specific subset of utility classes (e.g., `bg-`, `text-`, `p-`) into
/// properties within a [WindStyle] object.
///
/// ### The Parsing Contract
/// Parsers must be **deterministic** and **highly performant**. Implementation
/// should favor O(n) or O(1) lookups as they are invoked during the widget
/// building process.
///
/// *   [canParse]: Identifies if a utility class belongs to this parser's domain.
/// *   [parse]: Processes applicable classes and merges them into the style tree.
///
/// ### "Last Class Wins" Expectation
/// Following Tailwind CSS conventions, if multiple classes modify the same property
/// (e.g., `bg-red-500 bg-blue-500`), the last one in the class list must prevail.
/// Parsers should ideally iterate through the [classes] list in **reverse** order
/// and stop processing a property once it has been resolved.
///
/// ### Theme & Context Integration
/// Parsers use the provided [WindContext] to access theme scales (colors, spacing, etc.).
/// Note that responsive (`md:`), state (`hover:`), and platform prefixes are resolved
/// by the orchestrator ([WindParser]) before the classes are passed to this interface.
///
/// ### Adding a New Parser
/// 1. Create a new parser class implementing [WindParserInterface].
/// 2. Implement [canParse] to match relevant utility prefixes.
/// 3. Implement [parse] to return an updated [WindStyle] using `styles.copyWith()`.
/// 4. Register the parser instance in `WindParser._parserMap` within `lib/src/parser/wind_parser.dart`.
abstract class WindParserInterface {
  /// Transforms a list of applicable utility [classes] into updates for [styles].
  ///
  /// *   [styles]: The current immutable style object to be updated.
  /// *   [classes]: A list of utility classes (already stripped of prefixes)
  ///     that this parser has claimed via [canParse].
  /// *   [context]: The runtime context containing theme data and device metrics.
  ///
  /// Returns a new [WindStyle] instance containing the merged results.
  WindStyle parse(WindStyle styles, List<String>? classes, WindContext context);

  /// Determines if this parser can handle the provided [className].
  ///
  /// This check should be as fast as possible, typically using `startsWith()`
  /// on the utility prefix or matching against a known set of utility names.
  bool canParse(String className);
}
