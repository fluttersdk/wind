# Flexbox

Utilities for creating flexible layouts using CSS Flexbox concepts in Flutter.

## Flex Direction & Wrap

Control how flex items are arranged and whether they wrap.

<x-preview path="layout/flex_basic" size="md" source="example/lib/pages/layout/flex_basic.dart"></x-preview>

```dart
// Flex Row (default - items arranged horizontally)
WDiv(
  className: 'flex gap-2 p-4 bg-gray-100 rounded-lg',
  children: [
    WDiv(className: 'w-12 h-12 bg-blue-500 rounded-lg'),
    WDiv(className: 'w-12 h-12 bg-blue-500 rounded-lg'),
    WDiv(className: 'w-12 h-12 bg-blue-500 rounded-lg'),
  ],
)

// Flex Column (items arranged vertically)
WDiv(
  className: 'flex flex-col gap-2 p-4 bg-gray-100 rounded-lg',
  children: [
    WDiv(className: 'w-12 h-12 bg-green-500 rounded-lg'),
    WDiv(className: 'w-12 h-12 bg-green-500 rounded-lg'),
    WDiv(className: 'w-12 h-12 bg-green-500 rounded-lg'),
  ],
)

// Flex Wrap (items wrap to next line)
WDiv(
  className: 'flex flex-wrap gap-2 p-4 bg-gray-100 rounded-lg',
  children: [
    WDiv(className: 'w-12 h-12 bg-purple-500 rounded-lg'),
    WDiv(className: 'w-12 h-12 bg-purple-500 rounded-lg'),
    // ... more items wrap automatically
  ],
)
```

| Class | Description |
| :--- | :--- |
| `flex` | Enable flex layout (Row by default) |
| `flex-row` | Arrange items horizontally |
| `flex-col` | Arrange items vertically |
| `flex-wrap` | Allow items to wrap to next line |
| `flex-nowrap` | Prevent wrapping (default) |

## Flex Grow & Shrink

Control how flex items grow and shrink to fill available space.

<x-preview path="layout/flex_grow" size="md" source="example/lib/pages/layout/flex_grow.dart"></x-preview>

```dart
// flex-1: Item grows to fill available space
WDiv(
  className: 'flex gap-2',
  children: [
    WDiv(className: 'flex-none w-16 h-12 bg-blue-500'),  // Fixed size
    WDiv(className: 'flex-1 h-12 bg-purple-500'),         // Grows to fill
    WDiv(className: 'flex-none w-16 h-12 bg-blue-500'),  // Fixed size
  ],
)

// Multiple flex-1: Items share space equally
WDiv(
  className: 'flex gap-2',
  children: [
    WDiv(className: 'flex-1 h-12 bg-emerald-500'),
    WDiv(className: 'flex-1 h-12 bg-emerald-500'),
    WDiv(className: 'flex-1 h-12 bg-emerald-500'),
  ],
)
```

| Class | Description |
| :--- | :--- |
| `flex-1` | Grow and shrink, ignoring initial size |
| `flex-auto` | Grow and shrink, considering initial size |
| `flex-initial` | Shrink but don't grow |
| `flex-none` | Don't grow or shrink |
| `flex-grow` | Allow item to grow |
| `flex-grow-0` | Prevent item from growing |
| `shrink` | Allow shrinking (FlexFit.loose) |
| `shrink-0` | Prevent shrinking (FlexFit.tight) |

## Main Axis Size

Control how the flex container sizes along the main axis:

| Class | Description |
| :--- | :--- |
| `axis-min` | Shrink to fit content (MainAxisSize.min) |
| `axis-max` | Expand to fill space (MainAxisSize.max) |

## Align Self

Control alignment of individual flex items:

| Class | Description |
| :--- | :--- |
| `align-self-start` | Align self to start |
| `align-self-center` | Align self to center |
| `align-self-end` | Align self to end |

## Justify Content

Control how items are positioned along the **main axis** (horizontal for row, vertical for column).

<x-preview path="layout/flex_justify" size="md" source="example/lib/pages/layout/flex_justify.dart"></x-preview>

```dart
// justify-start: Pack items at start
WDiv(
  className: 'flex justify-start gap-2 p-4 bg-gray-100',
  children: [Box(), Box(), Box()],
)

// justify-center: Pack items at center
WDiv(
  className: 'flex justify-center gap-2 p-4 bg-gray-100',
  children: [Box(), Box(), Box()],
)

// justify-between: Distribute with space between
WDiv(
  className: 'flex justify-between p-4 bg-gray-100',
  children: [Box(), Box(), Box()],
)

// justify-around: Distribute with space around
WDiv(
  className: 'flex justify-around p-4 bg-gray-100',
  children: [Box(), Box(), Box()],
)

// justify-evenly: Distribute with equal space
WDiv(
  className: 'flex justify-evenly p-4 bg-gray-100',
  children: [Box(), Box(), Box()],
)
```

| Class | Description |
| :--- | :--- |
| `justify-start` | Pack items at start |
| `justify-end` | Pack items at end |
| `justify-center` | Pack items at center |
| `justify-between` | Distribute with space between |
| `justify-around` | Distribute with space around |
| `justify-evenly` | Distribute with equal space |

## Align Items

Control how items are positioned along the **cross axis** (vertical for row, horizontal for column).

<x-preview path="layout/flex_align" size="md" source="example/lib/pages/layout/flex_align.dart"></x-preview>

```dart
// items-start: Align items to start
WDiv(
  className: 'flex items-start gap-2 h-24 p-4 bg-gray-100',
  children: [
    WDiv(className: 'w-12 h-8 bg-amber-500'),
    WDiv(className: 'w-12 h-12 bg-amber-500'),
    WDiv(className: 'w-12 h-6 bg-amber-500'),
  ],
)

// items-center: Center items vertically
WDiv(
  className: 'flex items-center gap-2 h-24 p-4 bg-gray-100',
  children: [
    WDiv(className: 'w-12 h-8 bg-amber-500'),
    WDiv(className: 'w-12 h-12 bg-amber-500'),
    WDiv(className: 'w-12 h-6 bg-amber-500'),
  ],
)

// items-stretch: Stretch to fill container height
WDiv(
  className: 'flex items-stretch gap-2 h-24 p-4 bg-gray-100',
  children: [
    WDiv(className: 'w-12 bg-amber-500'),
    WDiv(className: 'w-12 bg-amber-500'),
    WDiv(className: 'w-12 bg-amber-500'),
  ],
)
```

| Class | Description |
| :--- | :--- |
| `items-start` | Align items to start |
| `items-end` | Align items to end |
| `items-center` | Center items |
| `items-baseline` | Align to text baseline |
| `items-stretch` | Stretch to fill container |

## Gap

Control spacing between flex items.

```dart
WDiv(
  className: 'flex gap-4',  // 16px gap between all items
  children: [...],
)

WDiv(
  className: 'flex gap-x-4 gap-y-2',  // Different horizontal/vertical gaps
  children: [...],
)
```

| Class | Description |
| :--- | :--- |
| `gap-{n}` | Gap on all sides (n × 4px) |
| `gap-x-{n}` | Horizontal gap only |
| `gap-y-{n}` | Vertical gap only |

## Common Patterns

### Centering Content

```dart
WDiv(
  className: 'flex items-center justify-center h-64',
  child: WText('Perfectly Centered'),
)
```

### Header with Logo and Nav

```dart
WDiv(
  className: 'flex justify-between items-center p-4',
  children: [
    WText('Logo', className: 'font-bold'),
    WDiv(
      className: 'flex gap-4',
      children: [
        WText('Home'),
        WText('About'),
        WText('Contact'),
      ],
    ),
  ],
)
```

### Sidebar Layout

```dart
WDiv(
  className: 'flex h-screen',
  children: [
    WDiv(className: 'flex-none w-64 bg-slate-800'),  // Fixed sidebar
    WDiv(className: 'flex-1 bg-white'),               // Flexible content
  ],
)
```

## Related Documentation

- [Grid](./grid.md) - Grid layout utilities
- [Spacing](./spacing.md) - Padding and margin
- [Responsive Design](../core-concepts/responsive-design.md) - Responsive flex layouts
