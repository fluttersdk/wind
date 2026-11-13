---
version: alpha
name: wind_kit gallery
description: The demo gallery embedded in the wind_kit docs, drawn with wind_kit itself, with slate surfaces, one blue accent and a gradient header per page.
colors:
  primary: "#0986E0"
  on-primary: "#FFFFFF"
  demo-accent: "#3B82F6"
  demo-accent-hover: "#2563EB"
  canvas: "#F8FAFC"
  canvas-dark: "#0F172A"
  surface: "#FFFFFF"
  surface-dark: "#1E293B"
  on-surface: "#0F172A"
  on-surface-dark: "#FFFFFF"
  on-surface-muted: "#475569"
  on-surface-muted-dark: "#94A3B8"
  outline: "#E2E8F0"
  outline-dark: "#334155"
  error: "#EF4444"
typography:
  page-title:
    fontFamily: system-ui
    fontSize: 24px
    fontWeight: 700
  section-title:
    fontFamily: system-ui
    fontSize: 18px
    fontWeight: 600
  body-sm:
    fontFamily: system-ui
    fontSize: 14px
    fontWeight: 400
rounded:
  DEFAULT: 4px
  md: 6px
  lg: 8px
  xl: 12px
  full: 9999px
spacing:
  base: 4px
  md: 16px
  card: 20px
  lg: 24px
components:
  page-canvas:
    backgroundColor: "{colors.canvas}"
    padding: "{spacing.md}"
  page-canvas-dark:
    backgroundColor: "{colors.canvas-dark}"
    padding: "{spacing.md}"
  page-header:
    textColor: "{colors.on-primary}"
    typography: "{typography.page-title}"
    rounded: "{rounded.xl}"
    padding: "{spacing.lg}"
  section-card:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.on-surface}"
    typography: "{typography.section-title}"
    rounded: "{rounded.xl}"
    padding: "{spacing.card}"
  section-card-dark:
    backgroundColor: "{colors.surface-dark}"
    textColor: "{colors.on-surface-dark}"
    typography: "{typography.section-title}"
    rounded: "{rounded.xl}"
    padding: "{spacing.card}"
  hairline:
    backgroundColor: "{colors.outline}"
    height: 1px
  hairline-dark:
    backgroundColor: "{colors.outline-dark}"
    height: 1px
  caption:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.on-surface-muted}"
    typography: "{typography.body-sm}"
  caption-dark:
    backgroundColor: "{colors.surface-dark}"
    textColor: "{colors.on-surface-muted-dark}"
    typography: "{typography.body-sm}"
  button-demo:
    backgroundColor: "{colors.demo-accent}"
    textColor: "{colors.on-primary}"
    typography: "{typography.body-sm}"
    rounded: "{rounded.lg}"
  button-demo-hover:
    backgroundColor: "{colors.demo-accent-hover}"
    textColor: "{colors.on-primary}"
  error-fill:
    backgroundColor: "{colors.error}"
    textColor: "{colors.on-primary}"
---

## Overview

`example/` is the canonical visual reference for wind_kit: each page demonstrates one widget or one concept, and the docs site embeds the pages in iframes. The gallery is built from the toolkit it documents, so its look is whatever the default Tailwind-shaped scales produce plus one overridden brand colour.

## Colors

- **Primary (#0986E0) and On-primary (#FFFFFF):** the brand blue set in `example/lib/main.dart` as the theme's `primary`; wind_kit widgets read it for selection states (select, checkbox, radio, date picker). The default `primary` is Tailwind blue-500, so this override recolours only what reads the token.
- **Demo-accent (#3B82F6) and its hover (#2563EB):** Tailwind `blue-500` and `blue-600`, the fill of the buttons the pages demonstrate (`bg-blue-500 hover:bg-blue-600` in `.claude/rules/example-pages.md`). It is not the `primary` token, so a demo and a widget default can sit side by side in two blues.
- **Canvas, Surface and Outline, light and dark:** the scaffold's slate set in `example/lib/widgets/example_scaffold.dart`: canvas `slate-50` and `slate-900`, cards `white` and `slate-800`, hairlines `slate-200` and `slate-700`.
- **On-surface and On-surface muted:** titles `slate-900` (white in dark mode) and descriptions `slate-600` (`slate-400` in dark mode).
- **Error (#EF4444):** `red-500`, the red fill the pages use. White text on it measures 3.8:1, below the 4.5:1 AA floor, so the linter warns on `error-fill`.

## Typography

One family, the theme's default `sans` stack (`system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif`, from `lib/src/theme/defaults/font_families.dart`). Page titles are `text-2xl font-bold`, section titles `text-lg font-semibold`, descriptions and captions `text-sm`.

## Layout

The theme unit is 4 px. A page is `p-4` (16 px) around a `max-w-4xl` (896 px) column centred with `mx-auto` and spaced with `gap-6` (24 px); a section card pads `p-5` (20 px) and the header `p-6` (24 px). The docs site embeds each page in an iframe, where 1024 px wide is safe.

## Elevation & Depth

Shadows come from the theme's `shadow-*` scale (`lib/src/theme/defaults/box_shadows.dart`), which follows Tailwind v3: `shadow-sm` is `0 1px 2px` at 5% black, `shadow-lg` starts at `0 10px 15px -3px` at 10%. The pages use `shadow-lg` most, then `shadow` and `shadow-xl`. The scaffold's own section cards use a border instead of a shadow.

## Shapes

Section cards and headers use `rounded-xl` (12 px). Across the pages `rounded-lg` (8 px) is by far the most common radius, then `rounded` (4 px), `rounded-xl`, `rounded-full` (9999 px) and `rounded-md` (6 px).

## Components

- **Page header:** a `bg-gradient-to-r` block, `rounded-xl p-6`, white title, `text-white/80` description. Each page chooses its own gradient pair; the page rule's default is `blue-500` to `purple-500`. A gradient has no token, so the header carries no background colour here.
- **Section card:** `bg-white dark:bg-slate-800`, `border-slate-200 dark:border-slate-700`, `rounded-xl p-5`, a `text-lg font-semibold` title above a `text-sm` description.
- **Demo button:** white text on `demo-accent`, `hover:bg-blue-600`. White on `blue-500` measures 3.7:1, below the 4.5:1 AA floor for 14 px text, so the linter warns on this pair; the pages use it today.

## Do's and Don'ts

- Do build new surfaces from the slate set above, as the scaffold (`example/lib/widgets/example_scaffold.dart`) does.
- Do keep a page's content inside one `max-w-4xl` column.
- Do open every page with one gradient header and put the demonstrations in section cards under it.
- Don't hard-code a width above 1024 px: 1280 px and over risks a sideways scroll in a narrow embed (`example/CLAUDE.md`).
