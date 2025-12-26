# Changelog

All notable changes to this project will be documented in this file.

This project follows [Semantic Versioning 2.0.0](https://semver.org/spec/v2.0.0.html).

---

## [1.0.0-alpha.5] - 2025-12-26

### ✨ New Features

#### Extended Widget Suite
- **WSelect**: Powerful dropdown with single/multi-select, search, pagination (infinite scroll), tagging (`onCreateOption`), and full custom builders.
- **WCheckbox**: Utility-first checkbox with `checked:` state styling and custom icon support.
- **WImage**: Network/Asset image wrapper with `object-fit`, `aspect-ratio`, and `rounded` utilities. Supports `asset://` schema.
- **WSvg**: SVG rendering with `fill-`, `stroke-` coloring and parent style inheritance.
- **WIcon**: Tailwind-styled Icon wrapper that honors parent text styles (`text-{color}`, `text-{size}`).

#### Animation System (Explicit)
- **Animation Utilities**: `animate-spin`, `animate-pulse`, `animate-bounce`, `animate-ping`.
- **WindAnimationWrapper**: Integrated wrapper that handles explicit animations automatically.
- **Widget Integration**: `WDiv`, `WIcon`, `WText` (via WDiv wrapper) support animation classes.

#### Implicit Animations (Transitions)
- **Duration**: `duration-{ms}` enables implicit animations on properties.
- **Easing**: `ease-linear`, `ease-in`, `ease-out`, `ease-in-out` curves.
- **Animated Widgets**: Automatically swaps to `AnimatedContainer`, `AnimatedOpacity`, `AnimatedAlign` (via explicit toggle pattern) when duration is present.

### 🐛 Bug Fixes & Improvements
- **Opacity Parsing**: Enhanced `/[0.2]` arbitrary syntax support to handle fractional doubles (0.0-1.0) correctly.
- **Revert**: Removed implicit alignment animation (`align-*` on containers) to avoid layout conflicts. Alignment animation should be done explicitly via `AnimatedAlign`.

---

## [1.0.0-alpha.4] - 2025-12-26

### ✨ New Features

#### WInput Widget (Form Input)
- **React-Style Binding**: `value` + `onChanged` props for controlled state management.
- **Input Types**: `text`, `password`, `email`, `number`, `multiline` via `InputType` enum.
- **Tailwind Styling**: `className` for input, `placeholderClassName` for placeholder text.
- **Focus Ring Support**: `focus:ring-2 focus:ring-blue-500` and similar classes work.
- **Custom States**: Use `states: {'error'}` with `error:border-red-500` for validation.
- **Keyboard Actions**: `textInputAction`, `onSubmitted`, `onEditingComplete`, `onTap`, `onTapOutside`.
- **Text Customization**: `textCapitalization`, `autocorrect`, `enableSuggestions` props.

#### Ring Parser Enhancements
- **Theme-Configurable Widths**: `ringWidths` and `ringOffsets` in `WindThemeData`.
- **Custom Ring Values**: `ring-custom` looks up from theme config.
- **Opacity Parsing**: Verified and tested `/opacity` syntax works for all ring colors.

### 📦 New Example Pages
- `/forms/input_basic` - Basic input types demonstration.
- `/forms/input_styled` - Styled inputs with Tailwind classes.
- `/forms/input_states` - Focus, disabled, and error state examples.

### 🐛 Bug Fixes
- Fixed deprecated `Color.value` usage in tests (replaced with `toARGB32()`).

---

## [1.0.0-alpha.3] - 2025-12-26

### ✨ New Features

#### State System Refactor
- **Unified State Handling**: Removed boolean flags (`isHovering`, etc.) in favor of `activeStates` (`Set<String>`).
- **Custom States**: Support for arbitrary states like `loading:`, `selected:`, `error:`.
- **Extensible Prefixes**: Any string can act as a state prefix (e.g., `loading:bg-gray-400`).

#### Color Opacity Support
- **Opacity Modifier**: Support for `/50` syntax on all color utilities.
- **Classes**: `bg-{color}/{opacity}`, `text-{color}/{opacity}`, `border-{color}/{opacity}`, `ring-{color}/{opacity}`, `shadow-{color}/{opacity}`.
- **Examples**: `bg-blue-500/50`, `text-red-500/75`, `ring-green-500/[0.3]`.

#### Ring Utilities
- **Ring Width**: `ring`, `ring-0` to `ring-8`.
- **Ring Color**: `ring-{color}`, `ring-{color}/{opacity}`.
- **Ring Offset**: `ring-offset-2`, `ring-offset-{color}`.
- **Ring Inset**: `ring-inset`.
- **Theme Configuration**: `WindThemeData.ringColor` to set default ring color.

#### Shadow Improvements
- **Shadow Opacity**: Support for opacity modifiers in shadow colors (`shadow-blue-500/50`).

---

## [1.0.0-alpha.2] - 2025-12-25

### ✨ New Features

#### Typography & Font Family
- **Font Family Utilities**: `font-sans`, `font-serif`, `font-mono`
- **Arbitrary Font Families**: `font-[Roboto]`, `font-[Inter, sans-serif]`
- **Default Font Application**: Automatically applies `font-sans` to all text (configurable via `WindThemeData.applyDefaultFontFamily`)
- **Theme Customization**: Define custom font families in `WindThemeData.fontFamilies`

#### Sizing & Layout
- **Aspect Ratio**: `aspect-square`, `aspect-video`, `aspect-auto`, `aspect-[4/3]`
- **Z-Index**: `z-0` to `z-50`, `z-auto`, `z-[100]`
- **Overflow**: `overflow-auto`, `overflow-hidden`, `overflow-visible`, `overflow-scroll`, `overflow-x/y-*`

#### Effects & Borders
- **Opacity**: `opacity-0` to `opacity-100`, `opacity-[0.37]`
- **Rings**: `ring`, `ring-2`, `ring-red-500`, `ring-offset-2` (Focus rings equivalents)

#### Transitions & Animations
- **Duration**: `duration-75/100/150/200/300/500/700/1000`, `duration-[ms]`
- **Timing Function**: `ease-linear`, `ease-in`, `ease-out`, `ease-in-out`
- **AnimatedContainer Integration**: `WDiv` automatically uses `AnimatedContainer` when `duration-*` is set

#### Developer Experience (DX)
- **Helper Functions**: `wColor`, `wSpacing`, `wScreen`, `wFontSize`, `wFontWeight`
- **BuildContext Extensions**: `context.windTheme`, `context.windColors`, `context.wColorExt(...)`
- **WindStyle Parsing**: `wStyle(context, '...')` helper to programmatically parse styles

### 🐛 Bug Fixes
- Fixed `font-weight` parsing interfering with `font-family` classes
- Fixed padding being applied outside Container instead of inside (Tailwind behavior)
- Fixed various documentation examples

---

## [1.0.0-alpha.1] - 2025-12-24

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

#### Specialist Parsers (8 Total)
- **`DisplayParser`**: `block`, `flex`, `grid`, `wrap`, `hidden`
- **`BackgroundParser`**: Colors, images, gradients, positioning, repeat
- **`BorderParser`**: Border width, color, style, and radius utilities
- **`TextParser`**: Colors, sizes, weights, alignment, decoration, transform, clamp
- **`SizingParser`**: Width, height, min/max constraints, fractions
- **`PaddingParser`**: All padding variants (`p-`, `px-`, `py-`, `pt-`, etc.)
- **`MarginParser`**: All margin variants (`m-`, `mx-`, `my-`, `mt-`, etc.)
- **`FlexboxGridParser`**: Flex direction, justify, align, gap, grid columns

#### Border & Rounded Utilities
- **Border width**: `border`, `border-0`, `border-2`, `border-4`, `border-8`
- **Directional borders**: `border-t`, `border-r`, `border-b`, `border-l`
- **Border colors**: `border-{color}-{shade}`, `border-[#hex]`
- **Border radius**: `rounded`, `rounded-sm/md/lg/xl/2xl/3xl/full/none`
- **Directional radius**: `rounded-t/r/b/l/tl/tr/bl/br`
- **Theme customization**: `borderWidths`, `borderRadius` in `WindThemeData`

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
