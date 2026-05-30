# Height

Control the height of widgets using the `h-*` utilities. Supports pixel-based, percentage-based, and viewport-relative values.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [How Values Are Calculated](#how-values-are-calculated)
- [Arbitrary Values](#arbitrary-values)
- [Responsive Design](#responsive-design)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<x-preview path="sizing/height" size="md" source="example/lib/pages/sizing/height.dart"></x-preview>

```dart
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

WContainer(
  className: 'h-12 bg-blue-500 dark:bg-blue-700',
  child: WText('Height is 48px'), // 12 * 4 (Pixel Factor)
)
```

<a name="basic-usage"></a>
## Basic Usage

Set the height of any `WContainer` by adding an `h-*` class. The predefined value is multiplied by the Pixel Factor (default 4), so `h-12` produces 48px. Use `h-full` for 100% of the parent's height or `h-[value]` for an exact pixel value.

```dart
WContainer(
  className: 'h-[150] bg-red-500 dark:bg-red-700',
  child: WText('Height is 150px'), // Arbitrary value
)

WContainer(
  className: 'h-full bg-green-500 dark:bg-green-700',
  child: WText('Full height of parent'),
)
```

<a name="quick-reference"></a>
## Quick Reference

| Class | Description | Example |
|:------|:------------|:--------|
| `h-{value}` | Height in pixels (scaled by Pixel Factor) | `h-12` |
| `h-[{value}]` | Arbitrary height in pixels | `h-[150]` |
| `h-full` | 100% of the parent's height | `h-full` |
| `h-max` | Infinite height | `h-max` |
| `h-min` | Minimum possible height (0px) | `h-min` |
| `h-{x}/{y}` | Percentage of the parent's height | `h-1/2` |
| `h-[{value}vh]` | Percentage of the viewport height | `h-[50vh]` |
| `h-screen` | 100% of the viewport height | `h-screen` |

<a name="how-values-are-calculated"></a>
## How Values Are Calculated

### Predefined Sizes

Height is calculated using the size value multiplied by the Pixel Factor.

- Example: `h-12` → 12 × 4 (Pixel Factor) = **48px**.

### Special Keywords

| Value | Result |
|:------|:-------|
| `full` | `double.infinity` (100% of parent) |
| `max` | `double.infinity` |
| `min` | `0.0` |
| `screen` | Viewport height via `MediaQuery` |

### Fraction Syntax

Use `h-x/y` to express a fraction of the parent height.

- Example: `h-1/2` → 50% of the parent's height.

### Viewport Height

Append `vh` inside brackets for a percentage of the viewport.

- Example: `h-[50vh]` → 50% of the viewport height.

<a name="arbitrary-values"></a>
## Arbitrary Values

Use bracket notation to apply any exact pixel value directly, bypassing the Pixel Factor.

```dart
WContainer(
  className: 'h-[200] bg-gray-300 dark:bg-gray-600',
  child: WText('Height is exactly 200px.'),
)
```

<a name="responsive-design"></a>
## Responsive Design

Prefix any `h-*` class with a breakpoint to change height at specific screen sizes.

```dart
WContainer(
  className: 'h-32 md:h-48 lg:h-64 bg-blue-500 dark:bg-blue-700',
  child: WText('Responsive height.'),
)
```

Available breakpoints: `sm`, `md`, `lg`, `xl`, `2xl`.

<a name="customizing-theme"></a>
## Customizing Theme

Predefined height values are scaled by the Pixel Factor. Adjust it to change the base unit.

```dart
WindTheme.setPixelFactor(3); // h-12 now produces 36px instead of 48px
```

See [Pixel Factor](../customization/pixel-factor.md) for full details.

<a name="related-documentation"></a>
## Related Documentation

- [Width](./width.md) — control widget width.
- [Max-Height and Min-Height](./max-height-min-height.md) — constrain the maximum and minimum height.
- [Padding](../spacing/padding.md) — apply inner spacing.
- [Margin](../spacing/margin.md) — apply outer spacing.
- [WContainer](../widgets/wcontainer.md) — the primary container widget.
