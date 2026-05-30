# Flex Direction

Set the layout direction of a flex container — horizontal row or vertical column — using `flex-row` and `flex-col`.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Responsive Design](#responsive-design)
- [Related Documentation](#related-documentation)

<x-preview path="flex/flex_direction" size="md" source="example/lib/pages/flex/flex_direction.dart"></x-preview>

```dart
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

WFlexContainer(
  className: 'flex-row w-full h-40 bg-gray-100',
  children: [
    WCard(className: 'bg-blue-500 w-1/3 h-full', child: WText('Card 1')),
    WCard(className: 'bg-green-500 w-1/3 h-full', child: WText('Card 2')),
    WCard(className: 'bg-red-500 w-1/3 h-full', child: WText('Card 3')),
  ],
);
```

<a name="basic-usage"></a>
## Basic Usage

Use `flex-row` to lay out children horizontally and `flex-col` to lay them out vertically.

```dart
// Vertical stack
WFlexContainer(
  className: 'flex-col bg-gray-100',
  children: [
    WCard(className: 'bg-blue-500 w-full h-16', child: WText('Top')),
    WCard(className: 'bg-green-500 w-full h-16', child: WText('Middle')),
    WCard(className: 'bg-red-500 w-full h-16', child: WText('Bottom')),
  ],
);
```

<a name="quick-reference"></a>
## Quick Reference

| Class | Axis | Description |
|:------|:-----|:------------|
| `flex-row` | `Axis.horizontal` | Lay out children left-to-right |
| `flex-col` | `Axis.vertical` | Lay out children top-to-bottom |

<a name="responsive-design"></a>
## Responsive Design

Switch direction at different breakpoints by prefixing the class.

```dart
WFlexContainer(
  className: 'flex-col md:flex-row bg-gray-100',
  children: [
    WCard(className: 'bg-blue-500 h-16', child: WText('A')),
    WCard(className: 'bg-green-500 h-16', child: WText('B')),
  ],
);
```

<a name="related-documentation"></a>
## Related Documentation

- [Justify Content](./justify-content.md) — control main-axis alignment.
- [Align Items](./align-items.md) — control cross-axis alignment.
- [Axis Sizes](./axis-sizes.md) — control how much space the container occupies along its main axis.
- [WFlexContainer](../widgets/wflexcontainer.md) — the primary flex layout widget.
- [WFlex](../widgets/wflex.md) — alternative flex container.
