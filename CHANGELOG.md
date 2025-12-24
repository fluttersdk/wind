# Changelog

All notable changes to this project will be documented in this file.

This project follows [Semantic Versioning 2.0.0](https://semver.org/spec/v2.0.0.html).

---

## [1.1.0] - 2025-12-24

### ✨ New Features

#### BorderParser
- New `BorderParser` for border and rounded utility classes
- **Border width**: `border`, `border-0`, `border-2`, `border-4`, `border-8`
- **Directional borders**: `border-t`, `border-r`, `border-b`, `border-l`
- **Border colors**: `border-{color}-{shade}`, `border-[#hex]`
- **Border styles**: `border-solid`, `border-none`
- **Border radius**: `rounded`, `rounded-sm`, `rounded-md`, `rounded-lg`, `rounded-xl`, `rounded-2xl`, `rounded-3xl`, `rounded-full`, `rounded-none`
- **Directional radius**: `rounded-t`, `rounded-r`, `rounded-b`, `rounded-l`, `rounded-tl`, `rounded-tr`, `rounded-bl`, `rounded-br`

#### Theme Customization
- Added `borderWidths` to `WindThemeData` for customizable border widths
- Added `borderRadius` to `WindThemeData` for customizable border radius
- New defaults: `defaults/border_widths.dart`, `defaults/border_radius.dart`
- BorderParser now reads values from theme (user can override defaults)

### 📚 Documentation
- Added `docs/borders.md` with Tailwind-style documentation and `x-preview` components
- New example pages: `/borders/radius_basic`, `/borders/width_basic` (iframe ready)

### 🧪 Tests
- Added 20 BorderParser unit tests
- Added 8 WDiv border widget tests (feature tests)
- Total: 239 tests passing

---

## [1.0.0] - 2025-12-24

### 🚀 Major Release - Complete Architectural Rewrite

This release represents a complete rewrite of the Wind framework with a new architecture inspired by TailwindCSS and Laravel Artisan philosophies.

### ⚠️ Breaking Changes

- **Removed all v0 widgets**: `WCard`, `WFlex`, `WFlexible`, `WContainer`, `WGap` are no longer available
- **New widget system**: Use `WDiv`, `WText`, `WAnchor` instead
- **Theme API changed**: `WindTheme.toThemeData()` replaced with `WindTheme` widget wrapper
- **Class name syntax updated**: Some utility class names have been standardized

### ✨ New Features

#### New Widget System
- **`WDiv`**: The fundamental building block - dynamically builds `Column`, `Row`, `GridView`, or `Wrap` based on display type
- **`WText`**: Specialized typography widget with full text utility support
- **`WAnchor`**: Interactive wrapper for hover, focus, and disabled state management

#### New Parsing Engine
- **`WindParser`**: Central parser with static caching for optimized performance
- **`WindStyle`**: Immutable style data object containing all resolved properties
- **`WindContext`**: Context object with theme, screen size, platform, and state information

#### Specialist Parsers (7 Total)
- **`DisplayParser`**: `block`, `flex`, `grid`, `wrap`, `hidden`
- **`BackgroundParser`**: Colors, images, gradients, positioning, repeat
- **`TextParser`**: Colors, sizes, weights, alignment, decoration, transform, clamp
- **`SizingParser`**: Width, height, min/max constraints, fractions
- **`PaddingParser`**: All padding variants (`p-`, `px-`, `py-`, `pt-`, etc.)
- **`MarginParser`**: All margin variants (`m-`, `mx-`, `my-`, `mt-`, etc.)
- **`FlexboxGridParser`**: Flex direction, justify, align, gap, grid columns

#### State-Based Styling
- **`hover:`** - Styles applied on hover (requires `WAnchor`)
- **`focus:`** - Styles applied on focus (requires `WAnchor`)
- **`disabled:`** - Styles applied when disabled (requires `WAnchor`)

#### Platform Prefixes
- **`ios:`**, **`android:`**, **`web:`**, **`macos:`**, **`windows:`**, **`linux:`**, **`mobile:`**

#### Responsive Breakpoints
- **`sm:`** (640px), **`md:`** (768px), **`lg:`** (1024px), **`xl:`** (1280px), **`2xl:`** (1536px)

#### Dark Mode Support
- **`dark:`** prefix for dark-mode-only styles
- Automatic color inversion via `WindThemeData.brightness`

#### CSS-Like Text Inheritance
- Text styles cascade from parent `WDiv` to child `WText` via `DefaultTextStyle`

### 🛠 Technical Improvements

- **Immutable Styles**: `WindStyle` is `@immutable` with proper `==` and `hashCode`
- **Static Caching**: Parsed styles are cached by compound key for performance
- **"Last Class Wins"**: Conflicting classes resolved by taking the last one
- **Intelligent Composition**: Widgets only wrap with decorators when needed

### 📦 New Theme Defaults
- Colors: Full Tailwind color palette (slate, gray, red, orange, amber, yellow, lime, green, emerald, teal, cyan, sky, blue, indigo, violet, purple, fuchsia, pink, rose)
- Font Sizes: xs, sm, base, lg, xl, 2xl, 3xl, 4xl, 5xl, 6xl
- Font Weights: thin, extralight, light, normal, medium, semibold, bold, extrabold, black
- Tracking: tighter, tight, normal, wide, wider, widest
- Leading: tight, snug, normal, relaxed, loose

### 🐛 Bug Fixes
- Fixed `getSpacing('full')` to return `double.infinity` (#3)

### 📚 Documentation
- Complete system instruction for AI assistants
- Comprehensive test suite (212 tests passing)

---

## [0.0.4] - 2025-06-12

- Updated `platform_info` dependency to `^5.0.0` for improved platform detection.

## [0.0.3] - 2025-06-09

### Added
- Display Control (`hide`, `show`) utility classes
- `DisplayParser` for handling display-related utilities
- New example page for display utilities

### Changed
- Improved debug logging for widgets
- `WFlexible.child` is now nullable
- `WContainer` wraps with `ClipRRect` when `borderRadius` is specified

### Fixed
- Alignment mapping for `alignment-left` and `alignment-right`
- Text alignment handling

## [0.0.2] - 2025-02-02

- Added Github workflow for publishing package to pub.dev
- Updated README.md with installation and usage instructions
- Added example application

## [0.0.1] - 2025-01-29

- Initial release
