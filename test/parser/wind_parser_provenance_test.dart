import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/src/parser/wind_parser.dart';
import 'package:fluttersdk_wind/src/parser/wind_style.dart';
import 'package:fluttersdk_wind/src/theme/wind_theme.dart';
import 'package:fluttersdk_wind/src/theme/wind_theme_data.dart';

/// Tests for the opt-in provenance tracking added to [WindParser.parse].
///
/// Wave 2 / Step 2.1 of dusk-magic-wind-enrichment-deepening:
///   - `WindStyle.resolvedVia` is an OPT-IN debug map (`Map<String, String>?`).
///   - `WindParser.parse(..., trackProvenance: true)` populates it.
///   - Equality and hashCode IGNORE `resolvedVia` (cache-key safety).
///   - `toString` DOES include `resolvedVia` (debug-readability).
///   - When `trackProvenance: true`, the cache is BYPASSED so the map is fresh.
///   - When `trackProvenance: false` (default), the existing cache + fast path
///     are untouched.
void main() {
  // Pump a host widget that exposes a real BuildContext under WindTheme.
  // Uses an explicit [MediaQuery] override so screen-width-driven breakpoints
  // are deterministic — `tester.view.physicalSize` does not always propagate
  // through MediaQuery.of() in the same frame.
  Future<void> pumpHost(
    WidgetTester tester,
    void Function(BuildContext context) onBuild, {
    Brightness brightness = Brightness.light,
    double screenWidth = 400,
    double screenHeight = 800,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(brightness: brightness),
        home: MediaQuery(
          data: MediaQueryData(size: Size(screenWidth, screenHeight)),
          child: WindTheme(
            data: WindThemeData(
              brightness: brightness,
              syncWithSystem: false,
            ),
            child: Builder(
              builder: (context) {
                onBuild(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
  }

  setUp(() {
    WindParser.clearCache();
  });

  group('WindStyle.resolvedVia field', () {
    test('defaults to null when not provided', () {
      const style = WindStyle();
      expect(style.resolvedVia, isNull);
    });

    test('round-trips through const constructor', () {
      const style = WindStyle(resolvedVia: {'bg-blue-500': 'hover,dark'});
      expect(style.resolvedVia, {'bg-blue-500': 'hover,dark'});
    });

    test('copyWith passes resolvedVia through', () {
      const original = WindStyle();
      final copy = original.copyWith(
        resolvedVia: const {'text-white': 'md,hover'},
      );
      expect(copy.resolvedVia, {'text-white': 'md,hover'});
    });

    test('copyWith without resolvedVia preserves existing value', () {
      const original = WindStyle(resolvedVia: {'bg-red-500': 'base'});
      final copy = original.copyWith(width: 100);
      expect(copy.resolvedVia, {'bg-red-500': 'base'});
      expect(copy.width, 100);
    });

    test('== EXCLUDES resolvedVia (same style with/without provenance equal)',
        () {
      const without = WindStyle(width: 100);
      const withProv = WindStyle(
        width: 100,
        resolvedVia: {'w-100': 'base'},
      );
      expect(withProv == without, isTrue,
          reason: 'Provenance must NOT affect equality.');
    });

    test('hashCode EXCLUDES resolvedVia (same style with/without share hash)',
        () {
      const without = WindStyle(width: 100);
      const withProv = WindStyle(
        width: 100,
        resolvedVia: {'w-100': 'base'},
      );
      expect(withProv.hashCode, equals(without.hashCode),
          reason: 'Provenance must NOT affect hashCode.');
    });

    test('toString INCLUDES resolvedVia when non-null', () {
      const style = WindStyle(
        width: 100,
        resolvedVia: {'w-100': 'md,hover'},
      );
      final str = style.toString();
      expect(str, contains('resolvedVia:'));
      expect(str, contains('w-100'));
      expect(str, contains('md,hover'));
    });

    test('toString INCLUDES resolvedVia: null marker when null', () {
      const style = WindStyle();
      // Either omitted, or printed as null — but the field name should NOT
      // surface noisy values. We assert the contract: when resolvedVia is null
      // we still want a single, predictable string form.
      expect(style.toString(), contains('resolvedVia: null'));
    });
  });

  group('WindParser.parse — trackProvenance default OFF', () {
    testWidgets('signature accepts trackProvenance named param',
        (tester) async {
      late WindStyle style;
      await pumpHost(tester, (context) {
        style = WindParser.parse(
          'bg-blue-500',
          context,
          trackProvenance: false,
        );
      });
      expect(style.resolvedVia, isNull);
    });

    testWidgets('default behavior leaves resolvedVia null', (tester) async {
      late WindStyle style;
      await pumpHost(tester, (context) {
        style = WindParser.parse('bg-blue-500 text-white', context);
      });
      expect(style.resolvedVia, isNull);
    });

    testWidgets('cache hit path is preserved when flag default',
        (tester) async {
      late WindStyle first;
      late WindStyle second;
      await pumpHost(tester, (context) {
        first = WindParser.parse('bg-red-500 p-4', context);
        second = WindParser.parse('bg-red-500 p-4', context);
      });
      // Same WindStyle instance returned from cache.
      expect(identical(first, second), isTrue,
          reason: 'Default-path cache hit must return same instance.');
      expect(WindParser.cacheSize, greaterThan(0));
    });
  });

  group('WindParser.parse — trackProvenance ON', () {
    testWidgets('single unprefixed token records "base" provenance',
        (tester) async {
      late WindStyle style;
      await pumpHost(tester, (context) {
        style = WindParser.parse(
          'bg-blue-500',
          context,
          trackProvenance: true,
        );
      });
      expect(style.resolvedVia, isNotNull);
      expect(style.resolvedVia, contains('bg-blue-500'));
      expect(style.resolvedVia!['bg-blue-500'], 'base');
    });

    testWidgets('multi-prefix token records joined prefix path',
        (tester) async {
      late WindStyle style;
      // Activate md breakpoint (>=768), hover, dark to trigger md:hover:dark:.
      await pumpHost(
        tester,
        (context) {
          style = WindParser.parse(
            'md:hover:dark:bg-blue-500',
            context,
            states: const {'hover'},
            trackProvenance: true,
          );
        },
        brightness: Brightness.dark,
        screenWidth: 900, // md range
      );
      expect(style.resolvedVia, isNotNull);
      expect(style.resolvedVia, contains('bg-blue-500'));
      // Recording order mirrors the prefix order in the className.
      expect(style.resolvedVia!['bg-blue-500'], 'md,hover,dark');
    });

    testWidgets('omits classes whose prefixes do not match the context',
        (tester) async {
      late WindStyle style;
      await pumpHost(tester, (context) {
        // hover NOT in activeStates → hover:bg-red-500 should not appear.
        style = WindParser.parse(
          'bg-blue-500 hover:bg-red-500',
          context,
          trackProvenance: true,
        );
      });
      expect(style.resolvedVia, isNotNull);
      expect(style.resolvedVia, contains('bg-blue-500'));
      expect(style.resolvedVia!['bg-blue-500'], 'base');
      expect(style.resolvedVia!.containsKey('bg-red-500'), isFalse,
          reason: 'Non-matching prefixed class must not appear in provenance.');
    });

    testWidgets('bypasses the cache so provenance is populated on every call',
        (tester) async {
      late WindStyle first;
      late WindStyle second;
      await pumpHost(tester, (context) {
        // Warm the cache with a default (flag off) call.
        WindParser.parse('bg-blue-500', context);
        // Now request provenance — must NOT short-circuit on the cached entry.
        first = WindParser.parse(
          'bg-blue-500',
          context,
          trackProvenance: true,
        );
        second = WindParser.parse(
          'bg-blue-500',
          context,
          trackProvenance: true,
        );
      });
      expect(first.resolvedVia, isNotNull,
          reason: 'Cache hit must NOT short-circuit the provenance branch.');
      expect(second.resolvedVia, isNotNull);
      // Each provenance call recomputes; do not reuse the cached "no provenance"
      // value.
      expect(first.resolvedVia, equals(second.resolvedVia));
    });

    testWidgets('cache entries from flag=false calls remain reusable',
        (tester) async {
      late WindStyle cached;
      late WindStyle provenanceRun;
      await pumpHost(tester, (context) {
        cached = WindParser.parse('p-4', context);
        provenanceRun = WindParser.parse('p-4', context, trackProvenance: true);
        // A subsequent flag=false call should still hit the original cache
        // entry (provenance run must not overwrite or pollute the cache).
        final cachedAgain = WindParser.parse('p-4', context);
        expect(identical(cached, cachedAgain), isTrue,
            reason:
                'Provenance recompute must NOT mutate the existing cache slot.');
      });
      expect(cached.resolvedVia, isNull);
      expect(provenanceRun.resolvedVia, isNotNull);
    });
  });
}
