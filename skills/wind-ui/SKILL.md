---
name: wind-ui
description: "Build Flutter UI with Wind UI 1.0 — utility-first className strings, 19 W-widgets, dark-mode pairs, responsive + platform prefixes, and the WindTheme integration. Triggers whenever a Flutter agent is producing or modifying UI in a project that depends on `fluttersdk_wind`."
when_to_use: |
  TRIGGER: WDiv, WText, WButton, WInput, WSelect, WCheckbox, WIcon, WImage, WSvg, WPopover, WAnchor, WFormInput, WFormSelect, WFormMultiSelect, WFormCheckbox, WDatePicker, WFormDatePicker, WSpacer, WDynamic, WBreakpoint, className, WindTheme, WindThemeData, fluttersdk_wind, wind-ui, utility-first Flutter, Tailwind for Flutter.
  DO NOT TRIGGER: Flutter questions without className usage, raw Dart logic without UI, backend/API code, projects that do not depend on `fluttersdk_wind`.
version: 1.0.0
---

<!-- Wind UI 1.0.0 stable | Skill rewritten 2026-05-22 | Codebase HEAD: v1 | upstream sync target: github.com/fluttersdk/ai -->

# Wind UI 1.0

You are writing Flutter code for an app that depends on `fluttersdk_wind` 1.0. Wind is utility-first styling: every visual decision lives in a `className` string parsed at build time into a `WindStyle` value object, then composed into a native Flutter widget tree. This is "Tailwind for Flutter" — same naming, same `dark:`/`hover:`/`md:` prefix language, different physics.

This skill stays loaded as long as a Wind file is open. Use it as the live consumer reference; never invent tokens, never guess at constructor signatures.

## 1. Mental model in five lines

1. **Widgets**: 19 W-prefix widgets. `WDiv` (not Container), `WText` (not Text), `WButton` (not ElevatedButton).
2. **Styling**: every visual change goes through `className: String?`. Inline Dart props (`backgroundColor`, `foregroundColor`) override className.
3. **Prefixes**: `dark:` (theme), `hover:`/`focus:`/`active:`/`disabled:`/`loading:`/`selected:` (state), `sm:`/`md:`/`lg:`/`xl:`/`2xl:` (responsive), `ios:`/`android:`/`web:`/`mobile:` (platform). Combine freely: `md:hover:bg-blue-500 dark:md:hover:bg-blue-400`.
4. **Last class wins**: `p-4 p-8` resolves to `p-8`. Order within className matters.
5. **Unknown tokens fail silently**: a typo (`text-7xl`, `flex-cow`) is a no-op, not an error. Spell-check by hand.

## 2. Getting started (5 lines of setup)

```yaml
# pubspec.yaml
dependencies:
  fluttersdk_wind: ^1.0.0
```

```dart
// main.dart
import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return WindTheme(
      data: WindThemeData(/* 23 optional fields; defaults applied */),
      builder: (context, controller) => MaterialApp(
        theme: controller.toThemeData(),
        home: const Scaffold(body: HomePage()),
      ),
    );
  }
}
```

Brightness syncs with the OS automatically. Toggle manually anywhere via `context.windTheme.toggleTheme()` (disables auto-sync), restore via `context.windTheme.resetToSystem()`. For debug-tooling integration: `if (kDebugMode) Wind.installDebugResolver();` once in `main.dart`. Full setup details in `references/getting-started.md`.

## 3. Wind ≠ Tailwind (the cheat sheet a Tailwind developer needs first)

A developer fluent in Tailwind defaults to assumptions that Wind partially supports, partially rejects.

| Tailwind expectation | Wind reality |
|----------------------|--------------|
| `flex-wrap` enables wrapping | No-op. Use `wrap` instead (Flutter `Wrap` is a separate widget). |
| `text-*` means font-size | Overloaded: font-size (`text-xl`), color (`text-red-500`), alignment (`text-center`). Resolved by ordered regex. |
| Font sizes go to `9xl` | Stops at `6xl` (60 px). `7xl`/`8xl`/`9xl` silently no-op. |
| Spacing in `rem` | Logical pixels (4 px per unit; `p-4` = 16 px). |
| `w-full` inside a row works | Causes overflow. Use `flex-1` for row children. |
| `h-full` inside a scrollable parent | Infinite-height layout error. Use `min-h-screen`. |
| `overflow-y-auto` enables iOS tap-to-top | Pass the constructor prop `scrollPrimary: true` as well — there is no className for it. |
| `dark:` is optional | Every `bg-*`, `text-*`, `border-*`, `ring-*`, `fill-*` carries a `dark:` pair in the SAME className. Missing pair is a bug. |
| `!flex` (Tailwind v3) or `flex!` (v4) for important | Does not exist. |
| `@apply`, `@layer`, `@variant` directives | Do not exist (no CSS layer). |
| Container queries (`@container`, `@sm:`) | Do not exist. Viewport breakpoints only. |
| `group-*` / `peer-*` sibling selectors | Do not exist. Use `states: {...}` for cross-widget state. |
| `divide-*`, `cursor-*`, `filter`, `backdrop-blur` | Do not exist. |
| `text-red-500/50` opacity modifier on any color token | Supported on color-bearing parsers (text, bg, border, ring, fill, stroke, shadow). |
| `bg-opacity-50` (v3 deprecated form) | Does not exist; use `bg-red-500/50`. |

**Wind-only additions Tailwind lacks**: `ios:` / `android:` / `web:` / `mobile:` platform prefixes; `axis-min` / `axis-max` for Flutter `MainAxisSize` control; inline color props (`WDiv.backgroundColor`, `WText.foregroundColor`) for runtime-dynamic colors that bypass the cache key; `WDynamic` for JSON-driven widget trees; `WBreakpoint` for declarative per-breakpoint widget builders.

Full migration guide for Tailwind developers: `references/migrate-from-tailwind.md`.

## 4. Flutter constraint reality (the six layout rules CSS does not have)

Wind hides most boilerplate but never changes Flutter's "constraints down, sizes up, parent sets position" model. Six rules cover 90% of consumer overflow errors.

| Rule | Wrong | Right |
|------|-------|-------|
| **Row children use `flex-1`, not `w-full`** | `WDiv(className: 'flex flex-row', children: [WDiv(className: 'w-full', child: ...)])` → RenderFlex overflowed | `WDiv(className: 'flex flex-row', children: [WDiv(className: 'flex-1', child: ...)])` |
| **Scrollable children use `flex-1`, not `h-full`** | `WDiv(className: 'flex flex-col', children: [WDiv(className: 'overflow-y-auto h-full', ...)])` → unbounded height | `WDiv(className: 'flex flex-col h-full', children: [WDiv(className: 'flex-1 overflow-y-auto', scrollPrimary: true, ...)])` |
| **`absolute` requires `relative` parent** | `WDiv(className: 'flex', children: [..., WDiv(className: 'absolute top-0 right-0', ...)])` | `WDiv(className: 'relative flex', children: [..., WDiv(className: 'absolute top-0 right-0', ...)])` |
| **`truncate` requires bounded width** | `WText('long text...', className: 'truncate')` inside a Row | wrap in `WDiv(className: 'flex-1', child: WText(..., className: 'truncate'))` |
| **Nested flex needs `min-w-0`** | `WDiv(className: 'flex-1 flex flex-col', children: [WText(..., className: 'truncate')])` | `WDiv(className: 'flex-1 flex flex-col min-w-0', children: [WText(..., className: 'truncate')])` |
| **Icon buttons need ≥48 dp touch target** | `WButton(child: WIcon(Icons.close))` — undersized | `WButton(className: 'p-3 rounded-lg', child: WIcon(Icons.close_outlined))` |

Full constraint reference + the 12 canonical layout recipes: `references/layouts.md`.

## 5. The 19 W-widgets at a glance

| Widget | Category | One-line purpose |
|--------|----------|------------------|
| `WDiv` | Layout | Universal container; auto-wraps in WAnchor on hover/focus/active. |
| `WSpacer` | Layout | Lightweight SizedBox from `w-N` / `h-N` only. |
| `WText` | Display | Typography; required positional `data: String`. |
| `WIcon` | Display | Material icons; use `Icons.*_outlined` variants only. |
| `WImage` | Display | Network/asset/ImageProvider; `object-cover` default. |
| `WSvg` | Display | `WSvg(src: 'asset://...')` or `WSvg.string('<svg>...')`; `fill-*` recolors. |
| `WButton` | Interactive | Wraps WAnchor + WDiv; built-in loading state. |
| `WAnchor` | Interactive | Low-level gesture + focus + hover state propagator. |
| `WInput` | Form | Controlled TextField; type-driven keyboard config. |
| `WCheckbox` | Form | Boolean checkbox with `checked:` state prefix. |
| `WSelect<T>` | Form | Single/multi-select with overlay; optional search, tagging, pagination. |
| `WDatePicker` | Form | Single date OR range mode; popover-based. |
| `WFormInput` / `WFormSelect` / `WFormMultiSelect` / `WFormCheckbox` / `WFormDatePicker` | Form wrappers | Extend `FormField<T>`; integrate with `Form` + `GlobalKey<FormState>`; inject `error:` state on validation failure. |
| `WPopover` | Overlay | OverlayPortal-based; `triggerBuilder` + `contentBuilder` + `PopoverController`. |
| `WDynamic` | Structural | Renders JSON → widget tree with whitelist security + state binding + action dispatch. |
| `WBreakpoint` | Structural | Declarative per-breakpoint builders when className prefixes are not enough. |

Full constructor signatures + every parameter: `references/widgets.md`.

## 6. The state system

**Automatic states** (require WAnchor or auto-wrapped widget; `WDiv`/`WButton` auto-wrap when className contains `hover:` / `focus:` / `active:`):
- `hover:` — pointer hover (web/desktop)
- `focus:` — keyboard focus
- `active:` — mid-press

**Manual states** via `states: Set<String>?` constructor parameter:
- `selected:` — `states: {'selected'}`
- `loading:` — `states: {'loading'}` (WButton sets this automatically when `isLoading: true`)
- `disabled:` — `states: {'disabled'}` (WButton sets this when `disabled: true`)
- `checked:` — WCheckbox sets this when `value: true`
- `error:` — WForm* widgets inject this when `state.hasError`
- Custom: `states: {'highlighted'}` + className `highlighted:bg-yellow-100`

**Combining prefixes**: order is arbitrary; all must match. `md:hover:bg-blue-500 dark:md:hover:bg-blue-400` activates on md+ breakpoint AND hover state AND dark theme.

```dart
// Conditional styling: do NOT interpolate; use `states:`
WDiv(
  className: '''
    rounded-lg p-4 border-2
    border-gray-200 dark:border-gray-700
    bg-white dark:bg-gray-800
    selected:border-blue-500 selected:bg-blue-50
    dark:selected:border-blue-400 dark:selected:bg-blue-950
  ''',
  states: isSelected ? {'selected'} : const {},
  child: ...,
);
```

String interpolation in className breaks the parser cache; never write `'bg-${isOn ? "blue" : "gray"}-500'`. Use `states:` for state-driven branching, inline color props for runtime values.

## 7. The Definition of Done for a Wind change

Before reporting a UI change complete, verify all five:

1. **Every color token has a `dark:` pair** in the same className. Grep your diff for `bg-`, `text-`, `border-`, `ring-`, `fill-`, `shadow-` and confirm a `dark:` peer.
2. **Every multi-line className (3+ concerns) is triple-quoted**, one concern per line, with `dark:` peers grouped beside their light variant.
3. **Every interactive surface has `hover:` and `focus:` states** if the widget renders on web/desktop. `disabled:` if it has an enabled flag.
4. **Every `child` XOR `children`** — assert fires at construction; mixing is a compile-time-shaped runtime crash.
5. **Every scrollable root WDiv has `scrollPrimary: true`** — required for iOS tap-to-top.

Plus the structural rules: `WIcon` uses `Icons.*_outlined`; constructor params are multi-line + trailing commas when 3+; no Dart string interpolation inside className; no inline `BoxDecoration` / `TextStyle` / `EdgeInsets` when a Wind equivalent exists.

## 8. Common patterns the agent will reach for

| Pattern | Quick recipe |
|---------|--------------|
| Centered card | `mx-auto max-w-md p-6 bg-white dark:bg-gray-800 rounded-lg shadow-sm` |
| Vertical stack | `flex flex-col gap-4` |
| Responsive grid 1→2→3 cols | `grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4` |
| Sticky header + scrollable body | `flex flex-col h-full` + header WDiv + `flex-1 overflow-y-auto scrollPrimary: true` |
| Full-page scroll | `w-full h-full overflow-y-auto p-4 scrollPrimary: true` |
| Hide on mobile, show md+ | `hidden md:flex` |
| Gradient header banner | `bg-gradient-to-br from-indigo-600 to-purple-600 p-8 rounded-2xl` |
| Form with validation | `Form(key: _formKey, child: WDiv(flex flex-col gap-4, children: [WFormInput(...)]))` |

Full 12-pattern catalog with code: `references/layouts.md`. Form patterns + validation: `references/forms.md`.

## 9. Reference index

Load these on-demand for depth. Each file is self-contained.

| File | Load when |
|------|-----------|
| `references/widgets.md` | Need the full constructor surface of a specific W-widget, including every optional parameter. |
| `references/tokens.md` | Need to verify a className token exists or check its full token family. The canonical 17-parser inventory. |
| `references/getting-started.md` | Setting up a new Flutter project with Wind: install, MaterialApp wrap, dark toggle, debug bridge. |
| `references/forms.md` | Building forms with WForm* + `Form` + `GlobalKey<FormState>` + validation + error display. |
| `references/layouts.md` | Picking a layout pattern: 12 canonical recipes + Flutter constraint reality + common scrollable shapes. |
| `references/responsive.md` | Breakpoint cascade rules, `WBreakpoint` widget, platform prefixes, `axis-min` / `axis-max`. |
| `references/dark-mode.md` | Dark-mode discipline, brightness sync, manual toggle, the `dark:` pair invariant. |
| `references/migrate-from-tailwind.md` | A Tailwind developer's complete v3/v4 → Wind difference catalog. |

## Anti-patterns wall (never write these in Wind)

| Wrong | Why | Correct |
|-------|-----|---------|
| `WDiv(child: x, children: [y])` | Assertion failure | one or the other |
| `WIcon(Icons.settings)` | filled icon (off-brand) | `Icons.settings_outlined` |
| `className: 'flex-wrap'` | Flutter `Wrap` is separate; no-op | `'wrap gap-2'` |
| `className: 'text-7xl'` / `'text-8xl'` / `'text-9xl'` | font-size table stops at `6xl` | `'text-6xl'` |
| `className: 'w-full'` inside a Row | overflow | `'flex-1'` |
| `className: 'h-full'` inside a scrollable | infinite height | `'flex-1 overflow-y-auto'` with `scrollPrimary: true` |
| `className: 'overflow-y-auto'` without `scrollPrimary: true` | iOS tap-to-top broken | add the constructor prop |
| `className: 'bg-white'` alone | no dark pair = bug | `'bg-white dark:bg-gray-800'` |
| `className: '${isOn ? "bg-blue-500" : "bg-gray-100"}'` | breaks parser cache | static className + `states: {'active'}` + `active:bg-blue-500` |
| `BoxDecoration(color: ...)` / `TextStyle(fontSize: ...)` inline | Wind has a className for it | use the className |
| `WindDuskIntegration.install()` (pre-1.0 API) | removed in alpha-9/10 | `Wind.installDebugResolver()` |
| `import 'package:fluttersdk_wind/dusk_integration.dart'` | sub-barrel removed | main barrel only |
| `group-hover:` / `peer-focus:` / `@container` / `@apply` / `!important` / `divide-*` / `cursor-*` / `filter` / `backdrop-blur` | not implemented | see `migrate-from-tailwind.md` |
| `className: 'absolute top-0'` without `relative` parent | Stack required | `WDiv(className: 'relative ...', children: [..., WDiv(className: 'absolute top-0')])` |
| `WText` inside Row without bounded width when using `truncate` | overflow | wrap in `flex-1` |

---

You build UI. The references are detailed. Reach into them when you need depth; stay terse when you do not.
