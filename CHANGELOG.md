# Changelog

All notable changes to this project will be documented in this file.

This project follows [Semantic Versioning 2.0.0](https://semver.org/spec/v2.0.0.html).

---

## [1.0.0] - 2026-05-21

The first stable release. Wind ships a complete utility-first styling layer for Flutter with className syntax, theming, responsive breakpoints, dark mode, dynamic JSON rendering, an MCP server for AI assistants, and a contracts-based debug bridge for external tooling. All public APIs in this release are considered stable; the surface follows Semantic Versioning from this point on.

### What's in the v1 surface

**Widgets (19 user-facing):** `WDiv`, `WText`, `WButton`, `WInput`, `WSelect`, `WCheckbox`, `WIcon`, `WImage`, `WSvg`, `WPopover`, `WAnchor`, `WBreakpoint`, `WSpacer`, `WDatePicker`, `WDynamic`, plus the FormField wrappers `WFormInput`, `WFormSelect`, `WFormMultiSelect`, `WFormCheckbox`, `WFormDatePicker`.

**Parsers (17):** background (color, gradient, image), border, ring, shadow, opacity, padding, margin, sizing, flexbox + grid, position (relative + absolute + insets), order, overflow, aspect-ratio, z-index, text (font-size / weight / family / tracking / leading / decoration / transform / align / overflow), animation, transition (duration + easing), svg fill/stroke + preserve-colors, debug.

**Theme (`WindThemeData` exposes 23 configurable fields):** brightness, colors, screens, containers, fontSizes, fontWeights, tracking, leading, borderWidths, borderRadius, fontFamilies, ringWidths, ringOffsets, applyDefaultFontFamily, syncWithSystem, baseSpacingUnit, ringColor, opacities, zIndices, shadows, transitionDurations, transitionCurves, animations.

**External integrations:** `Wind.installDebugResolver()` for the new `fluttersdk_wind_diagnostics_contracts` bridge (used by `fluttersdk_dusk` for E2E and any runtime inspector). Wind MCP server at `mcp.fluttersdk.com/wind` for AI coding assistants.

### Fixed (since the last published alpha, 1.0.0-alpha.6)

- `WInput`: `px-*` horizontal padding now matches the requested value on both single-line and multiline. Previously every `OutlineInputBorder` defaulted to `gapPadding: 4.0` (Material's reservation for a floating-label cutout), adding a phantom `+4px` on each horizontal edge. Wind routes labels through the parser and never uses `InputDecoration.labelText`, so the gap had no purpose. Setting `gapPadding: 0.0` on the built border yields exact `px-*` semantics: `px-3` now produces a 12 px inset instead of 16 px. Multiline `minLines`/`maxLines` geometry unchanged. (#61)

### Added (since 1.0.0-alpha.6)

The intermediate alphas 1.0.0-alpha.7 through 1.0.0-alpha.10 were not published to pub.dev. Their work is summarized here and laid out in detail in the per-alpha sections below.

- **`WBreakpoint` widget**: declarative per-breakpoint widget tree builder. Use it as an escape hatch when className prefixes (`sm:`, `md:`, `lg:`) are not enough because the widget structure itself changes between breakpoints. (alpha-9, #58)
- **CSS positioning utilities**: `relative`, `absolute`, `top-*`, `right-*`, `bottom-*`, `left-*`, `inset-*` plus negative variants and arbitrary-px values (`top-[24px]`). Layers a `Stack` / `Positioned` over the existing rendering. (alpha-6, #49)
- **Child order utilities**: `order-0` through `order-12`, `order-first`, `order-last`, `order-none`, and arbitrary `order-[n]` for reordering flex children without changing source order. (alpha-9, #57)
- **Reverse flex direction**: `flex-row-reverse` and `flex-col-reverse` map to `Row.textDirection` / `Column.verticalDirection`, so `justify-start` mirrors per CSS semantics. (alpha-9, #57)
- **Inline color props**: `WDiv.backgroundColor` and `WText.foregroundColor` for runtime-dynamic colors (per-tenant brand, color picker, etc.). Overrides any `bg-*` / `text-*` from className and stays out of the parser cache key, so a dragging color picker no longer bloats the cache the way `bg-[#$hex]` interpolation would. (alpha-9, #60)
- **Accessibility / Semantics on 6 interactive widgets**: `WAnchor`, `WButton`, `WInput`, `WFormInput`, `WCheckbox`, `WSelect`, `WDatePicker` now emit `Semantics` nodes (`button: true`, `textField: true`, `obscured` for passwords, etc.) so the Flutter web accessibility tree surfaces a role + label per widget. Enables Playwright `getByRole` / `getByLabel` / `getByText` resolution against Flutter web. New optional `WInput.semanticLabel` parameter for form wrappers. (alpha-9)
- **Contracts-based debug bridge**: new production dep `fluttersdk_wind_diagnostics_contracts: ^1.0.0`. Call `Wind.installDebugResolver()` inside `kDebugMode` to expose Wind state per widget (className, breakpoint, brightness, platform, states, bgColor, textColor) to any consumer of `WindDebugRegistry.current`. Used by `fluttersdk_dusk` for E2E snapshot capture; works for any inspector / IDE tool that wants the same data. (alpha-10, #62)

### Removed (BREAKING since 1.0.0-alpha.6)

- `WindDuskIntegration` class and `lib/dusk_integration.dart` sub-barrel are gone. Replaced by `Wind.installDebugResolver()` from the main barrel. (alpha-9 + alpha-10)
- `fluttersdk_dusk` is no longer a Wind dependency at any level (was a prod dep in alpha-8 and earlier, briefly a dev_dep in alpha-9, fully dropped in alpha-10). Consumers that need Dusk for their own E2E tests add it to their own pubspec. (alpha-10)
- The 50+ optional `WindStyle` fields the old dusk integration emitted in snapshot YAML are reduced to the 6 core fields the contracts package codifies: `className`, `breakpoint`, `brightness`, `platform`, `states`, `bgColor`, `textColor`. The provenance flag (`WindParser.parse(... trackProvenance: true)`) is dropped; revisit in v1.x if consumer demand surfaces.

### Migration from 1.0.0-alpha.6

If your app already runs against `1.0.0-alpha.6`, the only mandatory change is the debug-bridge wiring. The W-widget surface, theming, and parser-token set are source-compatible additions on top of alpha-6.

If you were using `WindDuskIntegration` (only consumers running Dusk against their own apps):

```dart
// Before (alpha-8 and earlier):
import 'package:fluttersdk_wind/fluttersdk_wind.dart';
if (kDebugMode) {
  WindDuskIntegration.install();
}

// After (1.0.0):
import 'package:fluttersdk_wind/fluttersdk_wind.dart';
if (kDebugMode) {
  Wind.installDebugResolver();
}
```

If you do not use Dusk: no migration needed. Drop in `1.0.0`, update your pubspec, run `flutter pub get`.

### Documentation

Full documentation moved to **[fluttersdk.com/wind](https://fluttersdk.com/wind)**. Every widget, parser, and theme field has a dedicated page with live examples and an LLM-friendly cheat-sheet under `skills/wind-ui/`.

---

## [1.0.0-alpha.10] - 2026-05-21

### BREAKING

- Removed `fluttersdk_dusk` dev_dependency entirely (was a dev_dep in alpha-9). Wind no longer compile-time depends on dusk for diagnostics; the new neutral bridge package `fluttersdk_wind_diagnostics_contracts` replaces that coupling.
- DELETED `lib/src/dusk_integration.dart` (503 LoC, the old enricher), `lib/dusk_integration.dart` (sub-barrel), `test/dusk_integration_test.dart` (750 LoC, 43 tests; 40 reborn as `test/debug_resolver_test.dart`, 3 dropped).
- `WindDuskIntegration.install()` REMOVED. Consumers migrate to `Wind.installDebugResolver()`.
- Lost vs alpha-9: 50+ optional WindStyle fields in the snapshot YAML (alpha-10 emits only 6 core: className, breakpoint, brightness, platform, states, bgColor, textColor). Provenance feature dropped (revisit V1.x with consumer signal).

### Added

- New production dep `fluttersdk_wind_diagnostics_contracts: ^1.0.0-alpha.1`: abstract `WindDebugResolver` contract + static `WindDebugRegistry`. Bridge between Wind and any debug-tooling package without compile-time coupling.
- `lib/src/debug_resolver.dart`: concrete `WindDebugResolverImpl` implementing the contract.
- `lib/src/wind_facade.dart`: `Wind` static facade exposing `Wind.installDebugResolver()` (kDebugMode-gated, idempotent).

### Migration

```dart
// alpha-9:
import 'package:fluttersdk_wind/dusk_integration.dart';
if (kDebugMode) {
  DuskPlugin.install();
  WindDuskIntegration.install();
}

// alpha-10:
import 'package:fluttersdk_wind/fluttersdk_wind.dart';  // main barrel only
if (kDebugMode) {
  DuskPlugin.install();
  Wind.installDebugResolver();
}
```

---

## [1.0.0-alpha.9] - 2026-04-17

> Internal alpha — not published to pub.dev. Content rolled into 1.0.0.

### BREAKING

- Dependency migration: `fluttersdk_dusk` moved from `dependencies:` to `dev_dependencies:`. Vanilla wind consumers no longer pull dusk transitively. Consumers wanting the WindDuskIntegration enricher must add `fluttersdk_dusk` to their own pubspec and switch their import path (see migration below).
- Barrel removal: `WindDuskIntegration` and `windClassNameEnricher` are no longer exported from the main `package:fluttersdk_wind/fluttersdk_wind.dart` barrel. The class and function names are unchanged; only the import path moves.
- New opt-in sub-barrel at `lib/dusk_integration.dart`. Consumer migration:

  Replace:
  ```dart
  import 'package:fluttersdk_wind/fluttersdk_wind.dart';
  // ... WindDuskIntegration.install();
  ```
  With:
  ```dart
  import 'package:fluttersdk_wind/fluttersdk_wind.dart';
  import 'package:fluttersdk_wind/dusk_integration.dart';
  // ... WindDuskIntegration.install();
  ```

  The `package:fluttersdk_wind/fluttersdk_wind.dart` import stays for the W-widget surface (WDiv, WButton, WindParser, etc.).

- Version bumped to `1.0.0-alpha.9` (BREAKING removal allowed in alpha cycle).

### Added
- **Accessibility / Semantics**: 6 interactive widgets now wrap their build tree with a `Semantics(...)` node so the Flutter web accessibility tree surfaces a role + label for each. `WAnchor` (and therefore the entire `WButton` family that wraps it) emits `button: true` with a merged label from its child Text/WText subtree via `MergeSemantics`. `WInput` and `WFormInput` emit `textField: true` with the placeholder (or the form-field `label`) as the Semantics label, the current text as Semantics value, and `obscured: true` for password inputs. `WCheckbox` emits a `checked` state. `WSelect` emits `button: true` with the placeholder or selected option label. `WDatePicker` emits `textField: true` with the placeholder as label and the ISO-formatted date as value. The wraps are additive: no existing styling, className, state, or callback behavior changes. New optional `WInput.semanticLabel` parameter lets form wrappers override the placeholder-derived Semantics label without changing the visual placeholder. Enables Playwright `getByRole` / `getByLabel` / `getByText` to resolve against the Flutter web build without per-widget caller-side annotation.
- **Child Order**: `order-0` through `order-12`, `order-first`, `order-last`, `order-none`, and arbitrary `order-[n]` (including negatives) for reordering flex children without changing source order. Stable-sort preserves insertion order among equal-order children. (#53)
- **Reverse Flex Direction**: `flex-row-reverse` and `flex-col-reverse` flip the main-axis direction via `Row.textDirection` / `Column.verticalDirection`, so `justify-start` mirrors to match CSS semantics (not just a visual list reversal). Applied after `order-*` sorting and works with responsive prefixes. (#53)
- **WBreakpoint**: New widget for declarative breakpoint-keyed widget trees. Takes `base` plus optional `sm`/`md`/`lg`/`xl`/`xxl` builders and a `custom` map for user-defined screens from `WindThemeData.screens`. Walks the screen chain descending, returns the builder for the highest breakpoint ≤ active width, falls back to `base`. Escape hatch for cases where className prefixes aren't enough (different widget types, different child counts). (#55)
- **Inline Color Props**: `WDiv.backgroundColor` and `WText.foregroundColor` for runtime-dynamic colors (color picker, per-tenant brand). Overrides any `bg-*` / `text-*` from `className` and does not participate in the parser cache key, so a dragging color picker no longer bloats the cache the way `bg-[#$hex]` interpolation would. Added `WindParser.cacheSize` for cache-behavior assertions in tests. (#59)
- **Dusk Integration Enrichment (Wave 2)**: `WindStyle` gains an optional nullable `resolvedVia` field (debug metadata; excluded from `==` / `hashCode`, included in `toString`). `WindParser.parse()` gains an opt-in `bool trackProvenance = false` named argument (default OFF; dead-branch eliminated via const propagation at release; cache bypassed when flag is true to preserve stable cache identity). Wind dusk integration enricher now emits 60+ `WindStyle` fields additively under the existing YAML snapshot key (the 6 original field names are fully preserved). `WindDuskIntegration.enableProvenance(bool)` toggle gates `resolvedVia:` emission per enricher call. New `test/dusk_integration_test.dart` with 43 test cases covering enricher output, provenance toggle, and zero-cost default.

### 🐛 Bug Fixes

- **Flex in Scrollable Axis**: `flex-1` / `flex-N` children inside `flex-row` + `overflow-x-auto|scroll` (or `flex-col` + `overflow-y-auto|scroll`) no longer throw "RenderFlex children have non-zero flex but incoming constraints are unbounded." The parent now signals via `WindFlexOverflowScope` so direct flex children skip `Expanded`/`Flexible` wrapping for that render pass. Responsive variants (`base:overflow-x-auto sm:overflow-visible` + `sm:flex-1`) work end-to-end. (#54)

---

## [1.0.0-alpha.6] - 2026-04-04

### Added
- **CSS Positioning**: `relative` and `absolute` position types with Stack/Positioned rendering
- **Offset Utilities**: `top-*`, `right-*`, `bottom-*`, `left-*` offset tokens using spacing scale
- **Inset Shortcuts**: `inset-*`, `inset-x-*`, `inset-y-*` for multi-side offsets
- **Negative Offsets**: `-top-*`, `-inset-*` for negative positioning
- **Arbitrary Position Values**: `top-[24px]`, `left-[12px]` bracket syntax (px only)

---

## [1.0.0-alpha.5] - 2026-03-31

### 🐛 Bug Fixes

- **Flex Space Distribution**: flex-1 + justify-between no longer breaks layout — shrink-0 children are skipped during container-level Flexible wrapping (#45)
- **shrink-0 Semantics**: shrink-0 no longer creates a Flexible wrapper — correctly preserves intrinsic size matching CSS flex-shrink: 0 behavior (#45)

### 🔧 Improvements

- **GitHub Copilot Config**: Added Copilot instructions converted from Claude Code configuration (#46)

---

## [1.0.0-alpha.4] - 2026-03-24

### ✨ New Features

- **WDynamic Custom Icons**: `customIcons` prop for user-defined icon mappings in dynamic rendering
- **Theme Callbacks**: `onThemeChanged` callback on `WindTheme` — fires on user-initiated theme toggles for persistence
- **Reset to System Theme**: `resetToSystem()` method on `WindThemeController` — re-enables automatic system brightness sync
- **SVG Preserve Colors**: `preserve-colors` utility class to skip ColorFilter on `WSvg`, ideal for QR codes and multi-color logos

### 🐛 Bug Fixes

- **WButton Spinner Size**: Increased default loading spinner size from 16 to 20 for better visibility
- **WButton Spinner Color**: Spinner now falls back to text color, then auto-computes contrast via W3C luminance when no color is resolvable

### 🔧 Improvements

- **CI/CD**: Replaced ci.yml with deploy.yml for web build and SSH deployment pipeline
- **Security**: Added SECURITY.md and Dependabot configuration
- **Developer Experience**: Added CLAUDE.md, path-scoped rules, and editor hooks for AI-assisted development
- **Community**: Added GitHub issue templates (bug report, feature request, documentation) and LLM skill community features

---

## [1.0.0-alpha.2] - 2026-02-05

### 📦 Package Improvements

- **Description**: Shortened package description to comply with pub.dev 180-character limit
- **Publishing**: Enhanced pub.dev compatibility and package metadata

---

## [1.0.0-alpha.1] - 2026-02-05

### 🎉 First Alpha Release

Wind v1.0.0-alpha.1 is the first public preview of the complete architectural rewrite. This release focuses on code quality, CI/CD infrastructure, and a solid foundation for v1 stable.

### ✨ Core Features

**Widgets:**
- `WDiv` - Utility-first container (flex, grid, wrap, overflow)
- `WText` - Typography with cascading styles
- `WInput` / `WFormInput` - Form inputs with validation
- `WButton` - Interactive button with loading states
- `WCheckbox` / `WFormCheckbox` - Styled checkboxes
- `WSelect` / `WFormSelect` / `WFormMultiSelect` - Dropdowns with search & tagging
- `WDatePicker` / `WFormDatePicker` - Calendar date picker
- `WPopover` - Overlay positioning system
- `WIcon`, `WImage`, `WSvg`, `WSpacer` - Media & spacing
- `WAnchor` - State management for hover/focus/custom states
- `WKeyboardActions` - iOS keyboard toolbar

**Utility Classes:**
- Layout: `flex`, `grid`, `wrap`, `gap-*`, sizing, spacing
- Typography: `text-*`, `font-*`, `uppercase`, `underline`
- Colors: `bg-*`, `text-*`, `border-*` with opacity modifiers
- Effects: `shadow-*`, `opacity-*`, `ring-*`, `rounded-*`
- States: `hover:`, `focus:`, `disabled:`, `loading:`, custom states
- Responsive: `sm:`, `md:`, `lg:`, `xl:`, `2xl:`
- Platform: `ios:`, `android:`, `web:`, `mobile:`
- Dark Mode: `dark:` prefix support

**Theme System:**
- `WindTheme` / `WindThemeData` - Customizable design tokens
- Runtime theme toggling
- Tailwind-compatible color palette

### 🔧 Quality & Infrastructure

- **Zero Analyzer Issues**: Full `flutter_lints` 5.0.0 compliance
- **835 Tests Passing**: Comprehensive coverage
- **CI/CD**: GitHub Actions with OIDC publishing
- **Flutter 3.29+**: Latest stable APIs

### 📦 Dependencies

- `flutter_svg: ^2.0.0` - SVG rendering
- `keyboard_actions: ^4.2.1` - iOS keyboard management
- `flutter_lints: ^5.0.0` - Code quality

### ⚠️ Breaking Changes

Complete rewrite from v0. Migration requires updating all widget names and class syntax.

### 📚 Documentation

- Full docs: [fluttersdk.com/wind](https://fluttersdk.com/wind)
- Example app: `/example`

---

## Previous Versions

See [full changelog](https://github.com/fluttersdk/wind/blob/v1/CHANGELOG.md) for alpha.9 through 0.0.1 release notes.
