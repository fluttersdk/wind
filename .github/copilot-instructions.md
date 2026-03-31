# Wind UI — Tailwind-Inspired Flutter Styling Framework

Utility-first Flutter UI plugin. Translates `className` strings (Tailwind syntax) into Flutter widget trees via modular parsing architecture.

**Version:** 1.0.0-alpha.4 · **Branch:** `v1` (master = v0, do NOT touch) · **Dart:** >=3.4.0 · **Flutter:** >=3.27.0

## Architecture

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

## Key Conventions

- All widgets use `W` prefix: `WDiv`, `WButton`, `WText`, `WFormInput`, `WSvg`
- `className` is the primary styling API — takes precedence over explicit style properties
- `child` XOR `children` — never both
- Last class wins — later classes override earlier ones for same property
- Spacing scale: N * 4px (`p-4` = 16px, `gap-2` = 8px)
- Arbitrary values: bracket syntax `w-[200px]`, `text-[#FF0000]`
- TDD — failing test first, red-green-refactor
- Zero tolerance — linter zero warnings, no suppressions

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

## Post-Change Checklist

After ANY source code change, sync before committing:

1. **`doc/`** — Update relevant documentation files
2. **`skills/wind-ui/`** — Update SKILL.md and references if API/widget changes
3. **`example/lib/pages/`** — Update or create demo pages
4. **`CHANGELOG.md`** — Add entry under `[Unreleased]`
5. **`README.md`** — Update if new widgets, features, or API changes

## Parser Development

1. Find parser in `lib/src/parser/parsers/` (or create new one implementing `WindParserInterface`)
2. Add property to `WindStyle` if needed (immutable — use `copyWith`)
3. Write failing test first in `test/parser/parsers/{name}_parser_test.dart`
4. Implement in parser
5. Run post-change checklist
