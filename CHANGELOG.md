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
- **`wind-ui` skill v2.0.1 community pattern**: `skills/wind-ui/SKILL.md` section 15 plus `skills/wind-ui/references/community.md` add opt-in star + issue-report CTAs surfaced once per session after a verified Wind task or a genuine wind-side bug. Prose-permission only, never auto-executed, `gh auth status`-gated. (#89)

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

- `WInput`: `px-*` horizontal padding now matches the requested value exactly; `OutlineInputBorder.gapPadding` is set to `0.0` so `px-3` produces a 12 px inset instead of 16 px. Multiline geometry unchanged. (#61)
- `WindParser.findAndGroupClasses`: duplicate tokens flow through to the parser pipeline so the documented last-class-wins contract holds on repeated overrides like `top-8 top-4 top-8`; previously `.toSet()` dropped the trailing occurrence.
- `WindParser.parse`: cache is bypassed in both directions (no read, no write) when `baseStyle` is non-null so per-call styles do not return stale cached entries or poison the cache slot for default-flag callers.
- `example/lib/routes.dart`: six widget routes (`/widgets/w-input-multiline`, `/widgets/w-input-search`, `/widgets/w-popover-alignment`, `/widgets/w-select_multi`, `/widgets/w-select_single`, `/widgets/w-text-transform`) renamed to snake_case to match their page-file basenames so live doc iframes at `wind.fluttersdk.com/preview/widgets/<key>` resolve. Two dead pages (`layout/grid_basic`, `layout/order`) without documentation references were removed.

### Quality

- 1,214 tests across 82 test files; line coverage 90.2% (CI gate enforces `>= 90%` via `./tool/coverage.sh 90`).
- New regression coverage in `test/parser/wind_parser_cache_test.dart` for the last-class-wins-on-duplicates and `baseStyle`-bypasses-cache contracts.
- `tool/coverage.sh` portable threshold-aware lcov wrapper; GitHub Actions gate fails any PR dropping below 90%.
- Surgical `// coverage:ignore-line` pragmas only on lines structurally unreachable from `flutter test` (`kDebugMode` branches, `dart:io` `Platform.is*` branches not matching the CI host). Each pragma carries a one-line WHY comment.

Production deps: `flutter` (SDK), `flutter_svg ^2.0.0`, `fluttersdk_wind_diagnostics_contracts ^1.0.0`. Dev deps: `flutter_test` (SDK), `flutter_lints ^5.0.0`. Full v1 documentation at [fluttersdk.com/wind](https://fluttersdk.com/wind); LLM-facing skill at `skills/wind-ui/` distributed via [fluttersdk/ai](https://github.com/fluttersdk/ai) (`npx skills add fluttersdk/ai --skill wind-ui`).

---

## Previous versions

The 1.0.0-alpha.1 through 1.0.0-alpha.10 release notes (Feb 2026 to May 2026) are preserved in git history and on the `v0` branch. The 0.0.x line is end-of-life; consumers pin to `^1.0.0` going forward.
