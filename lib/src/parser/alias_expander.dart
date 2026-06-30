/// Maximum expansion depth before resolution stops.
///
/// Eight levels cover any realistic alias chain (an alias whose value is an
/// alias whose value is an alias, etc.); a deeper chain almost certainly means
/// a misconfiguration, so the cap is a backstop alongside the per-chain cycle
/// guard rather than the primary termination mechanism.
const int _maxExpansionDepth = 8;

/// Maximum number of expanded output tokens before expansion stops.
///
/// The depth cap and cycle guard bound chain LENGTH, not branching WIDTH: an
/// acyclic map whose values each reference several further multi-token aliases
/// (`{a: 'b b', b: 'c c', ...}`) fans out as O(width^depth) and would still
/// blow up under the depth cap alone. This total-output budget bounds the
/// worst case to a constant regardless of map shape. A real className carries
/// at most a few dozen utility tokens, so the cap sits far above any legitimate
/// use. On exhaustion the remaining tokens are dropped and [onWarn] fires once;
/// the function never throws.
const int _maxOutputTokens = 256;

/// Expands user-defined className aliases into their underlying tokens.
///
/// This is a PURE function: a className string plus an alias map go in, an
/// expanded className string comes out. It imports no parser, theme, or Flutter
/// symbols so it can be unit-tested in isolation.
///
/// ### Behavior
///
/// - When [aliases] is empty, the input is returned unchanged (zero-cost fast
///   path; the hot rendering path pays nothing when no aliases are configured).
/// - Otherwise the className is split on whitespace and each token is expanded
///   independently. Alias keys are always BARE (no prefix); the lookup matches
///   a token's bare body, not the prefix chain. An unprefixed token matches a
///   key directly (`row` -> key `row`). A prefixed token has its prefix chain
///   peeled off, its bare body matched against the map, and on a hit the outer
///   prefix is re-applied to every produced token (`md:row` ->
///   `md:flex md:flex-row`; `hover:bg-surface` -> the surface alias' tokens
///   each carrying `hover:`). Prefix order is irrelevant to the parser, so a
///   `hover:` re-applied over a value's own `dark:` yields `hover:dark:...`.
///   The replacement is the alias value's own tokens, which may themselves
///   contain prefixes or further aliases and are expanded recursively.
/// - Token order and duplicates are preserved (no dedup); the parser is
///   last-class-wins, so dropping a trailing duplicate would change semantics.
///   Two independent occurrences of the same alias both expand.
///
/// ### Termination
///
/// Three independent guards bound the work:
/// - A per-chain visited-set: re-encountering a key already on the current
///   resolution chain (a self-cycle `a -> a` or a mutual cycle `a -> b -> a`)
///   leaves the token unexpanded instead of looping. A fresh chain copy is
///   passed down each branch so sibling occurrences of the same alias both
///   expand.
/// - [_maxExpansionDepth]: a depth backstop on chain LENGTH.
/// - [_maxOutputTokens]: a total-output budget on branching WIDTH, so a
///   fan-out map cannot explode the output exponentially.
///
/// On a cycle or depth-cap hit the offending token is kept verbatim; on a
/// budget hit the remaining tokens are dropped. Each guard invokes [onWarn]
/// (when provided, the budget warning once) with a diagnostic message. The
/// function never throws.
///
/// ### Example
///
/// ```dart
/// expandAliases('row-c', {'row': 'flex flex-row', 'row-c': 'row items-center'});
/// // -> 'flex flex-row items-center'
/// ```
String expandAliases(
  String className,
  Map<String, String> aliases, {
  void Function(String message)? onWarn,
}) {
  // Fast path: no aliases configured, nothing to expand.
  if (aliases.isEmpty) {
    return className;
  }

  final out = <String>[];
  // The budget warning fires at most once per call; it is shared across the
  // whole recursion via this closure, which is why expansion is a nested
  // function rather than a top-level one.
  var budgetWarned = false;

  void expand(String token, Set<String> chain, int depth) {
    // Output budget: stop once the total token count is reached so an acyclic
    // fan-out map cannot grow the output without bound. Warn once.
    if (out.length >= _maxOutputTokens) {
      if (!budgetWarned) {
        budgetWarned = true;
        onWarn?.call(
          'Wind alias expansion exceeded the $_maxOutputTokens-token budget; '
          'remaining tokens were dropped.',
        );
      }
      return;
    }

    // Peel any prefix chain (everything up to and including the LAST ':') off
    // the token; alias keys are always bare, so only the body can match. A
    // prefixed token whose body is an alias expands the body and re-applies the
    // prefix to each produced token, so hover:bg-surface and md:row resolve
    // instead of silently passing through. An unprefixed token has an empty
    // prefix and matches directly.
    final colon = token.lastIndexOf(':');
    final String prefix = colon == -1 ? '' : token.substring(0, colon + 1);
    final String body = colon == -1 ? token : token.substring(colon + 1);

    final replacement = aliases[body];

    // Not an alias key (unknown bare token, or a prefixed token whose body is
    // not an alias key): keep the ORIGINAL token verbatim.
    if (replacement == null) {
      out.add(token);
      return;
    }

    // Cycle guard: this key is already on the current resolution chain.
    if (chain.contains(body)) {
      onWarn?.call("Wind alias '$body' forms a cycle; left unexpanded.");
      out.add(token);
      return;
    }

    // Cap guard: chain deeper than the backstop allows.
    if (depth >= _maxExpansionDepth) {
      onWarn?.call(
        "Wind alias '$body' exceeds the $_maxExpansionDepth-level "
        'expansion cap; left unexpanded.',
      );
      out.add(token);
      return;
    }

    final nextChain = {...chain, body};
    for (final inner in _tokenize(replacement)) {
      // Re-apply the outer prefix (if any) to each produced token. Prefix order
      // is irrelevant to the parser, so hover: over a value's dark: becomes
      // hover:dark:... and still resolves.
      expand(prefix.isEmpty ? inner : '$prefix$inner', nextChain, depth + 1);
    }
  }

  for (final token in _tokenize(className)) {
    expand(token, <String>{}, 0);
  }

  return out.join(' ');
}

/// Splits a className string on whitespace, dropping empty fragments.
///
/// Mirrors WindParser.findAndGroupClasses so multiline / multi-space input
/// tokenizes identically on both sides.
Iterable<String> _tokenize(String value) =>
    value.split(RegExp(r'\s+')).where((s) => s.isNotEmpty);
