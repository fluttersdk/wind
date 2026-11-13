---
name: wind-ui
description: "Style Flutter UI with wind_kit: Tailwind-syntax className, W-widgets, dark: pairs, stacked prefixes, WindRecipe and WDynamic."
when_to_use: "Use when writing, editing or auditing Flutter UI in an app that uses wind_kit: a className, W-widget, theme or overflow."
version: 2.32.0
---

<!-- wind_kit 1.12.x | Skill v2.32.0 (2026-11-13) -->

# Wind UI

Scope: Wind-styled UI in an app that depends on `wind_kit`. Backend, state management and Material-only screens that never touch a W-widget are out of scope, and the Magic framework has its own skill (`magic-framework`).

Utility-first Flutter styling. Every visual decision lives in a `className: String?` parsed at build time into an immutable `WindStyle` and composed into a native Flutter widget tree. Tailwind syntax (`flex`, `p-4`, `dark:bg-gray-800`, `hover:shadow-lg`), Flutter physics.

This skill assumes the host app already depends on `wind_kit` and has `WindTheme` wrapping `MaterialApp`. If a fresh project needs setup (rare; the skill normally triggers on an already-installed project), see [Quick install](#13-quick-install) at the bottom.

## Install

```bash
flutter pub add wind_kit material_ui
```

Import `package:wind_kit/wind_kit.dart` (the only barrel) and `package:material_ui/material_ui.dart` for `MaterialApp` (not `package:flutter/material.dart`), and wrap the app once with `WindTheme(data: WindThemeData(), builder: (context, controller) => MaterialApp(theme: controller.toThemeData(), ...))`. The full wiring, with the debug resolver, is in [§13](#13-quick-install).

## 0. Before writing UI in this project

Three quick checks. Each pays off across the whole session.

1. **Confirm Wind is installed.** Look at `pubspec.yaml` for `wind_kit:`. If absent, jump to §13 first.
2. **Read the project's `WindThemeData` setup.** Usually in `lib/main.dart` or `lib/config/wind.dart`. Note any custom colour families (`primary`, `accent`, `incident`, etc.): those become available as `bg-primary-500`, `text-incident-700`, etc. without registration. Skip this and the agent risks writing tokens that silently no-op, or missing the brand palette entirely.
3. **Scan one existing view in `lib/` for the project's className idioms.** Triple-quoted style? Single-line preferred? Custom states (`pressed:`, `expanded:`)? Match the surrounding code, don't invent a new dialect.

After these, the agent has the project's colour landscape, breakpoint set, and className voice loaded.

The parser cache is near-100% hit-rate in production. Do not worry about className parse overhead; the same className parses exactly once for its (breakpoint, brightness, platform, states) tuple. Prefer expressive className over inline `BoxDecoration` / `EdgeInsets` for "performance" reasons; the cache handles it. The key leaves out the theme's maps, so after `setTheme` / `updateTheme` changes anything but brightness, call `WindParser.clearCache()` (details in `${CLAUDE_SKILL_DIR}/references/theme.md`).

## 1. Core Laws

These hold for every line of Wind code. Apply each as a hard constraint, not a suggestion.

1. **className is the styling surface.** Inline Dart props (`backgroundColor` on `WDiv`, `foregroundColor` on `WText`) exist only as runtime-dynamic escape hatches for values the cache key cannot represent. Default to className. Never reach for `BoxDecoration`, `EdgeInsets`, `TextStyle` when a token covers it.

2. **Every `bg-` / `text-` / `border-` / `ring-` / `shadow-` / `fill-` carries a `dark:` peer in the same className.** Missing pair is a bug, not a style choice. Pair `bg-white dark:bg-gray-800` on the same line, not at the top and bottom of a multi-line className. A colour that is the same in both modes, such as white text on a saturated button, needs no peer. Wind's dark-mode contract: the agent never opts in; every colour opts in by default. The one colour no token can pair is one an end user chose at runtime (a status page operator's brand colour): it arrives as a `Color`, so pick its text with `contrastForeground(background)` (or measure with `contrastRatio(a, b)`, WCAG 2.x) instead of guessing a `dark:` class.

3. **Conditional styling routes through `states: Set<String>?` plus prefixed classes.** Never interpolate Dart expressions into className. `'bg-${isOn ? "blue" : "gray"}-500'` is a bug: the token hides from the dark-pair audit and from grep, and every distinct string adds its own cache entry. The right shape:

   ```dart
   WDiv(
     className: '''
       rounded-lg p-4 border-2
       border-gray-200 dark:border-gray-700
       bg-white dark:bg-gray-800
       selected:border-blue-500 selected:bg-blue-50
       dark:selected:border-blue-400 dark:selected:bg-blue-950
     ''',
     states: isSelected ? const {'selected'} : const {},
     child: ...,
   );
   ```

4. **Inside a Row (`flex flex-row`), prefer `flex-1` for a fill-the-row child.** A bare `w-full` on a direct Row child is now treated as `flex-1` (the row wraps it in `Expanded`), so it fills the available width instead of asserting `RenderBox was not laid out`; `flex-1` stays the idiomatic, explicit choice and is what to reach for. (A prefixed `md:w-full` is not auto-expanded; use `md:flex-1`.) Inside a Column (`flex flex-col`), scrollable children use `flex-1 overflow-y-auto` plus the constructor prop `scrollPrimary: true` for iOS tap-to-top. `h-full` on a child of a `WDiv` vertical scroll asserts in debug; under a plain `SingleChildScrollView` it silently takes the screen height. Use `flex-1` in a `flex flex-col`.

5. **`child` XOR `children` on every W-widget that accepts both.** Passing both fails an assertion at construction. Passing neither renders an empty `SizedBox`.

6. **Unknown tokens are dropped; the debug hint fires only for tokens no parser recognises.** Two cases, and they behave differently. A token that no parser claims once its prefixes are stripped (`ps-4` logical-inline, `-m-4` negative margin, a mistyped family like `wibble-4`) is dropped and, in `kDebugMode`, prints a one-time `debugPrint` naming it (deduped per unique token per session; release builds stay silent), except the deliberate no-ops the parser knows (`transition`, `antialiased`, `sr-only`), which drop with no hint. A class with an unknown or inactive prefix (`hovr:bg-red-500`, `motion-safe:animate-spin`) is removed earlier and prints nothing. A token whose family is recognised but whose value is unsupported (`text-7xl`, past wind's `text-6xl` cap; `flex-cow`, which still matches `flex-*`) is claimed by that parser and drops silently, with no hint. So the hint catches unknown-family typos, not bad-value ones; spell-check values by hand or load `references/tokens.md` to verify the family.

7. **Last class wins within a parser family.** `p-4 p-8` resolves to `p-8`. `bg-red-500 bg-blue-500` resolves to `bg-blue-500`. Conflicts inside the same property are stable but silent; conflicts across properties (`text-red-500` colour + `text-center` alignment) coexist because they target different fields.

8. **Put `WindTheme` above `MaterialApp` with the `builder` form**: `WindTheme(data: ..., builder: (ctx, controller) => MaterialApp(...))`. Routes and `OverlayEntry` contexts then reach the theme by the normal ancestor walk. The shape to avoid is `MaterialApp(home: WindTheme(...))`: the theme then sits below the Navigator's `Overlay`, so an `OverlayEntry` cannot reach it and a W-widget there fails `No WindTheme found in context` (debug) or throws (release). If you cannot move the theme, wrap the entry content in `WindTheme(data: WindTheme.dataOf(outerContext), child: ...)`, capturing `outerContext` before `insert` (see `references/theme.md` §12). `WPopover` / `WSelect` already handle their own overlays.

9. **Wind composes with Flutter, not against it.** `Scaffold`, `AppBar`, `Dialog`, `BottomSheet`, `Drawer`, `SnackBar`, `Navigator`, `Hero`, `FutureBuilder`, `StreamBuilder`, `ValueListenableBuilder` remain canonical. `ListView` / `GridView.builder` / `CustomScrollView` are the right choice for virtualised lists; `WDiv` with `grid-cols-N` produces a static `Wrap` (or, with `items-stretch`, equal-height rows), not a virtualised grid. See [Wind ≠ Flutter rules of thumb](#9-wind--flutter-rules-of-thumb).

10. **No widget tracks press, so `active:` applies only through `states: {'active'}`.** `WAnchor` tracks hover and focus only; there is no onTapDown/onTapUp tracking. Don't rely on `active:bg-blue-700` for press feedback from a tap. If you need it, keep a transient press flag in the consumer's state and pass `states: {'active'}`.

11. **An `onTap` on `WAnchor` is reachable by keyboard and remote, and a gestureless anchor is not a stop.** `onTap` runs on `ActivateIntent`, which covers `Enter`, `Space`, the gamepad A button and `select` (the D-pad centre on Android TV, the click on the Apple TV remote). Only an anchor that carries a gesture is a traversal stop: the gestureless `WAnchor` that `WDiv` wraps itself in for `hover:` / `focus:` inherits the nearest anchor's primary focus and `disabled` instead of claiming a second stop, so `WAnchor(onTap:) > WDiv('focus:ring-2')` is one control the user tabs to once and the ring lands on the thing they activate. An anchor with only `onLongPress` binds no activation key. Do not add `Focus` or `Shortcuts` wrappers; the detail is in `${CLAUDE_SKILL_DIR}/references/widgets.md`.

## 2. The 27 public widgets (+ WindRecipe) at a glance

`wind_kit` v1 ships 27 public widgets plus the `WindRecipe` / `WindSlotRecipe` variant-composition primitives, all imported from the single barrel `package:wind_kit/wind_kit.dart`. No sub-barrels exist; do not write `import 'package:wind_kit/widgets.dart'`.

The headline 25 (table below) are the ones an agent reaches for daily. Two more cover narrow surfaces and live outside the table: `WKeyboardActions` (iOS keyboard toolbar overlay for `Done` / `Next` actions on a focused `TextField`) and `WindAnimationWrapper` (the internal stateful wrapper that drives looping `animate-*` tokens; consumers normally do not instantiate it directly).

| Widget | Category | Required parameters | One-line purpose |
|---|---|---|---|
| `WDiv` | Layout / container | none | Universal container; auto-wraps in `WAnchor` when className contains `hover:` / `focus:` / `active:`. `child` XOR `children`. Inline colour prop: `backgroundColor`. |
| `WSpacer` | Layout | none | Lightweight `SizedBox` that reads only `w-N` / `h-N`. Skips every other token. |
| `WBreakpoint` | Structural | `base:` | Per-breakpoint `WidgetBuilder` map (`base`, `sm`, `md`, `lg`, `xl`, `xxl`, plus theme-defined custom keys). Escape hatch when className prefixes are not enough. |
| `WText` | Display | `data` (positional) | Typography; supports `selectable` prop. Inline colour prop: `foregroundColor`. No `child` / `children`. |
| `WIcon` | Display | `icon` (positional) | Material icons; use `Icons.*_outlined` variants by convention. Reads `text-*` for size and colour (overloaded). Inherits from `DefaultTextStyle` when className is absent. Inline colour prop: `foregroundColor`. |
| `WImage` | Display | none (requires `src` or `image`) | Network (URL) or asset (prefix `asset://path`) or `ImageProvider`. `object-cover` default; `object-top` / `object-left-bottom` / ... (default `object-center`) pick which part of a cropped image stays in view. |
| `WSvg` / `WSvg.string` | Display | `src:` / `svg` (positional) | Vector graphics. `fill-*` / `stroke-*` for colour. `preserve-colors` token disables tint for multi-colour SVGs (QR codes, logos). |
| `WAnchor` | Interactive | `child:` | Low-level gesture + focus + hover propagator. Emits `Semantics(button: true)` only when it carries a gesture, or when `semanticLabel` is set. |
| `WButton` | Interactive | `child:` | Wraps `WAnchor` + `WDiv` + built-in spinner. `isLoading: true` injects `loading:` state. `disabled: true` injects `disabled:` state and blocks taps. |
| `WPopover` | Overlay | `triggerBuilder:`, `contentBuilder:` | `OverlayPortal`-based; `triggerBuilder(ctx, isOpen, isHovering)` + `contentBuilder(ctx, close)` + optional `PopoverController`. Auto-flips alignment when bottom space is insufficient, and caps its height at the room on that side; tall content must scroll (`overflow-y-auto` on the popover, or a scroll view), or a plain column overflows the cap. One Tab stop: Enter / Space / D-pad centre toggle, Escape closes and refocuses the trigger. The trigger's `hover:` / `focus:` / `disabled:` follow the popover, so give a plain `WDiv` trigger a `focus:ring-*` or keyboard focus is invisible. |
| `WInput` | Form (raw) | none | Material-free text input (EditableText core); works under Material, Cupertino, custom, or bare WidgetsApp (no Material ancestor required). `value` + `onChanged` for controlled binding, or `controller` for imperative needs; passing both throws `AssertionError` in debug. `InputType`: `text` / `password` / `email` / `number` / `multiline` (`number` takes a signed decimal with `decimalSeparator`, default `.`). `readOnly: true` activates `readonly:` like `enabled: false` activates `disabled:`. Interactive text selection needs an `Overlay` ancestor. One textbox semantics node carrying `semanticLabel ?? placeholder`. Full surface: `references/widgets.md`. |
| `WCheckbox` | Form (raw) | `value:` | Boolean checkbox; auto-injects `checked:` state when `value: true`. Default className includes `checked:bg-primary` (`primary` is a seeded default token aliased to blue; override it in `WindThemeData.colors` to rebrand). A null `onChanged` renders it display-only, exactly like `disabled: true`: no tap action, reported as not enabled, `disabled:` styles active. `WRadio` and `WSwitch` read a null callback the same way. |
| `WSelect<T>` | Form (raw) | `options:` | Single or multi-select dropdown with overlay. Supports searchable, async search, async create (tagging), pagination via `onLoadMore` + `hasMore`. Auto-flips upward when bottom space < `maxMenuHeight`. |
| `WDatePicker` | Form (raw) | none | `single` date, `DateRange`, or `dateTime` mode; popover-based calendar; min/max constraints. `dateTime` keeps the time of day (stepped time row, `minuteStep` / `timeLabel` / `doneLabel`) where the other two strike every value to midnight. |
| `WFormInput` | Form (FormField) | none | `extends FormField<String>`; auto-injects `error:` when validation fails; renders label / hint / error around `WInput`. |
| `WFormSelect<T>` | Form (FormField) | `options:` | `extends FormField<T>`; single-select with validation. |
| `WFormMultiSelect<T>` | Form (FormField) | `options:` | `extends FormField<List<T>>`; multi-select with validation; validator inspects the full list. |
| `WFormCheckbox` | Form (FormField) | none | `extends FormField<bool>`; validation hook + label + error display. |
| `WFormDatePicker` | Form (FormField) | none | `extends FormField<DateTime>`. Forwards `mode` / `minuteStep` / `timeLabel` / `doneLabel`, so `dateTime` gives the validator a full instant. Range mode stores `range.start` only in FormFieldState; validators only see the start date. |
| `WDynamic` | Structural / SSR | `json:` | Renders a JSON node tree into Wind widgets. 13 Wind types + 16 Flutter core types allowed by default; `builders:` adds custom types; `denyWidgets:` blocks. Max recursion depth default 50. |
| `WBadge` | Display | `label` (positional) | Inline status/label pill. Composes a rounded-full `WDiv` around `WText(text-xs)`. All tone via `className` (`bg-*`, `text-*`, `dark:` pairs). No positional child; label is the only positional param. |
| `WCard` | Layout / container | `child:` | Surface container. `header:`, `child:` (required), `footer:` slots; delegates to `WDiv(flex-col)`. No colours baked in; all tone via `className`. |
| `WSwitch` | Form (raw) | `value:` | Controlled toggle. `value` + `onChanged`. `className` styles the track; `thumbClassName` styles the indicator dot. `checked:` state activates when `value: true`. The thumb is a flex child of the track, so it slides via `justify-start` -> `checked:justify-end` on the track `className` (Wind has no transform parser; `translate-x-*` is a no-op). `disabled:` when `disabled: true`. |
| `WRadio<T>` | Form (raw) | `value:`, `groupValue:` | Controlled radio. `value`, `groupValue`, `onChanged`. `selected:` activates when `value == groupValue`. Outer ring: `className`. Inner dot: `indicatorClassName` (defaults to `w-2.5 h-2.5 rounded-full bg-primary selected:opacity-100`, so it follows the theme's `primary` token). Group exclusivity is the caller's responsibility. |
| `WTabs` | Form (raw) / Layout | `tabs:`, `selectedIndex:`, `panelBuilder:` | Controlled tabs. `tabs: List<String>`, `selectedIndex`, `panelBuilder`. `selected:` activates on the active tab. Slot classNames: `listClassName`, `tabClassName`, `selectedTabClassName`, `panelClassName`. `fullWidthList` (default `true`) prepends `w-full` so a `border-b` underline spans the container; set `false` for content-width / pill tabs. |

Full constructor surface, every named parameter, every default: `${CLAUDE_SKILL_DIR}/references/widgets.md`.

### WindRecipe / WindSlotRecipe (variant-composition primitives)

`WindRecipe` and `WindSlotRecipe` are callable objects (not widgets) that compose className strings from variant axes. Use them to centralise multi-variant component styling instead of scattering conditional className strings across the call sites.

```dart
final button = WindRecipe(
  base: 'flex flex-row items-center rounded-lg font-medium',
  variants: {
    'intent': {'primary': 'bg-blue-600 dark:bg-blue-500 text-white', 'ghost': 'bg-transparent text-blue-600 dark:text-blue-400'},
    'size':   {'sm': 'px-3 py-1.5 text-sm', 'md': 'px-4 py-2 text-base', 'lg': 'px-6 py-3 text-lg'},
  },
  compoundVariants: [
    WindCompoundVariant(conditions: {'intent': 'primary', 'size': 'lg'}, className: 'shadow-lg'),
  ],
  defaultVariants: {'intent': 'primary', 'size': 'md'},
);

button()                                       // uses defaults
button(variants: {'intent': 'ghost'})          // override one axis
button(variants: {'size': null})               // null clears the default (no size classes)
button(className: 'w-full')                    // caller suffix, appended last
```

Resolution order (strict, never sorted): `base ++ variant-classes(definition order) ++ matched-compound(array order) ++ caller`.

A compound condition value is a `String` (exact) or a `List<String>` (OR match): `WindCompoundVariant(conditions: {'intent': ['primary', 'ghost']}, className: '...')`. `WindSlotRecipe` takes `WindSlotCompoundVariant(conditions: {...}, classNames: {'slot': '...'})`. Selecting an axis the recipe does not define throws `ArgumentError` naming the known axes.

**Override contract:** a variant comes after the base, so it overrides it. Padding, margin and inset longhands compose with shorthands per side (`p-4` then `px-2` gives 8 left and right, 16 top and bottom). Border width and radius do not: `rounded-lg` then `rounded-t-none` squares every corner and `border-2` then `border-t-4` keeps only the top border, so a variant over such a base restates every side or corner.

`WindSlotRecipe` returns `Map<String, String>` (slot -> className). Use the slot keys directly on widget `className:` props.

**Core Law addition for recipes:** pass enum variant values as `.name` (`ButtonIntent.ghost.name`); recipe axes are plain strings.

**Caller-append contract (no twMerge):** the recipe only appends the caller's `className` last; it never dedupes or resolves conflicts itself. `WindRecipe(base: 'w-1/2')(className: 'w-full')` emits `'w-1/2 w-full'`, both tokens intact. The conflict resolves one layer down: `WindParser` groups same-family classes and each parser applies last-class-wins, so the appended `w-full` wins at parse time. Wind deliberately has no Dart `twMerge`/`cn` port; see the docs page `anilcancakir.com/wind_kit/docs/styling/wind-recipe`, "The Caller-Append Contract (No twMerge)". A component that treats an incoming `className` as a full replacement instead of appending it is a consumer bug, not a wind defect.

## 3. The state system (three layers)

| Layer | Set by | Examples |
|---|---|---|
| **Automatic** | `WAnchor` from pointer / keyboard events | `hover:` (MouseRegion `onEnter`/`onExit`), `focus:` (`FocusNode` listener) |
| **Framework-managed** | The widget itself, from its own props | `loading:` (WButton.isLoading), `disabled:` (any widget's `disabled` / `enabled` prop), `checked:` (WCheckbox.value, WSwitch.value), `selected:` (WRadio when value==groupValue, WTabs active tab), `error:` (WForm* when `FormFieldState.hasError`) |
| **Consumer-passed** | `states: Set<String>?` on the widget | `selected:` (card toggles), `highlighted:`, `new:`, any custom string. No registration required. |

WDiv wraps itself in WAnchor whenever className contains the literal substrings `hover:`, `focus:`, or `active:`; WButton always wraps. Other widgets do not. If you need hover detection on a `WText`, wrap it in `WDiv` or `WAnchor` explicitly.

All active states merge into a single `Set<String>` inside `WindContext.activeStates` and contribute to the parser cache key. Manual `states: {'hover'}` and a real pointer hover produce the same cache entry by design.

Combining prefixes:

```
md:hover:bg-blue-500          // breakpoint and hover
dark:md:hover:bg-blue-400     // dark, breakpoint and hover
ios:focus:ring-blue-500       // iOS only, and focused
md:dark:selected:border-2     // breakpoint, dark and selected
```

Prefix order does not matter at the parser level; all stacked prefixes must match for the class to activate.

## 4. The token landscape (high-frequency subset)

Inline this catalogue as your default reach-for set. For the full per-parser regex catalogue (every flag, every arbitrary-value pattern): `${CLAUDE_SKILL_DIR}/references/tokens.md`.

**Layout**: `flex` `flex-row` `flex-col` `flex-row-reverse` `flex-col-reverse` `wrap` `grid` `grid-cols-N` `block` `hidden`. `justify-start` `-center` `-end` `-between` `-around` `-evenly`. `items-start` `-center` `-end` `-baseline` `-stretch`. `axis-min` `axis-max` (Wind-only, sets `MainAxisSize`). On a `grid`, `items-stretch` opts into equal-height rows (cells match the tallest per row); the default grid sizes each cell to its own content.

**Flex child**: `flex-1` `flex-auto` `flex-none` `flex-N` (numeric). `shrink-0` `grow` `grow-0`; `flex-initial` and `flex-auto` both parse to a loose `Flexible`, but only `flex-auto` claims a grow share in a row (`flex-initial` never grows). `flex-shrink-0` and `flex-grow-0` are not wired and drop silently: write `shrink-0` / `grow-0`. `self-start` / `-end` / `-center` / `-auto` (align-self shorthand; `align-self-*` long form also works). `self-stretch` currently centres the child instead of stretching it (it maps to the same alignment as `self-center`); set the height explicitly. `order-0` through `order-12`, `order-first` / `order-last` / `order-none`, arbitrary `order-[-5]`.

**Spacing**: `p-N` `px-N` `py-N` `pt-N` `pr-N` `pb-N` `pl-N` (no `ps-`/`pe-`). `m-N` and axes (no negative margin, no `ms-`/`me-`, `mx-auto` for horizontal centring). `gap-N` `gap-x-N` `gap-y-N`; `space-x-N` / `space-y-N` parse to the same gap as `gap-x-N` / `gap-y-N`. Arbitrary `p-[18px]`, `gap-[3.5]` (no `%` for spacing). Default unit: 4 px per step. `p-4` = 16 px. `p-px` and `w-px` are silent no-ops.

**Sizing**: `w-N` `h-N` (theme scale). `w-1/2` `w-1/3` `w-2/3` `w-1/4` `w-3/4` `w-full` `w-screen`. `h-full` `h-screen`. `size-N` sets both width and height (`size-2`, `size-full`, `size-1/2`, `size-[20px]`); works on a childless `WDiv` (status dot). Arbitrary `w-[300px]` `h-[50%]` (`%` works only on `w-`, `h-` and `size-`; `min-*` / `max-*` arbitrary values take px only). `min-w-0` `min-w-full` `min-h-screen` (`min-w-full` is the viewport width and `min-h-full` the viewport height, not the parent's). `max-w-xs` through `max-w-7xl`, `max-w-prose`, `max-w-full`. No `w-auto` / `h-auto` (silently skipped).

**Position**: `relative` `absolute`. `top-N` `right-N` `bottom-N` `left-N` `inset-N` `inset-x-N` `inset-y-N`, negative `-top-N` `-inset-N`, arbitrary `top-[24px]` (no `%` for offsets). `fixed` / `sticky` are recognised by the parser but produce no visual effect.

**Colours** (every line needs a `dark:` peer, except a colour that reads the same in both modes, see Core Law 2): `bg-{family}-{shade}` `bg-[#hex]` `bg-transparent` `bg-white` `bg-black`. Arbitrary hex takes 3, 4, 6 or 8 digits and alpha leads in the 4- and 8-digit forms (Flutter packs `AARRGGBB` where CSS writes `RRGGBBAA`): 50%-alpha red is `bg-[#80ff0000]`. Opacity modifier `/N` (0-100): `bg-red-500/50`. Same shape for `text-*` `border-*` `ring-*` `fill-*` `stroke-*`, and a bare shade defaults to 500 there: `bg-red` = `bg-red-500`. `shadow-*` needs the shade and a size preset: `shadow-lg shadow-primary-500` tints the preset; `shadow-red`, `shadow-primary` and a colour without a preset paint nothing, and a `/N` modifier is ignored (the preset's alpha wins). Gradients: `bg-gradient-to-{t|tr|r|br|b|bl|l|tl}` + `from-{c}-{shade}` `via-{c}-{shade}` `to-{c}-{shade}`.

**Borders**: `border` `border-N` `border-t` `border-r` `border-b` `border-l` (there is no `border-x` or `border-y`: name the two sides). `border-solid` `border-none` (only these two; `border-dashed` / `border-dotted` are recognised but not wired). `rounded` `rounded-{sm|md|lg|xl|2xl|3xl|full|none}`, directional `rounded-t-lg` `rounded-tl-xl` (no arbitrary `rounded-[8px]`: pick a scale step or set the radius in the theme's `borderRadius`).

**Typography** (order of resolution inside `text-*`): colour → align → size → weight → style. `text-xs` `text-sm` `text-base` `text-lg` `text-xl` `text-2xl` through `text-6xl` (60 px). `text-7xl` / `text-8xl` / `text-9xl` are no-ops; do not write them (for a larger size use `text-[72px]`). `font-thin` through `font-black`. `text-left` `text-center` `text-right` `text-justify` `text-start` `text-end` (RTL-aware). `truncate` (= `text-ellipsis` + `maxLines: 1` + `softWrap: false`). `line-clamp-N`. `whitespace-nowrap` / `text-nowrap`. `uppercase` `lowercase` `capitalize` `normal-case` (`capitalize` raises the first letter of every word and leaves the rest as typed; casing follows the ambient locale, so `tr` and `az` get the dotted and dotless `i` right). `italic` / `not-italic`. `underline` `line-through` `no-underline`, plus `decoration-{color}/{style}/{thickness}`. `leading-tight` `leading-snug` `leading-normal` `leading-relaxed` `leading-loose` or arbitrary `leading-[24px]` (`leading-none` is not mapped; `rem` inside an arbitrary `text-[...]` or `leading-[...]` is read as px, so `text-[1.5rem]` is 1.5 px). `tracking-tighter` through `tracking-widest` are em (Tailwind's -0.05em to 0.1em), multiplied by the text's own `text-*` size, else the inherited size, else 14 (`kDefaultFontSize`); `tracking-[-0.02em]` is em, `tracking-[1px]` and a bare `tracking-[1]` are px. Font size + line height combined: `text-xl/8` (numeric only: a named leading after the slash, `text-xl/loose`, reads the theme multiplier as pixels and collapses the line height).

**Effects**: `opacity-N` (0, 5, 10, 20, 25, 30, 40, 50, 60, 70, 75, 80, 90, 95 or 100; there is no 15, 35, 45 or 55, and a missing step drops silently), plus arbitrary `opacity-[0.5]`. `shadow-sm` `shadow` `shadow-md` `shadow-lg` `shadow-xl` `shadow-2xl` `shadow-none` (no `shadow-inner`). Coloured shadow `shadow-lg shadow-blue-500` (needs a size preset; `/N` is ignored). `ring-N` `ring-{color}` `ring-offset-{0,1,2,4,8}` `ring-inset` (an outline over the box, never a fill: a ring on an element with no background stays empty inside; the offset gap is unpainted). `aspect-square` `aspect-video` `aspect-[4/3]`. `z-0` `z-10` through `z-50`, arbitrary `z-[100]`, `z-auto`.

**Overflow**: `overflow-hidden` `overflow-visible` `overflow-scroll` `overflow-auto`, axis-specific `overflow-x-auto` `overflow-y-auto`. On a box with a border, `overflow-hidden` clips inside the border (the padding box, inner radius), so the border stays whole at rounded corners and the box's own `shadow-*` still paints. Scrolling requires the constructor prop `scrollPrimary: true` for iOS tap-to-top (there is no className for it).

**Cursor** (web/desktop; `WDiv` adds a `MouseRegion`, inert on touch): `cursor-pointer` `cursor-default` `cursor-text` `cursor-wait` `cursor-progress` `cursor-help` `cursor-not-allowed` `cursor-none` `cursor-move` `cursor-grab` `cursor-grabbing` `cursor-zoom-in` `cursor-zoom-out` `cursor-col-resize` `cursor-row-resize` `cursor-{n,e,s,w,ne,nw,se,sw,ew,ns,nesw,nwse}-resize` plus `cursor-context-menu` `cursor-cell` `cursor-crosshair` `cursor-alias` `cursor-copy` `cursor-no-drop` `cursor-all-scroll`. Last token wins; unknown names no-op.

**Transitions / animations**: `duration-{75|100|150|200|300|500|700|1000}` plus arbitrary `duration-[500ms]`. `ease-linear` `ease-in` `ease-out` `ease-in-out`. `animate-spin` `animate-pulse` `animate-ping` `animate-bounce` `animate-none`. The bare `transition` / `transition-all` / `transition-colors` tokens are recognised in docs but not wired in the parser; pair `duration-*` + `ease-*` to enable transitions on `opacity` and colour changes.

**Prefixes**: Responsive `sm:` `md:` `lg:` `xl:` `2xl:` (default 640 / 768 / 1024 / 1280 / 1536 px, customisable via `WindThemeData.screens`). Dark `dark:`. Platform `ios:` `android:` `macos:` `web:` `mobile:` `windows:` `linux:`. State (Core Laws §3). Stackable freely.

## 5. Wind ≠ Tailwind (the cheat sheet a web developer needs first)

A developer fluent in Tailwind v3 or v4 will default to assumptions Wind partially honours, partially rejects. Full divergence catalogue: `${CLAUDE_SKILL_DIR}/references/tailwind-divergence.md`.

| Tailwind expectation | Wind reality |
|---|---|
| `flex-wrap` enables wrapping | Aliased to `wrap` (Flutter `Wrap` is a separate widget); prefer `wrap` directly, `flex-wrap` prints a one-time debug hint. |
| Font sizes go to `9xl` | Stop at `6xl` (60 px). `7xl`/`8xl`/`9xl` silently no-op; use `text-[72px]` for a larger size. |
| `text-7xl` typo fails loudly | A token no parser recognises is dropped with a one-time `kDebugMode` hint (except the deliberate no-ops such as `transition` and `antialiased`); a recognised family with an unsupported value (like `text-7xl`, claimed by `text-*`) drops silently. Hand-check values. |
| Spacing in rem | Logical pixels (4 px per unit; `p-4` = 16 px). Adjust via `WindThemeData.baseSpacingUnit`. |
| `w-full` inside a Row works | A bare `w-full` row child is treated as `flex-1` (wrapped in `Expanded`) and fills the row; prefer `flex-1` for clarity. `md:w-full` is not auto-expanded. |
| `h-full` inside a scrollable parent works | A child's `h-full` on a `WDiv` vertical scroll asserts in debug; under a plain `SingleChildScrollView` it silently takes the screen height. Use `flex-1` in a `flex flex-col`, `min-h-screen`, or a fixed-height container. |
| `overflow-y-auto` enables iOS tap-to-top | Add the constructor prop `scrollPrimary: true` as well. There is no className for it. |
| `dark:` is optional | Every colour token needs a `dark:` peer in the same className (Core Law §2). |
| `bg-opacity-50` (v3) | Removed in Wind. Use the v4-style `bg-red-500/50`. |
| `!flex` (v3 important) / `flex!` (v4 important) | Does not exist. Re-order or use `states:` instead. |
| `@apply`, `@layer`, `@variant`, `@theme`, theme directives | Do not exist. Wind has no CSS layer. |
| `@container` / `@sm:` container queries | Do not exist. Viewport breakpoints only. |
| `group-*` / `peer-*` sibling state selectors | Do not exist. Use `states:` for cross-widget state. |
| `divide-*`, `filter`, `backdrop-blur`, 3D transforms | Do not exist. |
| `ps-*` / `pe-*` / `ms-*` / `me-*` logical inline | Do not exist. Use `pl-` / `pr-` / `ml-` / `mr-` (physical). |
| Negative margins `-m-4` | Not supported. Restructure layout instead. |
| `w-auto` / `h-auto` | Silently skipped. Omit the token (Flutter defaults to intrinsic sizing). |
| `shadow-sm` / `shadow` / `rounded-sm` / `rounded` semantics | Match Tailwind v3 (Wind has not rolled the v4 rename one step down). |

**Wind-only additions Tailwind lacks**: `ios:` `android:` `macos:` `windows:` `linux:` `web:` `mobile:` platform prefixes. `axis-min` / `axis-max` for Flutter `MainAxisSize`. Inline colour props (`WDiv.backgroundColor`, `WText.foregroundColor`) that bypass the cache key. `WBreakpoint` for per-breakpoint widget builders. `WDynamic` for JSON-driven trees. `preserve-colors` token for `WSvg`.

## 6. Flutter constraint reality (the six layout rules CSS does not have)

Wind hides most boilerplate but never changes Flutter's "constraints down, sizes up, parent sets position" model. Six rules cover ~90% of overflow errors. Full recipe catalogue + assertion-to-fix mapping: `${CLAUDE_SKILL_DIR}/references/layouts.md`.

| Rule | Wrong | Right |
|---|---|---|
| **Row children: prefer `flex-1`** (a bare `w-full` now also works, treated as `flex-1`) | n/a | `WDiv(className: 'flex flex-row', children: [WDiv(className: 'flex-1', ...)])` |
| **A grow claim turns off `justify-*`'s shrink wrap** (so `flex-1` keeps the whole remainder, siblings stay at content width; `overflow-hidden` still wraps) | expecting `justify-between` to split the row evenly between a `flex-1` child and a 24 dp icon | `WDiv(className: 'flex flex-row justify-between', children: [WDiv(className: 'flex-1', ...), WIcon(...)])` |
| **Scrollable children use `flex-1`, not `h-full`** | `WDiv(className: 'flex flex-col', children: [WDiv(className: 'overflow-y-auto h-full', ...)])` → unbounded height | `WDiv(className: 'flex flex-col h-full', children: [WDiv(className: 'flex-1 overflow-y-auto', scrollPrimary: true, ...)])` |
| **`absolute` requires `relative` parent** | `WDiv(className: 'flex', children: [..., WDiv(className: 'absolute top-0 right-0')])` does not position correctly | `WDiv(className: 'relative flex', children: [..., WDiv(className: 'absolute top-0 right-0')])` |
| **`truncate` requires bounded width** | `WText('long...', className: 'truncate')` inside a Row | wrap in `WDiv(className: 'flex-1', child: WText(..., className: 'truncate'))` |
| **Nested flex with truncate needs `min-w-0`** | `WDiv(className: 'flex-1 flex flex-col', children: [WText(..., className: 'truncate')])` | `WDiv(className: 'flex-1 flex flex-col min-w-0', children: [WText(..., className: 'truncate')])` |
| **Icon buttons need ≥48 dp touch target** | `WButton(child: WIcon(Icons.close_outlined))` (visual size 24 dp) | `WButton(semanticLabel: 'Close', className: 'p-3 rounded-lg', child: WIcon(Icons.close_outlined))` (48 dp tap target) |
| **Icon-only buttons need `semanticLabel`** | `WButton(child: WIcon(Icons.close_outlined))` (nameless to screen readers / `getByRole`) | `WButton(semanticLabel: 'Close', child: WIcon(Icons.close_outlined))` |
| **`semanticLabel` overrides child text** | `WButton(semanticLabel: 'Save', child: WText('Save'))` (label set alongside visible text; the child's text is excluded from semantics) | omit it when the child has readable text; prefer it only for icon-only controls where no text is present |
| **`semanticLabel` excludes the word "button"** | `semanticLabel: 'Close button'` (announced as "Close button button") | `semanticLabel: 'Close'` (the role appends "button") |

`items-stretch` inside a `SingleChildScrollView` needs an `IntrinsicHeight` wrapper from native Flutter; Wind has no token for it. Rare; reach for it when row children inside a scroll must match heights.

**Intrinsic sizing limitation.** `IntrinsicHeight` / `IntrinsicWidth` around content that contains a `grid` throws `LayoutBuilder does not support returning intrinsic dimensions`: the grid composes a `Wrap` inside a `LayoutBuilder`, which cannot answer intrinsic queries (a Flutter constraint). Use the grid's own `items-stretch` for equal-height rows, or explicit `h-*` / `size-*` cells.

## 7. className formatting

Multi-line triple-quoted when the className covers 3+ concerns. One concern per line. Group `dark:` peers beside their light variant, not at the bottom.

Wrong (one long line, hard to scan, easy to miss a missing `dark:` peer):

```dart
className: 'rounded-lg p-4 border-2 border-gray-200 bg-white text-gray-900 hover:bg-gray-50',
```

Right (concerns visible, dark pairs paired inline, hover state grouped):

```dart
WDiv(
  className: '''
    rounded-lg p-4 border-2
    border-gray-200 dark:border-gray-700
    bg-white dark:bg-gray-800
    text-gray-900 dark:text-white
    hover:bg-gray-50 dark:hover:bg-gray-700
  ''',
  child: ...,
);
```

Single line is fine when the className is genuinely short (1-2 concerns, ≤ 60 chars). Don't force triple-quoting on `'text-lg font-bold'`.

Never embed Dart expressions in className. Route every dynamic visual through `states:` plus prefixed classes (Core Law §3), or through `backgroundColor` / `foregroundColor` inline props for runtime-dynamic colours.

## 8. Forms (when to reach for `WForm*`)

Two widget families, parallel surface, different scope.

| Family | Use when | Validation |
|---|---|---|
| Raw `WInput` / `WSelect` / `WCheckbox` / `WDatePicker` | Stateless reads, controlled forms managed by an external state library (Riverpod, Bloc, ChangeNotifier), or single fields without a Form | Manual: caller inspects `value` and renders error UI |
| `WFormInput` / `WFormSelect` / `WFormMultiSelect` / `WFormCheckbox` / `WFormDatePicker` | Multi-field forms inside `Form` + `GlobalKey<FormState>`. Each widget extends `FormField<T>` and integrates with `FormState.validate()` | Auto: pass `validator: (T?) => String?`. `state.hasError` injects the `error:` state for `error:border-red-500` styling. Pass `autovalidateMode: AutovalidateMode.onUserInteraction` to keep the form quiet until first interaction. |

Idiomatic form:

```dart
final _formKey = GlobalKey<FormState>();

Form(
  key: _formKey,
  child: WDiv(
    className: 'flex flex-col gap-4 p-6',
    children: [
      WFormInput(
        label: 'Email',
        type: InputType.email,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        className: '''
          rounded-lg p-3 border
          border-gray-300 dark:border-gray-600
          bg-white dark:bg-gray-800
          focus:ring-2 focus:ring-blue-500 dark:focus:ring-blue-400
          error:border-red-500 dark:error:border-red-400
        ''',
        validator: (value) {
          if (value == null || value.isEmpty) return 'Required';
          if (!value.contains('@')) return 'Invalid email';
          return null;
        },
        onSaved: (value) => _email = value ?? '',
      ),
      WButton(
        className: 'bg-blue-600 dark:bg-blue-500 hover:bg-blue-700 dark:hover:bg-blue-600 text-white px-6 py-3 rounded-lg',
        onTap: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            _submit();
          }
        },
        child: const Text('Submit'),
      ),
    ],
  ),
);
```

For server-side or async validation the WForm* widgets take no `forceErrorText`: keep the server message in your own state, have the field's `validator` return it (`validator: (v) => _serverError ?? localCheck(v)`), run the async work after `validate()` returns `true`, then `setState(() => _serverError = result.message)` and call `_formKey.currentState!.validate()` again so the `error:` state fires. Clear `_serverError` in the field's `onChanged` so the user can retry after editing, and discard a response whose submitted value no longer matches the field (compare against what you sent before applying it).

`WFormDatePicker` range mode gotcha: the `FormFieldState<DateTime>` stores only `range.start`. A validator inspecting "is the range complete" must reach for the controller's internal state separately.

Full Form patterns + validation recipes + async error flow: `${CLAUDE_SKILL_DIR}/references/forms.md`.

## 9. Wind ≠ Flutter rules of thumb

| Need | Reach for |
|---|---|
| App shell, navigation rails, drawer | `Scaffold` (Material), not WDiv |
| Title bar | `AppBar` / `SliverAppBar` (Material) |
| Modal sheet | `showModalBottomSheet(...)` (Material), content built with Wind |
| Toast / snackbar | `ScaffoldMessenger.of(context).showSnackBar(...)` (Material) |
| Dialog / confirm | `showDialog(...)` + `AlertDialog` (Material), content built with Wind |
| Virtualised list (large or dynamic item count) | `ListView.builder` / `GridView.builder` (Flutter), each item built with Wind |
| Tab bar | `TabBar` / `TabBarView` (Material) or `NavigationBar` (Material 3) |
| Cross-route shared animation | `Hero` (Flutter), wrap the W-widget being shared |
| Multi-property implicit animation | `AnimatedContainer` (Flutter); Wind's `animate-*` is for looping animations only (spin / pulse / ping / bounce) |
| Routing | `go_router` (community-canonical) or `Navigator 2.0`; Wind has no router |
| Async state stream | `FutureBuilder` / `StreamBuilder` / `ValueListenableBuilder` (Flutter), composed with W-widgets in the builder |
| Static row / column / wrap / stack | `WDiv` with `flex` / `flex-row` / `flex-col` / `wrap` / `relative+absolute` tokens |
| Static grid | `WDiv` with `grid grid-cols-N gap-N` (renders as `Wrap`, not virtualised; add `items-stretch` for equal-height rows) |
| Form integration with validation | `WForm*` family inside Flutter's `Form` + `GlobalKey<FormState>` |

`WDynamic` is the JSON-driven alternative when a server, A/B framework, or remote-config service supplies the widget tree at runtime. Whitelisted by default (13 Wind + 16 Flutter core types); extend with `builders:` / `customIcons:`; restrict with `denyWidgets:`. Reach for it only when remote rendering is a hard requirement; for static UI write Dart.

## 10. Definition of done for a Wind change

Per change (every UI edit), verify all seven:

1. **Every colour token has a `dark:` peer** in the same className block. Grep your diff for `bg-`, `text-`, `border-`, `ring-`, `fill-`, `shadow-` and confirm a `dark:` peer on each, except a colour that reads the same in both modes (the exemption in Core Law 2, such as a solid `-500` status fill or white text on a saturated button).
2. **Every multi-concern className (3+ token families) is triple-quoted**, one concern per line, dark pairs grouped beside their light variant.
3. **Every interactive surface has `hover:` and `focus:` states** (web/desktop targets) on `WButton`, `WAnchor`, `WInput`, `WSelect`, `WCheckbox`, `WDatePicker`, plus `disabled:` styling wherever the widget exposes an `enabled` / `disabled` parameter.
4. **Every `child` XOR `children`**: never both. Construction-time assertion.
5. **Every scrollable root `WDiv` has `scrollPrimary: true`** on at least one ancestor in the scroll chain so iOS status-bar-tap scrolls to top.
6. **No Dart string interpolation inside className**, no inline `BoxDecoration` / `TextStyle` / `EdgeInsets` when a token covers it, no `Icons.*` (non-outlined) without a deliberate reason, no `WIcon` without `Icons.*_outlined`.
7. **Every icon-only `WButton` / `WAnchor` has a `semanticLabel`**: without it the control is nameless to screen readers and `getByRole('button', { name })`. When set, the child subtree is excluded from semantics, so `semanticLabel` overrides any child text rather than concatenating with it. Prefer it for icon-only controls; omit it when the child already carries readable text. Do not put the word "button" in the label; the role appends it.

Run `dart analyze` on the touched files and visually verify the change in light and dark mode (toggle via `context.windTheme.toggleTheme()` if there is no UI for it yet) before reporting done. Missing dark pairs only surface when the app is actually in dark mode.

## 11. Common patterns (the agent will reach for these first)

| Pattern | Recipe |
|---|---|
| Centred card | `WDiv(className: 'mx-auto max-w-md p-6 bg-white dark:bg-gray-800 rounded-lg shadow-sm', child: ...)` |
| Vertical stack | `WDiv(className: 'flex flex-col gap-4', children: [...])` |
| Horizontal stack | `WDiv(className: 'flex flex-row items-center gap-3', children: [...])` |
| Responsive grid 1→2→3 | `WDiv(className: 'grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4', children: cards)` |
| Sticky header + scrollable body | Outer `flex flex-col h-full`, header `shrink-0`, body `flex-1 overflow-y-auto` + `scrollPrimary: true` |
| Full-page scroll | `WDiv(className: 'w-full h-full overflow-y-auto p-4', scrollPrimary: true, child: ...)` |
| Hide on mobile, show md+ | `className: 'hidden md:flex'` |
| Gradient header banner | `bg-gradient-to-br from-indigo-600 to-purple-600 p-8 rounded-2xl` (paired with `dark:from-indigo-500 dark:to-purple-500`) |
| Toggle / chip with selected state | `states: isSelected ? {'selected'} : const {}`; className uses `selected:bg-blue-500 selected:text-white dark:selected:bg-blue-400 dark:selected:text-gray-900` |
| Disabled secondary action | `WButton(disabled: true, className: 'disabled:opacity-50 disabled:cursor-not-allowed', ...)` |
| Loading button | `WButton(isLoading: _isSubmitting, className: 'loading:bg-blue-400 dark:loading:bg-blue-500 ...', child: const Text('Save'))` |
| Avatar with fallback | `WImage(src: user.avatarUrl, className: 'w-12 h-12 rounded-full object-cover', errorBuilder: (_, __, ___) => WIcon(Icons.person_outlined, className: 'text-gray-400 dark:text-gray-500'))` |
| Form field error styling | className includes `error:border-red-500 dark:error:border-red-400 error:ring-1 error:ring-red-500 dark:error:ring-red-400`: auto-activates when validator returns non-null |
| Popover menu | `WPopover(triggerBuilder: (_, isOpen, __) => WButton(...), contentBuilder: (_, close) => WDiv(...), alignment: PopoverAlignment.bottomRight)` |
| Per-breakpoint widget swap | `WBreakpoint(base: (_) => MobileLayout(), md: (_) => TabletLayout(), lg: (_) => DesktopLayout())` |
| Status badge / pill | `WDiv(className: 'flex flex-row items-center gap-1 rounded-full px-2 py-0.5 bg-green-100 dark:bg-green-900 text-green-700 dark:text-green-200 text-xs font-medium', children: [WIcon(Icons.circle_outlined, className: 'w-2 h-2'), const WText('Active')])` |
| Empty state | `WDiv(className: 'flex flex-col items-center justify-center gap-3 p-8', children: [WIcon(Icons.inbox_outlined, className: 'w-12 h-12 text-gray-400 dark:text-gray-500'), const WText('No items yet', className: 'text-base font-medium text-gray-700 dark:text-gray-200'), const WText('Tap the + button to add one.', className: 'text-sm text-gray-500 dark:text-gray-400 text-center'), WButton(onTap: _create, className: 'mt-2 bg-blue-600 dark:bg-blue-500 hover:bg-blue-700 dark:hover:bg-blue-600 text-white px-4 py-2 rounded-lg', child: const Text('Create'))])` |
| App shell | `Scaffold(appBar: AppBar(title: const Text(...)), body: WDiv(className: 'flex flex-col h-full', children: [...]))`: Material `Scaffold` + `AppBar` wraps; Wind owns the body |
| Icon-only button (48dp tap target) | `WButton(semanticLabel: 'Close', className: 'p-3 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700', onTap: _close, child: const WIcon(Icons.close_outlined))` |

Full recipe catalogue with code: `${CLAUDE_SKILL_DIR}/references/layouts.md`. Which token a visual should be (hierarchy levels, the type and spacing scales, semantic and status colour pairs, touch-target floors, depth, iOS navigation rules): `${CLAUDE_SKILL_DIR}/references/design-culture.md`. Reach for it whenever the task arrives without a design spec, or when a layout renders correctly and still looks wrong.

## 12. Anti-patterns wall

Compact catalogue of consistent footguns. Each entry: what's wrong, why, the corrected shape.

| Wrong | Why | Right |
|---|---|---|
| `WDiv(child: x, children: [y])` | Construction-time assertion fails | one or the other |
| `WIcon(Icons.settings)` | Filled Material icon (off-brand for Wind) | `WIcon(Icons.settings_outlined)` |
| `className: 'flex-wrap'` | Works (aliased to `wrap`), but `wrap` is the canonical token and avoids the debug hint | `'wrap gap-2'` |
| `className: 'text-7xl'` | Font scale stops at 6xl; silent no-op | `'text-6xl'` (cap), `'text-[72px]'` for a larger size, or a `7xl` key in `WindThemeData.fontSizes` |
| `className: 'w-full'` inside a Row (works, but `flex-1` is clearer) | No failure, just intent clarity | `'flex-1'` |
| `className: 'h-full'` inside a scrollable | Asserts in a WDiv scroll; takes the screen height elsewhere | `'flex-1 overflow-y-auto'` + `scrollPrimary: true` on the constructor |
| `className: 'overflow-y-auto'` without `scrollPrimary: true` | iOS tap-to-top broken | add the constructor prop |
| `className: 'bg-white'` alone | Missing dark pair = bug | `'bg-white dark:bg-gray-800'` |
| `className: '${isOn ? "bg-blue-500" : "bg-gray-100"}'` | Breaks parser cache; defeats prefix system | `states: isOn ? {'active'} : const {}` + static className with `active:bg-blue-500` |
| `BoxDecoration(color: ...)` / `TextStyle(fontSize: ...)` / `EdgeInsets.all(...)` inline | Wind has tokens for these | use the className tokens |
| `Container(child: ...)` instead of `WDiv` | Loses className surface | use `WDiv` |
| A sub-barrel import such as `package:wind_kit/widgets.dart` | Only the main barrel exists | `import 'package:wind_kit/wind_kit.dart'` |
| `group-hover:` / `peer-focus:` / `@container` / `@apply` / `!important` / `divide-*` / `filter` / `backdrop-blur` / `place-*` (claimed by the flex parser, no handler) / `ps-*` / `pe-*` / `ms-*` / `me-*` / `-m-N` / `w-auto` | Not implemented in Wind | see `tailwind-divergence.md` for substitutes |
| `className: 'absolute top-0'` without `relative` ancestor | `Stack` requires sibling `relative` to anchor | wrap parent in `relative` |
| `WText` with `truncate` inside Row without bounded width | Overflow | wrap in `WDiv(className: 'flex-1')` |
| Putting `dark:` peers at the bottom of a long className | Hard to audit; missing pairs slip through | group beside the light variant on the same line |
| `active:bg-blue-700` for press feedback | No widget tracks press (Core Law §10); `active:` applies only through `states: {'active'}` | track press in consumer state and pass `states: {'active'}` |
| Adding a `Focus` or `Shortcuts` wrapper to make a `WAnchor` keyboard-reachable | Already wired (Core Law §11); `onTap` answers `ActivateIntent` | pass `onTap` and let `Enter` / `Space` / D-pad `select` reach it |
| Expecting `focus:ring-*` on a `WDiv` inside a tappable `WAnchor` to need its own focus node | The gestureless wrapper inherits focus from the anchor (Core Law §11) | style the div, put the gesture on the anchor, leave the nodes alone |
| Inline `Padding(padding: EdgeInsets.all(16))` around a `WDiv` | Duplicates work | move the padding into the `WDiv` className as `p-4` |
| Asserting `uppercase` output for Turkish in a bare `pumpWidget` | Casing reads the ambient locale, and with no `Localizations` ancestor it falls back to Dart's locale-independent rules, so the assertion measures the fallback | wrap the subtree in `Localizations(locale: Locale('tr'), delegates: [DefaultWidgetsLocalizations.delegate], ...)` |

## 13. Quick install

This skill is written for Flutter apps that already depend on `wind_kit`, so this section is the rare bootstrap path: it applies only when the host app does not yet have Wind.

```yaml
# pubspec.yaml
dependencies:
  wind_kit: ^1.12.0
  material_ui: ^1.11.0
```

```dart
// lib/main.dart
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:material_ui/material_ui.dart';
import 'package:wind_kit/wind_kit.dart';

void main() {
  if (!kReleaseMode) {
    Wind.installDebugResolver();           // one-time; exposes className+state to tapir; tree-shaken in release
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return WindTheme(
      data: WindThemeData(/* every field is optional; defaults apply otherwise */),
      builder: (context, controller) => MaterialApp(
        theme: controller.toThemeData(),
        home: const Scaffold(body: HomePage()),
      ),
    );
  }
}
```

Brightness syncs with the OS by default. Toggle manually via `context.windTheme.toggleTheme()` (disables auto-sync). Reset to OS via `context.windTheme.resetToSystem()`. Read brightness from `context.windIsDark`. Full theme customisation (custom colour palettes, custom breakpoints, custom font families, `baseSpacingUnit` for non-4 px spacing scale): `${CLAUDE_SKILL_DIR}/references/theme.md`.

`WindThemeData.aliases` (`Map<String, String>`, empty by default) maps bare-token shorthand keys to full className strings (for example `{'btn-primary': 'bg-blue-600 dark:bg-blue-500 text-white px-4 py-2 rounded-lg'}`). Keys are bare tokens (no prefix, no colon), and a prefixed use still resolves: `hover:btn-primary` expands with `hover:` re-applied to every produced token. Expansion is recursive, an alias wins over a real token of the same name (with a debug warning), and it runs in `WindParser.parse`, so aliases work in every widget and in `WDynamic`.

`Wind.installDebugResolver()` is one-time setup behind `!kReleaseMode`. Idempotent; a no-op in release builds. Do not add it on every UI change: it belongs in `main.dart` only.

## 14. Testing

Test className-styled widgets with plain `flutter_test`: wrap the widget in a `WindTheme` with the `builder` form (`MaterialApp(theme: controller.toThemeData(), home: Scaffold(body: child))`), call `WindParser.clearCache()` in `setUp` because the cache persists between tests and gives false positives, and set a desktop-sized `tester.view.physicalSize` before pumping a layout that uses `md:` and above. Find icon-only controls with `find.bySemanticsLabel`, which is why they need a `semanticLabel`. Wind ships no matchers of its own; a complete example and the diagnostics helpers are in `${CLAUDE_SKILL_DIR}/references/debug.md`.

## 15. References (load on trigger)

| Load when... | File |
|---|---|
| Verifying a className token exists, picking the right family, looking up an arbitrary-value pattern, or auditing for unsupported syntax | `${CLAUDE_SKILL_DIR}/references/tokens.md` |
| Writing a specific W-widget and needing the full constructor surface (every named parameter, every default, every callback signature) | `${CLAUDE_SKILL_DIR}/references/widgets.md` |
| Building a `Form`, picking between `WInput` and `WFormInput`, wiring `FormState.validate()`, handling async / server-side errors, the WFormDatePicker range gotcha | `${CLAUDE_SKILL_DIR}/references/forms.md` |
| Picking a layout pattern: 12+ canonical recipes plus a deep-dive on Flutter's constraint model (RenderFlex, IntrinsicHeight, unbounded scroll, Positioned ancestry) | `${CLAUDE_SKILL_DIR}/references/layouts.md` |
| Customising `WindThemeData` (custom colours, custom breakpoints, font families, baseSpacingUnit), brightness toggling, responsive prefixes, platform prefixes, the OverlayEntry context caveat | `${CLAUDE_SKILL_DIR}/references/theme.md` |
| Migrating a Tailwind v3 or v4 className from web, or recovering from a "this token does not seem to do anything" stall | `${CLAUDE_SKILL_DIR}/references/tailwind-divergence.md` |
| Rendering a JSON-defined widget tree via `WDynamic`: schema, allowed types, custom builders, custom icons, action handlers, state binding by `id`, security model | `${CLAUDE_SKILL_DIR}/references/dynamic.md` |
| Wiring `Wind.installDebugResolver()` for tapir / E2E tooling, understanding the parser cache (and the `WindParser.clearCache()` test discipline), reading WindLogger output for performance debugging | `${CLAUDE_SKILL_DIR}/references/debug.md` |
| Deciding which token a visual should be, not whether it exists: hierarchy levels, the type and spacing scales, semantic + status + dark-surface colour pairs, touch-target floors, depth, mobile patterns, iOS navigation rules, the design anti-pattern wall | `${CLAUDE_SKILL_DIR}/references/design-culture.md` |

When the agent stalls on a token, layout, or widget, the first reach is one of these files, not a guess.
