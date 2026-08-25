import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';
import 'package:fluttersdk_wind_diagnostics_contracts/fluttersdk_wind_diagnostics_contracts.dart';

/// Stands in for wind's own implementation to prove `installPerfResolver()`
/// really returns early on a second call.
///
/// Comparing two `const WindPerfResolverImpl()` instances with `identical`
/// cannot prove it: const canonicalization makes them the same object whether
/// the second install ran or not.
class _FakePerfResolver implements WindPerfResolver {
  const _FakePerfResolver();

  @override
  Map<String, Object?> stats() => const <String, Object?>{'cacheHits': -1};
}

Widget wrapWithTheme(Widget child) {
  return MaterialApp(
    home: WindTheme(
      data: WindThemeData(),
      child: Scaffold(body: child),
    ),
  );
}

void main() {
  setUp(() {
    WindParser.clearCache();
    Wind.resetForTesting();
    WindDebugRegistry.resetForTesting();
  });

  tearDown(() {
    WindPerfCounters.enabled = false;
    WindParser.clearCache();
    Wind.resetForTesting();
    WindDebugRegistry.resetForTesting();
  });

  group('WindPerfCounters', () {
    testWidgets('counts one WDiv build per pump', (tester) async {
      WindPerfCounters.enabled = true;

      await tester.pumpWidget(wrapWithTheme(const WDiv(className: 'p-4')));
      expect(WindPerfCounters.wDivBuilds, 1);

      await tester.pumpWidget(wrapWithTheme(const WDiv(className: 'p-4')));
      expect(WindPerfCounters.wDivBuilds, 2);
      expect(WindPerfCounters.wTextBuilds, 0);
    });

    testWidgets('counts one WText build per pump', (tester) async {
      WindPerfCounters.enabled = true;

      await tester.pumpWidget(
        wrapWithTheme(const WText('Latency', className: 'text-sm')),
      );
      expect(WindPerfCounters.wTextBuilds, 1);

      await tester.pumpWidget(
        wrapWithTheme(const WText('Latency', className: 'text-sm')),
      );
      expect(WindPerfCounters.wTextBuilds, 2);
      expect(WindPerfCounters.wDivBuilds, 0);
    });

    testWidgets('records nothing at all while disabled', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const WDiv(
            className: 'p-4',
            child: WText('Latency', className: 'text-sm'),
          ),
        ),
      );

      expect(WindPerfCounters.wDivBuilds, 0);
      expect(WindPerfCounters.wTextBuilds, 0);
      expect(WindPerfCounters.cacheHits, 0);
      expect(WindPerfCounters.cacheMisses, 0);
      expect(WindPerfCounters.cacheBypasses, 0);
    });

    test('reset() zeroes the counters and leaves the session enabled', () {
      WindPerfCounters.enabled = true;
      WindPerfCounters.recordCacheHit();
      WindPerfCounters.recordCacheMiss();
      WindPerfCounters.recordCacheBypass();
      WindPerfCounters.recordWDivBuild();
      WindPerfCounters.recordWTextBuild();

      WindPerfCounters.reset();

      expect(WindPerfCounters.cacheHits, 0);
      expect(WindPerfCounters.cacheMisses, 0);
      expect(WindPerfCounters.cacheBypasses, 0);
      expect(WindPerfCounters.wDivBuilds, 0);
      expect(WindPerfCounters.wTextBuilds, 0);
      // A measurement session outlives a cache clear: clearCache() calls
      // reset(), and turning the flag off there would end the session that
      // asked for the numbers.
      expect(WindPerfCounters.enabled, isTrue);
    });
  });

  group('Wind.installPerfResolver()', () {
    test('registers into the perf slot and leaves the debug slot empty', () {
      expect(WindDebugRegistry.currentPerf, isNull);

      Wind.installPerfResolver();

      expect(WindDebugRegistry.currentPerf, isA<WindPerfResolverImpl>());
      expect(WindDebugRegistry.current, isNull);
    });

    test('is idempotent: a second call does not re-register', () {
      Wind.installPerfResolver();
      WindDebugRegistry.registerPerf(const _FakePerfResolver());

      Wind.installPerfResolver();

      expect(WindDebugRegistry.currentPerf, isA<_FakePerfResolver>());
    });

    test('resetForTesting() makes the perf install gate re-entrant', () {
      Wind.installPerfResolver();
      Wind.resetForTesting();
      WindDebugRegistry.resetForTesting();

      Wind.installPerfResolver();

      expect(WindDebugRegistry.currentPerf, isA<WindPerfResolverImpl>());
    });

    testWidgets('stats() reports exactly the six pinned keys', (tester) async {
      WindPerfCounters.enabled = true;
      await tester.pumpWidget(
        wrapWithTheme(
          const WDiv(
            className: 'p-4',
            child: WText('Latency', className: 'text-sm'),
          ),
        ),
      );

      Wind.installPerfResolver();
      final Map<String, Object?> stats = WindDebugRegistry.currentPerf!.stats();

      // The key set is the cross-repo contract fluttersdk_dusk reads; an extra
      // or renamed key is a silently empty section in its report.
      expect(
        stats.keys.toList(),
        <String>[
          'cacheHits',
          'cacheMisses',
          'cacheBypasses',
          'cacheSize',
          'wDivBuilds',
          'wTextBuilds',
        ],
      );
      expect(stats['wDivBuilds'], 1);
      expect(stats['wTextBuilds'], 1);
      expect(stats['cacheSize'], WindParser.cacheSize);
      // No `style:` was given, so `baseStyle` reached the parser as null and
      // both parses went through the cache. See the bypass test below for why
      // that is worth asserting rather than assuming.
      expect(stats['cacheBypasses'], 0);
      expect(stats['cacheMisses'], greaterThanOrEqualTo(2));
    });

    testWidgets('a widget given an explicit style bypasses the cache', (
      tester,
    ) async {
      WindPerfCounters.enabled = true;

      // `WDiv` and `WText` both call the parser as `baseStyle: style`, and
      // `style` is the widget's own nullable property. So a bypass is NOT a
      // property of using these widgets, as it would be easy to assume from
      // the call site; it is a property of a caller supplying `style:`. That
      // distinction is the whole reason bypasses are counted separately, and
      // it is why this test passes a style and the one above does not.
      await tester.pumpWidget(
        wrapWithTheme(
          const WDiv(
            className: 'p-4',
            style: WindStyle(),
            child: WText(
              'Latency',
              className: 'text-sm',
              style: WindStyle(),
            ),
          ),
        ),
      );

      Wind.installPerfResolver();
      final Map<String, Object?> stats = WindDebugRegistry.currentPerf!.stats();

      expect(stats['cacheBypasses'], greaterThanOrEqualTo(2));
      // A bypass never writes the cache, which is what makes it repeat work on
      // every rebuild rather than paying once.
      expect(stats['cacheSize'], 0);
    });
  });
}
