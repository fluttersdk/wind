# Justify Content

Control how children are distributed along the main axis of a flex container using the `justify-*` utilities.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Responsive Design](#responsive-design)
- [Related Documentation](#related-documentation)

<x-preview path="flex/justify_content" size="md" source="example/lib/pages/flex/justify_content.dart"></x-preview>

```dart
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

WFlexContainer(
  className: 'flex-row justify-between bg-gray-200',
  children: [
    WCard(className: 'bg-blue-500 w-16 h-16', child: WText('Card 1')),
    WCard(className: 'bg-green-500 w-16 h-16', child: WText('Card 2')),
    WCard(className: 'bg-red-500 w-16 h-16', child: WText('Card 3')),
  ],
);
```

<a name="basic-usage"></a>
## Basic Usage

The `justify-*` utilities map directly to Flutter's `MainAxisAlignment` values and control how children are spaced along the main axis of a flex container.

```dart
WFlexContainer(
  className: 'flex-row justify-center bg-gray-100',
  children: [
    WCard(className: 'bg-blue-500 w-16 h-16', child: WText('A')),
    WCard(className: 'bg-green-500 w-16 h-16', child: WText('B')),
  ],
);
```

<a name="quick-reference"></a>
## Quick Reference

| Class | MainAxisAlignment | Description |
|:------|:------------------|:------------|
| `justify-center` | `MainAxisAlignment.center` | Center children along the main axis |
| `justify-start` | `MainAxisAlignment.start` | Align children to the start of the main axis |
| `justify-end` | `MainAxisAlignment.end` | Align children to the end of the main axis |
| `justify-between` | `MainAxisAlignment.spaceBetween` | Place equal space between children |
| `justify-around` | `MainAxisAlignment.spaceAround` | Place equal space around each child |
| `justify-evenly` | `MainAxisAlignment.spaceEvenly` | Distribute children with equal spacing including edges |

<a name="responsive-design"></a>
## Responsive Design

Prefix any `justify-*` class with a breakpoint to change alignment at specific screen sizes.

```dart
WFlexContainer(
  className: 'flex-row justify-start md:justify-between lg:justify-evenly bg-gray-100',
  children: [
    WCard(className: 'bg-blue-500 w-16 h-16', child: WText('A')),
    WCard(className: 'bg-green-500 w-16 h-16', child: WText('B')),
    WCard(className: 'bg-red-500 w-16 h-16', child: WText('C')),
  ],
);
```

<a name="related-documentation"></a>
## Related Documentation

- [Align Items](./align-items.md) — control alignment along the cross axis.
- [Flex Direction](./flex-direction.md) — control whether the main axis runs horizontally or vertically.
- [Gap](./gap.md) — add fixed spacing between children.
- [WFlexContainer](../widgets/wflexcontainer.md) — the primary flex layout widget.
- [WFlex](../widgets/wflex.md) — alternative flex container.
