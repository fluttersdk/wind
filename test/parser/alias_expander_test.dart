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

      expect(result, contains('flex flex-row items-center'));
    });

    test('terminates on a self-cycle without hanging', () {
      // A self-referential alias must not loop; the offending token is left
      // unexpanded once it is detected as already visited.
      expect(expandAliases('a', const {'a': 'a'}), 'a');
    });

    test('terminates on a mutual cycle without hanging', () {
      // a -> b -> a forms a loop; resolution stops at the repeated token.
      final result = expandAliases('a', const {'a': 'b', 'b': 'a'});

      expect(result.split(' '), isNotEmpty);
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

      expect(warnings, isNotEmpty);
    });
  });
}
