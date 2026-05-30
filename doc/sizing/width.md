# Width

Control the width of widgets using the `w-*` utilities. Supports pixel-based, percentage-based, and viewport-relative values.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [How Values Are Calculated](#how-values-are-calculated)
- [Arbitrary Values](#arbitrary-values)
- [Responsive Design](#responsive-design)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<x-preview path="sizing/width" size="md" source="example/lib/pages/sizing/width.dart"></x-preview>

```dart
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

WContainer(
  className: 'w-12 bg-blue-500 dark:bg-blue-700',
  child: WText('Width is 48px'), // 12 * 4 (Pixel Factor)
)
```

<a name="basic-usage"></a>
## Basic Usage

Set the width of any `WContainer` by adding a `w-*` class. The predefined value is multiplied by the Pixel Factor (default 4), so `w-12` produces 48px. Use `w-full` for 100% of the parent's width or `w-[value]` for an exact pixel value.

```dart
WContainer(
  className: 'w-[150] bg-red-500 dark:bg-red-700',
  child: WText('Width is 150px'), // Arbitrary value
)

WContainer(
  className: 'w-full bg-green-500 dark:bg-green-700',
  child: WText('Full width of parent'),
)
```

<a name="quick-reference"></a>
## Quick Reference

| Class | Description | Example |
|:------|:------------|:--------|
| `w-{value}` | Width in pixels (scaled by Pixel Factor) | `w-12` |
| `w-[{value}]` | Arbitrary width in pixels | `w-[150]` |
| `w-full` | 100% of the parent's width | `w-full` |
| `w-max` | Infinite width | `w-max` |
| `w-min` | Minimum possible width (0px) | `w-min` |
| `w-{x}/{y}` | Percentage of the parent's width | `w-1/2` |
| `w-[{value}vw]` | Percentage of the viewport width | `w-[50vw]` |
| `w-screen` | 100% of the viewport width | `w-screen` |

<a name="how-values-are-calculated"></a>
## How Values Are Calculated

### Predefined Sizes

Width is calculated using the size value multiplied by the Pixel Factor.

- Example: `w-12` → 12 × 4 (Pixel Factor) = **48px**.

### Special Keywords

| Value | Result |
|:------|:-------|
| `full` | `double.infinity` (100% of parent) |
| `max` | `double.infinity` |
| `min` | `0.0` |
| `screen` | Viewport width via `MediaQuery` |

### Fraction Syntax

Use `w-x/y` to express a fraction of the parent width.

- Example: `w-1/2` → 50% of the parent's width.

### Viewport Width

Append `vw` inside brackets for a percentage of the viewport.

- Example: `w-[50vw]` → 50% of the viewport width.

<a name="arbitrary-values"></a>
## Arbitrary Values

Use bracket notation to apply any exact pixel value directly, bypassing the Pixel Factor.

```dart
WContainer(
  className: 'w-[200] bg-gray-300 dark:bg-gray-600',
  child: WText('Width is exactly 200px.'),
)
```

<a name="responsive-design"></a>
## Responsive Design

Prefix any `w-*` class with a breakpoint to change width at specific screen sizes.

```dart
WContainer(
  className: 'w-full md:w-1/2 lg:w-1/3 bg-blue-500 dark:bg-blue-700',
  child: WText('Responsive width.'),
)
```

Available breakpoints: `sm`, `md`, `lg`, `xl`, `2xl`.

<a name="customizing-theme"></a>
## Customizing Theme

Predefined width values are scaled by the Pixel Factor. Adjust it to change the base unit.

```dart
WindTheme.setPixelFactor(3); // w-12 now produces 36px instead of 48px
```

See [Pixel Factor](../customization/pixel-factor.md) for full details.

<a name="related-documentation"></a>
## Related Documentation

- [Height](./height.md) — control widget height.
- [Max-Width and Min-Width](./max-width-min-width.md) — constrain the maximum and minimum width.
- [Padding](../spacing/padding.md) — apply inner spacing.
- [Margin](../spacing/margin.md) — apply outer spacing.
- [WContainer](../widgets/wcontainer.md) — the primary container widget.
