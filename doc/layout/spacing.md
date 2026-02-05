# Spacing

Utilities for controlling padding and margin.

## Padding

Control inner spacing of elements.

<x-preview path="spacing/padding" size="md" source="example/lib/pages/spacing/padding.dart"></x-preview>

### All Sides

```dart
WDiv(className: 'p-2 bg-rose-500')  // 8px all sides
WDiv(className: 'p-4 bg-rose-500')  // 16px all sides
WDiv(className: 'p-6 bg-pink-500')  // 24px all sides
```

### Axis Padding

```dart
WDiv(className: 'px-6 py-1 bg-purple-500')  // Horizontal padding
WDiv(className: 'py-6 px-2 bg-violet-500')  // Vertical padding
```

### Individual Sides

```dart
WDiv(className: 'pt-4 bg-indigo-500')  // Top only
WDiv(className: 'pb-4 bg-blue-500')    // Bottom only
WDiv(className: 'pl-6 bg-cyan-500')    // Left only
WDiv(className: 'pr-6 bg-teal-500')    // Right only
```

| Class | Description |
| :--- | :--- |
| `p-{n}` | All sides |
| `px-{n}` | Left and right |
| `py-{n}` | Top and bottom |
| `pt-{n}` | Top only |
| `pr-{n}` | Right only |
| `pb-{n}` | Bottom only |
| `pl-{n}` | Left only |

## Margin

Control outer spacing of elements.

<x-preview path="spacing/margin" size="md" source="example/lib/pages/spacing/margin.dart"></x-preview>

### All Sides

```dart
WDiv(className: 'm-2 bg-amber-500')  // 8px all sides
WDiv(className: 'm-4 bg-amber-500')  // 16px all sides
```

### Axis Margin

```dart
WDiv(className: 'mx-6 bg-orange-500')  // Horizontal margin
WDiv(className: 'my-4 bg-red-500')     // Vertical margin
```

### Horizontal Centering

Use `mx-auto` to center an element horizontally:

```dart
WDiv(
  className: 'mx-auto w-32 bg-emerald-500',
  child: WText('Centered'),
)
```

| Class | Description |
| :--- | :--- |
| `m-{n}` | All sides |
| `mx-{n}` | Left and right |
| `my-{n}` | Top and bottom |
| `mt-{n}` | Top only |
| `mr-{n}` | Right only |
| `mb-{n}` | Bottom only |
| `ml-{n}` | Left only |
| `mx-auto` | Horizontally center element |

## Spacing Scale

| Value | Size |
| :--- | :--- |
| `0` | 0px |
| `1` | 4px |
| `2` | 8px |
| `3` | 12px |
| `4` | 16px |
| `5` | 20px |
| `6` | 24px |
| `8` | 32px |
| `10` | 40px |
| `12` | 48px |

## Arbitrary Values

Use square brackets for exact pixel values:

```dart
WDiv(className: 'p-[10px] bg-amber-500')   // Exact 10px
WDiv(className: 'mt-[20px] bg-orange-500') // Exact 20px margin-top
```

## Customizing Theme

### Base Spacing Unit

Wind uses a grid system divisible by 4. Customize in `WindThemeData`:

```dart
WindThemeData(
  baseSpacingUnit: 8.0, // Now 'p-1' is 8px, 'p-4' is 32px
)
```

This affects all utilities using the spacing scale:

- Padding (`p-*`)
- Margin (`m-*`)
- Width (`w-*`, except percentages)
- Height (`h-*`, except percentages)
- Gap (`gap-*`)

## Space Between Items

Aliases for gap utilities in flex/grid layouts:

```dart
// Horizontal spacing between children
WDiv(
  className: 'flex space-x-4',
  children: [...],
)

// Vertical spacing between children
WDiv(
  className: 'flex flex-col space-y-2',
  children: [...],
)
```

| Class | Description |
| :--- | :--- |
| `space-x-{n}` | Horizontal gap (alias for `gap-x-{n}`) |
| `space-y-{n}` | Vertical gap (alias for `gap-y-{n}`) |

## Related Documentation

- [Sizing](./sizing.md) - Width and height
- [Flexbox](./flexbox.md) - Gap utilities in flex layouts
- [Grid](./grid.md) - Gap utilities in grid layouts
