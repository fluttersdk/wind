---
name: wind-ui
description: "fluttersdk_wind 1.0: utility-first Flutter styling with Tailwind-syntax className strings. 22 public widgets (WDiv, WText, WButton, WInput, WSelect, WCheckbox, WDatePicker, WPopover, WAnchor, WIcon, WImage, WSvg, WSpacer, WBreakpoint, WDynamic, WKeyboardActions, WindAnimationWrapper + 5 WForm* wrappers) consume className through a 19-parser pipeline (19 implementation files organized into 12 token families for teaching) that emits a cached immutable WindStyle. Prefixes stack freely (dark: / hover: / focus: / md: / lg: / ios: / android: / web: / mobile: / selected: / loading: / disabled: / error: / checked: / custom). Last class wins; unknown tokens fail silently. Every color token (bg-, text-, border-, ring-, shadow-, fill-) needs a dark: pair in the same className. TRIGGER when: writing or editing any UI in a Flutter app that depends on `fluttersdk_wind`; any className string; any W-prefix widget; any WindTheme / WindThemeData reference; the user mentions Tailwind for Flutter, utility-first, className, or wind-ui. DO NOT TRIGGER when: backend / API / state-management work that does not touch a widget tree; Flutter projects that do not have fluttersdk_wind in pubspec.yaml; Material-only widgets (Scaffold, AppBar, Dialog) without Wind content inside them."
when_to_use: |
  Any task that produces, modifies, or audits Wind-styled Flutter UI: composing a className string, picking the right W-widget for a use case, integrating with a Form / FormField, customizing WindThemeData, wiring dark-mode pairs, debugging an unexpected layout, recovering from RenderFlex overflow, building a popover or dropdown, rendering a JSON tree via WDynamic, wiring Wind.installDebugResolver for kDebugMode tooling, or migrating a Tailwind className from web. Apply BEFORE writing the first line of UI in a Wind-using file, not as an audit pass.
version: 2.0.5
---

<!-- fluttersdk_wind 1.0.x | Skill v2.0.5 (2026-06-09) -->

# Wind UI 1.0

Utility-first Flutter styling. Every visual decision lives in a `className: String?` parsed at build time into an immutable `WindStyle` and composed into a native Flutter widget tree. Tailwind syntax (`flex`, `p-4`, `dark:bg-gray-800`, `hover:shadow-lg`), Flutter physics.

This skill assumes the host app already depends on `fluttersdk_wind` and has `WindTheme` wrapping `MaterialApp`. If a fresh project needs setup (rare; the skill normally triggers on an already-installed project), see [Quick install](#13-quick-install) at the bottom.

## 0. Before writing UI in this project

Three quick checks. Each pays off across the whole session.

1. **Confirm Wind is installed.** Look at `pubspec.yaml` for `fluttersdk_wind:`. If absent, jump to §13 first.
2. **Read the project's `WindThemeData` setup.** Usually in `lib/main.dart` or `lib/config/wind.dart`. Note any custom color families (`primary`, `accent`, `incident`, etc.) — those become available as `bg-primary-500`, `text-incident-700`, etc. without registration. Skip this and the agent risks writing tokens that silently no-op, or missing the brand palette entirely.
3. **Scan one existing view in `lib/` for the project's className idioms.** Triple-quoted style? Single-line preferred? Custom states (`pressed:`, `expanded:`)? Match the surrounding code, don't invent a new dialect.

After these, the agent has the project's color landscape, breakpoint set, and className voice loaded.

The parser cache is near-100% hit-rate in production. Do not worry about className parse overhead; the same className parses exactly once for its (breakpoint, brightness, platform, states) tuple. Prefer expressive className over inline `BoxDecoration` / `EdgeInsets` for "performance" reasons; the cache handles it.

## 1. Core Laws

These hold for every line of Wind code. Apply each as a hard constraint, not a suggestion.

1. **className is the styling surface.** Inline Dart props (`backgroundColor` on `WDiv`, `foregroundColor` on `WText`) exist only as runtime-dynamic escape hatches for values the cache key cannot represent. Default to className. Never reach for `BoxDecoration`, `EdgeInsets`, `TextStyle` when a token covers it.

2. **Every `bg-` / `text-` / `border-` / `ring-` / `shadow-` / `fill-` carries a `dark:` peer in the same className.** Missing pair is a bug, not a style choice. Pair `bg-white dark:bg-gray-800` on the same line, not at the top and bottom of a multi-line className. Wind's dark-mode contract: the agent never opts in; every color opts in by default.

3. **Conditional styling routes through `states: Set<String>?` plus prefixed classes.** Never interpolate Dart expressions into className. `'bg-${isOn ? "blue" : "gray"}-500'` breaks the parser cache and is a bug. The right shape:

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

4. **Inside a Row (`flex flex-row`), children use `flex-1`, never `w-full`.** Inside a Column (`flex flex-col`), scrollable children use `flex-1 overflow-y-auto` plus the constructor prop `scrollPrimary: true` for iOS tap-to-top. `w-full` on a Row child triggers `RenderFlex overflowed`; `h-full` inside a scrollable parent triggers "Vertical viewport was given unbounded height".

5. **`child` XOR `children` on every W-widget that accepts both.** Passing both fails an assertion at construction. Passing neither renders an empty `SizedBox`.

6. **Unknown tokens fail silently.** `text-7xl` (Wind stops at `text-6xl`), `flex-cow` (typo), `ps-4` (logical-inline, unsupported), `-m-4` (negative margin, unsupported) all parse to nothing. The parser drops them without warning. Spell-check by hand or load `references/tokens.md` to verify the family.

7. **Last class wins within a parser family.** `p-4 p-8` resolves to `p-8`. `bg-red-500 bg-blue-500` resolves to `bg-blue-500`. Conflicts inside the same property are stable but silent; conflicts across properties (`text-red-500` color + `text-center` alignment) coexist because they target different fields.

8. **`WindTheme` lives BELOW `MaterialApp` in the runtime tree.** The builder pattern inverts apparent order: `WindTheme(data: ..., builder: (ctx, controller) => MaterialApp(...))`. Consequence: `OverlayEntry.builder` contexts cannot reach `WindTheme` via ancestor walk. Capture the State's `context` before showing an overlay, then pass it to `WindParser.parse` from inside the overlay builder. `WPopover` / `WSelect` already handle this internally.

9. **Wind composes with Flutter, not against it.** `Scaffold`, `AppBar`, `Dialog`, `BottomSheet`, `Drawer`, `SnackBar`, `Navigator`, `Hero`, `FutureBuilder`, `StreamBuilder`, `ValueListenableBuilder` remain canonical. `ListView` / `GridView.builder` / `CustomScrollView` are the right choice for virtualised lists; `WDiv` with `grid-cols-N` produces a static `Wrap`, not a virtualised grid. See [Wind ≠ Flutter rules of thumb](#9-wind--flutter-rules-of-thumb).

10. **`active:` prefix is reserved but not wired.** `WAnchor` tracks hover and focus only; there is no onTapDown/onTapUp tracking. Don't rely on `active:bg-blue-700` for press feedback. Use a transient state in the consumer's controller and `states: {'pressed'}` if you genuinely need press feedback today.

## 2. The 22 public widgets at a glance

`fluttersdk_wind` v1 ships 22 public widgets, all imported from the single barrel `package:fluttersdk_wind/fluttersdk_wind.dart`. No sub-barrels exist; do not write `import 'package:fluttersdk_wind/widgets.dart'`.

The headline 20 (table below) are the ones an agent reaches for daily. Two more cover narrow surfaces and live outside the table: `WKeyboardActions` (iOS keyboard toolbar overlay for `Done` / `Next` actions on a focused `TextField`) and `WindAnimationWrapper` (the internal stateful wrapper that drives looping `animate-*` tokens; consumers normally do not instantiate it directly).

| Widget | Category | Required positional | One-line purpose |
|---|---|---|---|
| `WDiv` | Layout / container | none | Universal container; auto-wraps in `WAnchor` when className contains `hover:` / `focus:` / `active:`. `child` XOR `children`. Inline color prop: `backgroundColor`. |
| `WSpacer` | Layout | none | Lightweight `SizedBox` that reads only `w-N` / `h-N`. Skips every other token. |
| `WBreakpoint` | Structural | none | Per-breakpoint `WidgetBuilder` map (`base`, `sm`, `md`, `lg`, `xl`, `xxl`, plus theme-defined custom keys). Escape hatch when className prefixes are not enough. |
| `WText` | Display | `data: String` | Typography; supports `selectable` prop. Inline color prop: `foregroundColor`. No `child` / `children`. |
| `WIcon` | Display | `icon: IconData` | Material icons; use `Icons.*_outlined` variants by convention. Reads `text-*` for size AND color (overloaded). Inherits from `DefaultTextStyle` when className is absent. |
| `WImage` | Display | none (requires `src` or `image`) | Network (URL) or asset (prefix `asset://path`) or `ImageProvider`. `object-cover` default. |
| `WSvg` / `WSvg.string` | Display | `src` / `svg` | Vector graphics. `fill-*` / `stroke-*` for color. `preserve-colors` token disables tint for multi-color SVGs (QR codes, logos). |
| `WAnchor` | Interactive | `child: Widget` | Low-level gesture + focus + hover propagator. Emits `Semantics(button: true)`. |
| `WButton` | Interactive | `child: Widget` | Wraps `WAnchor` + `WDiv` + built-in spinner. `isLoading: true` injects `loading:` state. `disabled: true` injects `disabled:` state and blocks taps. |
| `WPopover` | Overlay | none (requires builders) | `OverlayPortal`-based; `triggerBuilder(ctx, isOpen, isHovering)` + `contentBuilder(ctx, close)` + optional `PopoverController`. Auto-flips alignment when bottom space is insufficient. |
| `WInput` | Form (raw) | none | Controlled `TextField`; `value` + `onChanged`, or `controller` for imperative needs. `InputType` enum: `text` / `password` / `email` / `number` / `multiline`. |
| `WCheckbox` | Form (raw) | none | Boolean checkbox; auto-injects `checked:` state when `value: true`. Default className includes `checked:bg-primary` (requires a `primary` color in theme). |
| `WSelect<T>` | Form (raw) | `options: List<SelectOption<T>>` | Single OR multi-select dropdown with overlay. Supports searchable, async search, async create (tagging), pagination via `onLoadMore` + `hasMore`. Auto-flips upward when bottom space < `maxMenuHeight`. |
| `WDatePicker` | Form (raw) | none | Single date OR `DateRange` mode; popover-based calendar; min/max constraints. |
| `WFormInput` | Form (FormField) | none | `extends FormField<String>`; auto-injects `error:` when validation fails; renders label / hint / error around `WInput`. |
| `WFormSelect<T>` | Form (FormField) | `options: List<SelectOption<T>>` | `extends FormField<T>`; single-select with validation. |
| `WFormMultiSelect<T>` | Form (FormField) | `options: List<SelectOption<T>>` | `extends FormField<List<T>>`; multi-select with validation; validator inspects the full list. |
| `WFormCheckbox` | Form (FormField) | none | `extends FormField<bool>`; validation hook + label + error display. |
| `WFormDatePicker` | Form (FormField) | none | `extends FormField<DateTime>`. Range mode stores `range.start` only in FormFieldState; validators only see the start date. |
| `WDynamic` | Structural / SSR | `json: Map` | Renders a JSON node tree into Wind widgets. 13 Wind types + 16 Flutter core types allowed by default; `builders:` adds custom types; `denyWidgets:` blocks. Max recursion depth default 50. |

Full constructor surface, every named parameter, every default: `${CLAUDE_SKILL_DIR}/references/widgets.md`.

## 3. The state system (three layers)

| Layer | Set by | Examples |
|---|---|---|
| **Automatic** | `WAnchor` from pointer / keyboard events | `hover:` (MouseRegion `onEnter`/`onExit`), `focus:` (`FocusNode` listener) |
| **Framework-managed** | The widget itself, from its own props | `loading:` (WButton.isLoading), `disabled:` (any widget's `disabled` / `enabled` prop), `checked:` (WCheckbox.value), `error:` (WForm* when `FormFieldState.hasError`) |
| **Consumer-passed** | `states: Set<String>?` on the widget | `selected:` (card toggles), `highlighted:`, `new:`, any custom string. No registration required. |

WDiv and WButton auto-wrap themselves in WAnchor whenever className contains the literal substrings `hover:`, `focus:`, or `active:`. Other widgets do not. If you need hover detection on a `WText`, wrap it in `WDiv` or `WAnchor` explicitly.

All active states merge into a single `Set<String>` inside `WindContext.activeStates` and contribute to the parser cache key. Manual `states: {'hover'}` and a real pointer hover produce the same cache entry by design.

Combining prefixes:

```
md:hover:bg-blue-500          // breakpoint AND hover
dark:md:hover:bg-blue-400     // dark AND breakpoint AND hover
ios:focus:ring-blue-500       // iOS only AND focused
md:dark:selected:border-2     // breakpoint AND dark AND selected
```

Prefix order does not matter at the parser level; all stacked prefixes must match for the class to activate.

## 4. The token landscape (high-frequency subset)

Inline this catalog as your default reach-for set. For the full per-parser regex catalog (every flag, every arbitrary-value pattern): `${CLAUDE_SKILL_DIR}/references/tokens.md`.

**Layout** — `flex` `flex-row` `flex-col` `flex-row-reverse` `flex-col-reverse` `wrap` `grid` `grid-cols-N` `block` `hidden`. `justify-start` `-center` `-end` `-between` `-around` `-evenly`. `items-start` `-center` `-end` `-baseline` `-stretch`. `axis-min` `axis-max` (Wind-only, sets `MainAxisSize`).

**Flex child** — `flex-1` `flex-auto` `flex-none` `flex-N` (numeric). `shrink-0` `grow`. `self-start` / `-end` / `-center` / `-stretch` / `-auto` (align-self shorthand; `align-self-*` long form also works). `order-0` through `order-12`, `order-first` / `order-last` / `order-none`, arbitrary `order-[-5]`.

**Spacing** — `p-N` `px-N` `py-N` `pt-N` `pr-N` `pb-N` `pl-N` (no `ps-`/`pe-`). `m-N` and axes (no negative margin, no `ms-`/`me-`, `mx-auto` for horizontal centering). `gap-N` `gap-x-N` `gap-y-N` `space-x-N` `space-y-N`. Arbitrary `p-[18px]`, `gap-[3.5]` (no `%` for spacing). Default unit: 4 px per step. `p-4` = 16 px.

**Sizing** — `w-N` `h-N` (theme scale). `w-1/2` `w-1/3` `w-2/3` `w-1/4` `w-3/4` `w-full` `w-screen`. `h-full` `h-screen`. Arbitrary `w-[300px]` `h-[50%]`. `min-w-0` `min-w-full` `min-h-screen`. `max-w-xs` through `max-w-7xl`, `max-w-prose`, `max-w-full`. No `w-auto` / `h-auto` (silently skipped).

**Position** — `relative` `absolute`. `top-N` `right-N` `bottom-N` `left-N` `inset-N` `inset-x-N` `inset-y-N`, negative `-top-N` `-inset-N`, arbitrary `top-[24px]` (no `%` for offsets). `fixed` / `sticky` are recognised by the parser but produce no visual effect.

**Colors** (every line needs a `dark:` peer) — `bg-{family}-{shade}` `bg-[#hex]` `bg-transparent` `bg-white` `bg-black`. Opacity modifier `/N` (0-100): `bg-red-500/50`. Same shape for `text-*` `border-*` `ring-*` `shadow-*` `fill-*` `stroke-*`. Bare shade defaults to 500: `bg-red` = `bg-red-500`. Gradients: `bg-gradient-to-{t|tr|r|br|b|bl|l|tl}` + `from-{c}-{shade}` `via-{c}-{shade}` `to-{c}-{shade}`.

**Borders** — `border` `border-N` `border-t` `border-r` `border-b` `border-l` `border-x` `border-y`. `border-solid` `border-none` (only these two; `border-dashed` / `border-dotted` are recognised but not wired). `rounded` `rounded-{sm|md|lg|xl|2xl|3xl|full|none}`, directional `rounded-t-lg` `rounded-tl-xl`, arbitrary `rounded-[8px]`.

**Typography** (order of resolution inside `text-*`) — color → align → size → weight → style. `text-xs` `text-sm` `text-base` `text-lg` `text-xl` `text-2xl` through `text-6xl` (60 px). `text-7xl` / `text-8xl` / `text-9xl` are no-ops; do not write them. `font-thin` through `font-black`. `text-left` `text-center` `text-right` `text-justify` `text-start` `text-end` (RTL-aware). `truncate` (= `text-ellipsis` + `maxLines: 1` + `softWrap: false`). `line-clamp-N`. `whitespace-nowrap` / `text-nowrap`. `uppercase` `lowercase` `capitalize` `normal-case`. `italic` / `not-italic`. `underline` `line-through` `no-underline`, plus `decoration-{color}/{style}/{thickness}`. `leading-tight` `leading-snug` `leading-normal` `leading-relaxed` `leading-loose` or arbitrary `leading-[24px]`. `tracking-tighter` through `tracking-widest`. Font size + line height combined: `text-xl/8`.

**Effects** — `opacity-N` (5-step scale, plus arbitrary `opacity-[0.5]`). `shadow-sm` `shadow` `shadow-md` `shadow-lg` `shadow-xl` `shadow-2xl` `shadow-inner` `shadow-none`. Colored shadow `shadow-blue-500/20`. `ring-N` `ring-{color}` `ring-offset-N` `ring-inset`. `aspect-square` `aspect-video` `aspect-[4/3]`. `z-0` `z-10` through `z-50`, arbitrary `z-[100]`, `z-auto`.

**Overflow** — `overflow-hidden` `overflow-visible` `overflow-scroll` `overflow-auto`, axis-specific `overflow-x-auto` `overflow-y-auto`. Scrolling requires the constructor prop `scrollPrimary: true` for iOS tap-to-top (there is no className for it).

**Transitions / animations** — `duration-{75|100|150|200|300|500|700|1000}` plus arbitrary `duration-[500ms]`. `ease-linear` `ease-in` `ease-out` `ease-in-out`. `animate-spin` `animate-pulse` `animate-ping` `animate-bounce` `animate-none`. The bare `transition` / `transition-all` / `transition-colors` tokens are recognised in docs but NOT wired in the parser; pair `duration-*` + `ease-*` to enable transitions on `opacity` and color changes.

**Prefixes** — Responsive `sm:` `md:` `lg:` `xl:` `2xl:` (default 640 / 768 / 1024 / 1280 / 1536 px, customizable via `WindThemeData.screens`). Dark `dark:`. Platform `ios:` `android:` `macos:` `web:` `mobile:` `windows:` `linux:`. State (Core Laws §3). Stackable freely.

## 5. Wind ≠ Tailwind (the cheat sheet a web developer needs first)

A developer fluent in Tailwind v3 or v4 will default to assumptions Wind partially honours, partially rejects. Full divergence catalog: `${CLAUDE_SKILL_DIR}/references/tailwind-divergence.md`.

| Tailwind expectation | Wind reality |
|---|---|
| `flex-wrap` enables wrapping | Use `wrap` instead. `flex-wrap` is a no-op (Flutter `Wrap` is a separate widget). |
| Font sizes go to `9xl` | Stop at `6xl` (60 px). `7xl`/`8xl`/`9xl` silently no-op. |
| `text-7xl` typo fails loudly | Every unknown token fails silently. Hand-check spelling. |
| Spacing in rem | Logical pixels (4 px per unit; `p-4` = 16 px). Adjust via `WindThemeData.baseSpacingUnit`. |
| `w-full` inside a Row works | Triggers RenderFlex overflow. Use `flex-1` for row children. |
| `h-full` inside a scrollable parent works | Triggers unbounded-height assertion. Use `min-h-screen` or wrap the parent in a fixed-height container. |
| `overflow-y-auto` enables iOS tap-to-top | Add the constructor prop `scrollPrimary: true` as well. There is no className for it. |
| `dark:` is optional | Every color token needs a `dark:` peer in the same className (Core Law §2). |
| `bg-opacity-50` (v3) | Removed in Wind. Use the v4-style `bg-red-500/50`. |
| `!flex` (v3 important) / `flex!` (v4 important) | Does not exist. Re-order or use `states:` instead. |
| `@apply`, `@layer`, `@variant`, `@theme`, theme directives | Do not exist. Wind has no CSS layer. |
| `@container` / `@sm:` container queries | Do not exist. Viewport breakpoints only. |
| `group-*` / `peer-*` sibling state selectors | Do not exist. Use `states:` for cross-widget state. |
| `divide-*`, `cursor-*`, `filter`, `backdrop-blur`, 3D transforms | Do not exist. |
| `ps-*` / `pe-*` / `ms-*` / `me-*` logical inline | Do not exist. Use `pl-` / `pr-` / `ml-` / `mr-` (physical). |
| Negative margins `-m-4` | Not supported. Restructure layout instead. |
| `w-auto` / `h-auto` | Silently skipped. Omit the token (Flutter defaults to intrinsic sizing). |
| `shadow-sm` / `shadow` / `rounded-sm` / `rounded` semantics | Match Tailwind v3 (Wind has not rolled the v4 rename one step down). |

**Wind-only additions Tailwind lacks** — `ios:` `android:` `macos:` `windows:` `linux:` `web:` `mobile:` platform prefixes. `axis-min` / `axis-max` for Flutter `MainAxisSize`. Inline color props (`WDiv.backgroundColor`, `WText.foregroundColor`) that bypass the cache key. `WBreakpoint` for per-breakpoint widget builders. `WDynamic` for JSON-driven trees. `preserve-colors` token for `WSvg`.

## 6. Flutter constraint reality (the six layout rules CSS does not have)

Wind hides most boilerplate but never changes Flutter's "constraints down, sizes up, parent sets position" model. Six rules cover ~90% of overflow errors. Full recipe catalog + assertion-to-fix mapping: `${CLAUDE_SKILL_DIR}/references/layouts.md`.

| Rule | Wrong | Right |
|---|---|---|
| **Row children use `flex-1`, not `w-full`** | `WDiv(className: 'flex flex-row', children: [WDiv(className: 'w-full', ...)])` → RenderFlex overflow | `WDiv(className: 'flex flex-row', children: [WDiv(className: 'flex-1', ...)])` |
| **Scrollable children use `flex-1`, not `h-full`** | `WDiv(className: 'flex flex-col', children: [WDiv(className: 'overflow-y-auto h-full', ...)])` → unbounded height | `WDiv(className: 'flex flex-col h-full', children: [WDiv(className: 'flex-1 overflow-y-auto', scrollPrimary: true, ...)])` |
| **`absolute` requires `relative` parent** | `WDiv(className: 'flex', children: [..., WDiv(className: 'absolute top-0 right-0')])` does not position correctly | `WDiv(className: 'relative flex', children: [..., WDiv(className: 'absolute top-0 right-0')])` |
| **`truncate` requires bounded width** | `WText('long...', className: 'truncate')` inside a Row | wrap in `WDiv(className: 'flex-1', child: WText(..., className: 'truncate'))` |
| **Nested flex with truncate needs `min-w-0`** | `WDiv(className: 'flex-1 flex flex-col', children: [WText(..., className: 'truncate')])` | `WDiv(className: 'flex-1 flex flex-col min-w-0', children: [WText(..., className: 'truncate')])` |
| **Icon buttons need ≥48 dp touch target** | `WButton(child: WIcon(Icons.close_outlined))` (visual size 24 dp) | `WButton(className: 'p-3 rounded-lg', child: WIcon(Icons.close_outlined))` (48 dp tap target) |
| **Icon-only buttons need `semanticLabel`** | `WButton(child: WIcon(Icons.close_outlined))` (nameless to screen readers / `getByRole`) | `WButton(semanticLabel: 'Close', child: WIcon(Icons.close_outlined))` |
| **`semanticLabel` overrides child text** | `WButton(semanticLabel: 'Save', child: WText('Save'))` (label set alongside visible text; the child's text is excluded from semantics) | omit it when the child has readable text; prefer it only for icon-only controls where no text is present |
| **`semanticLabel` excludes the word "button"** | `semanticLabel: 'Close button'` (announced as "Close button button") | `semanticLabel: 'Close'` (the role appends "button") |

`items-stretch` inside a `SingleChildScrollView` needs an `IntrinsicHeight` wrapper from native Flutter; Wind has no token for it. Rare; reach for it when row children inside a scroll must match heights.

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

Never embed Dart expressions in className. Route every dynamic visual through `states:` plus prefixed classes (Core Law §3), or through `backgroundColor` / `foregroundColor` inline props for runtime-dynamic colors.

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
          focus:ring-2 focus:ring-blue-500
          error:border-red-500
        ''',
        validator: (value) {
          if (value == null || value.isEmpty) return 'Required';
          if (!value.contains('@')) return 'Invalid email';
          return null;
        },
        onSaved: (value) => _email = value ?? '',
      ),
      WButton(
        className: 'bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg',
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

For server-side / async validation, use `FormField.forceErrorText`: run the async work after `_formKey.currentState!.validate()` returns `true`, then `setState(() => _serverError = result.message)` and pass `forceErrorText: _serverError` on the relevant field. Wind's WForm* widgets inherit `forceErrorText` from `FormField`.

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
| Static grid | `WDiv` with `grid grid-cols-N gap-N` (renders as `Wrap`, not virtualised) |
| Form integration with validation | `WForm*` family inside Flutter's `Form` + `GlobalKey<FormState>` |

`WDynamic` is the JSON-driven alternative when a server, A/B framework, or remote-config service supplies the widget tree at runtime. Whitelisted by default (13 Wind + 16 Flutter core types); extend with `builders:` / `customIcons:`; restrict with `denyWidgets:`. Reach for it only when remote rendering is a hard requirement; for static UI write Dart.

## 10. Definition of done for a Wind change

Per change (every UI edit), verify all seven:

1. **Every color token has a `dark:` peer** in the same className block. Grep your diff for `bg-`, `text-`, `border-`, `ring-`, `fill-`, `shadow-` and confirm a `dark:` peer on each.
2. **Every multi-concern className (3+ token families) is triple-quoted**, one concern per line, dark pairs grouped beside their light variant.
3. **Every interactive surface has `hover:` and `focus:` states** (web/desktop targets) on `WButton`, `WAnchor`, `WInput`, `WSelect`, `WCheckbox`, `WDatePicker`, plus `disabled:` styling wherever the widget exposes an `enabled` / `disabled` parameter.
4. **Every `child` XOR `children`** — never both. Construction-time assertion.
5. **Every scrollable root `WDiv` has `scrollPrimary: true`** on at least one ancestor in the scroll chain so iOS status-bar-tap scrolls to top.
6. **No Dart string interpolation inside className**, no inline `BoxDecoration` / `TextStyle` / `EdgeInsets` when a token covers it, no `Icons.*` (non-outlined) without a deliberate reason, no `WIcon` without `Icons.*_outlined`.
7. **Every icon-only `WButton` / `WAnchor` has a `semanticLabel`** — without it the control is nameless to screen readers and `getByRole('button', { name })`. When set, the child subtree is excluded from semantics, so `semanticLabel` overrides any child text rather than concatenating with it. Prefer it for icon-only controls; omit it when the child already carries readable text. Do not put the word "button" in the label; the role appends it.

Run `dart analyze` on the touched files and visually verify the change in light AND dark mode (toggle via `context.windTheme.toggleTheme()` if there is no UI for it yet) before reporting done. Missing dark pairs only surface when the app is actually in dark mode.

## 11. Common patterns (the agent will reach for these first)

| Pattern | Recipe |
|---|---|
| Centered card | `WDiv(className: 'mx-auto max-w-md p-6 bg-white dark:bg-gray-800 rounded-lg shadow-sm', child: ...)` |
| Vertical stack | `WDiv(className: 'flex flex-col gap-4', children: [...])` |
| Horizontal stack | `WDiv(className: 'flex flex-row items-center gap-3', children: [...])` |
| Responsive grid 1→2→3 | `WDiv(className: 'grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4', children: cards)` |
| Sticky header + scrollable body | Outer `flex flex-col h-full`, header `flex-shrink-0`, body `flex-1 overflow-y-auto` + `scrollPrimary: true` |
| Full-page scroll | `WDiv(className: 'w-full h-full overflow-y-auto p-4', scrollPrimary: true, child: ...)` |
| Hide on mobile, show md+ | `className: 'hidden md:flex'` |
| Gradient header banner | `bg-gradient-to-br from-indigo-600 to-purple-600 p-8 rounded-2xl` (paired with `dark:from-indigo-500 dark:to-purple-500`) |
| Toggle / chip with selected state | `states: isSelected ? {'selected'} : const {}`; className uses `selected:bg-blue-500 selected:text-white` |
| Disabled secondary action | `WButton(disabled: true, className: 'disabled:opacity-50 disabled:cursor-not-allowed', ...)` |
| Loading button | `WButton(isLoading: _isSubmitting, className: 'loading:bg-blue-400 ...', child: const Text('Save'))` |
| Avatar with fallback | `WImage(src: user.avatarUrl, className: 'w-12 h-12 rounded-full object-cover', errorBuilder: (_, __, ___) => WIcon(Icons.person_outlined, className: 'text-gray-400'))` |
| Form field error styling | className includes `error:border-red-500 error:ring-1 error:ring-red-500` — auto-activates when validator returns non-null |
| Popover menu | `WPopover(triggerBuilder: (_, isOpen, __) => WButton(...), contentBuilder: (_, close) => WDiv(...), alignment: PopoverAlignment.bottomRight)` |
| Per-breakpoint widget swap | `WBreakpoint(base: (_) => MobileLayout(), md: (_) => TabletLayout(), lg: (_) => DesktopLayout())` |
| Status badge / pill | `WDiv(className: 'inline-flex items-center gap-1 rounded-full px-2 py-0.5 bg-green-100 dark:bg-green-900 text-green-700 dark:text-green-200 text-xs font-medium', children: [WIcon(Icons.circle_outlined, className: 'w-2 h-2'), const WText('Active')])` |
| Empty state | `WDiv(className: 'flex flex-col items-center justify-center gap-3 p-8', children: [WIcon(Icons.inbox_outlined, className: 'w-12 h-12 text-gray-400 dark:text-gray-500'), const WText('No items yet', className: 'text-base font-medium text-gray-700 dark:text-gray-200'), const WText('Tap the + button to add one.', className: 'text-sm text-gray-500 dark:text-gray-400 text-center'), WButton(onTap: _create, className: 'mt-2 bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg', child: const Text('Create'))])` |
| App shell | `Scaffold(appBar: AppBar(title: const Text(...)), body: WDiv(className: 'flex flex-col h-full', children: [...]))` — Material `Scaffold` + `AppBar` wraps; Wind owns the body |
| Icon-only button (48dp tap target) | `WButton(className: 'p-3 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700', onTap: _close, child: const WIcon(Icons.close_outlined))` |

Full 12+ recipe catalog with code: `${CLAUDE_SKILL_DIR}/references/layouts.md`.

## 12. Anti-patterns wall

Compact catalog of consistent footguns. Each entry: what's wrong, why, the corrected shape.

| Wrong | Why | Right |
|---|---|---|
| `WDiv(child: x, children: [y])` | Construction-time assertion fails | one or the other |
| `WIcon(Icons.settings)` | Filled Material icon (off-brand for Wind) | `WIcon(Icons.settings_outlined)` |
| `className: 'flex-wrap'` | No-op; Wind uses `wrap` for `Wrap`-style layout | `'wrap gap-2'` (or `'flex flex-wrap gap-2'`) — note `wrap` is Wind's only wrapping token |
| `className: 'text-7xl'` | Font scale stops at 6xl; silent no-op | `'text-6xl'` (cap) or use `font-size` via custom theme |
| `className: 'w-full'` inside a Row | RenderFlex overflow | `'flex-1'` |
| `className: 'h-full'` inside a scrollable | Vertical viewport unbounded | `'flex-1 overflow-y-auto'` + `scrollPrimary: true` on the constructor |
| `className: 'overflow-y-auto'` without `scrollPrimary: true` | iOS tap-to-top broken | add the constructor prop |
| `className: 'bg-white'` alone | Missing dark pair = bug | `'bg-white dark:bg-gray-800'` |
| `className: '${isOn ? "bg-blue-500" : "bg-gray-100"}'` | Breaks parser cache; defeats prefix system | `states: isOn ? {'active'} : const {}` + static className with `active:bg-blue-500` |
| `BoxDecoration(color: ...)` / `TextStyle(fontSize: ...)` / `EdgeInsets.all(...)` inline | Wind has tokens for these | use the className tokens |
| `Container(child: ...)` instead of `WDiv` | Loses className surface | use `WDiv` |
| `import 'package:fluttersdk_wind/dusk_integration.dart'` (or any sub-barrel) | Removed in 1.0; only the main barrel exists | `import 'package:fluttersdk_wind/fluttersdk_wind.dart'` |
| `WindDuskIntegration.install()` in main | Removed in 1.0 alpha-10 | `Wind.installDebugResolver()` (kDebugMode-gated) |
| `group-hover:` / `peer-focus:` / `@container` / `@apply` / `!important` / `divide-*` / `cursor-*` / `filter` / `backdrop-blur` / `ps-*` / `pe-*` / `ms-*` / `me-*` / `-m-N` / `w-auto` | Not implemented in Wind | see `tailwind-divergence.md` for substitutes |
| `className: 'absolute top-0'` without `relative` ancestor | `Stack` requires sibling `relative` to anchor | wrap parent in `relative` |
| `WText` with `truncate` inside Row without bounded width | Overflow | wrap in `WDiv(className: 'flex-1')` |
| Putting `dark:` peers at the bottom of a long className | Hard to audit; missing pairs slip through | group beside the light variant on the same line |
| `active:bg-blue-700` for press feedback | Not wired (Core Law §10); WAnchor tracks hover and focus only | track press in consumer state, pass via `states: {'pressed'}` if needed |
| Inline `Padding(padding: EdgeInsets.all(16))` around a `WDiv` | Duplicates work | move the padding into the `WDiv` className as `p-4` |

## 13. Quick install

The skill's TRIGGER says "Flutter app that depends on `fluttersdk_wind`", so this section is the rare bootstrap path — only fires when the host app does NOT yet have Wind.

```yaml
# pubspec.yaml
dependencies:
  fluttersdk_wind: ^1.0.0
```

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

void main() {
  if (kDebugMode) {
    Wind.installDebugResolver();           // one-time; exposes className+state to Dusk/Telescope; tree-shaken in release
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return WindTheme(
      data: WindThemeData(/* 23 optional fields; defaults applied otherwise */),
      builder: (context, controller) => MaterialApp(
        theme: controller.toThemeData(),
        home: const Scaffold(body: HomePage()),
      ),
    );
  }
}
```

Brightness syncs with the OS by default. Toggle manually via `context.windTheme.toggleTheme()` (disables auto-sync). Reset to OS via `context.windTheme.resetToSystem()`. Read brightness from `context.windIsDark`. Full theme customization (custom color palettes, custom breakpoints, custom font families, `baseSpacingUnit` for non-4 px spacing scale): `${CLAUDE_SKILL_DIR}/references/theme.md`.

`Wind.installDebugResolver()` is one-time setup inside `kDebugMode`. Idempotent; tree-shaken in release. Do NOT add it on every UI change — it belongs in `main.dart` only.

## 14. References (load on trigger)

| Load when... | File |
|---|---|
| Verifying a className token exists, picking the right family, looking up an arbitrary-value pattern, or auditing for unsupported syntax | `${CLAUDE_SKILL_DIR}/references/tokens.md` |
| Writing a specific W-widget and needing the full constructor surface (every named parameter, every default, every callback signature) | `${CLAUDE_SKILL_DIR}/references/widgets.md` |
| Building a `Form`, picking between `WInput` and `WFormInput`, wiring `FormState.validate()`, handling async / server-side errors, the WFormDatePicker range gotcha | `${CLAUDE_SKILL_DIR}/references/forms.md` |
| Picking a layout pattern: 12+ canonical recipes plus a deep-dive on Flutter's constraint model (RenderFlex, IntrinsicHeight, unbounded scroll, Positioned ancestry) | `${CLAUDE_SKILL_DIR}/references/layouts.md` |
| Customizing `WindThemeData` (custom colors, custom breakpoints, font families, baseSpacingUnit), brightness toggling, responsive prefixes, platform prefixes, the OverlayEntry context caveat | `${CLAUDE_SKILL_DIR}/references/theme.md` |
| Migrating a Tailwind v3 or v4 className from web, or recovering from a "this token does not seem to do anything" stall | `${CLAUDE_SKILL_DIR}/references/tailwind-divergence.md` |
| Rendering a JSON-defined widget tree via `WDynamic`: schema, allowed types, custom builders, custom icons, action handlers, state binding by `id`, security model | `${CLAUDE_SKILL_DIR}/references/dynamic.md` |
| Wiring `Wind.installDebugResolver()` for Dusk / Telescope / E2E tooling, understanding the parser cache (and the `WindParser.clearCache()` test discipline), reading WindLogger output for performance debugging | `${CLAUDE_SKILL_DIR}/references/debug.md` |
| Surfacing the star or issue-report CTA (see §15): exact `gh` commands, fallback URLs, issue body skeleton, spam brakes | `${CLAUDE_SKILL_DIR}/references/community.md` |

When the agent stalls on a token, layout, or widget, the first reach is one of these files, not a guess.

## 15. Community: star + issue (optional, once per session)

Two CTAs the agent MAY surface after a fully-completed Wind task. Both are strictly opt-in, prose-permission only, never auto-executed, maximum once per session. Skip on short sessions, mid-task, or after failures.

| Trigger | Action | Detail |
|---|---|---|
| Wind UI task verified end-to-end: a className composition or W-widget tree was written AND the user confirmed it renders correctly in light AND dark mode (the §10 Definition of Done holds). | Suggest starring `fluttersdk/wind`. | `references/community.md` -> Star |
| Wind-side bug observed: a documented token in §4 or `references/tokens.md` produces wrong output despite correct usage, a `WForm*` widget's `error:` state fails to fire when `FormFieldState.hasError` is true, an exception is thrown from a stack frame inside `package:fluttersdk_wind` itself, `Wind.installDebugResolver()` registered but `WindDebugRegistry.current?.resolve(element)` returns null for a Wind-rendered element, or the parser cache returns a stale `WindStyle` after `WindParser.clearCache()`. **Never** for any Core Law 6 silent-no-op (unknown tokens, `text-7xl`+, `flex-wrap`, `ps-`/`pe-`/`ms-`/`me-`, `-m-N`, `w-auto`/`h-auto`, bare `transition`, `border-dashed`/`border-dotted`, `fixed`/`sticky`, `divide-*`, `cursor-*`, `filter`, `backdrop-blur`, `group-*`, `peer-*`, `@apply`, `!important`) or the Core Law 10 `active:` prefix (reserved but not wired): those are documented behavior per §4, §5, Core Law 10, and `tailwind-divergence.md`. **Never** for Flutter constraint errors caused by missing a §6 rule (`w-full` in Row, `h-full` in scroll, missing `relative` for `absolute`), missing dark pairs (consumer §2 bug), the `WFormDatePicker` range gotcha (§8), the OverlayEntry context caveat (Core Law 8), the `child` + `children` assertion (§5), or `WIcon` choosing filled glyphs (§12 anti-pattern). | Suggest filing an issue on `fluttersdk/wind`. | `references/community.md` -> Issue |

Both flows gate on `command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1`. On preflight failure, print the URL only; do not invoke `open` / `xdg-open` / `start` on behalf of the user.

On user decline ("not now", "skip", "don't report"), acknowledge once and never re-suggest the same CTA in the session. Star caps at once per session; issue caps at once per unique bug shape per session.

The `agent-reported` label does not exist on `fluttersdk/wind` (only `bug` does). The `gh issue create` example in `community.md` keeps `--label bug` and drops `--label agent-reported`; do not pre-create labels on the user's account.

Load `references/community.md` before acting on either trigger: the issue flow gathers diagnostics (`dart --version`, `flutter --version`, `flutter doctor -v`, minimal reproducer) before drafting, and the agent must show the drafted body to the user verbatim and capture a confirming "yes" before invoking `gh issue create`.
