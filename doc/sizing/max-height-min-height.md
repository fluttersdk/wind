# Max-Height and Min-Height

Constrain the maximum and minimum heights of widgets using the `max-h-*` and `min-h-*` utilities. Supports pixel-based, percentage-based, and viewport-relative values.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [How Values Are Calculated](#how-values-are-calculated)
- [Arbitrary Values](#arbitrary-values)
- [Responsive Design](#responsive-design)
- [Related Documentation](#related-documentation)

```dart
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

WContainer(
  className: 'max-h-[200] bg-blue-500 dark:bg-blue-700',
  child: WText('Max height: 200px'),
)

WContainer(
  className: 'min-h-[100] bg-orange-500 dark:bg-orange-700',
  child: WText('Min height: 100px'),
)
```

<a name="basic-usage"></a>
## Basic Usage

Use `max-h-*` to prevent a widget from growing beyond a certain height. Use `min-h-*` to ensure it never shrinks below a minimum. Both accept the same value forms as the `h-*` utilities.

```dart
WContainer(
  className: 'max-h-16 bg-blue-500 dark:bg-blue-700',
  child: WText('Max height: 64px'), // 16 * 4 (Pixel Factor)
)

WContainer(
  className: 'min-h-10 bg-yellow-500 dark:bg-yellow-700',
  child: WText('Min height: 40px'), // 10 * 4 (Pixel Factor)
)
```

<a name="quick-reference"></a>
## Quick Reference

### Max-Height

| Class | Description | Example |
|:------|:------------|:--------|
| `max-h-{value}` | Maximum height in pixels (scaled by Pixel Factor) | `max-h-20` |
| `max-h-[{value}]` | Arbitrary maximum height in pixels | `max-h-[200]` |
| `max-h-full` | 100% of the parent's height | `max-h-full` |
| `max-h-screen` | 100% of the viewport height | `max-h-screen` |
| `max-h-{x}/{y}` | Percentage of the parent's height | `max-h-1/2` |
| `max-h-[{value}vh]` | Percentage of the viewport height | `max-h-[90vh]` |

### Min-Height

| Class | Description | Example |
|:------|:------------|:--------|
| `min-h-{value}` | Minimum height in pixels (scaled by Pixel Factor) | `min-h-20` |
| `min-h-[{value}]` | Arbitrary minimum height in pixels | `min-h-[200]` |
| `min-h-full` | 100% of the parent's height | `min-h-full` |
| `min-h-screen` | 100% of the viewport height | `min-h-screen` |
| `min-h-{x}/{y}` | Percentage of the parent's height | `min-h-1/2` |
| `min-h-[{value}vh]` | Percentage of the viewport height | `min-h-[90vh]` |

<a name="how-values-are-calculated"></a>
## How Values Are Calculated

### Predefined Sizes

Values are multiplied by the Pixel Factor.

- Example: `max-h-16` → 16 × 4 (Pixel Factor) = **64px**.
- Example: `min-h-10` → 10 × 4 (Pixel Factor) = **40px**.

### Special Keywords

| Value | Result |
|:------|:-------|
| `full` | `double.infinity` (100% of parent) |
| `screen` | Viewport height via `MediaQuery` |

### Fraction Syntax

Use `max-h-x/y` or `min-h-x/y` to express a fraction of the parent height.

- Example: `max-h-3/4` → 75% of the parent's height.

### Viewport Height

Append `vh` inside brackets for a percentage of the viewport.

- Example: `max-h-[90vh]` → 90% of the viewport height.

<a name="arbitrary-values"></a>
## Arbitrary Values

Use bracket notation for an exact pixel value, bypassing the Pixel Factor.

```dart
WContainer(
  className: 'max-h-[400] min-h-[100] bg-gray-200 dark:bg-gray-700',
  child: WText('Height stays between 100px and 400px.'),
)
```

<a name="responsive-design"></a>
## Responsive Design

Combine max/min height with breakpoint prefixes for responsive constraints.

```dart
WContainer(
  className: 'max-h-[300] md:max-h-[500] lg:max-h-screen bg-blue-500 dark:bg-blue-700',
  child: WText('Responsive max-height.'),
)
```

Available breakpoints: `sm`, `md`, `lg`, `xl`, `2xl`.

<a name="related-documentation"></a>
## Related Documentation

- [Height](./height.md) — control widget height directly.
- [Max-Width and Min-Width](./max-width-min-width.md) — constrain width bounds.
- [Width](./width.md) — control widget width directly.
- [Pixel Factor](../customization/pixel-factor.md) — configure the base unit.
- [WContainer](../widgets/wcontainer.md) — the primary container widget.
