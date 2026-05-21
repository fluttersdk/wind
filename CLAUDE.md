# Wind UI — Tailwind-Inspired Flutter Styling Framework

Utility-first Flutter UI plugin. Translates `className` strings (Tailwind syntax) → Flutter widget trees via modular parsing architecture. A web developer who knows Tailwind should be able to build Flutter UIs with familiar syntax.

**Version:** 1.0.0-alpha.8 (v1 branch) · **Branch:** `v1` (master = v0, do NOT touch) · **Dart:** >=3.4.0 · **Flutter:** >=3.27.0

## Commands

| Command | Description |
|---------|-------------|
| `flutter test` | Run all tests |
| `flutter test test/parser` | Parser tests only |
| `flutter test test/widgets` | Widget tests only |
| `dart analyze` | Lint check (zero warnings required) |
| `dart format .` | Format all code |
| `cd example && flutter run` | Run demo playground |
| `cd example && flutter run -d chrome` | Web demo |

## Architecture

Wind ships an opt-in sub-barrel alongside the main `lib/fluttersdk_wind.dart`:
- `lib/dusk_integration.dart`: Wind adapter for fluttersdk_dusk (WindDuskIntegration + windClassNameEnricher); consumer must add `fluttersdk_dusk` to its own pubspec as a dev-dependency.

The sub-barrel is NOT exported from `lib/fluttersdk_wind.dart`. `fluttersdk_dusk` is a wind dev-dependency only; it is not a transitive prod dep for consumers.

```
lib/src/
├── widgets/          # 20 W-prefix widgets (WDiv, WText, WButton, WSvg, WDynamic...)
├── parser/
│   ├── wind_parser.dart      # Orchestrator — routes tokens to 17 parsers
│   ├── wind_style.dart       # Immutable style value object (parse output)
│   ├── wind_context.dart     # Theme + breakpoint + brightness + platform + states
│   └── parsers/              # 17 domain parsers (bg, border, flex, text, shadow...)
├── theme/
│   ├── wind_theme.dart       # WindTheme widget + WindThemeController
│   ├── wind_theme_data.dart  # Config: colors, screens, spacing, fonts
│   └── defaults/             # 16 default token scales
├── dynamic/          # WDynamic — JSON → widget tree (server-driven UI)
├── state/            # WindAnchorStateProvider (hover/focus/press via InheritedWidget)
└── utils/            # Extensions, helpers, color utils, logger
```

**Data flow:** `className` → WindParser.parse() → 17 parsers (first-match-wins) → WindStyle → Widget.build()

**Cache key:** className + breakpoint + brightness + platform + sorted states

## Post-Change Checklist

After ANY source code change, these MUST be synced **before committing**:

1. **`doc/`** — Update relevant documentation files (match existing format exactly)
2. **`skills/wind-ui/`** — Update SKILL.md and references if API/widget changes
3. **`example/lib/pages/`** — Update or create demo pages for changed/new features
4. **`CHANGELOG.md`** — Add entry under `[Unreleased]` section
5. **`README.md`** — Update if new widgets, features, or API changes affect the overview

Demo pages in `doc/` reference example app pages via `x-preview` blocks — keep them in sync.

## Key Gotchas

| Mistake | Fix |
|---------|-----|
| `className: 'flex-wrap'` | Use `wrap gap-2` — flex-wrap is a no-op |
| `WDiv(child: x, children: [...])` | `child` XOR `children`, never both |
| `overflow-y-auto` without `scrollPrimary: true` | Add it for iOS tap-to-top |
| `w-full` inside Row/flex-row | Use `flex-1` — w-full causes overflow |
| No `dark:` variant on colors | **Always** pair: `bg-white dark:bg-gray-800` |
| `WIcon(Icons.settings)` | Use `Icons.settings_outlined` — outlined only |
| className typo | Fails silently — parser ignores unknown tokens |
| `h-full` inside scrollable parent | Use `min-h-screen` — h-full = infinite height error |
| Forgetting `WindParser.clearCache()` in tests | Cache persists between tests |

## Parser Development

When adding/fixing a className feature:

1. Find parser in `lib/src/parser/parsers/` (or create new one implementing `WindParserInterface`)
2. Add property to `WindStyle` if needed (immutable — use `copyWith`)
3. **Write failing test first** in `test/parser/parsers/{name}_parser_test.dart`
4. Implement in parser
5. Run post-change checklist above

## Testing

Tests mirror source structure in `test/`. Parser tests use shared `createTestContext()` helper.

```dart
setUp(() {
  WindParser.clearCache(); // Required — cache persists between tests
});
```

## Skills & Extensions

- **`skills/wind-ui/`** — Wind UI skill for LLM agents. Teaches className patterns, layout rules, component composition. Symlinked from `.claude/skills/wind-ui/`
- **Upstream sync:** When you modify any file under `skills/wind-ui/`, the same change MUST also be applied to the [`fluttersdk/ai`](https://github.com/fluttersdk/ai) repository (`skills/wind-ui/` path). Remind the user to sync after committing.
- **CI:** `deploy.yml` (push to v1 → lint + test), `publish.yml` (GitHub Release → pub.dev)
