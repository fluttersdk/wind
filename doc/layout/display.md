# Display

Utilities for controlling the layout mode of an element.

- [Basic Usage](#basic-usage)
  - [Block](#block)
  - [Flex](#flex)
  - [Grid](#grid)
  - [Wrap](#wrap)
  - [Hidden](#hidden)
- [Quick Reference](#quick-reference)
- [Responsive Design](#responsive-design)
- [Dark Mode](#dark-mode)
- [State Variants](#state-variants)
- [Arbitrary Values](#arbitrary-values)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<!-- TODO: [UPDATE] path="layout/display" action="VERIFY" -->
<!-- Description: Ensure example covers block, flex, grid, and hidden modes -->
<x-preview path="layout/display" size="lg" source="example/lib/pages/layout/display.dart"></x-preview>

```dart
// Flex container
WDiv(className: 'flex gap-4', children: [...])

// Grid container
WDiv(className: 'grid grid-cols-3', children: [...])

// Hidden element
WDiv(className: 'hidden', child: ...)
```

<a name="basic-usage"></a>
## Basic Usage

<a name="block"></a>
### Block

Use `block` to create a standard block-level element. In Wind, this is the default behavior of `WDiv` (rendering a `Container` or `SizedBox`).

```dart
WDiv(
  className: 'block p-4 bg-white',
  child: WText('This is a block element'),
)
```

<a name="flex"></a>
### Flex

Use `flex` to create a flex container. This enables Flexbox layout properties (like `flex-row`, `items-center`, `justify-between`).

> [!NOTE]
> `flex` creates a `Row` or `Column` depending on `flex-row` (default) or `flex-col`.

```dart
WDiv(
  className: 'flex items-center space-x-4',
  children: [
    WDiv(className: 'w-10 h-10 bg-blue-500'),
    WText('Flex item'),
  ],
)
```

<a name="grid"></a>
### Grid

Use `grid` to create a grid container. This enables Grid layout properties (like `grid-cols-3`, `gap-4`).

```dart
WDiv(
  className: 'grid grid-cols-3 gap-4',
  children: [
    WDiv(className: 'h-20 bg-blue-100'),
    WDiv(className: 'h-20 bg-blue-200'),
    WDiv(className: 'h-20 bg-blue-300'),
  ],
)
```

<a name="wrap"></a>
### Wrap

Use `wrap` to create a wrapping container. This renders a Flutter `Wrap` widget.

> [!WARNING]
> Do **not** use `flex flex-wrap`. In Flutter, `Row`/`Column` cannot wrap. Always use the `wrap` display utility instead.

```dart
WDiv(
  className: 'wrap gap-2',
  children: [
    WChip('React'),
    WChip('Flutter'),
    WChip('Vue'),
  ],
)
```

<a name="hidden"></a>
### Hidden

Use `hidden` to remove an element from the visual tree. This renders a `SizedBox.shrink()` (effectively 0x0 size).

```dart
WDiv(
  className: 'hidden',
  child: WText('This will not appear'),
)
```

<a name="quick-reference"></a>
## Quick Reference

| Class | Description |
| :--- | :--- |
| `block` | Standard box model layout (Default). |
| `flex` | Creates a Flex container (Row/Column). |
| `grid` | Creates a Grid container. |
| `wrap` | Creates a Wrap container. |
| `hidden` | Removes the element from the layout. |

<a name="responsive-design"></a>
## Responsive Design

Prefix any display utility with a breakpoint variant like `md:` to apply it only at specific screen sizes.

<x-preview path="layout/responsive_display" size="lg" source="example/lib/pages/layout/responsive_display.dart"></x-preview>

```dart
// Hidden on mobile, Flex on medium screens and up
WDiv(
  className: 'hidden md:flex gap-4',
  children: [...],
)

// Block on mobile, Hidden on large screens
WDiv(
  className: 'block lg:hidden',
  child: ...,
)
```

<a name="dark-mode"></a>
## Dark Mode

Prefix any display utility with `dark:` to apply it only when dark mode is active.

```dart
// Visible only in dark mode
WDiv(
  className: 'hidden dark:block',
  child: WText('Dark Mode Active'),
)
```

<a name="state-variants"></a>
## State Variants

Prefix utilities with state variants like `hover:`, `focus:`, or `active:` to conditionally apply display modes.

```dart
// Show element on hover
WDiv(
  className: 'hidden group-hover:block',
  child: ...,
)
```

<a name="arbitrary-values"></a>
## Arbitrary Values

The display utility does not support arbitrary values. You must use one of the predefined keywords (`block`, `flex`, `grid`, `wrap`, `hidden`).

<a name="customizing-theme"></a>
## Customizing Theme

Display utilities are structural and cannot be customized via `WindThemeData`. They map directly to Flutter widgets (`Row`, `Column`, `Wrap`, `GridView`).

<a name="related-documentation"></a>
## Related Documentation

- [Flexbox](./flexbox.md) - Layout direction, alignment, and sizing for flex containers.
- [Grid](./grid.md) - Column definitions and gaps for grid containers.
- [Visibility](./visibility.md) - Control visibility without changing layout (opacity).
