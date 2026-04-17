# Changelog

All notable changes to this project will be documented in this file.

This project follows [Semantic Versioning 2.0.0](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Added
- **Child Order**: `order-0` through `order-12`, `order-first`, `order-last`, `order-none`, and arbitrary `order-[n]` (including negatives) for reordering flex children without changing source order. Stable-sort preserves insertion order among equal-order children. (#53)
- **Reverse Flex Direction**: `flex-row-reverse` and `flex-col-reverse` flip the main-axis direction via `Row.textDirection` / `Column.verticalDirection`, so `justify-start` mirrors to match CSS semantics (not just a visual list reversal). Applied after `order-*` sorting and works with responsive prefixes. (#53)
- **WBreakpoint**: New widget for declarative breakpoint-keyed widget trees. Takes `base` plus optional `sm`/`md`/`lg`/`xl`/`xxl` builders and a `custom` map for user-defined screens from `WindThemeData.screens`. Walks the screen chain descending, returns the builder for the highest breakpoint ≤ active width, falls back to `base`. Escape hatch for cases where className prefixes aren't enough (different widget types, different child counts). (#55)
- **Inline Color Props**: `WDiv.backgroundColor` and `WText.foregroundColor` for runtime-dynamic colors (color picker, per-tenant brand). Overrides any `bg-*` / `text-*` from `className` and does not participate in the parser cache key, so a dragging color picker no longer bloats the cache the way `bg-[#$hex]` interpolation would. Added `WindParser.cacheSize` for cache-behavior assertions in tests. (#59)

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

- Full docs: [wind.fluttersdk.com](https://wind.fluttersdk.com)
- Example app: `/example`

---

## Previous Versions

See [full changelog](https://github.com/fluttersdk/wind/blob/main/CHANGELOG.md) for alpha.9 through 0.0.1 release notes.
