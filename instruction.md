---
trigger: always_on
---

# Wind UI Framework - AI System Prompt

You are an expert Flutter developer working with `fluttersdk_wind`, a utility-first styling framework inspired by Tailwind CSS. This document serves as your complete reference for developing with Wind.

## Architecture Overview

### Core Philosophy
Wind follows two key principles:
1. **Configuration is King**: Design system centralized in WindThemeData, fully customizable
2. **Intelligent Composition**: Widgets dynamically build optimal Flutter widget trees based on className

### Component Layers

**Orchestrator Layer (WindParser)**
- Converts className strings to WindStyle objects
- Caches results with compound key (className + viewport + theme + state)
- Delegates parsing to specialized sub-parsers
- Handles prefix resolution (responsive, state, platform, dark mode)

**Model Layer (WindStyle)**
- Immutable data object holding all resolved style properties
- Properties: decoration, padding, margin, width, height, constraints, flex params, typography, shadow, ring, opacity, animation, etc.
- "Intermediate representation" between className and Flutter widgets

**Context Layer (WindContext)**
- Captures theme, screen size, platform, interaction state from BuildContext
- Determines active breakpoint and states for prefix resolution
- Provides cacheKey generation for style memoization

**Theme Layer (WindTheme + WindThemeData)**
- InheritedWidget providing design tokens to entire widget tree
- Configurable: colors, screens, fontSizes, fontWeights, fontFamilies, borderRadius, baseSpacingUnit
- Auto-magic dark mode via brightness property

### Parser System

18 specialist parsers implementing WindParserInterface:

| Parser | Handles |
|--------|---------|
| BackgroundParser | bg-{color}, bg-gradient-to-{dir}, from/via/to, bg-[url] |
| BorderParser | border, border-{width}, rounded-{size}, border-{color} |
| TextParser | text-{color}, text-{size}, font-{weight}, tracking, leading, decoration |
| SizingParser | w-{n}, h-{n}, min/max constraints, full/screen/arbitrary |
| PaddingParser | p-{n}, px/py, pt/pr/pb/pl, arbitrary |
| MarginParser | m-{n}, mx/my, mt/mr/mb/ml, mx-auto |
| FlexboxGridParser | flex, grid, justify, items, gap, grid-cols, wrap |
| ShadowParser | shadow-{size}, shadow-{color} |
| RingParser | ring, ring-{width}, ring-{color}, ring-offset, ring-inset |
| OpacityParser | opacity-{value} |
| TransitionParser | duration-{ms}, ease-{curve} |
| AnimationParser | animate-{spin\|pulse\|bounce\|ping} |
| OverflowParser | overflow-{visible\|hidden\|scroll\|auto} |
| AspectRatioParser | aspect-{auto\|square\|video\|[ratio]} |
| ZIndexParser | z-{value} |
| SvgParser | fill-{color}, stroke-{color} |

**Interface:** `canParse(cls)` + `parse(style, classes, context)` → WindStyle
**Rule:** "Last Class Wins" - later classes override earlier ones for same property.

### State Management System

**Three Pillars:**

1. **Detection (WAnchor)**
   - Uses MouseRegion for hover (onEnter/onExit)
   - Uses FocusNode for focus state
   - Uses GestureDetector for tap/longPress/doubleTap
   - isDisabled prop suppresses all events

2. **Propagation (WindAnchorStateProvider)**
   - InheritedWidget holding WindAnchorState
   - State object: isHovering, isFocused, isDisabled, customStates
   - Rebuilds descendants when state changes

3. **Resolution (WindParser.resolveClasses)**
   - Iterates class list checking prefixes
   - Matches prefixes against WindContext active states
   - Returns only classes whose prefixes are active

## Widget Reference

### WDiv - Universal Container
```dart
WDiv(className: "flex gap-4 p-4 bg-gray-100", children: [...])
WDiv(className: "p-4 bg-white", child: WText("Single"))
```
- `child`: Single widget (block layout) | `children`: Multiple (flex/grid/wrap)
- NEVER use both child and children
- Dynamic layout: Builds Row/Column/GridView/Wrap based on displayType
- Text inheritance: Wraps subtree in DefaultTextStyle.merge

### WText - Typography
```dart
WText("Hello", className: "text-xl text-blue-500 font-bold uppercase")
```
- Supports `selectable` prop or class for SelectableText
- Handles text transforms (uppercase, lowercase, capitalize)

### WButton - Interactive Button
```dart
WButton(
  onTap: () {}, isLoading: _loading, disabled: _disabled,
  loadingText: "Loading...",
  className: "bg-blue-600 hover:bg-blue-700 loading:opacity-70 px-4 py-2 rounded",
  child: Text("Submit"),
)
```
- Built-in loading spinner and loading: prefix
- Wraps WAnchor internally (hover/focus work automatically)

### WAnchor - State Wrapper
```dart
WAnchor(
  onTap: () {}, isDisabled: false, states: {'custom'},
  child: WDiv(className: "hover:bg-gray-100 focus:ring-2", ...),
)
```
- REQUIRED wrapper for hover:/focus:/disabled: prefixes on WDiv

### WInput - Controlled Input
```dart
WInput(
  value: _text, onChanged: (v) => setState(() => _text = v),
  type: InputType.email, placeholder: "Email",
  className: "p-3 border rounded focus:ring-2",
  placeholderClassName: "text-gray-400",
)
```
Input types: text, password, email, number, phone, url, multiline

### WFormInput - Form Validated
```dart
WFormInput(
  validator: (v) => v!.isEmpty ? "Required" : null,
  className: "p-3 border rounded error:border-red-500",
  errorClassName: "text-red-500 text-sm mt-1",
)
```
Integrates with Flutter Form, auto-activates error: prefix

### WSelect / WFormSelect - Dropdowns
```dart
WSelect<String>(
  value: _selected, options: [SelectOption(value: "a", label: "A")],
  onChange: (v) => setState(() => _selected = v),
  searchable: true, isMulti: false,
)
```

### WCheckbox / WFormCheckbox
```dart
WCheckbox(value: _checked, onChanged: (v) => setState(() => _checked = v),
  className: "w-5 h-5 rounded checked:bg-blue-500")
```

### WPopover
```dart
WPopover(
  alignment: PopoverAlignment.bottomLeft,
  className: "w-64 bg-white shadow-xl rounded-lg",
  triggerBuilder: (ctx, open, hover) => WButton(child: WText("Menu")),
  contentBuilder: (ctx, close) => WDiv(child: WText("Item")),
)
```

### WIcon / WImage / WSvg
```dart
WIcon(Icons.star, className: "text-yellow-400 text-2xl animate-spin")
WImage(src: "https://...", className: "w-full aspect-video object-cover")
WSvg(src: "assets/icon.svg", className: "fill-blue-500 w-6 h-6")
```

## Utility Class Reference

### Layout
`block` `flex` `flex-row` `flex-col` `grid` `wrap` `hidden`
`justify-{start|end|center|between|around|evenly}` `items-{start|end|center|stretch}`
`gap-{n}` `gap-x-{n}` `gap-y-{n}` `grid-cols-{1-12}` `flex-1` `flex-none` `flex-grow`

### Sizing (n × 4px)
`w-{n}` `h-{n}` `w-full` `h-full` `w-screen` `h-screen` `w-1/2` `w-[100px]`
`min-w-{n}` `max-w-{n}` `min-h-{n}` `max-h-{n}`

### Spacing
`p-{n}` `px-{n}` `py-{n}` `pt-{n}` `pr-{n}` `pb-{n}` `pl-{n}`
`m-{n}` `mx-{n}` `my-{n}` `mx-auto`

### Typography
Sizes: `text-{xs|sm|base|lg|xl|2xl|3xl|4xl|5xl|6xl}`
Weights: `font-{thin|light|normal|medium|semibold|bold|extrabold|black}`
Family: `font-{sans|serif|mono}` Transform: `uppercase` `lowercase` `capitalize`
Align: `text-{left|center|right}` Decoration: `underline` `line-through`
Overflow: `truncate` `line-clamp-{n}` Tracking: `tracking-{tight|wide}` Leading: `leading-{tight|loose}`

### Colors
Pattern: `{bg|text|border|ring|shadow|fill|stroke}-{color}-{shade}`
Opacity: `{...}-{color}-{shade}/{opacity}`
Colors: slate, gray, zinc, neutral, stone, red, orange, amber, yellow, lime, green, emerald, teal, cyan, sky, blue, indigo, violet, purple, fuchsia, pink, rose, white, black
Shades: 50, 100, 200, 300, 400, 500, 600, 700, 800, 900 | Arbitrary: `bg-[#hex]`

### Effects
Shadow: `shadow-{sm|md|lg|xl|2xl}` Ring: `ring` `ring-{1|2|4}` `ring-{color}` `ring-offset-{n}`
Rounded: `rounded-{none|sm|md|lg|xl|full}` Opacity: `opacity-{0|25|50|75|100}`

### Transitions/Animations
Duration: `duration-{75|100|150|200|300|500|700|1000}` Easing: `ease-{linear|in|out|in-out}`
Animation: `animate-{spin|pulse|bounce|ping|none}`

## State Prefixes

| Prefix | Trigger | Requirement |
|--------|---------|-------------|
| `hover:` | Mouse hover | WAnchor wrapper |
| `focus:` | Focus state | WAnchor wrapper |
| `disabled:` | disabled=true | - |
| `loading:` | isLoading=true | WButton |
| `checked:` | value=true | WCheckbox |
| `error:` | Validation fail | WFormInput/WFormSelect |
| `dark:` | Dark brightness | WindTheme |
| `sm:` `md:` `lg:` `xl:` `2xl:` | Breakpoints | ≥640/768/1024/1280/1536px |
| `ios:` `android:` `web:` `mobile:` | Platform | Auto-detected |

Custom: Pass `states: {'loading'}` prop → use `loading:opacity-50`

## Theme Configuration

```dart
WindTheme(
  data: WindThemeData(
    brightness: Brightness.light,
    colors: {'primary': Colors.indigo, 'secondary': Colors.teal},
    fontFamilies: {'sans': 'Inter'},
    baseSpacingUnit: 4.0,
  ),
  builder: (context, controller) => MaterialApp(
    theme: controller.toThemeData(),
    home: MyApp(),
  ),
)
```

## Helper Functions & Extensions

```dart
// Functions
wColor(context, 'blue', shade: 500)  // Color
wSpacing(context, 4)                  // 16.0 (4×4)
wFontSize(context, 'lg')              // 18.0
wScreen(context, 'md')                // 768
wScreenIs(context, 'lg')              // bool

// Context extensions
context.windTheme                     // WindThemeController
context.windTheme.toggleTheme()       // Toggle dark/light
```

## Documentation

All features MUST be documented in `docs/` (41 files, 9 categories):
`getting-started/`, `core-concepts/`, `widgets/`, `layout/`, `typography/`, `backgrounds/`, `borders/`, `effects/`, `helpers/`

**Requirements:** New widget → `docs/widgets/w-{name}.md` | New utility → update category doc | API change → update affected docs

## Testing

Test structure mirrors source: `test/parser/`, `test/widgets/`, `test/theme/`, `test/state/`

Run all: `flutter test`
Run specific: `flutter test test/widgets/w_button_test.dart`

## Code Standards

1. **Always use className** - Never manual Flutter styling
2. **WAnchor for hover/focus** - Required wrapper for state prefixes
3. **child vs children** - Never use both; child=block, children=flex/grid
4. **Custom states via props** - Pass states set, use prefix in className
5. **Theme tokens programmatically** - Use wColor(), wSpacing() helpers

### Long className Formatting
Use triple quotes for long className values (>80 chars):

```dart
WDiv(
  className: '''
    w-full py-3 rounded-xl bg-gradient-to-r from-indigo-500
    to-purple-500 text-white font-semibold text-center
  ''',
  child: WText("Follow"),
)
```

### README.md Updates
Update `README.md` when:
- Adding new widget → Add to "Core Widgets" section with example
- Adding new utility class category → Add to "Supported Utilities"
- Adding new state prefix → Add to "State" section
- Changing public API → Update relevant examples
- Major version changes → Update "What's New" section

### fluttersdk-wind-ui.md Updates
`fluttersdk-wind-ui.md` is the system prompt for AI agents using Wind in external projects. Update when:
- Adding/modifying widget → Update widget reference with props
- Adding new utility class → Add to relevant utility class section
- Adding new state prefix → Update state prefixes table
- Changing widget props → Update props list
- Adding Flutter→Wind mapping → Update mapping table

This file enables AI agents to use Wind correctly without reading source code.

## Extension Guide

To add new utility class support:
1. Create parser in `lib/src/parser/parsers/` implementing WindParserInterface
2. Implement `canParse(cls)` and `parse(style, classes, context)`
3. Register in `WindParser._parserMap`
4. Add property to WindStyle if needed
5. Update widget build methods
6. Add tests in `test/parser/parsers/`

## Anti-Patterns

❌ `Container(padding: EdgeInsets.all(16))` → Use className
❌ `WDiv(className: "hover:...")` without WAnchor → Wrap with WAnchor
❌ `WDiv(child: X, children: [Y])` → Never both
❌ Hardcoded colors → Use utility classes or theme
