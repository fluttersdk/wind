# Grid Template Columns

Utilities for specifying the columns in a grid layout.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Equal-Height Rows](#equal-height-rows)
- [Responsive](#responsive)
- [Dark Mode](#dark-mode)
- [Arbitrary Values](#arbitrary-values)
- [Related Documentation](#related-documentation)

<x-preview path="layout/grid_cols" size="md" source="example/lib/pages/layout/grid_cols.dart"></x-preview>

```dart
// Basic grid with 3 columns
WDiv(
  className: 'grid grid-cols-3 gap-4',
  children: [
    WDiv(className: 'bg-blue-500 h-12'),
    WDiv(className: 'bg-blue-500 h-12'),
    WDiv(className: 'bg-blue-500 h-12'),
  ],
)
```

<a name="basic-usage"></a>
## Basic Usage

Use `grid-cols-{n}` to create a grid with `n` equally sized columns.

This utility must be used alongside the `grid` class (or `inline-grid` if supported) to activate the grid layout model.

```dart
WDiv(
  className: 'grid grid-cols-4 gap-4',
  children: [
    // ... 4 items per row
  ],
)
```

<a name="quick-reference"></a>
## Quick Reference

| Class | Properties |
|:--- |:--- |
| `grid-cols-1` | `crossAxisCount: 1` |
| `grid-cols-2` | `crossAxisCount: 2` |
| `grid-cols-3` | `crossAxisCount: 3` |
| `grid-cols-4` | `crossAxisCount: 4` |
| `grid-cols-5` | `crossAxisCount: 5` |
| `grid-cols-6` | `crossAxisCount: 6` |
| `grid-cols-12` | `crossAxisCount: 12` |

> [!NOTE]
> Wind's parser supports **any integer** value for `grid-cols-{n}`, not just the standard Tailwind scale (1-12).

<a name="equal-height-rows"></a>
## Equal-Height Rows

By default a Wind grid sizes each cell to its own content (it renders as a `Wrap`), so a row where one card is taller leaves the others short. Add `items-stretch` to make every cell in a row match the tallest, mirroring CSS Grid's default `align-items: stretch`. With `items-stretch` the grid renders as a column of equal-height rows instead of a `Wrap`.

```dart
// KPI stat cards that all share the tallest card's height per row
WDiv(
  className: 'grid grid-cols-3 gap-4 items-stretch',
  children: [
    WDiv(
      className: 'p-4 rounded-lg bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700',
      children: [
        WText('Revenue', className: 'text-sm text-gray-500 dark:text-gray-400'),
        WText('\$12,480', className: 'text-2xl font-bold text-gray-900 dark:text-white'),
        WText('+8% vs last week', className: 'text-xs text-green-600 dark:text-green-400'),
      ],
    ),
    // ...sibling cards stretch to match the tallest
  ],
)
```

The equal-height rows are laid out for real (each cell is measured with a loose height, then re-laid to at least the row's tallest via a **min** height, never a tight squeeze), NOT via `IntrinsicHeight`, so cells whose content is itself a `flex flex-col`, or that use `h-full` / `basis-*` (which carry a `LayoutBuilder`), stretch correctly instead of asserting `LayoutBuilder does not support returning intrinsic dimensions`. Because a cell is never forced below its own content height, a stretched cell also produces no residual `RenderFlex overflowed` warning (#141).

<a name="responsive"></a>
## Responsive

Prefix grid utilities with breakpoint variants like `md:` or `lg:` to change the column count at different screen sizes.

<x-preview path="layout/grid_responsive" size="lg" source="example/lib/pages/layout/grid_responsive.dart"></x-preview>

```dart
WDiv(
  className: 'grid grid-cols-1 md:grid-cols-3 lg:grid-cols-6 gap-4',
  children: [
    // 1 col on mobile, 3 on tablet, 6 on desktop
  ],
)
```

<a name="dark-mode"></a>
## Dark Mode

While column counts rarely change based on theme, you can use `dark:` if needed.

```dart
WDiv(
  className: 'grid grid-cols-2 dark:grid-cols-4',
  children: [...],
)
```

<a name="arbitrary-values"></a>
## Arbitrary Values

Wind supports any integer for grid columns directly in the utility class. You do not need square brackets `[]` for this property.

```dart
// Create a grid with exactly 16 columns
WDiv(
  className: 'grid grid-cols-16 gap-1',
  children: [...],
)
```

<a name="related-documentation"></a>
## Related Documentation

- [Flexbox & Gap](./flexbox.md) - For `gap-{n}`, `gap-x-{n}`, and `gap-y-{n}` utilities.
- [Display](./display.md) - For the `grid` class.
