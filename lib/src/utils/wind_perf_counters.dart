import 'package:flutter/foundation.dart';

/// Opt-in aggregate counters for Wind's hottest path.
///
/// `WindParser.parse` runs on every build of every W-widget, so these counters
/// are OFF by default and every increment sits behind [enabled]: a disabled
/// counter costs one static bool load and returns. A debug tool (dusk's
/// performance session, via `Wind.installPerfResolver()`) flips the flag on for
/// the length of a measurement and reads the totals back out.
///
/// The cache has THREE outcomes, not two, and they are counted separately:
///
/// - **Hit**: no `baseStyle`, and the context-derived cache key is present.
/// - **Miss**: no `baseStyle`, key absent, so the style is parsed and cached.
/// - **Bypass**: a `baseStyle` was supplied, so the parser never consults and
///   never writes the cache (the key does not include `baseStyle`; see
///   `WindParser.parse`). A bypass is a property of a CALLER writing `style:`,
///   not of using `WDiv` or `WText`: both pass `baseStyle: style`, and `style`
///   is the widget's own nullable property, null in ordinary use, so those
///   calls take the cached path. Driven against a real app, bypasses measured
///   zero across 1613 W-widget builds. Counting them separately is what turned
///   that from an argument into a number; folding them into misses would have
///   left a cache-miss rate that looks explainable and says nothing about the
///   work that never amortises.
class WindPerfCounters {
  WindPerfCounters._();

  /// Whether counting is active. `false` in every app that has not explicitly
  /// asked for a measurement, which is what keeps the cost opt-in.
  static bool enabled = false;

  static int _cacheHits = 0;
  static int _cacheMisses = 0;
  static int _cacheBypasses = 0;
  static int _wDivBuilds = 0;
  static int _wTextBuilds = 0;

  /// Parses served from the style cache.
  static int get cacheHits => _cacheHits;

  /// Parses that were not in the cache and were computed and cached.
  static int get cacheMisses => _cacheMisses;

  /// Parses that skipped the cache entirely because a `baseStyle` was given.
  static int get cacheBypasses => _cacheBypasses;

  /// `WDiv` builds that reached the style-resolution step.
  static int get wDivBuilds => _wDivBuilds;

  /// `WText` builds that reached the style-resolution step.
  static int get wTextBuilds => _wTextBuilds;

  /// Records a style served from the cache.
  @internal
  static void recordCacheHit() {
    if (!enabled) return;
    _cacheHits++;
  }

  /// Records a style computed and written into the cache.
  @internal
  static void recordCacheMiss() {
    if (!enabled) return;
    _cacheMisses++;
  }

  /// Records a style computed with the cache skipped entirely.
  @internal
  static void recordCacheBypass() {
    if (!enabled) return;
    _cacheBypasses++;
  }

  /// Records one `WDiv` build.
  @internal
  static void recordWDivBuild() {
    if (!enabled) return;
    _wDivBuilds++;
  }

  /// Records one `WText` build.
  @internal
  static void recordWTextBuild() {
    if (!enabled) return;
    _wTextBuilds++;
  }

  /// Zeroes every counter, leaving [enabled] alone.
  ///
  /// `WindParser.clearCache()` calls this, so a hit rate is always reported
  /// against the cache it was measured on. Clearing the flag here would end a
  /// measurement session on the next theme change, which is not this method's
  /// decision to make.
  @internal
  static void reset() {
    _cacheHits = 0;
    _cacheMisses = 0;
    _cacheBypasses = 0;
    _wDivBuilds = 0;
    _wTextBuilds = 0;
  }
}
