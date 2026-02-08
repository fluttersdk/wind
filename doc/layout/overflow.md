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
