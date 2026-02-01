# Grid System

Utilities for creating grid layouts with automatic wrapping and gap control.

## Grid Template Columns

Use `grid-cols-{n}` to create a grid with a specific number of columns.

<x-preview path="layout/grid_cols" size="md" source="example/lib/pages/layout/grid_cols.dart"></x-preview>

```dart
// 2 Column Grid
WDiv(
  className: 'grid grid-cols-2 gap-2',
  children: [
    WDiv(className: 'bg-rose-500 h-12 rounded-lg'),
    WDiv(className: 'bg-rose-500 h-12 rounded-lg'),
    WDiv(className: 'bg-rose-500 h-12 rounded-lg'),
    WDiv(className: 'bg-rose-500 h-12 rounded-lg'),
  ],
)

// 3 Column Grid
WDiv(
  className: 'grid grid-cols-3 gap-2',
  children: List.generate(6, (i) => 
    WDiv(className: 'bg-pink-500 h-12 rounded-lg'),
  ),
)

// 4 Column Grid
WDiv(
  className: 'grid grid-cols-4 gap-2',
  children: List.generate(8, (i) => 
    WDiv(className: 'bg-fuchsia-500 h-12 rounded-lg'),
  ),
)
```

| Class | Description |
| :--- | :--- |
| `grid` | Enable grid layout |
| `grid-cols-1` | 1 column |
| `grid-cols-2` | 2 columns |
| `grid-cols-3` | 3 columns |
| `grid-cols-4` | 4 columns |
| `grid-cols-{n}` | n columns (1-12) |

## Gap

Control spacing between grid items using gap utilities.

<x-preview path="layout/grid_gap" size="md" source="example/lib/pages/layout/grid_gap.dart"></x-preview>

```dart
// Uniform gap (16px)
WDiv(
  className: 'grid grid-cols-3 gap-4',
  children: [...],
)

// Different horizontal/vertical gaps
WDiv(
  className: 'grid grid-cols-3 gap-x-4 gap-y-2',
  children: [...],
)
```

| Class | Description |
| :--- | :--- |
| `gap-{n}` | Gap on all sides (n × 4px) |
| `gap-x-{n}` | Horizontal gap only |
| `gap-y-{n}` | Vertical gap only |

### Gap Scale

| Class | Size |
| :--- | :--- |
| `gap-0` | 0px |
| `gap-1` | 4px |
| `gap-2` | 8px |
| `gap-3` | 12px |
| `gap-4` | 16px |
| `gap-6` | 24px |
| `gap-8` | 32px |

## Responsive Grid

Combine grid with responsive prefixes for adaptive layouts.

<x-preview path="layout/grid_responsive" size="lg" source="example/lib/pages/layout/grid_responsive.dart"></x-preview>

```dart
WDiv(
  className: '''
    grid gap-4
    grid-cols-1
    sm:grid-cols-2
    lg:grid-cols-3
    xl:grid-cols-4
  ''',
  children: products.map((p) => ProductCard(product: p)).toList(),
)
```

## Common Patterns

### Photo Gallery

```dart
WDiv(
  className: 'grid grid-cols-3 gap-2',
  children: images.map((img) => WImage(
    src: img.url,
    className: 'aspect-square object-cover rounded-lg',
  )).toList(),
)
```

### Dashboard Cards

```dart
WDiv(
  className: 'grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4',
  children: [
    StatCard(title: 'Users', value: '1,234'),
    StatCard(title: 'Revenue', value: '\$5,678'),
    StatCard(title: 'Orders', value: '890'),
    StatCard(title: 'Visitors', value: '12,345'),
  ],
)
```

### Form Layout

```dart
WDiv(
  className: 'grid grid-cols-2 gap-4',
  children: [
    WInput(label: 'First Name'),
    WInput(label: 'Last Name'),
    WInput(label: 'Email', className: 'col-span-2'),
  ],
)
```

## Related Documentation

- [Flexbox](./flexbox.md) - Flexible layouts
- [Spacing](./spacing.md) - Padding and margin
- [Responsive Design](../core-concepts/responsive-design.md) - Responsive grids
