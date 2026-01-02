---
trigger: always_on
---

# Wind UI - AI Agent System Prompt

You are building Flutter UIs with `fluttersdk_wind`. Use Tailwind-like className strings instead of manual Flutter styling.

## Core Widgets

### WDiv - Universal Container
```dart
WDiv(className: "flex gap-4 p-4 bg-gray-100 rounded-lg", children: [...])
WDiv(className: "p-4 bg-white shadow-md", child: WText("Single"))
```
**Props:**
- `className`: Utility class string
- `child`: Single widget (block layout)
- `children`: Multiple widgets (flex/grid/wrap) — **NEVER use both**
- `states`: Set<String> for custom prefixes (`loading:`, `error:`)

**Layout Detection:** `flex`/`flex-row`/`flex-col`→Row/Column, `grid`→GridView, `wrap`→Wrap, default→Block

### WText - Typography
```dart
WText("Hello", className: "text-xl text-blue-500 font-bold uppercase")
```
**Props:** `className`, `selectable` (bool)

### WButton - Interactive Button
```dart
WButton(
  onTap: () {}, isLoading: _loading, disabled: _disabled,
  className: "bg-blue-600 hover:bg-blue-700 loading:opacity-70 px-4 py-2 rounded",
  child: Text("Submit"),
)
```
**Props:** `onTap`, `onLongPress`, `onDoubleTap`, `isLoading`, `disabled`, `loadingText`, `loadingWidget`, `className`, `child`
- Auto-activates `loading:` and `disabled:` prefixes
- Wraps WAnchor internally (hover/focus work)

### WAnchor - State Wrapper
```dart
WAnchor(
  onTap: () {}, isDisabled: false, states: {'active'},
  child: WDiv(className: "hover:bg-gray-100 focus:ring-2 duration-300", ...),
)
```
**Props:** `onTap`, `onLongPress`, `onDoubleTap`, `isDisabled`, `states`, `child`
**CRITICAL:** Required wrapper for `hover:`/`focus:`/`disabled:` prefixes on WDiv

### WInput - Controlled Input
```dart
WInput(
  value: _text, onChanged: (v) => setState(() => _text = v),
  type: InputType.email, placeholder: "Email",
  className: "p-3 border rounded focus:ring-2 focus:ring-blue-500",
  placeholderClassName: "text-gray-400",
)
```
**Props:** `value`, `onChanged`, `type`, `placeholder`, `placeholderClassName`, `className`, `states`, `prefixIcon`, `suffixIcon`, `textInputAction`
**Types:** `InputType.text`, `.password`, `.email`, `.number`, `.phone`, `.url`, `.multiline`

### WFormInput - Form Validated
```dart
WFormInput(
  initialValue: "", type: InputType.email,
  validator: (v) => v!.isEmpty ? "Required" : null,
  className: "p-3 border rounded error:border-red-500",
  errorClassName: "text-red-500 text-sm mt-1",
)
```
**Props:** Same as WInput + `validator`, `errorClassName`, `label`, `autovalidateMode`
- Auto-activates `error:` prefix on validation fail

### WSelect<T> - Dropdown
```dart
WSelect<String>(
  value: _selected,
  options: [SelectOption(value: 'a', label: 'Option A', icon: Icons.star)],
  onChange: (v) => setState(() => _selected = v),
  className: "w-64 border rounded p-3",
  menuClassName: "bg-white shadow-lg rounded",
  searchable: true,
)
```
**Props:** `value`, `values` (multi), `options`, `onChange`, `onMultiChange`, `isMulti`, `searchable`, `onSearch`, `onLoadMore`, `hasMore`, `onCreateOption`, `disabled`, `placeholder`, `className`, `menuClassName`, `states`
**Builders:** `triggerBuilder`, `itemBuilder`, `selectedChipBuilder`, `emptyBuilder`, `loadingBuilder`

### WFormSelect<T> - Form Validated
**Props:** Same as WSelect + `validator`, `label`, `errorClassName`

### WCheckbox
```dart
WCheckbox(
  value: _checked, onChanged: (v) => setState(() => _checked = v),
  className: "w-5 h-5 rounded checked:bg-blue-500",
)
```
**Props:** `value`, `onChanged`, `disabled`, `className`, `iconClassName`, `checkIcon`, `states`

### WFormCheckbox - Form Validated
**Props:** Same as WCheckbox + `validator`, `labelText`, `hint`, `errorClassName`

### WPopover
```dart
WPopover(
  alignment: PopoverAlignment.bottomLeft,
  className: "w-64 bg-white shadow-xl rounded-lg",
  triggerBuilder: (ctx, open, hover) => WButton(child: WText("Menu")),
  contentBuilder: (ctx, close) => WDiv(child: WText("Item")),
)
```
**Props:** `triggerBuilder`, `contentBuilder`, `alignment`, `className`, `offset`, `maxHeight`, `disabled`, `closeOnContentTap`

### WIcon
```dart
WIcon(Icons.star, className: "text-yellow-400 text-2xl animate-spin")
```
**Props:** `icon` (IconData), `className`

### WImage
```dart
WImage(src: "https://...", alt: "Photo", className: "w-full aspect-video object-cover")
WImage(src: "asset://assets/logo.png", className: "w-24 h-24 rounded-full")
```
**Props:** `src`, `alt`, `className`, `placeholder`, `errorBuilder`

### WSvg
```dart
WSvg(src: "assets/icon.svg", className: "fill-blue-500 w-6 h-6")
WSvg.string("<svg>...</svg>", className: "stroke-red-500 w-8")
```
**Props:** `src`, `svgString`, `className`

---

## Utility Classes

### Display & Layout
`block` `flex` `flex-row` `flex-col` `grid` `wrap` `hidden`

### Flex Alignment
`justify-start` `justify-end` `justify-center` `justify-between` `justify-around` `justify-evenly`
`items-start` `items-end` `items-center` `items-baseline` `items-stretch`
`align-content-start` `align-content-end` `align-content-center` `align-content-between`
`align-self-start` `align-self-end` `align-self-center` `align-self-stretch` `align-self-auto`

### Flex Children
`flex-1` `flex-2` ... `flex-grow` `flex-auto` `flex-initial` `flex-shrink` `flex-none`

### Grid
`grid-cols-1` ... `grid-cols-12`

### Gap
`gap-{n}` `gap-x-{n}` `gap-y-{n}` `gap-[10px]`

### Axis Size
`axis-min` `axis-max` (MainAxisSize.min / MainAxisSize.max)

### Sizing (n × 4px)
`w-{n}` `h-{n}` `w-full` `h-full` `w-screen` `h-screen`
`w-1/2` `w-1/3` `w-2/3` `w-1/4` `w-3/4`
`w-[100px]` `h-[50%]` `w-auto` `h-auto`
`min-w-{n}` `max-w-{n}` `min-h-{n}` `max-h-{n}` `min-w-0` `max-w-full`

### Spacing
`p-{n}` `px-{n}` `py-{n}` `pt-{n}` `pr-{n}` `pb-{n}` `pl-{n}` `p-[10px]`
`m-{n}` `mx-{n}` `my-{n}` `mt-{n}` `mr-{n}` `mb-{n}` `ml-{n}` `mx-auto`

### Typography
**Size:** `text-xs` `text-sm` `text-base` `text-lg` `text-xl` `text-2xl` ... `text-6xl` `text-[20px]`
**Weight:** `font-thin` `font-light` `font-normal` `font-medium` `font-semibold` `font-bold` `font-extrabold` `font-black`
**Family:** `font-sans` `font-serif` `font-mono` | **Color:** `text-{color}-{shade}` | **Align:** `text-left` `text-center` `text-right`
**Style:** `italic` | **Transform:** `uppercase` `lowercase` `capitalize`
**Decoration:** `underline` `line-through` `decoration-{solid|dashed|wavy}` `decoration-{color}`
**Tracking:** `tracking-tight` `tracking-wide` | **Leading:** `leading-tight` `leading-normal` `leading-loose`
**Overflow:** `truncate` `line-clamp-{n}` | **Wrap:** `whitespace-nowrap`

### Colors
**Pattern:** `{bg|text|border|ring|shadow|fill|stroke}-{color}-{shade}`
**Opacity:** `{...}-{color}-{shade}/{opacity}` (e.g. `bg-blue-500/50`)
**Colors:** slate, gray, zinc, neutral, stone, red, orange, amber, yellow, lime, green, emerald, teal, cyan, sky, blue, indigo, violet, purple, fuchsia, pink, rose, white, black, transparent
**Shades:** 50, 100, 200, 300, 400, 500, 600, 700, 800, 900
**Arbitrary:** `bg-[#FF5733]` `text-[rgb(255,87,51)]`

### Background
**Color:** `bg-{color}-{shade}` `bg-[#hex]`
**Gradient:** `bg-gradient-to-{t|tr|r|br|b|bl|l|tl}` `from-{color}-{shade}` `via-{color}-{shade}` `to-{color}-{shade}`
**Image:** `bg-[url(...)]` `bg-cover` `bg-contain` `bg-center` `bg-top` `bg-bottom` `bg-left` `bg-right` `bg-no-repeat` `bg-repeat`

### Border
**Width:** `border` `border-0` `border-2` `border-4` `border-8` `border-t` `border-r` `border-b` `border-l` `border-t-2`
**Color:** `border-{color}-{shade}` `border-[#hex]`
**Style:** `border-solid` `border-none`
**Radius:** `rounded` `rounded-none` `rounded-sm` `rounded-md` `rounded-lg` `rounded-xl` `rounded-2xl` `rounded-3xl` `rounded-full`
**Directional Radius:** `rounded-t` `rounded-r` `rounded-b` `rounded-l` `rounded-tl` `rounded-tr` `rounded-bl` `rounded-br` `rounded-tl-lg`

### Effects
**Shadow:** `shadow-sm` `shadow` `shadow-md` `shadow-lg` `shadow-xl` `shadow-2xl` `shadow-none` `shadow-{color}-{shade}`
**Ring:** `ring` `ring-0` `ring-1` `ring-2` `ring-4` `ring-8` `ring-{color}-{shade}` `ring-offset-{n}` `ring-inset`
**Opacity:** `opacity-0` `opacity-25` `opacity-50` `opacity-75` `opacity-100` `opacity-[0.3]`

### Overflow & Misc
`overflow-visible` `overflow-hidden` `overflow-scroll` `overflow-auto`
`aspect-auto` `aspect-square` `aspect-video` | `z-0` `z-10` `z-20` `z-30` `z-40` `z-50`

### Transitions & Animations
**Duration:** `duration-75` `duration-100` `duration-150` `duration-200` `duration-300` `duration-500` `duration-700` `duration-1000`
**Easing:** `ease-linear` `ease-in` `ease-out` `ease-in-out`
**Animation:** `animate-spin` `animate-ping` `animate-pulse` `animate-bounce` `animate-none`

### SVG
`fill-{color}-{shade}` `stroke-{color}-{shade}`

---

## State Prefixes

| Prefix | Trigger | Requires |
|--------|---------|----------|
| `hover:` | Mouse hover | WAnchor/WButton |
| `focus:` | Focus state | WAnchor/WButton |
| `disabled:` | disabled=true | - |
| `loading:` | isLoading=true | WButton |
| `checked:` | value=true | WCheckbox |
| `error:` | Validation fail | WFormInput/WFormSelect |
| `dark:` | Dark mode | WindTheme |
| `sm:` | ≥640px | - |
| `md:` | ≥768px | - |
| `lg:` | ≥1024px | - |
| `xl:` | ≥1280px | - |
| `2xl:` | ≥1536px | - |
| `ios:` `android:` `web:` `mobile:` | Platform | - |

**Custom:** `states: {'loading'}` → `loading:opacity-50`

---

## Theme & Helpers

```dart
context.windTheme.toggleTheme()        // Toggle dark/light
context.wIsMobile / context.wIsDesktop // bool
wColor(context, 'blue', shade: 500)    // Color?
wSpacing(context, 4)                   // 16.0
```

---

## Flutter → Wind Widget Mapping

| Flutter Widget | Wind Equivalent |
|----------------|-----------------|
| `Container` | `WDiv(className: "p-4 bg-white rounded-lg")` |
| `Row` | `WDiv(className: "flex flex-row gap-4", children: [...])` |
| `Column` | `WDiv(className: "flex flex-col gap-4", children: [...])` |
| `Wrap` | `WDiv(className: "wrap gap-4", children: [...])` |
| `GridView` | `WDiv(className: "grid grid-cols-3 gap-4", children: [...])` |
| `SizedBox(width: 100)` | `WDiv(className: "w-[100px]")` |
| `Padding(padding: E.all(16))` | `WDiv(className: "p-4")` |
| `Center` | `WDiv(className: "flex justify-center items-center")` |
| `Text` | `WText("...", className: "text-lg font-bold")` |
| `Icon` | `WIcon(Icons.star, className: "text-2xl text-yellow-500")` |
| `Image.network` | `WImage(src: "url", className: "w-full rounded")` |
| `TextField` | `WInput(value: v, onChanged: fn, className: "...")` |
| `Checkbox` | `WCheckbox(value: v, onChanged: fn, className: "...")` |
| `ElevatedButton` | `WButton(onTap: fn, className: "bg-blue-600 ...", child: ...)` |
| `GestureDetector` | `WAnchor(onTap: fn, child: ...)` |
| `InkWell` | `WAnchor(onTap: fn, child: WDiv(className: "hover:bg-gray-100", ...))` |
| `Expanded` | Use `flex-1` class on child |
| `Flexible` | Use `flex-auto` class on child |

This reference is not exhaustive. If you need to use a Flutter widget that is not listed here, you can use the `WDiv` widget with the appropriate className.

---

## Long className Formatting

For className values longer than 80 characters, use triple quotes:

```dart
WDiv(
  className: '''
    w-full py-3 rounded-xl bg-gradient-to-r from-indigo-500
    to-purple-500 text-white font-semibold text-center
    hover:from-indigo-600 hover:to-purple-600 duration-300
  ''',
  child: WText("Follow"),
)
```

This improves readability and allows logical grouping of related classes.

---

## Rules

✅ **DO:**
- Use `WDiv(className: ...)` instead of Container/Row/Column
- Wrap with WAnchor for `hover:`/`focus:` on WDiv
- Use triple quotes for long className (>80 chars)
- Add `duration-{n}` for smooth transitions

❌ **DON'T:**
- Use `hover:` without WAnchor/WButton
- Use both `child` and `children` in WDiv
- Hardcode colors/sizes

**Debug:** `WDiv(className: "debug p-4", ...)` prints composition to console

