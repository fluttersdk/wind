import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/src/parser/wind_parser.dart';
import 'package:fluttersdk_wind/src/theme/wind_theme.dart';
import 'package:fluttersdk_wind/src/theme/wind_theme_data.dart';
import 'package:fluttersdk_wind/src/widgets/w_div.dart';

/// Number of iterations for the cache cold/warm bench.
const int _kBenchIterations = 10000;

/// className used for the cache bench.
const String _kBenchClassName =
    'bg-white p-4 m-2 text-lg font-bold rounded-md shadow-sm';

/// Returns a [WDiv] node with [className] wrapping [child].
Widget _styledNode(String className, Widget? child) => WDiv(
      className: className,
      child: child,
    );

/// Builds a balanced wide/deep tree of [WDiv] nodes.
///
/// Strategy: two nesting levels + a wide fan-out so the total node count
/// reaches ~300-500 styled nodes without blowing the widget tree stack.
/// Layout: 20 outer nodes x 20 inner nodes = 400 leaf renders.
Widget _buildLargeTree() {
  const outerCount = 20;
  const innerCount = 20;

  final outerChildren = List.generate(outerCount, (outerIndex) {
    final innerChildren = List.generate(innerCount, (innerIndex) {
      // Alternate class names so the parser cache sees diverse keys.
      final isEven = (outerIndex + innerIndex) % 2 == 0;
      final leafClass = isEven
          ? 'bg-gray-100 p-2 text-sm rounded'
          : 'bg-blue-50 p-3 text-base font-medium';

      return _styledNode(leafClass, const SizedBox(width: 20, height: 20));
    });

    return _styledNode(
      'flex flex-col p-2 m-1 bg-white rounded-md',
      Column(children: innerChildren),
    );
  });

  return _styledNode(
    'flex flex-col p-4 bg-gray-50',
    Column(children: outerChildren),
  );
}

void main() {
  setUp(WindParser.clearCache);

  group('Parser performance', () {
    /// Cache cold vs warm speedup ratio gate.
    ///
    /// Cold: [WindParser.clearCache] is called before every parse so every
    /// call is a cache miss. Warm: the same className is parsed once to prime
    /// the cache, then re-parsed [_kBenchIterations] times — every call hits.
    ///
    /// Assertion: warm total time must be less than cold total time / 3,
    /// i.e. the cache must deliver at least a 3x speedup. The multiplier is
    /// deliberately generous to stay stable across CI environments.
    testWidgets('cache warm path is at least 3x faster than cold path',
        (tester) async {
      // 1. Capture a real BuildContext from inside the widget tree.
      late BuildContext capturedCtx;
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: Builder(
              builder: (context) {
                capturedCtx = context;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      // 2. Cold bench: clear the cache before each iteration, but time only the
      //    parse() call. clearCache() stays OUTSIDE the measured window so
      //    coldTotal reflects pure cache-miss parse cost, not map-clear cost.
      final coldWatch = Stopwatch();
      for (var i = 0; i < _kBenchIterations; i++) {
        WindParser.clearCache();
        coldWatch.start();
        WindParser.parse(_kBenchClassName, capturedCtx);
        coldWatch.stop();
      }
      final coldTotal = coldWatch.elapsedMicroseconds;

      // 3. Verify the cache received exactly one entry after the last miss.
      expect(WindParser.cacheSize, 1,
          reason: 'cold bench must leave one cache entry after the last miss');

      // 4. Warm bench: prime the cache once, then hit it [_kBenchIterations]
      //    times without clearing between iterations.
      WindParser.clearCache();
      WindParser.parse(_kBenchClassName, capturedCtx); // prime
      final cacheSizeAfterPrime = WindParser.cacheSize;

      // Time only the parse() call per iteration, matching the cold bench's
      // per-iteration start/stop so the speedup ratio compares like with like.
      final warmWatch = Stopwatch();
      for (var i = 0; i < _kBenchIterations; i++) {
        warmWatch.start();
        WindParser.parse(_kBenchClassName, capturedCtx);
        warmWatch.stop();
      }
      final warmTotal = warmWatch.elapsedMicroseconds;

      // 5. Cache must NOT grow during warm iterations (pure hits, no new misses).
      expect(WindParser.cacheSize, cacheSizeAfterPrime,
          reason: 'cache size must be stable during warm iterations');

      // 6. Report raw numbers.
      debugPrint('PERF: cache cold total = ${coldTotal}us '
          '($_kBenchIterations iters)');
      debugPrint('PERF: cache warm total = ${warmTotal}us '
          '($_kBenchIterations iters)');
      final ratio = coldTotal / (warmTotal == 0 ? 1 : warmTotal);
      debugPrint('PERF: cache speedup ratio = ${ratio.toStringAsFixed(2)}x');

      // 7. Ratio gate: warm must be at least 3x faster than cold.
      expect(
        warmTotal,
        lessThan(coldTotal ~/ 3),
        reason: 'warm cache must be at least 3x faster than cold '
            '(cold=${coldTotal}us warm=${warmTotal}us)',
      );
    });

    /// Large-tree render bench: report-only, no hard assert.
    ///
    /// Builds a 400-node styled [WDiv] tree and pumps it via [pumpWidget],
    /// measuring the wall time. The result is printed under the [PERF:] prefix
    /// for Step 7 scraping.
    testWidgets('large-tree pump time (report-only)', (tester) async {
      final tree = MaterialApp(
        home: WindTheme(
          data: WindThemeData(),
          child: SingleChildScrollView(child: _buildLargeTree()),
        ),
      );

      final watch = Stopwatch()..start();
      await tester.pumpWidget(tree);
      watch.stop();

      final pumpMs = watch.elapsedMilliseconds;
      debugPrint('PERF: large-tree pump = ${pumpMs}ms (400 styled nodes)');

      // Smoke-check only: the tree must actually render without throwing.
      expect(find.byType(WDiv), findsWidgets);
    });
  });
}
