# Margin

Apply outer spacing to widgets using the `m-*` utilities. Values are multiplied by the Pixel Factor or used directly as arbitrary pixel values.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [How Values Are Calculated](#how-values-are-calculated)
- [Arbitrary Values](#arbitrary-values)
- [Responsive Design](#responsive-design)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<x-preview path="spacing/margin" size="md" source="example/lib/pages/spacing/margin.dart"></x-preview>

```dart
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

WContainer(
  className: 'm-4 bg-gray-200 dark:bg-gray-700',
  child: WText('This container has 16px margin.'),
)
```

<a name="basic-usage"></a>
## Basic Usage

Margin is applied by adding an `m-*` class to any `WContainer` or widget that accepts `className`. The value is scaled by the Pixel Factor (default 4), so `m-4` produces 16px of margin on all sides.

```dart
WContainer(
  className: 'mt-4 mr-[8] ml-2 mb-[12] bg-gray-200 dark:bg-gray-700',
  child: WText('Custom side-specific margin applied.'),
)
```

<a name="quick-reference"></a>
## Quick Reference

| Class | Description | Example |
|:------|:------------|:--------|
| `m-{value}` | Margin on all sides | `m-4`, `m-[6]` |
| `mx-{value}` | Horizontal margin (left + right) | `mx-4`, `mx-[6]` |
| `my-{value}` | Vertical margin (top + bottom) | `my-4`, `my-[6]` |
| `mt-{value}` | Top margin | `mt-4`, `mt-[6]` |
| `mb-{value}` | Bottom margin | `mb-4`, `mb-[6]` |
| `ml-{value}` | Left margin | `ml-4`, `ml-[6]` |
| `mr-{value}` | Right margin | `mr-4`, `mr-[6]` |

<a name="how-values-are-calculated"></a>
## How Values Are Calculated

### Predefined Sizes

Margin is calculated using the size value multiplied by the Pixel Factor.

- Example: `m-4` → 4 (size) × 4 (Pixel Factor) = **16px**.

### Arbitrary Values

Arbitrary sizes wrapped in brackets bypass the Pixel Factor and use the value directly in pixels.

- Example: `m-[6]` → **6px**.

```dart
WContainer(
  className: 'm-[10] bg-gray-200 dark:bg-gray-700',
  child: WText('This container has 10px margin.'),
)
```

<a name="arbitrary-values"></a>
## Arbitrary Values

Use bracket notation to apply any pixel value directly without scaling. The bracket form expects a unitless integer or decimal.

```dart
WContainer(
  className: 'mt-[24] mb-[8] mx-[16] bg-white dark:bg-gray-800',
  child: WText('Custom arbitrary margin on each axis.'),
)
```

<a name="responsive-design"></a>
## Responsive Design

Prefix any margin class with a breakpoint to apply it only at that screen size and above.

```dart
WContainer(
  className: 'm-2 md:m-4 lg:m-8 bg-gray-100 dark:bg-gray-800',
  child: WText('Responsive margin.'),
)
```

Available breakpoints: `sm`, `md`, `lg`, `xl`, `2xl`.

<a name="customizing-theme"></a>
## Customizing Theme

Margin values are scaled by the Pixel Factor. Adjust the Pixel Factor to change the base unit for all predefined margin values.

```dart
WindTheme.setPixelFactor(3); // m-4 now produces 12px instead of 16px
```

See [Pixel Factor](../customization/pixel-factor.md) for full details.

<a name="related-documentation"></a>
## Related Documentation

- [Padding](./padding.md) — apply inner spacing to widgets.
- [Pixel Factor](../customization/pixel-factor.md) — configure the base unit used by spacing utilities.
- [Width](../sizing/width.md) — control widget width.
- [Height](../sizing/height.md) — control widget height.
- [WContainer](../widgets/wcontainer.md) — the primary container widget that accepts margin classes.
