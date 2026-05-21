import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';
import 'package:wind_diagnostics_contracts/wind_diagnostics_contracts.dart';

/// Tests for the Wind alpha-10 debug resolver.
///
/// The resolver's contract (per `WindDebugResolver` abstract class):
///   `Map<String, Object?> resolve(Element)`
///
/// - Returns `const {}` on miss (non-W widget OR empty/null className).
/// - Returns a map with the 6 core fields for valid W-widgets.
/// - Never retains the Element across calls.
/// - Emits only the 6 core fields: className, breakpoint, brightness,
///   platform, states, bgColor (conditional), textColor (conditional).
/// - All 50+ optional alpha-9 fields (displayType, flexDirection, padding,
///   margin, fontSize, ...) are intentionally absent in alpha-10.

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
    Wind.resetForTesting();
    WindDebugRegistry.resetForTesting();
    // Cache persists across tests; clearing is mandatory per
    // wind/.claude/rules/tests.md.
    WindParser.clearCache();
  });

  // ---------------------------------------------------------------------------
  // W-widget guard: only W-prefixed widgets get resolved
  // ---------------------------------------------------------------------------

  group('W-widget guard', () {
    testWidgets('returns const {} for non-W widgets (plain SizedBox)', (
      tester,
    ) async {
      await tester.pumpWidget(wrapWithTheme(const SizedBox(width: 10)));
      final element = _firstElementOf<SizedBox>(tester);

      final data = const WindDebugResolverImpl().resolve(element);
      expect(data, equals(const <String, Object?>{}));
    });

    testWidgets('returns const {} for WDiv with null className', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(const WDiv(child: SizedBox(width: 10))),
      );
      final element = _firstElementOf<WDiv>(tester);

      final data = const WindDebugResolverImpl().resolve(element);
      expect(data, equals(const <String, Object?>{}));
    });

    testWidgets('returns const {} for WDiv with empty className', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(const WDiv(className: '', child: SizedBox(width: 10))),
      );
      final element = _firstElementOf<WDiv>(tester);

      final data = const WindDebugResolverImpl().resolve(element);
      expect(data, equals(const <String, Object?>{}));
    });

    testWidgets(
      'returns a non-empty map for WButton (one of the 17 supported widgets)',
      (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(WButton(
            className: 'bg-blue-500 text-white',
            onTap: () {},
            child: const Text('Click'),
          )),
        );
        final element = _firstElementOf<WButton>(tester);

        final data = const WindDebugResolverImpl().resolve(element);
        expect(data, isNotEmpty);
        expect(data.containsKey('className'), isTrue);
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

      final data = const WindDebugResolverImpl().resolve(element);
      expect(data, isNotEmpty);
      expect(data.containsKey('breakpoint'), isTrue);
      expect(data['breakpoint'], isA<String>());
    });

    testWidgets('emits brightness: light by default', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const WDiv(className: 'p-4', child: SizedBox())),
      );
      final element = _firstElementOf<WDiv>(tester);

      final data = const WindDebugResolverImpl().resolve(element);
      expect(data['brightness'], equals('light'));
    });

    testWidgets('emits platform field', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const WDiv(className: 'p-4', child: SizedBox())),
      );
      final element = _firstElementOf<WDiv>(tester);

      final data = const WindDebugResolverImpl().resolve(element);
      expect(data.containsKey('platform'), isTrue);
      expect(data['platform'], isA<String>());
    });

    testWidgets('emits states as a List', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const WDiv(className: 'p-4', child: SizedBox())),
      );
      final element = _firstElementOf<WDiv>(tester);

      final data = const WindDebugResolverImpl().resolve(element);
      expect(data.containsKey('states'), isTrue);
      expect(data['states'], isA<List>());
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

      final data = const WindDebugResolverImpl().resolve(element);
      expect(data, isNotEmpty);
      expect(data.containsKey('bgColor'), isTrue);
      expect(data['bgColor'], isA<String>());
      expect(data['bgColor'] as String, startsWith('#'));
    });

    testWidgets(
      'emits textColor as a #RRGGBB hex when text-* class resolves',
      (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WText('hello', className: 'text-red-500'),
          ),
        );
        final element = _firstElementOf<WText>(tester);

        final data = const WindDebugResolverImpl().resolve(element);
        expect(data, isNotEmpty);
        expect(data.containsKey('textColor'), isTrue);
        expect(data['textColor'], isA<String>());
        expect(data['textColor'] as String, startsWith('#'));
      },
    );
  });

  // ---------------------------------------------------------------------------
  // Layout fields (alpha-10: only 6 core fields emitted; layout fields absent)
  // ---------------------------------------------------------------------------

  group('Layout fields emission', () {
    testWidgets(
      'does not emit displayType (alpha-10 drops extra layout fields)',
      (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WDiv(className: 'flex', child: SizedBox())),
        );
        final element = _firstElementOf<WDiv>(tester);

        final data = const WindDebugResolverImpl().resolve(element);
        expect(data, isNotEmpty);
        expect(data.containsKey('displayType'), isFalse);
      },
    );

    testWidgets(
      'does not emit flexDirection (alpha-10 drops extra layout fields)',
      (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDiv(className: 'flex flex-col', child: SizedBox()),
          ),
        );
        final element = _firstElementOf<WDiv>(tester);

        final data = const WindDebugResolverImpl().resolve(element);
        expect(data, isNotEmpty);
        expect(data.containsKey('flexDirection'), isFalse);
      },
    );

    testWidgets(
      'does not emit mainAxisAlignment (alpha-10 drops extra layout fields)',
      (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDiv(className: 'flex justify-center', child: SizedBox()),
          ),
        );
        final element = _firstElementOf<WDiv>(tester);

        final data = const WindDebugResolverImpl().resolve(element);
        expect(data, isNotEmpty);
        expect(data.containsKey('mainAxisAlignment'), isFalse);
      },
    );

    testWidgets(
      'does not emit gapX / gapY (alpha-10 drops extra layout fields)',
      (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDiv(className: 'flex gap-4', child: SizedBox()),
          ),
        );
        final element = _firstElementOf<WDiv>(tester);

        final data = const WindDebugResolverImpl().resolve(element);
        expect(data, isNotEmpty);
        expect(data.containsKey('gapX'), isFalse);
        expect(data.containsKey('gapY'), isFalse);
      },
    );

    testWidgets(
      'does not emit flex int (alpha-10 drops extra layout fields)',
      (tester) async {
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

        final data = const WindDebugResolverImpl().resolve(element);
        expect(data, isNotEmpty);
        expect(data.containsKey('flex'), isFalse);
      },
    );
  });

  // ---------------------------------------------------------------------------
  // Sizing fields (alpha-10: sizing fields absent from 6-core output)
  // ---------------------------------------------------------------------------

  group('Sizing fields emission', () {
    testWidgets(
      'does not emit width (alpha-10 drops extra sizing fields)',
      (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDiv(className: 'w-[100px]', child: SizedBox()),
          ),
        );
        final element = _firstElementOf<WDiv>(tester);

        final data = const WindDebugResolverImpl().resolve(element);
        expect(data, isNotEmpty);
        expect(data.containsKey('width'), isFalse);
      },
    );

    testWidgets(
      'does not emit height (alpha-10 drops extra sizing fields)',
      (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDiv(className: 'h-[200px]', child: SizedBox()),
          ),
        );
        final element = _firstElementOf<WDiv>(tester);

        final data = const WindDebugResolverImpl().resolve(element);
        expect(data, isNotEmpty);
        expect(data.containsKey('height'), isFalse);
      },
    );
  });

  // ---------------------------------------------------------------------------
  // Spacing fields (alpha-10: spacing fields absent from 6-core output)
  // ---------------------------------------------------------------------------

  group('Spacing fields emission', () {
    testWidgets(
      'does not emit padding (alpha-10 drops extra spacing fields)',
      (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WDiv(className: 'p-4', child: SizedBox())),
        );
        final element = _firstElementOf<WDiv>(tester);

        final data = const WindDebugResolverImpl().resolve(element);
        expect(data, isNotEmpty);
        expect(data.containsKey('padding'), isFalse);
      },
    );

    testWidgets(
      'does not emit margin (alpha-10 drops extra spacing fields)',
      (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WDiv(className: 'm-2', child: SizedBox())),
        );
        final element = _firstElementOf<WDiv>(tester);

        final data = const WindDebugResolverImpl().resolve(element);
        expect(data, isNotEmpty);
        expect(data.containsKey('margin'), isFalse);
      },
    );
  });

  // ---------------------------------------------------------------------------
  // Typography fields (alpha-10: typography fields absent from 6-core output)
  // ---------------------------------------------------------------------------

  group('Typography fields emission', () {
    testWidgets(
      'does not emit fontSize (alpha-10 drops extra typography fields)',
      (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WText('hi', className: 'text-lg')),
        );
        final element = _firstElementOf<WText>(tester);

        final data = const WindDebugResolverImpl().resolve(element);
        expect(data, isNotEmpty);
        expect(data.containsKey('fontSize'), isFalse);
      },
    );

    testWidgets(
      'does not emit fontWeight (alpha-10 drops extra typography fields)',
      (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WText('hi', className: 'font-bold')),
        );
        final element = _firstElementOf<WText>(tester);

        final data = const WindDebugResolverImpl().resolve(element);
        expect(data, isNotEmpty);
        expect(data.containsKey('fontWeight'), isFalse);
      },
    );

    testWidgets(
      'does not emit textAlign (alpha-10 drops extra typography fields)',
      (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WText('hi', className: 'text-center')),
        );
        final element = _firstElementOf<WText>(tester);

        final data = const WindDebugResolverImpl().resolve(element);
        expect(data, isNotEmpty);
        expect(data.containsKey('textAlign'), isFalse);
      },
    );

    testWidgets(
      'does not emit textOverflow (alpha-10 drops extra typography fields)',
      (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WText('hi', className: 'truncate')),
        );
        final element = _firstElementOf<WText>(tester);

        final data = const WindDebugResolverImpl().resolve(element);
        expect(data, isNotEmpty);
        expect(data.containsKey('textOverflow'), isFalse);
      },
    );

    testWidgets(
      'does not emit textDecoration (alpha-10 drops extra typography fields)',
      (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(const WText('hi', className: 'underline')),
        );
        final element = _firstElementOf<WText>(tester);

        final data = const WindDebugResolverImpl().resolve(element);
        expect(data, isNotEmpty);
        expect(data.containsKey('textDecoration'), isFalse);
      },
    );
  });

  // ---------------------------------------------------------------------------
  // Border + Ring fields (alpha-10: ring fields absent from 6-core output)
  // ---------------------------------------------------------------------------

  group('Border + Ring fields emission', () {
    testWidgets(
      'does not emit ringColor (alpha-10 drops extra ring fields)',
      (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDiv(className: 'ring-2 ring-blue-500', child: SizedBox()),
          ),
        );
        final element = _firstElementOf<WDiv>(tester);

        final data = const WindDebugResolverImpl().resolve(element);
        expect(data, isNotEmpty);
        expect(data.containsKey('ringColor'), isFalse);
      },
    );

    testWidgets(
      'does not emit ringWidth (alpha-10 drops extra ring fields)',
      (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDiv(className: 'ring-4', child: SizedBox()),
          ),
        );
        final element = _firstElementOf<WDiv>(tester);

        final data = const WindDebugResolverImpl().resolve(element);
        expect(data, isNotEmpty);
        expect(data.containsKey('ringWidth'), isFalse);
      },
    );
  });

  // ---------------------------------------------------------------------------
  // Effects fields (alpha-10: effects fields absent from 6-core output)
  // ---------------------------------------------------------------------------

  group('Effects fields emission', () {
    testWidgets(
      'does not emit opacity (alpha-10 drops extra effects fields)',
      (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDiv(className: 'opacity-50', child: SizedBox()),
          ),
        );
        final element = _firstElementOf<WDiv>(tester);

        final data = const WindDebugResolverImpl().resolve(element);
        expect(data, isNotEmpty);
        expect(data.containsKey('opacity'), isFalse);
      },
    );

    testWidgets(
      'does not emit transitionDuration (alpha-10 drops extra effects fields)',
      (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDiv(className: 'duration-300', child: SizedBox()),
          ),
        );
        final element = _firstElementOf<WDiv>(tester);

        final data = const WindDebugResolverImpl().resolve(element);
        expect(data, isNotEmpty);
        expect(data.containsKey('transitionDuration'), isFalse);
      },
    );

    testWidgets(
      'does not emit boxShadow (alpha-10 drops extra effects fields)',
      (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDiv(className: 'shadow-md', child: SizedBox()),
          ),
        );
        final element = _firstElementOf<WDiv>(tester);

        final data = const WindDebugResolverImpl().resolve(element);
        expect(data, isNotEmpty);
        expect(data.containsKey('boxShadow'), isFalse);
      },
    );
  });

  // ---------------------------------------------------------------------------
  // Position fields (alpha-10: position fields absent from 6-core output)
  // ---------------------------------------------------------------------------

  group('Position fields emission', () {
    testWidgets(
      'does not emit positionType (alpha-10 drops extra position fields)',
      (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDiv(className: 'absolute', child: SizedBox()),
          ),
        );
        final element = _firstElementOf<WDiv>(tester);

        final data = const WindDebugResolverImpl().resolve(element);
        expect(data, isNotEmpty);
        expect(data.containsKey('positionType'), isFalse);
      },
    );

    testWidgets(
      'does not emit positionTop/positionLeft (alpha-10 drops extra position fields)',
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

        final data = const WindDebugResolverImpl().resolve(element);
        expect(data, isNotEmpty);
        expect(data.containsKey('positionTop'), isFalse);
        expect(data.containsKey('positionLeft'), isFalse);
      },
    );
  });

  // ---------------------------------------------------------------------------
  // Animation field (alpha-10: animation fields absent from 6-core output)
  // ---------------------------------------------------------------------------

  group('Animation field emission', () {
    testWidgets(
      'does not emit animationType (alpha-10 drops extra animation fields)',
      (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDiv(className: 'animate-spin', child: SizedBox()),
          ),
        );
        final element = _firstElementOf<WDiv>(tester);

        final data = const WindDebugResolverImpl().resolve(element);
        expect(data, isNotEmpty);
        expect(data.containsKey('animationType'), isFalse);
      },
    );
  });

  // ---------------------------------------------------------------------------
  // Overflow fields (alpha-10: overflow fields absent from 6-core output)
  // ---------------------------------------------------------------------------

  group('Overflow fields emission', () {
    testWidgets(
      'does not emit overflow key (alpha-10 drops extra overflow fields)',
      (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDiv(className: 'overflow-hidden', child: SizedBox()),
          ),
        );
        final element = _firstElementOf<WDiv>(tester);

        final data = const WindDebugResolverImpl().resolve(element);
        expect(data, isNotEmpty);
        expect(data.containsKey('overflow'), isFalse);
      },
    );
  });

  // ---------------------------------------------------------------------------
  // Null and default skip rules (alpha-10: 6-core always present; extras absent)
  // ---------------------------------------------------------------------------

  group('Null and default values skip emission', () {
    testWidgets(
      'omits width/height/padding/margin/fontSize/opacity/positionType/animationType',
      (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDiv(className: 'bg-blue-500', child: SizedBox()),
          ),
        );
        final element = _firstElementOf<WDiv>(tester);

        final data = const WindDebugResolverImpl().resolve(element);
        expect(data, isNotEmpty);
        // Alpha-9 optional fields not in the 6-core contract: never emitted.
        expect(data.containsKey('width'), isFalse);
        expect(data.containsKey('height'), isFalse);
        expect(data.containsKey('padding'), isFalse);
        expect(data.containsKey('margin'), isFalse);
        expect(data.containsKey('fontSize'), isFalse);
        expect(data.containsKey('opacity'), isFalse);
        expect(data.containsKey('positionType'), isFalse);
        expect(data.containsKey('animationType'), isFalse);
      },
    );

    testWidgets(
      'omits flex-related keys when className has no flex tokens',
      (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDiv(className: 'bg-red-500', child: SizedBox()),
          ),
        );
        final element = _firstElementOf<WDiv>(tester);

        final data = const WindDebugResolverImpl().resolve(element);
        // Alpha-10 does not emit any layout keys regardless of className.
        expect(data.containsKey('displayType'), isFalse);
        expect(data.containsKey('flexDirection'), isFalse);
        expect(data.containsKey('mainAxisAlignment'), isFalse);
        expect(data.containsKey('gapX'), isFalse);
        expect(data.containsKey('gapY'), isFalse);
        expect(data.containsKey('flex'), isFalse);
      },
    );
  });

  // ---------------------------------------------------------------------------
  // Value content: Map values are raw (no truncation like alpha-9 YAML output)
  // ---------------------------------------------------------------------------

  group('Value content', () {
    testWidgets(
      'resolver returns valid map for shadow-2xl (no boxShadow key in alpha-10)',
      (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDiv(className: 'shadow-2xl', child: SizedBox()),
          ),
        );
        final element = _firstElementOf<WDiv>(tester);

        final data = const WindDebugResolverImpl().resolve(element);
        expect(data, isNotEmpty);
        // Alpha-10 emits 6 core fields; boxShadow is not one of them.
        expect(data.containsKey('boxShadow'), isFalse);
        // The 6 core fields must still be present.
        expect(data.containsKey('className'), isTrue);
        expect(data.containsKey('breakpoint'), isTrue);
        expect(data.containsKey('brightness'), isTrue);
        expect(data.containsKey('platform'), isTrue);
        expect(data.containsKey('states'), isTrue);
      },
    );
  });

  // ---------------------------------------------------------------------------
  // Provenance toggle (alpha-10: provenance feature removed entirely)
  // ---------------------------------------------------------------------------

  group('Provenance toggle', () {
    testWidgets(
      'provenance absent (alpha-10): no resolvedVia key emitted',
      (tester) async {
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

        final data = const WindDebugResolverImpl().resolve(element);
        expect(data, isNotEmpty);
        expect(data.containsKey('resolvedVia'), isFalse);
      },
    );

    testWidgets(
      'provenance absent (alpha-10): resolvedVia never emitted regardless of className',
      (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDiv(
              className: 'bg-blue-500',
              child: SizedBox(),
            ),
          ),
        );
        final element = _firstElementOf<WDiv>(tester);

        final data = const WindDebugResolverImpl().resolve(element);
        expect(data, isNotEmpty);
        expect(data.containsKey('resolvedVia'), isFalse);
      },
    );

    testWidgets(
      'provenance absent (alpha-10): resolver map never contains bg-blue-500= token',
      (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            const WDiv(className: 'bg-blue-500', child: SizedBox()),
          ),
        );
        final element = _firstElementOf<WDiv>(tester);

        final data = const WindDebugResolverImpl().resolve(element);
        expect(data, isNotEmpty);
        // No provenance entry; className is present but as the raw className string.
        expect(data['className'], equals('bg-blue-500'));
        expect(data.values.whereType<String>().any((v) => v.contains('=')),
            isFalse);
      },
    );
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
      final firstData = const WindDebugResolverImpl().resolve(firstElement);
      expect(firstData.containsKey('bgColor'), isTrue);

      // Re-pump a fresh tree with a different W widget.
      await tester.pumpWidget(
        wrapWithTheme(
          const WText('hi', className: 'text-green-500'),
        ),
      );
      final secondElement = _firstElementOf<WText>(tester);
      final secondData = const WindDebugResolverImpl().resolve(secondElement);

      expect(secondData, isNotEmpty);
      expect(secondData.containsKey('textColor'), isTrue);
      // No leakage from the first element: bgColor was set in tree 1 only.
      expect(secondData.containsKey('bgColor'), isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // Non-Wind widget contract: const {} for any element not starting with W
  // ---------------------------------------------------------------------------

  group('Non-Wind widget contract', () {
    testWidgets(
      'resolve returns const {} for Container (runtimeType does not start with W)',
      (tester) async {
        await tester.pumpWidget(wrapWithTheme(Container(width: 50)));
        final element = _firstElementOf<Container>(tester);

        final data = const WindDebugResolverImpl().resolve(element);
        expect(data, equals(const <String, Object?>{}));
      },
    );
  });
}
