# Wind Utility Classes Reference

Complete list of supported className utilities organized by parser.

## Table of Contents
- [Background](#background)
- [Borders](#borders)
- [Layout (Flexbox & Grid)](#layout)
- [Sizing](#sizing)
- [Spacing (Padding & Margin)](#spacing)
- [Typography](#typography)
- [Effects (Opacity, Shadow, Ring)](#effects)
- [Overflow](#overflow)
- [Aspect Ratio](#aspect-ratio)
- [Z-Index](#z-index)
- [Animation & Transition](#animation--transition)
- [SVG](#svg)
- [Debug](#debug)

## Background

```
bg-{color}-{shade}          bg-red-500, bg-slate-100
bg-[#hex]                   bg-[#FF5733]
bg-{color}-{shade}/{opacity} bg-red-500/50
bg-[url(...)]               background image
bg-cover, bg-contain        background size
bg-center, bg-top, bg-bottom, bg-left, bg-right
bg-no-repeat, bg-repeat, bg-repeat-x, bg-repeat-y
bg-gradient-to-{direction}  t, tr, r, br, b, bl, l, tl
from-{color}-{shade}        gradient start
via-{color}-{shade}         gradient middle
to-{color}-{shade}          gradient end
```

## Borders

```
border                      default 1px
border-{0|2|4|8}            width
border-{t|r|b|l}            side-specific default
border-{t|r|b|l}-{0|2|4|8}  side-specific width
border-{color}-{shade}      border-red-500
border-[#hex]               border-[#333]
border-{color}/{opacity}    border-gray-300/50
border-solid, border-none
border-[Npx]                arbitrary width

rounded                     default (4px)
rounded-{none|sm|md|lg|xl|2xl|3xl|full}
rounded-{t|r|b|l|tl|tr|bl|br}          corner-specific
rounded-{t|r|b|l|tl|tr|bl|br}-{size}   corner + size
```

## Layout

```
# Display
flex, grid, wrap, block, hidden

# Direction
flex-row, flex-col

# Justify content
justify-{start|end|center|between|around|evenly}

# Align items
items-{start|end|center|baseline|stretch}

# Align content (wrap)
align-content-{start|end|center|between|around|evenly|stretch}

# Gap
gap-{N}              both axes
gap-x-{N}, gap-y-{N} single axis
space-x-{N}, space-y-{N}
gap-[Npx]            arbitrary

# Grid
grid-cols-{N}        number of columns

# Flex child
flex-{1|2|3|...}     flex factor
flex-grow, flex-auto, flex-initial, flex-shrink, flex-none
shrink, shrink-0

# Align self
align-self-{start|end|center|stretch|auto}

# Axis size
axis-min, axis-max
```

## Sizing

```
w-{N}, h-{N}                theme spacing (N * 4px)
w-full, h-full               100%
w-screen, h-screen           viewport size
w-{1/2|1/3|2/3|1/4|3/4}     fraction (percentage)
w-[Npx], w-[N%]             arbitrary
h-[Npx], h-[N%]             arbitrary
min-w-{N}, max-w-{N}
min-h-{N}, max-h-{N}
max-w-{xs|sm|md|lg|xl|2xl|3xl|4xl|5xl|6xl|7xl|prose}
```

## Spacing

```
# Padding
p-{N}   all sides         px-{N}  horizontal
py-{N}  vertical          pt-{N}  top
pr-{N}  right             pb-{N}  bottom
pl-{N}  left              p-[Npx] arbitrary

# Margin
m-{N}   all sides         mx-{N}  horizontal
my-{N}  vertical          mt-{N}  top
mr-{N}  right             mb-{N}  bottom
ml-{N}  left              mx-auto center horizontally
m-[Npx] arbitrary
```

Spacing scale (N * 4px): 0, 0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4, 5, 6, 7, 8, 9, 10, 11, 12, 14, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 64, 72, 80, 96

## Typography

```
# Color
text-{color}-{shade}         text-red-500
text-[#hex]                  text-[#FF0000]
text-{color}/{opacity}       text-blue-500/75

# Alignment
text-{left|right|center|justify|start|end}

# Size
text-{xs|sm|base|lg|xl|2xl|3xl|4xl|5xl|6xl}
text-[Npx]                   arbitrary
text-{size}/{lineHeight}     text-sm/relaxed

# Weight
font-{thin|extralight|light|normal|medium|semibold|bold|extrabold|black}
font-[N]                     arbitrary (100-900)

# Family
font-{sans|serif|mono}
font-[CustomFont]            arbitrary

# Style
italic, not-italic

# Decoration
underline, overline, line-through, no-underline
decoration-{solid|double|dotted|dashed|wavy}
decoration-{color}-{shade}
decoration-{N}               thickness

# Tracking (letter-spacing)
tracking-{tighter|tight|normal|wide|wider|widest}
tracking-[N]

# Leading (line-height)
leading-{tight|snug|normal|relaxed|loose|N}
leading-[Npx]

# Transform
uppercase, lowercase, capitalize, normal-case

# Overflow
truncate, text-ellipsis, text-clip, line-clamp-{N}

# Whitespace & Wrap
whitespace-{normal|nowrap}
text-{wrap|nowrap|balance}
```

## Effects

```
# Opacity
opacity-{0|5|10|20|25|30|40|50|60|70|75|80|90|95|100}
opacity-[N]

# Shadow
shadow                       default
shadow-{sm|md|lg|xl|2xl|none}
shadow-{color}-{shade}
shadow-[#hex]

# Ring
ring                         default (3px)
ring-{0|1|2|4|8}
ring-{color}-{shade}
ring-[#hex]
ring-offset-{0|1|2|4|8}
ring-inset
```

## Overflow

```
overflow-{hidden|visible|scroll|auto}
overflow-x-{hidden|visible|scroll|auto}
overflow-y-{hidden|visible|scroll|auto}
```

**Note:** `overflow-y-auto`/`overflow-x-auto` creates `SingleChildScrollView`. Use `scrollPrimary: true` on WDiv for iOS status bar tap-to-top behavior.

## Aspect Ratio

```
aspect-{auto|square|video}
aspect-[W/H]                 aspect-[16/9]
```

## Z-Index

```
z-{0|10|20|30|40|50}
z-[N]
z-auto
```

## Animation & Transition

```
# Transition
duration-{75|100|150|200|300|500|700|1000}
duration-[Nms]
ease-{linear|in|out|in-out}

# Animation
animate-{spin|ping|pulse|bounce|none}
```

## SVG

```
fill-{color}-{shade}, fill-none, fill-current
stroke-{color}-{shade}, stroke-none, stroke-current
```

## Debug

```
debug                        enables logging for that widget
```

## Visibility (Responsive)

```
hidden                       display: none
sm:hidden, md:hidden, etc.   hide at breakpoint
sm:block, md:flex, etc.      show at breakpoint
```

Example: `hidden sm:block` — hidden on mobile, visible on sm+
