# Wind UI className Token Reference (v1.0.0)

Every recognized className token, organized by the parser that owns it. Spell-check against this catalog: unknown tokens fail silently.

## Prefix system (applies to every category below)

Order of prefixes within a single class is arbitrary; ALL prefixes must match for the class to apply.

| Prefix kind | Tokens | Activation |
|-------------|--------|------------|
| Responsive | `sm:`, `md:`, `lg:`, `xl:`, `2xl:` | Active when screen width ≥ breakpoint (defaults: 640, 768, 1024, 1280, 1536). Mobile-first cascade. |
| State | `hover:`, `focus:`, `active:`, `disabled:`, `loading:`, `selected:`, `checked:`, `error:` | Hover/focus/active auto-detected by WAnchor. Others injected via `states: Set<String>?` constructor param. |
| Theme | `dark:` | Active when `WindThemeController.brightness == Brightness.dark`. |
| Platform | `ios:`, `android:`, `web:`, `mobile:` | Active per `WindPlatformService` detection. `mobile:` = iOS OR Android. |
| Arbitrary | `[N]` brackets | Pixel-exact override (e.g., `p-[10px]`, `w-[300px]`, `bg-[#ff5733]`). |
| Opacity modifier | `/N` suffix (after color) | Applies to color tokens: `bg-red-500/50`, `text-white/80`, `shadow-blue-500/20`. |

Cache key includes: `className + activeBreakpoint + brightness + platform + sorted(activeStates)`.

## Spacing

### Padding (`padding_parser.dart`)

`p-{N}`, `pt-{N}`, `pr-{N}`, `pb-{N}`, `pl-{N}`, `px-{N}`, `py-{N}` (top, right, bottom, left, horizontal, vertical).

Values: `0, 0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4, 5, 6, 7, 8, 9, 10, 11, 12, 14, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 64, 72, 80, 96` (theme spacing scale) + `px` (1 px) + arbitrary `p-[10px]`. Each unit = 4 px (so `p-4` = 16 px).

### Margin (`margin_parser.dart`)

Same shape as padding: `m-{N}`, `mt-{N}`, `mr-{N}`, `mb-{N}`, `ml-{N}`, `mx-{N}`, `my-{N}` + `mx-auto` (horizontal centering).

## Sizing

### Width / Height (`sizing_parser.dart`)

| Token family | Values |
|--------------|--------|
| `w-{N}` / `h-{N}` | spacing-scale values, `full` (100%), `screen` (viewport), `min`, `max`, `fit`, fractions (`w-1/2`, `w-1/3`, `w-2/3`, `w-1/4`, `w-3/4`, `w-1/5` ... `w-4/5`, `w-1/12` ... `w-11/12`) |
| `min-w-{N}` / `min-h-{N}` | same value set; `min-h-screen` very common |
| `max-w-{named}` | `xs` (320), `sm` (384), `md` (448), `lg` (512), `xl` (576), `2xl` (672), `3xl` (768), `4xl` (896), `5xl` (1024), `6xl` (1152), `7xl` (1280), `prose` (1040) |
| `max-h-{N}` | spacing-scale or arbitrary |
| Arbitrary | `w-[300px]`, `h-[50%]`, `min-w-[200px]` |

Wind stops at `7xl` for max-width-named; `8xl`/`9xl` are silent no-ops.

### Flex / Grid sizing

`flex-1`, `flex-auto`, `flex-initial`, `flex-none`, `flex-grow`, `flex-shrink`, `shrink`, `shrink-0` for flex children. `grid-cols-{N}` for grid columns. `axis-min` / `axis-max` (Wind-only) control flex container `MainAxisSize`.

## Color (the overloaded space)

### Background (`background_parser.dart`)

- Solid color: `bg-{name}-{shade}` (e.g., `bg-red-500`, `bg-slate-900`), arbitrary `bg-[#ff5733]`, opacity modifier `bg-red-500/50`.
- Color names: `slate, gray, zinc, neutral, stone, red, orange, amber, yellow, lime, green, emerald, teal, cyan, sky, blue, indigo, violet, purple, fuchsia, pink, rose` (22 families).
- Shades: `50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 950` (11 stops per family).
- Image: `bg-[url(asset://path)]` (asset), arbitrary `bg-[url(...)]`. Position: `bg-center`, `bg-top`, `bg-bottom`, `bg-left`, `bg-right`. Size: `bg-cover`, `bg-contain`. Repeat: `bg-no-repeat`, `bg-repeat`, `bg-repeat-x`, `bg-repeat-y`.
- Gradient: `bg-gradient-to-{t|tr|r|br|b|bl|l|tl}` + `from-{color}-{shade}` + optional `via-{color}-{shade}` + `to-{color}-{shade}`.

### Text color, alignment, font-size (`text_parser.dart`) — OVERLOADED

The `text-*` prefix has three meanings resolved by ordered regex:

**1. Font size:** `text-xs` (12), `text-sm` (14), `text-base` (16), `text-lg` (18), `text-xl` (20), `text-2xl` (24), `text-3xl` (30), `text-4xl` (36), `text-5xl` (48), `text-6xl` (60). STOPS AT `6xl` — `text-7xl` / `text-8xl` / `text-9xl` silently no-op. Arbitrary: `text-[20px]`, `text-[1.5rem]`. With paired line-height: `text-xl/8` (size + leading-8).

**2. Color:** `text-{name}-{shade}` (e.g., `text-gray-900`, `text-white`, `text-black`), arbitrary `text-[#hex]`, opacity `text-white/80`.

**3. Alignment:** `text-left`, `text-center`, `text-right`, `text-justify`, `text-start`, `text-end`.

### Border color (`border_parser.dart`)

`border-{name}-{shade}`, arbitrary `border-[#hex]`, opacity `border-red-500/50`. Default border color when no color specified.

### Other color-bearing tokens (with opacity modifier)

| Token | Use |
|-------|-----|
| `ring-{color}/{opacity}` | focus ring color |
| `shadow-{color}/{opacity}` | tinted shadow |
| `fill-{color}/{opacity}` | SVG fill |
| `stroke-{color}/{opacity}` | SVG stroke |

## Typography (other than size/color/align)

### Font (`text_parser.dart` continued)

| Family | Tokens |
|--------|--------|
| Weight | `font-thin` (100), `font-extralight` (200), `font-light` (300), `font-normal` (400), `font-medium` (500), `font-semibold` (600), `font-bold` (700), `font-extrabold` (800), `font-black` (900), arbitrary `font-[450]` |
| Family | `font-sans`, `font-serif`, `font-mono`, custom `font-[Inter]` |
| Style | `italic`, `not-italic` |
| Decoration | `underline`, `overline`, `line-through`, `no-underline` |
| Decoration style | `decoration-solid`, `decoration-double`, `decoration-dotted`, `decoration-dashed`, `decoration-wavy` |
| Decoration color | `decoration-{color}-{shade}`, `decoration-[#hex]` |
| Decoration thickness | `decoration-{0..8}`, `decoration-[3px]` |
| Transform | `uppercase`, `lowercase`, `capitalize`, `normal-case` |
| Letter spacing | `tracking-{tighter|tight|normal|wide|wider|widest}`, arbitrary `tracking-[0.1em]` |
| Line height | `leading-{tight|snug|normal|relaxed|loose}` or numeric `leading-{N}` (× 4 px), arbitrary `leading-[24px]` |
| Overflow | `truncate`, `text-ellipsis`, `text-clip` |
| Line clamp | `line-clamp-{1..12|none}` |
| Wrap | `whitespace-normal`, `whitespace-nowrap`, `text-wrap`, `text-nowrap`, `text-balance` |

## Borders (`border_parser.dart`)

### Width

`border` (default 1 px), `border-{0|1|2|4|8}` (numeric or theme), arbitrary `border-[3px]`. Directional: `border-t-{N}`, `border-r-{N}`, `border-b-{N}`, `border-l-{N}`.

### Style

`border-solid`, `border-none` (no `border-dashed`/`-dotted`).

### Radius

`rounded` (default), `rounded-none`, `rounded-full`, `rounded-{sm|md|lg|xl|2xl|3xl}`. Directional: `rounded-t-{size}`, `rounded-r-{size}`, `rounded-b-{size}`, `rounded-l-{size}`, `rounded-tl-{size}`, `rounded-tr-{size}`, `rounded-bl-{size}`, `rounded-br-{size}`.

## Layout (`flexbox_grid_parser.dart`)

### Display

`flex`, `grid`, `wrap`, `block`, `hidden`. (`flex-wrap` is a NO-OP; use `wrap`.)

### Flex direction

`flex-row`, `flex-col`, `flex-row-reverse`, `flex-col-reverse`.

### Justify (main axis)

`justify-start`, `justify-end`, `justify-center`, `justify-between`, `justify-around`, `justify-evenly`.

### Align items (cross axis)

`items-start`, `items-end`, `items-center`, `items-baseline`, `items-stretch`.

### Align content (when wrapped)

`align-content-start`, `align-content-end`, `align-content-center`, `align-content-between`, `align-content-around`, `align-content-evenly`, `align-content-stretch`.

### Gap (between flex/grid children)

`gap-{N}`, `gap-x-{N}`, `gap-y-{N}`, `space-x-{N}`, `space-y-{N}` (legacy). Arbitrary `gap-[10px]`.

### Self-alignment

`align-self-start`, `align-self-end`, `align-self-center`, `align-self-stretch`, `align-self-auto`.

### Grid

`grid-cols-{1|2|3|4|5|6|7|8|9|10|11|12}`. Use `WBreakpoint` for column counts beyond static numbers.

## Position (`position_parser.dart`)

### Type

`relative` (creates Stack ancestry for `absolute` children), `absolute` (positioned inside parent Stack), `fixed` / `sticky` (claimed by parser but currently NOT supported — silently treated as `relative`).

### Offsets

`top-{N}`, `right-{N}`, `bottom-{N}`, `left-{N}`. Negative prefix: `-top-4`. Arbitrary: `top-[24px]`.

### Inset (multi-side shorthand)

`inset-{N}` (all four sides), `inset-x-{N}` (left + right), `inset-y-{N}` (top + bottom). Negative + arbitrary supported.

## Order (`order_parser.dart`) — NEW in alpha-9

`order-{0..12}`, `order-first` (-9999), `order-last` (9999), `order-none` (0), arbitrary `order-[-42]`. Controls flex child rendering order without changing source order.

## Effects

### Shadow (`shadow_parser.dart`)

Presets: `shadow` (default), `shadow-sm`, `shadow-md`, `shadow-lg`, `shadow-xl`, `shadow-2xl`, `shadow-none`. Color tinting: `shadow-{color}-{shade}`, arbitrary `shadow-[#hex]`, opacity `shadow-red-500/30`.

### Ring (`ring_parser.dart`)

`ring` (default), `ring-{0|1|2|4|8}` (width). Color: `ring-{color}-{shade}`, arbitrary `ring-[#hex]`, opacity `ring-blue-500/50`. Offset: `ring-offset-{0|1|2|4|8}`. Inset: `ring-inset` (inset shadow vs outline).

### Opacity (`opacity_parser.dart`)

`opacity-{0|5|10|15|...|95|100}` (5% steps), arbitrary `opacity-[0.35]` (0.0-1.0 range, clamped).

## Transitions and animations

### Transitions (`transition_parser.dart`)

Duration: `duration-{75|100|150|200|300|500|700|1000}` (ms), arbitrary `duration-[500ms]`. Easing: `ease-linear`, `ease-in`, `ease-out`, `ease-in-out`.

Apply with the `animate-*` family on the same widget for smooth transitions.

### Animations (`animation_parser.dart`)

`animate-spin` (continuous rotation; loading indicators), `animate-pulse` (opacity fade), `animate-bounce` (vertical bounce), `animate-ping` (scale-up + fade), `animate-none` (disable).

## Aspect ratio (`aspectratio_parser.dart`)

`aspect-auto` (no constraint), `aspect-square` (1:1), `aspect-video` (16:9), arbitrary `aspect-[4/3]` (any ratio).

## Z-index (`zindex_parser.dart`)

`z-{0|10|20|30|40|50}`, arbitrary `z-[100]`, `z-auto`.

## Overflow (`overflow_parser.dart`)

`overflow-hidden`, `overflow-visible`, `overflow-scroll`, `overflow-auto`. Directional: `overflow-x-{...}`, `overflow-y-{...}`. **REMINDER**: scrolling overflow requires the constructor `scrollPrimary: true` on the WDiv for iOS tap-to-top.

## SVG (`svg_parser.dart`)

Fill: `fill-{color}-{shade}`, arbitrary `fill-[#hex]`, `fill-none`, `fill-current` (inherit from text color).
Stroke: `stroke-{color}-{shade}`, arbitrary `stroke-[#hex]`, `stroke-none`, `stroke-current`.
Special: `preserve-colors` (disable color filter for multi-color brand SVGs).

## Debug (`debug_parser.dart`)

`debug` — draws a colorful layout border showing the widget tree boundaries. Development only; never ship.

## What Wind DOES NOT support (silent no-ops)

Writing any of these in a Wind className produces no effect and no error. Use `references/migrate-from-tailwind.md` for the full migration list.

- `flex-wrap` (use `wrap`)
- `text-7xl`, `text-8xl`, `text-9xl`
- `group-*`, `peer-*`
- `divide-x`, `divide-y`, `divide-*-color`
- `cursor-pointer`, `cursor-not-allowed`, etc.
- `filter`, `blur-*`, `backdrop-blur-*`, `drop-shadow-*`
- `@apply`, `@layer`, `@variant`, `@container`, `@sm:`
- `!important` markers (`!bg-red-500` v3, `bg-red-500!` v4)
- `bg-opacity-50` (deprecated v3 form; use `bg-red-500/50`)
- `fixed`, `sticky` position types (parser sees them; no implementation)
- Container queries (no DOM = no containment)
- `space-x-reverse`, `divide-x-reverse`

## Reading tips

- **Combine prefixes freely**: `md:hover:bg-blue-500 dark:md:hover:bg-blue-400` activates on md+ screen AND hover AND dark theme.
- **Last class wins per property**: `p-4 p-8` → `p-8`. Order within className matters.
- **Multi-line className**: triple-quoted strings, one concern per line, group `dark:` peers beside light variants. Tabs/leading whitespace are ignored.
- **States vs interpolation**: `states: isOn ? {'active'} : const {}` + `active:bg-blue-500` is correct; `'bg-${isOn ? "blue" : "gray"}-500'` is wrong (breaks cache, hard to read).
- **Arbitrary > theme**: when both might match, arbitrary `[N]` wins because parsers check brackets first.
- **Inline color props override className**: `WDiv(backgroundColor: someRuntimeColor, className: 'bg-blue-500')` uses `someRuntimeColor` AND bypasses cache.
