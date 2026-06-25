import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

void main() {
  group('WindRecipe', () {
    test('returns base when no variants selected and no defaults', () {
      final recipe = WindRecipe(base: 'inline-flex rounded-full px-2 py-1');

      expect(recipe(), 'inline-flex rounded-full px-2 py-1');
    });

    test('appends a selected variant class after the base in definition order',
        () {
      final recipe = WindRecipe(
        base: 'rounded',
        variants: {
          'tone': {
            'primary': 'bg-blue-500 text-white',
            'ghost': 'bg-transparent text-blue-500',
          },
        },
      );

      expect(
        recipe(variants: {'tone': 'primary'}),
        'rounded bg-blue-500 text-white',
      );
    });

    test('joins multiple variant axes in the variants-map definition order',
        () {
      final recipe = WindRecipe(
        base: 'btn',
        variants: {
          'intent': {
            'primary': 'bg-blue-500',
            'secondary': 'bg-gray-200',
          },
          'size': {
            'sm': 'px-2 py-1',
            'lg': 'px-4 py-2',
          },
        },
      );

      // 'intent' is declared before 'size', so its classes emit first
      // regardless of the selection map's iteration order.
      expect(
        recipe(variants: {'size': 'lg', 'intent': 'primary'}),
        'btn bg-blue-500 px-4 py-2',
      );
    });

    test('falls back to defaultVariants when an axis is not selected', () {
      final recipe = WindRecipe(
        base: 'btn',
        variants: {
          'intent': {
            'primary': 'bg-blue-500',
            'secondary': 'bg-gray-200',
          },
        },
        defaultVariants: {'intent': 'primary'},
      );

      expect(recipe(), 'btn bg-blue-500');
    });

    test('an explicit selection overrides the default for the same axis', () {
      final recipe = WindRecipe(
        base: 'btn',
        variants: {
          'intent': {
            'primary': 'bg-blue-500',
            'secondary': 'bg-gray-200',
          },
        },
        defaultVariants: {'intent': 'primary'},
      );

      expect(recipe(variants: {'intent': 'secondary'}), 'btn bg-gray-200');
    });

    test('a null selection clears a default variant for that axis', () {
      final recipe = WindRecipe(
        base: 'btn',
        variants: {
          'intent': {
            'primary': 'bg-blue-500',
          },
        },
        defaultVariants: {'intent': 'primary'},
      );

      expect(recipe(variants: {'intent': null}), 'btn');
    });

    test('matches a compound variant only when ALL conditions hold (AND)', () {
      final recipe = WindRecipe(
        base: 'btn',
        variants: {
          'intent': {'primary': 'bg-blue-500'},
          'size': {'lg': 'px-4'},
        },
        compoundVariants: [
          WindCompoundVariant(
            conditions: {'intent': 'primary', 'size': 'lg'},
            className: 'shadow-lg',
          ),
        ],
      );

      expect(
        recipe(variants: {'intent': 'primary', 'size': 'lg'}),
        'btn bg-blue-500 px-4 shadow-lg',
      );
      // size != lg, so the compound must NOT match.
      expect(
        recipe(variants: {'intent': 'primary', 'size': 'sm'})
            .contains('shadow-lg'),
        isFalse,
      );
    });

    test('matches a compound variant when the value is in an OR array', () {
      final recipe = WindRecipe(
        base: 'btn',
        variants: {
          'intent': {
            'primary': 'bg-blue-500',
            'destructive': 'bg-red-500',
          },
        },
        compoundVariants: [
          WindCompoundVariant(
            conditions: {
              'intent': ['primary', 'destructive'],
            },
            className: 'text-white',
          ),
        ],
      );

      expect(
        recipe(variants: {'intent': 'primary'}),
        'btn bg-blue-500 text-white',
      );
      expect(
        recipe(variants: {'intent': 'destructive'}),
        'btn bg-red-500 text-white',
      );
    });

    test('emits matched compound variants in array order, after the variants',
        () {
      final recipe = WindRecipe(
        base: 'btn',
        variants: {
          'intent': {'primary': 'bg-blue-500'},
        },
        compoundVariants: [
          WindCompoundVariant(
            conditions: {'intent': 'primary'},
            className: 'first-compound',
          ),
          WindCompoundVariant(
            conditions: {'intent': 'primary'},
            className: 'second-compound',
          ),
        ],
      );

      expect(
        recipe(variants: {'intent': 'primary'}),
        'btn bg-blue-500 first-compound second-compound',
      );
    });

    test('appends the caller extraClass last, in strict order', () {
      final recipe = WindRecipe(
        base: 'btn',
        variants: {
          'intent': {'primary': 'bg-blue-500'},
        },
      );

      expect(
        recipe(variants: {'intent': 'primary'}, className: 'mt-4'),
        'btn bg-blue-500 mt-4',
      );
    });

    test(
      'preserves a caller hover: token after a base hover: token without '
      'dedupe (order-preservation proof)',
      () {
        // Both tokens survive to parse-time; wind per-family last-wins lets the
        // trailing caller hover:bg-blue-700 override the base hover:bg-blue-500.
        final recipe = WindRecipe(base: 'px-4 hover:bg-blue-500');

        final result = recipe(className: 'hover:bg-blue-700');

        expect(result, 'px-4 hover:bg-blue-500 hover:bg-blue-700');
        // Never deduped: both occurrences are present.
        expect(
          'hover:bg-blue-500'.allMatches(result).length +
              'hover:bg-blue-700'.allMatches(result).length,
          2,
        );
      },
    );

    test('never sorts or dedupes repeated tokens', () {
      final recipe = WindRecipe(base: 'p-2 p-4');

      // p-2 p-4 must survive verbatim (last-wins resolved at parse-time).
      expect(recipe(className: 'p-2'), 'p-2 p-4 p-2');
    });

    test('throws when a selected axis is unknown', () {
      final recipe = WindRecipe(
        base: 'btn',
        variants: {
          'intent': {'primary': 'bg-blue-500'},
        },
      );

      expect(
        () => recipe(variants: {'unknown': 'x'}),
        throwsArgumentError,
      );
    });

    group('shorthand/longhand debug lint', () {
      test(
        'warns when base and a resolved variant touch a shorthand+longhand '
        'pair of the same family',
        () {
          final recipe = WindRecipe(
            base: 'p-4',
            variants: {
              'pad': {'tight': 'px-2'},
            },
          );

          final logs = <String>[];
          final original = debugPrint;
          debugPrint = (message, {wrapWidth}) => logs.add(message ?? '');
          try {
            recipe(variants: {'pad': 'tight'});
          } finally {
            debugPrint = original;
          }

          expect(
            logs.any((l) => l.contains('p-') && l.contains('px-')),
            isTrue,
            reason: 'expected a shorthand/longhand override warning',
          );
        },
      );

      test('does not warn when base and variant touch the same granularity',
          () {
        final recipe = WindRecipe(
          base: 'px-4',
          variants: {
            'pad': {'tight': 'px-2'},
          },
        );

        final logs = <String>[];
        final original = debugPrint;
        debugPrint = (message, {wrapWidth}) => logs.add(message ?? '');
        try {
          recipe(variants: {'pad': 'tight'});
        } finally {
          debugPrint = original;
        }

        expect(logs, isEmpty);
      });

      test(
        'two DISTINCT offending recipes of the same family each warn once',
        () {
          // Both recipes mix m-* shorthand with my-* longhand, but with
          // different tokens. The dedupe key is the offending token set, so the
          // first warning must not silence the second distinct offense.
          final recipeA = WindRecipe(base: 'm-4 my-2');
          final recipeB = WindRecipe(base: 'm-8 my-6');

          final logs = <String>[];
          final original = debugPrint;
          debugPrint = (message, {wrapWidth}) => logs.add(message ?? '');
          try {
            recipeA();
            recipeB();
          } finally {
            debugPrint = original;
          }

          final warnings =
              logs.where((l) => l.contains('m-') && l.contains('my-')).toList();
          expect(
            warnings.length,
            2,
            reason: 'each distinct offending mix must warn once',
          );
        },
      );

      test('the SAME offending recipe warns once across repeated calls', () {
        // Idempotency: a repeated identical offense logs once per process, so a
        // re-rendered recipe does not spam the console.
        final recipe = WindRecipe(base: 'inset-4 top-2');

        final logs = <String>[];
        final original = debugPrint;
        debugPrint = (message, {wrapWidth}) => logs.add(message ?? '');
        try {
          recipe();
          recipe();
          recipe();
        } finally {
          debugPrint = original;
        }

        final warnings = logs
            .where((l) => l.contains('inset-') && l.contains('top-'))
            .toList();
        expect(warnings.length, 1);
      });
    });
  });

  group('WindSlotRecipe', () {
    test('returns a base className per slot when no variants selected', () {
      final recipe = WindSlotRecipe(
        slots: {
          'root': 'flex flex-col rounded',
          'header': 'font-bold',
          'body': 'p-4',
        },
      );

      final result = recipe();

      expect(result['root'], 'flex flex-col rounded');
      expect(result['header'], 'font-bold');
      expect(result['body'], 'p-4');
    });

    test('appends per-slot variant classes after each slot base', () {
      final recipe = WindSlotRecipe(
        slots: {
          'root': 'flex',
          'item': 'block',
        },
        variants: {
          'active': {
            'true': {
              'root': 'bg-blue-50',
              'item': 'text-blue-600',
            },
          },
        },
      );

      final result = recipe(variants: {'active': 'true'});

      expect(result['root'], 'flex bg-blue-50');
      expect(result['item'], 'block text-blue-600');
    });

    test('applies defaultVariants and null-clear per slot', () {
      final recipe = WindSlotRecipe(
        slots: {'root': 'flex'},
        variants: {
          'tone': {
            'primary': {'root': 'bg-blue-500'},
          },
        },
        defaultVariants: {'tone': 'primary'},
      );

      expect(recipe()['root'], 'flex bg-blue-500');
      expect(recipe(variants: {'tone': null})['root'], 'flex');
    });

    test('applies matched compound variants per slot in array order', () {
      final recipe = WindSlotRecipe(
        slots: {'root': 'flex', 'label': 'text-sm'},
        variants: {
          'tone': {
            'primary': {'root': 'bg-blue-500'},
          },
          'size': {
            'lg': {'root': 'p-4'},
          },
        },
        compoundVariants: [
          WindSlotCompoundVariant(
            conditions: {'tone': 'primary', 'size': 'lg'},
            classNames: {'root': 'shadow-lg', 'label': 'font-bold'},
          ),
        ],
      );

      final result = recipe(variants: {'tone': 'primary', 'size': 'lg'});

      expect(result['root'], 'flex bg-blue-500 p-4 shadow-lg');
      expect(result['label'], 'text-sm font-bold');
    });

    test('appends caller per-slot extraClasses last', () {
      final recipe = WindSlotRecipe(
        slots: {'root': 'flex'},
      );

      final result = recipe(classNames: {'root': 'mt-4'});

      expect(result['root'], 'flex mt-4');
    });
  });
}
