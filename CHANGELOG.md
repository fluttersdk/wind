# Changelog

All notable changes to this project will be documented in this file.

This project follows [Semantic Versioning 2.0.0](https://semver.org/spec/v2.0.0.html).

---

## [1.0.0] - 2026-05-27

First stable release. wind is utility-first, Tailwind-syntax styling for Flutter; v1.0.0 is a complete rewrite of the 0.0.x line with a fresh API surface, a 19-parser pipeline with cached resolution, dark-mode pairs as a first-class contract, and a contracts-based debug bridge for external tooling. All public APIs follow Semantic Versioning 2.0.0 from this point forward.

**Migration from 0.0.x.** v1 is not source-compatible with v0. Class names like `WText`, `WDiv`, `WButton` are preserved but constructor signatures, the supported className token set, and theme integration differ throughout. Consumers on 0.0.x rewrite their UI against the v1 API; the full v1 documentation lives at [fluttersdk.com/wind](https://fluttersdk.com/wind).

### Added

- **22 public widgets** exported from the single barrel `package:fluttersdk_wind/fluttersdk_wind.dart`:
  - Layout: `WDiv`, `WSpacer`
  - Structural: `WBreakpoint`, `WDynamic`
  - Display: `WText`, `WIcon`, `WImage`, `WSvg`
  - Interactive: `WAnchor`, `WButton`
  - Overlay: `WPopover`
  - Form (raw): `WInput`, `WSelect<T>`, `WCheckbox`, `WDatePicker`
  - Form (FormField wrappers): `WFormInput`, `WFormSelect<T>`, `WFormMultiSelect<T>`, `WFormCheckbox`, `WFormDatePicker`
  - Utility: `WKeyboardActions`, `WindAnimationWrapper`
- **19 className parsers** in a token-routing pipeline: background (color, gradient, image), border + radius, ring, shadow, opacity, padding, margin, sizing, flexbox + grid, position (relative + absolute + insets), order, overflow, aspect-ratio, z-index, text (size / weight / family / tracking / leading / decoration / transform / align / overflow), animation, transition (duration + easing), svg fill/stroke + preserve-colors, debug.
- **`WindThemeData` with 23 configurable fields**: `brightness`, `colors`, `screens`, `containers`, `fontSizes`, `fontWeights`, `tracking`, `leading`, `borderWidths`, `borderRadius`, `fontFamilies`, `ringWidths`, `ringOffsets`, `applyDefaultFontFamily`, `syncWithSystem`, `baseSpacingUnit`, `ringColor`, `opacities`, `zIndices`, `shadows`, `transitionDurations`, `transitionCurves`, `animations`. `WindThemeController` exposes `toggleTheme()`, `setTheme()`, `updateTheme()`, `resetToSystem()`. Optional `onThemeChanged` callback fires only on user-initiated toggles, not system brightness syncs.
- **State system, three layers.** Automatic (`hover:`, `focus:` via `WAnchor` pointer + focus listeners), framework-managed (`loading:`, `disabled:`, `checked:`, `error:`), consumer-passed (`states: Set<String>?` for any custom string like `selected:`). All states funnel into a single `Set<String>` on the parser cache key.
- **Responsive prefixes** (`sm:`, `md:`, `lg:`, `xl:`, `2xl:`, customizable via `WindThemeData.screens`), dark mode (`dark:`), and platform prefixes (`ios:`, `android:`, `macos:`, `web:`, `mobile:`, `windows:`, `linux:`). Stackable freely.
- **CSS positioning utilities**: `relative`, `absolute`, `top-*`, `right-*`, `bottom-*`, `left-*`, `inset-*`, `inset-x-*`, `inset-y-*`, plus negative variants (`-top-*`, `-inset-*`) and arbitrary-px values (`top-[24px]`).
- **Child order utilities**: `order-0` through `order-12`, `order-first`, `order-last`, `order-none`, plus arbitrary `order-[n]` (including negatives) for reordering flex children without changing source order.
- **Reverse flex direction**: `flex-row-reverse` and `flex-col-reverse` flip the main-axis direction so `justify-start` mirrors per CSS semantics.
- **Inline color props**: `WDiv.backgroundColor` and `WText.foregroundColor` for runtime-dynamic colors. Override any `bg-*` / `text-*` from className and stay out of the parser cache key.
- **`WBreakpoint` widget**: declarative per-breakpoint widget tree builder. Reach for it when className prefixes are not enough because the widget structure itself changes between breakpoints.
- **`WDynamic`**: JSON-driven widget tree renderer. 13 Wind types + 16 Flutter core types allowed by default, extensible via `builders:`, restrictable via `denyWidgets:`, with `customIcons:` for user-defined icon mappings (25 built-in glyphs). State binding by widget `id`, action dispatch via `WActionHandler`, max recursion depth 50.
- **Accessibility / Semantics** on 7 interactive widgets (`WAnchor`, `WButton`, `WInput`, `WFormInput`, `WCheckbox`, `WSelect`, `WDatePicker`): emit `Semantics` nodes with role + label, password fields mark `obscured`. Enables Playwright `getByRole` / `getByLabel` / `getByText` resolution against the Flutter web build. New optional `WInput.semanticLabel` parameter.
- **`Wind.installDebugResolver()`**: call inside `kDebugMode` to register a `WindDebugResolverImpl` against the new `fluttersdk_wind_diagnostics_contracts` bridge. Resolves 7 fields per Wind widget element: `className`, `breakpoint`, `brightness`, `platform`, `states`, conditional `bgColor`, conditional `textColor`. Consumed by `fluttersdk_dusk` for E2E snapshot capture and by any runtime inspector. Tree-shaken in release builds.

### Changed

- **BREAKING.** Complete API rewrite from 0.0.x. The legacy `lib/src/parsers/` (28 modules) and `lib/src/components/` (8 modules) directories were deleted and reimplemented under `lib/src/parser/parsers/` and `lib/src/widgets/`. Class names `WText`, `WDiv`, `WButton` are preserved but their constructor signatures, the className token set they accept, and theme integration differ. Not source-compatible with v0.
- **BREAKING.** Flutter SDK minimum raised from `>=3.3.0` to `>=3.27.0`. Dart SDK constraint set to `>=3.4.0 <4.0.0`.
- **BREAKING.** Parser cache is now always on. The opt-in `trackProvenance` flag on `WindParser.parse()` and the `WindStyle.resolvedVia` field are gone; debug-tooling consumers read widget state through `Wind.installDebugResolver()` and the `fluttersdk_wind_diagnostics_contracts` contract package instead.

### Removed

- **BREAKING.** `WindDuskIntegration` class and the `lib/dusk_integration.dart` sub-barrel. Replaced by `Wind.installDebugResolver()` from the main barrel.
- **BREAKING.** `fluttersdk_dusk` as a wind dependency at any level. Consumers needing Dusk for their own E2E add it to their own pubspec.
- **BREAKING.** `google_fonts` and `platform_info` dependencies. Consumers depending on them transitively must add explicit deps.
- **BREAKING.** `WindParser.parse(trackProvenance:)` parameter, `WindStyle.resolvedVia` field, and the `enableProvenance()` toggle. The contracts-based diagnostic bridge does not require provenance instrumentation.

### Fixed

- `WInput`: `px-*` horizontal padding now matches the requested value exactly on both single-line and multiline inputs. Previously every `OutlineInputBorder` defaulted to `gapPadding: 4.0` (Material's reservation for a floating-label cutout) which added a phantom `+4px` on each horizontal edge; wind routes labels through the parser and never uses `InputDecoration.labelText`, so the gap had no purpose. Setting `gapPadding: 0.0` on the built border yields exact `px-*` semantics: `px-3` now produces a 12 px inset instead of 16 px. Multiline `minLines` / `maxLines` geometry unchanged. (#61)
- `example/lib/routes.dart`: six widget routes that used kebab-case keys (`/widgets/w-input-multiline`, `/widgets/w-input-search`, `/widgets/w-popover-alignment`, `/widgets/w-select_multi`, `/widgets/w-select_single`, `/widgets/w-text-transform`) are now snake_case to match their page-file basenames. Live doc iframes at `wind.fluttersdk.com/preview/widgets/<key>` resolve correctly. Two dead pages (`layout/grid_basic`, `layout/order`) with no documentation reference were removed.

### Dependencies

- **Runtime**: `flutter` (SDK), `flutter_svg ^2.0.0`, `fluttersdk_wind_diagnostics_contracts ^1.0.0`.
- **Dev**: `flutter_test` (SDK), `flutter_lints ^5.0.0`.

### Quality

- 1,211 tests across 81 test files; line coverage 90.2% (CI gate enforces `≥ 90%` via `./tool/coverage.sh 90`).
- `tool/coverage.sh` portable threshold-aware lcov wrapper; GitHub Actions gate fails any PR dropping below 90%.
- Surgical `// coverage:ignore-line` pragmas only on lines structurally unreachable from `flutter test` (kDebugMode branches, `dart:io` `Platform.is*` branches not matching the CI host). Each pragma carries a one-line WHY comment.

### Documentation

- Full v1 documentation at [fluttersdk.com/wind](https://fluttersdk.com/wind). Every widget, parser, and theme field has a dedicated page with `<x-preview>` live demos.
- LLM-facing skill at `skills/wind-ui/` distributed via [fluttersdk/ai](https://github.com/fluttersdk/ai) for 8+ AI clients (Claude Code, Cursor, OpenCode, Gemini CLI, VS Code Copilot, Codex CLI, Cline, Roo Code). Install: `npx skills add fluttersdk/ai --skill wind-ui`.

---

## Previous versions

The 1.0.0-alpha.1 through 1.0.0-alpha.10 release notes (Feb 2026 to May 2026) are preserved in git history and on the `v0` branch. The 0.0.x line is end-of-life; consumers pin to `^1.0.0` going forward.
