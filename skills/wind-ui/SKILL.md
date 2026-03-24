---
name: wind-ui
description: "Wind UI v1 utility-first styling for Flutter. ALWAYS activate for: WDiv, WText, WButton, WInput, WSelect, WCheckbox, WIcon, WImage, WSvg, WPopover, WAnchor, WFormInput, WFormSelect, WFormMultiSelect, WFormCheckbox, WDatePicker, WFormDatePicker, WSpacer, className, WindTheme, wind-ui, Flutter styling, Flutter layout, mobile UI, app design. Turkish: Flutter tasarım, uygulama arayüzü, mobil UI, Flutter stil, className kullanımı."
---

# Wind UI v1

Utility-first styling for Flutter UI. Translate Tailwind-like classes to Flutter render tree semantics via `className` string parsing.

## 1. Core Laws

1. **W-prefix mandate**: Use `WDiv` (not Container), `WText` (not Text), `WButton` (not ElevatedButton/GestureDetector).
2. **className-first**: ALL styling via `className` string. Never inline BoxDecoration, TextStyle, or EdgeInsets when a Wind equivalent exists.
3. **dark: is mandatory**: Every `bg-`, `text-`, and `border-` class MUST have a `dark:` counterpart.
4. **Trailing commas**: Always on the last constructor parameter and list item.
5. **Multi-line**: Constructor parameters must always be multi-line when 3 or more.
6. **No theory output**: When applying styling, do not explain the classes — just provide the code.

## 2. Flutter Layout Reality

Flutter constraint resolution differs fundamentally from CSS. Wind UI maps `className` syntax to native Flutter semantics. Follow these rules to avoid overflows and unbounded height errors.

**Space-filling**

| Goal | Use | Why |
|------|-----|-----|
| Fill remaining space in Row/Column | `flex-1` | Maps to `Expanded` — negotiates available space |
| Full width in Column context | `w-full` | `SizedBox(width: double.infinity)` — works here |
| Full width in Row context | `flex-1` (NOT `w-full`!) | `w-full` causes `RenderFlex` overflow in Rows |
| `flex-none` / `shrink-0` | No flex shrink — unlike CSS, Flutter Row/Column children DON'T auto-shrink; use `flex-1` to allow growth | Row child stays fixed width |

**Scrollable layouts**

| Goal | className | Required context |
|------|-----------|-----------------|
| Vertical scroll | `overflow-y-auto` + `scrollPrimary: true` | Parent MUST have bounded height |
| Bounded height for scroll | `flex-1` on the scrollable `WDiv` | Inside a Column/Flex parent |
| Horizontal scroll | `overflow-x-auto` | Same rules |

**WDiv Composition Rules**

| className contains | Flutter widget | Notes |
|-------------------|----------------|-------|
| `flex flex-col` | Column | `flex` alone defaults to Row |
| `flex flex-row` or `flex` | Row | Direction default |
| `wrap` or `grid` | Wrap | NOT `flex-wrap` (no-op!) |
| `overflow-y-auto` | SingleChildScrollView | Needs bounded height |
| `hidden` | SizedBox.shrink() | |

**Critical Layout Gotchas:**

```dart
// ❌ WRONG — overflow in Row
WDiv(
  className: 'flex flex-row',
  children: [
    WDiv(className: 'w-full', child: WText('Long text')), // OVERFLOW
  ],
)

// ✅ CORRECT
WDiv(
  className: 'flex flex-row',
  children: [
    WDiv(className: 'flex-1', child: WText('Long text')), // Fills remaining space
  ],
)
```

```dart
// ❌ WRONG — unbounded height scroll
Column(
  children: [
    WDiv(className: 'overflow-y-auto', children: [...]) // ERROR: infinite height
  ],
)

// ✅ CORRECT
WDiv(
  className: 'flex flex-col h-full', // Bounded
  children: [
    WDiv(
      className: 'flex-1 overflow-y-auto',
      scrollPrimary: true, // iOS tap-to-top
      children: [...],
    ),
  ],
)
```

```dart
// ❌ WRONG — truncate without bounded width
WDiv(
  className: 'flex flex-row',
  children: [
    WText('Very long title', className: 'truncate'), // OVERFLOW
  ],
)

// ✅ CORRECT
WDiv(
  className: 'flex flex-row',
  children: [
    WDiv(
      className: 'flex-1', // Bounds the text
      child: WText('Very long title', className: 'truncate'),
    ),
  ],
)
```

**Note:** `h-full` inside a scrollable parent results in an infinite height error. Use `min-h-screen` instead. Native Flutter widgets (e.g., `ListView.builder`, charts) inside a `Row` or `Column` MUST be wrapped in a manual `Expanded()`.

## 3. Widget Quick Reference

| Widget | Required Props | Key Optional Props | Use For |
|--------|---------------|-------------------|---------|
| `WDiv` | - | `className`, `child`/`children`, `states`, `scrollPrimary` | Any container, layout |
| `WText` | `data` | `className`, `selectable`, `states` | All text rendering |
| `WButton` | `child` | `onTap`, `isLoading`, `disabled`, `className` | All interactive buttons |
| `WInput` | `value`, `onChanged`| `type`, `placeholder`, `className`, `placeholderClassName`| Standalone inputs |
| `WSelect` | `options`, `value`/`values`, `onChange` | `searchable`, `isMulti`, `onCreateOption`, `className`| Dropdowns |
| `WCheckbox`| `value`, `onChanged`| `className` | Toggle checkboxes |
| `WIcon` | `icon` | `className` | Icons with styling |
| `WImage` | `src` | `className` | Images with object-fit |
| `WSvg` | `src` | `className`, `preserve-colors` | SVG with fill/stroke/preserve |
| `WPopover` | `triggerBuilder`, `contentBuilder`| `alignment`, `className` | Dropdowns, menus, tooltips|
| `WAnchor` | `child` | `onTap`, `className` | Raw interactive wrapper |
| `WFormInput`| (FormField) | `controller`, `type`, `placeholder`, `className`, `validator` | MagicForm-integrated input|
| `WFormSelect`| (FormField) | `options`, `searchable`, `className` | MagicForm-integrated select|
| `WFormMultiSelect`| (FormField) | `options`, `onCreateOption`, `className` | MagicForm multi-select |
| `WFormCheckbox`| (FormField) | `label`, `className` | MagicForm-integrated checkbox|
| `WDatePicker`| `mode`, `onDateSelected`/`onRangeSelected` | `className`, `initialDate`, `firstDate`, `lastDate`| Single date or date range picker|
| `WFormDatePicker`| (FormField) | `mode`, `className`, `firstDate`, `lastDate` | MagicForm-integrated date picker|
| `WSpacer` | - | `className` | Semantic spacing between siblings |
| `WDynamic` | `json` | `actions`, `controller`, `customIcons`, `builders`, `denyWidgets` | Server-driven UI from JSON |

**Rules:**
- `child` and `children` are mutually exclusive on `WDiv`.
- `WDiv` auto-wraps in `WAnchor` if `hover:`, `focus:`, or `active:` is present in the `className`.
- `WButton` with `isLoading: true` activates `loading:` prefix classes and disables interaction.
- `WSelect` with `isMulti: true` must use `values` + `onMultiChange` instead of `value` + `onChange`.
- `WSpacer` is a `const`-friendly semantic spacer — prefer over `SizedBox` or empty `WDiv` for gaps between siblings.
- `WDatePicker` `mode`: `DatePickerMode.single` or `DatePickerMode.range`. Range mode uses `onRangeSelected` callback.

## 4. Token System

**Spacing Formula:** `n × 4px` (e.g., `p-4` = 16px, `gap-6` = 24px, `m-2` = 8px)

**Color Syntax:** `{role}-{color}-{shade}` (e.g., `bg-blue-500`, `text-gray-900`, `border-red-300`)
- **Opacity:** `bg-primary/50`, `text-gray-500/75`
- **Arbitrary:** `bg-[#FF5733]`, `w-[200px]`, `text-[18px]`

**Responsive:** Prefix with breakpoint (e.g., `md:flex-row`, `lg:p-6`, `xl:hidden`)
- Breakpoints: `sm` (640px), `md` (768px), `lg` (1024px), `xl` (1280px), `2xl` (1536px)

**Typography Sizes:** `xs` (12), `sm` (14), `base` (16), `lg` (18), `xl` (20), `2xl` (24), `3xl` (30), `4xl` (36)

**Border Radius:** `rounded` (4), `rounded-md` (6), `rounded-lg` (8), `rounded-xl` (12), `rounded-2xl` (16), `rounded-full` (9999)

## 5. State & Modifier Prefixes

| Prefix | Trigger | Example |
|--------|---------|---------|
| `dark:` | Dark mode (MANDATORY on all colors) | `bg-white dark:bg-gray-800` |
| `hover:` | Mouse hover (via `WAnchor`) | `hover:bg-gray-100` |
| `focus:` | Keyboard focus | `focus:ring-2 focus:ring-primary` |
| `disabled:`| Widget disabled prop | `disabled:opacity-50` |
| `loading:` | `WButton` isLoading=true | `loading:opacity-75` |
| `active:` | Tap down / `WAnchor` active | `active:scale-95` |
| `selected:`| Custom via `states` Set | `selected:bg-primary/10` |
| `error:` | Form validation fail | `error:border-red-500` |
| `sm:` `md:` `lg:` `xl:` `2xl:` | Screen width breakpoints | `md:flex-row` |
| `ios:` `android:` `web:` `mobile:` | Platform | `ios:pt-12` |

Modifiers stack: `dark:hover:bg-gray-700`, `md:dark:flex-row`
Custom states via `states` param: `states: isActive ? {'active'} : {}`

### Conditional Styling with `states` (CRITICAL)

Wind widgets have a `states: Set<String>?` parameter for Dart-controlled conditional styling. **ALWAYS use `states` + prefixed classes instead of Dart string interpolation in `className`.**

The `states` param activates custom prefix classes in `className`. When a state name is in the set, all classes prefixed with that name become active.

**Pattern:** Define ALL visual variants in a single static `className`, use `states` to toggle between them.

```dart
// ✅ CORRECT — declarative state binding
WDiv(
  className: 'border-2 border-gray-200 selected:border-blue-500 bg-white selected:bg-blue-50 rounded-lg p-4',
  states: isSelected ? {'selected'} : {},
  child: WText(
    'Item',
    className: 'text-gray-600 selected:text-blue-600 font-medium',
    states: isSelected ? {'selected'} : {},
  ),
)

// ❌ WRONG — Dart string interpolation in className
WDiv(
  className: '''
    border-2 rounded-lg p-4
    ${isSelected ? 'border-blue-500 bg-blue-50' : 'border-gray-200 bg-white'}
  ''',
  child: WText(
    'Item',
    className: '${isSelected ? "text-blue-600" : "text-gray-600"} font-medium',
  ),
)
```

**Multiple custom states — combine in the Set:**

```dart
WDiv(
  className: '''
    bg-white enabled:bg-blue-50 locked:bg-gray-100 locked:opacity-75
    border border-gray-200 enabled:border-blue-500 locked:border-gray-300
    p-4 rounded-lg
  ''',
  states: {
    if (isEnabled && !isLocked) 'enabled',
    if (isLocked) 'locked',
  },
  child: WText(
    title,
    className: 'text-gray-500 enabled:text-primary locked:text-gray-400',
    states: {
      if (isEnabled && !isLocked) 'enabled',
      if (isLocked) 'locked',
    },
  ),
)
```

**Navigation / Tab active state:**

```dart
WButton(
  onTap: () => onTabChanged(index),
  states: isActive ? {'active'} : {},
  className: '''
    px-3 py-2.5 rounded-lg transition-colors
    text-gray-600 dark:text-gray-400
    hover:bg-gray-100 dark:hover:bg-gray-800
    active:bg-primary/10 active:text-primary
  ''',
  child: WText(label, className: 'text-sm font-medium'),
)
```

**When string interpolation is acceptable:**
- Dynamic values that are NOT state-based (e.g., `className: 'grid grid-cols-$columns'`)
- Layout direction changes (e.g., `className: 'flex ${isVertical ? "flex-col" : "flex-row"}'`)
- Content that changes (text strings, icons) — NOT styling classes

**Rule of thumb:** If you're choosing between two sets of **styling classes** based on a boolean → use `states`. If you're inserting a **dynamic value** (number, direction) → interpolation is fine.

## 6. Design Rules

**Typography hierarchy:**
- Page title: `text-2xl font-bold text-gray-900 dark:text-white`
- Section heading: `text-lg font-semibold text-gray-800 dark:text-gray-100`
- Body: `text-base text-gray-700 dark:text-gray-300`
- Secondary/caption: `text-sm text-gray-500 dark:text-gray-400`
- Label (section): `text-xs font-bold uppercase tracking-wide text-gray-500 dark:text-gray-400`

**Spacing rules:**
- Screen padding: `p-4` mobile, `p-6` desktop (`p-4 lg:p-6`)
- Between sections: `gap-6` or `gap-8`
- Between related items: `gap-3` or `gap-4`
- Inline (icon-to-text): `gap-1` or `gap-2`

**Touch targets (interactive elements):**
- Buttons: MINIMUM `py-3 px-4` (≈44dp height)
- Icon-only buttons: MINIMUM `p-3` (12px padding on 24px icon = 48dp)
- Never: `py-1` or `py-2` on primary interactive elements

**Dark mode pairs** (always provide both):
- Surfaces: `bg-white dark:bg-gray-800` or `bg-gray-50 dark:bg-gray-900`
- Borders: `border-gray-200 dark:border-gray-700`
- Text primary: `text-gray-900 dark:text-white`
- Text secondary: `text-gray-500 dark:text-gray-400`
- Hover: `hover:bg-gray-100 dark:hover:bg-gray-800`

## 7. Anti-Patterns Wall

| ❌ Wrong | ✅ Correct | Why |
|---------|-----------|-----|
| `Container(...)` | `WDiv(className: '...')` | Always use `W`-prefix |
| `Text('hello')` | `WText('hello', className: '...')` | Always use `W`-prefix |
| `ElevatedButton(...)` | `WButton(child: ..., className: '...')`| Always use `W`-prefix |
| `className: '${isFoo ? "bg-blue-500" : "bg-gray-500"}'` | `className: 'bg-gray-500 active:bg-blue-500'` + `states: isFoo ? {'active'} : {}` | Use `states` param, not string interpolation for conditional styling |
| `className: '${isEnabled ? 'text-primary' : 'text-gray-500'}'` | `className: 'text-gray-500 enabled:text-primary'` + `states: isEnabled ? {'enabled'} : {}` | State prefixes keep className static and cacheable |
| `w-full` inside `flex-row`| `flex-1` inside `flex-row` | `w-full` causes RenderFlex overflow |
| `overflow-y-auto` without bounded parent | Add `flex-1` to scrollable `WDiv` | Unbounded height → crash |
| `h-full` in scrollable context| `min-h-screen` | `h-full` in scrollable = infinite height |
| `flex-wrap` | `wrap` (display type) | `flex-wrap` is a no-op in Flutter |
| `WText('long', className: 'truncate')` in Row| Wrap in `WDiv(className: 'flex-1')` | `truncate` needs bounded width |
| `bg-white` without `dark:`| `bg-white dark:bg-gray-800` | `dark:` is mandatory |
| `py-1` on a button | `py-3 px-4` minimum | Touch targets ≥44dp |
| `gap: 2` (Dart) | `className: 'gap-2'` | Use className, not Dart params |
| `WSelect(flex-wrap className)`| `WSelect(className: 'wrap ...')` | No `flex-wrap` token |
| Native widget in Row without size | Wrap in `Expanded()` | Must provide bounds |
| `WSvg(className: 'fill-blue-500')` on multi-color SVG | Add `preserve-colors` to className | Multi-color SVGs need original colors preserved |

## 8. Pre-Completion Checklist

Before finalizing any Wind UI task, verify:
- [ ] Every `bg-`/`text-`/`border-` class has a `dark:` variant
- [ ] No `w-full` inside `flex flex-row` (use `flex-1` instead)
- [ ] No `${condition ? 'classA' : 'classB'}` in className — use `states` param + state prefixes instead
- [ ] Every `overflow-y-auto` has a bounded parent (`flex-1` or explicit height)
- [ ] `scrollPrimary: true` on the main scrollable `WDiv` per view
- [ ] All interactive elements have minimum `py-3 px-4` (or `p-3` for icon-only)
- [ ] `WText` with `truncate` has `Expanded`/`flex-1` parent in Row context
- [ ] `wrap` used (NOT `flex-wrap`) for wrapping layouts
- [ ] Native Flutter widgets in Row/Column wrapped in `Expanded()` if they size-to-fill
- [ ] Trailing commas on all constructor params
- [ ] No `Container`, `Text`, `ElevatedButton` — use `WDiv`, `WText`, `WButton`

## 9. Reference Index

| File | Content | Load When |
|------|---------|-----------|
| `references/widgets.md` | Complete widget API, all constructor params | Full widget signature needed |
| `references/tokens.md` | Complete className token reference by category | Looking up specific token syntax |
| `references/layout-patterns.md`| Page scaffolding, scrollable, responsive patterns, debugging guide | Building page layouts |
| `references/form-patterns.md` | MagicForm, WFormInput/Select/MultiSelect, validation, keyboard | Building forms |
| `references/design-tokens.md` | Spacing scale, typography scale, color system, shadow scale | Design system decisions |
| `references/theme-setup.md` | WindTheme setup, dark mode, custom colors, context extensions | Theme configuration |
| `references/component-patterns.md`| Card, button, badge, empty state, modal, nav components | Building UI components |
