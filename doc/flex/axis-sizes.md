# Axis Sizes

Control how much space a flex container occupies along its main axis using `axis-max` and `axis-min`.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Responsive Design](#responsive-design)
- [Related Documentation](#related-documentation)

<x-preview path="flex/axis_sizes" size="md" source="example/lib/pages/flex/axis_sizes.dart"></x-preview>

```dart
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

WFlexContainer(
  className: 'axis-max flex-row bg-gray-400',
  children: [
    WCard(className: 'bg-blue-500 w-20 h-20', child: WText('Card 1')),
    WCard(className: 'bg-green-500 w-20 h-20', child: WText('Card 2')),
  ],
);
```

<a name="basic-usage"></a>
## Basic Usage

`axis-max` makes the flex container stretch to fill all available space along the main axis. `axis-min` shrinks the container to fit its children exactly.

```dart
// Only occupies the space its children need
WFlexContainer(
  className: 'axis-min flex-row bg-gray-400',
  children: [
    WCard(className: 'bg-blue-500 w-20 h-20', child: WText('Card 1')),
    WCard(className: 'bg-green-500 w-20 h-20', child: WText('Card 2')),
  ],
);
```

<a name="quick-reference"></a>
## Quick Reference

| Class | MainAxisSize | Description |
|:------|:-------------|:------------|
| `axis-max` | `MainAxisSize.max` | Container takes up all available space along the main axis |
| `axis-min` | `MainAxisSize.min` | Container takes up only the space required by its children |

<a name="responsive-design"></a>
## Responsive Design

Prefix axis-size classes with a breakpoint to change behavior at specific screen widths.

```dart
WFlexContainer(
  className: 'axis-min md:axis-max flex-row bg-gray-100',
  children: [
    WCard(className: 'bg-blue-500 w-20 h-20', child: WText('A')),
    WCard(className: 'bg-green-500 w-20 h-20', child: WText('B')),
  ],
);
```

<a name="related-documentation"></a>
## Related Documentation

- [Flex Direction](./flex-direction.md) — control whether the main axis runs horizontally or vertically.
- [Flex Fit](./flex-fit.md) — control how individual children are sized within the flex container.
- [WFlexContainer](../widgets/wflexcontainer.md) — the primary flex layout widget.
