/// Maximum expansion depth before resolution stops.
///
/// Eight levels cover any realistic alias chain (an alias whose value is an
/// alias whose value is an alias, etc.); a deeper chain almost certainly means
/// a misconfiguration, so the cap is a backstop alongside the per-chain cycle
/// guard rather than the primary termination mechanism.
const int _maxExpansionDepth = 8;

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
///   independently. Only a WHOLE unprefixed token equal to an alias key is
///   replaced (`row` matches the key `row`; `md:row` does not). The replacement
///   is the alias value's own tokens, which may themselves contain prefixes or
///   further aliases and are expanded recursively.
/// - Token order and duplicates are preserved (no dedup); the parser is
///   last-class-wins, so dropping a trailing duplicate would change semantics.
///   Two independent occurrences of the same alias both expand.
///
/// ### Termination
///
/// Each token expands down its own chain, guarded by a per-chain visited-set:
/// re-encountering a key already on the current chain (a self-cycle `a -> a` or
/// a mutual cycle `a -> b -> a`) leaves the token unexpanded instead of
/// looping. [_maxExpansionDepth] is a secondary backstop. On a cycle or cap hit
/// the offending token is kept verbatim and [onWarn] (when provided) is invoked
/// with a diagnostic message; the function never throws.
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

  final expanded = <String>[];

  for (final token in _tokenize(className)) {
    _expandToken(token, aliases, <String>{}, 0, expanded, onWarn);
  }

  return expanded.join(' ');
}

/// Splits a className string on whitespace, dropping empty fragments.
///
/// Mirrors WindParser.findAndGroupClasses so multiline / multi-space input
/// tokenizes identically on both sides.
Iterable<String> _tokenize(String value) =>
    value.split(RegExp(r'\s+')).where((s) => s.isNotEmpty);

/// Expands a single [token], appending the resulting tokens to [out].
///
/// [chain] is the set of alias keys already expanded on the current resolution
/// path; a token present in it (cycle) or a [depth] past [_maxExpansionDepth]
/// (cap) is appended unexpanded after warning. A fresh chain copy is passed
/// down each branch so sibling occurrences of the same alias both expand.
void _expandToken(
  String token,
  Map<String, String> aliases,
  Set<String> chain,
  int depth,
  List<String> out,
  void Function(String message)? onWarn,
) {
  // Bare-token contract: a prefixed token (anything carrying a ':' variant,
  // such as md:row or dark:bg-gray-900) is never alias-expanded, even if the
  // map happens to hold a matching prefixed key. Only whole unprefixed tokens
  // are eligible, so the lookup is skipped before it can match.
  if (token.contains(':')) {
    out.add(token);
    return;
  }

  final replacement = aliases[token];

  // Not an alias key (unknown bare token): keep verbatim.
  if (replacement == null) {
    out.add(token);
    return;
  }

  // Cycle guard: this key is already on the current resolution chain.
  if (chain.contains(token)) {
    onWarn?.call("Wind alias '$token' forms a cycle; left unexpanded.");
    out.add(token);
    return;
  }

  // Cap guard: chain deeper than the backstop allows.
  if (depth >= _maxExpansionDepth) {
    onWarn?.call(
      "Wind alias '$token' exceeds the $_maxExpansionDepth-level "
      'expansion cap; left unexpanded.',
    );
    out.add(token);
    return;
  }

  final nextChain = {...chain, token};
  for (final inner in _tokenize(replacement)) {
    _expandToken(inner, aliases, nextChain, depth + 1, out, onWarn);
  }
}
