# Gap

Add consistent spacing between flex children using `gap-N` (scaled by the pixel factor) or `gap-[N]` (fixed pixels).

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Arbitrary Values](#arbitrary-values)
- [Responsive Design](#responsive-design)
- [Related Documentation](#related-documentation)

<x-preview path="flex/gap" size="md" source="example/lib/pages/flex/gap.dart"></x-preview>

```dart
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

WFlexContainer(
  className: 'flex-row gap-4 bg-gray-100',
  children: [
    WCard(className: 'bg-blue-500 w-16 h-16', child: WText('Card 1')),
    WCard(className: 'bg-green-500 w-16 h-16', child: WText('Card 2')),
    WCard(className: 'bg-red-500 w-16 h-16', child: WText('Card 3')),
  ],
);
```

<a name="basic-usage"></a>
## Basic Usage

`gap-N` multiplies `N` by the current pixel factor (default `4`) to produce the gap in logical pixels. For example, `gap-4` produces `4 × 4 = 16 px` at the default factor.

The gap is inserted between children along the flex direction — `flex-row` inserts horizontal gaps, `flex-col` inserts vertical gaps.

```dart
WFlexContainer(
  className: 'flex-col gap-2 bg-gray-100',
  children: [
    WCard(className: 'bg-blue-500 w-full h-16', child: WText('Row 1')),
    WCard(className: 'bg-green-500 w-full h-16', child: WText('Row 2')),
    WCard(className: 'bg-red-500 w-full h-16', child: WText('Row 3')),
  ],
);
```

<a name="quick-reference"></a>
## Quick Reference

| Syntax | Gap (default pixel factor 4) | Description |
|:-------|:-----------------------------|:------------|
| `gap-1` | `4 px` | 1 unit of spacing |
| `gap-2` | `8 px` | 2 units of spacing |
| `gap-4` | `16 px` | 4 units of spacing |
| `gap-8` | `32 px` | 8 units of spacing |

Any integer value is accepted. The actual pixel size is `N × pixelFactor`.

<a name="arbitrary-values"></a>
## Arbitrary Values

Use `gap-[N]` to set a fixed pixel gap that is not scaled by the pixel factor.

<x-preview path="flex/gap_dynamic" size="md" source="example/lib/pages/flex/gap_dynamic.dart"></x-preview>

```dart
WFlexContainer(
  className: 'gap-[8] flex-row bg-gray-200',
  children: [
    WCard(className: 'bg-blue-500 w-16 h-16', child: WText('Card 1')),
    WCard(className: 'bg-green-500 w-16 h-16', child: WText('Card 2')),
    WCard(className: 'bg-red-500 w-16 h-16', child: WText('Card 3')),
  ],
);
```

The value inside `[...]` is treated as a literal pixel count (`8` → `8 px`).

<a name="responsive-design"></a>
## Responsive Design

Prefix `gap-N` or `gap-[N]` with a breakpoint to apply different spacing at specific screen sizes.

```dart
WFlexContainer(
  className: 'flex-row gap-2 md:gap-4 lg:gap-8 bg-gray-100',
  children: [
    WCard(className: 'bg-blue-500 w-16 h-16', child: WText('A')),
    WCard(className: 'bg-green-500 w-16 h-16', child: WText('B')),
  ],
);
```

<a name="related-documentation"></a>
## Related Documentation

- [Flex Direction](./flex-direction.md) — determines the axis along which the gap is applied.
- [Align Items](./align-items.md) — control cross-axis alignment.
- [Justify Content](./justify-content.md) — control main-axis spacing with alignment utilities.
- [WFlexContainer](../widgets/wflexcontainer.md) — the primary flex layout widget.
