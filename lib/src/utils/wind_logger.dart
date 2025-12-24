import 'package:flutter/foundation.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// A simple data class for the [WindLogger].
class LogEntry {
  final String widgetName;
  final String properties;

  LogEntry(this.widgetName, this.properties);
}

/// A logger for debugging the widget composition tree
/// created by the Wind framework.
///
/// When `debug` is true, it captures the sequence of
/// wrapper widgets and their properties, and at the end of the
/// build process, it prints a pseudo-Dart code representation
/// of the entire widget tree along with the build time.
///
/// Example usage:
/// ```dart
/// final logger = WindLogger(debug: true, widgetName: runtimeType.toString());
/// logger.wrapWith("Padding", "padding: EdgeInsets.all(8.0)");
/// logger.setCoreWidget("Column(children: [...])");
/// logger.printFinalCode();
/// ```
class WindLogger {
  final bool _isDebug;
  final String _widgetName;
  final List<LogEntry> _log = [];
  String _coreWidget = "const SizedBox.shrink()";
  WindStyle? _finalStyles;

  /// Measures the build time from the start to `printFinalCode()`.
  final Stopwatch _stopwatch = Stopwatch();

  /// Initializes the logger with the `debug` flag and the
  /// name of the widget calling it (`runtimeType.toString()`).
  WindLogger({required bool debug, required String widgetName})
    : _isDebug = debug,
      _widgetName = widgetName {
    if (!_isDebug) return;
    debugPrint("--- [WIND DEBUG] START: $_widgetName ---");
    // Start the stopwatch as soon as the logger is created
    _stopwatch.start();
  }

  /// Sets the innermost core widget of the composition.
  void setCoreWidget(String core) {
    if (!_isDebug) return;
    _coreWidget = core;
  }

  /// Sets the final computed styles for reference.
  void setFinalStyles(WindStyle styles) {
    if (!_isDebug) return;
    _finalStyles = styles;
  }

  /// Adds a "wrapper" widget to the composition tree.
  /// (We add to the beginning of the list since we wrap from the inside-out)
  void wrapWith(String widgetName, String properties) {
    if (!_isDebug) return;
    _log.insert(0, LogEntry(widgetName, properties));
  }

  /// Called at the end of the `build` method.
  /// If `debug` is true, prints the final, pseudo-Dart code
  /// representation of the widget tree AND the build time.
  void printFinalCode() {
    if (!_isDebug) return;

    // Stop the stopwatch
    _stopwatch.stop();

    debugPrint("--- [WIND DEBUG] Composition Tree: ---");

    String output = "";
    int indent = 0;

    // 1. Print outer wrappers (Margin, Padding)
    for (final entry in _log) {
      final indentStr = "  " * indent;
      output += "$indentStr${entry.widgetName}(\n";
      output +=
          "$indentStr  ${entry.properties.replaceAll("\n", "\n$indentStr  ")},\n";
      output += "$indentStr  child: \n";
      indent++;
    }

    // 2. Print the core widget (Column, Row, child)
    final coreIndent = "  " * indent;
    output += "$coreIndent$_coreWidget,";

    // 3. Add closing parentheses
    while (indent > 0) {
      indent--;
      output += "\n${"  " * indent})";
    }

    debugPrint(output);

    if (_finalStyles != null) {
      debugPrint(
        "--- [WIND DEBUG] Final Styles: ${_finalStyles.toString()} ---",
      );
    }

    debugPrint(
      "--- [WIND DEBUG] Build Time: ${_stopwatch.elapsedMicroseconds}µs ---",
    );

    debugPrint("--- [WIND DEBUG] END: $_widgetName ---");
  }

  /// Logs instantaneous steps.
  void logStep(String step, String details) {
    if (!_isDebug) return;
    debugPrint("   $step: $details");
  }
}
