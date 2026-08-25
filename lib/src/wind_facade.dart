import 'package:flutter/foundation.dart';
import 'package:fluttersdk_wind_diagnostics_contracts/fluttersdk_wind_diagnostics_contracts.dart';

import 'debug_resolver.dart';
import 'parser/wind_parser.dart';
import 'utils/wind_perf_counters.dart';

/// Publishes Wind's aggregate performance counters through the
/// fluttersdk_wind_diagnostics_contracts perf slot.
///
/// The returned key set is the cross-repo contract `fluttersdk_dusk` reads;
/// it is pinned in [WindPerfResolver] and must not be renamed here. Counting
/// itself stays off until [WindPerfCounters.enabled] is set, so installing
/// this resolver costs nothing on its own; `cacheSize` is the exception and is
/// always live, since it measures the cache rather than the session.
class WindPerfResolverImpl implements WindPerfResolver {
  const WindPerfResolverImpl();

  @override
  Map<String, Object?> stats() => <String, Object?>{
        'cacheHits': WindPerfCounters.cacheHits,
        'cacheMisses': WindPerfCounters.cacheMisses,
        'cacheBypasses': WindPerfCounters.cacheBypasses,
        'cacheSize': WindParser.cacheSize,
        'wDivBuilds': WindPerfCounters.wDivBuilds,
        'wTextBuilds': WindPerfCounters.wTextBuilds,
      };
}

/// Wind framework-level facade for debug-tooling integration.
///
/// Consumer host integration in lib/main.dart:
/// ```dart
/// if (kDebugMode) {
///   Wind.installDebugResolver();
///   Wind.installPerfResolver();
/// }
/// ```
class Wind {
  Wind._();

  static bool _installed = false;
  static bool _perfInstalled = false;

  /// Installs the Wind diagnostics resolver into the global
  /// fluttersdk_wind_diagnostics_contracts registry. Idempotent. No-op in
  /// release builds (kDebugMode gate).
  static void installDebugResolver() {
    if (!kDebugMode || _installed) return;
    _installed = true;
    WindDebugRegistry.register(const WindDebugResolverImpl());
  }

  /// Installs the Wind performance resolver into the perf slot of the same
  /// registry. Idempotent. No-op in release builds (kDebugMode gate).
  ///
  /// Separate from [installDebugResolver] because the two answer different
  /// questions and a host may want one without the other: the debug resolver
  /// resolves per-Element widget state at snapshot time, this one publishes
  /// process-wide counters. Installing it costs nothing on its own, since
  /// counting stays off until [WindPerfCounters.enabled] is set.
  static void installPerfResolver() {
    if (!kDebugMode || _perfInstalled) return;
    _perfInstalled = true;
    WindDebugRegistry.registerPerf(const WindPerfResolverImpl());
  }

  /// Test-only reset. Drops both installed flags; call
  /// `WindDebugRegistry.resetForTesting()` separately from the test file
  /// to also clear the registry (the registry method is @visibleForTesting
  /// and may only be called from test/ context).
  @visibleForTesting
  static void resetForTesting() {
    _installed = false;
    _perfInstalled = false;
  }
}
