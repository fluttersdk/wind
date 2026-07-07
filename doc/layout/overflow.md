# Overflow

Utilities for controlling how an element handles content that is too large for the container.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Variants](#variants)
- [Responsive Design](#responsive-design)
- [Dark Mode](#dark-mode)
- [Arbitrary Values](#arbitrary-values)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<x-preview path="effects/overflow_basic" size="md" source="example/lib/pages/effects/overflow_basic.dart"></x-preview>

```dart
// Basic examples
WDiv(className: 'overflow-hidden')
WDiv(className: 'overflow-scroll')
WDiv(className: 'overflow-x-auto')
```

<a name="basic-usage"></a>
## Basic Usage

Use `overflow-{mode}` to control how content behaves when it exceeds the container's bounds.

### Hidden

Use `overflow-hidden` to clip any content that extends beyond the container's edges. This applies `Clip.hardEdge` to the widget.

```dart
WDiv(
  className: 'overflow-hidden w-20 h-20 bg-white rounded-lg',
  child: WDiv(className: 'w-40 h-40 bg-red-500'),
)
```

### Scroll

Use `overflow-scroll` to enable scrolling regardless of whether content overflows. This generally wraps the content in a `SingleChildScrollView`.

```dart
WDiv(
  className: 'overflow-scroll w-64 h-64 bg-white',
  child: LongContentWidget(),
)
```

### Auto

Use `overflow-auto` to enable scrolling only when content actually overflows the container bounds.

```dart
WDiv(
  className: 'overflow-auto max-h-48 bg-gray-100',
  child: LongContentWidget(),
)
```

### Visible

Use `overflow-visible` to allow content to spill out of the container. This applies `Clip.none` and prevents the container from introducing a scroll context.

```dart
WDiv(
  className: 'overflow-visible',
  child: LargeContentWidget(),
)
```

<a name="quick-reference"></a>
## Quick Reference

| Class | Flutter Equivalent | Description |
|:------|:-------------------|:------------|
| `overflow-auto` | `SingleChildScrollView` (conditional) | Scroll only if content overflows |
| `overflow-hidden` | `Clip.hardEdge` | Clip overflowing content |
| `overflow-visible` | `Clip.none` | Content flows outside container |
| `overflow-scroll` | `SingleChildScrollView` | Always enable scrolling |

<a name="variants"></a>
## Variants

### Directional Overflow

Use `overflow-x-{mode}` and `overflow-y-{mode}` to control overflow on a specific axis independently.

<x-preview path="effects/overflow_directional" size="md" source="example/lib/pages/effects/overflow_directional.dart"></x-preview>

```dart
WDiv(className: 'overflow-x-scroll overflow-y-hidden')
```

| Class | Description |
|:------|:------------|
| `overflow-x-auto` | Scroll horizontally if needed |
| `overflow-y-scroll` | Always scroll vertically |
| `overflow-x-hidden` | Clip horizontal overflow |
| `overflow-y-visible` | Allow vertical overflow |

<a name="min-width-scroll"></a>
## Fill on Desktop, Scroll on Narrow (Responsive Table)

Compose `overflow-x-auto` on a wrapper with `w-full` (optionally `min-w-[Npx]`) on the inner content, the same pattern shadcn's `<Table>` uses. The inner content fills the viewport when it is wide and honors its minimum width (so the wrapper scrolls) when it is narrow:

```dart
WDiv(
  className: 'overflow-x-auto',
  child: WDiv(
    className: 'w-full min-w-[600px] flex flex-row',
    children: [
      WDiv(className: 'flex-1', child: WText('Name')),
      WDiv(className: 'flex-1', child: WText('Status')),
      WDiv(className: 'flex-1', child: WText('Updated')),
    ],
  ),
)
```

On a viewport wider than `600px` the row fills the container (no horizontal scroll). On a narrower viewport it stays `600px` wide and the wrapper scrolls horizontally. This works with no new token: `w-full` inside a horizontal scroll is threaded the viewport width instead of asserting on the scroll's unbounded width, and `min-w-[Npx]` sets the scroll floor. Without a `min-w-*` floor, `w-full` simply fills the viewport.

<x-preview path="layout/responsive_table" size="lg" source="example/lib/pages/layout/responsive_table.dart"></x-preview>

> **`h-full` inside a vertical scroll is a layout error.** A child that resolves `h-full` inside an `overflow-y-auto` / `overflow-y-scroll` parent has an unbounded height and produces a cryptic Flutter failure. Wind raises an actionable assert in debug pointing at the fix: use `flex-1` inside a `flex flex-col` (with the scroll on the column) instead of `h-full` inside a vertical scroll. The scroll container itself may still carry `h-full` (it is bounded by its own parent).

<a name="responsive-design"></a>
## Responsive Design

Apply different overflow behaviors at different breakpoints using standard modifiers like `sm:`, `md:`, `lg:`, `xl:`, and `2xl:`.

```dart
// Scroll on mobile, but show full content on desktop
WDiv(className: 'overflow-scroll md:overflow-visible')
```

<a name="dark-mode"></a>
## Dark Mode

Change overflow behavior in dark mode using the `dark:` prefix.

```dart
WDiv(className: 'overflow-visible dark:overflow-hidden')
```

<a name="arbitrary-values"></a>
## Arbitrary Values

The overflow utility does not support arbitrary values. You must use one of the defined keywords (`hidden`, `visible`, `scroll`, `auto`).

<a name="customizing-theme"></a>
## Customizing Theme

Overflow utilities are hardcoded behavior toggles and cannot be customized via `WindThemeData`.

<a name="related-documentation"></a>
## Related Documentation

- [Sizing](../layout/sizing.md)
- [Display](../layout/display.md)
