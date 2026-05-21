# Tailwind → Wind UI migration

A developer fluent in Tailwind CSS will write some patterns correctly in Wind and trip over others. This is the complete v3/v4 diff catalog, ordered by frequency of mistake.

## Identical between Tailwind and Wind

Default-write these and you are correct.

| Concept | Both have |
|---------|-----------|
| Spacing scale | `p-1` = 4 px, `p-4` = 16 px (Wind: logical pixels; Tailwind v4: `0.25rem` per unit, equivalent to 4 px) |
| Color palette | 22 families × 11 shades (50-950) = 242 colors |
| Color shade naming | `red-500`, `slate-900`, `blue-50` ... `blue-950` |
| Breakpoints | `sm:` (640), `md:` (768), `lg:` (1024), `xl:` (1280), `2xl:` (1536) |
| Mobile-first cascade | `text-sm md:text-base lg:text-lg` |
| Dark prefix | `dark:bg-gray-800` |
| State prefixes | `hover:`, `focus:`, `active:`, `disabled:` |
| Arbitrary bracket values | `p-[10px]`, `bg-[#ff5733]`, `text-[1.5rem]` |
| Opacity modifier `/N` | `bg-red-500/50`, `text-white/80` (Wind: on color-bearing tokens only) |
| Flex display + direction | `flex`, `flex-row`, `flex-col`, `flex-row-reverse`, `flex-col-reverse` |
| Justify + items | `justify-between`, `justify-center`, `items-center`, `items-start` |
| Grid columns | `grid grid-cols-3 gap-4` |
| Position type | `relative`, `absolute` |
| Position offsets | `top-0`, `inset-y-4`, negative `-top-2` |
| Aspect ratio | `aspect-square`, `aspect-video`, arbitrary `aspect-[4/3]` |
| Border + radius | `border`, `border-2`, `rounded-lg`, `border-t-4`, `rounded-tl-md` |
| Shadow | `shadow`, `shadow-lg`, `shadow-2xl`, color-tinted `shadow-blue-500/20` |
| Animation tokens (by name) | `animate-spin`, `animate-pulse`, `animate-bounce`, `animate-ping` |
| Truncation | `truncate`, `line-clamp-3` |
| Z-index | `z-10`, `z-50` |

## Renamed in Wind

Mechanically the same but spelled differently.

| Tailwind | Wind |
|----------|------|
| `flex-wrap` | `wrap` |
| `bg-opacity-50` (v3 deprecated) | `bg-red-500/50` (modifier) |
| `!flex` (v3 important) or `flex!` (v4 important) | (no equivalent — Wind has no important-marker concept) |

## Wind has features Tailwind lacks

| Wind-only | Tailwind reality | Purpose |
|-----------|------------------|---------|
| `ios:`, `android:`, `web:`, `mobile:` prefixes | CSS has no platform variants | Conditional styling by OS |
| `axis-min`, `axis-max` | No Flutter `MainAxisSize` analog | Control flex container size |
| Inline `backgroundColor` / `foregroundColor` props | CSS uses inline `style` | Runtime-dynamic colors that bypass parser cache |
| `WDynamic` JSON renderer | CSS has no equivalent | Server-driven UI from JSON |
| `WBreakpoint` widget | `@container` queries (v4) cover layout-shape branching | Declarative per-breakpoint WIDGET STRUCTURE (not just style) |
| `scrollPrimary: true` constructor prop | CSS has no analog | iOS tap-to-status-bar-to-scroll-top |
| `selected:`, `loading:`, `error:`, custom states via `states:` Set | Has `checked:` and similar variants | Wider state vocabulary, custom states supported |

## Tailwind features Wind DOES NOT support

Writing any of these in a Wind className produces no effect and no error.

### Layout & flex

| Tailwind | Why missing in Wind |
|----------|---------------------|
| `flex-wrap` | Flutter's `Wrap` is a separate widget; Wind exposes it via `wrap` |
| `divide-x`, `divide-y`, `divide-{color}` | Would require sibling-aware rendering (DOM sibling selectors); Wind has no DOM |
| `space-x-reverse`, `divide-x-reverse` | Same reason |
| `fixed`, `sticky` position types | Parser sees them but treats as `relative` (Flutter has no fixed/sticky overlay model in className) |

### Selectors

| Tailwind | Why missing in Wind |
|----------|---------------------|
| `group-*` (parent state via `group` class on ancestor) | Requires DOM ancestor selector; use `states:` to propagate explicitly |
| `peer-*` (sibling state via `peer` class) | Requires DOM sibling selector; use shared parent state instead |
| `has-*` (parent-of-something selector) | Same |
| Container queries `@container`, `@sm:`, `@md:`, etc. | No DOM containment in Flutter; use `WBreakpoint` for layout-shape changes |

### Effects

| Tailwind | Why missing in Wind |
|----------|---------------------|
| `filter`, `blur-*`, `backdrop-blur-*`, `drop-shadow-*`, `saturate-*`, `brightness-*`, `contrast-*` | Flutter `BackdropFilter`/`ImageFilter` exist but are not wired into the parser; wrap manually if needed |
| `cursor-pointer`, `cursor-not-allowed`, `cursor-*` | Web-only CSS concept; Flutter has `MouseCursor` but Wind does not expose it via className |
| `pointer-events-none`, `pointer-events-auto` | Use Flutter `AbsorbPointer`/`IgnorePointer` directly |
| `mix-blend-*`, `bg-blend-*` | Not implemented |

### Typography

| Tailwind | Why missing in Wind |
|----------|---------------------|
| `text-7xl` (72 px), `text-8xl` (96 px), `text-9xl` (128 px) | Font-size scale stops at `text-6xl` (60 px) in Wind defaults |
| `text-pretty` | Not in CSS spec until v4; not implemented |
| Font feature settings (`font-stylistic-*`, `font-tabular-*`, etc.) | Use `TextStyle.fontFeatures` inline |

### CSS-specific concepts

| Tailwind | Why missing in Wind |
|----------|---------------------|
| `@apply` directive | No CSS layer in Flutter |
| `@layer base/components/utilities` | No CSS layer |
| `@variant` (v4) | No CSS layer |
| `!important` markers (`!flex` v3 or `flex!` v4) | No cascade conflicts to resolve; last class wins is the only rule |
| `tailwind.config.js` | Use `WindThemeData(...)` constructor params instead |
| `:root` CSS variables / `var(--my-color)` | Use `WindThemeData` or `context.windTheme` |

## Mapping cheat sheet

When you would write a Tailwind class that Wind does not support, here is the typical Wind replacement.

```css
/* Tailwind */
group hover:bg-blue-500
group-hover:text-white
```
```dart
// Wind
// Use shared state via the parent's `states:` Set; pass to children explicitly:
WAnchor(
  child: Builder(builder: (context) {
    final isHovering = WindAnchorStateProvider.of(context).isHovering;
    return WDiv(
      states: isHovering ? {'hover'} : const {},
      // OR drive child className conditionally — but prefer states-driven approach
      children: [...],
    );
  }),
);
```

```css
/* Tailwind */
@apply bg-blue-500 text-white p-4 rounded-lg;
```
```dart
// Wind: just put the tokens directly in the consumer's className.
// If you need reuse, extract a Dart widget:
class PrimaryCard extends StatelessWidget {
  const PrimaryCard({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => WDiv(
    className: 'bg-blue-500 text-white p-4 rounded-lg',
    child: child,
  );
}
```

```css
/* Tailwind */
@container (min-width: 32rem) {
  .grid { grid-template-columns: 1fr 1fr; }
}
```
```dart
// Wind: use a viewport breakpoint OR WBreakpoint for structural changes.
WDiv(className: 'grid grid-cols-1 md:grid-cols-2');
// OR when the WIDGET TREE differs:
WBreakpoint(
  base: (ctx) => MobileCard(),
  md: (ctx) => DesktopCard(),
);
```

```css
/* Tailwind v4 */
<button class="bg-red-500!">  /* important */
```
```dart
// Wind: there is no important marker. Last class wins;
// runtime overrides via inline props.
WDiv(backgroundColor: Colors.red, className: 'bg-anything-else');
```

```css
/* Tailwind */
<div class="cursor-pointer">
```
```dart
// Wind: use the appropriate W-widget. Interactive surfaces are WButton or WAnchor.
WButton(onTap: () {}, child: WText('Click me'));
// or a WAnchor wrap if the surface is not a button shape.
```

```css
/* Tailwind */
<div class="divide-y divide-gray-200">
  <div>A</div>
  <div>B</div>
</div>
```
```dart
// Wind: explicit bottom-borders on each item except the last
WDiv(
  className: 'flex flex-col',
  children: [
    WDiv(className: 'border-b border-gray-200 dark:border-gray-700', child: ...),
    WDiv(className: 'border-b border-gray-200 dark:border-gray-700', child: ...),
    WDiv(child: ...),  // last item: no bottom border
  ],
);
```

## Version-tracking notes

- **Tailwind v3 vs v4**: Wind tracks the v3 mental model (explicit spacing ladder, `bg-opacity-50` deprecated form not supported, `!flex` v3 important not supported). Wind's `bg-red-500/50` opacity modifier matches v3+ syntax.
- **Tailwind v4 spacing multiplier**: v4 lets you write `p-97.25`. Wind requires either a theme-scale value OR an arbitrary `p-[Npx]`.
- **Tailwind v4 container queries**: not supported. Use `WBreakpoint` or viewport breakpoints.
- **Tailwind v4 `@variant`, `@layer base`**: not applicable (Wind has no CSS layer).

## When in doubt

- `references/tokens.md` is the canonical Wind className inventory. If a token is not in there, it does not work — period.
- `references/widgets.md` is the canonical W-widget surface. If a widget is not in there, it is not part of v1's public API.
- Wind's `lib/src/parser/parsers/` directory has 17 files; one per parser family. Reading the file directly is the ground truth for what works.
