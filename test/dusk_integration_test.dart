import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_dusk/dusk.dart';
import 'package:fluttersdk_wind/dusk_integration.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Tests for the Wind ↔ Dusk snapshot enricher.
///
/// The enricher's contract (per FROZEN `DuskSnapshotEnricher` typedef):
///   `String? Function(Element, RefRegistry)`
///
/// - Returns null on miss (non-W widget OR empty className).
/// - Never retains the Element across calls.
/// - Reads only — no shared-state mutation beyond the explicit
///   `WindDuskIntegration.enableProvenance(bool)` toggle.

/// Helper to wrap widget in MaterialApp with WindTheme (canonical wind test
/// harness pattern per `wind/.claude/rules/tests.md`).
Widget wrapWithTheme(Widget child, {Size size = const Size(1024, 768)}) {
  return MediaQuery(
    data: MediaQueryData(size: size),
    child: MaterialApp(
      home: WindTheme(
        data: WindThemeData(),
        child: Scaffold(body: child),
      ),
    ),
  );
}

/// Returns the first Element in the tree of type [T] (canonical fixture).
Element _firstElementOf<T>(WidgetTester tester) {
  return tester.element(find.byType(T).first);
}

void main() {
  setUp(() {
    // Cache persists across tests; clearing is mandatory per
    // wind/.claude/rules/tests.md.
    WindParser.clearCache();
    // Reset the integration state so each test starts from a clean slate.
    WindDuskIntegration.resetForTesting();
  });

  tearDown(() {
    WindDuskIntegration.resetForTesting();
    WindParser.clearCache();
  });

  // ---------------------------------------------------------------------------
  // install() / resetForTesting() lifecycle
  // ---------------------------------------------------------------------------

  group('WindDuskIntegration.install', () {
    test('registers windClassNameEnricher on first install', () {
      expect(DuskPlugin.enrichers, isEmpty);

      WindDuskIntegration.install();

      expect(DuskPlugin.enrichers, hasLength(1));
      expect(DuskPlugin.enrichers.first, same(windClassNameEnricher));
      expect(WindDuskIntegration.isInstalled, isTrue);
    });

    test('install() is idempotent (no duplicate enrichers on second call)', () {
      WindDuskIntegration.install();
      WindDuskIntegration.install();
      WindDuskIntegration.install();

      expect(DuskPlugin.enrichers, hasLength(1));
    });

    test('resetForTesting() removes the enricher and resets the flag', () {
      WindDuskIntegration.install();
      expect(DuskPlugin.enrichers, hasLength(1));

      WindDuskIntegration.resetForTesting();

      expect(DuskPlugin.enrichers, isEmpty);
      expect(WindDuskIntegration.isInstalled, isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // W-widget guard: only W-prefixed widgets get enriched
  // ---------------------------------------------------------------------------

  group('W-widget guard', () {
    testWidgets('returns null for non-W widgets (plain SizedBox)', (
      tester,
    ) async {
      await tester.pumpWidget(wrapWithTheme(const SizedBox(width: 10)));
      final element = _firstElementOf<SizedBox>(tester);

      expect(windClassNameEnricher(element, RefRegistry.instance), isNull);
    });

    testWidgets('returns null for WDiv with null className', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const WDiv(child: SizedBox(width: 10))),
      );
      final element = _firstElementOf<WDiv>(tester);

      expect(windClassNameEnricher(element, RefRegistry.instance), isNull);
    });

    testWidgets('returns null for WDiv with empty className', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const WDiv(className: '', child: SizedBox(width: 10))),
      );
      final element = _firstElementOf<WDiv>(tester);

      expect(windClassNameEnricher(element, RefRegistry.instance), isNull);
    });

    testWidgets(
      'returns a YAML block for WButton (one of the 17 supported widgets)',
      (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(WButton(
            className: 'bg-blue-500 text-white',
            onTap: () {},
            child: const Text('Click'),
          )),
        );
        final element = _firstElementOf<WButton>(tester);

        final emitted = windClassNameEnricher(element, RefRegistry.instance);
        expect(emitted, isNotNull);
        expect(emitted, startsWith('wind:\n'));
      },
    );
  });

  // ---------------------------------------------------------------------------
  // Existing 6 fields regression suite (slots + names must NOT change)
  // ---------------------------------------------------------------------------

  group('Existing 6 fields regression', () {
    testWidgets('emits breakpoint based on screen width', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const WDiv(className: 'p-4', child: SizedBox()),
          size: const Size(1280, 800), // xl breakpoint
        ),
      );
      final element = _firstElementOf<WDiv>(tester);

      final emitted = windClassNameEnricher(element, RefRegistry.instance);
      expect(emitted, isNotNull);
      expect(emitted, contains('breakpoint: '));
    });

    testWidgets('emits brightness: light by default', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const WDiv(className: 'p-4', child: SizedBox())),
      );
      final element = _firstElementOf<WDiv>(tester);

      final emitted = windClassNameEnricher(element, RefRegistry.instance);
      expect(emitted, contains('brightness: light'));
    });

    testWidgets('emits platform field', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const WDiv(className: 'p-4', child: SizedBox())),
      );
      final element = _firstElementOf<WDiv>(tester);

      final emitted = windClassNameEnricher(element, RefRegistry.instance);
      expect(emitted, contains('platform: '));
    });

    testWidgets('emits states as a comma-separated bracketed list', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(const WDiv(className: 'p-4', child: SizedBox())),
      );
      final element = _firstElementOf<WDiv>(tester);

      final emitted = windClassNameEnricher(element, RefRegistry.instance);
      expect(emitted, contains('states: ['));
    });

    testWidgets('emits bgColor as a #RRGGBB hex when bg class resolves', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const WDiv(className: 'bg-blue-500', child: SizedBox()),
        ),
      );
      final element = _firstElementOf<WDiv>(tester);

      final emitted = windClassNameEnricher(element, RefRegistry.instance);
      expect(emitted, isNotNull);
      expect(emitted, contains("bgColor: '#"));
    });

    testWidgets('emits textColor as a #RRGGBB hex when text-* class resolves', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const WText('hello', className: 'text-red-500'),
        ),
      );
      final element = _firstElementOf<WText>(tester);

      final emitted = windClassNameEnricher(element, RefRegistry.instance);
      expect(emitted, isNotNull);
      expect(emitted, contains("textColor: '#"));
    });
  });

  // ---------------------------------------------------------------------------
  // Layout fields (Step 2.2)
  // ---------------------------------------------------------------------------

  group('Layout fields emission', () {
    testWidgets('emits displayType when flex is applied', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const WDiv(className: 'flex', child: SizedBox())),
      );
      final element = _firstElementOf<WDiv>(tester);

      final emitted = windClassNameEnricher(element, RefRegistry.instance);
      expect(emitted, contains('displayType: flex'));
    });

    testWidgets('emits flexDirection for flex-col', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const WDiv(className: 'flex flex-col', child: SizedBox()),
        ),
      );
      final element = _firstElementOf<WDiv>(tester);

      final emitted = windClassNameEnricher(element, RefRegistry.instance);
      expect(emitted, contains('flexDirection: '));
    });

    testWidgets('emits mainAxisAlignment for justify-center', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const WDiv(className: 'flex justify-center', child: SizedBox()),
        ),
      );
      final element = _firstElementOf<WDiv>(tester);

      final emitted = windClassNameEnricher(element, RefRegistry.instance);
      expect(emitted, contains('mainAxisAlignment: '));
    });

    testWidgets('emits gapX / gapY when gap-4 is applied', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const WDiv(className: 'flex gap-4', child: SizedBox()),
        ),
      );
      final element = _firstElementOf<WDiv>(tester);

      final emitted = windClassNameEnricher(element, RefRegistry.instance);
      expect(emitted, contains('gapX: '));
      expect(emitted, contains('gapY: '));
    });

    testWidgets('emits flex int when flex-1 is applied', (tester) async {
      // flex-1 builds an Expanded widget — wrap in a Row so the parent data
      // type matches.
      await tester.pumpWidget(
        wrapWithTheme(
          const Row(
            children: [
              WDiv(className: 'flex-1', child: SizedBox()),
            ],
          ),
        ),
      );
      final element = _firstElementOf<WDiv>(tester);

      final emitted = windClassNameEnricher(element, RefRegistry.instance);
      expect(emitted, contains('flex: 1'));
    });
  });

  // ---------------------------------------------------------------------------
  // Sizing fields
  // ---------------------------------------------------------------------------

  group('Sizing fields emission', () {
    testWidgets('emits width when w-[100px] is applied', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const WDiv(className: 'w-[100px]', child: SizedBox()),
        ),
      );
      final element = _firstElementOf<WDiv>(tester);

      final emitted = windClassNameEnricher(element, RefRegistry.instance);
      expect(emitted, contains('width: 100'));
    });

    testWidgets('emits height when h-[200px] is applied', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const WDiv(className: 'h-[200px]', child: SizedBox()),
        ),
      );
      final element = _firstElementOf<WDiv>(tester);

      final emitted = windClassNameEnricher(element, RefRegistry.instance);
      expect(emitted, contains('height: 200'));
    });
  });

  // ---------------------------------------------------------------------------
  // Spacing fields
  // ---------------------------------------------------------------------------

  group('Spacing fields emission', () {
    testWidgets('emits padding as "T,R,B,L" string when p-4 applied', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(const WDiv(className: 'p-4', child: SizedBox())),
      );
      final element = _firstElementOf<WDiv>(tester);

      final emitted = windClassNameEnricher(element, RefRegistry.instance);
      expect(emitted, contains('padding: '));
    });

    testWidgets('emits margin as "T,R,B,L" string when m-2 applied', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(const WDiv(className: 'm-2', child: SizedBox())),
      );
      final element = _firstElementOf<WDiv>(tester);

      final emitted = windClassNameEnricher(element, RefRegistry.instance);
      expect(emitted, contains('margin: '));
    });
  });

  // ---------------------------------------------------------------------------
  // Typography fields
  // ---------------------------------------------------------------------------

  group('Typography fields emission', () {
    testWidgets('emits fontSize when text-lg is applied', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const WText('hi', className: 'text-lg')),
      );
      final element = _firstElementOf<WText>(tester);

      final emitted = windClassNameEnricher(element, RefRegistry.instance);
      expect(emitted, contains('fontSize: '));
    });

    testWidgets(
      'emits fontWeight in numeric form (e.g. "400") when font-bold applied',
      (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WText('hi', className: 'font-bold')),
        );
        final element = _firstElementOf<WText>(tester);

        final emitted = windClassNameEnricher(element, RefRegistry.instance);
        expect(emitted, contains('fontWeight: '));
        // Numeric extraction: should be a 3-digit weight like "700".
        expect(emitted, matches(RegExp(r'fontWeight: \d{3}')));
      },
    );

    testWidgets('emits textAlign when text-center is applied', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const WText('hi', className: 'text-center')),
      );
      final element = _firstElementOf<WText>(tester);

      final emitted = windClassNameEnricher(element, RefRegistry.instance);
      expect(emitted, contains('textAlign: '));
    });

    testWidgets('emits textOverflow when truncate is applied', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const WText('hi', className: 'truncate')),
      );
      final element = _firstElementOf<WText>(tester);

      final emitted = windClassNameEnricher(element, RefRegistry.instance);
      expect(emitted, contains('textOverflow: '));
    });

    testWidgets('emits textDecoration when underline is applied', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(const WText('hi', className: 'underline')),
      );
      final element = _firstElementOf<WText>(tester);

      final emitted = windClassNameEnricher(element, RefRegistry.instance);
      expect(emitted, contains('textDecoration: '));
    });
  });

  // ---------------------------------------------------------------------------
  // Borders + Ring fields
  // ---------------------------------------------------------------------------

  group('Border + Ring fields emission', () {
    testWidgets('emits ringColor as #RRGGBB hex when ring-blue-500 applied', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const WDiv(className: 'ring-2 ring-blue-500', child: SizedBox()),
        ),
      );
      final element = _firstElementOf<WDiv>(tester);

      final emitted = windClassNameEnricher(element, RefRegistry.instance);
      expect(emitted, contains("ringColor: '#"));
    });

    testWidgets('emits ringWidth when ring-4 is applied', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const WDiv(className: 'ring-4', child: SizedBox()),
        ),
      );
      final element = _firstElementOf<WDiv>(tester);

      final emitted = windClassNameEnricher(element, RefRegistry.instance);
      expect(emitted, contains('ringWidth: '));
    });
  });

  // ---------------------------------------------------------------------------
  // Effects fields
  // ---------------------------------------------------------------------------

  group('Effects fields emission', () {
    testWidgets('emits opacity when opacity-50 is applied', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const WDiv(className: 'opacity-50', child: SizedBox()),
        ),
      );
      final element = _firstElementOf<WDiv>(tester);

      final emitted = windClassNameEnricher(element, RefRegistry.instance);
      expect(emitted, contains('opacity: '));
    });

    testWidgets('emits transitionDuration as milliseconds suffix', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const WDiv(className: 'duration-300', child: SizedBox()),
        ),
      );
      final element = _firstElementOf<WDiv>(tester);

      final emitted = windClassNameEnricher(element, RefRegistry.instance);
      expect(emitted, contains('transitionDuration: 300ms'));
    });

    testWidgets('emits boxShadow list when shadow-md is applied', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const WDiv(className: 'shadow-md', child: SizedBox()),
        ),
      );
      final element = _firstElementOf<WDiv>(tester);

      final emitted = windClassNameEnricher(element, RefRegistry.instance);
      expect(emitted, contains('boxShadow: '));
    });
  });

  // ---------------------------------------------------------------------------
  // Position fields
  // ---------------------------------------------------------------------------

  group('Position fields emission', () {
    testWidgets('emits positionType when absolute is applied', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const WDiv(className: 'absolute', child: SizedBox()),
        ),
      );
      final element = _firstElementOf<WDiv>(tester);

      final emitted = windClassNameEnricher(element, RefRegistry.instance);
      expect(emitted, contains('positionType: '));
    });

    testWidgets(
      'emits positionTop/positionLeft when top-4/left-2 are applied',
      (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDiv(
              className: 'absolute top-4 left-2',
              child: SizedBox(),
            ),
          ),
        );
        final element = _firstElementOf<WDiv>(tester);

        final emitted = windClassNameEnricher(element, RefRegistry.instance);
        expect(emitted, contains('positionTop: '));
        expect(emitted, contains('positionLeft: '));
      },
    );
  });

  // ---------------------------------------------------------------------------
  // Animation field
  // ---------------------------------------------------------------------------

  group('Animation field emission', () {
    testWidgets('emits animationType when animate-spin is applied', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const WDiv(className: 'animate-spin', child: SizedBox()),
        ),
      );
      final element = _firstElementOf<WDiv>(tester);

      final emitted = windClassNameEnricher(element, RefRegistry.instance);
      expect(emitted, contains('animationType: spin'));
    });
  });

  // ---------------------------------------------------------------------------
  // Overflow fields
  // ---------------------------------------------------------------------------

  group('Overflow fields emission', () {
    testWidgets('emits overflow when overflow-hidden is applied', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const WDiv(className: 'overflow-hidden', child: SizedBox()),
        ),
      );
      final element = _firstElementOf<WDiv>(tester);

      final emitted = windClassNameEnricher(element, RefRegistry.instance);
      expect(emitted, contains('overflow: hidden'));
    });
  });

  // ---------------------------------------------------------------------------
  // Null/default skip rules
  // ---------------------------------------------------------------------------

  group('Null and default values skip emission', () {
    testWidgets('omits width / height / padding lines when not applied', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const WDiv(className: 'bg-blue-500', child: SizedBox()),
        ),
      );
      final element = _firstElementOf<WDiv>(tester);

      final emitted = windClassNameEnricher(element, RefRegistry.instance);
      expect(emitted, isNotNull);
      // Nullable fields not in the className → no `key: null` lines.
      expect(emitted, isNot(contains('width:')));
      expect(emitted, isNot(contains('height:')));
      expect(emitted, isNot(contains('padding:')));
      expect(emitted, isNot(contains('margin:')));
      expect(emitted, isNot(contains('fontSize:')));
      expect(emitted, isNot(contains('opacity:')));
      expect(emitted, isNot(contains('positionType:')));
      expect(emitted, isNot(contains('animationType:')));
    });

    testWidgets('omits flex-related lines when className has no flex tokens', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const WDiv(className: 'bg-red-500', child: SizedBox()),
        ),
      );
      final element = _firstElementOf<WDiv>(tester);

      final emitted = windClassNameEnricher(element, RefRegistry.instance);
      // displayType defaults to `block` (the identity default) → no emit.
      expect(emitted, isNot(contains('displayType:')));
      expect(emitted, isNot(contains('flexDirection:')));
      expect(emitted, isNot(contains('mainAxisAlignment:')));
      expect(emitted, isNot(contains('gapX:')));
      expect(emitted, isNot(contains('gapY:')));
      expect(emitted, isNot(contains('flex:')));
    });
  });

  // ---------------------------------------------------------------------------
  // Truncation: value >60 chars truncated with "…"
  // ---------------------------------------------------------------------------

  group('Value truncation', () {
    testWidgets('caps individual emitted values at 60 chars with "…" suffix', (
      tester,
    ) async {
      // shadow-2xl produces a long boxShadow `[...]` toString — easily >60
      // chars when serialised. Verify the value side of the line is bounded.
      await tester.pumpWidget(
        wrapWithTheme(
          const WDiv(className: 'shadow-2xl', child: SizedBox()),
        ),
      );
      final element = _firstElementOf<WDiv>(tester);

      final emitted = windClassNameEnricher(element, RefRegistry.instance);
      expect(emitted, isNotNull);

      // For each YAML line, the value portion (right of `key: `) must be
      // ≤60 chars (or truncated with `…`). Inspect every line.
      final lines = emitted!.split('\n').where((l) => l.contains(': '));
      for (final line in lines) {
        final idx = line.indexOf(': ');
        final value = line.substring(idx + 2);
        expect(
          value.length,
          lessThanOrEqualTo(61), // 60 chars + the optional `…`
          reason: 'Line exceeds 60-char value cap: "$line"',
        );
      }
    });
  });

  // ---------------------------------------------------------------------------
  // Provenance toggle (default OFF + opt-in ON + revert)
  // ---------------------------------------------------------------------------

  group('Provenance toggle', () {
    testWidgets('provenance off (default): no resolvedVia line emitted', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const WDiv(
            className: 'bg-blue-500 md:bg-red-500 hover:bg-green-500',
            child: SizedBox(),
          ),
          size: const Size(1280, 800),
        ),
      );
      final element = _firstElementOf<WDiv>(tester);

      final emitted = windClassNameEnricher(element, RefRegistry.instance);
      expect(emitted, isNotNull);
      expect(emitted, isNot(contains('resolvedVia:')));
    });

    testWidgets(
      'provenance on: enableProvenance(true) → subsequent emits include '
      'resolvedVia line',
      (tester) async {
        WindDuskIntegration.enableProvenance(true);

        await tester.pumpWidget(
          wrapWithTheme(
            const WDiv(
              className: 'bg-blue-500',
              child: SizedBox(),
            ),
          ),
        );
        final element = _firstElementOf<WDiv>(tester);

        final emitted = windClassNameEnricher(element, RefRegistry.instance);
        expect(emitted, isNotNull);
        expect(emitted, contains('resolvedVia:'));
        expect(emitted, contains('bg-blue-500='));
      },
    );

    testWidgets('provenance off again: enableProvenance(false) reverts', (
      tester,
    ) async {
      WindDuskIntegration.enableProvenance(true);
      WindDuskIntegration.enableProvenance(false);

      await tester.pumpWidget(
        wrapWithTheme(
          const WDiv(className: 'bg-blue-500', child: SizedBox()),
        ),
      );
      final element = _firstElementOf<WDiv>(tester);

      final emitted = windClassNameEnricher(element, RefRegistry.instance);
      expect(emitted, isNotNull);
      expect(emitted, isNot(contains('resolvedVia:')));
    });
  });

  // ---------------------------------------------------------------------------
  // Element non-retention (pump 2 different trees, ensure fresh read)
  // ---------------------------------------------------------------------------

  group('Element non-retention', () {
    testWidgets('does not retain Element references between pumps', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const WDiv(className: 'bg-red-500', child: SizedBox()),
        ),
      );
      final firstElement = _firstElementOf<WDiv>(tester);
      final firstEmit =
          windClassNameEnricher(firstElement, RefRegistry.instance);
      expect(firstEmit, contains('bgColor'));

      // Re-pump a fresh tree with a different W widget.
      await tester.pumpWidget(
        wrapWithTheme(
          const WText('hi', className: 'text-green-500'),
        ),
      );
      final secondElement = _firstElementOf<WText>(tester);
      final secondEmit =
          windClassNameEnricher(secondElement, RefRegistry.instance);

      expect(secondEmit, isNotNull);
      expect(secondEmit, contains('textColor'));
      // No leakage from the first element: bgColor was set in tree 1 only.
      expect(secondEmit, isNot(contains('bgColor')));
    });
  });
}
