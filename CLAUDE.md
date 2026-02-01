# FlutterSDK Wind

A utility-first Flutter UI framework inspired by Tailwind CSS. Parses CSS-like class strings into Flutter widget trees.

## Quick Reference

| Command | Description |
|---------|-------------|
| `flutter test` | Run all tests (695+) |
| `flutter test test/widgets/` | Run widget tests only |
| `flutter test test/parser/` | Run parser tests only |
| `cd example && flutter run -d macos` | Run example app |
| `dart analyze` | Run static analysis |

<ARCHITECTURE>
## Architecture

**Core Pipeline:** `className string → WindParser → WindStyle → Widget`

```
lib/src/
├── core/          # Platform services
├── parser/
│   ├── wind_parser.dart      # Central orchestrator - splits classes, delegates to parsers
│   ├── wind_style.dart       # Parsed style data object
│   ├── wind_context.dart     # Responsive breakpoints & state context
│   └── parsers/              # 18 specialized parsers (background, border, flexbox, text, etc.)
├── state/         # Anchor state management
├── theme/         # WindTheme - Tailwind-compatible color/spacing/typography scales
├── utils/         # Color utils, extensions, helpers, logger
└── widgets/       # 15 W-prefixed widgets (WDiv, WText, WButton, WSelect, etc.)
```

**Key patterns:**
- Parsers implement `WindParserInterface` and handle specific utility prefixes
- `WindParser` caches parsed results for performance
- Responsive (`md:`, `lg:`) and state (`hover:`, `focus:`) prefixes resolved via `WindContext`
- All widgets accept `className` string parameter
</ARCHITECTURE>

<CONVENTIONS>
## Conventions

- **Widget naming:** `W` prefix (WDiv, WText, WButton, WSelect, WPopover)
- **Parser naming:** `{feature}_parser.dart` implementing `WindParserInterface`
- **Class syntax:** Tailwind-compatible (`bg-red-500`, `flex`, `gap-4`, `p-2`, `rounded-lg`)
- **State management:** StatefulWidget for interactive widgets, no external state library
- **Exports:** Single barrel file at `lib/fluttersdk_wind.dart`
- **Dart SDK:** ^3.10.4, Flutter >=1.17.0
- **Dependencies:** Only `flutter_svg` beyond Flutter SDK
</CONVENTIONS>

<TESTING>
## Testing

- **Framework:** flutter_test (695+ tests, 3 known failures)
- **Structure mirrors source:** `test/widgets/`, `test/parser/`, `test/theme/`, `test/utils/`
- **Widget tests:** Use `tester.pumpWidget()` with `MaterialApp` wrapper
- **Pattern:** Arrange (build widget) → Act (interact) → Assert (find/expect)
- **Run single file:** `flutter test test/widgets/w_div/layout_test.dart`
</TESTING>

<TOOLS>
## Available Tools

- **Serena MCP:** Use `get_symbols_overview`, `find_symbol`, `find_referencing_symbols` for code navigation
- **context7:** For Flutter/Dart documentation lookups
- **GitHub MCP:** For issues and PRs against `fluttersdk/wind`
</TOOLS>

<GOTCHAS>
## Gotchas

- Parser caching means style changes may need cache invalidation during testing
- `WindContext` must be available in widget tree for responsive/state prefixes to resolve
- Ring parser and border parser handle overlapping border-related classes differently
- WSelect uses WPopover internally - test WPopover behavior when debugging dropdown issues
- Example app is in `example/` with its own pubspec.yaml
</GOTCHAS>
