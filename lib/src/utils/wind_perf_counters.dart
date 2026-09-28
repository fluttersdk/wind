import 'package:flutter/foundation.dart';

/// The four inherited-widget reads [WindPerfCounters.recordInheritedRead]
/// tracks. Backed by an enum rather than a free string so a call site cannot
/// typo a key that would then silently sit outside the pinned four; `.name`
/// is what gets written into [WindPerfCounters.inheritedReads], so the stats
/// map keys are unchanged by this type.
enum WindInheritedRead {
  /// `MediaQuery.of(context).size`.
  mediaQuerySize,

  /// `MediaQuery.maybePlatformBrightnessOf(context)`.
  mediaQueryBrightness,

  /// `WindTheme.dataOf(context)` / `WindTheme.maybeDataOf(context)`.
  windTheme,

  /// `DefaultTextStyle.of(context)`.
  defaultTextStyle,
}

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

  /// Per-type build counts for every W-widget with a build method (e.g.
  /// `'WButton'`), keyed by [Widget.runtimeType] as printed at the call site,
  /// not via reflection.
  static final Map<String, int> _widgetBuilds = <String, int>{};

  /// Per-type emission counts for the Flutter (or Wind-authored render-layer)
  /// wrapper widgets Wind inserts around content (`'Container'`, `'Padding'`,
  /// `'MouseRegion'`, ...).
  static final Map<String, int> _wrapperEmissions = <String, int>{};

  /// Inherited-widget read counts, fixed to four keys: `mediaQuerySize`,
  /// `mediaQueryBrightness`, `windTheme`, `defaultTextStyle`.
  static final Map<String, int> _inheritedReads = <String, int>{
    'mediaQuerySize': 0,
    'mediaQueryBrightness': 0,
    'windTheme': 0,
    'defaultTextStyle': 0,
  };

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

  /// Per-W-widget-type build counts. Read-only snapshot; mutate only through
  /// [recordWidgetBuild].
  static Map<String, int> get widgetBuilds => Map.unmodifiable(_widgetBuilds);

  /// Per-wrapper-type emission counts. Read-only snapshot; mutate only
  /// through [recordWrapperEmission].
  static Map<String, int> get wrapperEmissions =>
      Map.unmodifiable(_wrapperEmissions);

  /// Inherited-widget read counts. Read-only snapshot; mutate only through
  /// [recordInheritedRead].
  static Map<String, int> get inheritedReads =>
      Map.unmodifiable(_inheritedReads);

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

  /// Records one build of the W-widget named [typeName] (e.g. `'WButton'`).
  ///
  /// Additive to [recordWDivBuild] / [recordWTextBuild]: those two dedicated
  /// counters stay for backward compatibility with the pinned six-key
  /// contract, and this call sits next to them rather than replacing them.
  @internal
  static void recordWidgetBuild(String typeName) {
    if (!enabled) return;
    _widgetBuilds[typeName] = (_widgetBuilds[typeName] ?? 0) + 1;
  }

  /// Records one emission of the wrapper widget named [typeName] (e.g.
  /// `'Container'`, `'MouseRegion'`).
  @internal
  static void recordWrapperEmission(String typeName) {
    if (!enabled) return;
    _wrapperEmissions[typeName] = (_wrapperEmissions[typeName] ?? 0) + 1;
  }

  /// Records one read of the inherited widget [read].
  @internal
  static void recordInheritedRead(WindInheritedRead read) {
    if (!enabled) return;
    final String key = read.name;
    _inheritedReads[key] = (_inheritedReads[key] ?? 0) + 1;
  }

  /// Zeroes every counter, leaving [enabled] alone.
  ///
  /// Public, unlike the recorders: a measurement session opens by zeroing the
  /// counters from another package (`magic_devtools` assigns dusk's
  /// session-begin hook), so this is part of the cross-package contract rather
  /// than wind's own bookkeeping.
  ///
  /// `WindParser.clearCache()` calls this, so a hit rate is always reported
  /// against the cache it was measured on. Clearing the flag here would end a
  /// measurement session on the next theme change, which is not this method's
  /// decision to make.
  static void reset() {
    _cacheHits = 0;
    _cacheMisses = 0;
    _cacheBypasses = 0;
    _wDivBuilds = 0;
    _wTextBuilds = 0;
    _widgetBuilds.clear();
    _wrapperEmissions.clear();
    _inheritedReads.updateAll((_, __) => 0);
  }
}
