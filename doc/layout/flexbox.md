# Flexbox & Layout

Utilities for controlling flex containers, direction, alignment, wrapping, and spacing.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Flex Direction](#flex-direction)
- [Reversing Direction](#reversing-direction)
- [Child Order](#child-order)
- [Wrapping](#wrapping)
- [Justify Content](#justify-content)
- [Align Items](#align-items)
- [Align Content](#align-content)
- [Align Self](#align-self)
- [Flex, Grow & Shrink](#flex-grow--shrink)
- [Gap & Spacing](#gap--spacing)
- [Responsive Design](#responsive-design)
- [Arbitrary Values](#arbitrary-values)
- [Customizing Theme](#customizing-theme)
- [Flex Children Inside a Scrollable Axis](#flex-and-overflow)
- [Related Documentation](#related-documentation)

<x-preview path="layout/flex_intro" size="md" source="example/lib/pages/layout/flex_intro.dart"></x-preview>

```dart
// Basic flex row
WDiv(className: 'flex gap-4 items-center')

// Vertical column
WDiv(className: 'flex flex-col gap-2')
```

<a name="basic-usage"></a>
## Basic Usage

Flexbox in Wind mirrors CSS Flexbox behavior but maps to Flutter's `Row` and `Column` widgets. Use `flex` to initialize a flex container, then apply utilities to control direction, alignment, and spacing.

```dart
WDiv(
  className: 'flex flex-col md:flex-row justify-between items-center gap-4 p-6 bg-white',
  children: [
    WText('Logo'),
    WDiv(
      className: 'flex gap-2',
      children: [
        WText('Home'),
        WText('About'),
      ],
    ),
  ],
)
```

<a name="quick-reference"></a>
## Quick Reference

| Class | CSS Equivalent | Flutter Equivalent |
|:------|:---------------|:-------------------|
| `flex` | `display: flex` | `Row` / `Column` |
| `wrap` | `flex-wrap: wrap` | `Wrap` |
| `flex-row` | `flex-direction: row` | `Row()` |
| `flex-col` | `flex-direction: column` | `Column()` |
| `flex-row-reverse` | `flex-direction: row-reverse` | `Row(textDirection: mirrored)` |
| `flex-col-reverse` | `flex-direction: column-reverse` | `Column(verticalDirection: up)` |
| `order-{n}` | `order: {n}` | Stable-sort children before layout |
| `justify-{alignment}` | `justify-content: ...` | `MainAxisAlignment` |
| `items-{alignment}` | `align-items: ...` | `CrossAxisAlignment` |
| `gap-{n}` | `gap: {n}` | `SizedBox` (spacer) |
| `flex-1` | `flex: 1` | `Expanded()` |
| `shrink-0` | `flex-shrink: 0` | No wrapper — preserves intrinsic size |

<a name="flex-direction"></a>
## Flex Direction

Control the axis of your layout.

<x-preview path="layout/flex_basic" size="md" source="example/lib/pages/layout/flex_basic.dart"></x-preview>

```dart
// Row (Horizontal) - Default for 'flex'
WDiv(className: 'flex flex-row')

// Column (Vertical)
WDiv(className: 'flex flex-col')
```

<a name="reversing-direction"></a>
## Reversing Direction

Use `flex-row-reverse` or `flex-col-reverse` to reverse the main-axis direction. Rather than reversing the children list, Wind flips the axis itself (via `Row.textDirection` / `Column.verticalDirection`), so alignment tokens mirror correctly: `justify-start` anchors to what is now the visual end, matching CSS's `flex-direction: *-reverse`. Cross-axis alignment is unaffected.

```dart
WDiv(
  className: 'flex flex-row-reverse gap-2',
  children: [
    WText('First in code'),
    WText('Last in code'),
  ],
)
// Renders as: [Last in code] [First in code]
```

Responsive prefixes work as expected:

```dart
// Column on mobile, row-reverse on md+
WDiv(className: 'flex flex-col md:flex-row-reverse gap-4')
```

<a name="child-order"></a>
## Child Order

Use `order-*` on individual flex children to override their paint order without changing the source order. The parent flex container stable-sorts children by their resolved `order` value before laying them out; children without `order-*` default to `0`.

| Class | Behavior |
|:------|:---------|
| `order-0` .. `order-12` | Explicit index (integers only) |
| `order-first` | Placed before everything else (sentinel `-9999`) |
| `order-last` | Placed after everything else (sentinel `9999`) |
| `order-none` | Resets to `0` |
| `order-[n]` | Arbitrary integer (supports negative, e.g. `order-[-3]`) |

```dart
WDiv(
  className: 'flex',
  children: [
    WDiv(className: 'order-3', child: WText('A')),
    WDiv(className: 'order-1', child: WText('B')),
    WDiv(className: 'order-2', child: WText('C')),
  ],
)
// Visual order: B, C, A
```

Responsive reordering is a common use case — swap the layout per breakpoint without duplicating children:

```dart
WDiv(
  className: 'flex flex-col md:flex-row gap-4',
  children: [
    WDiv(className: 'order-2 md:order-1', child: WText('Sidebar')),
    WDiv(className: 'order-1 md:order-2', child: WText('Main content')),
  ],
)
```

When combined with `flex-*-reverse`, children are sorted by `order-*` first; the container then flips the main-axis direction so `justify-*` still applies against the (now reversed) axis.

<a name="wrapping"></a>
## Wrapping

Use `wrap` to create a wrapping layout (Flutter's `Wrap` widget).

> [!WARNING]
> Flutter's `Row` and `Column` do **not** wrap. You must use the `wrap` class instead of `flex` if you want wrapping behavior.

```dart
// Items wrap to the next line when they run out of space
WDiv(
  className: 'wrap gap-2',
  children: [
    WDiv(className: 'px-2 py-1 bg-gray-200 rounded', child: WText('Tag 1')),
    WDiv(className: 'px-2 py-1 bg-gray-200 rounded', child: WText('Tag 2')),
    // ...
  ],
)
```

<a name="justify-content"></a>
## Justify Content

Controls how children are distributed along the **main axis** (Horizontal for `row`, Vertical for `col`).

| Class | Flutter `MainAxisAlignment` |
|:------|:----------------------------|
| `justify-start` | `start` |
| `justify-end` | `end` |
| `justify-center` | `center` |
| `justify-between` | `spaceBetween` |
| `justify-around` | `spaceAround` |
| `justify-evenly` | `spaceEvenly` |

```dart
WDiv(
  className: 'flex justify-between',
  children: [
    WDiv(className: 'w-10 h-10 bg-red-500'),
    WDiv(className: 'w-10 h-10 bg-blue-500'),
  ],
)
```

<a name="align-items"></a>
## Align Items

Controls how children are distributed along the **cross axis** (Vertical for `row`, Horizontal for `col`).

| Class | Flutter `CrossAxisAlignment` |
|:------|:-----------------------------|
| `items-start` | `start` |
| `items-end` | `end` |
| `items-center` | `center` |
| `items-baseline` | `baseline` |
| `items-stretch` | `stretch` |

```dart
// Vertically center items in a row
WDiv(className: 'flex items-center h-20')
```

<a name="align-content"></a>
## Align Content

Only applicable when using `wrap`. Controls how lines of wrapped content are aligned.

| Class | Flutter `WrapAlignment` |
|:------|:------------------------|
| `align-content-start` | `start` |
| `align-content-end` | `end` |
| `align-content-center` | `center` |
| `align-content-between` | `spaceBetween` |
| `align-content-around` | `spaceAround` |
| `align-content-evenly` | `spaceEvenly` |
| `align-content-stretch` | `start` (Flutter limitation) |

<a name="align-self"></a>
## Align Self

Control alignment of an individual flex item, overriding the container's `items-*` setting.

| Class | Flutter `Alignment` |
|:------|:--------------------|
| `align-self-start` | `topCenter` |
| `align-self-end` | `bottomCenter` |
| `align-self-center` | `center` |
| `align-self-stretch` | `center` |
| `align-self-auto` | `center` |

```dart
WDiv(
  className: 'flex items-start h-20',
  children: [
    WDiv(className: '...'),
    // This item centers itself
    WDiv(className: 'align-self-center ...'),
  ],
)
```

<a name="flex-grow--shrink"></a>
## Flex, Grow & Shrink

Control how individual children resize to fill available space.

| Class | Description |
|:------|:------------|
| `flex-1` | Allow child to grow and fill available space (`Expanded`). |
| `flex-grow` | Alias for `flex-1`. |
| `flex-{n}` | Specific flex factor (e.g., `flex-2`). |
| `shrink` | Allow child to shrink if needed (`FlexFit.loose`). |
| `shrink-0` | Preserve intrinsic size — no Flexible wrapper, child keeps its natural dimensions. |
| `flex-none` | Do not grow or shrink. |

<x-preview path="layout/flex_grow" size="md" source="example/lib/pages/layout/flex_grow.dart"></x-preview>

```dart
WDiv(
  className: 'flex',
  children: [
    // Sidebar: Fixed width, won't shrink
    WDiv(className: 'w-16 shrink-0 bg-gray-200'),
    
    // Content: Fills remaining space
    WDiv(
      className: 'flex-1 bg-white p-4',
      child: WText('Main Content'),
    ),
  ],
)
```

<a name="gap--spacing"></a>
## Gap & Spacing

Wind's `gap` utilities add space between flex or grid items without using margin on the children themselves.

| Class | Value (Default) | Description |
|:------|:----------------|:------------|
| `gap-0` | 0px | No gap |
| `gap-1` | 4px | Small gap |
| `gap-2` | 8px | Medium gap |
| `gap-4` | 16px | Large gap |
| `gap-x-{n}` | - | Horizontal gap only |
| `gap-y-{n}` | - | Vertical gap only |

> [!NOTE]
> `space-x-{n}` and `space-y-{n}` are supported as aliases for `gap`, but `gap` is preferred for consistency with Grid.

```dart
// 16px gap horizontally and vertically
WDiv(className: 'flex gap-4')

// 8px horizontal, 16px vertical
WDiv(className: 'flex flex-col gap-x-2 gap-y-4')
```

<a name="responsive-design"></a>
## Responsive Design

Change layout direction or spacing based on screen size. This is extremely powerful for mobile-first designs.

```dart
// Column on mobile, Row on tablet+
WDiv(className: 'flex flex-col md:flex-row gap-4 md:gap-8')
```

<a name="arbitrary-values"></a>
## Arbitrary Values

Need a specific gap or flex value not in the theme? Use bracket notation.

```dart
// Specific 23px gap
WDiv(className: 'flex gap-[23px]')

// Specific pixel gap
WDiv(className: 'flex gap-[1.5rem]')
```

<a name="customizing-theme"></a>
## Customizing Theme

To change the default spacing scale used by `gap`, modify `baseSpacingUnit` or the `containers` map in `WindThemeData`.

```dart
WindThemeData(
  baseSpacingUnit: 8.0, // Now gap-1 = 8px, gap-2 = 16px
)
```

<a name="flex-and-overflow"></a>
## Flex Children Inside a Scrollable Axis

When a flex container's own main axis is scrollable (`flex-row` with `overflow-x-auto|scroll`, or `flex-col` with `overflow-y-auto|scroll`), Flutter's `Expanded`/`Flexible` cannot resolve — the incoming constraint is unbounded. Wind detects this at resolution time and skips the `Expanded`/`Flexible` wrap for direct flex children in that pass, so `flex-N` becomes a no-op while the axis is scrollable.

This enables the common responsive pattern of "scroll on narrow, distribute on wide":

```dart
WDiv(
  className: 'flex flex-row gap-1 overflow-x-auto sm:overflow-visible',
  children: [
    for (final tab in tabs)
      WDiv(className: 'flex-1', child: _tabBtn(tab)),
  ],
)
```

At `base` the row scrolls horizontally and children keep their intrinsic width. At `sm+` the overflow is removed and `flex-1` distributes width equally. Nested non-scrolling flex subtrees under a scrolling ancestor behave normally.

<a name="related-documentation"></a>
## Related Documentation

- [Grid Layout](./grid.md)
- [Display Modes](./display.md)
- [Sizing](../layout/sizing.md)
