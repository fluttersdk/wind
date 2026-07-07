# Positioning

Utilities for controlling how elements are positioned in the layout using `relative` and `absolute` placement.

- [Position Types](#position-types)
- [Offset Utilities](#offset-utilities)
- [Inset Shortcuts](#inset-shortcuts)
- [Negative Offsets](#negative-offsets)
- [Arbitrary Values](#arbitrary-values)
- [Common Patterns](#common-patterns)
- [Combining with Flex](#combining-with-flex)
- [Future Work](#future-work)
- [Related Documentation](#related-documentation)

<x-preview path="layout/positioning" size="lg" source="example/lib/pages/layout/positioning.dart"></x-preview>

```dart
// Badge overlay: red dot on an avatar
WDiv(
  className: 'relative',
  children: [
    WDiv(className: 'w-12 h-12 rounded-full bg-gray-300'),
    WDiv(className: 'absolute top-0 right-0 w-3 h-3 rounded-full bg-red-500'),
  ],
)
```

<a name="position-types"></a>
## Position Types

Wind maps CSS `position` values to Flutter's `Stack` widget. A `relative` parent establishes a stacking context; `absolute` children are placed inside it using offset utilities.

| Wind className | CSS Equivalent | Flutter Widget |
|:---------------|:---------------|:---------------|
| `relative` | `position: relative` | `Stack` (parent) |
| `absolute` | `position: absolute` | `Positioned` (child inside `Stack`) |

> [!NOTE]
> An `absolute` child must live inside a `relative` parent. Wind will wrap the `relative` container in a `Stack` and each `absolute` child in a `Positioned` widget automatically.

```dart
WDiv(
  className: 'relative w-32 h-32 bg-gray-100',
  children: [
    WDiv(className: 'absolute top-2 left-2 w-8 h-8 bg-blue-500'),
  ],
)
```

<a name="offset-utilities"></a>
## Offset Utilities

Control the position of `absolute` children using directional offset classes. Values follow the spacing scale (`spacing * n`).

| Class | CSS Equivalent | Description |
|:------|:---------------|:------------|
| `top-{n}` | `top: {n}` | Distance from the top edge |
| `right-{n}` | `right: {n}` | Distance from the right edge |
| `bottom-{n}` | `bottom: {n}` | Distance from the bottom edge |
| `left-{n}` | `left: {n}` | Distance from the left edge |

Default spacing scale (base unit = 4px):

| Class | Value |
|:------|:------|
| `top-0` | 0px |
| `top-1` | 4px |
| `top-2` | 8px |
| `top-4` | 16px |
| `top-6` | 24px |
| `top-8` | 32px |

The same scale applies to `right-*`, `bottom-*`, and `left-*`.

```dart
WDiv(
  className: 'relative h-48 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-lg',
  children: [
    WDiv(
      className: 'absolute bottom-4 right-4 px-3 py-2 bg-blue-600 rounded',
      child: WText('Action', className: 'text-sm text-white'),
    ),
  ],
)
```

<a name="inset-shortcuts"></a>
## Inset Shortcuts

Apply offsets to multiple sides at once with `inset-*` shorthand classes.

| Class | Sides Affected | Description |
|:------|:---------------|:------------|
| `inset-{n}` | top, right, bottom, left | All four sides |
| `inset-x-{n}` | left, right | Horizontal sides only |
| `inset-y-{n}` | top, bottom | Vertical sides only |
| `inset-0` | top, right, bottom, left | Full stretch (fills parent) |

```dart
// Full overlay: covers the entire relative parent
WDiv(
  className: 'relative w-full h-48',
  children: [
    WImage(src: 'assets/photo.jpg', className: 'w-full h-full'),
    // Semi-transparent overlay that fills the image
    WDiv(
      className: 'absolute inset-0 bg-black opacity-40',
    ),
    WText(
      'Caption',
      className: 'absolute bottom-4 left-4 text-white font-semibold',
    ),
  ],
)
```

```dart
// Horizontal inset: leaves top and bottom unconstrained
WDiv(
  className: 'absolute inset-x-4 bottom-4 bg-white rounded p-3',
  child: WText('Bottom bar'),
)
```

<a name="negative-offsets"></a>
## Negative Offsets

Prefix any offset class with `-` to pull an element outside its parent's boundary.

| Class | Value | Description |
|:------|:------|:------------|
| `-top-{n}` | negative top | Pulls element above the parent |
| `-right-{n}` | negative right | Pulls element to the right of the parent |
| `-bottom-{n}` | negative bottom | Pulls element below the parent |
| `-left-{n}` | negative left | Pulls element to the left of the parent |
| `-inset-{n}` | negative all sides | Expands element beyond all four parent edges |

```dart
// Notification badge: overlaps the top-right corner of an icon button
WDiv(
  className: 'relative',
  children: [
    WDiv(className: 'w-10 h-10 rounded bg-gray-200 flex items-center justify-center'),
    WDiv(
      className: 'absolute -top-1 -right-1 w-4 h-4 rounded-full bg-red-500 flex items-center justify-center',
      child: WText('3', className: 'text-[10px] text-white font-bold'),
    ),
  ],
)
```

<a name="arbitrary-values"></a>
## Arbitrary Values

Use bracket notation when you need an exact pixel value not in the theme scale. Only `px` values are supported; percentage (`%`) offsets are not supported because Flutter's `Positioned` widget uses logical pixels, not relative units.

```dart
// Exact pixel value
WDiv(className: 'absolute top-[24px] left-[12px]')

// Mixed: precise multi-side offset
WDiv(className: 'absolute top-[12px] right-[8px] bottom-[12px] left-[8px]')
```

<a name="common-patterns"></a>
## Common Patterns

### Badge Overlay

A notification dot positioned on top of an avatar or icon.

```dart
WDiv(
  className: 'relative w-12 h-12',
  children: [
    WDiv(className: 'w-12 h-12 rounded-full bg-indigo-500'),
    WDiv(
      className: 'absolute -top-1 -right-1 w-5 h-5 rounded-full bg-red-500 border-2 border-white flex items-center justify-center',
      child: WText('2', className: 'text-[9px] text-white font-bold'),
    ),
  ],
)
```

### Floating Action Button (FAB)

An action button pinned to the bottom-right corner of a scrollable view.

```dart
WDiv(
  className: 'relative flex-1',
  children: [
    WDiv(
      className: 'w-full h-full overflow-y-auto p-4',
      child: WText('Scrollable content...'),
    ),
    WDiv(
      className: 'absolute bottom-6 right-6 w-14 h-14 rounded-full bg-blue-600 flex items-center justify-center shadow-lg',
      child: WIcon(Icons.add_outlined, className: 'text-white'),
    ),
  ],
)
```

### Full Overlay

A semi-transparent scrim that covers an entire card or image.

```dart
WDiv(
  className: 'relative rounded-xl overflow-hidden',
  children: [
    WImage(src: 'assets/hero.jpg', className: 'w-full h-48 object-cover'),
    WDiv(className: 'absolute inset-0 bg-gradient-to-t from-black/60 to-transparent'),
    WDiv(
      className: 'absolute bottom-0 left-0 right-0 p-4',
      child: WText('Hero Title', className: 'text-white text-lg font-bold'),
    ),
  ],
)
```

<a name="combining-with-flex"></a>
## Combining with Flex

`relative` and `absolute` compose naturally with flex layouts. The `relative` container itself can be a flex row or column; the `Stack` wraps around the flex widget, and `absolute` children are layered on top.

```dart
// Navigation bar with an absolute badge on the icon
WDiv(
  className: 'flex flex-row items-center justify-between px-4 py-3 bg-white dark:bg-gray-800 border-b border-gray-200 dark:border-gray-700',
  children: [
    WText('Inbox', className: 'text-base font-semibold text-gray-900 dark:text-gray-100'),
    WDiv(
      className: 'relative',
      children: [
        WIcon(Icons.notifications_outlined, className: 'text-gray-700 dark:text-gray-300'),
        WDiv(
          className: 'absolute -top-1 -right-1 w-4 h-4 rounded-full bg-red-500',
        ),
      ],
    ),
  ],
)
```

> [!NOTE]
> When you add `absolute` children to a flex item, Wind promotes that item to a `Stack`. The flex layout of the parent is preserved.

<a name="future-work"></a>
## Future Work

The following position types are tracked but not yet implemented in v1:

| Class | Status |
|:------|:-------|
| `fixed` | Deferred: maps to Flutter's `Overlay`/`Stack` at the root level |
| `sticky` | Deferred: requires custom `SliverPersistentHeader` integration |

Until these land, use `Overlay` directly or Flutter's `Stack` at the `Scaffold` body level for fixed positioning.

<a name="related-documentation"></a>
## Related Documentation

- [Flexbox & Layout](./flexbox.md)
- [Grid Layout](./grid.md)
- [Sizing](../layout/sizing.md)
- [Spacing](../layout/spacing.md)
