import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/src/parser/alias_expander.dart';

void main() {
  group('expandAliases', () {
    test('returns the input unchanged when the alias map is empty', () {
      expect(expandAliases('flex p-4', const {}), 'flex p-4');
    });

    test('expands a single alias into its tokens', () {
      expect(
        expandAliases('row', const {'row': 'flex flex-row'}),
        'flex flex-row',
      );
    });

    test('expands recursively when an alias value references another alias',
        () {
      final result = expandAliases(
        'row-c',
        const {
          'row': 'flex flex-row',
          'row-c': 'row items-center',
        },
      );

      expect(result, 'flex flex-row items-center');
    });

    test('terminates on a self-cycle without hanging', () {
      // A self-referential alias must not loop; the offending token is left
      // unexpanded once it is detected as already visited.
      expect(expandAliases('a', const {'a': 'a'}), 'a');
    });

    test('terminates on a mutual cycle without hanging', () {
      // a -> b -> a forms a loop; 'a' expands to 'b', 'b' expands back to 'a'
      // which is already on the chain, so the repeated 'a' is left verbatim.
      expect(expandAliases('a', const {'a': 'b', 'b': 'a'}), 'a');
    });

    test('passes an unknown token through unchanged', () {
      expect(expandAliases('foo', const {'row': 'flex flex-row'}), 'foo');
    });

    test('does not match a prefixed token against a bare alias key', () {
      // Only an unprefixed whole token may match an alias key; `md:row` is not
      // equal to the key `row`, so it passes through verbatim.
      expect(
        expandAliases('md:row', const {'row': 'flex flex-row'}),
        'md:row',
      );
    });

    test('never expands a prefixed token even when a prefixed key exists', () {
      // A prefixed token is ineligible regardless of the map: a `md:row` key is
      // not bare, so the bare-token contract leaves the token unexpanded.
      expect(
        expandAliases('md:row', const {'md:row': 'flex flex-row'}),
        'md:row',
      );
    });

    test('passes a prefixed token inside an alias value through as-is', () {
      expect(
        expandAliases('card', const {'card': 'dark:bg-gray-900'}),
        'dark:bg-gray-900',
      );
    });

    test('preserves duplicate tokens and their order (no dedup)', () {
      expect(
        expandAliases('p-2 p-4 p-2', const {}),
        'p-2 p-4 p-2',
      );
    });

    test('preserves order when expanding alongside non-alias tokens', () {
      expect(
        expandAliases('p-4 row m-2', const {'row': 'flex flex-row'}),
        'p-4 flex flex-row m-2',
      );
    });

    test('invokes onWarn when a cycle is detected', () {
      final warnings = <String>[];

      expandAliases(
        'a',
        const {'a': 'a'},
        onWarn: warnings.add,
      );

      expect(warnings, hasLength(1));
      expect(warnings.single, contains('cycle'));
    });

    test('stops at the depth cap on an acyclic chain longer than the cap', () {
      // A non-cyclic chain (every link is a distinct key, so the per-chain
      // visited-set never trips) longer than the cap exercises the depth
      // backstop: resolution stops, leaves the deep token unexpanded, and warns.
      // The chain length (12) must stay greater than _maxExpansionDepth (8) for
      // this test to keep hitting the cap branch; widen it if the cap is raised.
      const chain = {
        'a1': 'a2',
        'a2': 'a3',
        'a3': 'a4',
        'a4': 'a5',
        'a5': 'a6',
        'a6': 'a7',
        'a7': 'a8',
        'a8': 'a9',
        'a9': 'a10',
        'a10': 'a11',
        'a11': 'a12',
        'a12': 'leaf',
      };
      final warnings = <String>[];

      final result = expandAliases('a1', chain, onWarn: warnings.add);

      // The cap trips before the chain resolves to its 'leaf' tail; the
      // offending token is kept verbatim rather than expanded further.
      expect(result, isNot(contains('leaf')));
      expect(result.split(' '), hasLength(1));
      expect(warnings, isNotEmpty);
      expect(warnings.any((w) => w.contains('expansion cap')), isTrue);
    });

    test('bounds an acyclic fan-out map by the output-token budget', () {
      // The depth cap and cycle guard bound chain length, not branching width.
      // This map is acyclic (distinct keys) and each value fans out to 4 tokens,
      // so unbounded it would emit thousands of tokens. The output budget must
      // cap it and warn. The literal 256 mirrors the private _maxOutputTokens;
      // keep them in sync.
      const fanOut = {
        'a': 'b b b b',
        'b': 'c c c c',
        'c': 'd d d d',
        'd': 'e e e e',
        'e': 'f f f f',
        'f': 'leaf',
      };
      final warnings = <String>[];

      final result = expandAliases('a', fanOut, onWarn: warnings.add);

      // The budget caps the output (proving termination: an unbounded fan-out
      // would emit thousands of tokens) and warns. No wall-clock assertion: the
      // bounded count is the deterministic termination signal, not elapsed time.
      final tokens = result.split(' ').where((t) => t.isNotEmpty);
      expect(tokens.length, lessThanOrEqualTo(256));
      expect(warnings.any((w) => w.contains('budget')), isTrue);
    });
  });
}
