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
      expect(WindPerfCounters.widgetBuilds, isEmpty);
      expect(WindPerfCounters.wrapperEmissions, isEmpty);
      expect(
        WindPerfCounters.inheritedReads.values.every((int v) => v == 0),
        isTrue,
      );
    });

    test('reset() zeroes the counters and leaves the session enabled', () {
      WindPerfCounters.enabled = true;
      WindPerfCounters.recordCacheHit();
      WindPerfCounters.recordCacheMiss();
      WindPerfCounters.recordCacheBypass();
      WindPerfCounters.recordWDivBuild();
      WindPerfCounters.recordWTextBuild();
      WindPerfCounters.recordWidgetBuild('WButton');
      WindPerfCounters.recordWrapperEmission('Container');
      WindPerfCounters.recordInheritedRead(WindInheritedRead.windTheme);

      WindPerfCounters.reset();

      expect(WindPerfCounters.cacheHits, 0);
      expect(WindPerfCounters.cacheMisses, 0);
      expect(WindPerfCounters.cacheBypasses, 0);
      expect(WindPerfCounters.wDivBuilds, 0);
      expect(WindPerfCounters.wTextBuilds, 0);
      expect(WindPerfCounters.widgetBuilds, isEmpty);
      expect(WindPerfCounters.wrapperEmissions, isEmpty);
      // The inherited-reads map keeps its four fixed keys, all zeroed, rather
      // than being cleared: the resolver's `stats()` output always carries
      // the same four keys whether or not a session has run yet.
      expect(
        WindPerfCounters.inheritedReads,
        <String, int>{
          'mediaQuerySize': 0,
          'mediaQueryBrightness': 0,
          'windTheme': 0,
          'defaultTextStyle': 0,
        },
      );
      // A measurement session outlives a cache clear: clearCache() calls
      // reset(), and turning the flag off there would end the session that
      // asked for the numbers.
      expect(WindPerfCounters.enabled, isTrue);
    });

    testWidgets(
      'widgetBuilds and wrapperEmissions count a pumped WButton',
      (tester) async {
        WindPerfCounters.enabled = true;

        await tester.pumpWidget(
          wrapWithTheme(
            WButton(
              onTap: () {},
              className: 'bg-blue-600',
              child: const WText('x'),
            ),
          ),
        );

        // w_button.dart:184 (Container) and w_anchor.dart:336 (MouseRegion,
        // unconditional) are the two cited emission sites.
        expect(WindPerfCounters.widgetBuilds['WButton'], 1);
        expect(
          WindPerfCounters.wrapperEmissions['Container'],
          greaterThanOrEqualTo(1),
        );
        expect(
          WindPerfCounters.wrapperEmissions['MouseRegion'],
          greaterThanOrEqualTo(1),
        );
      },
    );

    testWidgets(
      'a decorated WDiv counts its box primitives, not a Container',
      (tester) async {
        WindPerfCounters.enabled = true;

        await tester.pumpWidget(
          wrapWithTheme(
            const WDiv(
              className: 'w-20 p-2 bg-white border rounded-lg',
              child: WText('Box'),
            ),
          ),
        );

        final Map<String, int> emitted = WindPerfCounters.wrapperEmissions;
        expect(emitted['Container'], isNull);
        expect(emitted['DecoratedBox'], 1);
        expect(emitted['Padding'], 1);
        expect(emitted['ConstrainedBox'], 1);
      },
    );

    testWidgets(
      'a transitioned WDiv still counts one AnimatedContainer',
      (tester) async {
        WindPerfCounters.enabled = true;

        await tester.pumpWidget(
          wrapWithTheme(
            const WDiv(
              className: 'p-2 bg-white duration-300',
              child: WText('Box'),
            ),
          ),
        );

        expect(WindPerfCounters.wrapperEmissions['AnimatedContainer'], 1);
        expect(WindPerfCounters.wrapperEmissions['DecoratedBox'], isNull);
      },
    );

    testWidgets(
      'a hover-only WDiv counts no Focus, a focus: WDiv counts one',
      (tester) async {
        WindPerfCounters.enabled = true;

        await tester.pumpWidget(
          wrapWithTheme(
            const WDiv(className: 'hover:bg-gray-100', child: WText('Row')),
          ),
        );
        expect(WindPerfCounters.wrapperEmissions['Focus'], isNull);
        expect(WindPerfCounters.wrapperEmissions['MouseRegion'], 1);
        expect(WindPerfCounters.wrapperEmissions['WindAnchorStateProvider'], 1);

        WindPerfCounters.reset();
        await tester.pumpWidget(
          wrapWithTheme(
            const WDiv(className: 'focus:ring-2', child: WText('Row')),
          ),
        );
        expect(WindPerfCounters.wrapperEmissions['Focus'], 1);
      },
    );

    testWidgets(
      'a WText with its own colour reads no DefaultTextStyle',
      (tester) async {
        WindPerfCounters.enabled = true;

        await tester.pumpWidget(
          wrapWithTheme(const WText('Latency', className: 'text-gray-900')),
        );

        expect(WindPerfCounters.inheritedReads['defaultTextStyle'], 0);
      },
    );

    testWidgets(
      'inheritedReads counts windTheme/mediaQueryBrightness on a pumped WInput',
      (tester) async {
        WindPerfCounters.enabled = true;

        await tester.pumpWidget(wrapWithTheme(const WInput()));

        // w_input.dart:679-681: WindTheme.maybeDataOf is always read; the
        // ambient WindTheme supplies a brightness, so the MediaQuery fallback
        // is not reached in this fixture (a WindTheme ancestor is present).
        expect(
          WindPerfCounters.inheritedReads['windTheme'],
          greaterThanOrEqualTo(1),
        );
      },
    );

    testWidgets(
      'inheritedReads counts mediaQuerySize/windTheme on a plain WDiv build',
      (tester) async {
        WindPerfCounters.enabled = true;

        // wind_context.dart:70-71: WindContext.build reads WindTheme.dataOf
        // and MediaQuery.of(context).size on every WindParser.parse, which
        // runs for every WDiv/WText build, not only WInput and the h-full
        // paths that were the only recorders before this fix.
        await tester.pumpWidget(wrapWithTheme(const WDiv(className: 'p-2')));

        expect(
          WindPerfCounters.inheritedReads['mediaQuerySize'],
          greaterThanOrEqualTo(1),
        );
        expect(
          WindPerfCounters.inheritedReads['windTheme'],
          greaterThanOrEqualTo(1),
        );
      },
    );

    testWidgets(
      'inheritedReads counts defaultTextStyle/mediaQueryBrightness on a bare WText',
      (tester) async {
        WindPerfCounters.enabled = true;

        // No Material ancestor and no explicit text color, so WText's
        // fallback (w_text.dart:200-207) reads both. Mirrors the "bare
        // context" fixture in test/widgets/w_text/baseline_test.dart.
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: WindTheme(
              data: WindThemeData(),
              child: const WText('Latency'),
            ),
          ),
        );

        expect(
          WindPerfCounters.inheritedReads['defaultTextStyle'],
          greaterThanOrEqualTo(1),
        );
        expect(
          WindPerfCounters.inheritedReads['mediaQueryBrightness'],
          greaterThanOrEqualTo(1),
        );
      },
    );

    testWidgets(
      'counting changes nothing emitted: identical find.byType inventory on and off',
      (tester) async {
        // A representative WDiv className set exercising the Container,
        // Padding, Align, Expanded and DefaultTextStyle.merge branches of the
        // composition pipeline (w_div.dart), so a counting call that ever
        // added, removed or reordered a wrapper would show up as a differing
        // widget-type inventory below.
        Widget buildTree() => wrapWithTheme(
              WDiv(
                className: 'flex flex-col p-4 gap-2 items-center',
                children: const [
                  WDiv(
                    className:
                        'bg-blue-500 rounded-lg shadow-md m-2 flex-1 text-white',
                    child: WText('Row 1', className: 'text-sm font-bold'),
                  ),
                  WDiv(
                    className: 'w-1/2 self-center opacity-75',
                    child: WText('Row 2'),
                  ),
                ],
              ),
            );

        WindPerfCounters.enabled = false;
        await tester.pumpWidget(buildTree());
        final List<Type> typesOff =
            tester.allWidgets.map((Widget w) => w.runtimeType).toList();

        WindPerfCounters.enabled = true;
        await tester.pumpWidget(buildTree());
        final List<Type> typesOn =
            tester.allWidgets.map((Widget w) => w.runtimeType).toList();

        expect(typesOn, typesOff);
      },
    );
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

    testWidgets('stats() reports exactly the nine pinned keys', (
      tester,
    ) async {
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
          'widgetBuilds',
          'wrapperEmissions',
          'inheritedReads',
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
      expect((stats['widgetBuilds'] as Map)['WDiv'], 1);
      expect((stats['widgetBuilds'] as Map)['WText'], 1);
      expect(
        (stats['inheritedReads'] as Map).keys.toSet(),
        <String>{
          'mediaQuerySize',
          'mediaQueryBrightness',
          'windTheme',
          'defaultTextStyle',
        },
      );
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
