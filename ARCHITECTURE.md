# wind_kit: Architecture

How the package is organised internally. Companion to [README.md](README.md) (the user-facing overview) and [CLAUDE.md](CLAUDE.md) (the contributor process rules).

## Directory layout

```
lib/src/
├── widgets/          # the public W-prefix widgets plus internal layout helpers (see .claude/rules/widgets.md)
├── parser/
│   ├── wind_parser.dart      # Orchestrator: first-match-wins routing to the token parsers
│   ├── alias_expander.dart   # Expands WindThemeData.aliases before the cache key is built
│   ├── wind_style.dart       # Immutable value object (parse output)
│   ├── wind_context.dart     # Theme + breakpoint + brightness + platform + states
│   └── parsers/              # one domain parser per token family (see .claude/rules/parsers.md)
├── theme/
│   ├── wind_theme.dart       # WindTheme StatefulWidget + WindThemeController
│   ├── wind_theme_data.dart  # the configurable fields; merges with defaults/
│   └── defaults/             # the default token scales
├── dynamic/          # WDynamic JSON renderer (see .claude/rules/dynamic.md)
├── recipe/           # WindRecipe, WindSlotRecipe: variant selections to className strings
├── state/            # WindAnchorStateProvider (hover/focus via InheritedWidget) and the flex-overflow scopes
├── utils/            # color_utils, wind_logger, wind_perf_counters, extensions, helpers
├── core/             # platform_service singleton
├── debug_resolver.dart   # implements contracts package's WindDebugResolver
└── wind_facade.dart      # Wind.installDebugResolver() and Wind.installPerfResolver()
```

## Data flow

```
className: String
    ↓
WindParser.parse(className, context, states:, baseStyle:)
    ↓
alias expansion (WindThemeData.aliases)
    ↓
cache lookup by WindContext.cacheKey (skipped when baseStyle is given)
    ↓
the domain parsers (first match wins per class, in _parserMap order)
    ↓
WindStyle (immutable value object)
    ↓
Widget.build()  // composes the Flutter tree from style fields
```

## Parser cache

Key: `WindContext.cacheKey` over the alias-expanded className, `activeBreakpoint`, `brightness`, `platform` and `sorted(activeStates)`. A call that passes a `baseStyle` never consults the cache, because the key does not include it; `WDiv` and `WText` pass their own nullable `style:`, which is null in ordinary use, so only a caller that sets `style:` bypasses. The perf-counters entry in `CHANGELOG.md` records 0 bypasses and a hit rate of 99% or better across 1613 W-widget builds of one real app; `WindPerfCounters` (off by default) measures it in yours. The key leaves out the theme's maps, and `setTheme`, `updateTheme` and a parent rebuilding `WindTheme` with a new `data:` (its `didUpdateWidget` calls `setTheme`) do not clear the cache, so after any of them changes anything but brightness a cached style keeps the old value. Call `WindParser.clearCache()` then, and in test `setUp`; it also resets the counters. A brightness change needs no call, because `brightness` is in the key.

## WindTheme integration

Wrap the app once at the top:

```dart
WindTheme(
  data: WindThemeData(/* all fields optional, merged with defaults */),
  builder: (context, controller) => MaterialApp(
    theme: controller.toThemeData(),
    home: ...,
  ),
);
```

With the `builder` form above, `WindTheme` sits above `MaterialApp`, so routes and `OverlayEntry` contexts reach it by the normal ancestor walk (`lib/src/theme/wind_theme.dart`, the `_WindThemeInherited` wrapper). The trap is the other shape, `MaterialApp(home: WindTheme(...))`: there the theme sits below the Navigator's `Overlay`, an `OverlayEntry` cannot reach it, and the State's `context` has to be captured before the overlay opens and passed to `WindParser.parse`.

## Diagnostics bridge

Call `Wind.installDebugResolver()` behind `!kReleaseMode` to expose 7 fields (`className`, `breakpoint`, `brightness`, `platform`, `states`, `bgColor`, `textColor`) to any consumer of `WindDebugRegistry.current` (e.g., `tapir` for E2E and any runtime inspector). Idempotent; a no-op in release builds (`!kReleaseMode`, so a profile build still carries it), and the call tree-shakes when you gate it the same way. `Wind.installPerfResolver()` does the same for the parse-path counters (`cacheHits`, `cacheMisses`, `cacheBypasses`, `cacheSize` and the widget build counts) through the registry's perf slot; counting stays off until the host sets `WindPerfCounters.enabled`. The bridge is the `wind_kit_diagnostics_contracts` contract.

## Widget API surface (invariants locked at 1.0.0)

- `child` XOR `children` - never both. Asserts at construction.
- `className: String?` is the styling API; explicit props (`backgroundColor`, `foregroundColor`) are escape hatches that override className.
- `states: Set<String>?` activates prefixed classes (`hover:`, `selected:`, `loading:`, custom).
- `WIcon(Icons.X)` - use the `*_outlined` variant; Wind icons are outlined by convention.
- `WDiv` wraps itself in `WAnchor` when className contains `hover:` / `focus:` / `active:`; `WButton` always does.

## Invariants

| Rule | Why | Verify |
|------|-----|--------|
| No `package:flutter/material.dart` or `package:flutter/cupertino.dart` in `lib/` | Flutter 3.50 deprecates both, and pana takes 10 static-analysis points off a package that imports them | `grep -rln "package:flutter/\(material\|cupertino\).dart" lib` prints nothing |
| `dart:io` is reached only through the conditional import in `lib/src/parser/parsers/background_parser.dart` | A package whose import graph reaches `dart:io` fails the wasm-ready check | `grep -rl "dart:io" lib` prints only `file_image_io.dart` |

## Change guide

| Task | Touch | Check |
|------|-------|-------|
| A new className token family | `lib/src/parser/parsers/<name>_parser.dart`; its entry in `_parserMap` (`lib/src/parser/wind_parser.dart`, where order decides which parser claims a class); a field with its `copyWith`, `==` and `hashCode` entries in `lib/src/parser/wind_style.dart`; the builder that reads the field (`w_div.dart` for box styling, `w_text.dart` for text) | `test/parser/parsers/<name>_parser_test.dart` and `test/parser/wind_style_test.dart` |
| A new widget | `lib/src/widgets/w_<name>.dart` and its `export` in `lib/wind_kit.dart` | `test/widgets/w_<name>_test.dart` |
| A new `WindThemeData` field or scale | The field, constructor parameter, `copyWith` and its line in `operator ==` in `lib/src/theme/wind_theme_data.dart`; a scale also gets a file under `lib/src/theme/defaults/` | `test/theme/`; a field missing from `operator ==` makes `WindTheme` skip an update that changes only that field, with no error |
| A change to what the debug bridge exposes | `lib/src/debug_resolver.dart`; the map keys belong to `wind_kit_diagnostics_contracts` | The contracts-package rules in `CLAUDE.md`, Key Gotchas |

Every `lib/` change also owes the doc, example, skill and changelog surfaces listed in the Post-Change Checklist in `CLAUDE.md`.

## Where Wind differs from Tailwind

Wind keeps Tailwind's class vocabulary and diverges where Flutter's layout model does not allow the same thing: no `group-*` / `peer-*`, no container queries, no `@apply`, a font scale that stops at `6xl`, 4 logical pixels per spacing step. The full divergence catalogue, with the substitute for each case, is `skills/wind-ui/references/tailwind-divergence.md`; this file does not repeat it.

## Last reviewed

2026-11-13: audited against `lib/`. Alias expansion and the `baseStyle` cache bypass joined the data flow, `recipe/` and `alias_expander.dart` joined the tree, the perf resolver joined the diagnostics bridge, and Invariants and a Change guide were added. The parser cache paragraph now states that the key omits the theme's maps and when to call `clearCache()`.
