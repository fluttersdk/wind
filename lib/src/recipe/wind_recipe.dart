import 'package:flutter/foundation.dart';

/// **A Single Compound-Variant Rule for [WindRecipe]**
///
/// A compound variant contributes [className] only when EVERY entry in
/// [conditions] is satisfied by the resolved variant selection. A condition
/// value may be a single `String` (exact match) or a `List<String>` (OR match,
/// satisfied when the resolved value is any member of the list).
///
/// ### Example Usage:
///
/// ```dart
/// WindCompoundVariant(
///   conditions: {'intent': ['primary', 'destructive']},
///   className: 'text-white',
/// )
/// ```
@immutable
final class WindCompoundVariant {
  /// The axis -> required-value(s) map. A value is a `String` (exact) or a
  /// `List<String>` (OR match).
  final Map<String, Object> conditions;

  /// The className appended when [conditions] all hold.
  final String className;

  /// Creates a compound-variant rule.
  const WindCompoundVariant({
    required this.conditions,
    required this.className,
  });
}

/// **A Single Compound-Variant Rule for [WindSlotRecipe]**
///
/// Like [WindCompoundVariant] but contributes a className per slot through
/// [classNames] (slot name -> className) when all [conditions] hold.
@immutable
final class WindSlotCompoundVariant {
  /// The axis -> required-value(s) map. A value is a `String` (exact) or a
  /// `List<String>` (OR match).
  final Map<String, Object> conditions;

  /// The per-slot className map appended when [conditions] all hold.
  final Map<String, String> classNames;

  /// Creates a slot compound-variant rule.
  const WindSlotCompoundVariant({
    required this.conditions,
    required this.classNames,
  });
}

/// **A Tailwind-Variants `tv()` Equivalent for Wind**
///
/// `WindRecipe` composes a single element's className from a [base], a set of
/// [variants] (one axis per key, each mapping a value to a className), optional
/// [compoundVariants] (multi-condition rules), and [defaultVariants] (the
/// selection applied when the caller does not pass an axis).
///
/// ### Resolution
///
/// Calling the recipe merges `{...defaultVariants, ...selected}`. A `null` in
/// the selection CLEARS the default for that axis (no class emitted), matching
/// `tv()`'s `undefined`-clears semantics. The result is joined in STRICT order:
///
/// ```text
/// base ++ variant-classes(definition order) ++ matched-compound(array order) ++ caller
/// ```
///
/// ### Why no dedupe / sort / twMerge
///
/// Wind's parser resolves conflicts per family with last-class-wins AT
/// PARSE-TIME (`wind_parser.dart` `findAndGroupClasses`). State-prefixed tokens
/// (`hover:`, `dark:`, `md:`) only collapse correctly when their emission order
/// is preserved verbatim, so the recipe NEVER applies `toSet()`, sort, or a
/// tailwind-merge style resolver. A trailing caller `hover:bg-blue-700` must
/// survive next to a base `hover:bg-blue-500` for the parser to pick the last.
///
/// ### Same-granularity-override contract
///
/// Because parser last-wins is per-family, a variant must override a base token
/// at the SAME granularity (override `px-*` with `px-*`, never mix `p-*` and
/// `px-*`): the parser would silently keep the shorthand. A debug-only lint
/// (stripped from release via `assert`) warns when a base and a resolved
/// variant touch a shorthand+longhand pair of the same family.
///
/// ### Example Usage:
///
/// ```dart
/// final button = WindRecipe(
///   base: 'inline-flex items-center rounded font-medium',
///   variants: {
///     'intent': {
///       'primary': 'bg-blue-500 text-white',
///       'ghost': 'bg-transparent text-blue-500',
///     },
///     'size': {'sm': 'px-2 py-1 text-sm', 'lg': 'px-4 py-2'},
///   },
///   compoundVariants: [
///     WindCompoundVariant(
///       conditions: {'intent': 'primary', 'size': 'lg'},
///       className: 'shadow-lg',
///     ),
///   ],
///   defaultVariants: {'intent': 'primary', 'size': 'sm'},
/// );
///
/// // Variant axis keys are plain strings; pass enum values as `.name`.
/// button(variants: {'intent': ButtonIntent.ghost.name});
/// ```
@immutable
final class WindRecipe {
  /// The always-applied base className.
  final String base;

  /// The variant axes: axis -> (value -> className). Iteration order of this
  /// map fixes the emission order of variant classes.
  final Map<String, Map<String, String>> variants;

  /// The compound-variant rules, evaluated in list order.
  final List<WindCompoundVariant> compoundVariants;

  /// The default selection applied when an axis is not passed by the caller.
  final Map<String, String> defaultVariants;

  /// Creates a single-element recipe.
  const WindRecipe({
    this.base = '',
    this.variants = const {},
    this.compoundVariants = const [],
    this.defaultVariants = const {},
  });

  /// Resolves the recipe into a single className string.
  ///
  /// [variants] is the caller's selection (axis -> value, or `null` to clear a
  /// default). [className] is an extra caller className appended last.
  String call({
    Map<String, String?>? variants,
    String? className,
  }) {
    // 1. Merge defaults with the selection; null in the selection clears.
    final resolved = _resolveSelection(
      this.variants,
      defaultVariants,
      variants,
    );

    // 2. base ++ variant-classes(definition order).
    final parts = <String>[];
    _addNonEmpty(parts, base);
    for (final axisEntry in this.variants.entries) {
      final selectedValue = resolved[axisEntry.key];
      if (selectedValue == null) continue;
      final variantClass = axisEntry.value[selectedValue];
      _addNonEmpty(parts, variantClass);
    }

    // 3. ++ matched-compound(array order).
    for (final compound in compoundVariants) {
      if (_matchesCompound(compound.conditions, resolved)) {
        _addNonEmpty(parts, compound.className);
      }
    }

    // 4. ++ caller extraClass.
    _addNonEmpty(parts, className);

    // 5. Debug-only same-granularity-override lint (stripped in release).
    assert(_lintShorthandLonghand(parts), 'lint always returns true');

    return parts.join(' ');
  }
}

/// **A Tailwind-Variants Multi-Part (`slots`) Recipe for Wind**
///
/// `WindSlotRecipe` resolves a `Map<String, String>` (slot name -> className),
/// one entry per slot. Each variant value carries a per-slot className map, and
/// the resolution + ordering rules mirror [WindRecipe] applied independently to
/// every slot.
///
/// ### Example Usage:
///
/// ```dart
/// final card = WindSlotRecipe(
///   slots: {
///     'root': 'flex flex-col rounded',
///     'header': 'font-bold',
///     'body': 'p-4',
///   },
///   variants: {
///     'tone': {
///       'primary': {'root': 'bg-blue-500', 'header': 'text-white'},
///     },
///   },
///   defaultVariants: {'tone': 'primary'},
/// );
///
/// final classes = card();
/// WDiv(className: classes['root']);
/// ```
@immutable
final class WindSlotRecipe {
  /// The base className per slot. Slot identity comes from these keys.
  final Map<String, String> slots;

  /// The variant axes: axis -> (value -> (slot -> className)).
  final Map<String, Map<String, Map<String, String>>> variants;

  /// The compound-variant rules, evaluated in list order.
  final List<WindSlotCompoundVariant> compoundVariants;

  /// The default selection applied when an axis is not passed by the caller.
  final Map<String, String> defaultVariants;

  /// Creates a multi-part (slot) recipe.
  const WindSlotRecipe({
    this.slots = const {},
    this.variants = const {},
    this.compoundVariants = const [],
    this.defaultVariants = const {},
  });

  /// Resolves the recipe into a `slot -> className` map.
  ///
  /// [variants] is the caller's selection (axis -> value, or `null` to clear a
  /// default). [classNames] is an extra caller className per slot, appended
  /// last for that slot.
  Map<String, String> call({
    Map<String, String?>? variants,
    Map<String, String>? classNames,
  }) {
    // 1. Merge defaults with the selection; null in the selection clears.
    final resolved = _resolveSelection(
      this.variants,
      defaultVariants,
      variants,
    );

    // 2. Per slot: base ++ variant ++ compound ++ caller, in strict order.
    final result = <String, String>{};
    for (final slotEntry in slots.entries) {
      final slot = slotEntry.key;
      final parts = <String>[];
      _addNonEmpty(parts, slotEntry.value);

      for (final axisEntry in this.variants.entries) {
        final selectedValue = resolved[axisEntry.key];
        if (selectedValue == null) continue;
        final slotMap = axisEntry.value[selectedValue];
        _addNonEmpty(parts, slotMap?[slot]);
      }

      for (final compound in compoundVariants) {
        if (_matchesCompound(compound.conditions, resolved)) {
          _addNonEmpty(parts, compound.classNames[slot]);
        }
      }

      _addNonEmpty(parts, classNames?[slot]);

      assert(_lintShorthandLonghand(parts), 'lint always returns true');

      result[slot] = parts.join(' ');
    }

    return result;
  }
}

/// Merges `{...defaults, ...selection}` validating every selected axis.
///
/// A `null` value in [selection] CLEARS the default for that axis (the axis is
/// dropped from the result), reproducing `tv()`'s `undefined`-clears behavior.
/// Throws [ArgumentError] when an axis is unknown so typos fail loudly instead
/// of silently emitting nothing.
Map<String, String> _resolveSelection(
  Map<String, Object> knownAxes,
  Map<String, String> defaults,
  Map<String, String?>? selection,
) {
  final resolved = <String, String>{...defaults};

  if (selection != null) {
    for (final entry in selection.entries) {
      if (!knownAxes.containsKey(entry.key)) {
        throw ArgumentError.value(
          entry.key,
          'variants',
          'Unknown variant axis (known: ${knownAxes.keys.join(', ')})',
        );
      }
      // null clears the default rather than selecting a value.
      if (entry.value == null) {
        resolved.remove(entry.key);
      } else {
        resolved[entry.key] = entry.value!;
      }
    }
  }

  return resolved;
}

/// Returns true when every condition in [conditions] matches [resolved].
///
/// A condition value is a `String` (exact match) or a `List<String>` (OR match,
/// satisfied when the resolved value is any member).
bool _matchesCompound(
  Map<String, Object> conditions,
  Map<String, String> resolved,
) {
  for (final condition in conditions.entries) {
    final actual = resolved[condition.key];
    if (actual == null) return false;

    final expected = condition.value;
    if (expected is List) {
      if (!expected.contains(actual)) return false;
    } else if (expected != actual) {
      return false;
    }
  }
  return true;
}

/// Splits [className] on whitespace and adds the non-empty result to [parts].
///
/// Kept as a single token sequence (no dedupe/sort) so the parser's per-family
/// last-wins still sees every occurrence in order.
void _addNonEmpty(List<String> parts, String? className) {
  if (className == null) return;
  final trimmed = className.trim();
  if (trimmed.isEmpty) return;
  parts.add(trimmed);
}

/// The shorthand -> longhand token-family map for the same-granularity lint.
///
/// Each shorthand prefix maps to the longhand prefixes of the same CSS family.
/// Wind's parser resolves these per family with last-wins, so mixing a base
/// shorthand with a variant longhand (or vice versa) silently keeps the
/// shorthand instead of overriding it.
const Map<String, List<String>> _shorthandFamilies = {
  'p-': ['px-', 'py-', 'pt-', 'pb-', 'pl-', 'pr-'],
  'm-': ['mx-', 'my-', 'mt-', 'mb-', 'ml-', 'mr-'],
  'inset-': ['top-', 'bottom-', 'left-', 'right-'],
};

/// Tracks lint keys already warned this session so a repeated render of the
/// same offending recipe logs once, not per call. Debug-only.
final Set<String> _lintedKeys = <String>{};

/// Debug-only lint: warns when [parts] mix a shorthand and a longhand token of
/// the same family (the same-granularity-override guardrail).
///
/// Always returns `true` so it can sit inside an `assert(...)` and be tree
/// shaken from release builds. Tokens keep any state prefix (`hover:`, `dark:`)
/// stripped before family matching so prefixed pairs are checked too.
bool _lintShorthandLonghand(List<String> parts) {
  if (parts.isEmpty) return true;

  final tokens = parts.expand((part) => part.split(RegExp(r'\s+'))).where(
        (token) => token.isNotEmpty,
      );

  // Track which granularities of each family appear.
  final seenShorthand = <String>{};
  final seenLonghand = <String, Set<String>>{};

  for (final token in tokens) {
    final bare = token.contains(':') ? token.split(':').last : token;

    for (final family in _shorthandFamilies.entries) {
      if (bare.startsWith(family.key)) {
        seenShorthand.add(family.key);
        continue;
      }
      for (final longhand in family.value) {
        if (bare.startsWith(longhand)) {
          seenLonghand.putIfAbsent(family.key, () => <String>{}).add(longhand);
        }
      }
    }
  }

  for (final family in seenShorthand) {
    final longhands = seenLonghand[family];
    if (longhands == null || longhands.isEmpty) continue;

    final key = '$family${longhands.join(',')}';
    if (!_lintedKeys.add(key)) continue;

    debugPrint(
      "WindRecipe: a shorthand '$family*' and longhand "
      "'${longhands.join("*, ")}*' of the same family both appear; "
      'wind parser last-wins is per-family and will silently keep the '
      'shorthand. Override at the same granularity instead.',
    );
  }

  return true;
}
