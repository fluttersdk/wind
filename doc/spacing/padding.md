# Padding

Apply inner spacing to widgets using the `p-*` utilities. Values are multiplied by the Pixel Factor or used directly as arbitrary pixel values.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [How Values Are Calculated](#how-values-are-calculated)
- [Arbitrary Values](#arbitrary-values)
- [Responsive Design](#responsive-design)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<x-preview path="spacing/padding" size="md" source="example/lib/pages/spacing/padding.dart"></x-preview>

```dart
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

WContainer(
  className: 'p-4 bg-gray-200 dark:bg-gray-700',
  child: WText('This container has 16px padding.'),
)
```

<a name="basic-usage"></a>
## Basic Usage

Padding is applied by adding a `p-*` class to any `WContainer` or widget that accepts `className`. The value is scaled by the Pixel Factor (default 4), so `p-4` produces 16px of padding on all sides.

```dart
WContainer(
  className: 'pt-4 pr-[8] pl-2 pb-[12] bg-gray-200 dark:bg-gray-700',
  child: WText('Custom side-specific padding applied.'),
)
```

**Note:** As of version 0.0.3, if the resolved padding is 0 on all sides, the `PaddingParser` will not wrap the widget with a `Padding` widget at all. This reduces unnecessary widget nesting.

<a name="quick-reference"></a>
## Quick Reference

| Class | Description | Example |
|:------|:------------|:--------|
| `p-{value}` | Padding on all sides | `p-4`, `p-[6]` |
| `px-{value}` | Horizontal padding (left + right) | `px-4`, `px-[6]` |
| `py-{value}` | Vertical padding (top + bottom) | `py-4`, `py-[6]` |
| `pt-{value}` | Top padding | `pt-4`, `pt-[6]` |
| `pb-{value}` | Bottom padding | `pb-4`, `pb-[6]` |
| `pl-{value}` | Left padding | `pl-4`, `pl-[6]` |
| `pr-{value}` | Right padding | `pr-4`, `pr-[6]` |

<a name="how-values-are-calculated"></a>
## How Values Are Calculated

### Predefined Sizes

Padding is calculated using the size value multiplied by the Pixel Factor.

- Example: `p-4` → 4 (size) × 4 (Pixel Factor) = **16px**.

### Arbitrary Values

Arbitrary sizes wrapped in brackets bypass the Pixel Factor and use the value directly in pixels.

- Example: `p-[6]` → **6px**.

```dart
WContainer(
  className: 'p-[10] bg-gray-200 dark:bg-gray-700',
  child: WText('This container has 10px padding.'),
)
```

<a name="arbitrary-values"></a>
## Arbitrary Values

Use bracket notation to apply any pixel value directly without scaling. The bracket form expects a unitless integer or decimal.

```dart
WContainer(
  className: 'pt-[24] pb-[8] px-[16] bg-white dark:bg-gray-800',
  child: WText('Custom arbitrary padding on each axis.'),
)
```

<a name="responsive-design"></a>
## Responsive Design

Prefix any padding class with a breakpoint to apply it only at that screen size and above.

```dart
WContainer(
  className: 'p-2 md:p-4 lg:p-8 bg-gray-100 dark:bg-gray-800',
  child: WText('Responsive padding.'),
)
```

Available breakpoints: `sm`, `md`, `lg`, `xl`, `2xl`.

<a name="customizing-theme"></a>
## Customizing Theme

Padding values are scaled by the Pixel Factor. Adjust the Pixel Factor to change the base unit for all predefined padding values.

```dart
WindTheme.setPixelFactor(3); // p-4 now produces 12px instead of 16px
```

See [Pixel Factor](../customization/pixel-factor.md) for full details.

<a name="related-documentation"></a>
## Related Documentation

- [Margin](./margin.md) — apply outer spacing to widgets.
- [Pixel Factor](../customization/pixel-factor.md) — configure the base unit used by spacing utilities.
- [Width](../sizing/width.md) — control widget width.
- [Height](../sizing/height.md) — control widget height.
- [WContainer](../widgets/wcontainer.md) — the primary container widget that accepts padding classes.
