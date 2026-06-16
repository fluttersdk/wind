# Wind UI — Architecture

How the package is organized internally. Companion to [README.md](README.md) (the user-facing overview) and [CLAUDE.md](CLAUDE.md) (the contributor process rules).

## Directory layout

```
lib/src/
├── widgets/          # 22 user-facing W-prefix widgets (see .claude/rules/widgets.md)
├── parser/
│   ├── wind_parser.dart      # Orchestrator: first-match-wins routing to 19 parsers
│   ├── wind_style.dart       # Immutable value object (parse output)
│   ├── wind_context.dart     # Theme + breakpoint + brightness + platform + states
│   └── parsers/              # 19 domain parsers (see .claude/rules/parsers.md)
├── theme/
│   ├── wind_theme.dart       # WindTheme StatefulWidget + WindThemeController
│   ├── wind_theme_data.dart  # 24 configurable fields; merges with defaults/
│   └── defaults/             # 16 default token scales
├── dynamic/          # WDynamic JSON renderer (see .claude/rules/dynamic.md)
├── state/            # WindAnchorStateProvider (hover/focus/press via InheritedWidget)
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
19 domain parsers (first match wins)
    ↓
WindStyle (immutable value object)
    ↓
Widget.build()  // composes the Flutter tree from style fields
```

## Parser cache

Key: `className + activeBreakpoint + brightness + platform + sorted(activeStates)`. Stable across rebuilds; near-100% hit rate in production. Invalidate via `WindParser.clearCache()` (test `setUp` only — never in production code).

## WindTheme integration

Wrap the app once at the top:

```dart
WindTheme(
  data: WindThemeData(/* 24 fields, all optional, merged with defaults */),
  builder: (context, controller) => MaterialApp(
    theme: controller.toThemeData(),
    home: ...,
  ),
);
```

`WindTheme` lives BELOW `MaterialApp` in the actual widget tree (the builder pattern inverts the apparent order). `Overlay` contexts cannot reach `WindTheme` via ancestor walk — use the State's `context` when calling `WindParser.parse` from inside `OverlayEntry.builder`.

## Diagnostics bridge

Call `Wind.installDebugResolver()` inside `kDebugMode` to expose 7 fields (`className`, `breakpoint`, `brightness`, `platform`, `states`, `bgColor`, `textColor`) to any consumer of `WindDebugRegistry.current` (e.g., `fluttersdk_dusk` for E2E and any runtime inspector). Idempotent; gated by `kDebugMode` so release builds tree-shake it. There is no `WindDuskIntegration` class in v1.0 — replaced by this bridge via the `fluttersdk_wind_diagnostics_contracts` contract.

## Widget API surface (invariants locked at 1.0.0)

- `child` XOR `children` — never both. Asserts at construction.
- `className: String?` is the styling API; explicit props (`backgroundColor`, `foregroundColor`) are escape hatches that override className.
- `states: Set<String>?` activates prefixed classes (`hover:`, `selected:`, `loading:`, custom).
- `WIcon(Icons.X)` — use the `*_outlined` variant; Wind icons are outlined by convention.
- `WAnchor` auto-wraps `WDiv` / `WButton` when className contains `hover:` / `focus:` / `active:`.

## Wind ≠ Tailwind cheat sheet

A contributor fluent in Tailwind will trip over these:

| Tailwind expectation | Wind reality |
|----------------------|--------------|
| `flex-wrap` enables wrapping | Use `wrap` instead. `flex-wrap` is a no-op (Flutter `Wrap` is a separate widget). |
| `text-*` means font-size | Overloaded: font-size (`text-xl`), color (`text-red-500`), alignment (`text-center`). Resolved by ordered regex; do not assume one meaning. |
| Font sizes go to `9xl` | Stop at `6xl` (60px). `7xl` / `8xl` / `9xl` silently no-op. |
| `text-7xl` typo fails loudly | Every unknown token fails silently — parser ignores it. Spell-check tokens by hand. |
| Spacing in rem | Logical pixels (4 px per unit; `p-4` = 16 px). |
| `w-full` inside a row works | Causes overflow. Use `flex-1` for row children. |
| `h-full` inside a scrollable parent works | Infinite-height layout error. Use `min-h-screen`. |
| `overflow-y-auto` enables iOS tap-to-top | Pass the constructor prop `scrollPrimary: true` as well — there is no className for it. |
| `dark:` is optional | Every `bg-*`, `text-*`, `border-*`, `ring-*`, `fill-*` carries a `dark:` pair in the same className. Missing dark pair is a bug. |
| `divide-*`, `cursor-*`, `filter`, `backdrop-blur`, container queries, `group-*` / `peer-*`, `@apply` | Not implemented. No silent no-op intent — these tokens simply do not exist. |

Wind-only additions Tailwind lacks: `ios:` / `android:` / `web:` / `mobile:` platform prefixes; `axis-min` / `axis-max` for `MainAxisSize` control; `WDynamic` JSON-driven widget trees; state prefixes (`hover:`, `focus:`, `disabled:`, `loading:`, custom) as first-class className citizens.
