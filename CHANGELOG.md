# Changelog

All notable changes to this project will be documented in this file.

This project follows [Semantic Versioning 2.0.0](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Added

- `WInput`: debug `AssertionError` when both `value` and `controller` are supplied simultaneously; passing both was always a logic error and previously led to silent precedence behavior (controller wins). The assert surfaces the misuse immediately in debug builds (W2).

### Changed

- `WInput`: selection handles are now Cupertino-style on all platforms (previously Material-style on Android/web). The context menu reads `WidgetsLocalizations` so copy/cut/paste labels work under any ancestor, including bare `WidgetsApp`. This is a visual change on Android and web; behavior is identical.
- `doc/layout/flexbox.md` and the `wind-ui` skill: layout-stability guidance added for `IntrinsicHeight`/`IntrinsicWidth` in animated subtrees; the safe alternative is `Stack`+`Positioned` or `items-stretch` (W3).

### Fixed

- `WInput` now renders Material-free (`EditableText` core, `BoxDecoration` border/padding) and no longer crashes under a non-Material ancestor such as a bare `WidgetsApp` or Cupertino app. Wrapping `WInput` in a `MaterialApp` is no longer required. (#102)
- `WInput` emits a single clean `textField` semantics node; the previous implementation produced a double-textbox node under the old `MergeSemantics > TextField` wrapping (W1). Dusk snapshot consumers relying on a single textbox node per `WInput` can expect clean output from this release (pairs with dusk D2).

---

## [1.0.0] - 2026-06-09

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
- **`self-*` align-self shorthand**: `self-start`, `self-end`, `self-center`, `self-stretch`, `self-auto`, `self-baseline` as aliases for the `align-self-*` long form, matching Tailwind's canonical class name.
- **Flex grow / basis tokens**: `grow` (Tailwind shorthand for `flex-grow`, i.e. `flex: 1`), `grow-0` (no grow), and `basis-1/2` / `basis-1/3` / `basis-1/4` / `basis-full` / `basis-[Npx]`. Basis approximates CSS `flex-basis`: it sets the child's initial MAIN-axis size (width in a row, height in a column) and ignores grow/shrink interplay. The no-grow / no-shrink resets follow last-class-wins: `grow-0` cancels an earlier `grow`/`flex-grow`/`flex-N`, `shrink-0` cancels an earlier `shrink`/`flex-shrink`, and `flex-none` (`flex: 0 0 auto`) cancels both, within the same active class list.
- **Smart column cross-axis stretch**: a `flex flex-col` with no explicit `items-*` token now stretches each `WDiv`, `WAnchor` (any child), and `WButton` child that does not control its own width to the column width (CSS `align-items: stretch` default), so a clickable nav row (`WAnchor(onTap) > WDiv`) fills the column width without an explicit `items-stretch` or `w-full`. For a `WAnchor`: when it wraps a `WDiv`, the inner `WDiv`'s className decides; when it wraps a `WText` or raw widget, it always stretches. Children that self-wrap in `Expanded`/`Flexible` (`grow`, `flex-grow`, `flex-auto`, `flex-initial`, `shrink`, `flex-shrink`, `flex-N`, in any state/breakpoint variant), children with an explicit `w-*` / `min-w-*` / `max-w-*` (including `w-full`), absolute children, bare `WText` leaves, and raw Flutter widgets are left untouched. `shrink-0` / `flex-none` children still stretch on the cross axis (their no-shrink effect is main-axis only, matching CSS). Rows are unaffected.
- **Inline color props**: `WDiv.backgroundColor` and `WText.foregroundColor` for runtime-dynamic colors. Override any `bg-*` / `text-*` from className and stay out of the parser cache key.
- **`WBreakpoint` widget**: declarative per-breakpoint widget tree builder. Reach for it when className prefixes are not enough because the widget structure itself changes between breakpoints.
- **`WDynamic`**: JSON-driven widget tree renderer. 13 Wind types + 16 Flutter core types allowed by default, extensible via `builders:`, restrictable via `denyWidgets:`, with `customIcons:` for user-defined icon mappings (24 built-in glyphs). State binding by widget `id`, action dispatch via `WActionHandler`, max recursion depth 50.
- **Accessibility / Semantics** on 7 interactive widgets (`WAnchor`, `WButton`, `WInput`, `WFormInput`, `WCheckbox`, `WSelect`, `WDatePicker`): emit `Semantics` nodes with role + label, password fields mark `obscured`. Enables Playwright `getByRole` / `getByLabel` / `getByText` resolution against the Flutter web build. New optional `semanticLabel` parameters on `WInput`, `WButton`, and `WAnchor`; the button/anchor label gives icon-only controls an accessible name when there is no child text for `MergeSemantics` to absorb.
- **`Wind.installDebugResolver()`**: call inside `kDebugMode` to register a `WindDebugResolverImpl` against the new `fluttersdk_wind_diagnostics_contracts` bridge. Resolves 7 fields per Wind widget element: `className`, `breakpoint`, `brightness`, `platform`, `states`, conditional `bgColor`, conditional `textColor`. Consumed by `fluttersdk_dusk` for E2E snapshot capture and by any runtime inspector. Tree-shaken in release builds.
- **`wind-ui` skill v2.0.2 community pattern**: `skills/wind-ui/SKILL.md` section 15 plus `skills/wind-ui/references/community.md` add opt-in star + issue-report CTAs surfaced once per session after a verified Wind task or a genuine wind-side bug. Prose-permission only, never auto-executed, `gh auth status`-gated. (#89)

### Changed

- **BREAKING.** Complete API rewrite from 0.0.x. The legacy `lib/src/parsers/` (28 modules) and `lib/src/components/` (8 modules) directories were deleted and reimplemented under `lib/src/parser/parsers/` and `lib/src/widgets/`. Class names `WText`, `WDiv`, `WButton` are preserved but their constructor signatures, the className token set they accept, and theme integration differ. Not source-compatible with v0.
- **BREAKING.** Flutter SDK minimum raised from `>=3.3.0` to `>=3.27.0`. Dart SDK constraint set to `>=3.4.0 <4.0.0`.
- **BREAKING.** Parser cache is now always on. The opt-in `trackProvenance` flag on `WindParser.parse()` and the `WindStyle.resolvedVia` field are gone; debug-tooling consumers read widget state through `Wind.installDebugResolver()` and the `fluttersdk_wind_diagnostics_contracts` contract package instead.
- **BREAKING.** The public `DatePickerMode` enum is renamed to `WDatePickerMode`. The old name collided with Flutter Material's own `DatePickerMode`, forcing any consumer importing both `package:flutter/material.dart` and the wind barrel to `hide` one symbol. `WDatePicker` / `WFormDatePicker` `mode:` now takes `WDatePickerMode`.

### Removed

- **BREAKING.** `WindDuskIntegration` class and the `lib/dusk_integration.dart` sub-barrel. Replaced by `Wind.installDebugResolver()` from the main barrel.
- **BREAKING.** `fluttersdk_dusk` as a wind dependency at any level. Consumers needing Dusk for their own E2E add it to their own pubspec.
- **BREAKING.** `google_fonts` and `platform_info` dependencies. Consumers depending on them transitively must add explicit deps.
- **BREAKING.** `WindParser.parse(trackProvenance:)` parameter, `WindStyle.resolvedVia` field, and the `enableProvenance()` toggle. The contracts-based diagnostic bridge does not require provenance instrumentation.
- **BREAKING.** 13 internal parser classes (`AspectRatioParser`, `BackgroundParser`, `BorderParser`, `FlexboxGridParser`, `MarginParser`, `OpacityParser`, `OverflowParser`, `PaddingParser`, `RingParser`, `SizingParser`, `TextParser`, `TransitionParser`, `ZIndexParser`), `WindPlatformService`, `WindLogger`, `LogEntry`, `WDynamicRenderer`, and `WindDebugResolverImpl` are no longer exported from the public barrel (`package:fluttersdk_wind/fluttersdk_wind.dart`). These were always internal implementation details; any consumer referencing them by name must remove those references. The public widget and theme API is unaffected.

### Fixed

- `WText` bare rendering: a `WText` used outside a `MaterialApp` / `Scaffold` now renders with a brightness-aware baseline color (`Colors.white` on dark platforms, `Colors.black` on light, read from `MediaQuery.platformBrightness`) instead of Flutter's debug yellow-underline fallback. When no `Directionality` ancestor exists, `WText` injects one defaulting to `TextDirection.ltr`. Explicitly supplied colors (`className text-*`, `foregroundColor`, `textStyle`) still win and are unaffected.
- Background image parser (`bg-[/abs/path]`): the `FileImage(File(...))` branch is now guarded by `kIsWeb`; on web, where `dart:io` `File` is unsupported, the image degrades gracefully (skipped) instead of throwing at runtime. Non-web behavior is unchanged. `pubspec.yaml` now declares explicit platform support (`android`, `ios`, `macos`, `web`, `linux`, `windows`) so pub.dev platform detection is not narrowed by the `dart:io` import graph.
- WASM compatibility: removed `dart:io` from the library import graph (`platform_service.dart` now uses `defaultTargetPlatform`; absolute-path `bg-[/...]` image resolution moved behind a conditional import). The package is now `is:wasm-ready`, raising the pana/pub.dev platform-support score to 20/20 (160/160). (#95)
- `max-w-prose`: corrected value from 1040 px (65 × 16, an incorrect approximation) to 512 px, matching the actual parser output. Docs and skill references updated accordingly.
- `WButton` / `WAnchor` `semanticLabel`: the `Semantics` node now sets `excludeSemantics: true` and lifts `onTap`/`onLongPress` onto itself when `semanticLabel` is set, so the label overrides any child text instead of concatenating with it under `MergeSemantics`, while activation is preserved.
- `Wind.installDebugResolver()`: the resolver no longer crashes on a className-less W-widget. `WindDebugResolverImpl.resolve` guarded its dynamic `className` read, so a bare `WAnchor` (or `WBreakpoint` / `WindAnimationWrapper` / `WKeyboardActions`) in the tree no longer throws `NoSuchMethodError` and abort the entire `fluttersdk_dusk` / telescope diagnostic snapshot.
- `WInput`: `px-*` horizontal padding now matches the requested value exactly; `OutlineInputBorder.gapPadding` is set to `0.0` so `px-3` produces a 12 px inset instead of 16 px. Multiline geometry unchanged. (#61)
- `WindParser.findAndGroupClasses`: duplicate tokens flow through to the parser pipeline so the documented last-class-wins contract holds on repeated overrides like `top-8 top-4 top-8`; previously `.toSet()` dropped the trailing occurrence.
- `WindParser.parse`: cache is bypassed in both directions (no read, no write) when `baseStyle` is non-null so per-call styles do not return stale cached entries or poison the cache slot for default-flag callers.
- `example/lib/routes.dart`: six widget routes (`/widgets/w-input-multiline`, `/widgets/w-input-search`, `/widgets/w-popover-alignment`, `/widgets/w-select_multi`, `/widgets/w-select_single`, `/widgets/w-text-transform`) renamed to snake_case to match their page-file basenames so live doc iframes at `wind.fluttersdk.com/preview/widgets/<key>` resolve. Two dead pages (`layout/grid_basic`, `layout/order`) without documentation references were removed.
- `BackgroundParser`: `bg-[#hex]` arbitrary-color backgrounds no longer also resolve to a bogus `AssetImage("assets/#hex")`. The image regex now excludes `#`-leading bracket values so a hex literal is parsed only as a color, eliminating a stray failed asset fetch on every arbitrary-hex background.
- `flex-none`: now means CSS `flex: 0 0 auto` (no grow AND no shrink). It no longer maps to a shrinking `FlexFit.loose`; instead it routes through the same no-shrink path as `shrink-0`, so a `flex-none` child in a `justify-between` row keeps its intrinsic size instead of being forced into a `Flexible` shrink allocation.
- `WindStyle.copyWith`: a padding-, margin-, or text-only style keeps `decoration == null` instead of fabricating an empty `BoxDecoration`. This stops `WDiv`/`WText` from wrapping a needless `Container` around non-decorated content. `shadow-none` likewise no longer forces a Container.
- `WDynamicRenderer`: malformed JSON degrades gracefully. A non-string `type` or non-list `children` is coerced defensively (routed through the whitelist / treated as no children) instead of throwing an implicit-downcast `TypeError` out of `build()`.
- `WindThemeData`: implements value-based `operator ==` and `hashCode`. The equality guards in `WindThemeController.setTheme` and `_WindThemeState.didUpdateWidget` now compare by value, so a fresh default `WindThemeData()` on a parent rebuild no longer clobbers a prior `toggleTheme()` choice or triggers spurious full-tree rebuilds.

### Quality

- 1,224 tests across 83 test files; line coverage 90.3% (CI gate enforces `>= 90%` via `./tool/coverage.sh 90`).
- New regression coverage in `test/parser/wind_parser_cache_test.dart` for the last-class-wins-on-duplicates and `baseStyle`-bypasses-cache contracts.
- New regression coverage for the arbitrary-hex background (`background_parser_test.dart`), `decoration`-stays-null contract (`wind_style_test.dart`), malformed-JSON graceful degradation (`w_dynamic_renderer_test.dart`), `WindThemeData` value equality (`wind_theme_data_test.dart`), and icon-only button Semantics label (`w_button_test.dart`).
- `tool/coverage.sh` portable threshold-aware lcov wrapper; GitHub Actions gate fails any PR dropping below 90%.
- Surgical `// coverage:ignore-line` pragmas only on lines structurally unreachable from `flutter test` (`kDebugMode` branches, `dart:io` `Platform.is*` branches not matching the CI host). Each pragma carries a one-line WHY comment.
- Final 1.0.0 QA gate: added permanent regression suites under `test/pixel/` (px-exact geometry + color via `getRect`/`getSize`/`renderObject`, no golden files), `test/interaction/` (tap/hover/focus/disabled/responsive/animation/overlay in-process), and `test/performance/` (parser cache hit/miss speedup ratio gate, ~26x, plus report-only large-tree pump timing). Validated live via a fresh consumer app driven by `fluttersdk_dusk` (all routes navigated, `wind:` enricher 7-field block confirmed, screenshots manually compared). No behavioral regressions found.

Production deps: `flutter` (SDK), `flutter_svg ^2.0.0`, `fluttersdk_wind_diagnostics_contracts ^1.0.0`. Dev deps: `flutter_test` (SDK), `flutter_lints ^5.0.0`. Full v1 documentation at [fluttersdk.com/wind](https://fluttersdk.com/wind); LLM-facing skill at `skills/wind-ui/` distributed via [fluttersdk/ai](https://github.com/fluttersdk/ai) (`npx skills add fluttersdk/ai --skill wind-ui`).

---

## Previous versions

The 1.0.0-alpha.1 through 1.0.0-alpha.10 release notes (Feb 2026 to May 2026) are preserved in git history and on the `v0` branch. The 0.0.x line is end-of-life; consumers pin to `^1.0.0` going forward.

[Unreleased]: https://github.com/fluttersdk/wind/compare/1.0.0...HEAD
[1.0.0]: https://github.com/fluttersdk/wind/releases/tag/1.0.0
