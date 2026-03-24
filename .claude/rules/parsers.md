---
path: "lib/src/parser/**/*.dart"
---

# Parser Domain

- Every parser implements `WindParserInterface` with exactly two methods: `canParse()` and `parse()`
- `canParse()` must be O(1) — use `startsWith()` or pre-compiled `static final RegExp`. No heavy logic
- `parse()` iterates classes in **reverse** (last class wins semantics). Forward iteration is a bug
- Return `styles.copyWith(...)` from parse() — never return null, never mutate input
- If `classes == null`, return `styles` unchanged immediately
- Use named RegExp capture groups: `(?<root>p|pt|pr|pb|pl|px|py)` — not positional groups
- Prefix stripping (`hover:`, `dark:`, `md:`) happens in WindParser before delegation — parsers never see prefixes
- First-match-wins routing: WindParser checks `canParse()` across all parsers — first `true` wins. Order matters
- One parser per file in `parsers/`. File name matches domain: `padding_parser.dart`, `border_parser.dart`
- Register new parsers in `WindParser._parserMap` — key is descriptive string, value is const instance
- `WindStyle` is immutable — properties are nullable. Merge with existing: `pTop ?? styles.padding?.top ?? 0`
- Theme value resolution via `context.theme.getSpacing()`, `context.theme.getColor()` — never hardcode values
- Arbitrary values use `[...]` bracket syntax: `p-[10px]`, `bg-[#FF5733]`. Parse brackets before theme lookup
- Cache key = className + breakpoint + brightness + platform + sorted states. Call `WindParser.clearCache()` in tests
