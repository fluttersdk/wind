# wind_kit: Architecture

How the package is organised internally. Companion to [README.md](README.md) (the user-facing overview) and [CLAUDE.md](CLAUDE.md) (the contributor process rules).

## Directory layout

```
lib/src/
├── widgets/          # the public W-prefix widgets plus internal layout helpers (see .claude/rules/widgets.md)
├── parser/
│   ├── wind_parser.dart      # Orchestrator: first-match-wins routing to the token parsers
│   ├── wind_style.dart       # Immutable value object (parse output)
│   ├── wind_context.dart     # Theme + breakpoint + brightness + platform + states
│   └── parsers/              # one domain parser per token family (see .claude/rules/parsers.md)
├── theme/
│   ├── wind_theme.dart       # WindTheme StatefulWidget + WindThemeController
│   ├── wind_theme_data.dart  # the configurable fields; merges with defaults/
│   └── defaults/             # the default token scales
├── dynamic/          # WDynamic JSON renderer (see .claude/rules/dynamic.md)
├── state/            # WindAnchorStateProvider (hover/focus via InheritedWidget)
├── utils/            # color_utils, wind_logger, extensions, helpers
├── core/             # platform_service singleton
├── debug_resolver.dart   # implements contracts package's WindDebugResolver
└── wind_facade.dart      # Wind.installDebugResolver() entry point
```

## Data flow

```
className: String
    ↓
WindParser.parse(className, context, states:)
    ↓
the domain parsers (first match wins)
    ↓
WindStyle (immutable value object)
    ↓
Widget.build()  // composes the Flutter tree from style fields
```

## Parser cache

Key: `className + activeBreakpoint + brightness + platform + sorted(activeStates)`. Stable across rebuilds; near-100% hit rate in production. Invalidate via `WindParser.clearCache()` (test `setUp` only - never in production code).

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

Call `Wind.installDebugResolver()` behind `!kReleaseMode` to expose 7 fields (`className`, `breakpoint`, `brightness`, `platform`, `states`, `bgColor`, `textColor`) to any consumer of `WindDebugRegistry.current` (e.g., `tapir` for E2E and any runtime inspector). Idempotent; a no-op in release builds (`!kReleaseMode`, so a profile build still carries it), and the call tree-shakes when you gate it the same way. The bridge is the `wind_kit_diagnostics_contracts` contract.

## Widget API surface (invariants locked at 1.0.0)

- `child` XOR `children` - never both. Asserts at construction.
- `className: String?` is the styling API; explicit props (`backgroundColor`, `foregroundColor`) are escape hatches that override className.
- `states: Set<String>?` activates prefixed classes (`hover:`, `selected:`, `loading:`, custom).
- `WIcon(Icons.X)` - use the `*_outlined` variant; Wind icons are outlined by convention.
- `WAnchor` auto-wraps `WDiv` / `WButton` when className contains `hover:` / `focus:` / `active:`.

## Where Wind differs from Tailwind

Wind keeps Tailwind's class vocabulary and diverges where Flutter's layout model does not allow the same thing: no `group-*` / `peer-*`, no container queries, no `@apply`, a font scale that stops at `6xl`, 4 logical pixels per spacing step. The full divergence catalogue, with the substitute for each case, is `skills/wind-ui/references/tailwind-divergence.md`; this file does not repeat it.

## Last reviewed

2026-11-13: package renamed to `wind_kit`; widget, parser and theme-field counts re-checked against `lib/`; the Tailwind cheat sheet moved to the skill reference.
