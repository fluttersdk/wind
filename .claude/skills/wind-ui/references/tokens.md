# Wind UI Token Reference

This document maps `className` string tokens to their native Flutter semantics.

## 1. Layout & Flexbox

**CRITICAL RULE:** Flutter constraints differ from CSS. Pay close attention to the Flutter Mapping column.

| Token | Flutter Mapping | Notes |
|-------|-----------------|-------|
| `flex` | `Row` or `Column` | Defaults to Row unless `flex-col` is present. |
| `grid` | `Wrap` | Uses Wrap, not GridView. Used with `grid-cols-{n}`. |
| `wrap` | `Wrap` | **CRITICAL:** DO NOT USE `flex-wrap` (it is a no-op). Use `wrap` instead. |
| `block` | `SizedBox` | Generic container. |
| `hidden` | `SizedBox.shrink()` | Hides the widget completely. |
| `flex-row` | `Axis.horizontal` | Standard row layout. |
| `flex-col` | `Axis.vertical` | Standard column layout. |
| `flex-row-reverse` | `Axis.horizontal` | Row layout with reversed children order (via textDirection). |
| `flex-col-reverse` | `Axis.vertical` | Column layout with reversed children order (via verticalDirection). |
| `flex-1` | `Expanded(flex: 1)` | **CRITICAL:** Use this to fill remaining space in a Row/Column. |
| `flex-auto` | `Flexible(fit: FlexFit.loose)` | Child can shrink but won't force expansion. |
| `flex-none` | `Flexible(fit: FlexFit.loose)` | Same as `flex-auto` in this implementation. |
| `shrink-0` | `Flexible(fit: FlexFit.tight)` | Child cannot shrink. |
| `justify-start` | `MainAxisAlignment.start` | Align to main-axis start. |
| `justify-end` | `MainAxisAlignment.end` | Align to main-axis end. |
| `justify-center` | `MainAxisAlignment.center` | Align to main-axis center. |
| `justify-between`| `MainAxisAlignment.spaceBetween`| Distribute space between items. |
| `justify-around` | `MainAxisAlignment.spaceAround` | Distribute space around items. |
| `justify-evenly` | `MainAxisAlignment.spaceEvenly` | Distribute space evenly. |
| `items-start` | `CrossAxisAlignment.start` | Align to cross-axis start. |
| `items-end` | `CrossAxisAlignment.end` | Align to cross-axis end. |
| `items-center` | `CrossAxisAlignment.center` | Align to cross-axis center. |
| `items-stretch` | `CrossAxisAlignment.stretch` | Stretch to fill cross-axis. |
| `items-baseline` | `CrossAxisAlignment.baseline` | Align text baseline. |
| `gap-{n}` | `SizedBox` spacing | Applies to both axes. Formula: `n × 4px`. |
| `gap-x-{n}` | Horizontal spacing | Formula: `n × 4px`. |
| `gap-y-{n}` | Vertical spacing | Formula: `n × 4px`. |
| `self-start` | `Alignment.topCenter` | Used for single child alignment. |
| `self-center` | `Alignment.center` | Used for single child alignment. |
| `grid-cols-{n}`| `Wrap` constraints | Calculates width to fit exactly `n` items per row. |

## 2. Spacing

Spacing tokens follow a mathematical formula. You do not need an exhaustive list.

**Formula: `n × 4px`**

| Token Prefix | Axis | Description | Example (`-4` = 16px) |
|--------------|------|-------------|-----------------------|
| `p-` | All | Padding on all sides | `p-4` (16px all sides) |
| `px-` | Horizontal | Padding left and right | `px-4` (16px L/R) |
| `py-` | Vertical | Padding top and bottom | `py-4` (16px T/B) |
| `pt-` | Top | Padding top | `pt-4` (16px top) |
| `pr-` | Right | Padding right | `pr-4` (16px right) |
| `pb-` | Bottom | Padding bottom | `pb-4` (16px bottom) |
| `pl-` | Left | Padding left | `pl-4` (16px left) |
| `m-` | All | Margin on all sides | `m-4` (16px all sides) |
| `mx-` | Horizontal | Margin left and right | `mx-4` (16px L/R) |
| `my-` | Vertical | Margin top and bottom | `my-4` (16px T/B) |
| `mt-` | Top | Margin top | `mt-4` (16px top) |
| `mr-` | Right | Margin right | `mr-4` (16px right) |
| `mb-` | Bottom | Margin bottom | `mb-4` (16px bottom) |
| `ml-` | Left | Margin left | `ml-4` (16px left) |

### Common Values Reference
- `1` = 4px
- `2` = 8px
- `3` = 12px
- `4` = 16px
- `5` = 20px
- `6` = 24px
- `8` = 32px
- `10` = 40px
- `12` = 48px

### Arbitrary & Special Spacing
| Token | Flutter Mapping | Notes |
|-------|-----------------|-------|
| `mx-auto` | Center horizontally | Typically wraps in a Row with `MainAxisAlignment.center`. |
| `p-[10px]` | Exact pixels | Arbitrary padding. px suffix is optional but recommended. |
| `m-[5.5]` | Exact pixels | Arbitrary margin (evaluates to 5.5px, not `5.5 * 4`). |

## 3. Sizing

Sizing applies fixed dimensions or constraints.

| Token | Flutter Mapping | Notes |
|-------|-----------------|-------|
| `w-{n}` | `width: n * 4.0` | Exact width calculation (e.g., `w-16` = 64px). |
| `w-full` | `width: double.infinity` | **CRITICAL:** Works in Column. **OVERFLOWS** in Row. Use `flex-1` in Rows! |
| `w-screen` | `MediaQuery.size.width`| Full viewport width. |
| `w-1/2` | `widthFactor: 0.5` | 50% width via FractionallySizedBox logic. |
| `w-1/3` | `widthFactor: 0.333` | 33% width. |
| `w-2/3` | `widthFactor: 0.666` | 66% width. |
| `w-1/4` | `widthFactor: 0.25` | 25% width. |
| `h-{n}` | `height: n * 4.0` | Exact height calculation. |
| `h-full` | Height bounded | **CRITICAL:** Parent MUST have bounded height. Errors in scrollable views. |
| `h-screen` | `MediaQuery.size.height`| Full viewport height. |
| `min-h-screen`| `BoxConstraints(minHeight)`| Ensures at least screen height (ideal for scroll views). |
| `min-w-{n}` | `minWidth: n * 4.0` | Minimum width constraint. |
| `max-w-{preset}`| `maxWidth: preset` | Maximum width constraint (see presets below). |
| `min-h-{n}` | `minHeight: n * 4.0` | Minimum height constraint. |
| `max-h-{n}` | `maxHeight: n * 4.0` | Maximum height constraint. |
| `aspect-auto` | No aspect ratio | Default behavior. |
| `aspect-square`| `AspectRatio(1.0)` | Forces 1:1 aspect ratio. Needs 1 bounded dimension. |
| `aspect-video`| `AspectRatio(16/9)` | Forces 16:9 aspect ratio. Needs 1 bounded dimension. |
| `aspect-[4/3]`| `AspectRatio(4/3)` | Arbitrary aspect ratio. |

### Max-Width Presets
- `xs` (320px)
- `sm` (384px)
- `md` (448px)
- `lg` (512px)
- `xl` (576px)
- `2xl` (672px)
- `3xl` (768px)
- `4xl` (896px)
- `5xl` (1024px)
- `prose` (65ch approx)

## 4. Typography

### Size & Weight Scales

| Size Token | Pixel Size | Line Height | | Weight Token | Font Weight |
|------------|------------|-------------|-|--------------|-------------|
| `text-xs` | 12px | 16px | | `font-thin` | w100 |
| `text-sm` | 14px | 20px | | `font-extralight`| w200 |
| `text-base` | 16px | 24px | | `font-light` | w300 |
| `text-lg` | 18px | 28px | | `font-normal`| w400 |
| `text-xl` | 20px | 28px | | `font-medium`| w500 |
| `text-2xl` | 24px | 32px | | `font-semibold`| w600 |
| `text-3xl` | 30px | 36px | | `font-bold` | w700 |
| `text-4xl` | 36px | 40px | | `font-extrabold`| w800 |
| `text-5xl` | 48px | 48px | | `font-black` | w900 |

### Styling

| Token | Flutter Mapping | Notes |
|-------|-----------------|-------|
| `text-left` | `TextAlign.left` | - |
| `text-center` | `TextAlign.center` | - |
| `text-right` | `TextAlign.right` | - |
| `text-justify` | `TextAlign.justify` | - |
| `text-{color}-{shade}`| `color: ThemeColor`| E.g., `text-primary`, `text-blue-500`. |
| `text-[#hex]` | `color: HexColor` | E.g., `text-[#FF5733]`. |
| `text-{color}/80` | `color: Color.withOpacity`| Opacity modifier. E.g., `text-white/80`. |
| `uppercase` | `.toUpperCase()` | String transformation. |
| `lowercase` | `.toLowerCase()` | String transformation. |
| `capitalize` | Custom util | Capitalize first letter of each word. |
| `normal-case` | Original string | Reverts transforms. |
| `underline` | `TextDecoration.underline`| - |
| `line-through` | `TextDecoration.lineThrough`| - |
| `no-underline` | `TextDecoration.none`| - |
| `truncate` | `TextOverflow.ellipsis`| **CRITICAL:** Requires `Expanded` parent in Row to prevent infinite width errors. |
| `text-ellipsis`| `TextOverflow.ellipsis`| Similar to truncate but doesn't force `maxLines: 1`. |
| `line-clamp-{n}`| `maxLines: n` | Limits text to exact number of lines. |

### Leading & Tracking

| Token | Leading (Line Height) | | Token | Tracking (Letter Spacing) |
|-------|-----------------------|-|-------|---------------------------|
| `leading-none` | 1.0 | | `tracking-tight` | -0.025em |
| `leading-tight`| 1.25 | | `tracking-normal`| 0em |
| `leading-normal`| 1.5 | | `tracking-wide` | 0.025em |
| `leading-relaxed`| 1.625 | | `tracking-wider` | 0.05em |
| `leading-loose`| 2.0 | | `tracking-widest`| 0.1em |

## 5. Color & Background

All standard Tailwind color names are supported: `slate`, `gray`, `zinc`, `neutral`, `stone`, `red`, `orange`, `amber`, `yellow`, `lime`, `green`, `emerald`, `teal`, `cyan`, `sky`, `blue`, `indigo`, `violet`, `purple`, `fuchsia`, `pink`, `rose`.
Semantic colors: `primary`, `success`, `warning`, `error`, `info`.
Shades: `50`, `100`, `200`, `300`, `400`, `500`, `600`, `700`, `800`, `900`, `950`.

| Token | Description | Examples |
|-------|-------------|----------|
| `bg-{color}-{shade}` | Standard background | `bg-red-500`, `bg-primary` |
| `bg-[#hex]` | Arbitrary background | `bg-[#123456]` |
| `bg-transparent` | Transparent background | `bg-transparent` |
| `bg-white` | White background | `bg-white` |
| `bg-black` | Black background | `bg-black` |
| `bg-{color}/{opacity}` | **Opacity Modifier** | `bg-primary/50` (Works on all colors!) |
| `bg-gradient-to-{dir}` | Gradient direction | `bg-gradient-to-r`, `bg-gradient-to-br` |
| `from-{color}` | Gradient start color | `from-red-500` |
| `via-{color}` | Gradient middle color | `via-yellow-500` |
| `to-{color}` | Gradient end color | `to-blue-500` |
| `bg-[url(...)]` | Background image URL | `bg-[url(https://...)]` |
| `bg-cover` | Image fit cover | `BoxFit.cover` |
| `bg-contain` | Image fit contain | `BoxFit.contain` |
| `bg-center` | Image align center | `Alignment.center` |
| `bg-top` | Image align top | `Alignment.topCenter` |

## 6. Borders & Radius

| Token | Flutter Mapping | Notes |
|-------|-----------------|-------|
| `border` | `Border.all(width: 1)` | Default 1px border. |
| `border-0` | `Border.all(width: 0)` | No border width. |
| `border-2` | `Border.all(width: 2)` | 2px border width. |
| `border-4` | `Border.all(width: 4)` | 4px border width. |
| `border-8` | `Border.all(width: 8)` | 8px border width. |
| `border-t` | `Border(top: ...)` | Top border only. |
| `border-r` | `Border(right: ...)` | Right border only. |
| `border-b` | `Border(bottom: ...)` | Bottom border only. |
| `border-l` | `Border(left: ...)` | Left border only. |
| `border-{color}`| `Border(color: ...)` | Color. E.g., `border-gray-200`. |
| `border-{c}/50` | `Color.withOpacity(0.5)`| Opacity modifier. E.g., `border-gray-200/50`. |
| `border-solid` | `BorderStyle.solid` | Default style. |
| `border-dashed`| Pattern border | Dashed pattern. |
| `border-dotted`| Pattern border | Dotted pattern. |
| `border-none` | `BorderStyle.none` | No border style. |

### Radius Table
| Token | Radius Value |
|-------|--------------|
| `rounded` | 4px |
| `rounded-md` | 6px |
| `rounded-lg` | 8px |
| `rounded-xl` | 12px |
| `rounded-2xl` | 16px |
| `rounded-3xl` | 24px |
| `rounded-full` | 9999px |

### Per-Side Radius
Target specific corners by appending direction:
- `rounded-t-{size}`: Top-left and Top-right
- `rounded-b-{size}`: Bottom-left and Bottom-right
- `rounded-l-{size}`: Top-left and Bottom-left
- `rounded-r-{size}`: Top-right and Bottom-right
- `rounded-tl-{size}`: Top-left only

## 7. Effects

| Token | Description | Examples |
|-------|-------------|----------|
| `shadow` | Default shadow | `shadow` |
| `shadow-{preset}` | preset sizes | `shadow-sm`, `shadow-md`, `shadow-lg`, `shadow-xl`, `shadow-2xl` |
| `shadow-none` | No shadow | `shadow-none` |
| `shadow-{color}/{op}`| Colored shadow | `shadow-primary/20` |
| `opacity-{n}` | Preset opacity % | `opacity-0`, `opacity-50`, `opacity-100` |
| `opacity-[n]` | Arbitrary opacity factor | `opacity-[0.5]` |
| `ring` | Default outline ring | `ring` (implemented via BoxShadow) |
| `ring-{n}` | Ring width | `ring-2`, `ring-4` |
| `ring-{color}` | Ring color | `ring-blue-500` |
| `ring-offset-{n}`| Ring offset spacing | `ring-offset-2` |
| `ring-inset` | Inset ring | `ring-inset` |

## 8. Transitions & Animations

| Token | Flutter Mapping | Examples |
|-------|-----------------|----------|
| `duration-{n}` | `Duration(milliseconds: n)`| `duration-75`, `duration-150`, `duration-300`, `duration-500`, `duration-1000` |
| `ease-linear` | `Curves.linear` | Constant speed. |
| `ease-in` | `Curves.easeIn` | Starts slow, speeds up. |
| `ease-out` | `Curves.easeOut` | Starts fast, slows down. |
| `ease-in-out` | `Curves.easeInOut` | Slow start and end. |
| `animate-spin` | `RotationTransition` | Infinite rotation. |
| `animate-ping` | `ScaleTransition` | Radar ping effect. |
| `animate-pulse` | `FadeTransition` | Fading in and out opacity. |
| `animate-bounce`| `SlideTransition` | Vertical bounce effect. |
| `animate-none` | No animation | Stops active animation. |
| `scale-{n}` | `Transform.scale` | Usually paired with state. E.g., `active:scale-95`. |

## 9. Position & Z-Index

| Token | Flutter Mapping | Notes |
|-------|-----------------|-------|
| `absolute` | `Positioned` | Requires parent to be `relative` (Stack). |
| `relative` | `Stack` | Becomes a positioning context for children. |
| `sticky` | Native scroll behavior | Sticky header behavior within scroll view. |
| `fixed` | Application overlay | Renders above everything, locked to screen. |
| `inset-{n}` | `Positioned(top, right...)`| Spacing applied to all 4 edges. |
| `top-{n}` | `Positioned(top: ...)` | Spacing applied to top edge. |
| `right-{n}` | `Positioned(right: ...)` | Spacing applied to right edge. |
| `bottom-{n}` | `Positioned(bottom: ...)` | Spacing applied to bottom edge. |
| `left-{n}` | `Positioned(left: ...)` | Spacing applied to left edge. |
| `z-{n}` | Render stack order | Presets: `z-0`, `z-10`, `z-20`, `z-30`, `z-40`, `z-50` |
| `z-[n]` | Arbitrary stack order | `z-[100]` |

## 10. Overflow & Clipping

| Token | Flutter Mapping | Notes |
|-------|-----------------|-------|
| `overflow-hidden`| `ClipRect` / `ClipRRect`| Clips content to bounding box (respects radius). |
| `overflow-y-auto`| `SingleChildScrollView` | **CRITICAL:** Creates vertical scroll. Parent MUST have bounded height (like `flex-1` inside a Column). |
| `overflow-x-auto`| `SingleChildScrollView` | Creates horizontal scroll. |
| `overflow-visible`| No clipping applied | Allows content to render outside box. |

## Modifiers (Prefixes)

Prefixes can be chained to apply classes conditionally. E.g., `dark:hover:bg-gray-700`.

- **Responsive:** `sm:`, `md:`, `lg:`, `xl:`, `2xl:` (min-width breakpoints)
- **State:** `hover:`, `focus:`, `active:`, `disabled:`, `loading:`, `selected:`, `error:`
- **Theme:** `dark:` (REQUIRED for dark mode support)
- **Platform:** `ios:`, `android:`, `web:`, `mobile:`
