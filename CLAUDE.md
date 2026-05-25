# Wind UI

Utility-first Flutter styling. Translates Tailwind-syntax `className` strings into Flutter widget trees through a modular parsing pipeline.

**Stack:** Flutter >=3.27.0 · Dart >=3.4.0 · Runtime deps: `flutter_svg`, `fluttersdk_wind_diagnostics_contracts`. No `mockito`, no state management library, no router.
**Branch:** `v1` is the active 1.0.x stable line. `master` is the abandoned v0 series — do not commit there.

## Definition of done

A code change is not finished until ALL of these hold for the touched scope. The agent self-checks before reporting work complete:

1. `dart analyze` reports zero issues, zero warnings on the touched files.
2. `dart format .` produces no diff.
3. `flutter test` reports zero failures (pre-existing skips noted, never new).
4. `./tool/coverage.sh 90` exits 0 — total line coverage stays at or above 90%. If the change drops coverage, add tests in the same change set, do not lower the threshold.
5. Every code change triggers the **post-change sync** below — skipping any of the four sub-surfaces is not optional.

The PostToolUse hooks in `.claude/settings.json` auto-run format + analyze after `.dart` edits, so steps 1-2 are mostly automatic in the edit loop. CI re-runs all four gates on push; they are not negotiable there.

## Post-change sync (five surfaces, every code change)

When source under `lib/` changes, the agent updates each of these in the same change set, BEFORE reporting the work done. Each surface has its own format and acceptance criterion — comply with all five; skipping is a bug.

**1. `doc/`** — the user-facing markdown reference.

- New or changed widget / parser / token / theme field: locate the matching file under `doc/widgets/`, `doc/layout/`, `doc/styling/`, etc. Format details live in `.claude/rules/docs.md`.
- New widget: create `doc/widgets/<w-name>.md` mirroring the format of the nearest neighbor file (one `#` title, ToC, `<x-preview>` tag, Props table with `Required`/default/description columns, Constructor signature, Styling Examples, Related Documentation).
- Removed surface: delete the doc file or mark deprecated; never leave a stale doc pointing at a removed API.
- Acceptance: the doc file's `<x-preview source="...">` path matches a real `example/lib/pages/` file (sync surface #2 below).

**2. `example/lib/pages/`** — the playground demos.

- New widget / token / pattern: add `example/lib/pages/<category>/<feature>_basic.dart` (or extend an existing demo). Page shape rules live in `.claude/rules/example-pages.md`.
- `<x-preview source="..." path="...">` in any `doc/` file points to a real example page. If you add a doc x-preview, you add or extend the example page. If you delete an example page, you remove the doc x-preview.
- Acceptance: `cd example && flutter run -d chrome` boots without errors; new pages render with realistic content (no Lorem ipsum); every color token carries its `dark:` pair.

**3. `skills/wind-ui/`** — the LLM-facing skill.

- New widget, parser token family, theme field, or breaking change to className semantics: update `skills/wind-ui/SKILL.md` (trigger keywords, Core Laws, Layout Reality) AND any matching `skills/wind-ui/references/<topic>.md`.
- Acceptance: `SKILL.md` frontmatter version bumps when API surface changes; references stay self-consistent.
- **Upstream mirror:** when any file under `skills/wind-ui/**` changes, the same change MUST also land in the `fluttersdk/ai` GitHub repository under `skills/wind-ui/`. Remind the user to sync to that repo after the local commit lands. The agent does not push to `fluttersdk/ai` itself; the human does it.

**4. `CHANGELOG.md`** — versioned change log.

- Every behavior-changing source change gets an entry under the right semantic-version section:
  - `[Unreleased]` during normal development.
  - The currently-prepping version section during release prep (e.g., `[1.0.0]`).
- Entries land under one of the subsections: `Added`, `Changed`, `Fixed`, `Removed` (BREAKING), `Quality` (test/coverage/CI infra), `Security`. Pick the one closest to user impact, not internal scope.
- Format: one-line bullet per change, with backticked code identifiers and GitHub issue numbers (`(#61)`) when relevant. Match the surrounding entries' tone; no emojis unless adjacent entries use them.
- Acceptance: `grep -A 5 "^## \[" CHANGELOG.md | head -20` shows the new entry in the correct section.

**5. `README.md`** — overview-level only.

- Update only when the change is overview-worthy: a new widget added to the public roster, a new top-level feature (theme field, parser token family, integration entry point), a public API addition or removal.
- Internal refactors, test additions, doc fixes, dependency tweaks: NO README update needed — the noise harms more than the precision helps.
- Acceptance: README's "What you get" list reflects the v1 roster (19 widgets, 17 parsers, 23 theme fields) accurately.

**One change set, all five surfaces.** Do not split "code now, docs later" — the next session loses context and the docs rot.

## Commands

Standard Flutter package commands (`flutter test`, `dart analyze`, `dart format .`, `flutter pub get`) work as expected. Non-obvious ones:

| Command | Purpose |
|---------|---------|
| `./tool/coverage.sh 90` | Run tests with coverage + enforce 90% line threshold (the CI gate). Plain `./tool/coverage.sh` just reports. |
| `cd example && flutter run -d chrome` | Demo app (`example/lib/main.dart`) |

`.claude/settings.json` PostToolUse hooks auto-run `dart format` and `dart analyze` after every `.dart` edit. CI runs `flutter analyze` + `dart format --set-exit-if-changed` + `./tool/coverage.sh 90` on push to `main`, `develop`, `v1`.

## Architecture

```
lib/src/
├── widgets/          # 19 user-facing W-prefix widgets (see .claude/rules/widgets.md)
├── parser/
│   ├── wind_parser.dart      # Orchestrator: first-match-wins routing to 17 parsers
│   ├── wind_style.dart       # Immutable value object (parse output)
│   ├── wind_context.dart     # Theme + breakpoint + brightness + platform + states
│   └── parsers/              # 17 domain parsers (see .claude/rules/parsers.md)
├── theme/
│   ├── wind_theme.dart       # WindTheme StatefulWidget + WindThemeController
│   ├── wind_theme_data.dart  # 23 configurable fields; merges with defaults/
│   └── defaults/             # 16 default token scales
├── dynamic/          # WDynamic JSON renderer (see .claude/rules/dynamic.md)
├── state/            # WindAnchorStateProvider (hover/focus/press via InheritedWidget)
├── utils/            # color_utils, wind_logger, extensions, helpers
├── core/             # platform_service singleton
├── debug_resolver.dart   # implements contracts package's WindDebugResolver
└── wind_facade.dart      # Wind.installDebugResolver() entry point
```

**Data flow:** `className` → `WindParser.parse(className, context, states:)` → 17 parsers (first-match-wins) → `WindStyle` (immutable) → widget composes its tree.

**Parser cache key:** `className + activeBreakpoint + brightness + platform + sorted(states)`. Stable across rebuilds; invalidate via `WindParser.clearCache()` (test setUp only — never in production code).

**WindTheme integration** — wrap the app once at the top:
```dart
WindTheme(
  data: WindThemeData(/* 23 fields, all optional, merged with defaults */),
  builder: (context, controller) => MaterialApp(
    theme: controller.toThemeData(),
    home: ...,
  ),
);
```
`WindTheme` lives BELOW `MaterialApp` in the actual widget tree (the builder pattern inverts the apparent order). `Overlay` contexts cannot reach `WindTheme` via ancestor walk — use the State's `context` when calling `WindParser.parse` from inside `OverlayEntry.builder`.

**Diagnostics bridge:** call `Wind.installDebugResolver()` inside `kDebugMode` to expose 6 fields (className, breakpoint, brightness, platform, states, bgColor, textColor) to any consumer of `WindDebugRegistry.current` (e.g., `fluttersdk_dusk` for E2E). Idempotent; gated by `kDebugMode`. There is no `WindDuskIntegration` class in v1.0.

## Wind ≠ Tailwind cheat sheet

A contributor fluent in Tailwind will trip over these:

| Tailwind expectation | Wind reality |
|----------------------|--------------|
| `flex-wrap` enables wrapping | Use `wrap` instead. `flex-wrap` is a no-op (Flutter `Wrap` is a separate widget). |
| `text-*` means font-size | Overloaded: font-size (`text-xl`), color (`text-red-500`), alignment (`text-center`). Resolved by ordered regex; do not assume one meaning. |
| Font sizes go to `9xl` | Stop at `6xl` (60px). `7xl`/`8xl`/`9xl` silently no-op. |
| `text-7xl` typo fails loudly | Every unknown token fails silently — parser ignores it. Spell-check tokens by hand. |
| Spacing in rem | Logical pixels (4 px per unit; `p-4` = 16 px). |
| `w-full` inside a row works | Causes overflow. Use `flex-1` for row children. |
| `h-full` inside a scrollable parent works | Infinite-height layout error. Use `min-h-screen`. |
| `overflow-y-auto` enables iOS tap-to-top | Pass the constructor prop `scrollPrimary: true` as well — there is no className for it. |
| `dark:` is optional | Every `bg-*`, `text-*`, `border-*`, `ring-*`, `fill-*` carries a `dark:` pair in the same className. Missing dark pair is a bug. |
| `divide-*`, `cursor-*`, `filter`, `backdrop-blur`, container queries, `group-*`/`peer-*`, `@apply` | Not implemented. No silent no-op intent — these tokens simply do not exist. |

Wind-only additions Tailwind lacks: `ios:` / `android:` / `web:` platform prefixes; `axis-min` / `axis-max` for `MainAxisSize` control; `WDynamic` JSON-driven widget trees.

## Widget API surface (locked at 1.0.0)

- `child` XOR `children` — never both. Asserts at construction.
- `className: String?` is the styling API; explicit props (`backgroundColor`, `foregroundColor`) are escape hatches that override className.
- `states: Set<String>?` activates prefixed classes (`hover:`, `selected:`, `loading:`, custom).
- `WIcon(Icons.X)` — use the `*_outlined` variant; Wind icons are outlined by convention.
- `WAnchor` auto-wraps `WDiv` / `WButton` when className contains `hover:` / `focus:` / `active:`.

## Coverage policy (binding)

The 90% line-coverage gate is the floor, not the target.

- Adding code drops coverage? Add tests in the SAME change set to land back at ≥ 90%. Never lower the gate.
- `// coverage:ignore-line` only for lines structurally unreachable from `flutter test` (kDebugMode-only branches, dart:io `Platform.is*` branches not matching the CI host). Pragma must be on the SAME line as the statement; add a one-line WHY comment immediately above.
- Use `./tool/coverage.sh 90` locally before pushing — same gate CI enforces. CI fails the PR if you skip it.
- Pre-existing skipped tests are noted in the report; never add new `skip:` tags without an explicit reason in the test's nearby comment.

## Testing rule that catches everyone

Parser tests MUST call `WindParser.clearCache()` in `setUp()` — the cache persists between tests and produces false positives if not cleared. Widget tests that pump className-styled widgets also need it. See `.claude/rules/tests.md` for the full test discipline.
