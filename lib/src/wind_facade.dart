import 'package:flutter/foundation.dart';
import 'package:wind_diagnostics_contracts/wind_diagnostics_contracts.dart';

import 'debug_resolver.dart';

/// Wind framework-level facade for debug-tooling integration.
///
/// Consumer host integration in lib/main.dart:
/// ```dart
/// if (kDebugMode) {
///   Wind.installDebugResolver();
/// }
/// ```
class Wind {
  Wind._();

  static bool _installed = false;

  /// Installs the Wind diagnostics resolver into the global
  /// wind_diagnostics_contracts registry. Idempotent. No-op in
  /// release builds (kDebugMode gate).
  static void installDebugResolver() {
    if (!kDebugMode || _installed) return;
    _installed = true;
    WindDebugRegistry.register(const WindDebugResolverImpl());
  }

  /// Test-only reset. Drops the installed flag; call
  /// `WindDebugRegistry.resetForTesting()` separately from the test file
  /// to also clear the registry (the registry method is @visibleForTesting
  /// and may only be called from test/ context).
  @visibleForTesting
  static void resetForTesting() {
    _installed = false;
  }
}
