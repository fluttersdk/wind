# Max-Width and Min-Width

Constrain the maximum and minimum widths of widgets using the `max-w-*` and `min-w-*` utilities. Supports pixel-based, percentage-based, and viewport-relative values.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [How Values Are Calculated](#how-values-are-calculated)
- [Arbitrary Values](#arbitrary-values)
- [Responsive Design](#responsive-design)
- [Related Documentation](#related-documentation)

```dart
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

WContainer(
  className: 'max-w-[300] bg-purple-500 dark:bg-purple-700',
  child: WText('Max width: 300px'),
)

WContainer(
  className: 'min-w-[100] bg-orange-500 dark:bg-orange-700',
  child: WText('Min width: 100px'),
)
```

<a name="basic-usage"></a>
## Basic Usage

Use `max-w-*` to prevent a widget from growing beyond a certain width. Use `min-w-*` to ensure it never shrinks below a minimum. Both accept the same value forms as the `w-*` utilities.

```dart
WContainer(
  className: 'max-w-10 bg-purple-500 dark:bg-purple-700',
  child: WText('Max width: 40px'), // 10 * 4 (Pixel Factor)
)

WContainer(
  className: 'min-w-12 bg-yellow-500 dark:bg-yellow-700',
  child: WText('Min width: 48px'), // 12 * 4 (Pixel Factor)
)
```

<a name="quick-reference"></a>
## Quick Reference

### Max-Width

| Class | Description | Example |
|:------|:------------|:--------|
| `max-w-{value}` | Maximum width in pixels (scaled by Pixel Factor) | `max-w-20` |
| `max-w-[{value}]` | Arbitrary maximum width in pixels | `max-w-[300]` |
| `max-w-full` | 100% of the parent's width | `max-w-full` |
| `max-w-screen` | 100% of the viewport width | `max-w-screen` |
| `max-w-{x}/{y}` | Percentage of the parent's width | `max-w-1/2` |
| `max-w-[{value}vw]` | Percentage of the viewport width | `max-w-[80vw]` |

### Min-Width

| Class | Description | Example |
|:------|:------------|:--------|
| `min-w-{value}` | Minimum width in pixels (scaled by Pixel Factor) | `min-w-20` |
| `min-w-[{value}]` | Arbitrary minimum width in pixels | `min-w-[300]` |
| `min-w-full` | 100% of the parent's width | `min-w-full` |
| `min-w-screen` | 100% of the viewport width | `min-w-screen` |
| `min-w-{x}/{y}` | Percentage of the parent's width | `min-w-1/2` |
| `min-w-[{value}vw]` | Percentage of the viewport width | `min-w-[80vw]` |

<a name="how-values-are-calculated"></a>
## How Values Are Calculated

### Predefined Sizes

Values are multiplied by the Pixel Factor.

- Example: `max-w-20` → 20 × 4 (Pixel Factor) = **80px**.
- Example: `min-w-12` → 12 × 4 (Pixel Factor) = **48px**.

### Special Keywords

| Value | Result |
|:------|:-------|
| `full` | `double.infinity` (100% of parent) |
| `screen` | Viewport width via `MediaQuery` |

### Fraction Syntax

Use `max-w-x/y` or `min-w-x/y` to express a fraction of the parent width.

- Example: `max-w-3/4` → 75% of the parent's width.

### Viewport Width

Append `vw` inside brackets for a percentage of the viewport.

- Example: `max-w-[80vw]` → 80% of the viewport width.

<a name="arbitrary-values"></a>
## Arbitrary Values

Use bracket notation for an exact pixel value, bypassing the Pixel Factor.

```dart
WContainer(
  className: 'max-w-[600] min-w-[200] bg-gray-200 dark:bg-gray-700',
  child: WText('Width stays between 200px and 600px.'),
)
```

<a name="responsive-design"></a>
## Responsive Design

Combine max/min width with breakpoint prefixes for responsive constraints.

```dart
WContainer(
  className: 'max-w-full md:max-w-[600] lg:max-w-[800] bg-blue-500 dark:bg-blue-700',
  child: WText('Responsive max-width.'),
)
```

Available breakpoints: `sm`, `md`, `lg`, `xl`, `2xl`.

<a name="related-documentation"></a>
## Related Documentation

- [Width](./width.md) — control widget width directly.
- [Max-Height and Min-Height](./max-height-min-height.md) — constrain height bounds.
- [Height](./height.md) — control widget height directly.
- [Pixel Factor](../customization/pixel-factor.md) — configure the base unit.
- [WContainer](../widgets/wcontainer.md) — the primary container widget.
